@isTest
global class ScheduleCentreOutgoings_UT {
    
    public static testMethod void  createSchedule() {
                
        // Create Account
        Account objAccount = VC_UnitTestFactory.buildTestAccount();
        objAccount.Tenant_Key__c = '1';
        insert objAccount;
        
        // Create Tenant Rep
        Contact objContact1 = VC_UnitTestFactory.buildTenantRep();
        objContact1.Contact_Key__c = '1';
        insert objContact1;
        
        Contact objContact2 = VC_UnitTestFactory.buildTenantRep();
        objContact2.Contact_Key__c = '2';
        insert objContact2;
        
        Contact objContact3 = VC_UnitTestFactory.buildTenantRep();
        objContact3.Contact_Key__c = '5';
        insert objContact3;
        
        Map<String,Id> mapAccount = new Map<String,Id>();
        mapAccount.put('1', objAccount.Id);
        
        Test.startTest();
		
		Test.setMock(HttpCalloutMock.class, new AuthResponseMockHttpResponseGenerator());
        
        ScheduleCentreOutgoings sc1 = new ScheduleCentreOutgoings();
        ScheduleCentreOutgoings sc2 = new ScheduleCentreOutgoings(1);
        ScheduleCentreOutgoings sc3 = new ScheduleCentreOutgoings(sc1.getToken(),1,2,mapAccount);
        
        List<Centre_Outgoings__c> lstContact = new List<Centre_Outgoings__c>();
        
        Test.setMock(HttpCalloutMock.class, new ContactMockHttpResponseGenerator());
        
        HttpResponse response = new HttpResponse();
        Database.BatchableContext  bc;
        
        sc3.start(bc);
        sc3.execute(bc,lstContact);
        sc3.finish(bc);
        //sc3.hasRedirect(response);

        String jsonResponse = '{ "pagination": { "total_pages": 5, "page": 1 }, "data": [ { "Remark": "", "amenity_code": "CR01", "log_level": "B", "log_class": "CI", "business_unit_key": "42", "rate": "65.39", "expiry_date": "2017-06-30", "Centre_Override_Code": "", "critical_date": "2017-06-30", "begin_date": "2016-07-01", "business_unit_code": "77510" } ] }';
        sc3.save(jsonResponse);
        
        Test.stopTest();
        
    } 
    
    global class AuthResponseMockHttpResponseGenerator implements HttpCalloutMock {
	    global HTTPResponse respond(HTTPRequest req) {
	        
	        HttpResponse res = new HttpResponse();
	        res.setHeader('Content-Type', 'application/json');
	        res.setBody('{ "refresh_token_expires_in": "0", "api_product_list": "[Vicinity Data Lake API]", "organization_name": "vicinitycentres", "developer.email": "vicinitycentres@vicinity.com.au", "token_type": "BearerToken", "issued_at": "1488412657099", "client_id": "v4bFh1TY90I6Nfr2vI4SGiDRozS0af6G", "access_token": "wR8yUE9PUFsN9TN830G8xfVvrU4i", "application_name": "9f9caa6e-3c6e-460d-a7d3-5ab0e043b0e9", "scope": "", "expires_in": "1799", "refresh_count": "0", "status": "approved" }');
	        res.setStatusCode(200);
	        return res;
	    }
	}
    
    global class ContactMockHttpResponseGenerator implements HttpCalloutMock {
	    global HTTPResponse respond(HTTPRequest req) {
	        
	        HttpResponse res = new HttpResponse();
	        res.setHeader('Content-Type', 'application/json');
	        res.setBody('{ "pagination": { "total_pages": 5, "page": 1 }, "data": [ { "Remark": "", "amenity_code": "CR01", "log_level": "B", "log_class": "CI", "business_unit_key": "42", "rate": "65.39", "expiry_date": "2017-06-30", "Centre_Override_Code": "", "critical_date": "2017-06-30", "begin_date": "2016-07-01", "business_unit_code": "77510" } ] }');
	        res.setStatusCode(302);
	        res.setHeader('Location','https://cs31.salesforce.com');
	        return res;
	    }
}
}