/*
    Date        : 17-10-2016
	Project     : Lease Management System
    Description : Unit test class for OpportunityTriggerHandler
    
    Change History
    --------------      
*/
@isTest
public class OpportunityTriggerHandler_UT {
	
	public static testMethod void  newAuthReps() {
		
		// Create Account
		Account objAccount = VC_UnitTestFactory.buildTestAccount();
		insert objAccount;
		
		// Create Authorised Rep
		Contact objContact = VC_UnitTestFactory.buildTenantRep();
		objContact.Tenant_Rep_Type__c = 'Authorised Representative';
		insert objContact;
		
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
		
		// Create opportunity
		Opportunity objOpp =  VC_UnitTestFactory.buildTestOpportunity();
		objOpp.AccountId = objAccount.Id;
		objOpp.Deal_Type__c = 'New Tenant Standard';
		objOpp.Unit__c = objUnit.Id;
		
		insert objOpp;
		
		// Update Opportunity with the selected rep
		objOpp.Authorised_Reps__c = objContact.Id + ';';
		update objOpp;
		
		List<OpportunityContactRole> lstOppCon = [SELECT Id, ContactId, OpportunityId FROM OpportunityContactRole 
																	   				  WHERE OpportunityId = :objOpp.Id];
		if(lstOppCon.size() > 0) {
			System.assertEquals(lstOppCon[0].OpportunityId, objOpp.Id);
			System.assertEquals(lstOppCon[0].ContactId, objContact.Id);
		}
	}
	
	public static testMethod void  newBillReps() {
		
		// Create Account
		Account objAccount = VC_UnitTestFactory.buildTestAccount();
		insert objAccount;
		
		// Create Billing Rep
		Contact objContact = VC_UnitTestFactory.buildTenantRep();
		objContact.Tenant_Rep_Type__c = 'Billing Representative';
		insert objContact;
		
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
		
		// Create opportunity
		Opportunity objOpp =  VC_UnitTestFactory.buildTestOpportunity();
		objOpp.AccountId = objAccount.Id;
		objOpp.Deal_Type__c = 'Renewal';
		objOpp.Unit__c = objUnit.Id;
		insert objOpp;
		
		// Update Opportunity with the selected rep
		objOpp.Billing_Reps__c = objContact.Id + ';';
		update objOpp;
		
	}
	
	public static testMethod void  newGurantorReps() {
		
		// Create Account
		Account objAccount = VC_UnitTestFactory.buildTestAccount();
		insert objAccount;
		
		// Create Guarantor Rep
		Contact objContact = VC_UnitTestFactory.buildTenantRep();
		objContact.Tenant_Rep_Type__c = 'Gaurantor Representative';
		insert objContact;

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
		
		// Create opportunity
		Opportunity objOpp =  VC_UnitTestFactory.buildTestOpportunity();
		objOpp.AccountId = objAccount.Id;
		objOpp.Deal_Type__c = 'Renewal';
		objOpp.Unit__c = objUnit.Id;
		insert objOpp;
		
		// Update Opportunity with the selected rep
		objOpp.Guarantor_Reps__c = objContact.Id + ';';
		update objOpp;
		
	}
	
	public static testMethod void  newLegalReps() {
		
		// Create Account
		Account objAccount = VC_UnitTestFactory.buildTestAccount();
		insert objAccount;
		
		// Create Legal Rep
		Contact objContact = VC_UnitTestFactory.buildTenantRep();
		objContact.Tenant_Rep_Type__c = 'Legal Representative';
		insert objContact;
		
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
		
		// Create opportunity
		Opportunity objOpp =  VC_UnitTestFactory.buildTestOpportunity();
		objOpp.AccountId = objAccount.Id;
		objOpp.Deal_Type__c = 'Renewal';
		objOpp.Unit__c = objUnit.Id;
		insert objOpp;
		
		// Update Opportunity with the selected rep
		objOpp.Legal_Reps__c = objContact.Id + ';';
		update objOpp;
		
	}
	
	public static testMethod void  newNoticeReps() {
		
		// Create Account
		Account objAccount = VC_UnitTestFactory.buildTestAccount();
		insert objAccount;
		
		// Create Notice Rep
		Contact objContact = VC_UnitTestFactory.buildTenantRep();
		objContact.Tenant_Rep_Type__c = 'Notice Representative';
		insert objContact;
		
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
		
		// Create opportunity
		Opportunity objOpp =  VC_UnitTestFactory.buildTestOpportunity();
		objOpp.AccountId = objAccount.Id;
		objOpp.Deal_Type__c = 'New Tenant As Is';
		objOpp.Unit__c = objUnit.Id;
		insert objOpp;
		
		// Update Opportunity with the selected rep
		objOpp.Notice_Reps__c = objContact.Id + ';';
		update objOpp;
		
	}
	
