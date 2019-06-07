/*
    Date        : 18-10-2016
	Project     : Lease Management System
    Description : Unit test class for RestAPI class for on demand fetch of tenant profile
    
    Change History
    --------------      
*/
@isTest
global class RestAPI_UT {
	
	public static testMethod void  createRESTApi() {
		
		// Create Account
		Account objAccount = VC_UnitTestFactory.buildTestAccount();
		objAccount.Tenant_Key__c = '16423';
		insert objAccount;

		// Create centre
		Centre__c objCentre = VC_UnitTestFactory.buildTestCentre();
		objCentre.Name = 'Emporium';
		insert objCentre;
		
		// Create building
		Building__c objBuilding = VC_UnitTestFactory.buildTestBuilding();
		objBuilding.Centre_Key__c = objCentre.Centre_Key__c;
		objBuilding.Centre__c = objCentre.Id;
		insert objBuilding;
				
		// Create unit
		Unit__c objUnit = VC_UnitTestFactory.buildTestUnit();
		objUnit.Centre_Key__c = objCentre.Centre_Key__c;
		objUnit.Centre__c = objCentre.Id;
		objUnit.Building_Key__c = objBuilding.Building_Key__c;
		objUnit.Building__c = objBuilding.Id;
		objUnit.Name = 'test';
		insert objUnit;
		
		// Create opportunity
		Opportunity objOpp =  VC_UnitTestFactory.buildTestOpportunity();
		objOpp.AccountId = objAccount.Id;
		objOpp.Deal_Type__c = 'New Tenant Standard';
		objOpp.Unit__c = objUnit.Id;
		insert objOpp;
		
		HttpResponse response = new HttpResponse();
		Test.startTest();
		ApexPages.currentPage().getParameters().put('id', objOpp.Id);
		RestAPI rp = new RestAPI(new ApexPages.StandardController(new Opportunity()));
		rp.oppVal = objOpp.Id;
		Continuation conti = (Continuation)rp.startRequest();
		Map<String, HttpRequest> requests = conti.getRequests();
		Test.setMock(HttpCalloutMock.class, new AuthResponseMockHttpResponseGenerator());
		response.setBody('{ "refresh_token_expires_in": "0", "api_product_list": "[Vicinity Data Lake API]", "organization_name": "vicinitycentres", "developer.email": "vicinitycentres@vicinity.com.au", "token_type": "BearerToken", "issued_at": "1488412657099", "client_id": "v4bFh1TY90I6Nfr2vI4SGiDRozS0af6G", "access_token": "wR8yUE9PUFsN9TN830G8xfVvrU4i", "application_name": "9f9caa6e-3c6e-460d-a7d3-5ab0e043b0e9", "scope": "", "expires_in": "1799", "refresh_count": "0", "status": "approved" }');
		Test.setContinuationResponse(rp.oauthRequestLabel, response);
		Object obj2 = rp.processOauthToken();
		Test.setMock(HttpCalloutMock.class, new FinalResponseMockHttpResponseGenerator());
		response.setBody('{"pagination": {"total_pages": 1,"page": 1},"data": [{"code": "281493","building_key": "0","parent_guarantee": "No","percentage_rent_category": "GOVSRV","percentage_rent_rate": "6.0","permitted_use": "Retail sale of mens, womens and childrens apparel, footwear accessories and equipment of the major international lifestyle, leisure and sporting brands, trading as SPORTSCO","unit_type": "","personal_guarantee": "No","rent_review_rate": "5.0","promo_contribution_percentage": "5.0","hoarding_at_commencement": "Yes","promo_review_rate": "5.0","contract_number": "0","group_security": "0","timestamp": "2016-10-18 19:57:09","bank_guarantee_required": "Yes","bank_guarantee_months": "4","no_of_personal_guarantees": "0","rent_review_type": "01","design_review_fees_at_commencement": "Yes","promo_review_type": "01","tenant_key": "16423"}]}');
		Test.setContinuationResponse(rp.apiRequestLabel, response);
		Object obj3e = rp.processFinalResponse();
		response.setBody('{"pagination": {"total_pages": 1,"page": 1},"data": [{"code": "281493","building_key": "0","parent_guarantee": "No","percentage_rent_category": "LIQUOR","percentage_rent_rate": "6.0","permitted_use": "Retail sale of mens, womens and childrens apparel, footwear accessories and equipment of the major international lifestyle, leisure and sporting brands, trading as SPORTSCO","unit_type": "","personal_guarantee": "No","rent_review_rate": "5.0","promo_contribution_percentage": "5.0","hoarding_at_commencement": "Yes","promo_review_rate": "5.0","contract_number": "0","group_security": "0","timestamp": "2016-10-18 19:57:09","bank_guarantee_required": "Yes","bank_guarantee_months": "4","no_of_personal_guarantees": "0","rent_review_type": "01","design_review_fees_at_commencement": "Yes","promo_review_type": "01","tenant_key": "16423"}]}');
		Test.setContinuationResponse(rp.apiRequestLabel, response);
		Object obj3f = rp.processFinalResponse();
		response.setBody('{"pagination": {"total_pages": 1,"page": 1},"data": [{"code": "281493","building_key": "0","parent_guarantee": "No","percentage_rent_category": "PHARM","percentage_rent_rate": "6.0","permitted_use": "Retail sale of mens, womens and childrens apparel, footwear accessories and equipment of the major international lifestyle, leisure and sporting brands, trading as SPORTSCO","unit_type": "","personal_guarantee": "No","rent_review_rate": "5.0","promo_contribution_percentage": "5.0","hoarding_at_commencement": "Yes","promo_review_rate": "5.0","contract_number": "0","group_security": "0","timestamp": "2016-10-18 19:57:09","bank_guarantee_required": "Yes","bank_guarantee_months": "4","no_of_personal_guarantees": "0","rent_review_type": "01","design_review_fees_at_commencement": "Yes","promo_review_type": "01","tenant_key": "16423"}]}');
		Test.setContinuationResponse(rp.apiRequestLabel, response);
		Object obj3g = rp.processFinalResponse();
		response.setBody('{"pagination": {"total_pages": 1,"page": 1},"data": [{"code": "281493","building_key": "0","parent_guarantee": "No","percentage_rent_category": "REST","percentage_rent_rate": "6.0","permitted_use": "Retail sale of mens, womens and childrens apparel, footwear accessories and equipment of the major international lifestyle, leisure and sporting brands, trading as SPORTSCO","unit_type": "","personal_guarantee": "No","rent_review_rate": "5.0","promo_contribution_percentage": "5.0","hoarding_at_commencement": "Yes","promo_review_rate": "5.0","contract_number": "0","group_security": "0","timestamp": "2016-10-18 19:57:09","bank_guarantee_required": "Yes","bank_guarantee_months": "4","no_of_personal_guarantees": "0","rent_review_type": "01","design_review_fees_at_commencement": "Yes","promo_review_type": "01","tenant_key": "16423"}]}');
		Test.setContinuationResponse(rp.apiRequestLabel, response);
		Object obj3h = rp.processFinalResponse();
		response.setBody('{"pagination": {"total_pages": 1,"page": 1},"data": [{"code": "281493","building_key": "0","parent_guarantee": "No","percentage_rent_category": "SERV","percentage_rent_rate": "6.0","permitted_use": "Retail sale of mens, womens and childrens apparel, footwear accessories and equipment of the major international lifestyle, leisure and sporting brands, trading as SPORTSCO","unit_type": "","personal_guarantee": "No","rent_review_rate": "5.0","promo_contribution_percentage": "5.0","hoarding_at_commencement": "Yes","promo_review_rate": "5.0","contract_number": "0","group_security": "0","timestamp": "2016-10-18 19:57:09","bank_guarantee_required": "Yes","bank_guarantee_months": "4","no_of_personal_guarantees": "0","rent_review_type": "01","design_review_fees_at_commencement": "Yes","promo_review_type": "01","tenant_key": "16423"}]}');
		Test.setContinuationResponse(rp.apiRequestLabel, response);
		Object obj3i = rp.processFinalResponse();
		response.setBody('{"pagination": {"total_pages": 1,"page": 1},"data": [{"code": "281493","building_key": "0","parent_guarantee": "No","percentage_rent_category": "TATTRV","percentage_rent_rate": "6.0","permitted_use": "Retail sale of mens, womens and childrens apparel, footwear accessories and equipment of the major international lifestyle, leisure and sporting brands, trading as SPORTSCO","unit_type": "","personal_guarantee": "No","rent_review_rate": "5.0","promo_contribution_percentage": "5.0","hoarding_at_commencement": "Yes","promo_review_rate": "5.0","contract_number": "0","group_security": "0","timestamp": "2016-10-18 19:57:09","bank_guarantee_required": "Yes","bank_guarantee_months": "4","no_of_personal_guarantees": "0","rent_review_type": "01","design_review_fees_at_commencement": "Yes","promo_review_type": "01","tenant_key": "16423"}]}');
		Test.setContinuationResponse(rp.apiRequestLabel, response);
		Object obj3j = rp.processFinalResponse();
		response.setBody('{"pagination": {"total_pages": 1,"page": 1},"data": [{"code": "281493","building_key": "0","parent_guarantee": "Yes","percentage_rent_category": "TOBACC","percentage_rent_rate": "6.0","permitted_use": "Retail sale of mens, womens and childrens apparel, footwear accessories and equipment of the major international lifestyle, leisure and sporting brands, trading as SPORTSCO","unit_type": "","personal_guarantee": "No","rent_review_rate": "5.0","promo_contribution_percentage": "5.0","hoarding_at_commencement": "Yes","promo_review_rate": "5.0","contract_number": "0","group_security": "0","timestamp": "2016-10-18 19:57:09","bank_guarantee_required": "Yes","bank_guarantee_months": "4","no_of_personal_guarantees": "0","rent_review_type": "01","design_review_fees_at_commencement": "Yes","promo_review_type": "01","tenant_key": "16423"}]}');
		Test.setContinuationResponse(rp.apiRequestLabel, response);
		Object obj3k = rp.processFinalResponse();
		rp.oppVal = objOpp.Id;
		String jsonResponse = '{"pagination": {"total_pages": 1,"page": 1},"data": [{"code": "281493","building_key": "0","parent_guarantee": "No","percentage_rent_category": "RETAIL","percentage_rent_rate": "6.0","permitted_use": "Retail sale of mens, womens and childrens apparel, footwear accessories and equipment of the major international lifestyle, leisure and sporting brands, trading as SPORTSCO","unit_type": "","personal_guarantee": "No","rent_review_rate": "5.0","promo_contribution_percentage": "5.0","hoarding_at_commencement": "Yes","promo_review_rate": "5.0","contract_number": "0","group_security": "0","timestamp": "2016-10-18 19:57:09","bank_guarantee_required": "Yes","bank_guarantee_months": "4","no_of_personal_guarantees": "0","rent_review_type": "01","design_review_fees_at_commencement": "Yes","promo_review_type": "01","tenant_key": "16423"}]}';
		rp.parseResponse(jsonResponse);
		response.setHeader('Location', 'test');
		Object obj4 = rp.handleRedirect(response);
		Test.stopTest();
	} 
	
	public static testMethod void  createRESTApi2() {
		
		// Create Account
		Account objAccount = VC_UnitTestFactory.buildTestAccount();
		objAccount.Tenant_Key__c = '16423';
		insert objAccount;
		
		// Create centre
		Centre__c objCentre = VC_UnitTestFactory.buildTestCentre();
		objCentre.Name = 'Emporium';
		insert objCentre;
		
		// Create building
		Building__c objBuilding = VC_UnitTestFactory.buildTestBuilding();
		objBuilding.Centre_Key__c = objCentre.Centre_Key__c;
		objBuilding.Centre__c = objCentre.Id;
		insert objBuilding;
				
		// Create unit
		Unit__c objUnit = VC_UnitTestFactory.buildTestUnit();
		objUnit.Centre_Key__c = objCentre.Centre_Key__c;
		objUnit.Centre__c = objCentre.Id;
		objUnit.Building_Key__c = objBuilding.Building_Key__c;
		objUnit.Building__c = objBuilding.Id;
		objUnit.Name = 'test';
		insert objUnit;
		
		// Create opportunity
		Opportunity objOpp =  VC_UnitTestFactory.buildTestOpportunity();
		objOpp.AccountId = objAccount.Id;
		objOpp.Deal_Type__c = 'New Tenant Standard';
		objOpp.Unit__c = objUnit.Id;
		insert objOpp;
		
		HttpResponse response = new HttpResponse();
		Test.startTest();
		ApexPages.currentPage().getParameters().put('id', objOpp.Id);
		RestAPI rp = new RestAPI(new ApexPages.StandardController(new Opportunity()));
		rp.oppVal = objOpp.Id;
		Continuation conti = (Continuation)rp.startRequest();
		Map<String, HttpRequest> requests = conti.getRequests();
		Test.setMock(HttpCalloutMock.class, new AuthResponseMockHttpResponseGenerator());
		response.setBody('{ "refresh_token_expires_in": "0", "api_product_list": "[Vicinity Data Lake API]", "organization_name": "vicinitycentres", "developer.email": "vicinitycentres@vicinity.com.au", "token_type": "BearerToken", "issued_at": "1488412657099", "client_id": "v4bFh1TY90I6Nfr2vI4SGiDRozS0af6G", "access_token": "wR8yUE9PUFsN9TN830G8xfVvrU4i", "application_name": "9f9caa6e-3c6e-460d-a7d3-5ab0e043b0e9", "scope": "", "expires_in": "1799", "refresh_count": "0", "status": "approved" }');
		Test.setContinuationResponse(rp.oauthRequestLabel, response);
		Object obj2 = rp.processOauthToken();
		Test.setMock(HttpCalloutMock.class, new FinalResponseMockHttpResponseGenerator());
		response.setBody('{"pagination": {"total_pages": 1,"page": 1},"data": [{"code": "281493","building_key": "0","parent_guarantee": "No","percentage_rent_category": "RETAIL","percentage_rent_rate": "6.0","permitted_use": "Retail sale of mens, womens and childrens apparel, footwear accessories and equipment of the major international lifestyle, leisure and sporting brands, trading as SPORTSCO","unit_type": "Retail","personal_guarantee": "No","rent_review_rate": "5.0","promo_contribution_percentage": "5.0","hoarding_at_commencement": "Yes","promo_review_rate": "5.0","contract_number": "0","group_security": "0","timestamp": "2016-10-18 19:57:09","bank_guarantee_required": "Yes","bank_guarantee_months": "4","no_of_personal_guarantees": "0","rent_review_type": "01","design_review_fees_at_commencement": "Yes","promo_review_type": "01","tenant_key": "16423"}]}');
		Test.setContinuationResponse(rp.apiRequestLabel, response);
		Object obj3 = rp.processFinalResponse();
		response.setBody('{"pagination": {"total_pages": 1,"page": 1},"data": [{"code": "281493","building_key": "0","parent_guarantee": "No","percentage_rent_category": "BANK","percentage_rent_rate": "6.0","permitted_use": "Retail sale of mens, womens and childrens apparel, footwear accessories and equipment of the major international lifestyle, leisure and sporting brands, trading as SPORTSCO","unit_type": "","personal_guarantee": "No","rent_review_rate": "5.0","promo_contribution_percentage": "5.0","hoarding_at_commencement": "Yes","promo_review_rate": "5.0","contract_number": "0","group_security": "0","timestamp": "2016-10-18 19:57:09","bank_guarantee_required": "Yes","bank_guarantee_months": "4","no_of_personal_guarantees": "0","rent_review_type": "02","design_review_fees_at_commencement": "Yes","promo_review_type": "02","tenant_key": "16423"}]}');
		Test.setContinuationResponse(rp.apiRequestLabel, response);
		Object obj3a = rp.processFinalResponse();
		response.setBody('{"pagination": {"total_pages": 1,"page": 1},"data": [{"code": "281493","building_key": "0","parent_guarantee": "No","percentage_rent_category": "CAFE","percentage_rent_rate": "6.0","permitted_use": "Retail sale of mens, womens and childrens apparel, footwear accessories and equipment of the major international lifestyle, leisure and sporting brands, trading as SPORTSCO","unit_type": "","personal_guarantee": "No","rent_review_rate": "5.0","promo_contribution_percentage": "5.0","hoarding_at_commencement": "Yes","promo_review_rate": "5.0","contract_number": "0","group_security": "0","timestamp": "2016-10-18 19:57:09","bank_guarantee_required": "Yes","bank_guarantee_months": "4","no_of_personal_guarantees": "0","rent_review_type": "03","design_review_fees_at_commencement": "Yes","promo_review_type": "03","tenant_key": "16423"}]}');
		Test.setContinuationResponse(rp.apiRequestLabel, response);
		Object obj3b = rp.processFinalResponse();
		response.setBody('{"pagination": {"total_pages": 1,"page": 1},"data": [{"code": "281493","building_key": "0","parent_guarantee": "No","percentage_rent_category": "CHAR","percentage_rent_rate": "6.0","permitted_use": "Retail sale of mens, womens and childrens apparel, footwear accessories and equipment of the major international lifestyle, leisure and sporting brands, trading as SPORTSCO","unit_type": "","personal_guarantee": "No","rent_review_rate": "5.0","promo_contribution_percentage": "5.0","hoarding_at_commencement": "Yes","promo_review_rate": "5.0","contract_number": "0","group_security": "1","timestamp": "2016-10-18 19:57:09","bank_guarantee_required": "Yes","bank_guarantee_months": "4","no_of_personal_guarantees": "0","rent_review_type": "04","design_review_fees_at_commencement": "Yes","promo_review_type": "04","tenant_key": "16423"}]}');
		Test.setContinuationResponse(rp.apiRequestLabel, response);
		Object obj3c = rp.processFinalResponse();
		response.setBody('{"pagination": {"total_pages": 1,"page": 1},"data": [{"code": "281493","building_key": "0","parent_guarantee": "No","percentage_rent_category": "FOOD","percentage_rent_rate": "6.0","permitted_use": "Retail sale of mens, womens and childrens apparel, footwear accessories and equipment of the major international lifestyle, leisure and sporting brands, trading as SPORTSCO","unit_type": "","personal_guarantee": "No","rent_review_rate": "5.0","promo_contribution_percentage": "5.0","hoarding_at_commencement": "Yes","promo_review_rate": "5.0","contract_number": "0","group_security": "0","timestamp": "2016-10-18 19:57:09","bank_guarantee_required": "Yes","bank_guarantee_months": "4","no_of_personal_guarantees": "0","rent_review_type": "NA","design_review_fees_at_commencement": "Yes","promo_review_type": "NA","tenant_key": "16423"}]}');
		Test.setContinuationResponse(rp.apiRequestLabel, response);
		Object obj3d = rp.processFinalResponse();
		response.setBody('{"pagination": {"total_pages": 1,"page": 1},"data": [{"code": "281493","building_key": "0","parent_guarantee": "No","percentage_rent_category": "GOVSRV","percentage_rent_rate": "6.0","permitted_use": "Retail sale of mens, womens and childrens apparel, footwear accessories and equipment of the major international lifestyle, leisure and sporting brands, trading as SPORTSCO","unit_type": "","personal_guarantee": "No","rent_review_rate": "5.0","promo_contribution_percentage": "5.0","hoarding_at_commencement": "Yes","promo_review_rate": "5.0","contract_number": "0","group_security": "0","timestamp": "2016-10-18 19:57:09","bank_guarantee_required": "Yes","bank_guarantee_months": "4","no_of_personal_guarantees": "0","rent_review_type": "01","design_review_fees_at_commencement": "Yes","promo_review_type": "01","tenant_key": "16423"}]}');
		Test.setContinuationResponse(rp.apiRequestLabel, response);
		Object obj3e = rp.processFinalResponse();
		rp.oppVal = objOpp.Id;
		String jsonResponse = '{"pagination": {"total_pages": 1,"page": 1},"data": [{"code": "281493","building_key": "0","parent_guarantee": "No","percentage_rent_category": "RETAIL","percentage_rent_rate": "6.0","permitted_use": "Retail sale of mens, womens and childrens apparel, footwear accessories and equipment of the major international lifestyle, leisure and sporting brands, trading as SPORTSCO","unit_type": "","personal_guarantee": "No","rent_review_rate": "5.0","promo_contribution_percentage": "5.0","hoarding_at_commencement": "Yes","promo_review_rate": "5.0","contract_number": "0","group_security": "0","timestamp": "2016-10-18 19:57:09","bank_guarantee_required": "Yes","bank_guarantee_months": "4","no_of_personal_guarantees": "0","rent_review_type": "01","design_review_fees_at_commencement": "Yes","promo_review_type": "01","tenant_key": "16423"}]}';
		rp.parseResponse(jsonResponse);
		response.setHeader('Location', 'test');
		Object obj4 = rp.handleRedirect(response);
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
	
    global class FinalResponseMockHttpResponseGenerator implements HttpCalloutMock {
	    global HTTPResponse respond(HTTPRequest req) {
	        
	        HttpResponse res = new HttpResponse();
	        res.setHeader('Content-Type', 'application/json');
	        res.setBody('{"pagination": {"total_pages": 1,"page": 1},"data": [{"code": "281493","building_key": "0","parent_guarantee": "No","percentage_rent_category": "RETAIL","percentage_rent_rate": "6.0","permitted_use": "Retail sale of mens, womens and childrens apparel, footwear accessories and equipment of the major international lifestyle, leisure and sporting brands, trading as SPORTSCO","unit_type": "","personal_guarantee": "No","rent_review_rate": "5.0","promo_contribution_percentage": "5.0","hoarding_at_commencement": "Yes","promo_review_rate": "5.0","contract_number": "0","group_security": "0","timestamp": "2016-10-18 19:57:09","bank_guarantee_required": "Yes","bank_guarantee_months": "4","no_of_personal_guarantees": "0","rent_review_type": "01","design_review_fees_at_commencement": "Yes","promo_review_type": "01","tenant_key": "16423"}]}');
	        res.setStatusCode(200);
	        return res;
	    }
	}
}