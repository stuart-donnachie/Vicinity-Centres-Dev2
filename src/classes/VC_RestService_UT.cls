@isTest 
public class VC_RestService_UT {
	static testMethod void testDealPOST() {
		
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
		insert newOpp1;

		newUnit1.Preferred_Tenant__c = newOpp1.Id;
		update newUnit1;

		RestRequest req = new RestRequest(); 
		RestResponse res = new RestResponse();
		
		req.requestURI = '/services/apexrest/api?content=deal&filter=preferred';  
		req.httpMethod = 'POST';
		req.addParameter('content', 'deal');
		req.addParameter('filter', 'preferred');
		req.addParameter('recordNumberStart', '1');
		req.addParameter('recordNumberEnd', '100000000');
		
		RestContext.request = req;
    	RestContext.response = res;
		
		VC_RestService.doPOST(1, 10000000, null, null);
		test.stopTest();
	}
	
	static testMethod void testUnitPOST() {
		
		test.startTest();
		Unit__c newUnit1 = new Unit__c();
		insert newUnit1;
		
		Opportunity newOpp1 = new Opportunity();
		newOpp1.Name = 'test';
		newOpp1.StageName = 'test';
		newOpp1.CloseDate = Date.today();
		newOpp1.Lease_Incentive_Amount__c = 5;
		newOpp1.Unit__c = newUnit1.Id;
		insert newOpp1;

		newUnit1.Preferred_Tenant__c = newOpp1.Id;
		update newUnit1;

		RestRequest req = new RestRequest(); 
		RestResponse res = new RestResponse();
		
		req.requestURI = '/services/apexrest/api?content=unit';  
		req.httpMethod = 'POST';
		req.addParameter('content', 'unit');
		req.addParameter('recordNumberStart', '1');
		req.addParameter('recordNumberEnd', '100000000');
		
		RestContext.request = req;
    	RestContext.response = res;
		
		VC_RestService.doPOST(1, 100000000, null, null);
		test.stopTest();
	}
	
	static testMethod void testExceptionPOST() {
		
		test.startTest();
		Unit__c newUnit1 = new Unit__c();
		insert newUnit1;
		
		Opportunity newOpp1 = new Opportunity();
		newOpp1.Name = 'test';
		newOpp1.StageName = 'test';
		newOpp1.CloseDate = Date.today();
		newOpp1.Lease_Incentive_Amount__c = 5;
		newOpp1.Unit__c = newUnit1.Id;
		insert newOpp1;
		
		newUnit1.Preferred_Tenant__c = newOpp1.Id;
		update newUnit1;

		RestRequest req = new RestRequest(); 
		RestResponse res = new RestResponse();
		
		req.requestURI = '/services/apexrest/api?content=exp';  
		req.httpMethod = 'POST';
		req.addParameter('content', 'exp');
		req.addParameter('recordNumberStart', '1');
		req.addParameter('recordNumberEnd', '100000000');
		
		RestContext.request = req;
    	RestContext.response = res;
		
		VC_RestService.doPOST(1, 100, null, null);
		test.stopTest();
	}
	
	static testMethod void testExceptionGET() {
		
		test.startTest();
		Unit__c newUnit1 = new Unit__c();
		insert newUnit1;
		
		Opportunity newOpp1 = new Opportunity();
		newOpp1.Unit__c = newUnit1.Id;
		newOpp1.Name = 'test';
		newOpp1.StageName = 'test';
		newOpp1.CloseDate = Date.today();
		newOpp1.Lease_Incentive_Amount__c = 5;
		newOpp1.Last_Updated_By_API__c = Date.today();
		
		insert newOpp1;

		newUnit1.Preferred_Tenant__c = newOpp1.Id;
		newUnit1.Last_Updated_By_Job__c = Date.today();
		newUnit1.Last_Updated_By_API__c = Date.today();
		update newUnit1;

		RestRequest req = new RestRequest(); 
		RestResponse res = new RestResponse();
		
		req.requestURI = '/services/apexrest/api?content=deal&request=test';  
		req.httpMethod = 'GET';
		req.addParameter('content', 'deal');
		req.addParameter('request', 'test');
		
		RestContext.request = req;
    	RestContext.response = res;
		
		VC_RestService.doGet();
		test.stopTest();
	}
	