	public static testMethod void  newRegisteredReps() {
		
		// Create Account
		Account objAccount = VC_UnitTestFactory.buildTestAccount();
		insert objAccount;
		
		// Create Registered Rep
		Contact objContact = VC_UnitTestFactory.buildTenantRep();
		objContact.Tenant_Rep_Type__c = 'Registered Representative';
		insert objContact;
		
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
		
		// Create opportunity
		Opportunity objOpp =  VC_UnitTestFactory.buildTestOpportunity();
		objOpp.AccountId = objAccount.Id;
		objOpp.Deal_Type__c = 'New Tenant As Is';
		objOpp.Unit__c = objUnit.Id;
		insert objOpp;
		
		// Update Opportunity with the selected rep
		objOpp.Registration_Reps__c = objContact.Id + ';';
		update objOpp;
		
	}
	
	public static testMethod void  existingReps() {
		
		// Create Account
		Account objAccount = VC_UnitTestFactory.buildTestAccount();
		insert objAccount;
		
		// Create Existing Billing Rep
		Contact objContact1 = VC_UnitTestFactory.buildTenantRep();
		objContact1.Tenant_Rep_Type__c = 'Billing Representative';
		insert objContact1;
		
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
		
		// Create opportunity
		Opportunity objOpp =  VC_UnitTestFactory.buildTestOpportunity();
		objOpp.AccountId = objAccount.Id;
		objOpp.Deal_Type__c = 'New Tenant As Is';
		objOpp.Billing_Reps__c = objContact1.Id + ';';
		objOpp.Unit__c = objUnit.Id;
		insert objOpp;
		
		
		// Create Opportunity Contact Role
		OpportunityContactRole objOppCon = new OpportunityContactRole();
		objOppCon.ContactId = objContact1.Id;
		objOppCon.OpportunityId = objOpp.Id;
		objOppCon.Role = objContact1.Tenant_Rep_Type__c;
		insert objOppCon;
		
		// Create Registered Rep
		Contact objContact2 = VC_UnitTestFactory.buildTenantRep();
		objContact2.Tenant_Rep_Type__c = 'Registered Representative';
		insert objContact2;
		
		// Update Opportunity with the selected rep
		objOpp.Registration_Reps__c = objContact2.Id + ';';
		update objOpp;
		
	}
	
	public static testMethod void  uniqueConRoles() {
		
		// Create Account
		Account objAccount = VC_UnitTestFactory.buildTestAccount();
		insert objAccount;
		
		// Create Existing Billing Rep
		Contact objContact1 = VC_UnitTestFactory.buildTenantRep();
		objContact1.Tenant_Rep_Type__c = 'Billing Representative';
		insert objContact1;
		
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
		
		// Create opportunity
		Opportunity objOpp =  VC_UnitTestFactory.buildTestOpportunity();
		objOpp.AccountId = objAccount.Id;
		objOpp.Deal_Type__c = 'New Tenant As Is';
		objOpp.Billing_Reps__c = objContact1.Id + ';';
		objOpp.Unit__c = objUnit.Id;
		insert objOpp;
		
		// Create Opportunity Contact Role
		OpportunityContactRole objOppCon = new OpportunityContactRole();
		objOppCon.ContactId = objContact1.Id;
		objOppCon.OpportunityId = objOpp.Id;
		objOppCon.Role = objContact1.Tenant_Rep_Type__c;
		insert objOppCon;
		
		// Update Opportunity ensuring same contact role does not get created again
		// but any new ones do
		objOpp.Registration_Reps__c = objContact1.Id + ';';
		update objOpp;
		
	}
	
	public static testMethod void  noRoleSelected() {
		
		// Create Account
		Account objAccount = VC_UnitTestFactory.buildTestAccount();
		insert objAccount;
		
		// Create Existing Billing Rep
		Contact objContact = VC_UnitTestFactory.buildTenantRep();
		insert objContact;
		
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
		
		// Create opportunity
		Opportunity objOpp =  VC_UnitTestFactory.buildTestOpportunity();
		objOpp.AccountId = objAccount.Id;
		objOpp.Deal_Type__c = 'New Tenant As Is';
		objOpp.Unit__c = objUnit.Id;
		insert objOpp;

		// Update Opportunity for a contact without role
		objOpp.Billing_Reps__c = objContact.Id + ';';
		update objOpp;
		
	}
}