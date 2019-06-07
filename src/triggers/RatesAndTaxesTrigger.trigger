trigger RatesAndTaxesTrigger on Rates_and_Taxes__c (before update, before insert) {
    if(Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate))
    {
        for(Rates_and_Taxes__c rt: Trigger.new)
        {
            rt.Unique_Key__c = rt.Amenity_Code__c + '-' 
            					+ rt.Log_Class__c + '-' 
            					+ rt.Log_Level__c + '-' 
            					+ rt.Begin_Date__c.day() + rt.Begin_Date__c.month() + rt.Begin_Date__c.year() + '-' 
            					+ rt.Building_Code__c + '-' 
            					+ rt.Unit_Name__c;
        }
    }
}