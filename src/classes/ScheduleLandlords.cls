global class ScheduleLandlords implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful {
	global String token;
	global Integer page;
	global Integer totalPages;
	global String query;
	global Map<String,Id> mapBuilding;

	global ScheduleLandlords(String token, Integer page, Integer totalPages,  Map<String,Id> mapBuilding) {
		this.token = token;
		this.page = page;
		this.totalPages = totalPages;
		this.mapBuilding = mapBuilding;
	}

	global ScheduleLandlords(Integer page) {
		this.page = page;
		this.mapBuilding = new Map<String,Id>();
	}

	global ScheduleLandlords() {
		this.page = 1;
		this.mapBuilding = new Map<String,Id>();
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
		if (this.mapBuilding.size() == 0) {
			for(Building__c b : [SELECT Id,Building_Key__c FROM Building__c]){
				this.mapBuilding.put(b.Building_Key__c,b.Id);
			}
		}

		if (String.isEmpty(this.token)) {
			this.token = this.getToken();
		}

        return new List<Landlord__c>{new Landlord__c()};
	}

	global void execute(Database.BatchableContext bc, List<Landlord__c> obj) {
		System.debug('Executing Landlord Schedule - Page#'+this.page);
		try {
			this.download(this.page);
		} catch(Exception ex) {
			ErrorLogHandler.log('Landlord Schedule Exception - Page#'+ this.page,ex);
		}
	}

	global void finish(Database.BatchableContext bc) {
		if (this.page < this.totalPages) {
			Database.executeBatch(new ScheduleLandlords(this.token, this.page + 1, this.totalPages, this.mapBuilding), 1000);
		} else  {
			System.scheduleBatch(new ScheduleContact(), 'Contact Schedule', 0);
		}
	}

	global void download(Integer page) {
		HttpRequest request = new HttpRequest();
		request.setMethod('GET');
		request.setHeader('Authorization', 'Bearer ' + this.token);
		request.setHeader('Cache-Control', 'No-Cache');
		request.setEndpoint(Global_Settings__c.getInstance().API_URL_2__c+'/landlords?page='+ page);
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

		Map<String,Landlord__c> landlordsToUpdate = new Map<String,Landlord__c>();

		JSONParser parser = JSON.createParser(jsonResponse);

		while(parser.nextToken() != null) {
			if (this.totalPages == null && parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'total_pages') {
       	 		parser.nextToken();
        		this.totalPages = Integer.valueOf(parser.getText());
    		}
			if(parser.getCurrentToken() == JSONToken.START_ARRAY) {
				while(parser.nextToken() != null) {
					if(parser.getCurrentToken() == JSONToken.START_OBJECT) {

						landlordWrapper ld = (landlordWrapper)parser.readValueAs(landlordWrapper.class);

						Landlord__c objLandlord = new Landlord__c();

						objLandlord.Building_Code__c = ld.building_code;
						objLandlord.Building_Key__c = ld.building_key;
						objLandlord.Responsible_Entity__c = ld.responsible_entity;
						objLandlord.Landlord_Description__c = ld.landlord_description;
						objLandlord.Name = ld.lessor_text_number;
						objLandlord.Building__c = mapBuilding.containsKey(ld.building_key) ? Id.valueOf(mapBuilding.get(ld.building_key)) : null;
						objLandlord.Last_Updated_By_JDE__c = Date.valueOf(ld.last_updated);
						objLandlord.Last_Updated_By_Job__c = System.now();

						objLandlord.Unique_Key__c = objLandlord.Building_Code__c + '-' + objLandlord.Name;

						landlordsToUpdate.put(objLandlord.Unique_Key__c,objLandlord);
					}
				}
			}
		}

		for(Landlord__c ld :[SELECT Name, Id, Building_Key__c, Unique_Key__c
						FROM Landlord__c
						WHERE Unique_Key__c in :landlordsToUpdate.keyset()]){

			if(landlordsToUpdate.containsKey(ld.Unique_Key__c)){
				landlordsToUpdate.get(ld.Unique_Key__c).Id = ld.Id;
			}
		}

		try{
			upsert landlordsToUpdate.values();
			ErrorLogHandler.log('Landlord Schedule',String.valueOf(landlordsToUpdate.values().size()), String.valueOf(totalPages), String.valueOf(page), 'Schedule');
			if(landlordsToUpdate.values().size() == 0 && !Test.isRunningTest()){
				ErrorLogHandler.log('Error in Landlord Schedule Schedule #'+page, jsonResponse.left(131000));
				token = null;
				page -= 1;
			}
			//Database.upsert(landlordsToUpdate.values(), false);
		}catch(exception e) {
			ErrorLogHandler.log('Landlord Schedule exception #1 - Exception', e);
			ErrorLogHandler.log('Landlord Schedule exception #2 - Exception', jsonResponse);
		}
	}

	// Landlord Wrapper
	global class landlordWrapper {
	    public String building_code;
	    public String building_key;
		public String responsible_entity;
		public String landlord_description;
        public String last_updated;
        public String lessor_text_number;
	}
}