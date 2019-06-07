/*
    Date        : 12-09-2016
	Project     : Lease Management System
    Description : Centre default rates batch downloader

    Change History
    --------------
*/
global class ScheduleRates implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful {
	global String token;
	global Integer page;
	global Integer totalPages;

	global ScheduleRates(String token, Integer page, Integer totalPages) {
		this.token = token;
		this.page = page;
		this.totalPages = totalPages;
	}

	global ScheduleRates(Integer page) {
		this.page = page;
	}

	global ScheduleRates() {
		this.page = 1;
	}

    global String getToken() {
		HttpRequest request = new HttpRequest();
		request.setMethod('POST');
		request.setEndpoint('callout:Vicinity_Apigee_Prod');
		request.setHeader('Content-Length', '0');
		request.setTimeout(100000);

		Http http = new Http();
		HttpResponse response = http.send(request);
		Map<String, Object> jsonResponse = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
		return String.valueOf(jsonResponse.get('access_token'));
	}

	global Iterable<sObject> start(Database.BatchableContext bc) {

		if (String.isEmpty(this.token)) {
			this.token = this.getToken();
		}

		return new List<Centre__c>{new Centre__c()};
	}

	global void execute(Database.BatchableContext bc, List<Centre__c> obj) {
		System.debug('Executing Rates Schedule - Page#'+this.page);
		try {
			this.download(this.page);
		} catch(Exception ex) {
			ErrorLogHandler.log('Rates Schedule Exception - Page#'+ this.page,ex);
		}
	}

	global void finish(Database.BatchableContext bc) {
		if (this.page < this.totalPages) {
			Database.executeBatch(new ScheduleRates(this.token, this.page + 1, this.totalPages), 1000);
		} else  {
			System.scheduleBatch(new ScheduleBusinessUnit(), 'Business Units Schedule', 0);
		}
	}

	global void download(Integer page) {
		HttpRequest request = new HttpRequest();
		request.setMethod('GET');
		request.setHeader('Authorization', 'Bearer ' + this.token);
		request.setHeader('Cache-Control', 'No-Cache');
		request.setEndpoint(Global_Settings__c.getInstance().API_URL_2__c+'/default-rates?page='+ page);
		request.setTimeout(30000);
		Http http = new Http();
		HttpResponse response = http.send(request);
		if (hasRedirect(response)) {
			response = handleRedirect(response);
		}
		save(response.getBody());
	}

	public Boolean hasRedirect(HttpResponse res) {
		System.debug('HTTP status code: ' + res.getStatusCode());
		if (res.getStatusCode() >= 300 && res.getStatusCode() <= 307 && res.getStatusCode() != 306) {
			String loc = res.getHeader('Location');
			if (loc != null) {
				System.debug('has redirect: ' + loc);
				return true;
			}
		}
		return false;
	}

	public HttpResponse handleRedirect(HttpResponse res) {
      	HttpRequest req = new HttpRequest();
      	req.setMethod('GET');
      	req.setEndpoint(res.getHeader('Location'));

		Http http = new Http();
		HttpResponse response = http.send(req);

		return response;
	}

	global void save(String jsonResponse) {

		Map<String,Centre__c> mapjsonData = new Map<String,Centre__c>();
		List<Centre__c> centresToUpdate = new List<Centre__c>();

		JSONParser parser = JSON.createParser(jsonResponse);
		while(parser.nextToken() != null) {
			if (this.totalPages == null && parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'total_pages') {
       	 		parser.nextToken();
        		this.totalPages = Integer.valueOf(parser.getText());
    		}
			if(parser.getCurrentToken() == JSONToken.START_ARRAY) {
				while(parser.nextToken() != null) {
					if(parser.getCurrentToken() == JSONToken.START_OBJECT) {

						ratesWrapper rt = (ratesWrapper)parser.readValueAs(ratesWrapper.class);

						Centre__c objCentre = new Centre__c();

						objCentre.Default_Hoardings_Rate__c = Decimal.valueOf(rt.hoardings_rate);
						objCentre.Default_Storage_Rate__c =  Decimal.valueOf(rt.storage_rate);
						objCentre.Design_Review_Fees__c = Decimal.valueOf(rt.design_review_fee);
						objCentre.Last_Updated_By_Job__c = system.now();

						mapjsonData.put(rt.centre_key,objCentre);
					}
				}
			}
		}

		for(Centre__c c :[SELECT Id, Default_Hoardings_Rate__c, Default_Storage_Rate__c, Design_Review_Fees__c,Centre_Key__c
																					FROM Centre__c
																					WHERE Centre_Key__c in :mapjsonData.keyset()]){

			if(mapjsonData.containsKey(c.Centre_Key__c)){
				mapjsonData.get(c.Centre_Key__c).Id = c.Id;
				centresToUpdate.add(mapjsonData.get(c.Centre_Key__c));
			}
		}

		try{
			update centresToUpdate;
			ErrorLogHandler.log('Default Rates Schedule',String.valueOf(centresToUpdate.size()), String.valueOf(totalPages), String.valueOf(page), 'Schedule');
			//Database.update(centresToUpdate, false);
		}catch(exception e) {
			ErrorLogHandler.log('Rates Schedule exception #1 - Exception', e);
			ErrorLogHandler.log('Rates Schedule exception #2 - Exception', jsonResponse);
		}
	}

	// Centre Wrapper
	global class ratesWrapper {
	    public String design_review_fee;
		public String hoardings_rate;
		public String storage_rate;
        public String centre_key;
	}
}