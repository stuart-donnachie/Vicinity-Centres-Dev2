/*
    Date        : 12-09-2016
	Project     : Lease Management System
    Description : Units batch downloader

    Change History
    --------------
*/
global class ScheduleUnit implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful {
	global String token;
	global Integer page;
	global Integer totalPages;
	global Map<String,Id> mapCentre;
	global Map<String,Id> mapBuilding;
	global Map<String,Id> mapTenant;
	global Map<String,Id> mapBU;

	global ScheduleUnit(String token, Integer page, Integer totalPages,
	Map<String,Id> mapCentre,  Map<String,Id> mapBuilding,  Map<String,Id> mapTenant,  Map<String,Id> mapBU) {
		this.token = token;
		this.page = page;
		this.totalPages = totalPages;
		this.mapCentre = mapCentre;
		this.mapBuilding = mapBuilding;
		this.mapTenant = mapTenant;
		this.mapBU = mapBU;
	}

	global ScheduleUnit(Integer page) {
		this.page = page;
		this.mapCentre = new Map<String,Id>();
		this.mapBuilding = new Map<String,Id>();
		this.mapTenant = new Map<String,Id>();
		this.mapBU = new Map<String,Id>();
	}

	global ScheduleUnit() {
		this.page = 1;
		this.mapCentre = new Map<String,Id>();
		this.mapBuilding = new Map<String,Id>();
		this.mapTenant = new Map<String,Id>();
		this.mapBU = new Map<String,Id>();
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

	// Get the authentication token
	global Iterable<sObject> start(Database.BatchableContext bc) {
		if (String.isEmpty(this.token)) {
			this.token = this.getToken();
		}

		// Centres
		if (this.mapCentre.size() == 0) {
			for(Centre__c c : [SELECT Id,Centre_Key__c FROM Centre__c]){
				this.mapCentre.put(c.Centre_Key__c,c.Id);
			}
		}

		// Buildings
		if (this.mapBuilding.size() == 0) {
			for(Building__c b : [SELECT Id,Building_Key__c FROM Building__c]){
				this.mapBuilding.put(b.Building_Key__c,b.Id);
			}
		}

		// Tenants
		if (this.mapTenant.size() == 0) {
			for(Account a : [SELECT Id,Tenant_Key__c FROM Account]){
				this.mapTenant.put(a.Tenant_Key__c,a.Id);
			}
		}

		// BUs
		if (this.mapBU.size() == 0) {
			for(Business_Unit__c bu : [SELECT Id,Business_Unit_Key__c FROM Business_Unit__c]){
				this.mapBU.put(bu.Business_Unit_Key__c,bu.Id);
			}
		}

		return new List<Unit__c>{new Unit__c()};
	}

	global void execute(Database.BatchableContext bc, List<Unit__c> obj) {
		try {
			this.download(this.page);
		} catch(Exception ex) {
			ErrorLogHandler.log('Unit Schedule Exception - Page#'+ this.page,ex);
		}
	}

	global void finish(Database.BatchableContext bc) {
		if (this.page < this.totalPages) {
			Database.executeBatch(new ScheduleUnit(this.token, this.page + 1,
			this.totalPages, this.mapCentre, this.mapBuilding, this.mapTenant, this.mapBU), 1000);
		} else  {
			System.scheduleBatch(new ScheduleLeaseUnit(), 'Lease Unit Schedule', 0);
		}
	}

	global void download(Integer page) {
		HttpRequest request = new HttpRequest();
		request.setMethod('GET');
		request.setHeader('Authorization', 'Bearer ' + this.token);
		request.setHeader('Cache-Control', 'No-Cache');
		request.setEndpoint(Global_Settings__c.getInstance().API_URL_2__c+'/units?page='+ page);
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
      	req.setTimeout(100000);

		Http http = new Http();
		HttpResponse response = http.send(req);

		return response;
	}

	public String keyFix(String key){
		return (String.valueOf(Decimal.valueOf(key).setscale(0)));
	}

	global void save(String jsonResponse) {

		System.debug(jsonResponse);
		Map<String,Unit__c> mapjsonData = new Map<String,Unit__c>();
		Set<String> unitKeySet = new Set<String>();

		JSONParser parser = JSON.createParser(jsonResponse);
		while(parser.nextToken() != null) {
			if (this.totalPages == null && parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'total_pages') {
       	 		parser.nextToken();
        		this.totalPages = Integer.valueOf(parser.getText());
    		}
			if(parser.getCurrentToken() == JSONToken.START_ARRAY) {
				while(parser.nextToken() != null) {
					if(parser.getCurrentToken() == JSONToken.START_OBJECT) {

						unitWrapper ut = (unitWrapper)parser.readValueAs(unitWrapper.class);

						Unit__c objUnit = new Unit__c();

						objUnit.Name = ut.unit;
						objUnit.Unit_Code__c = ut.unit_type_deal_name;
						objUnit.Unit_Type__c = ut.unit_type_deal_code;
						objUnit.Area_of_Premises__c = Decimal.valueOf(ut.area);
						objUnit.Floor_Level__c = ut.floor;
						objUnit.Centre_Key__c = ut.centre_key;
						objUnit.Centre__c = mapCentre.containsKey(ut.centre_key) ?Id.valueOf(mapCentre.get(ut.centre_key)) : null;
						objUnit.Business_Unit__c = mapBU.containsKey(ut.business_unit_key) ?Id.valueOf(mapBU.get(ut.business_unit_key)) : null;
						objUnit.Building_Key__c = ut.building_key;
						objUnit.Building__c = mapBuilding.containsKey(ut.building_key) ? Id.valueOf(mapBuilding.get(ut.building_key)) : null;
						objUnit.Current_Tenant__c = (!String.isEmpty(ut.tenant_key) && ut.tenant_key != 'None' && mapTenant.containsKey(ut.tenant_key))
													? Id.valueOf(mapTenant.get(ut.tenant_key)) : null;
						objUnit.Unit_Key__c = ut.unit_key;
						//objUnit.Unit_Key__c = keyFix(objUnit.Unit_Key__c); // KEY FIX
						objUnit.Current_Tenant_Key__c = (!String.isEmpty(ut.tenant_key) && ut.tenant_key != 'None') ? ut.tenant_key : null;
						objUnit.System_Unit_Category__c = ut.system_defined_unit_code;
						objUnit.Current_Tenant_Trading_Name__c = ut.current_tenant_name;
						objUnit.Last_Updated_By_Job__c = system.now();

						mapjsonData.put(objUnit.Unit_Key__c,objUnit);
					}
				}
			}
		}

		for(Unit__c u :[SELECT Id, Name, Unit_Code__c, Unit_Type__c, Area_of_Premises__c, Floor_Level__c, System_Unit_Category__c,
															Centre_Key__c, Building_Key__c, Unit_Key__c , Last_Updated_By_Job__c,
															Current_Tenant__c, Current_Tenant_Trading_Name__c, Current_Tenant_Key__c
															FROM Unit__c
															WHERE Unit_Key__c in :mapjsonData.keyset()]){

			if(mapjsonData.containsKey(u.Unit_Key__c)){
				mapjsonData.get(u.Unit_Key__c).Id = u.Id;
			}
		}

		try{
			upsert mapjsonData.values();
			ErrorLogHandler.log('Unit Schedule',String.valueOf(mapjsonData.values().size()), String.valueOf(totalPages), String.valueOf(page), 'Schedule');
			if(mapjsonData.values().size() == 0 && !Test.isRunningTest()){
				ErrorLogHandler.log('Error in Unit Schedule #'+page, jsonResponse.left(131000));
				token = null;
				page -= 1;
			}
			//Database.upsert(mapjsonData.values(), false);
		}catch(exception e) {
			ErrorLogHandler.log('Unit Schedule exception #1 - Exception', e);
			ErrorLogHandler.log('Unit Schedule exception #2 - Exception', jsonResponse);
		}

	}

	// Units Wrapper
	global class unitWrapper {
		public String unit;
		public String unit_type_deal_name;
		public String unit_type_deal_code;
		public String area;
		public String floor;
		public String centre_key;
		public String building_key;
		public String business_unit_key;
		public String unit_key;
		public String tenant_key;
		public String current_tenant_name;
		public String system_defined_unit_code;
	}
}