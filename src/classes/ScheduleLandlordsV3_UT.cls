@isTest
global class ScheduleLandlordsV3_UT {

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

        ScheduleLandlordsV3 sc1 = new ScheduleLandlordsV3();
        ScheduleLandlordsV3 sc2 = new ScheduleLandlordsV3(1);
        ScheduleLandlordsV3 sc3 = new ScheduleLandlordsV3(sc1.getToken(),1,2,mapAccount);

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