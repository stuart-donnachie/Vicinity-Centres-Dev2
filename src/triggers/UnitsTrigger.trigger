trigger UnitsTrigger on Unit__c (after insert, after update, before update, before insert) {
	
	if(Trigger.isBefore && (Trigger.isUpdate || Trigger.isInsert)) { // Handle issue of updating with non-exsisting SDUC
		
		Schema.DescribeFieldResult SDUCfieldResult = Unit__c.System_Unit_Category__c.getDescribe();
	   	List<Schema.PicklistEntry> SDUCple = SDUCfieldResult.getPicklistValues();
	   	
	   	Map<String, String> SDUCpicklist = new Map<String, String>();
	        
	   	for(Schema.PicklistEntry f : SDUCple)
	   	{
	      	SDUCpicklist.put(f.getLabel(), f.getValue());
	   	} 
		
		for(Unit__c newUnit :Trigger.new)
    	{

			//newUnit.System_Unit_Category__c = (newUnit.System_Unit_Category__c == 'Option') ? 'Options' : newUnit.System_Unit_Category__c;
			//newUnit.System_Unit_Category__c = (newUnit.System_Unit_Category__c == 'Major') ? 'Majors' : newUnit.System_Unit_Category__c;

    		if(newUnit.System_Unit_Category__c !=null && !SDUCpicklist.containsKey(newUnit.System_Unit_Category__c)){
    			 
	    		if(Trigger.isInsert) {
	    			ErrorLogHandler.log('Invalid System Defined Unit Category', newUnit.Id + ' | ' + newUnit.Unit_Key__c, newUnit.System_Unit_Category__c, newUnit.Current_Tenant_Lease_Status__c);
	    			
    				newUnit.System_Unit_Category__c = null;
    				newUnit.Current_Tenant_Lease_Status__c = null;
    			}else if(Trigger.isUpdate) {
    				Unit__c oldIUnit = Trigger.oldMap.get(newUnit.Id);
    				
    				ErrorLogHandler.log('Invalid System Defined Unit Category', newUnit.Id + ' | ' + newUnit.Unit_Key__c, newUnit.System_Unit_Category__c, newUnit.Current_Tenant_Lease_Status__c, oldIUnit.System_Unit_Category__c, oldIUnit.Current_Tenant_Lease_Status__c);
    				
    				newUnit.System_Unit_Category__c = oldIUnit.System_Unit_Category__c;
    				newUnit.Current_Tenant_Lease_Status__c = oldIUnit.Current_Tenant_Lease_Status__c;
    			}
    			
    		}
    		
    		newUnit.Current_Tenant_Lease_Status__c = (String.isEmpty(newUnit.System_Unit_Category__c)) ? null : newUnit.Current_Tenant_Lease_Status__c;
    	}
	}
	
	
	if(Trigger.isBefore && Trigger.isUpdate) {
		
		for(Unit__c newUnit :Trigger.new)
    	{
    		Unit__c oldIUnit = Trigger.oldMap.get(newUnit.Id);

    		if(newUnit.System_Unit_Category__c !=null && newUnit.System_Unit_Category__c != oldIUnit.System_Unit_Category__c){
    			newUnit.Current_Tenant_Lease_Status__c = newUnit.System_Unit_Category__c;
    		}
    	}
	}
	
	if(Trigger.isBefore && Trigger.isInsert) {
		
		for(Unit__c newUnit :Trigger.new)
    	{
    		if(newUnit.System_Unit_Category__c !=null){
    			newUnit.Current_Tenant_Lease_Status__c = newUnit.System_Unit_Category__c;
    		}
    	}
	}
	
}