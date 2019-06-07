trigger CentreOutgoinsTrigger on Centre_Outgoings__c (before update, before insert) {
    if(Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate))
    {
        for(Centre_Outgoings__c objCo: Trigger.new)
        {
            objCo.Unique_Key__c = objCo.Amenity_Code__c + '-' + objCo.Begin_Date__c.day() + objCo.Begin_Date__c.month() + objCo.Begin_Date__c.year() + '-' + objCo.Business_Unit_Code__c;
        }
    }
}