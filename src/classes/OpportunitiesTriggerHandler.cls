/*
    Date        : 19-08-2016
    Project     : Lease Management System
    Description : Creating contact roles on opportunity update based on tenant representatives 	
*/

public class OpportunitiesTriggerHandler {
	
    // Creating contact roles on creation of deals based on the role types
    public static void createContactRoles(Map<Id, Opportunity> newMap) {
    	
    	System.debug('createContactRoles -- '+ newMap.size() );	
    	
		Set<String> existingConReps = new Set<String>();
		Set<String> existingConRoles = new Set<String>();
    	Set<String> createConRoles = new Set<String>();
		Set<String> deleteConRoles = new Set<String>();
    	
    	OpportunityContactRole[] oppCon = new List<OpportunityContactRole>();

		// Existing opportunity contact role
		for(OpportunityContactRole o : [SELECT Id, ContactId, Role, OpportunityId FROM OpportunityContactRole 
																				  WHERE  OpportunityId IN :newMap.keySet()]) {
			existingConRoles.add(o.ContactId);															
		}
    	
    	for(Opportunity opp : newMap.values()) {

    		// Authorised
	 		if (opp.Authorised_Reps__c != null){
				string repId = opp.Authorised_Reps__c;
				string[] repIds = repId.split(';');
				
				for(String s : repIds){
					existingConReps.add(s);
				}
	 		}
	 		
	    	// Billing
	 		if (opp.Billing_Reps__c != null){
				string repId = opp.Billing_Reps__c;
				string[] repIds = repId.split(';');
				
				for(String s : repIds){
					existingConReps.add(s);
				}
	 		}
	 		
	    	// Guarantor
	 		if (opp.Guarantor_Reps__c != null){
				string repId = opp.Guarantor_Reps__c;
				string[] repIds = repId.split(';');
				
				for(String s : repIds){
					existingConReps.add(s);
				}
	 		}
	 		
	    	// Legal
	 		if (opp.Legal_Reps__c != null){
				string repId = opp.Legal_Reps__c;
				string[] repIds = repId.split(';');
				
				for(String s : repIds){
					existingConReps.add(s);
				}
	 		}
	 		
	    	// Notice
	 		if (opp.Notice_Reps__c != null){
				string repId = opp.Notice_Reps__c;
				string[] repIds = repId.split(';');
				
				for(String s : repIds){
					existingConReps.add(s);
				}
	 		}
	 		
	    	// Registered
	 		if (opp.Registration_Reps__c != null){
				string repId = opp.Registration_Reps__c;
				string[] repIds = repId.split(';');
				
				for(String s : repIds){
					existingConReps.add(s);
				}
	 		}
    		
			createConRoles = existingConReps.clone();
			
    		// Take only the newly added representatives from the set to create opportunity roles
    		for(String s : createConRoles) {
    			if(existingConRoles.contains(s)) {
    				createConRoles.remove(s);
    			}
    		}
    		

    		
    	}
    	
    	List<Contact> con1 = [SELECT Id, Tenant_Rep_Type__c From Contact WHERE Id IN :createConRoles];
    	
    	System.debug('con1 -- '+ con1.size() );	
    	
    	for(Opportunity opp : newMap.values()) {
    		// Create opportunity contact roles
	    	for(Contact con : con1) {
				OpportunityContactRole o = new OpportunityContactRole(ContactId = con.Id, OpportunityId = opp.Id, Role = con.Tenant_Rep_Type__c);
	    		oppCon.add(o);
	    	}
    	}
    	
		try {
			insert oppCon;
		} catch(exception e) {
			
		}
	    	
	    // Delete opportunity contact roles
	    	
		for(String s : existingConRoles) {
			if(!existingConReps.contains(s)) {
				deleteConRoles.add(s);
			}
		}
	    	
		List<OpportunityContactRole> lstOppCon = [SELECT Id, ContactId, OpportunityId FROM OpportunityContactRole
																					  WHERE OpportunityId IN :newMap.keySet()
																					  AND ContactId IN :deleteConRoles];
		System.debug('lstOppCon -- '+ lstOppCon.size() );																				  
																					  
		delete lstOppCon;
	    	
    	createConRoles.clear();
    	existingConRoles.clear();
    	deleteConRoles.clear();
    }
}