@isTest
global class ScheduleBuildingV3_UT {

    public static testMethod void  createSchedule() {

        // Create centre
        Centre__c objCentre = VC_UnitTestFactory.buildTestCentre();
        objCentre.Centre_Key__c = '52';
        insert objCentre;

        // Create building
        Building__c objBuilding1 = VC_UnitTestFactory.buildTestBuilding();
        objBuilding1.Centre_Key__c = objCentre.Centre_Key__c;
        objBuilding1.Centre__c = objCentre.Id;
        objBuilding1.Building_Key__c = '2';
        insert objBuilding1;

        Building__c objBuilding2 = VC_UnitTestFactory.buildTestBuilding();
        objBuilding2.Centre_Key__c = objCentre.Centre_Key__c;
        objBuilding2.Centre__c = objCentre.Id;
        objBuilding1.Building_Key__c = '3';
        insert objBuilding2;

        Map<String,Id> mapCentre = new Map<String,Id>();
        mapCentre.put('52', objCentre.Id);

        ScheduleBuildingV3 sc1 = new ScheduleBuildingV3();
        ScheduleBuildingV3 sc2 = new ScheduleBuildingV3(1);
        ScheduleBuildingV3 sc3 = new ScheduleBuildingV3('ABC',1,2,mapCentre, new Map<String,Id>());

        Test.startTest();

        Test.setMock(HttpCalloutMock.class, new BuildingMockHttpResponseGenerator());

        List<Building__c> lstBuilding = new List<Building__c>();
        HttpResponse response = new HttpResponse();
        Database.BatchableContext  bc;

        sc3.start(bc);
        sc3.execute(bc,lstBuilding);
        sc3.finish(bc);

        Test.stopTest();

        String jsonResponse = '{"pagination": {"total_pages": 1,"page": 1},"data": [{"city": "ALBANY","code": "73810","name": "ALBANY BROOKS GARDEN","building_key": "2","country": "AUSTRALIA","address": "CNR CHESTER PASS & CATALINA ROADS","state": "WA","postcode": "6330","timestamp": "2016-10-17 19:56:04","centre_key": "52"},{"city": "ARMIDALE","code": "73910","name": "ARMIDALE CENTRAL","building_key": "3","country": "AUSTRALIA","address": "225 BEARDY STREET","state": "NSW","postcode": "2350","timestamp": "2016-10-17 19:56:04","centre_key": "52"}]}';
        sc3.save(jsonResponse);


    }

    public static testMethod void  createSchedule2() {

        // Create centre
        Centre__c objCentre = VC_UnitTestFactory.buildTestCentre();
        objCentre.Centre_Key__c = '52';
        insert objCentre;

        // Create building
        Building__c objBuilding1 = VC_UnitTestFactory.buildTestBuilding();
        objBuilding1.Centre_Key__c = objCentre.Centre_Key__c;
        objBuilding1.Centre__c = objCentre.Id;
        objBuilding1.Building_Key__c = '2';
        insert objBuilding1;

        Building__c objBuilding2 = VC_UnitTestFactory.buildTestBuilding();
        objBuilding2.Centre_Key__c = objCentre.Centre_Key__c;
        objBuilding2.Centre__c = objCentre.Id;
        objBuilding1.Building_Key__c = '3';
        insert objBuilding2;

        Map<String,Id> mapCentre = new Map<String,Id>();
        mapCentre.put('52', objCentre.Id);

        Test.startTest();

        Test.setMock(HttpCalloutMock.class, new AuthResponseMockHttpResponseGenerator());

        ScheduleBuildingV3 sc1 = new ScheduleBuildingV3();
        ScheduleBuildingV3 sc2 = new ScheduleBuildingV3(1);
        ScheduleBuildingV3 sc3 = new ScheduleBuildingV3(sc1.getToken(),1,2,mapCentre, new Map<String,Id>());

        Test.setMock(HttpCalloutMock.class, new BuildingMockHttpResponseGenerator());

        List<Building__c> lstBuilding = new List<Building__c>();
        HttpResponse response = new HttpResponse();

        Database.BatchableContext  bc;

        sc3.start(bc);
        sc3.execute(bc,lstBuilding);
        sc3.finish(bc);
        sc3.hasRedirect(response);
        //sc3.handleRedirect(response);

        Test.stopTest();

        String jsonResponse = '{"pagination": {"total_pages": 1,"page": 1},"data": [{"city": "ALBANY","code": "73810","name": "ALBANY BROOKS GARDEN","building_key": "2","country": "AUSTRALIA","address": "CNR CHESTER PASS & CATALINA ROADS","state": "WA","postcode": "6330","timestamp": "2016-10-17 19:56:04","centre_key": "52"},{"city": "ARMIDALE","code": "73910","name": "ARMIDALE CENTRAL","building_key": "3","country": "AUSTRALIA","address": "225 BEARDY STREET","state": "NSW","postcode": "2350","timestamp": "2016-10-17 19:56:04","centre_key": "52"}]}';
        sc3.save(jsonResponse);


    }

    public static testMethod void  createScheduleMapCentreSizeZero() {

        // Create centre
        Centre__c objCentre = VC_UnitTestFactory.buildTestCentre();
        objCentre.Centre_Key__c = '52';
        insert objCentre;

        Business_Unit__c myBusiness_unit = new Business_Unit__c(Name = 'BU1', Business_Unit_Key__c = 'BUK1');
        insert myBusiness_unit;

        Map<String,Id> mapCentre = new Map<String,Id>();

        ScheduleBuildingV3 sc1 = new ScheduleBuildingV3();
        ScheduleBuildingV3 sc2 = new ScheduleBuildingV3(1);
        ScheduleBuildingV3 sc3 = new ScheduleBuildingV3(null,1,2,mapCentre, new Map<String,Id>());

        Test.startTest();

        Test.setMock(HttpCalloutMock.class, new BuildingMockHttpResponseGenerator());

        List<Building__c> lstBuilding = new List<Building__c>();
        HttpResponse response = new HttpResponse();
        Database.BatchableContext  bc;

        sc3.start(bc);
        sc3.execute(bc,lstBuilding);
        sc3.finish(bc);

        Test.stopTest();

        String jsonResponse = '';
        sc3.save(jsonResponse);
    }

    global class BuildingMockHttpResponseGenerator implements HttpCalloutMock {
        global HTTPResponse respond(HTTPRequest req) {

            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setHeader('Location','https://cs31.salesforce.com');
            res.setBody('{"pagination": {"total_pages": 1,"page": 1},"data": [{"code": "1","name": "Chadstone","country": "Australia","Longitude": "145.12453600","state": "VIC","postcode": "3199","address": "28 Beach Street","latitude": "-38.14116900","centre_key": "1","contract_number": "1"},{"code": "10","name": " ","country": "Australia","Longitude": "144.91977300","state": "VIC","postcode": "3047","address": "1099-1169 Pascoe Vale Road","latitude": "-37.67951900","centre_key": "2","contract_number": "1"}]}');
            res.setStatusCode(302);
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