trigger BuildingsTrigger on Building__c (before update, before insert) {
	/*
    if(Trigger.isBefore && Trigger.isInsert) { 
        Map<String, Id> currentBuildingsMap = new Map<String, Id>();
        Set<Id> buildingsToDeactivate = new Set<Id>();
        
        List<Building__c> activeBuildings = [SELECT Name, Id, Centre__c FROM Building__c WHERE Is_Active__c = true ORDER BY Building_Code__c ASC];
        
        for(Building__c building :activeBuildings)
        {
            currentBuildingsMap.put(building.Name+building.Centre__c, building.Id);
        }
        
        for(Building__c building :Trigger.new)
        {
            if(currentBuildingsMap.containsKey(building.Name+building.Centre__c)){
       	        building.Old_Building__c = currentBuildingsMap.get(building.Name+building.Centre__c);
                
                buildingsToDeactivate.add(building.Old_Building__c);
            }
        }
        
       
        List<Building__c> buildingsToUpdate = [SELECT Name, Id FROM Building__c WHERE Id IN :buildingsToDeactivate];
        
        for(Building__c building : buildingsToUpdate){
        	building.Is_Active__c = false;
        } 
        
        update buildingsToUpdate;

    }
    */
    if(Trigger.isAfter && Trigger.isUpdate) { 

    	Set<Id> inactiveBuildings = new Set<Id>();
    	
    	for(Building__c building :Trigger.new)
        {
        	if(building.Is_Active__c == false){
        		inactiveBuildings.add(building.Id);
        	}
        }
        
        List<Unit__c> unitsToUpdate = [SELECT Name, Id, Is_Active__c FROM Unit__c WHERE Building__c IN : inactiveBuildings];
        
        for(Unit__c unit: unitsToUpdate){
        	unit.Is_Active__c = false;
        }
        
        update unitsToUpdate;
    }

}