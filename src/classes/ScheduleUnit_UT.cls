/*
    Date        : 18-10-2016
	Project     : Lease Management System
    Description : Unit test class for ScheduleUnit batch class
    
    Change History
    --------------      
*/
@isTest
global class ScheduleUnit_UT {
	
	public static testMethod void  createSchedule() {
				
		// Create centre
		Centre__c objCentre = VC_UnitTestFactory.buildTestCentre();
		objCentre.Centre_Key__c = '1';
		insert objCentre;
		
		// Create building
		Building__c objBuilding = VC_UnitTestFactory.buildTestBuilding();
		objBuilding.Centre_Key__c = objCentre.Centre_Key__c;
		objBuilding.Centre__c = objCentre.Id;
		objBuilding.Building_Key__c = '78';
		insert objBuilding;
		
		// Create unit
		Unit__c objUnit1 = VC_UnitTestFactory.buildTestUnit();
		objUnit1.Centre_Key__c = objCentre.Centre_Key__c;
		objUnit1.Centre__c = objCentre.Id;
		objUnit1.Building_Key__c = objBuilding.Building_Key__c;
		objUnit1.Building__c = objBuilding.Id;
		objUnit1.Unit_Key__c = '1';
		insert objUnit1;
		
		Unit__c objUnit2 = VC_UnitTestFactory.buildTestUnit();
		objUnit2.Centre_Key__c = objCentre.Centre_Key__c;
		objUnit2.Centre__c = objCentre.Id;
		objUnit2.Building_Key__c = objBuilding.Building_Key__c;
		objUnit2.Building__c = objBuilding.Id;
		objUnit1.Unit_Key__c = '2';
		insert objUnit2;
		
		Account objAccount = VC_UnitTestFactory.buildTestAccount();
		insert objAccount;
		
		Map<String,Id> mapCentre = new Map<String,Id>();
		mapCentre.put('1', objCentre.Id);
		 
		Map<String,Id> mapBuilding = new Map<String,Id>();
		mapBuilding.put('78', objBuilding.Id);
		
		Map<String,Id> mapTenant = new Map<String,Id>();
		mapBuilding.put('78', objAccount.Id);
		
		ScheduleUnit sc1 = new ScheduleUnit();
		ScheduleUnit sc2 = new ScheduleUnit(1);
		ScheduleUnit sc3 = new ScheduleUnit('ABC',1,2,mapCentre,mapBuilding, mapTenant, new Map<String,Id>());
		
		Test.setMock(HttpCalloutMock.class, new UnitMockHttpResponseGenerator());
		
		List<Unit__c> lstUnit = new List<Unit__c>();
		HttpResponse response = new HttpResponse();
		Database.BatchableContext  bc;

		sc3.start(bc);
		sc3.execute(bc,lstUnit);
		sc3.finish(bc);
		//sc3.hasRedirect(response);
		
		String jsonResponse = '{"pagination": {"total_pages": 1,"page": 1},"data": [{"unit_name": "00001","end_date": "2008-10-31","area": "346.0","building_key": "78","timestamp": "2016-10-18 01:03:26","floor": "EXT","unit_key": "1","unit_type_deal_name": "10RTL","unit_type_deal_code": "Retail Specialty","centre_key": "1","start_date": "1975-01-01"},{"unit_name": "00001","end_date": "","area": "831.0","building_key": "78","timestamp": "2016-10-18 01:03:26","floor": "BLD2","unit_key": "2","unit_type_deal_name": "28MIN","unit_type_deal_code": "Mini-Majors","centre_key": "1","start_date": "2005-01-01"}]}';
		sc3.save(jsonResponse);
	}
	
	    global class UnitMockHttpResponseGenerator implements HttpCalloutMock {
	    global HTTPResponse respond(HTTPRequest req) {
	        
	        HttpResponse res = new HttpResponse();
	        res.setHeader('Content-Type', 'application/json');
	        res.setBody('{"pagination": {"total_pages": 1,"page": 1},"data": [{"unit_name": "00001","end_date": "2008-10-31","area": "346.0","building_key": "78","timestamp": "2016-10-18 01:03:26","floor": "EXT","unit_key": "1","unit_type_deal_name": "10RTL","unit_type_deal_code": "Retail Specialty","centre_key": "1","start_date": "1975-01-01"},{"unit_name": "00001","end_date": "","area": "831.0","building_key": "78","timestamp": "2016-10-18 01:03:26","floor": "BLD2","unit_key": "2","unit_type_deal_name": "28MIN","unit_type_deal_code": "Mini-Majors","centre_key": "1","start_date": "2005-01-01"}]}');
	        res.setStatusCode(200);
	        return res;
	    }
	}
}