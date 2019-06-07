/*
    Date        : 12-09-2016
	Project     : Lease Management System
    Description : Tenants batch downloader

    Change History
    --------------
*/
global class ScheduleTenant implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful {
	global String token;
	global Integer page;
	global Integer totalPages;

	global ScheduleTenant(String token, Integer page, Integer totalPages) {
		this.token = token;
		this.page = page;
		this.totalPages = totalPages;
	}

	global ScheduleTenant(Integer page) {
		this.page = page;
	}

	global ScheduleTenant() {
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

        return new List<Account>{new Account()};
	}

	global void execute(Database.BatchableContext bc, List<Account> obj) {
		System.debug('Executing Tenant Schedule - Page#'+this.page);
		try {
			this.download(this.page);
		} catch(Exception ex) {
			ErrorLogHandler.log('Tenant Schedule Exception - Page#'+ this.page,ex);
		}
	}

	global void finish(Database.BatchableContext bc) {
		if (this.page < this.totalPages) {
			Database.executeBatch(new ScheduleTenant(this.token, this.page + 1, this.totalPages), 1000);
		} else  {
			System.scheduleBatch(new ScheduleLandlords(), 'Landlord Schedule', 0);
		}
	}

	global void download(Integer page) {
		HttpRequest request = new HttpRequest();
		request.setMethod('GET');
		request.setHeader('Authorization', 'Bearer ' + this.token);
		request.setHeader('Cache-Control', 'No-Cache');
		request.setEndpoint(Global_Settings__c.getInstance().API_URL_2__c+'/tenants?page='+ page);
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

		Map<String,Account> mapjsonData = new Map<String,Account>();
		Set<String> tenantKeySet = new Set<String>();

		JSONParser parser = JSON.createParser(jsonResponse);
		while(parser.nextToken() != null) {
			if (this.totalPages == null && parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'total_pages') {
       	 		parser.nextToken();
        		this.totalPages = Integer.valueOf(parser.getText());
    		}
			if(parser.getCurrentToken() == JSONToken.START_ARRAY) {
				while(parser.nextToken() != null) {
					if(parser.getCurrentToken() == JSONToken.START_OBJECT) {

						tenantWrapper tenant = (tenantWrapper)parser.readValueAs(tenantWrapper.class);

						Account objAcc = new Account();

						objAcc.Tenant_CABID__c = tenant.tenant_code;
						objAcc.Legal_Group__c = tenant.legal_group;
						objAcc.Tenant_Entity__c = tenant.trading_name;
						objAcc.Trading_Group__c = tenant.trading_group;
						objAcc.ABN__c = tenant.abn;
						objAcc.Legal_Name__c = tenant.long_legal_name;
						objAcc.Tenant_ACN__c = tenant.acn;
						objAcc.Tenant_Key__c = tenant.tenant_key;
						//objAcc.Tenant_Key__c = keyFix(objAcc.Tenant_Key__c); // KEY FIX
						objAcc.Name = tenant.tenant_name;
						objAcc.Last_Updated_By_Job__c = system.now();
						objAcc.Last_Updated_By_JDE__c = (tenant.last_updated != null) ? Date.valueOf(tenant.last_updated) : null;
						mapjsonData.put(objAcc.Tenant_Key__c,objAcc);
					}
				}
			}
		}

		for(Account t :[SELECT Id, Tenant_CABID__c, Legal_Group__c, Tenant_Entity__c, Trading_Group__c,
																	Tenant_ACN__c, Tenant_Key__c, Name, Last_Updated_By_Job__c, ABN__c
																	FROM Account
																	WHERE Tenant_Key__c in :mapjsonData.keyset()]){

			if(mapjsonData.containsKey(t.Tenant_Key__c)){
				mapjsonData.get(t.Tenant_Key__c).Id = t.Id;
			}
		}

		try{
			upsert mapjsonData.values();
			ErrorLogHandler.log('Tenant Schedule',String.valueOf(mapjsonData.values().size()), String.valueOf(totalPages), String.valueOf(page), 'Schedule');
			if(mapjsonData.values().size() == 0 && !Test.isRunningTest()){
				ErrorLogHandler.log('Error in Tenant Schedule #'+page, jsonResponse.left(131000));
				token = null;
				page -= 1;
			}
			//Database.upsert(mapjsonData.values(), false);
		}catch(exception e) {
			ErrorLogHandler.log('Tenant Schedule exception #1 - Exception', e);
			ErrorLogHandler.log('Tenant Schedule exception #2 - Exception', jsonResponse);
		}

	}

	// Tenant Wrapper
	global class tenantWrapper {
		public String tenant_code;
		public String legal_group;
		public String tenant_name;
		public String acn;
		public String abn;
		public String long_legal_name;
		public String trading_group;
		public String last_updated;
		public String tenant_key;
		public String trading_name;
	}
}