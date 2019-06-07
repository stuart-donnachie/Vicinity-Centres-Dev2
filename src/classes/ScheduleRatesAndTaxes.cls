global class ScheduleRatesAndTaxes implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful {
	global String token;
	global Integer page;
	global Integer totalPages;
	global Map<String,Id> mapBU;
	global Map<String,Id> mapBuilding;
	global Map<String,Id> mapUnit;

	global ScheduleRatesAndTaxes(String token, Integer page, Integer totalPages, Map<String,Id> mapBU, Map<String,Id> mapBuilding, Map<String,Id> mapUnit) {
		this.token = token;
		this.page = page;
		this.totalPages = totalPages;
		this.mapBU = mapBU;
		this.mapBuilding = mapBuilding;
		this.mapUnit = mapUnit;
	}

	global ScheduleRatesAndTaxes(Integer page) {
		this.page = page;
		this.mapBU = new Map<String,Id>();
		this.mapBuilding = new Map<String,Id>();
		this.mapUnit = new Map<String,Id>();
	}

	global ScheduleRatesAndTaxes() {
		this.page = 1;
		this.mapBU = new Map<String,Id>();
		this.mapBuilding = new Map<String,Id>();
		this.mapUnit = new Map<String,Id>();
	}

    global String getToken() {
    	System.debug('Getting API Token');
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
      	req.setTimeout(100000);

		Http http = new Http();
		HttpResponse response = http.send(req);

		return response;
	}

	global Iterable<sObject> start(Database.BatchableContext bc) {
		System.debug('Start Executing Rates And Taxes Schedule');

		//BU
        if (this.mapBU.size() == 0) {
			for(Business_Unit__c bu : [SELECT Id,Business_Unit_Key__c FROM Business_Unit__c]){
				this.mapBU.put(bu.Business_Unit_Key__c,bu.Id);
			}
        }

        // Buildings
		if (this.mapBuilding.size() == 0) {
			for(Building__c b : [SELECT Id,Building_Key__c FROM Building__c]){
				this.mapBuilding.put(b.Building_Key__c,b.Id);
			}
		}

		// Units
		if (this.mapUnit.size() == 0) {
			for(Unit__c u : [SELECT Id,Unit_Key__c FROM Unit__c]){
				this.mapUnit.put(u.Unit_Key__c,u.Id);
			}
		}


		if (String.isEmpty(this.token)) {
			this.token = this.getToken();
		}

		return new List<Rates_and_Taxes__c>{new Rates_and_Taxes__c()};
	}

	global void execute(Database.BatchableContext bc, List<Rates_and_Taxes__c> obj) {
		System.debug('Executing Rates And Taxes Schedule - Page#'+this.page);
		try {
			this.download(this.page);
		} catch(Exception ex) {
			ErrorLogHandler.log('Rates And Taxes Schedule Exception - Page#'+ this.page,ex);
		}
	}

	global void finish(Database.BatchableContext bc) {
		System.debug('Finish Executing Rates And Taxes Schedule - Page#'+this.page);
		if (this.page < this.totalPages) {
			Database.executeBatch(new ScheduleRatesAndTaxes(this.token, this.page + 1, this.totalPages, this.mapBU, this.mapBuilding, this.mapUnit), 1000);
		}else  {
			//ErrorLogHandler.log('SCHEDULE JOB FINISHED');
		}
	}

	global void download(Integer page) {
		HttpRequest request = new HttpRequest();
		request.setMethod('GET');
		request.setHeader('Authorization', 'Bearer ' + this.token);
		request.setHeader('Cache-Control', 'No-Cache');
		request.setEndpoint(Global_Settings__c.getInstance().API_URL_2__c+'/unit-rates-and-taxes-outgoings?page='+ page);
		request.setTimeout(30000);
		Http http = new Http();
		HttpResponse response = http.send(request);
		if (hasRedirect(response)) {
				response = handleRedirect(response);
		}
		save(response.getBody());
	}

	global void save(String jsonResponse) {

		Map<String,Rates_and_Taxes__c> mapjsonData = new Map<String,Rates_and_Taxes__c>();
		Set<String> buildingKeySet = new Set<String>();

		JSONParser parser = JSON.createParser(jsonResponse);
		while(parser.nextToken() != null) {
			if (this.totalPages == null && parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'total_pages') {
       	 		parser.nextToken();
        		this.totalPages = Integer.valueOf(parser.getText());
    		}
			if(parser.getCurrentToken() == JSONToken.START_ARRAY) {
				while(parser.nextToken() != null) {
					if(parser.getCurrentToken() == JSONToken.START_OBJECT) {

						ratesAndTaxesWrapper rt = (ratesAndTaxesWrapper)parser.readValueAs(ratesAndTaxesWrapper.class);

						Rates_and_Taxes__c objRt = new Rates_and_Taxes__c();

						objRt.Amenity_Code__c = rt.amenity_id;
						objRt.Log_Class__c = rt.log_class;
						objRt.Log_Level__c = rt.log_level;
						objRt.Building__c = mapBuilding.containsKey(rt.building_key) ? mapBuilding.get(rt.building_key) : null;
						objRt.Building_Code__c = rt.building_code;
						objRt.Building_Key__c = rt.building_key;
						objRt.Business_Unit__c = mapBU.containsKey(rt.business_unit_key) ? mapBU.get(rt.business_unit_key) : null;
						objRt.Business_Unit_Code__c = rt.business_unit_code;
						objRt.Business_Unit_Key__c = rt.business_unit_key;
						objRt.Unit__c = mapUnit.containsKey(rt.unit_key) ? mapUnit.get(rt.unit_key) : null;
						objRt.Unit_Name__c = rt.unit;
						objRt.Last_Updated_By_Job__c = System.now();
						objRt.Begin_Date__c = String.isNotEmpty(rt.begin_date) ? Date.valueOf(rt.begin_date) : null;
						objRt.Expiry_Date__c = String.isNotEmpty(rt.expiry_date) ? Date.valueOf(rt.expiry_date) : null;
						objRt.Rate__c = String.isNotEmpty(rt.rate) ? Decimal.valueOf(rt.rate) : null;
						if(String.isNotEmpty(objRt.Amenity_Code__c) && objRt.Begin_Date__c !=null){
					 		objRt.Unique_Key__c = objRt.Amenity_Code__c + '-'
					 							+ objRt.Log_Class__c + '-'
					 							+ objRt.Log_Level__c +'-'
					 							+ objRt.Begin_Date__c.day() + objRt.Begin_Date__c.month() + objRt.Begin_Date__c.year() + '-'
					 							+ objRt.Building_Code__c + '-'
					 		 					+ objRt.Unit_Name__c;

					 		mapjsonData.put(objRt.Unique_Key__c,objRt);
						}
					}
				}
			}
		}

		for(Rates_and_Taxes__c c :[SELECT Id, Name, Unique_Key__c
									FROM Rates_and_Taxes__c WHERE Unique_Key__c IN :mapjsonData.keySet()]){

			if(mapjsonData.containsKey(c.Unique_Key__c)){
				mapjsonData.get(c.Unique_Key__c).Id = c.Id;
			}
		}

		try{
			//upsert mapjsonData.values();
			Database.upsert(mapjsonData.values(), false);
			ErrorLogHandler.log('Rates and Taxes Schedule',String.valueOf(mapjsonData.values().size()), String.valueOf(totalPages), String.valueOf(page), 'Schedule');
			if(mapjsonData.values().size() == 0 && !Test.isRunningTest()){
				ErrorLogHandler.log('Error in Rates and Taxes Schedule Schedule #'+page, jsonResponse.left(131000));
				token = null;
				page -= 1;
			}
		}catch(exception e) {
			ErrorLogHandler.log('Rates And Taxes Schedule exception #1 - Exception', e);
			//ErrorLogHandler.log('Rates And Taxes Schedule exception #2 - Exception', jsonResponse);
		}
	}

	global class ratesAndTaxesWrapper {
		public String building_code;
		public String log_level;
		public String amenity_id;
		public String building_key;
		public String log_class;
		public String business_unit_key;
		public String rate;
		public String expiry_date;
		public String unit_key;
		public String begin_date;
		public String business_unit_code;
		public String unit;

	}
}