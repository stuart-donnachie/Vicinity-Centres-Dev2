trigger LandlordTrigger on Landlord__c  (before update, before insert) {
   if(Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate))
    {
        for(Landlord__c ld: Trigger.new)
        {
            ld.Unique_Key__c = ld.Building_Code__c + '-' + ld.Name;
        }
    }
}