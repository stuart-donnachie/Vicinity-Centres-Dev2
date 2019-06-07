trigger CentreTrigger on Centre__c (before update, before insert) {
    if(Trigger.isAfter && Trigger.isUpdate) { 

        Set<Id> inactiveCentres = new Set<Id>();
        
        for(Centre__c centre :Trigger.new)
        {
            if(centre.Is_Active__c == false){
                inactiveCentres.add(centre.Id);
            }
        }
        
        List<Building__c> buildingsToUpdate = [SELECT Name, Id, Is_Active__c FROM Building__c WHERE Centre__c IN : inactiveCentres];
        
        for(Building__c building: buildingsToUpdate){
            building.Is_Active__c = false;
        }
        
        update buildingsToUpdate;
    }
}