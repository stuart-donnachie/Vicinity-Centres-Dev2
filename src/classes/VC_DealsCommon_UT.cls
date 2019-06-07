@isTest 
public class VC_DealsCommon_UT {
    static testMethod void myTest1() {

		// Create Account
		Account objAccount = VC_UnitTestFactory.buildTestAccount();
		insert objAccount;
		
		// Create Authorised Rep
		Contact objContact = VC_UnitTestFactory.buildTenantRep();
		objContact.Tenant_Rep_Type__c = 'Authorised Representative';
		insert objContact;
		
		// Create centre
		Centre__c objCentre = VC_UnitTestFactory.buildTestCentre();
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
		objOpp.Retail_Act_Applies__c = 'Y';
		objOpp.Recovery_Type__c = 'Net';
		objOpp.Estimated_Lease_Commencement_Date__c = Date.today();
		
		insert objOpp;

		test.startTest();
		
		VC_DealsCommon dc = new VC_DealsCommon();
		objOpp = dc.getDeal(objOpp.Id);
		VC_DealsCommon dc2 = new VC_DealsCommon(new ApexPages.StandardController(objOpp));
    	Decimal d = dc2.calculateOutgoings();
    	Decimal d2 = dc2.calculateRatesAndTaxes();
    	List<Centre_Outgoings__c> outgoings = dc2.queryOutgoings('OT', Date.today());
    	List<Rates_and_Taxes__c> northgateRates = dc2.queryNortgateOutgoings(Date.today());
    	List<Centre_Outgoings__c> outgoingsCrit = dc2.queryOutgoingsCrit('OT');
    	Integer i = dc2.checkRate('CR', 'NL', Date.today());
    	Integer i2 = dc2.checkRate('CR', 'N', Date.today());

    	test.stopTest();
    }
    
    static testMethod void myTest2() {

		// Create Account
		Account objAccount = VC_UnitTestFactory.buildTestAccount();
		insert objAccount;
		
		// Create Authorised Rep
		Contact objContact = VC_UnitTestFactory.buildTenantRep();
		objContact.Tenant_Rep_Type__c = 'Authorised Representative';
		insert objContact;
		
		// Create centre
		Centre__c objCentre = VC_UnitTestFactory.buildTestCentre();
		objCentre.Name = 'Paradise Centre';
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
		objOpp.Retail_Act_Applies__c = 'Y';
		objOpp.Recovery_Type__c = 'Net';
		
		insert objOpp;

		test.startTest();
		
		VC_DealsCommon dc = new VC_DealsCommon();
		objOpp = dc.getDeal(objOpp.Id);
		VC_DealsCommon dc2 = new VC_DealsCommon(objOpp);

    	Decimal d = dc2.calculateOutgoings();
    	Decimal d2 = dc2.calculateRatesAndTaxes();

    	test.stopTest();
    }
    
    static testMethod void myTest3() {

		// Create Account
		Account objAccount = VC_UnitTestFactory.buildTestAccount();
		insert objAccount;
		
		// Create Authorised Rep
		Contact objContact = VC_UnitTestFactory.buildTenantRep();
		objContact.Tenant_Rep_Type__c = 'Authorised Representative';
		insert objContact;
		
		// Create centre
		Centre__c objCentre = VC_UnitTestFactory.buildTestCentre();
		objCentre.Name = 'Northgate';
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
		objOpp.Retail_Act_Applies__c = 'Y';
		objOpp.Recovery_Type__c = 'Net';
		
		insert objOpp;

		test.startTest();
		
		VC_DealsCommon dc = new VC_DealsCommon();
		objOpp = dc.getDeal(objOpp.Id);
		VC_DealsCommon dc2 = new VC_DealsCommon(objOpp);
    	Decimal d = dc2.calculateOutgoings();
    	Decimal d2 = dc2.calculateRatesAndTaxes();

    	test.stopTest();
    }
    
    static testMethod void myTest4() {

		// Create Account
		Account objAccount = VC_UnitTestFactory.buildTestAccount();
		insert objAccount;
		
		// Create Authorised Rep
		Contact objContact = VC_UnitTestFactory.buildTenantRep();
		objContact.Tenant_Rep_Type__c = 'Authorised Representative';
		insert objContact;
		
		// Create centre
		Centre__c objCentre = VC_UnitTestFactory.buildTestCentre();
		objCentre.Name = 'Northgate';
		objCentre.State__c = 'QLD';
		insert objCentre;
		
		// Create building
		Building__c objBuilding = VC_UnitTestFactory.buildTestBuilding();
		objBuilding.Centre_Key__c = objCentre.Centre_Key__c;
		objBuilding.Centre__c = objCentre.Id;
		objBuilding.State__c = 'QLD';
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
		objOpp.Retail_Act_Applies__c = 'Y';
		objOpp.Recovery_Type__c = 'Net';
		
		insert objOpp;

		test.startTest();
		
		VC_DealsCommon dc = new VC_DealsCommon();
		objOpp = dc.getDeal(objOpp.Id);
		VC_DealsCommon dc2 = new VC_DealsCommon(objOpp);
    	Decimal d = dc2.calculateOutgoings();
    	Decimal d2 = dc2.calculateRatesAndTaxes();

    	test.stopTest();
    }
}