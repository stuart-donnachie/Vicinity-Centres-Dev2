/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
global class ScheduleLandlords_UT {

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
        
        ScheduleLandlords sc1 = new ScheduleLandlords();
        ScheduleLandlords sc2 = new ScheduleLandlords(1);
        ScheduleLandlords sc3 = new ScheduleLandlords(sc1.getToken(),1,2,mapAccount);
        
        List<Landlord__c> objs = new List<Landlord__c>();
        
        Test.setMock(HttpCalloutMock.class, new ContactMockHttpResponseGenerator());
        
        HttpResponse response = new HttpResponse();
        Database.BatchableContext  bc;
        
        sc3.start(bc);
        sc3.execute(bc,objs);
        sc3.finish(bc);
        //sc3.hasRedirect(response);

        String jsonResponse = '{ "pagination": { "total_pages": 1, "page": 1 }, "data": [ { "building_code": "74610", "responsible_entity": "", "landlord_description": "Vicinity Custodian Pty Ltd ACN 077 870 243 in its capacity as trustee for Federation Property Investment Trust ABN 24 295 350 357", "building_key": "130", "last_updated": "2016-05-13", "lessor_text_number": "93" } ] }';
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
	        res.setBody('{ "pagination": { "total_pages": 1, "page": 1 }, "data": [ { "building_code": "74610", "responsible_entity": "", "landlord_description": "Vicinity Custodian Pty Ltd ACN 077 870 243 in its capacity as trustee for Federation Property Investment Trust ABN 24 295 350 357", "building_key": "130", "last_updated": "2016-05-13", "lessor_text_number": "93" } ] }');
	        res.setStatusCode(302);
	        res.setHeader('Location','https://cs31.salesforce.com');
	        return res;
	    }
}
}