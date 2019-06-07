/*
    Date        : 17-10-2016
	Project     : Lease Management System
    Description : Unit test class for VC_DealsController

    Change History
    --------------
*/
@isTest
global class VC_Deal_DetailsController_UT {


	// Placing a new deal in ITL Stage
	public static testMethod void  newDealITL() {

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

		// Create Authorised Rep
		Contact objContact = VC_UnitTestFactory.buildTenantRep();
		objContact.Tenant_Rep_Type__c = 'Authorised Representative';
		insert objContact;

		// Create Billing Rep
		Contact objContact2 = VC_UnitTestFactory.buildTenantRep();
		objContact2.Tenant_Rep_Type__c = 'Billing Representative';
		insert objContact2;

		// Create Legal Rep
		Contact objContact3 = VC_UnitTestFactory.buildTenantRep();
		objContact3.Tenant_Rep_Type__c = 'Legal Representative';
		insert objContact3;

		// Create Guarantor Rep
		Contact objContact4 = VC_UnitTestFactory.buildTenantRep();
		objContact4.Tenant_Rep_Type__c = 'Gaurantor Representative';
		insert objContact4;

		// Create Notice Rep
		Contact objContact5 = VC_UnitTestFactory.buildTenantRep();
		objContact5.Tenant_Rep_Type__c = 'Notice Representative';
		insert objContact5;

		// Create Registered Rep
		Contact objContact6 = VC_UnitTestFactory.buildTenantRep();
		objContact6.Tenant_Rep_Type__c = 'Registered Representative';
		insert objContact6;

		// Create opportunity
		Opportunity objOpp =  VC_UnitTestFactory.buildTestOpportunity();
		objOpp.AccountId = objAccount.Id;
		objOpp.Deal_Type__c = 'New Tenant Standard';
		objOpp.Centre__c = objCentre.Id;
		objOpp.Building__c = objBuilding.Id;
		objOpp.Unit__c = objUnit.Id;
		objOpp.Development_Unit__c = true;
		objOpp.Unit_Code__c = '40OFF';
		objOpp.Promotion_Contribution_Percent__c = 15;
		objOpp.Base_Rent__c = 54000;
		objOpp.Promo_Amt_Year_1__c = 6700;
		objOpp.Recovery_Type__c = 'Net';
		objOpp.Area_of_premises_sqmt__c = 3200;
		insert objOpp;

		objOpp.Authorised_Reps__c = objContact.Id + ';';
		objOpp.Billing_Reps__c = objContact2.Id + ';';
		objOpp.Guarantor_Reps__c = objContact3.Id + ';' + objContact2.Id + ';';
		objOpp.Legal_Reps__c = objContact4.Id + ';';
		objOpp.Notice_Reps__c = objContact5.Id + ';';
		objOpp.Registration_Reps__c = objContact6.Id + ';';
		update objOpp;

		ApexPages.currentPage().getParameters().put('id', objOpp.Id);
		//VC_Deal_DetailsController vcdeal = new VC_Deal_DetailsController();
		VC_Deal_DetailsController vcdeals = new VC_Deal_DetailsController(new ApexPages.StandardController(objOpp));

		//vcdeals.selectedWorkType = null;
		vcdeals.selectedauthrep = objContact.Id;
		vcdeals.selectedbillrep = objContact.Id;
		vcdeals.selectedguarrep = objContact.Id;
		vcdeals.selectedlegrep = objContact.Id;
		vcdeals.selectednoticerep = objContact.Id;
		vcdeals.selectedregrep = objContact.Id;

		vcdeals.unselectauthrep = objContact.Id;
		vcdeals.unselectbillrep = objContact.Id;
		vcdeals.unselectguarrep = objContact.Id;
		vcdeals.unselectlegrep = objContact.Id;
		vcdeals.unselectnoticerep = objContact.Id;
		vcdeals.unselectregrep = objContact.Id;

		vcdeals.tenantBillingAddress = null;
		vcdeals.pageUrl = null;
		//vcdeals.exsFitOther = true;

		vcdeals.getAuthReps();
		vcdeals.getOpportunityAuthReps();
		vcdeals.getBillReps();
		vcdeals.getOpportunityBillReps();
		vcdeals.getGuarReps();
		vcdeals.getOpportunityGuarReps();
		vcdeals.getLegalReps();
		vcdeals.getOpportunityLegalReps();
		vcdeals.getNoticeReps();
		vcdeals.getOpportunityNoticeReps();
		////vcdeals.getRegReps();
		vcdeals.getOpportunityRegReps();
		//vcdeals.getAllWorkTypes();

		vcdeals.saveDeal();
		vcdeals.cancelDeal();
		////vcdeals.dealRules();
		vcdeals.refreshField();
		//vcdeals.loifDone();
		vcdeals.pageReload();
		vcdeals.setReps();
		vcdeals.delReps();
		vcdeals.setBillReps();
		vcdeals.delBillReps();
		vcdeals.setGuarReps();
		vcdeals.delGuarReps();
		vcdeals.setlegalReps();
		vcdeals.dellegalReps();
		vcdeals.setnoticeReps();
		vcdeals.delnoticeReps();
		vcdeals.setregReps();
		vcdeals.delregReps();

		System.assertEquals(objCentre.Id,objOpp.Centre__c);
	}

	// Placing a new deal in the Deal Builder stage
	public static testMethod void  newDealBuilder() {

		// Create centre
		Centre__c objCentre = VC_UnitTestFactory.buildTestCentre();
		objCentre.Name = 'DFO Homebush';
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

		// Create Authorised Rep
		Contact objContact = VC_UnitTestFactory.buildTenantRep();
		objContact.Tenant_Rep_Type__c = 'Authorised Representative';
		insert objContact;

		// Create opportunity
		Opportunity objOpp =  VC_UnitTestFactory.buildTestOpportunity();
		objOpp.AccountId = objAccount.Id;
		objOpp.Deal_Type__c = 'New Tenant Standard';
		objOpp.Centre__c = objCentre.Id;
		objOpp.Building__c = objBuilding.Id;
		objOpp.Unit__c = objUnit.Id;
		objOpp.Development_Unit__c = true;
		objOpp.Unit_Code__c = '40OFF';
		objOpp.Promotion_Contribution_Percent__c = 5;
		objOpp.Base_Rent__c = 54000;
		objOpp.Promo_Amt_Year_1__c = 6700;
		objOpp.Authorised_Reps__c = objContact.Id + ';';
		objOpp.Billing_Reps__c = objContact.Id + ';';
		objOpp.Guarantor_Reps__c = objContact.Id + ';';
		objOpp.Legal_Reps__c = objContact.Id + ';';
		objOpp.Notice_Reps__c = objContact.Id + ';';
		objOpp.Registration_Reps__c = objContact.Id + ';';
		objOpp.StageName = 'Deal Builder';
		objOpp.Area_of_premises_sqmt__c = 3200;
		insert objOpp;

		ApexPages.currentPage().getParameters().put('id', objOpp.Id);
		//VC_Deal_DetailsController vcdeal = new VC_Deal_DetailsController();
		VC_Deal_DetailsController vcdeals = new VC_Deal_DetailsController(new ApexPages.StandardController(objOpp));

		//vcdeals.selectedWorkType = 'DFO Homebush';
		vcdeals.selectedauthrep = objContact.Id;
		vcdeals.selectedbillrep = objContact.Id;
		vcdeals.selectedguarrep = objContact.Id;
		vcdeals.selectedlegrep = objContact.Id;
		vcdeals.selectednoticerep = objContact.Id;
		vcdeals.selectedregrep = objContact.Id;

		vcdeals.unselectauthrep = objContact.Id;
		vcdeals.unselectbillrep = objContact.Id;
		vcdeals.unselectguarrep = objContact.Id;
		vcdeals.unselectlegrep = objContact.Id;
		vcdeals.unselectnoticerep = objContact.Id;
		vcdeals.unselectregrep = objContact.Id;

		vcdeals.tenantBillingAddress = null;
		vcdeals.pageUrl = null;
		//vcdeals.exsFitOther = true;

		vcdeals.getAuthReps();
		vcdeals.getOpportunityAuthReps();
		vcdeals.getBillReps();
		vcdeals.getOpportunityBillReps();
		vcdeals.getGuarReps();
		vcdeals.getOpportunityGuarReps();
		vcdeals.getLegalReps();
		vcdeals.getOpportunityLegalReps();
		vcdeals.getNoticeReps();
		vcdeals.getOpportunityNoticeReps();
		//vcdeals.getRegReps();
		vcdeals.getOpportunityRegReps();
		//vcdeals.getAllWorkTypes();

		vcdeals.saveDeal();
		vcdeals.cancelDeal();
		vcdeals.refreshField();
		//vcdeals.loifDone();
		vcdeals.pageReload();
		vcdeals.setReps();
		vcdeals.delReps();
		vcdeals.setBillReps();
		vcdeals.delBillReps();
		vcdeals.setGuarReps();
		vcdeals.delGuarReps();
		vcdeals.setlegalReps();
		vcdeals.dellegalReps();
		vcdeals.setnoticeReps();
		vcdeals.delnoticeReps();
		vcdeals.setregReps();
		vcdeals.delregReps();
	}

	// Placing a new deal in the Lease Offer stage
	public static testMethod void  newDealLeaseOffer() {

		// Create centre
		Centre__c objCentre = VC_UnitTestFactory.buildTestCentre();
		objCentre.Name = 'Emporium';
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

		// Create Authorised Rep
		Contact objContact = VC_UnitTestFactory.buildTenantRep();
		objContact.Tenant_Rep_Type__c = 'Authorised Representative';
		insert objContact;

		// Create opportunity
		Opportunity objOpp =  VC_UnitTestFactory.buildTestOpportunity();
		objOpp.AccountId = objAccount.Id;
		objOpp.Deal_Type__c = 'Renewal';
		objOpp.Centre__c = objCentre.Id;
		objOpp.Building__c = objBuilding.Id;
		objOpp.Unit__c = objUnit.Id;
		objOpp.Unit_Code__c = '40OFF';
		objOpp.Promotion_Contribution_Percent__c = 5;
		objOpp.Base_Rent__c = 54000;
		objOpp.Promo_Amt_Year_1__c = 6700;
		objOpp.Authorised_Reps__c = objContact.Id + ';';
		objOpp.Billing_Reps__c = objContact.Id + ';';
		objOpp.Guarantor_Reps__c = objContact.Id + ';';
		objOpp.Legal_Reps__c = objContact.Id + ';';
		objOpp.Notice_Reps__c = objContact.Id + ';';
		objOpp.Registration_Reps__c = objContact.Id + ';';
		objOpp.StageName = 'Lease Offer';
		objOpp.Area_of_premises_sqmt__c = 3200;
		insert objOpp;

		ApexPages.currentPage().getParameters().put('id', objOpp.Id);
		//VC_Deal_DetailsController vcdeal = new VC_Deal_DetailsController();
		VC_Deal_DetailsController vcdeals = new VC_Deal_DetailsController(new ApexPages.StandardController(objOpp));

		//vcdeals.selectedWorkType = null;
		vcdeals.selectedauthrep = objContact.Id;
		vcdeals.selectedbillrep = objContact.Id;
		vcdeals.selectedguarrep = objContact.Id;
		vcdeals.selectedlegrep = objContact.Id;
		vcdeals.selectednoticerep = objContact.Id;
		vcdeals.selectedregrep = objContact.Id;

		vcdeals.unselectauthrep = objContact.Id;
		vcdeals.unselectbillrep = objContact.Id;
		vcdeals.unselectguarrep = objContact.Id;
		vcdeals.unselectlegrep = objContact.Id;
		vcdeals.unselectnoticerep = objContact.Id;
		vcdeals.unselectregrep = objContact.Id;

		vcdeals.tenantBillingAddress = null;
		vcdeals.pageUrl = null;
		//vcdeals.exsFitOther = true;

		vcdeals.getAuthReps();
		vcdeals.getOpportunityAuthReps();
		vcdeals.getBillReps();
		vcdeals.getOpportunityBillReps();
		vcdeals.getGuarReps();
		vcdeals.getOpportunityGuarReps();
		vcdeals.getLegalReps();
		vcdeals.getOpportunityLegalReps();
		vcdeals.getNoticeReps();
		vcdeals.getOpportunityNoticeReps();
		//vcdeals.getRegReps();
		vcdeals.getOpportunityRegReps();
		//vcdeals.getAllWorkTypes();

		vcdeals.saveDeal();
		vcdeals.cancelDeal();
		////vcdeals.dealRules();
		vcdeals.refreshField();
		//vcdeals.loifDone();
		vcdeals.pageReload();
		vcdeals.setReps();
		vcdeals.delReps();
		vcdeals.setBillReps();
		vcdeals.delBillReps();
		vcdeals.setGuarReps();
		vcdeals.delGuarReps();
		vcdeals.setlegalReps();
		vcdeals.dellegalReps();
		vcdeals.setnoticeReps();
		vcdeals.delnoticeReps();
		vcdeals.setregReps();
		vcdeals.delregReps();
	}

	// Placing a new deal in the Lease Offer Approval stage
	public static testMethod void  newDealLeaseOfferApproval() {

		// Create centre
		Centre__c objCentre = VC_UnitTestFactory.buildTestCentre();
		objCentre.Name = 'Emporium';
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

		// Create Authorised Rep
		Contact objContact = VC_UnitTestFactory.buildTenantRep();
		objContact.Tenant_Rep_Type__c = 'Authorised Representative';
		insert objContact;

		// Create opportunity
		Opportunity objOpp =  VC_UnitTestFactory.buildTestOpportunity();
		objOpp.AccountId = objAccount.Id;
		objOpp.Deal_Type__c = 'Renewal';
		objOpp.Centre__c = objCentre.Id;
		objOpp.Building__c = objBuilding.Id;
		objOpp.Unit__c = objUnit.Id;
		objOpp.Unit_Code__c = '40OFF';
		objOpp.Promotion_Contribution_Percent__c = 5;
		objOpp.Base_Rent__c = 54000;
		objOpp.Promo_Amt_Year_1__c = 6700;
		objOpp.Authorised_Reps__c = objContact.Id + ';';
		objOpp.Billing_Reps__c = objContact.Id + ';';
		objOpp.Guarantor_Reps__c = objContact.Id + ';';
		objOpp.Legal_Reps__c = objContact.Id + ';';
		objOpp.Notice_Reps__c = objContact.Id + ';';
		objOpp.Registration_Reps__c = objContact.Id + ';';
		objOpp.StageName = 'Lease Offer Approval';
		objOpp.Area_of_premises_sqmt__c = 3200;
		insert objOpp;

		ApexPages.currentPage().getParameters().put('id', objOpp.Id);
		//VC_Deal_DetailsController vcdeal = new VC_Deal_DetailsController();
		VC_Deal_DetailsController vcdeals = new VC_Deal_DetailsController(new ApexPages.StandardController(objOpp));

		//vcdeals.selectedWorkType = 'Emporium';
		vcdeals.selectedauthrep = objContact.Id;
		vcdeals.selectedbillrep = objContact.Id;
		vcdeals.selectedguarrep = objContact.Id;
		vcdeals.selectedlegrep = objContact.Id;
		vcdeals.selectednoticerep = objContact.Id;
		vcdeals.selectedregrep = objContact.Id;

		vcdeals.unselectauthrep = objContact.Id;
		vcdeals.unselectbillrep = objContact.Id;
		vcdeals.unselectguarrep = objContact.Id;
		vcdeals.unselectlegrep = objContact.Id;
		vcdeals.unselectnoticerep = objContact.Id;
		vcdeals.unselectregrep = objContact.Id;

		vcdeals.tenantBillingAddress = null;
		vcdeals.pageUrl = null;
		//vcdeals.exsFitOther = true;

		vcdeals.getAuthReps();
		vcdeals.getOpportunityAuthReps();
		vcdeals.getBillReps();
		vcdeals.getOpportunityBillReps();
		vcdeals.getGuarReps();
		vcdeals.getOpportunityGuarReps();
		vcdeals.getLegalReps();
		vcdeals.getOpportunityLegalReps();
		vcdeals.getNoticeReps();
		vcdeals.getOpportunityNoticeReps();
		//vcdeals.getRegReps();
		vcdeals.getOpportunityRegReps();
		//vcdeals.getAllWorkTypes();

		vcdeals.saveDeal();
		vcdeals.cancelDeal();
		////vcdeals.dealRules();
		vcdeals.refreshField();
		//vcdeals.loifDone();
		vcdeals.pageReload();
		vcdeals.setReps();
		vcdeals.delReps();
		vcdeals.setBillReps();
		vcdeals.delBillReps();
		vcdeals.setGuarReps();
		vcdeals.delGuarReps();
		vcdeals.setlegalReps();
		vcdeals.dellegalReps();
		vcdeals.setnoticeReps();
		vcdeals.delnoticeReps();
		vcdeals.setregReps();
		vcdeals.delregReps();
	}

	// Placing a new deal in the Proceed Now Stage
	public static testMethod void  newDealProceedNow() {

		// Create centre
		Centre__c objCentre = VC_UnitTestFactory.buildTestCentre();
		objCentre.Name = 'Emporium';
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

		// Create Authorised Rep
		Contact objContact = VC_UnitTestFactory.buildTenantRep();
		objContact.Tenant_Rep_Type__c = 'Authorised Representative';
		insert objContact;

		// Create opportunity
		Opportunity objOpp =  VC_UnitTestFactory.buildTestOpportunity();
		objOpp.AccountId = objAccount.Id;
		objOpp.Deal_Type__c = 'Renewal';
		objOpp.Centre__c = objCentre.Id;
		objOpp.Building__c = objBuilding.Id;
		objOpp.Unit__c = objUnit.Id;
		objOpp.Unit_Code__c = '40OFF';
		objOpp.Promotion_Contribution_Percent__c = 5;
		objOpp.Base_Rent__c = 54000;
		objOpp.Promo_Amt_Year_1__c = 6700;
		objOpp.Authorised_Reps__c = objContact.Id + ';';
		objOpp.Billing_Reps__c = objContact.Id + ';';
		objOpp.Guarantor_Reps__c = objContact.Id + ';';
		objOpp.Legal_Reps__c = objContact.Id + ';';
		objOpp.Notice_Reps__c = objContact.Id + ';';
		objOpp.Registration_Reps__c = objContact.Id + ';';
		objOpp.StageName = 'Proceed Now';
		objOpp.Recovery_Type__c = 'Gross';
		objOpp.Area_of_premises_sqmt__c = 3200;
		insert objOpp;

		ApexPages.currentPage().getParameters().put('id', objOpp.Id);
		//VC_Deal_DetailsController vcdeal = new VC_Deal_DetailsController();
		VC_Deal_DetailsController vcdeals = new VC_Deal_DetailsController(new ApexPages.StandardController(objOpp));

		//vcdeals.selectedWorkType = 'Emporium';
		vcdeals.selectedauthrep = objContact.Id;
		vcdeals.selectedbillrep = objContact.Id;
		vcdeals.selectedguarrep = objContact.Id;
		vcdeals.selectedlegrep = objContact.Id;
		vcdeals.selectednoticerep = objContact.Id;
		vcdeals.selectedregrep = objContact.Id;

		vcdeals.unselectauthrep = objContact.Id;
		vcdeals.unselectbillrep = objContact.Id;
		vcdeals.unselectguarrep = objContact.Id;
		vcdeals.unselectlegrep = objContact.Id;
		vcdeals.unselectnoticerep = objContact.Id;
		vcdeals.unselectregrep = objContact.Id;

		vcdeals.tenantBillingAddress = null;
		vcdeals.pageUrl = null;
		//vcdeals.exsFitOther = true;

		vcdeals.getAuthReps();
		vcdeals.getOpportunityAuthReps();
		vcdeals.getBillReps();
		vcdeals.getOpportunityBillReps();
		vcdeals.getGuarReps();
		vcdeals.getOpportunityGuarReps();
		vcdeals.getLegalReps();
		vcdeals.getOpportunityLegalReps();
		vcdeals.getNoticeReps();
		vcdeals.getOpportunityNoticeReps();
		//vcdeals.getRegReps();
		vcdeals.getOpportunityRegReps();
		//vcdeals.getAllWorkTypes();

		vcdeals.saveDeal();
		vcdeals.cancelDeal();
		//vcdeals.dealRules();
		vcdeals.refreshField();
		//vcdeals.loifDone();
		vcdeals.pageReload();
		vcdeals.setReps();
		vcdeals.delReps();
		vcdeals.setBillReps();
		vcdeals.delBillReps();
		vcdeals.setGuarReps();
		vcdeals.delGuarReps();
		vcdeals.setlegalReps();
		vcdeals.dellegalReps();
		vcdeals.setnoticeReps();
		vcdeals.delnoticeReps();
		vcdeals.setregReps();
		vcdeals.delregReps();
	}

	// Placing a new deal in the Key Dates Stage
	public static testMethod void  newDealKeyDates() {

		// Create centre
		Centre__c objCentre = VC_UnitTestFactory.buildTestCentre();
		objCentre.Name = 'Emporium';
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

		// Create Authorised Rep
		Contact objContact = VC_UnitTestFactory.buildTenantRep();
		objContact.Tenant_Rep_Type__c = 'Authorised Representative';
		insert objContact;

		// Create opportunity
		Opportunity objOpp =  VC_UnitTestFactory.buildTestOpportunity();
		objOpp.AccountId = objAccount.Id;
		objOpp.Deal_Type__c = 'Renewal';
		objOpp.Centre__c = objCentre.Id;
		objOpp.Building__c = objBuilding.Id;
		objOpp.Unit__c = objUnit.Id;
		objOpp.Unit_Code__c = '40OFF';
		objOpp.Promotion_Contribution_Percent__c = 5;
		objOpp.Base_Rent__c = 54000;
		objOpp.Promo_Amt_Year_1__c = 6700;
		objOpp.Authorised_Reps__c = objContact.Id + ';';
		objOpp.Billing_Reps__c = objContact.Id + ';';
		objOpp.Guarantor_Reps__c = objContact.Id + ';';
		objOpp.Legal_Reps__c = objContact.Id + ';';
		objOpp.Notice_Reps__c = objContact.Id + ';';
		objOpp.Registration_Reps__c = objContact.Id + ';';
		objOpp.StageName = 'Key Dates';
		objOpp.Date_of_Actual_Handover__c = system.today();
		objOpp.Common_Opening_Date__c = system.today()+1;
		objOpp.Recovery_Type__c = 'Gross';
		objOpp.Area_of_premises_sqmt__c = 3200;
		insert objOpp;

		ApexPages.currentPage().getParameters().put('id', objOpp.Id);
		//VC_Deal_DetailsController vcdeal = new VC_Deal_DetailsController();
		VC_Deal_DetailsController vcdeals = new VC_Deal_DetailsController(new ApexPages.StandardController(objOpp));

		//vcdeals.selectedWorkType = 'Emporium';
		vcdeals.selectedauthrep = objContact.Id;
		vcdeals.selectedbillrep = objContact.Id;
		vcdeals.selectedguarrep = objContact.Id;
		vcdeals.selectedlegrep = objContact.Id;
		vcdeals.selectednoticerep = objContact.Id;
		vcdeals.selectedregrep = objContact.Id;

		vcdeals.unselectauthrep = objContact.Id;
		vcdeals.unselectbillrep = objContact.Id;
		vcdeals.unselectguarrep = objContact.Id;
		vcdeals.unselectlegrep = objContact.Id;
		vcdeals.unselectnoticerep = objContact.Id;
		vcdeals.unselectregrep = objContact.Id;

		vcdeals.tenantBillingAddress = null;
		vcdeals.pageUrl = null;
		//vcdeals.exsFitOther = true;

		vcdeals.getAuthReps();
		vcdeals.getOpportunityAuthReps();
		vcdeals.getBillReps();
		vcdeals.getOpportunityBillReps();
		vcdeals.getGuarReps();
		vcdeals.getOpportunityGuarReps();
		vcdeals.getLegalReps();
		vcdeals.getOpportunityLegalReps();
		vcdeals.getNoticeReps();
		vcdeals.getOpportunityNoticeReps();
		//vcdeals.getRegReps();
		vcdeals.getOpportunityRegReps();
		//vcdeals.getAllWorkTypes();

		vcdeals.saveDeal();
		vcdeals.cancelDeal();
		//vcdeals.dealRules();
		vcdeals.refreshField();
		//vcdeals.loifDone();
		vcdeals.pageReload();
		vcdeals.setReps();
		vcdeals.delReps();
		vcdeals.setBillReps();
		vcdeals.delBillReps();
		vcdeals.setGuarReps();
		vcdeals.delGuarReps();
		vcdeals.setlegalReps();
		vcdeals.dellegalReps();
		vcdeals.setnoticeReps();
		vcdeals.delnoticeReps();
		vcdeals.setregReps();
		vcdeals.delregReps();
	}

	// Cancelling a deal
	public static testMethod void  newDealCncelled() {

		// Create centre
		Centre__c objCentre = VC_UnitTestFactory.buildTestCentre();
		objCentre.Name = 'Emporium';
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

		// Create Authorised Rep
		Contact objContact = VC_UnitTestFactory.buildTenantRep();
		objContact.Tenant_Rep_Type__c = 'Authorised Representative';
		insert objContact;

		// Create opportunity
		Opportunity objOpp =  VC_UnitTestFactory.buildTestOpportunity();
		objOpp.AccountId = objAccount.Id;
		objOpp.Deal_Type__c = 'Renewal';
		objOpp.Centre__c = objCentre.Id;
		objOpp.Building__c = objBuilding.Id;
		objOpp.Unit__c = objUnit.Id;
		objOpp.Unit_Code__c = '40OFF';
		objOpp.Promotion_Contribution_Percent__c = 5;
		objOpp.Base_Rent__c = 54000;
		objOpp.Promo_Amt_Year_1__c = 6700;
		objOpp.Authorised_Reps__c = objContact.Id + ';';
		objOpp.Billing_Reps__c = objContact.Id + ';';
		objOpp.Guarantor_Reps__c = objContact.Id + ';';
		objOpp.Legal_Reps__c = objContact.Id + ';';
		objOpp.Notice_Reps__c = objContact.Id + ';';
		objOpp.Registration_Reps__c = objContact.Id + ';';
		objOpp.StageName = 'Proceed Now';
		objOpp.Deal_Cancelled__c = true;
		objOpp.Deal_Closure_Reason__c = 'Landlord not proceeding';
		objOpp.Area_of_premises_sqmt__c = 3200;
		insert objOpp;

		ApexPages.currentPage().getParameters().put('id', objOpp.Id);
		//VC_Deal_DetailsController vcdeal = new VC_Deal_DetailsController();
		VC_Deal_DetailsController vcdeals = new VC_Deal_DetailsController(new ApexPages.StandardController(objOpp));

		//vcdeals.selectedWorkType = 'Emporium';
		vcdeals.selectedauthrep = objContact.Id;
		vcdeals.selectedbillrep = objContact.Id;
		vcdeals.selectedguarrep = objContact.Id;
		vcdeals.selectedlegrep = objContact.Id;
		vcdeals.selectednoticerep = objContact.Id;
		vcdeals.selectedregrep = objContact.Id;

		vcdeals.unselectauthrep = objContact.Id;
		vcdeals.unselectbillrep = objContact.Id;
		vcdeals.unselectguarrep = objContact.Id;
		vcdeals.unselectlegrep = objContact.Id;
		vcdeals.unselectnoticerep = objContact.Id;
		vcdeals.unselectregrep = objContact.Id;

		vcdeals.tenantBillingAddress = null;
		vcdeals.pageUrl = null;
		//vcdeals.exsFitOther = true;

		vcdeals.getAuthReps();
		vcdeals.getOpportunityAuthReps();
		vcdeals.getBillReps();
		vcdeals.getOpportunityBillReps();
		vcdeals.getGuarReps();
		vcdeals.getOpportunityGuarReps();
		vcdeals.getLegalReps();
		vcdeals.getOpportunityLegalReps();
		vcdeals.getNoticeReps();
		vcdeals.getOpportunityNoticeReps();
		//vcdeals.getRegReps();
		vcdeals.getOpportunityRegReps();
		//vcdeals.getAllWorkTypes();

		vcdeals.saveDeal();
		vcdeals.cancelDeal();
		//vcdeals.dealRules();
		vcdeals.refreshField();
		//vcdeals.loifDone();
		vcdeals.pageReload();
		vcdeals.setReps();
		vcdeals.delReps();
		vcdeals.setBillReps();
		vcdeals.delBillReps();
		vcdeals.setGuarReps();
		vcdeals.delGuarReps();
		vcdeals.setlegalReps();
		vcdeals.dellegalReps();
		vcdeals.setnoticeReps();
		vcdeals.delnoticeReps();
		vcdeals.setregReps();
		vcdeals.delregReps();
	}

	// Placing a deal for a new tenant
	public static testMethod void  newTenantDeal() {

		// Create centre
		Centre__c objCentre = VC_UnitTestFactory.buildTestCentre();
		objCentre.Name = 'Emporium';
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
		Account objAccount = VC_UnitTestFactory.buildTestDefaultAccount();
		insert objAccount;

		// Create Authorised Rep
		Contact objContact = VC_UnitTestFactory.buildTenantRep();
		objContact.Tenant_Rep_Type__c = 'Authorised Representative';
		insert objContact;

		// Create opportunity
		Opportunity objOpp =  VC_UnitTestFactory.buildTestOpportunity();
		objOpp.AccountId = objAccount.Id;
		objOpp.Deal_Type__c = 'Renewal';
		objOpp.Centre__c = objCentre.Id;
		objOpp.Building__c = objBuilding.Id;
		objOpp.Unit__c = objUnit.Id;
		objOpp.Unit_Code__c = '40OFF';
		objOpp.Promotion_Contribution_Percent__c = 5;
		objOpp.Base_Rent__c = 54000;
		objOpp.Promo_Amt_Year_1__c = 6700;
		objOpp.Guarantor_Reps__c = objContact.Id + ';';
		objOpp.Legal_Reps__c = objContact.Id + ';';
		objOpp.Notice_Reps__c = objContact.Id + ';';
		objOpp.Registration_Reps__c = objContact.Id + ';';
		objOpp.StageName = 'Deal Builder';
		objOpp.Recovery_Type__c = 'Net';
		objOpp.Area_of_premises_sqmt__c = 3200;
		insert objOpp;

		ApexPages.currentPage().getParameters().put('id', objOpp.Id);
		//VC_Deal_DetailsController vcdeal = new VC_Deal_DetailsController();
		VC_Deal_DetailsController vcdeals = new VC_Deal_DetailsController(new ApexPages.StandardController(objOpp));

		//vcdeals.selectedWorkType = 'Emporium';
		vcdeals.selectedauthrep = objContact.Id;
		vcdeals.selectedbillrep = objContact.Id;
		vcdeals.selectedguarrep = objContact.Id;
		vcdeals.selectedlegrep = objContact.Id;
		vcdeals.selectednoticerep = objContact.Id;
		vcdeals.selectedregrep = objContact.Id;

		vcdeals.unselectauthrep = objContact.Id;
		vcdeals.unselectbillrep = objContact.Id;
		vcdeals.unselectguarrep = objContact.Id;
		vcdeals.unselectlegrep = objContact.Id;
		vcdeals.unselectnoticerep = objContact.Id;
		vcdeals.unselectregrep = objContact.Id;

		vcdeals.tenantBillingAddress = null;
		vcdeals.pageUrl = null;
		//vcdeals.exsFitOther = true;
		vcdeals.defaultTenant = true;

		vcdeals.getAuthReps();
		vcdeals.getOpportunityAuthReps();
		vcdeals.getBillReps();
		vcdeals.getOpportunityBillReps();
		vcdeals.getGuarReps();
		vcdeals.getOpportunityGuarReps();
		vcdeals.getLegalReps();
		vcdeals.getOpportunityLegalReps();
		vcdeals.getNoticeReps();
		vcdeals.getOpportunityNoticeReps();
		//vcdeals.getRegReps();
		vcdeals.getOpportunityRegReps();
		//vcdeals.getAllWorkTypes();

		vcdeals.saveDeal();
		vcdeals.cancelDeal();
		//vcdeals.dealRules();
		vcdeals.refreshField();
		//vcdeals.loifDone();
		vcdeals.pageReload();
		vcdeals.setReps();
		vcdeals.delReps();
		vcdeals.setBillReps();
		vcdeals.delBillReps();
		vcdeals.setGuarReps();
		vcdeals.delGuarReps();
		vcdeals.setlegalReps();
		vcdeals.dellegalReps();
		vcdeals.setnoticeReps();
		vcdeals.delnoticeReps();
		vcdeals.setregReps();
		vcdeals.delregReps();
	}

	public static testMethod void  myTestMethod1() {
		// Create centre
		Centre__c objCentre = VC_UnitTestFactory.buildTestCentre();
		objCentre.Name = 'Emporium';
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
		Account objAccount = VC_UnitTestFactory.buildTestDefaultAccount();
		insert objAccount;

		// Create Authorised Rep
		Contact objContact = VC_UnitTestFactory.buildTenantRep();
		objContact.Tenant_Rep_Type__c = 'Authorised Representative';
		insert objContact;

		// Create opportunity
		Opportunity objOpp =  VC_UnitTestFactory.buildTestOpportunity();
		objOpp.AccountId = objAccount.Id;
		objOpp.Deal_Type__c = 'Renewal';
		objOpp.Centre__c = objCentre.Id;
		objOpp.Building__c = objBuilding.Id;
		objOpp.Unit__c = objUnit.Id;
		objOpp.Unit_Code__c = '40OFF';
		objOpp.Promotion_Contribution_Percent__c = 5;
		objOpp.Base_Rent__c = 54000;
		objOpp.Promo_Amt_Year_1__c = 6700;
		objOpp.Guarantor_Reps__c = objContact.Id + ';';
		objOpp.Legal_Reps__c = objContact.Id + ';';
		objOpp.Notice_Reps__c = objContact.Id + ';';
		objOpp.Registration_Reps__c = objContact.Id + ';';
		objOpp.StageName = 'Deal Builder';
		objOpp.Recovery_Type__c = 'Net';
		objOpp.Area_of_premises_sqmt__c = 3200;
		objOpp.Authorised_Reps__c  = null;
		objOpp.Legal_Reps__c = null;
		objOpp.New_Auth_Rep_Name__c = 'test';
		objOpp.New_Leg_Rep_Name__c = 'test';
		objOpp.New_Auth_Rep_Address__c = 'test';
		objOpp.New_Leg_Rep_Address__c = 'test';
		objOpp.Surrender_other_premises_in_Centre__c = true;
		objOpp.Surrender_other_premises_Date_Options__c = 'Fixed Date';
		objOpp.Surrender_other_premises_Date__c = Date.today();
		objOpp.Surrender_other_premises_Fees__c = 100;
		objOpp.Surrender_other_premises_Make_Good__c = 'Yes';
		//objOpp.Surrender_other_premises_Unit_No__c = 'test';
		objOpp.Surrender_these_premises_Date_Options__c = 'Fixed Date';
		objOpp.Surrender_these_premises_Date__c = Date.today();
		objOpp.Surrender_these_premises_Fees__c = 100;
		objOpp.Surrender_these_premises_Make_Good__c = 'Yes';
		//objOpp.Surrender_these_premises_Unit_No__c = '100';
		objOpp.Surrender_these_premises_Legal_Cost__c = 'Landlord';
		objOpp.Tenant_Classification__c = 'RTRL';
		objOpp.Tenant_Category__c = 'Base';
		objOpp.TDP_Milestone__c = 'TDPM03';
		objOpp.Process_Status_Identifier__c='LCRM09';

		insert objOpp;

		Test.startTest();
		ApexPages.currentPage().getParameters().put('id', objOpp.Id);
		VC_Deal_DetailsController vcdeals = new VC_Deal_DetailsController(new ApexPages.StandardController(objOpp));
		vcdeals.defaultTenant = false;
		vcdeals.getAccount();
		//vcdeals.checkRecordCompletion();
		//vcdeals.generateLOIF();
		//vcdeals.checkErrors();
		vcdeals.calcPercentageRentRate();
		//vcdeals.calcFitoutPeriod();
		Test.stopTest();

	}


	public static testMethod void  myTestMethod2() {
		// Create centre
		Centre__c objCentre = VC_UnitTestFactory.buildTestCentre();
		objCentre.Name = 'Emporium';
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
		Account objAccount = VC_UnitTestFactory.buildTestDefaultAccount();
		insert objAccount;

		// Create Authorised Rep
		Contact objContact = VC_UnitTestFactory.buildTenantRep();
		objContact.Tenant_Rep_Type__c = 'Authorised Representative';
		insert objContact;

		// Create opportunity
		Opportunity objOpp =  VC_UnitTestFactory.buildTestOpportunity();
		objOpp.AccountId = objAccount.Id;
		objOpp.Deal_Type__c = 'Renewal';
		objOpp.Centre__c = objCentre.Id;
		objOpp.Building__c = objBuilding.Id;
		objOpp.Unit__c = objUnit.Id;
		objOpp.Unit_Code__c = '40OFF';
		objOpp.Promotion_Contribution_Percent__c = 5;
		objOpp.Base_Rent__c = 54000;
		objOpp.Promo_Amt_Year_1__c = 6700;
		objOpp.Guarantor_Reps__c = objContact.Id + ';';
		objOpp.Legal_Reps__c = objContact.Id + ';';
		objOpp.Notice_Reps__c = objContact.Id + ';';
		objOpp.Registration_Reps__c = objContact.Id + ';';
		objOpp.StageName = 'Deal Builder';
		objOpp.Recovery_Type__c = 'Net';
		objOpp.Area_of_premises_sqmt__c = 3200;
		objOpp.Authorised_Reps__c  = null;
		objOpp.Legal_Reps__c = null;
		objOpp.New_Auth_Rep_Name__c = 'test';
		objOpp.New_Leg_Rep_Name__c = 'test';
		objOpp.New_Auth_Rep_Address__c = 'test';
		objOpp.New_Leg_Rep_Address__c = 'test';
		objOpp.Surrender_other_premises_in_Centre__c = true;
		objOpp.Surrender_other_premises_Date_Options__c = 'Fixed Date';
		objOpp.Surrender_other_premises_Date__c = Date.today();
		objOpp.Surrender_other_premises_Fees__c = 100;
		objOpp.Surrender_other_premises_Make_Good__c = 'Yes';
		//objOpp.Surrender_other_premises_Unit_No__c = 'test';
		objOpp.Surrender_these_premises_Date_Options__c = 'Fixed Date';
		objOpp.Surrender_these_premises_Date__c = Date.today();
		objOpp.Surrender_these_premises_Fees__c = 100;
		objOpp.Surrender_these_premises_Make_Good__c = 'Yes';
		//objOpp.Surrender_these_premises_Unit_No__c = '100';
		objOpp.Surrender_these_premises_Legal_Cost__c = 'Landlord';
		objOpp.Tenant_Classification__c = 'RTRL';
		objOpp.Tenant_Category__c = 'Base';
		objOpp.TDP_Milestone__c = 'TDPM03';
		objOpp.Process_Status_Identifier__c='LCRM09';

		objOpp.LAD_Approved__c=true;

		insert objOpp;

		Test.startTest();
		ApexPages.currentPage().getParameters().put('id', objOpp.Id);
		VC_Deal_DetailsController vcdeals = new VC_Deal_DetailsController(new ApexPages.StandardController(objOpp));
		vcdeals.refreshSource = 'LAD_Approved__c';
		vcdeals.checkApprovedSpecialCons();
		objOpp.Non_Standard_Special_Conditions__c = 'LON038;LON001;LON065;LON046;LON003;LON004;LON059;LON053;'+
													 'LON007;XDISTR;LON009;LON008;LON045;LON010;LON011;LON012;'+
													 'LON067;LON017;LQRLIC;LON019;LON020;OPTDET;OPTRRV;PROMRV;'+
													 'RENTRV;LON050;LON021;LON044;LON066;LON061;XREPRE;LON025;'+
													 'LON049;LON026;LON062;LON033;SURFEE;LON031;LON032;LON034;'+
													 'LON054;LON037;WAMTE5YT;WAMTLMT;WAMTLT'
													 ;
		vcdeals.setLADApproved();


		Test.stopTest();

	}

	public static testMethod void  myTestMethod3() {

		/*
		UDC_Codes__c newUdcCode = new UDC_Codes__c();
		newUdcCode.Name = 'test';
		newUdcCode.Category_Code__c = 'test';
		newUdcCode.Code_Type_Description__c = 'test';
		newUdcCode.Code_Notes__c = 'test';
		newUdcCode.Code_Type__c = 'test';
		newUdcCode.Code_Value__c = 'test';
		insert newUdcCode;
		*/
		// Create centre
		Centre__c objCentre = VC_UnitTestFactory.buildTestCentre();
		objCentre.Name = 'Emporium';
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

		// Create Account
		Account objAccount = VC_UnitTestFactory.buildTestDefaultAccount();
		insert objAccount;

		// Create Authorised Rep
		Contact objContact = VC_UnitTestFactory.buildTenantRep();
		objContact.Tenant_Rep_Type__c = 'Authorised Representative';
		insert objContact;

		// Create opportunity
		Opportunity objOpp =  VC_UnitTestFactory.buildTestOpportunity();
		objOpp.AccountId = objAccount.Id;
		objOpp.Deal_Type__c = 'Renewal';
		objOpp.Centre__c = objCentre.Id;
		objOpp.Building__c = objBuilding.Id;
		objOpp.Unit__c = objUnit.Id;
		objOpp.Unit_Code__c = '40OFF';
		objOpp.Promotion_Contribution_Percent__c = 5;
		objOpp.Base_Rent__c = 54000;
		objOpp.Promo_Amt_Year_1__c = 6700;
		objOpp.Guarantor_Reps__c = objContact.Id + ';';
		objOpp.Legal_Reps__c = objContact.Id + ';';
		objOpp.Notice_Reps__c = objContact.Id + ';';
		objOpp.Registration_Reps__c = objContact.Id + ';';
		objOpp.StageName = 'Deal Builder';
		objOpp.Recovery_Type__c = 'Net';
		objOpp.Area_of_premises_sqmt__c = 3200;
		objOpp.Authorised_Reps__c  = null;
		objOpp.Legal_Reps__c = null;
		objOpp.New_Auth_Rep_Name__c = 'test';
		objOpp.New_Leg_Rep_Name__c = 'test';
		objOpp.New_Auth_Rep_Address__c = 'test';
		objOpp.New_Leg_Rep_Address__c = 'test';
		objOpp.Surrender_other_premises_in_Centre__c = true;
		objOpp.Surrender_other_premises_Date_Options__c = 'Fixed Date';
		objOpp.Surrender_other_premises_Date__c = Date.today();
		objOpp.Surrender_other_premises_Fees__c = 100;
		objOpp.Surrender_other_premises_Make_Good__c = 'Yes';
		//objOpp.Surrender_other_premises_Unit_No__c = 'test';
		objOpp.Surrender_these_premises_Date_Options__c = 'Fixed Date';
		objOpp.Surrender_these_premises_Date__c = Date.today();
		objOpp.Surrender_these_premises_Fees__c = 100;
		objOpp.Surrender_these_premises_Make_Good__c = 'Yes';
		//objOpp.Surrender_these_premises_Unit_No__c = '100';
		objOpp.Surrender_these_premises_Legal_Cost__c = 'Landlord';
		objOpp.Tenant_Classification__c = 'RTRL';
		objOpp.Tenant_Category__c = 'Base';
		objOpp.TDP_Milestone__c = 'TDPM03';
		objOpp.Process_Status_Identifier__c='LCRM09';
		objOpp.LAD_Approved__c=true;
		objOpp.Non_Standard_Special_Conditions__c='LON001';
		objOpp.Existing_Retailer__c = true;
		insert objOpp;

		Non_Standard_Special_Conditions__c ns = new Non_Standard_Special_Conditions__c();
		ns.Special_Condition__c = 'test';
		ns.Deal__c = objOpp.Id;
		insert ns;

		Test.startTest();
		ApexPages.currentPage().getParameters().put('id', objOpp.Id);
		VC_Deal_DetailsController vcdeals = new VC_Deal_DetailsController(new ApexPages.StandardController(objOpp));
		Test.setMock(HttpCalloutMock.class, new AuthResponseMockHttpResponseGenerator());
		vcdeals.nsscId = ns.Id;
		List<SelectOption> permittedUseList = vcdeals.permittedUseList;
		List<SelectOption> fitoutlist = vcdeals.getExistingFitoutList();
		List<SelectOption> spconlist = vcdeals.getSpecialConsList();
		vcdeals.addNSSpecialCon();
		vcdeals.removeNSSpecialCon();
		vcdeals.customCancel();
		List<Unit__c> units = VC_Deal_DetailsController.queryUnits('test',objBuilding.Id);
		Set<String> cons = vcdeals.selectedSpCons;
		Test.stopTest();
	}
	/*
		public static testMethod void  myTestMethod4() {

		UDC_Codes__c newUdcCode = new UDC_Codes__c();
		newUdcCode.Name = 'test';
		newUdcCode.Category_Code__c = 'test';
		newUdcCode.Code_Type_Description__c = 'test';
		newUdcCode.Code_Notes__c = 'test';
		newUdcCode.Code_Type__c = 'test';
		newUdcCode.Code_Value__c = 'test';
		// Create centre
		Centre__c objCentre = VC_UnitTestFactory.buildTestCentre();
		objCentre.Name = 'Emporium';
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

		// Create Account
		Account objAccount = VC_UnitTestFactory.buildTestDefaultAccount();
		insert objAccount;

		// Create Authorised Rep
		Contact objContact = VC_UnitTestFactory.buildTenantRep();
		objContact.Tenant_Rep_Type__c = 'Authorised Representative';
		insert objContact;

		// Create opportunity
		Opportunity objOpp =  VC_UnitTestFactory.buildTestOpportunity();
		objOpp.AccountId = objAccount.Id;
		objOpp.Deal_Type__c = 'Renewal';
		objOpp.Centre__c = objCentre.Id;
		objOpp.Building__c = objBuilding.Id;
		objOpp.Unit__c = objUnit.Id;
		objOpp.Unit_Code__c = '40OFF';
		objOpp.Promotion_Contribution_Percent__c = 5;
		objOpp.Base_Rent__c = 54000;
		objOpp.Promo_Amt_Year_1__c = 6700;
		objOpp.Guarantor_Reps__c = objContact.Id + ';';
		objOpp.Legal_Reps__c = objContact.Id + ';';
		objOpp.Notice_Reps__c = objContact.Id + ';';
		objOpp.Registration_Reps__c = objContact.Id + ';';
		objOpp.StageName = 'Deal Builder';
		objOpp.Recovery_Type__c = 'Net';
		objOpp.Area_of_premises_sqmt__c = 3200;
		objOpp.Authorised_Reps__c  = null;
		objOpp.Legal_Reps__c = null;
		objOpp.New_Auth_Rep_Name__c = 'test';
		objOpp.New_Leg_Rep_Name__c = 'test';
		objOpp.New_Auth_Rep_Address__c = 'test';
		objOpp.New_Leg_Rep_Address__c = 'test';
		objOpp.Surrender_other_premises_in_Centre__c = true;
		objOpp.Surrender_other_premises_Date_Options__c = 'Fixed Date';
		objOpp.Surrender_other_premises_Date__c = Date.today();
		objOpp.Surrender_other_premises_Fees__c = 100;
		objOpp.Surrender_other_premises_Make_Good__c = 'Yes';
		//objOpp.Surrender_other_premises_Unit_No__c = 'test';
		objOpp.Surrender_these_premises_Date_Options__c = 'Fixed Date';
		objOpp.Surrender_these_premises_Date__c = Date.today();
		objOpp.Surrender_these_premises_Fees__c = 100;
		objOpp.Surrender_these_premises_Make_Good__c = 'Yes';
		//objOpp.Surrender_these_premises_Unit_No__c = '100';
		objOpp.Surrender_these_premises_Legal_Cost__c = 'Landlord';
		objOpp.Tenant_Classification__c = 'RTRL';
		objOpp.Tenant_Category__c = 'Base';
		objOpp.TDP_Milestone__c = 'TDPM03';
		objOpp.Process_Status_Identifier__c='LCRM09';
		objOpp.LAD_Approved__c=true;
		objOpp.Non_Standard_Special_Conditions__c='LON001';
		objOpp.Existing_Retailer__c = true;
		insert objOpp;

		Non_Standard_Special_Conditions__c ns = new Non_Standard_Special_Conditions__c();
		ns.Special_Condition__c = 'test';
		ns.Deal__c = objOpp.Id;
		insert ns;

		Test.startTest();
		ApexPages.currentPage().getParameters().put('id', objOpp.Id);
		VC_Deal_DetailsController vcdeals = new VC_Deal_DetailsController(new ApexPages.StandardController(objOpp));
		Test.setMock(HttpCalloutMock.class, new AuthResponseMockHttpResponseGenerator());

		vcdeals.sendECMDocRequest();

		Test.stopTest();
	}

	*/
		public static testMethod void  myTestMethod5() {

		UDC_Codes__c newUdcCode = new UDC_Codes__c();
		newUdcCode.Name = 'test';
		newUdcCode.Category_Code__c = 'test';
		newUdcCode.Code_Type_Description__c = 'test';
		newUdcCode.Code_Notes__c = 'test';
		newUdcCode.Code_Type__c = 'test';
		newUdcCode.Code_Value__c = 'test';
		// Create centre
		Centre__c objCentre = VC_UnitTestFactory.buildTestCentre();
		objCentre.Name = 'Emporium';
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

		// Create Account
		Account objAccount = VC_UnitTestFactory.buildTestDefaultAccount();
		insert objAccount;

		// Create Authorised Rep
		Contact objContact = VC_UnitTestFactory.buildTenantRep();
		objContact.Tenant_Rep_Type__c = 'Authorised Representative';
		insert objContact;

		// Create opportunity
		Opportunity objOpp =  VC_UnitTestFactory.buildTestOpportunity();
		objOpp.AccountId = objAccount.Id;
		objOpp.Deal_Type__c = 'Renewal';
		objOpp.Centre__c = objCentre.Id;
		objOpp.Building__c = objBuilding.Id;
		objOpp.Unit__c = objUnit.Id;
		objOpp.Unit_Code__c = '40OFF';
		objOpp.Promotion_Contribution_Percent__c = 5;
		objOpp.Base_Rent__c = 54000;
		objOpp.Promo_Amt_Year_1__c = 6700;
		objOpp.Guarantor_Reps__c = objContact.Id + ';';
		objOpp.Legal_Reps__c = objContact.Id + ';';
		objOpp.Notice_Reps__c = objContact.Id + ';';
		objOpp.Registration_Reps__c = objContact.Id + ';';
		objOpp.StageName = 'Deal Builder';
		objOpp.Recovery_Type__c = 'Net';
		objOpp.Area_of_premises_sqmt__c = 3200;
		objOpp.Authorised_Reps__c  = null;
		objOpp.Legal_Reps__c = null;
		objOpp.New_Auth_Rep_Name__c = 'test';
		objOpp.New_Leg_Rep_Name__c = 'test';
		objOpp.New_Auth_Rep_Address__c = 'test';
		objOpp.New_Leg_Rep_Address__c = 'test';
		objOpp.Surrender_other_premises_in_Centre__c = true;
		objOpp.Surrender_other_premises_Date_Options__c = 'Fixed Date';
		objOpp.Surrender_other_premises_Date__c = Date.today();
		objOpp.Surrender_other_premises_Fees__c = 100;
		objOpp.Surrender_other_premises_Make_Good__c = 'Yes';
		//objOpp.Surrender_other_premises_Unit_No__c = 'test';
		objOpp.Surrender_these_premises_Date_Options__c = 'Fixed Date';
		objOpp.Surrender_these_premises_Date__c = Date.today();
		objOpp.Surrender_these_premises_Fees__c = 100;
		objOpp.Surrender_these_premises_Make_Good__c = 'Yes';
		//objOpp.Surrender_these_premises_Unit_No__c = '100';
		objOpp.Surrender_these_premises_Legal_Cost__c = 'Landlord';
		objOpp.Tenant_Classification__c = 'RTRL';
		objOpp.Tenant_Category__c = 'Base';
		objOpp.TDP_Milestone__c = 'TDPM03';
		objOpp.Process_Status_Identifier__c='LCRM09';
		objOpp.LAD_Approved__c=true;
		objOpp.Non_Standard_Special_Conditions__c='LON001';
		objOpp.Existing_Retailer__c = true;
		insert objOpp;

		Non_Standard_Special_Conditions__c ns = new Non_Standard_Special_Conditions__c();
		ns.Special_Condition__c = 'test';
		ns.Deal__c = objOpp.Id;
		insert ns;

		Test.startTest();
		ApexPages.currentPage().getParameters().put('id', objOpp.Id);
		VC_Deal_DetailsController vcdeals = new VC_Deal_DetailsController(new ApexPages.StandardController(objOpp));
		Test.setMock(HttpCalloutMock.class, new AuthResponseMockHttpResponseGenerator());
		vcdeals.generateLON();
		Test.stopTest();
	}


		public static testMethod void  myTestMethod6() {

		UDC_Codes__c newUdcCode = new UDC_Codes__c();
		newUdcCode.Name = 'test';
		newUdcCode.Category_Code__c = 'test';
		newUdcCode.Code_Type_Description__c = 'test';
		newUdcCode.Code_Notes__c = 'test';
		newUdcCode.Code_Type__c = 'test';
		newUdcCode.Code_Value__c = 'test';
		// Create centre
		Centre__c objCentre = VC_UnitTestFactory.buildTestCentre();
		objCentre.Name = 'Emporium';
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

		// Create Account
		Account objAccount = VC_UnitTestFactory.buildTestDefaultAccount();
		insert objAccount;

		// Create Authorised Rep
		Contact objContact = VC_UnitTestFactory.buildTenantRep();
		objContact.Tenant_Rep_Type__c = 'Authorised Representative';
		insert objContact;

		// Create opportunity
		Opportunity objOpp =  VC_UnitTestFactory.buildTestOpportunity();
		objOpp.AccountId = objAccount.Id;
		objOpp.Deal_Type__c = 'Renewal';
		objOpp.Centre__c = objCentre.Id;
		objOpp.Building__c = objBuilding.Id;
		objOpp.Unit__c = objUnit.Id;
		objOpp.Unit_Code__c = '40OFF';
		objOpp.Promotion_Contribution_Percent__c = 5;
		objOpp.Base_Rent__c = 54000;
		objOpp.Promo_Amt_Year_1__c = 6700;
		objOpp.Guarantor_Reps__c = objContact.Id + ';';
		objOpp.Legal_Reps__c = objContact.Id + ';';
		objOpp.Notice_Reps__c = objContact.Id + ';';
		objOpp.Registration_Reps__c = objContact.Id + ';';
		objOpp.StageName = 'Deal Builder';
		objOpp.Recovery_Type__c = 'Net';
		objOpp.Area_of_premises_sqmt__c = 3200;
		objOpp.Authorised_Reps__c  = null;
		objOpp.Legal_Reps__c = null;
		objOpp.New_Auth_Rep_Name__c = 'test';
		objOpp.New_Leg_Rep_Name__c = 'test';
		objOpp.New_Auth_Rep_Address__c = 'test';
		objOpp.New_Leg_Rep_Address__c = 'test';
		objOpp.Surrender_other_premises_in_Centre__c = true;
		objOpp.Surrender_other_premises_Date_Options__c = 'Fixed Date';
		objOpp.Surrender_other_premises_Date__c = Date.today();
		objOpp.Surrender_other_premises_Fees__c = 100;
		objOpp.Surrender_other_premises_Make_Good__c = 'Yes';
		//objOpp.Surrender_other_premises_Unit_No__c = 'test';
		objOpp.Surrender_these_premises_Date_Options__c = 'Fixed Date';
		objOpp.Surrender_these_premises_Date__c = Date.today();
		objOpp.Surrender_these_premises_Fees__c = 100;
		objOpp.Surrender_these_premises_Make_Good__c = 'Yes';
		//objOpp.Surrender_these_premises_Unit_No__c = '100';
		objOpp.Surrender_these_premises_Legal_Cost__c = 'Landlord';
		objOpp.Tenant_Classification__c = 'RTRL';
		objOpp.Tenant_Category__c = 'Base';
		objOpp.TDP_Milestone__c = 'TDPM03';
		objOpp.Process_Status_Identifier__c='LCRM09';
		objOpp.LAD_Approved__c=true;
		objOpp.Non_Standard_Special_Conditions__c='LON001';
		objOpp.Existing_Retailer__c = true;
		insert objOpp;

		Non_Standard_Special_Conditions__c ns = new Non_Standard_Special_Conditions__c();
		ns.Special_Condition__c = 'test';
		ns.Deal__c = objOpp.Id;
		insert ns;

		Test.startTest();
		ApexPages.currentPage().getParameters().put('id', objOpp.Id);
		VC_Deal_DetailsController vcdeals = new VC_Deal_DetailsController(new ApexPages.StandardController(objOpp));
		Test.setMock(HttpCalloutMock.class, new AuthResponseMockHttpResponseGenerator());
		objOpp.LON_Regeneration_Type__c = 'C';
		//vcdeals.sendECMDocRequest();
		vcdeals.regenerateLON();
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