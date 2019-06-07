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
private class VC_RestService2_UT {

    static testMethod void ecmResponseTest1() {
        test.startTest();
		Unit__c newUnit1 = new Unit__c();
		insert newUnit1;
		
		Opportunity newOpp1 = new Opportunity();
		newOpp1.Name = 'test';
		newOpp1.StageName = 'test';
		newOpp1.CloseDate = Date.today();
		newOpp1.API_Error__c = false;
		newOpp1.Is_Incomplete__c = false;
		newOpp1.Lease_Incentive_Amount__c = 5;
		newOpp1.Unit__c = newUnit1.Id;
		newOpp1.Deal_Key__c = 'AA11035';
		insert newOpp1;

		newUnit1.Preferred_Tenant__c = newOpp1.Id;
		update newUnit1;

		RestRequest req = new RestRequest(); 
		RestResponse res = new RestResponse();
		
		req.requestURI = '/services/apexrest/api/v2?content=ecm_response';  
		req.httpMethod = 'POST';
		req.addParameter('content', 'ecm_response');
		req.requestBody = Blob.valueof('{"status": "true", "reason": null, "links": '+
		'[{"link": "https://technologyservices.s3-ap-southeast-2.amazonaws.com/Leasing/EOI/AA11035/EOI%20Attachments-EOI00001.pdf", '+
		'"title": "EOI Attachments-EOI00001.pdf"}], "deal_key": "AA11035"}');
		
		RestContext.request = req;
    	RestContext.response = res;
		
		VC_RestService2.doPOST();
		test.stopTest();
    }
    
    static testMethod void tdpResponseTest1() {
        test.startTest();
		Unit__c newUnit1 = new Unit__c();
		insert newUnit1;
		
		Opportunity newOpp1 = new Opportunity();
		newOpp1.Name = 'test';
		newOpp1.StageName = 'test';
		newOpp1.CloseDate = Date.today();
		newOpp1.API_Error__c = false;
		newOpp1.Is_Incomplete__c = false;
		newOpp1.Lease_Incentive_Amount__c = 5;
		newOpp1.Unit__c = newUnit1.Id;
		newOpp1.Deal_Key__c = 'AC04498';
		insert newOpp1;

		newUnit1.Preferred_Tenant__c = newOpp1.Id;
		update newUnit1;

		RestRequest req = new RestRequest(); 
		RestResponse res = new RestResponse();
		
		req.requestURI = '/services/apexrest/api/v2?content=tdp_response';  
		req.httpMethod = 'POST';
		req.addParameter('content', 'tdp_response');
		req.requestBody = Blob.valueof('{"status": "true", "reason": null, "deal_key": "AC04498"}');
		
		RestContext.request = req;
    	RestContext.response = res;
		
		VC_RestService2.doPOST();
		test.stopTest();
    }
    
        
    static testMethod void tdpResponseTest2() {
        test.startTest();
		Unit__c newUnit1 = new Unit__c();
		insert newUnit1;
		
		Opportunity newOpp1 = new Opportunity();
		newOpp1.Name = 'test';
		newOpp1.StageName = 'test';
		newOpp1.CloseDate = Date.today();
		newOpp1.API_Error__c = false;
		newOpp1.Is_Incomplete__c = false;
		newOpp1.Lease_Incentive_Amount__c = 5;
		newOpp1.Unit__c = newUnit1.Id;
		newOpp1.Deal_Key__c = 'AC04498';
		insert newOpp1;

		newUnit1.Preferred_Tenant__c = newOpp1.Id;
		update newUnit1;

		RestRequest req = new RestRequest(); 
		RestResponse res = new RestResponse();
		
		req.requestURI = '/services/apexrest/api/v2?content=tdp_response';  
		req.httpMethod = 'POST';
		req.addParameter('content', 'tdp_response');
		req.requestBody = Blob.valueof('{"status": "false", "reason": null, "deal_key": "AC04498"}');
		
		RestContext.request = req;
    	RestContext.response = res;
		
		VC_RestService2.doPOST();
		test.stopTest();
    }
            
    static testMethod void lonResponseTest1() {
        test.startTest();
		Unit__c newUnit1 = new Unit__c();
		insert newUnit1;
		
		Opportunity newOpp1 = new Opportunity();
		newOpp1.Name = 'test';
		newOpp1.StageName = 'test';
		newOpp1.CloseDate = Date.today();
		newOpp1.API_Error__c = false;
		newOpp1.Is_Incomplete__c = false;
		newOpp1.Lease_Incentive_Amount__c = 5;
		newOpp1.Unit__c = newUnit1.Id;
		newOpp1.Deal_Key__c = 'AC04498';
		insert newOpp1;

		newUnit1.Preferred_Tenant__c = newOpp1.Id;
		update newUnit1;

		RestRequest req = new RestRequest(); 
		RestResponse res = new RestResponse();
		
		req.requestURI = '/services/apexrest/api/v2?content=lon_response';  
		req.httpMethod = 'POST';
		req.addParameter('content', 'lon_response');
		req.requestBody = Blob.valueof('{"status": "true", "reason": null, "deal_key": "AC04498"}');
		
		RestContext.request = req;
    	RestContext.response = res;
		
		VC_RestService2.doPOST();
		test.stopTest();
    }
      
    static testMethod void postResponseException() {
        test.startTest();
		Unit__c newUnit1 = new Unit__c();
		insert newUnit1;
		
		Opportunity newOpp1 = new Opportunity();
		newOpp1.Name = 'test';
		newOpp1.StageName = 'test';
		newOpp1.CloseDate = Date.today();
		newOpp1.API_Error__c = false;
		newOpp1.Is_Incomplete__c = false;
		newOpp1.Lease_Incentive_Amount__c = 5;
		newOpp1.Unit__c = newUnit1.Id;
		newOpp1.Deal_Key__c = 'AC04498';
		insert newOpp1;

		newUnit1.Preferred_Tenant__c = newOpp1.Id;
		update newUnit1;

		RestRequest req = new RestRequest(); 
		RestResponse res = new RestResponse();
		
		req.requestURI = '/services/apexrest/api/v2?content=lon_response';  
		req.httpMethod = 'POST';
		req.addParameter('content', 'lon_response');
		req.requestBody = Blob.valueof('"status": "true", "reason": null, "deal_key": "AC04498"');
		
		RestContext.request = req;
    	RestContext.response = res;
		
		VC_RestService2.doPOST();
		
		VC_RestService2.sendEmail('test','test','test@test.com');
		
		test.stopTest();
    }
}