/*
    Date        : 18-10-2016
	Project     : Lease Management System
    Description : Unit test class for ScheduleCentre batch class

    Change History
    --------------
*/
@isTest
global class ScheduleCentreV3_UT {

    public static testMethod void  createSchedule() {

        // Create centre
        Centre__c objCentre1 = VC_UnitTestFactory.buildTestCentre();
        objCentre1.Centre_Key__c = '1';
        insert objCentre1;

        Centre__c objCentre2 = VC_UnitTestFactory.buildTestCentre();
        objCentre1.Centre_Key__c = '2';
        insert objCentre2;

        Test.startTest();

        Test.setMock(HttpCalloutMock.class, new AuthResponseMockHttpResponseGenerator());

        ScheduleCentreV3 sc1 = new ScheduleCentreV3();
        ScheduleCentreV3 sc2 = new ScheduleCentreV3(1);
        ScheduleCentreV3 sc3 = new ScheduleCentreV3(sc1.getToken(),1,2);

        Test.setMock(HttpCalloutMock.class, new CentreMockHttpResponseGenerator());

        List<Centre__c> lstCentre = new List<Centre__c>();
        HttpResponse response = new HttpResponse();
        Database.BatchableContext  bc;

        sc3.start(bc);
        sc3.execute(bc,lstCentre);
        sc3.finish(bc);
        sc3.hasRedirect(response);

        String jsonResponse = '{"pagination": {"total_pages": 1,"page": 1},"data": [{"code": "1","name": "Chadstone","country": "Australia","Longitude": "145.12453600","state": "VIC","postcode": "3199","address": "28 Beach Street","latitude": "-38.14116900","centre_key": "1","contract_number": "1"},{"code": "10","name": " ","country": "Australia","Longitude": "144.91977300","state": "VIC","postcode": "3047","address": "1099-1169 Pascoe Vale Road","latitude": "-37.67951900","centre_key": "2","contract_number": "1"}]}';
        sc3.save(jsonResponse);

        Test.stopTest();

    }

    global class CentreMockHttpResponseGenerator implements HttpCalloutMock {
        global HTTPResponse respond(HTTPRequest req) {

            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"pagination": {"total_pages": 1,"page": 1},"data": [{"code": "1","name": "Chadstone","country": "Australia","Longitude": "145.12453600","state": "VIC","postcode": "3199","address": "28 Beach Street","latitude": "-38.14116900","centre_key": "1","contract_number": "1"},{"code": "10","name": " ","country": "Australia","Longitude": "144.91977300","state": "VIC","postcode": "3047","address": "1099-1169 Pascoe Vale Road","latitude": "-37.67951900","centre_key": "2","contract_number": "1"}]}');
            res.setStatusCode(302);
            res.setHeader('Location','https://cs31.salesforce.com');
            return res;
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
}