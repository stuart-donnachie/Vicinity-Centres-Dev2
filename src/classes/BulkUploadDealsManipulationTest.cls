/**
 * Created by stuartdonnachie on 9/2/18.
 */
@IsTest
global with sharing class BulkUploadDealsManipulationTest {
    @TestSetup
    static void setupData(){
        // Create centre
        Centre__c objCentre = VC_UnitTestFactory.buildTestCentre();
        objCentre.Centre_Code__c = '46';
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
        objUnit.Unit_Code__c = '45ATM';
        objUnit.Building_Key__c = objBuilding.Building_Key__c;
        objUnit.Building__c = objBuilding.Id;
        insert objUnit;

        // Create Account
        Account objAccount = VC_UnitTestFactory.buildTestAccount();
        insert objAccount;

        // Create Account
        Account objAccount2 = VC_UnitTestFactory.buildTestDefaultAccount();
        insert objAccount2;

        // Create opportunity
        Opportunity objOpp =  VC_UnitTestFactory.buildTestOpportunity();
        objOpp.AccountId = objAccount.Id;
        objOpp.Deal_Type__c = 'New Tenant Standard';
        objOpp.Building__c = objBuilding.Id;
        objOpp.Existing_Retailer__c = true;
        objOpp.Unit__c = objUnit.Id;
        objOpp.Development_Unit__c = true;
        objOpp.Estimated_Handover_Date__c = System.today() + 3;
        objOpp.Estimated_Lease_Commencement_Date__c = System.today() + 3;
        insert objOpp;

        Opportunity objOpp2 =  VC_UnitTestFactory.buildTestOpportunity();
        objOpp2.AccountId = objAccount.Id;
        objOpp2.Deal_Type__c = 'Renewal';
        objOpp2.Recovery_Type__c = 'GROSS';
        objOpp2.Building__c = objBuilding.Id;
        objOpp2.Existing_Retailer__c = false;
        objOpp2.New_Retailer__c = true;
        objOpp2.Unit__c = objUnit.Id;
        objOpp2.Development_Unit__c = true;
        objOpp2.Estimated_Handover_Date__c = System.today() + 3;
        objOpp2.Estimated_Lease_Commencement_Date__c = System.today() + 3;
        objOpp2.Refit__c = false;
        insert objOpp2;

        Opportunity objOpp3 =  VC_UnitTestFactory.buildTestOpportunity();
        objOpp3.AccountId = objAccount.Id;
        objOpp3.Deal_Type__c = 'New Tenant As Is';
        objOpp3.Building__c = objBuilding.Id;
        objOpp3.Existing_Retailer__c = false;
        objOpp3.New_Retailer__c = true;
        objOpp3.Unit__c = objUnit.Id;
        objOpp3.Development_Unit__c = true;
        objOpp3.Estimated_Handover_Date__c = System.today() + 3;
        objOpp3.Estimated_Lease_Commencement_Date__c = System.today() + 3;
        objOpp3.Refit__c = false;
        insert objOpp3;
    }

    testMethod static void testManipulation(){
        List<User> userForTesting = [SELECT Id FROM User WHERE Lastname = 'Donnachie' LIMIT 1];

        System.runAs(userForTesting[0]){
            Test.startTest();

            Opportunity opportunity = [SELECT Id, Tenant_Key__c, Unit__r.Building__r.Centre_Key__c, Contract_Number__c, Unit_Code__c, Unit__r.Building__r.Building_Key__c FROM Opportunity WHERE Deal_Type__c = 'Renewal' LIMIT 1];

            BulkUploadDealsManipulation manipulation = new BulkUploadDealsManipulation();

            manipulation.setDeal(opportunity.Id);

            Test.setMock(HttpCalloutMock.class, new AuthResponseMockHttpResponseGenerator());

            Test.setMock(HttpCalloutMock.class, new TenantProfileMockHttpResponseGenerator());

            manipulation.doWork(opportunity.Id);

            Test.stopTest();
        }
    }

    testMethod static void testManipulation2(){
        List<User> userForTesting = [SELECT Id FROM User WHERE Lastname = 'Donnachie' LIMIT 1];

        System.runAs(userForTesting[0]){
            Test.startTest();

            Opportunity opportunity = [SELECT Id, Tenant_Key__c, Unit__r.Building__r.Centre_Key__c, Contract_Number__c, Unit_Code__c, Unit__r.Building__r.Building_Key__c FROM Opportunity WHERE Deal_Type__c = 'New Tenant Standard' LIMIT 1];

            BulkUploadDealsManipulation manipulation = new BulkUploadDealsManipulation();

            manipulation.setDeal(opportunity.Id);

            Test.setMock(HttpCalloutMock.class, new AuthResponseMockHttpResponseGenerator());

            Test.setMock(HttpCalloutMock.class, new TenantProfileMockHttpResponseGenerator());

            manipulation.doWork(opportunity.Id);

            Test.stopTest();
        }
    }

    testMethod static void testManipulation3(){
        List<User> userForTesting = [SELECT Id FROM User WHERE Lastname = 'Donnachie' LIMIT 1];

        System.runAs(userForTesting[0]){
            Test.startTest();

            Opportunity opportunity = [SELECT Id, Tenant_Key__c, Unit__r.Building__r.Centre_Key__c, Contract_Number__c, Unit_Code__c, Unit__r.Building__r.Building_Key__c FROM Opportunity WHERE Deal_Type__c = 'New Tenant As Is' LIMIT 1];

            BulkUploadDealsManipulation manipulation = new BulkUploadDealsManipulation();

            manipulation.setDeal(opportunity.Id);


            Test.setMock(HttpCalloutMock.class, new AuthResponseMockHttpResponseGenerator());

            Test.setMock(HttpCalloutMock.class, new TenantProfileMockHttpResponseGenerator());

            manipulation.doWork(opportunity.Id);

            Test.stopTest();
        }
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