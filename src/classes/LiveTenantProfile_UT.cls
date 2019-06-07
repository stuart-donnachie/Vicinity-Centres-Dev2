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
global class LiveTenantProfile_UT {

    static testMethod void myUnitTest() {

		Centre__c objCentre = VC_UnitTestFactory.buildTestCentre();
		insert objCentre;

		Building__c objBuilding = VC_UnitTestFactory.buildTestBuilding();
		objBuilding.Centre_Key__c = objCentre.Centre_Key__c;
		objBuilding.Centre__c = objCentre.Id;
		insert objBuilding;

		Unit__c objUnit = VC_UnitTestFactory.buildTestUnit();
		objUnit.Centre_Key__c = objCentre.Centre_Key__c;
		objUnit.Centre__c = objCentre.Id;
		objUnit.Building_Key__c = objBuilding.Building_Key__c;
		objUnit.Building__c = objBuilding.Id;
		insert objUnit;

		Account objAccount = VC_UnitTestFactory.buildTestAccount();
		insert objAccount;

		Opportunity objOpp =  VC_UnitTestFactory.buildTestOpportunity();
		objOpp.AccountId = objAccount.Id;
		objOpp.Deal_Type__c = 'New Tenant Standard';
		objOpp.Building__c = objBuilding.Id;
		objOpp.Unit__c = objUnit.Id;
		objOpp.Development_Unit__c = true;
		insert objOpp;
    	
    	Test.startTest();
    	
        LiveTenantProfile ltp = new LiveTenantProfile(objOpp);
        
        Test.setMock(HttpCalloutMock.class, new AuthResponseMockHttpResponseGenerator());
        String token = ltp.getToken();
        
        Test.setMock(HttpCalloutMock.class, new TenantProfileMockHttpResponseGenerator());
        String responeJSON = ltp.getTenantProfile(token);
        
        Boolean status = ltp.updateDeal(responeJSON);
        
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
    
    global class TenantProfileMockHttpResponseGenerator implements HttpCalloutMock {
	    global HTTPResponse respond(HTTPRequest req) {
	        
	        HttpResponse res = new HttpResponse();
	        res.setHeader('Content-Type', 'application/json');
	        res.setBody('{ "pagination": { "total_pages": 10, "page": 1 }, "data": [ { "last_updated": "2010-06-10", "building_key": "", "parent_guarantee": "No", "percentage_rent_category": "RETAIL", "percentage_rent_rate": "10.0", "permitted_use": "The retail sale and provision of(i) communications equipment and telecommunications equipment, facilities and services (including, without limitation, telephone and computer communications regardless of the method of transmission) and related goods and services(ii) computer hardware, software and related goods and services(iii) any type of equipment used for or in connection with communications or telecommunications (including, without limitation, equipment used in connection with internet access and digital cameras); AND (iv)at the Tenants option from time to time, the collection of accounts payable to the Tenant or an entity related to the Tenant within the meaning of the Corporations Act 2001 (Cth) (whether or not the accounts relate to the goods or services sold or provided from the Premises)., trading as OPTUS WORLD", "type_of_guarantor_required": "PE", "unit_type": "", "no_of_guarantees_required": "1", "hoardings_at_commencement": "Yes", "personal_guarantee": "Yes", "franchisor": "N", "national_tenant_flag": "N", "rent_review_rate": "5.0", "promo_contribution_percentage": "5.0", "promo_review_rate": "5.0", "mercury_building_code": "0", "contract_number": "0", "group_security_no_of_months_required": "0", "public_listed_company": "NO", "group_security": "0.0", "tenant_code": "199168", "bank_guarantee_required": "Yes", "bank_guarantee_months": "3", "rent_review_type": "01", "design_review_fees_at_commencement": "Yes", "group_security_amount": "0.0", "promo_review_type": "01", "tenant_key": "7959" } ] }');
	        res.setStatusCode(302);
	        res.setHeader('Location','https://cs31.salesforce.com');
	        return res;
	    }
	}
}