	static testMethod void testExceptionGET1() {
		
		test.startTest();
		Unit__c newUnit1 = new Unit__c();
		insert newUnit1;
		
		Opportunity newOpp1 = new Opportunity();
		newOpp1.Unit__c = newUnit1.Id;
		newOpp1.Name = 'test';
		newOpp1.StageName = 'test';
		newOpp1.CloseDate = Date.today();
		newOpp1.Lease_Incentive_Amount__c = 5;
		newOpp1.Last_Updated_By_API__c = Date.today();
		
		insert newOpp1;

		newUnit1.Preferred_Tenant__c = newOpp1.Id;
		newUnit1.Last_Updated_By_Job__c = Date.today();
		newUnit1.Last_Updated_By_API__c = Date.today();
		update newUnit1;

		RestRequest req = new RestRequest(); 
		RestResponse res = new RestResponse();
		
		req.requestURI = '/services/apexrest/api?content=deal&request=latest_sf_modified_date';  
		req.httpMethod = 'GET';
		req.addParameter('content', 'deal');
		req.addParameter('request', 'latest_sf_modified_date');
		
		RestContext.request = req;
    	RestContext.response = res;
		
		VC_RestService.doGet();
		test.stopTest();
	}
	
	static testMethod void testExceptionGET2() {
		
		test.startTest();
		Unit__c newUnit1 = new Unit__c();
		insert newUnit1;
		
		Opportunity newOpp1 = new Opportunity();
		newOpp1.Unit__c = newUnit1.Id;
		newOpp1.Name = 'test';
		newOpp1.StageName = 'test';
		newOpp1.CloseDate = Date.today();
		newOpp1.Lease_Incentive_Amount__c = 5;
		newOpp1.Last_Updated_By_API__c = Date.today();
		insert newOpp1;
		
		newUnit1.Preferred_Tenant__c = newOpp1.Id;
		newUnit1.Last_Updated_By_Job__c = Date.today();
		newUnit1.Last_Updated_By_API__c = Date.today();
		update newUnit1;

		RestRequest req = new RestRequest(); 
		RestResponse res = new RestResponse();
		
		req.requestURI = '/services/apexrest/api?content=deal&request=latest_sf_modified_date';  
		req.httpMethod = 'GET';
		req.addParameter('content', 'unit');
		req.addParameter('request', 'latest_sf_modified_date');
		
		RestContext.request = req;
    	RestContext.response = res;
		
		VC_RestService.doGet();
		test.stopTest();
	}
	
	static testMethod void testExceptionGET3() {
		
		test.startTest();
		Unit__c newUnit1 = new Unit__c();
		insert newUnit1;
		
		Opportunity newOpp1 = new Opportunity();
		newOpp1.Unit__c = newUnit1.Id;
		newOpp1.Name = 'test';
		newOpp1.StageName = 'test';
		newOpp1.CloseDate = Date.today();
		newOpp1.Lease_Incentive_Amount__c = 5;
		newOpp1.Last_Updated_By_API__c = Date.today();
		insert newOpp1;

		newUnit1.Preferred_Tenant__c = newOpp1.Id;
		newUnit1.Last_Updated_By_Job__c = Date.today();
		newUnit1.Last_Updated_By_API__c = Date.today();
		update newUnit1;

		RestRequest req = new RestRequest(); 
		RestResponse res = new RestResponse();
		
		req.requestURI = '/services/apexrest/api?content=deal&request=latest_schedule_modified_date';  
		req.httpMethod = 'GET';
		req.addParameter('content', 'unit');
		req.addParameter('request', 'latest_schedule_modified_date');
		
		RestContext.request = req;
    	RestContext.response = res;
		
		VC_RestService.doGet();
		test.stopTest();
	}
	
	static testMethod void testExceptionGET4() {
		
		test.startTest();
		Unit__c newUnit1 = new Unit__c();
		insert newUnit1;
		
		Opportunity newOpp1 = new Opportunity();
		newOpp1.Unit__c = newUnit1.Id;
		newOpp1.Name = 'test';
		newOpp1.StageName = 'test';
		newOpp1.CloseDate = Date.today();
		newOpp1.Lease_Incentive_Amount__c = 5;
		newOpp1.Last_Updated_By_API__c = Date.today();
		insert newOpp1;

		newUnit1.Preferred_Tenant__c = newOpp1.Id;
		newUnit1.Last_Updated_By_Job__c = Date.today();
		newUnit1.Last_Updated_By_API__c = Date.today();
		update newUnit1;

		RestRequest req = new RestRequest(); 
		RestResponse res = new RestResponse();
		
		req.requestURI = '/services/apexrest/api?content=deal&request=latest_api_modified_date';  
		req.httpMethod = 'GET';
		req.addParameter('content', 'unit');
		req.addParameter('request', 'latest_api_modified_date');
		
		RestContext.request = req;
    	RestContext.response = res;
		
		VC_RestService.doGet();
		test.stopTest();
	}
	
