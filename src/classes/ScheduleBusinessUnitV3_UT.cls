/**
 * Created by stuartdonnachie on 20/12/17.
 */

@IsTest
global class ScheduleBusinessUnitV3_UT {
    static testMethod void testBehavior() {


        Test.startTest();

        ScheduleBusinessUnitV3 sbu1 = new ScheduleBusinessUnitV3(1);
        ScheduleBusinessUnitV3 sbu2 = new ScheduleBusinessUnitV3('ABC', 1, 2);
        ScheduleBusinessUnitV3 sbu3 = new ScheduleBusinessUnitV3();


        Test.setMock(HttpCalloutMock.class, new BuildingMockHttpResponseGenerator());

        List<Business_Unit__c> lstBusinessUnit = new List<Business_Unit__c>();
        HttpResponse response = new HttpResponse();
        Database.BatchableContext bc;

        sbu3.start(bc);
        sbu3.execute(bc, lstBusinessUnit);
        sbu3.finish(bc);

        String jsonResponse = '{"pagination": {"total_pages": 1,"page": 1},"data": [{"city": "ALBANY","code": "73810","name": "ALBANY BROOKS GARDEN","building_key": "2","country": "AUSTRALIA","address": "CNR CHESTER PASS & CATALINA ROADS","state": "WA","postcode": "6330","timestamp": "2016-10-17 19:56:04","centre_key": "52"},{"city": "ARMIDALE","code": "73910","name": "ARMIDALE CENTRAL","building_key": "3","country": "AUSTRALIA","address": "225 BEARDY STREET","state": "NSW","postcode": "2350","timestamp": "2016-10-17 19:56:04","centre_key": "52"}]}';
        sbu3.save(jsonResponse);

        Test.stopTest();


    }

    static testMethod void testBehaviorWithBusinessUnit() {
        Business_Unit__c myBusiness_unit = new Business_Unit__c(Name = 'BU1', Business_Unit_Key__c = '264');

        Test.startTest();

        ScheduleBusinessUnitV3 sbu1 = new ScheduleBusinessUnitV3(1);
        ScheduleBusinessUnitV3 sbu2 = new ScheduleBusinessUnitV3('ABC', 1, 2);
        ScheduleBusinessUnitV3 sbu3 = new ScheduleBusinessUnitV3();


        Test.setMock(HttpCalloutMock.class, new BuildingMockHttpResponseGenerator());

        List<Business_Unit__c> lstBusinessUnit = new List<Business_Unit__c>();
        HttpResponse response = new HttpResponse();
        Database.BatchableContext bc;

        lstBusinessUnit.add(myBusiness_unit);

        sbu3.start(bc);
        sbu3.execute(bc, lstBusinessUnit);
        sbu3.finish(bc);

        String jsonResponse = '{"pagination":    {"total_pages": 6,"page": 1},"data":    [{"business_unit_description": "MODEL BALANCE SHEET CHART (2)","business_unit_code": "BS","last_updated": "1995-10-11","business_unit_key": "264"}]}';
        sbu3.save(jsonResponse);

        Test.stopTest();


    }

    global class BuildingMockHttpResponseGenerator implements HttpCalloutMock {
        global HTTPResponse respond(HTTPRequest req) {

            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setHeader('Location', 'https://cs31.salesforce.com');
            res.setBody('{"pagination": {"total_pages": 1,"page": 1},"data": [{"code": "1","name": "Chadstone","country": "Australia","Longitude": "145.12453600","state": "VIC","postcode": "3199","address": "28 Beach Street","latitude": "-38.14116900","centre_key": "1","contract_number": "1"},{"code": "10","name": " ","country": "Australia","Longitude": "144.91977300","state": "VIC","postcode": "3047","address": "1099-1169 Pascoe Vale Road","latitude": "-37.67951900","centre_key": "2","contract_number": "1"}]}');
            res.setStatusCode(302);
            return res;
        }
    }
}