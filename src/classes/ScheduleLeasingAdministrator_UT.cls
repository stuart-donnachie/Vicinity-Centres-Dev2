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
global class ScheduleLeasingAdministrator_UT {

    static testMethod void myUnitTest() {
    	
    	Test.startTest();
    	
        ScheduleLeasingAdministrator sla = new ScheduleLeasingAdministrator();
        
        Test.setMock(HttpCalloutMock.class, new AuthResponseMockHttpResponseGenerator());
        String token = ScheduleLeasingAdministrator.getToken();
        
        Test.setMock(HttpCalloutMock.class, new LeasingAdminMockHttpResponseGenerator());
        String responeJSON = ScheduleLeasingAdministrator.getLeasingAdministrators(token);
        
        Boolean status = ScheduleLeasingAdministrator.updateContacts(responeJSON);
        
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
    
    global class LeasingAdminMockHttpResponseGenerator implements HttpCalloutMock {
	    global HTTPResponse respond(HTTPRequest req) {
	        
	        HttpResponse res = new HttpResponse();
	        res.setHeader('Content-Type', 'application/json');
	        res.setBody('{ "pagination": { "total_pages": 1, "page": 1 }, "data": [ { "mailing_name": "Lisa Modrich", "code": "8111", "email": "lisa.modrich@vicinity.com.au", "name": "Lisa Modrich", "title": "" } ] }');
	        res.setStatusCode(302);
	        res.setHeader('Location','https://cs31.salesforce.com');
	        return res;
	    }
	}
}