@isTest
global class ScheduleContactV3_UT {

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

        ScheduleContactV3 sc1 = new ScheduleContactV3();
        ScheduleContactV3 sc2 = new ScheduleContactV3(1);
        ScheduleContactV3 sc3 = new ScheduleContactV3(sc1.getToken(),1,2,mapAccount);

        List<Contact> lstContact = new List<Contact>();

        Test.setMock(HttpCalloutMock.class, new ContactMockHttpResponseGenerator());

        HttpResponse response = new HttpResponse();
        Database.BatchableContext  bc;

        sc3.start(bc);
        sc3.execute(bc,lstContact);
        sc3.finish(bc);
        //sc3.hasRedirect(response);

        String jsonResponse = '{"pagination": {"total_pages": 1,"page": 1},"data": [{"code": "101185","contact_details": [{"phone_number": "9702 3011","city": "BERWICK","phone_number_type": "BUS","phone_number_prefix": "03","contact_details_key": "2","country": "","acn": "","email": "harry@sujikim.com","state": "VIC","timestamp": "2016-10-17 19:58:06","address_line_4": "","contact_key": "1","address_line_2": "","address_line_3": "","address_line_1": "43-45 CASERTA DRIVE"}],"description": "Harry Kim Pty Ltd","contact_type": "B","timestamp": "2016-10-17 19:57:11","contact": "Accounts Payable","centre_description": "Do not Delete","contact_key": "1","tenant_key": "1"},{"code": "101185","contact_details": [{"phone_number": "","city": "BERWICK","phone_number_type": "","phone_number_prefix": "","contact_details_key": "3","country": "","acn": "","email": "","state": "VIC","timestamp": "2016-10-17 19:58:06","address_line_4": "","contact_key": "2","address_line_2": "","address_line_3": "","address_line_1": "43-45 CASERTA DRIVE"}],"description": "Harry Kim Pty Ltd","contact_type": "Z","timestamp": "2016-10-17 19:57:11","contact": "Harry Kim Pty Ltd","centre_description": "Do not Delete","contact_key": "2","tenant_key": "1"},{"code": "101185","contact_details": [{"phone_number": "9702 3011","city": "BERWICK","phone_number_type": "BUS","phone_number_prefix": "03","contact_details_key": "6","country": "","acn": "","email": "harry@sujikim.com","state": "VIC","timestamp": "2016-10-17 19:58:06","address_line_4": "","contact_key": "5","address_line_2": "","address_line_3": "","address_line_1": "43-45 CASERTA DRIVE"},{"phone_number": "220 122","city": "BERWICK","phone_number_type": "MOB","phone_number_prefix": "0438","contact_details_key": "7","country": "","acn": "","email": "harry@sujikim.com","state": "VIC","timestamp": "2016-10-17 19:58:06","address_line_4": "","contact_key": "5","address_line_2": "","address_line_3": "","address_line_1": "43-45 CASERTA DRIVE"}],"description": "Harry Kim Pty Ltd","contact_type": "A","timestamp": "2016-10-17 19:57:11","contact": "Suji Kim","centre_description": "Do not Delete","contact_key": "5","tenant_key": "1"}]}';
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
            res.setBody('{"pagination": {"total_pages": 1,"page": 1},"data": [{"code": "101185","contact_details": [{"phone_number": "9702 3011","city": "BERWICK","phone_number_type": "BUS","phone_number_prefix": "03","contact_details_key": "2","country": "","acn": "","email": "harry@sujikim.com","state": "VIC","timestamp": "2016-10-17 19:58:06","address_line_4": "","contact_key": "1","address_line_2": "","address_line_3": "","address_line_1": "43-45 CASERTA DRIVE"}],"description": "Harry Kim Pty Ltd","contact_type": "B","timestamp": "2016-10-17 19:57:11","contact": "Accounts Payable","centre_description": "Do not Delete","contact_key": "1","tenant_key": "1"},{"code": "101185","contact_details": [{"phone_number": "","city": "BERWICK","phone_number_type": "","phone_number_prefix": "","contact_details_key": "3","country": "","acn": "","email": "","state": "VIC","timestamp": "2016-10-17 19:58:06","address_line_4": "","contact_key": "2","address_line_2": "","address_line_3": "","address_line_1": "43-45 CASERTA DRIVE"}],"description": "Harry Kim Pty Ltd","contact_type": "Z","timestamp": "2016-10-17 19:57:11","contact": "Harry Kim Pty Ltd","centre_description": "Do not Delete","contact_key": "2","tenant_key": "1"},{"code": "101185","contact_details": [{"phone_number": "9702 3011","city": "BERWICK","phone_number_type": "BUS","phone_number_prefix": "03","contact_details_key": "6","country": "","acn": "","email": "harry@sujikim.com","state": "VIC","timestamp": "2016-10-17 19:58:06","address_line_4": "","contact_key": "5","address_line_2": "","address_line_3": "","address_line_1": "43-45 CASERTA DRIVE"},{"phone_number": "220 122","city": "BERWICK","phone_number_type": "MOB","phone_number_prefix": "0438","contact_details_key": "7","country": "","acn": "","email": "harry@sujikim.com","state": "VIC","timestamp": "2016-10-17 19:58:06","address_line_4": "","contact_key": "5","address_line_2": "","address_line_3": "","address_line_1": "43-45 CASERTA DRIVE"}],"description": "Harry Kim Pty Ltd","contact_type": "A","timestamp": "2016-10-17 19:57:11","contact": "Suji Kim","centre_description": "Do not Delete","contact_key": "5","tenant_key": "1"}]}');
            res.setStatusCode(302);
            res.setHeader('Location','https://cs31.salesforce.com');
            return res;
        }
    }
}