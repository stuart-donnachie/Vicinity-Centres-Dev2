global class ScheduleBusinessUnit implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful {
	global String token;
	global Integer page;
	global Integer totalPages;
	global String query;

	global ScheduleBusinessUnit(String token, Integer page, Integer totalPages) {
		this.token = token;
		this.page = page;
		this.totalPages = totalPages;
	}

	global ScheduleBusinessUnit(Integer page) {
		this.page = page;
	}

	global ScheduleBusinessUnit() {
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

        return new List<Business_Unit__c>{new Business_Unit__c()};
	}

	global void execute(Database.BatchableContext bc, List<Business_Unit__c> obj) {
		System.debug('Executing Business Unit Schedule - Page#'+this.page);
		try {
			this.download(this.page);
		} catch(Exception ex) {
			ErrorLogHandler.log('Business Unit Schedule Exception - Page#'+ this.page,ex);
		}
	}

	global void finish(Database.BatchableContext bc) {
		if (this.page < this.totalPages) {
			Database.executeBatch(new ScheduleBusinessUnit(this.token, this.page + 1, this.totalPages), 1000);
		} else  {
			System.scheduleBatch(new ScheduleBuilding(), 'Building Schedule', 0);
		}
	}

	global void download(Integer page) {
		HttpRequest request = new HttpRequest();
		request.setMethod('GET');
		request.setHeader('Authorization', 'Bearer ' + this.token);
		request.setHeader('Cache-Control', 'No-Cache');
		request.setEndpoint(Global_Settings__c.getInstance().API_URL_2__c+'/business-units?page='+ page);
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

	public String keyFix(String key){
		return (String.valueOf(Decimal.valueOf(key).setscale(0)));
	}

	global void save(String jsonResponse) {

		Map<String,Business_Unit__c> busToUpdate = new Map<String,Business_Unit__c>();

		JSONParser parser = JSON.createParser(jsonResponse);

		while(parser.nextToken() != null) {
			if (this.totalPages == null && parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'total_pages') {
       	 		parser.nextToken();
        		this.totalPages = Integer.valueOf(parser.getText());
    		}
			if(parser.getCurrentToken() == JSONToken.START_ARRAY) {
				while(parser.nextToken() != null) {
					if(parser.getCurrentToken() == JSONToken.START_OBJECT) {

						buWrapper bu = (buWrapper)parser.readValueAs(buWrapper.class);

						Business_Unit__c objBU = new Business_Unit__c();

						objBU.Business_Unit_Code__c = bu.business_unit_code;
						objBU.Business_Unit_Key__c = bu.business_unit_key;
						//objBU.Business_Unit_Key__c = keyFix(objBU.Business_Unit_Key__c); // KEY FIX
						objBU.Name = bu.business_unit_description;
						objBU.Last_Updated_By_Job__c = system.now();
						objBU.Last_Updated_By_JDE__c = (bu.last_updated !=null) ? Date.valueOf(bu.last_updated) : null;

						busToUpdate.put(objBU.Business_Unit_Key__c,objBU);
					}
				}
			}
		}

		for(Business_Unit__c bu :[SELECT Name, Id, Business_Unit_Key__c
						FROM Business_Unit__c
						WHERE Business_Unit_Key__c in :busToUpdate.keyset()]){

			if(busToUpdate.containsKey(bu.Business_Unit_Key__c)){
				busToUpdate.get(bu.Business_Unit_Key__c).Id = bu.Id;
			}
		}

		try{
			upsert busToUpdate.values();
			ErrorLogHandler.log('Business Unit Schedule',String.valueOf(busToUpdate.values().size()), String.valueOf(totalPages), String.valueOf(page), 'Schedule');
			if(busToUpdate.values().size() == 0){
				ErrorLogHandler.log('Error in Business Unit Schedule #'+page, jsonResponse.left(131000));
				token = null;
				page -= 1;
			}
			//Database.upsert(busToUpdate.values(), false);
		}catch(exception e) {
			ErrorLogHandler.log('BU Schedule exception #1 - Exception', e);
		}
	}

	// BU Wrapper
	global class buWrapper {
	    public String business_unit_description;
		public String business_unit_code;
		public String last_updated;
        public String business_unit_key;
	}
}