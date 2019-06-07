@isTest
global class LiveSchedule_UT {
    static testMethod void myTest() {
    	Centre__c objCentre = VC_UnitTestFactory.buildTestCentre();
		objCentre.Centre_Key__c = '1';
		insert objCentre;

		Building__c objBuilding = VC_UnitTestFactory.buildTestBuilding();
		objBuilding.Centre_Key__c = objCentre.Centre_Key__c;
		objBuilding.Centre__c = objCentre.Id;
		objBuilding.Building_Key__c = '2';
		insert objBuilding;

		Account objAccount = VC_UnitTestFactory.buildTestAccount();
		objAccount.Tenant_Key__c = '1';
		insert objAccount;

		Unit__c objUnit = VC_UnitTestFactory.buildTestUnit();
		objUnit.Centre_Key__c = objCentre.Centre_Key__c;
		objUnit.Centre__c = objCentre.Id;
		objUnit.Building_Key__c = objBuilding.Building_Key__c;
		objUnit.Building__c = objBuilding.Id;
		objUnit.Unit_Key__c = '1';
		insert objUnit;

    	Test.startTest();
    	LiveSchedule ls = new LiveSchedule();

    	Test.setMock(HttpCalloutMock.class, new TokenMockHttpResponseGenerator());
		String token = LiveSchedule.getToken();

		Test.setMock(HttpCalloutMock.class, new LiveTenantMockHttpResponseGenerator());
		String tenantsJSON = LiveSchedule.getRecords(token, '/tenants-daily-changes');

		Test.setMock(HttpCalloutMock.class, new LiveUnitMockHttpResponseGenerator());
		String unitsJSON = LiveSchedule.getRecords(token, '/units-daily-changes');

		Test.setMock(HttpCalloutMock.class, new LiveContactMockHttpResponseGenerator());
		String contactsJSON = LiveSchedule.getRecords(token, '/contacts-daily-changes');

		LiveSchedule.saveTenants(tenantsJSON);
		LiveSchedule.saveUnits(unitsJSON);
		LiveSchedule.saveContacts(contactsJSON);
		Test.stopTest();
    }

    global class LiveTenantMockHttpResponseGenerator implements HttpCalloutMock {
	    global HTTPResponse respond(HTTPRequest req) {

	        HttpResponse res = new HttpResponse();
	        res.setHeader('Content-Type', 'application/json');
	        res.setBody('[ { "legal_group": ".", "tenant_name": "RODNEY CLARKE", "jde_business_key": "290987", "acn": "615056963", "abn": "59615056963", "auditdate": "2017-06-21 07:31:10", "timestamp": "2017-06-21 10:09:00", "trading_group": ".", "tenant_key": "1", "trading_name": "RC RETAIL GROUP PTY LTD" }]');
	        res.setStatusCode(200);
	        return res;
	    }
	}

    global class LiveUnitMockHttpResponseGenerator implements HttpCalloutMock {
	    global HTTPResponse respond(HTTPRequest req) {

	        HttpResponse res = new HttpResponse();
	        res.setHeader('Content-Type', 'application/json');
	        res.setBody('[ { "unit_name": "G-136B", "end_date": "", "floor": "GND", "building_key": "2", "timestamp": "2017-06-21 10:58:45", "current_tenant_name": "", "unit_status": "", "system_defined_unit_category": "LBNT - Not Trading", "area": "107.0", "unit_key": "6976", "unit_type_deal_name": "10RTL", "unit_type_deal_code": "Retail Specialty", "centre_key": "1", "current_tenant_key": "", "start_date": "2016-05-01" }]');
	        res.setHeader('Location','https://cs31.salesforce.com');
	        res.setStatusCode(302);
	        return res;
	    }
	}


    global class LiveContactMockHttpResponseGenerator implements HttpCalloutMock {
	    global HTTPResponse respond(HTTPRequest req) {

	        HttpResponse res = new HttpResponse();
	        res.setHeader('Content-Type', 'application/json');
	        res.setBody('[ { "last_updated": "2017-10-04", "description": "Barry And Matthew Iles", "contact_type": "A", "timestamp": "2017-10-04 11:35:25", "detail_line_identifier": "1", "contact": "Amanda Walker", "centre_description": "Do not Delete", "contact_details": [ { "city": "PORT MELBOURNE", "phone_number_type": "BUS", "last_updated": "2017-10-02", "description": "Pafu Co Outlets Pty Ltd", "contact_type": "A", "country": "", "email_business_key": "1", "detail_line_identifier": "2", "phone_business_key": "1", "email": "stg100780@gmail.com", "phone": "+61 433 118 314", "state": "VIC", "contact": "Tatt Ghee Saw", "address_business_key": "298645", "centre_description": "Do not Delete", "address_line_4": "", "contact_key": "169580", "address_line_2": "", "address_line_3": "", "tenant_key": "18122", "address_line_1": "120 TURNER STREET" }], "contact_key": "169599", "tenant_key": "5739" } ]');
	        res.setHeader('Location','https://cs31.salesforce.com');
	        res.setStatusCode(302);
	        return res;
	    }
	}
    global class TokenMockHttpResponseGenerator implements HttpCalloutMock {
	    global HTTPResponse respond(HTTPRequest req) {

	        HttpResponse res = new HttpResponse();
	        res.setHeader('Content-Type', 'application/json');
	        res.setBody('{ "refresh_token_expires_in": "0", "api_product_list": "[Vicinity Data Lake API]", "api_product_list_json": [ "Vicinity Data Lake API" ], "organization_name": "vicinitycentres", "developer.email": "vicinitycentres@vicinity.com.au", "token_type": "BearerToken", "issued_at": "1498003649335", "client_id": "v4bFh1TY90I6Nfr2vI4SGiDRozS0af6G", "access_token": "kPbACRzmsLG7dV6U2FJJ6my6o4Cq", "application_name": "9f9caa6e-3c6e-460d-a7d3-5ab0e043b0e9", "scope": "", "expires_in": "1799", "refresh_count": "0", "status": "approved" }');
	        res.setHeader('Location','https://cs31.salesforce.com');
	        res.setStatusCode(302);
	        return res;
	    }
	}
}