	static testMethod void testExceptionGET5() {
		
		test.startTest();
		Unit__c newUnit1 = new Unit__c();
		insert newUnit1;
		
		Opportunity newOpp1 = new Opportunity();
		newOpp1.Unit__c = newUnit1.Id;
		newOpp1.Name = 'test';
		newOpp1.StageName = 'test';
		newOpp1.CloseDate = Date.today();
		newOpp1.Lease_Incentive_Amount__c = 5;
		newOpp1.Last_Updated_By_API__c = Date.today();
		insert newOpp1;
		
		newUnit1.Preferred_Tenant__c = newOpp1.Id;
		newUnit1.Last_Updated_By_Job__c = Date.today();
		newUnit1.Last_Updated_By_API__c = Date.today();
		update newUnit1;

		RestRequest req = new RestRequest(); 
		RestResponse res = new RestResponse();
		
		req.requestURI = '/services/apexrest/api?content=deal&request=latest_api_modified_date';  
		req.httpMethod = 'GET';
		req.addParameter('content', 'deal');
		req.addParameter('request', 'latest_api_modified_date');
		
		RestContext.request = req;
    	RestContext.response = res;
		
		VC_RestService.doGet();
		test.stopTest();
	}
	
	static testMethod void testDealPUT() {
		
		test.startTest();
		Unit__c newUnit1 = new Unit__c();
		insert newUnit1;
		
		Opportunity newOpp1 = new Opportunity();
		newOpp1.Unit__c = newUnit1.Id;
		newOpp1.Name = 'test';
		newOpp1.Deal_Key__c = 'AA00060';
		newOpp1.StageName = 'Deal Builder';
		newOpp1.CloseDate = Date.today();
		newOpp1.Lease_Incentive_Amount__c = 5;
		insert newOpp1;

		newUnit1.Preferred_Tenant__c = newOpp1.Id;
		update newUnit1;

		RestRequest req = new RestRequest(); 
		RestResponse res = new RestResponse();
		
		req.requestBody = Blob.valueof('[ { "deal_key": "AA00060", "process_status": "Pending Approval", "process_status_date": "1990-10-10", "process_status_identifier": "LCRM01", "milestone": null, "milestone_date": null, "open_for_trade_date": null } ]');

		req.requestURI = '/services/apexrest/api?content=deal';  
		req.httpMethod = 'PUT';
		req.addParameter('content', 'deal');

		RestContext.request = req;
    	RestContext.response = res;
		
		VC_RestService.doPut();
		test.stopTest();
	}
	
		
	static testMethod void testPUTException() {
		
		test.startTest();
		Unit__c newUnit1 = new Unit__c();
		insert newUnit1;
		
		Opportunity newOpp1 = new Opportunity();
		newOpp1.Unit__c = newUnit1.Id;
		newOpp1.Name = 'test';
		newOpp1.Deal_Key__c = 'AA00060';
		newOpp1.StageName = 'Deal Builder';
		newOpp1.CloseDate = Date.today();
		newOpp1.Lease_Incentive_Amount__c = 5;
		insert newOpp1;

		newUnit1.Preferred_Tenant__c = newOpp1.Id;
		update newUnit1;

		RestRequest req = new RestRequest(); 
		RestResponse res = new RestResponse();
		
		req.requestBody = Blob.valueof('[ { "deal_key": "AA00060", "process_status": "Pending Approval", "process_status_date": "1990-10-10", "process_status_identifier": "LCRM01", "milestone": null, "milestone_date": null, "open_for_trade_date": null } ]');

		req.requestURI = '/services/apexrest/api?content=test';  
		req.httpMethod = 'PUT';
		req.addParameter('content', 'test');

		RestContext.request = req;
    	RestContext.response = res;
		
		VC_RestService.doPut();
		test.stopTest();
	}
	
	static testMethod void testUnitPUT() {
		
		test.startTest();
		Unit__c newUnit1 = new Unit__c();
		insert newUnit1;
		
		Opportunity newOpp1 = new Opportunity();
		newOpp1.Unit__c = newUnit1.Id;
		newOpp1.Name = 'test';
		newOpp1.Deal_Key__c = 'AA00060';
		newOpp1.StageName = 'Deal Builder';
		newOpp1.CloseDate = Date.today();
		newOpp1.Lease_Incentive_Amount__c = 5;
		insert newOpp1;
		
		newUnit1.Preferred_Tenant__c = newOpp1.Id;
		newUnit1.Unit_Key__c = '19';
		update newUnit1;

		RestRequest req = new RestRequest(); 
		RestResponse res = new RestResponse();
		
		req.requestBody = Blob.valueof('[{"unit_key": "19","forecast_base_rent": 10, "current_tenant_planned_end": "1990-01-15", "fitout_contribution_forecast": 100, "landlord_works_forecast": 1000, "estimated_rent_start": "1990-01-15", "estimated_rent_end": null}]');

		req.requestURI = '/services/apexrest/api?content=unit';  
		req.httpMethod = 'PUT';
		req.addParameter('content', 'unit');

		RestContext.request = req;
    	RestContext.response = res;
		
		VC_RestService.doPut();
		test.stopTest();
	}
	
	static testMethod void myTestMethod1() {
		//Integer offset = VC_RestService.getOffset(10, 1);
		//Integer totalpages = VC_RestService.getTotalPages(100, 10);
	}
	
	
}