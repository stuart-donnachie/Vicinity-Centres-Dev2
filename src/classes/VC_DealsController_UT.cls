/*
    Date        : 17-10-2016
	Project     : Lease Management System
    Description : Unit test class for VC_DealsController

    Change History
    --------------
*/
@isTest
global class VC_DealsController_UT {

	// When a new standard deal is created
	public static testMethod void  newStandardDeal() {

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

		// Create opportunity
		Opportunity objOpp =  VC_UnitTestFactory.buildTestOpportunity();
		objOpp.AccountId = objAccount.Id;
		objOpp.Deal_Type__c = 'New Tenant Standard';
		objOpp.Building__c = objBuilding.Id;
		objOpp.Existing_Retailer__c = true;
		objOpp.Unit__c = objUnit.Id;
		objOpp.Development_Unit__c = true;
		insert objOpp;

		ApexPages.currentPage().getParameters().put('id', objOpp.Id);
		//VC_DealsController vcdeal = new VC_DealsController();
		VC_DealsController vcdeals = new VC_DealsController(new ApexPages.StandardController(objOpp));

		vcdeals.objOpp = objOpp;
		vcdeals.oppId = objOpp.Id;
		//vcdeals.dealStage = objOpp.StageName;
		//vcdeals.selectedDealType = 'New Tenant Standard';
		//vcdeals.selectedDealStage = objOpp.StageName;
		//vcdeals.dealName = objOpp.Name;

		//vcdeals.getDealTypes();
		//vcdeals.getDealStages();
		vcdeals.createDeal();
	 	vcdeals.cancelDeal();
	 	//vcdeals.refreshAction();
	 	//vcdeals.refreshDevUnit();
	 	vcdeals.refreshFields();

	 	System.assertEquals(objOpp.Id, vcdeals.oppId);
	}

	// When a new renewal deal is created
	public static testMethod void  newRenewalDeal() {

		// Create centre
		Centre__c objCentre = VC_UnitTestFactory.buildTestCentre();
		objCentre.Centre_Code__c = '100';
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
		objUnit.Unit_Code__c = '40OFF';
		objUnit.Building_Key__c = objBuilding.Building_Key__c;
		objUnit.Building__c = objBuilding.Id;
		insert objUnit;

		// Create Account
		Account objAccount = VC_UnitTestFactory.buildTestAccount();
		insert objAccount;

		// Create opportunity
		Opportunity objOpp =  VC_UnitTestFactory.buildTestOpportunity();
		objOpp.AccountId = objAccount.Id;
		objOpp.Deal_Type__c = 'Renewal';
		objOpp.Building__c = objBuilding.Id;
		objOpp.Unit__c = objUnit.Id;
		insert objOpp;

		ApexPages.currentPage().getParameters().put('id', objOpp.Id);
		//VC_DealsController vcdeal = new VC_DealsController();
		VC_DealsController vcdeals = new VC_DealsController(new ApexPages.StandardController(objOpp));

		vcdeals.objOpp = objOpp;
		vcdeals.oppId = objOpp.Id;
		//vcdeals.closeDate = String.valueOf(objOpp.CloseDate);
		//vcdeals.dealStage = objOpp.StageName;
		//vcdeals.selectedDealType = 'Renewal';
		//vcdeals.selectedDealStage = objOpp.StageName;

		//vcdeals.getDealTypes();
		//vcdeals.getDealStages();
		vcdeals.createDeal();
	 	vcdeals.cancelDeal();
	 	//vcdeals.refreshAction();
	 	//vcdeals.refreshDevUnit();
	 	vcdeals.refreshFields();
	}

	// When a new tenant as is deal is created
	public static testMethod void  newAsIsDeal() {

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
		insert objUnit;

		// Create Account
		Account objAccount = VC_UnitTestFactory.buildTestAccount();
		insert objAccount;

		// Create opportunity
		Opportunity objOpp =  VC_UnitTestFactory.buildTestOpportunity();
		objOpp.AccountId = objAccount.Id;
		objOpp.Deal_Type__c = 'New Tenant As Is';
		objOpp.Building__c = objBuilding.Id;
		objOpp.Unit__c = objUnit.Id;
		insert objOpp;

		ApexPages.currentPage().getParameters().put('id', objOpp.Id);
		//VC_DealsController vcdeal = new VC_DealsController();
		VC_DealsController vcdeals = new VC_DealsController(new ApexPages.StandardController(objOpp));

		vcdeals.objOpp = objOpp;
		vcdeals.oppId = objOpp.Id;
		//vcdeals.closeDate = String.valueOf(objOpp.CloseDate);
		//vcdeals.dealStage = objOpp.StageName;
		//vcdeals.selectedDealType = 'New Tenant As Is';
		//vcdeals.selectedDealStage = objOpp.StageName;

		//vcdeals.getDealTypes();
		//vcdeals.getDealStages();
		vcdeals.createDeal();
	 	vcdeals.cancelDeal();
	 	//vcdeals.refreshDevUnit();
	 	//vcdeals.refreshAction();
	 	vcdeals.refreshFields();
	}

	// When a new tenant is being added on the deal - uses default CABID
	public static testMethod void  newTenantDeal() {

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
		insert objUnit;

		// Default Account
		Account objDefAccount = VC_UnitTestFactory.buildTestDefaultAccount();
		insert objDefAccount;

		// Create opportunity
		Opportunity objOpp =  VC_UnitTestFactory.buildTestOpportunity();
		objOpp.Deal_Type__c = 'New Tenant Standard';
		objOpp.Building__c = objBuilding.Id;
		objOpp.Unit__c = objUnit.Id;
		objOpp.New_Retailer__c = true;
		insert objOpp;

		ApexPages.currentPage().getParameters().put('id', objOpp.Id);
		//VC_DealsController vcdeal = new VC_DealsController();
		VC_DealsController vcdeals = new VC_DealsController(new ApexPages.StandardController(objOpp));

		vcdeals.objOpp = objOpp;
		vcdeals.oppId = objOpp.Id;
		//vcdeals.closeDate = String.valueOf(objOpp.CloseDate);
		//vcdeals.dealStage = objOpp.StageName;
		///vcdeals.selectedDealType = 'New Tenant Standard';
		//vcdeals.selectedDealStage = objOpp.StageName;

		//vcdeals.getDealTypes();
		//vcdeals.getDealStages();
		vcdeals.createDeal();
	 	vcdeals.cancelDeal();
	 	//vcdeals.refreshDevUnit();
	 	//vcdeals.refreshAction();
	 	vcdeals.refreshFields();
	}

	// When no deal type is selected
	public static testMethod void  noDealType() {

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
		insert objUnit;

		// Create Account
		Account objAccount = VC_UnitTestFactory.buildTestAccount();
		insert objAccount;

		// Create opportunity
		Opportunity objOpp =  VC_UnitTestFactory.buildTestOpportunity();
		objOpp.AccountId = objAccount.Id;
		objOpp.Deal_Type__c = 'New Tenant Standard';
		objOpp.Building__c = objBuilding.Id;
		objOpp.Unit__c = objUnit.Id;
		objOpp.Development_Unit__c = true;
		insert objOpp;

		ApexPages.currentPage().getParameters().put('id', objOpp.Id);
		//VC_DealsController vcdeal = new VC_DealsController();
		VC_DealsController vcdeals = new VC_DealsController(new ApexPages.StandardController(objOpp));

		vcdeals.objOpp = objOpp;
		vcdeals.oppId = objOpp.Id;
		//vcdeals.closeDate = String.valueOf(objOpp.CloseDate);
		//vcdeals.dealStage = objOpp.StageName;

		//vcdeals.getDealTypes();
		//vcdeals.getDealStages();
		vcdeals.createDeal();
	 	vcdeals.cancelDeal();
	 	//vcdeals.refreshDevUnit();
	 	//vcdeals.refreshAction();
	 	vcdeals.refreshFields();
	}

	public static testMethod void myUnitTest1() {
		Test.StartTest();

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

		VC_DealsWSController.deleteDeal(objOpp);

		DealDeleteSchedule sh1 = new DealDeleteSchedule();
 		String sch = '0 0 23 * * ?';
        system.schedule('Test check', sch, sh1);

		Test.stopTest();
	}

	public static testMethod void  myUnitTest2() {


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
		insert objUnit;

		// Create Account
		Account objAccount = VC_UnitTestFactory.buildTestAccount();
		insert objAccount;

		// Create opportunity
		Opportunity objOpp =  VC_UnitTestFactory.buildTestOpportunity();
		objOpp.AccountId = objAccount.Id;
		objOpp.Existing_Retailer__c = true;
		objOpp.Deal_Type__c = 'New Tenant Standard';
		objOpp.Building__c = objBuilding.Id;
		objOpp.Unit__c = objUnit.Id;
		objOpp.Development_Unit__c = true;
		objOpp.Estimated_Lease_Commencement_Date__c = Date.today();
		objOpp.Recovery_Type__c = 'Net';
		objOpp.Retail_Act_Applies__c = 'Y';
		objOpp.Existing_Retailer__c = true;
		objOpp.Promo_Review_Rate_and_Type__c  = 'Non Standard';
		insert objOpp;

		Test.startTest();

		ApexPages.currentPage().getParameters().put('id', objOpp.Id);
		VC_DealsCommon dc = new VC_DealsCommon();
		objOpp = dc.getDeal(objOpp.Id);
		VC_DealsController vcdeals = new VC_DealsController(new ApexPages.StandardController(objOpp));

		vcdeals.objOpp = objOpp;
		vcdeals.oppId = objOpp.Id;
		vcdeals.refreshFields();
		vcdeals.SelectedRetailerType = 'EXISTING';
		vcdeals.SetRetailerType();
		vcdeals.SelectedRetailerType = 'NEW';
		vcdeals.SetRetailerType();
	 	List<Account> acc = VC_DealsController.queryAccounts('test');

		Test.setMock(HttpCalloutMock.class, new AuthResponseMockHttpResponseGenerator());
	 	vcdeals.createDeal();
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

}