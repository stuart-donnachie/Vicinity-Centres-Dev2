@isTest 
public class VC_Units_Controller_UT {


    static testMethod void unitTest1() {
    	
    	Unit__c newUnit1 = new Unit__c();
    	insert newUnit1;
    	
		test.startTest();
		Opportunity newOpp1 = new Opportunity();
		newOpp1.Name = 'test';
		newOpp1.StageName = 'test';
		newOpp1.CloseDate = Date.today();
		newOpp1.Lease_Incentive_Amount__c = 5;
		newOpp1.Unit__c = newUnit1.Id;
		insert newOpp1;
		
		
		newUnit1.Preferred_Tenant__c = newOpp1.Id;
		newUnit1.Current_Tenant_Planned_End__c = Date.today();
		newUnit1.Estimated_Rent_Start__c = Date.today();
		newUnit1.Estimated_Rent_End__c = Date.today();
		newUnit1.Forecast_Base_Rent__c = 1000;
		newUnit1.System_Unit_Category__c = 'Vacancy';
		update newUnit1;
		
		newUnit1.System_Unit_Category__c = 'Opportunity';
		update newUnit1;
		
		newOpp1.Unit__c = newUnit1.Id;
		update newOpp1;
		
		Test.setCurrentPageReference(new PageReference('Page.VC_Unit'));

    	Apexpages.Standardcontroller stdController = new Apexpages.Standardcontroller(newUnit1);
    	
    	VC_Units_Controller controller = new VC_Units_Controller(stdController);
    	
    	List<SelectOption> opps = controller.OpportunitiesForSearch;
    	controller.debug = 'test'; 
    	//controller.addErrorMessage();
    	controller.customEdit();
    	//controller.SetEdit();
    	controller.customSave();
    	controller.createDeal();
    	controller.refreshFields();
    	String finalUrl = controller.getFinalUrl();
    	
    	test.stopTest();
    }

	static testMethod void testRatesAndOutgoingsLogic(){

		// Create the data to enable this testing
		VC_UnitTestFactory.createTestDataRatesAndOutgoings();

		test.startTest();

		// Start Test
		Test.setCurrentPageReference(new PageReference('Page.VC_Unit'));

		List<Unit__c> units = new List<Unit__c>([SELECT Id, Building__c, Building__r.State__c, Building__r.Business_Unit__c, Building__r.Centre__r.Name, Preferred_Tenant__c, Area_of_Premises__c FROM Unit__c]);

		for (Unit__c unit : units) {
			Apexpages.Standardcontroller stdController = new Apexpages.Standardcontroller(unit);

			VC_Units_Controller controller = new VC_Units_Controller(stdController);
		}

	/*	List<SelectOption> opps = controller.OpportunitiesForSearch;
		controller.debug = 'test';
		controller.customEdit();
		controller.customSave();
		controller.createDeal();
		controller.refreshFields();
		String finalUrl = controller.getFinalUrl();*/

		// Stop Test
		test.stopTest();


		// Asserts

	}
}