/*
    Date        : 18-10-2016
    Project     : Lease Management System
    Description : Unit test factory for building test data
    
    Change History
    --------------      
*/
@isTest 
public without sharing class VC_UnitTestFactory {
    
    // Building default tenant
    public static Account buildTestDefaultAccount() {
        
        // Add required fields as needed
        Account objAccount = new Account();
        
        objAccount.Name = 'DEFAULT TENANT';
        objAccount.Tenant_ACN__c = '111111111';
        objAccount.Tenant_Entity__c = 'DEFAULT PTY LTD';
        objAccount.Billing_Address_Name__c = 'Accounts Payable';
        objAccount.Tenant_CABID__c = '276050';
        objAccount.Tenant_Key__c = '15995';
        
        return objAccount;
    }
    
    // Building new tenant
    public static Account buildTestAccount() {
        
        // Add required fields as needed
        Account objAccount = new Account();
        
        objAccount.Name = 'LOUIS VUITTON';
        objAccount.Tenant_ACN__c = '005918678';
        objAccount.Tenant_Entity__c = 'LOUIS VUITTON AUSTRALIA PTY LTD';
        objAccount.Billing_Address_Name__c = 'Accounts Payable';
        objAccount.Tenant_CABID__c = '135351';
        objAccount.Tenant_Key__c = '2152';
        
        return objAccount;
    }
    
    // Building new opportunity
    public static Opportunity buildTestOpportunity() {
        
        // Add required fields as needed
        Opportunity objOpp = new Opportunity();
        
        objOpp.StageName = 'ITL';
        objOpp.CloseDate = System.today()+ 730;  
        objOpp.Name = 'Test deal 1001';
        
        return objOpp;
    }
    
    // Building new centre
    public static Centre__c buildTestCentre() {
        
        // Add required fields as needed
        Centre__c objCentre = new Centre__c();
        
        objCentre.Name = 'Chadstone';
        objCentre.Address__c = '1341 Dandenong Road';
        objCentre.State__c = 'VIC';
        objCentre.Postcode__c = '3148';
        objCentre.Conditional_Cap__c = 15000;
        objCentre.Contract_Number__c = '1';
        objCentre.Default_Hoardings_Rate__c = 156;
        objCentre.Default_Storage_Rate__c = 1000;
        objCentre.Design_Review_Fees__c = 2550;
        objCentre.Centre_Code__c = '11';
        objCentre.Centre_Key__c = '13';

        return objCentre;
    }
    
    // Building new building
    public static Building__c buildTestBuilding() {
        
        // Add required fields as needed 
        Building__c objBuilding = new Building__c();
        
        objBuilding.Name = 'CHADSTONE SHOPPING CENTRE';
        objBuilding.Address_Line_1__c = '1341 DANDENONG ROAD';
        objBuilding.City__c = 'CHADSTONE';
        objBuilding.State__c = 'VIC';
        objBuilding.Postal_Code__c = '3148';
        objBuilding.Country__c = 'AUSTRALIA';
        objBuilding.Building_Code__c = '80110';
        objBuilding.Building_Key__c = '67';
        
        return objBuilding;
    }
    
    // Building new unit
    public static Unit__c buildTestUnit() {
        
        // Add required fields as needed 
        Unit__c objUnit = new Unit__c();
        
        objUnit.Name = 'B-192';
        objUnit.Area_of_Premises__c = 127.30;
        objUnit.Floor_Level__c = 'LWMA';
        objUnit.Unit_Type__c = 'Retail Specialty';
        objUnit.Unit_Code__c = '10RTL';
        objUnit.Unit_Key__c = '2281';
        
        return objUnit;
    }
    
    
    public static Contact buildTenantRep() {
        
        Contact objContact = new Contact();
        
        objContact.LastName = 'Test Contact';
        objContact.Phone_Number__c = '123456';
        objContact.Phone_Number_Prefix__c = '02';
        objContact.Phone_Number_Type__c = 'MOB';
        objContact.Tenant_Description__c = 'Tenant Rep Description';
        objContact.Tenant_Email__c = 'a@gmail.com';
        objContact.Tenant_Rep_ACN__c = '11111';
        objContact.mailingStreet = '123 Street';
        objContact.mailingCity = 'Melbourne';
        objContact.mailingState = 'VIC';
        objContact.mailingCountry = 'Australia';
        
        return objContact;
    }
    
    public static testMethod void myTest1(){
        UDC_Codes__c newUdcCode = new UDC_Codes__c();
        newUdcCode.Name = 'test';
        newUdcCode.Category_Code__c = 'test';
        newUdcCode.Code_Type_Description__c = 'Tenant Usage';
        newUdcCode.Code_Notes__c = 'test';
        newUdcCode.Code_Type__c = 'test';
        newUdcCode.Code_Value__c = 'test';
        insert newUdcCode;
        
        CAB_Request__c cr = new CAB_Request__c();
        cr.Trading_Name__c = 'test';
        cr.Tenant_Usage_Picklist__c = 'Books';
        
        cr.BR_Copy_From_AR__c = true;
        cr.LR_Copy_From_AR__c = true;
        cr.RR_Copy_From_AR__c = true;
        cr.NR_Copy_From_RR__c = true;
        insert cr;
        
        cr.BR_Copy_From_AR__c = true;
        cr.LR_Copy_From_AR__c = true;
        cr.RR_Copy_From_AR__c = true;
        cr.NR_Copy_From_RR__c = true;
        update cr;
    }
    
    public static testMethod void myTest2(){
        Rates_and_Taxes__c rt = new Rates_and_Taxes__c ();
        rt.Amenity_Code__c = 'tesdt';
        rt.Log_Class__c = 'tesdt';
        rt.Log_Level__c = 'tesdt';
        rt.Building_Code__c = 'tesdt';
        rt.Unit_Name__c = 'tesdt';
        rt.Begin_Date__c = Date.today();
        
        insert rt;
        
    }

    public static void createTestDataRatesAndOutgoings(){
        // 1. Create Business Units

        List<Business_Unit__c> business_unitsToInsert = new List<Business_Unit__c>();

        Business_Unit__c businessUnit1 = new  Business_Unit__c(Name = 'First Business Unit', Business_Unit_Key__c = 'FBU1');
        Business_Unit__c businessUnit2 = new  Business_Unit__c(Name = 'Second Business Unit', Business_Unit_Key__c = 'FBU2');
        Business_Unit__c businessUnit3 = new  Business_Unit__c(Name = 'Third Business Unit', Business_Unit_Key__c = 'FBU3');
        Business_Unit__c businessUnit4 = new  Business_Unit__c(Name = 'Fourth Business Unit', Business_Unit_Key__c = 'FBU4');


        business_unitsToInsert.add(businessUnit1);
        business_unitsToInsert.add(businessUnit2);
        business_unitsToInsert.add(businessUnit3);
        business_unitsToInsert.add(businessUnit4);


        insert business_unitsToInsert;

        System.debug('Business Units Size : ' + business_unitsToInsert.size());

        List<Centre__c> centresToInsert = new List<Centre__c>();

        Centre__c centre1 = new Centre__c(Name = 'Northgate', Centre_Code__c = 'NGC1');
        Centre__c centre2 = new Centre__c(Name = 'MyCentre2', Centre_Code__c = 'MYC2');
        Centre__c centre3 = new Centre__c(Name = 'MyCentre3', Centre_Code__c = 'MYC3');

        centresToInsert.add(centre1);
        centresToInsert.add(centre2);
        centresToInsert.add(centre3);

        insert centresToInsert;

        System.debug('Centres Size : ' + centresToInsert.size());

        List<Building__c> buildingsToInsert = new List<Building__c>();

        Building__c building1 = new Building__c(Name = 'Belmont Building', Business_Unit__c = business_unitsToInsert[1].Id, Centre__c = centresToInsert[0].Id, State__c = 'WA');
        Building__c building2 = new Building__c(Name = 'Rockingham Centre', Business_Unit__c = business_unitsToInsert[0].Id, Centre__c = centresToInsert[1].Id, State__c = 'WA');
        Building__c building3 = new Building__c(Name = 'Brandon Park', Business_Unit__c = business_unitsToInsert[2].Id, Centre__c = centresToInsert[2].Id, State__c = 'VIC');
        Building__c building4 = new Building__c(Name = 'Altona Gate', Business_Unit__c = business_unitsToInsert[0].Id, Centre__c = centresToInsert[1].Id, State__c = 'NSW');
        Building__c building5 = new Building__c(Name = 'San Fran Gate', Business_Unit__c = business_unitsToInsert[1].Id, Centre__c = centresToInsert[1].Id, State__c = 'QLD');


        buildingsToInsert.add(building1);
        buildingsToInsert.add(building2);
        buildingsToInsert.add(building3);
        buildingsToInsert.add(building4);
        buildingsToInsert.add(building5);


        insert buildingsToInsert;

        System.debug('Buildings Size : ' + buildingsToInsert.size());

        // Create Units data that populates the Unit__c object. Create 3 Units
        List<Unit__c> unitsToInsert = new List<Unit__c>();

        Unit__c unit1 = new Unit__c(Name = 'SP001', Building__c = buildingsToInsert[1].Id, Business_Unit__c = business_unitsToInsert[0].Id, Centre__c = centresToInsert[2].Id, Area_of_Premises__c = 230.90);
        Unit__c unit2 = new Unit__c(Name = 'KL672', Building__c = buildingsToInsert[2].Id, Business_Unit__c = business_unitsToInsert[1].Id, Centre__c = centresToInsert[2].Id, Area_of_Premises__c = 190.77);
        Unit__c unit3 = new Unit__c(Name = 'GG298', Building__c = buildingsToInsert[0].Id, Business_Unit__c = business_unitsToInsert[1].Id, Centre__c = centresToInsert[0].Id, Area_of_Premises__c = 489.90);
        Unit__c unit4 = new Unit__c(Name = 'KK293', Building__c = buildingsToInsert[4].Id, Business_Unit__c = business_unitsToInsert[1].Id, Centre__c = centresToInsert[1].Id, Area_of_Premises__c = 283.90);


        unitsToInsert.add(unit1);
        unitsToInsert.add(unit2);
        unitsToInsert.add(unit3);
        unitsToInsert.add(unit4);


        insert unitsToInsert;

        // Create multiple Rates and Taxes data into Rates_and_Taxes__c object
        List<Rates_and_Taxes__c> rates_and_taxesToInsert = new List<Rates_and_Taxes__c>();

        Rates_and_Taxes__c rate1 = new Rates_and_Taxes__c(Log_Class__c = 'EP', Log_Level__c = 'U', Amenity_Code__c = 'AAVB', Rate__c = 5001, Business_Unit__c = business_unitsToInsert[0].Id, Begin_Date__c = Date.newInstance(2017, 07, 01), Unit__c = unitsToInsert[0].Id);
        Rates_and_Taxes__c rate2 = new Rates_and_Taxes__c(Log_Class__c = 'AS', Log_Level__c = 'U', Amenity_Code__c = 'ANCR', Rate__c = 244, Business_Unit__c = business_unitsToInsert[2].Id, Begin_Date__c = Date.newInstance(2017, 07, 01), Unit__c = unitsToInsert[1].Id);
        Rates_and_Taxes__c rate3 = new Rates_and_Taxes__c(Log_Class__c = 'AU', Log_Level__c = 'U', Amenity_Code__c = 'AAV', Rate__c = 776, Business_Unit__c = business_unitsToInsert[0].Id, Begin_Date__c = Date.newInstance(2017, 07, 01), Unit__c = unitsToInsert[2].Id);

        rates_and_taxesToInsert.add(rate1);
        rates_and_taxesToInsert.add(rate2);
        rates_and_taxesToInsert.add(rate3);

        insert rates_and_taxesToInsert;

        // Create multiple Outgoings data into Centre_Outgoings__c object

        List<Centre_Outgoings__c> centre_outgoingsToInsert = new List<Centre_Outgoings__c>();

        Centre_Outgoings__c centreOutgoing1 = new Centre_Outgoings__c(Business_Unit_Key__c = '71', Amenity_Code__c = 'CRNL', Rate__c = 2983, Critical_Date__c = Date.newInstance(2018, 07, 01), Business_Unit__c = business_unitsToInsert[0].Id, Begin_Date__c = Date.newInstance(2017, 07, 01));
        Centre_Outgoings__c centreOutgoing2 = new Centre_Outgoings__c(Business_Unit_Key__c = '72', Amenity_Code__c = 'CRMM', Rate__c = 567, Critical_Date__c = Date.newInstance(2016, 07, 01), Business_Unit__c = business_unitsToInsert[1].Id, Begin_Date__c = Date.newInstance(2017, 07, 01));
        Centre_Outgoings__c centreOutgoing3 = new Centre_Outgoings__c(Business_Unit_Key__c = '74', Amenity_Code__c = 'CRN', Rate__c = 5675, Critical_Date__c = Date.newInstance(2018, 07, 01), Business_Unit__c = business_unitsToInsert[2].Id, Begin_Date__c = Date.newInstance(2017, 07, 01));
        Centre_Outgoings__c centreOutgoing4 = new Centre_Outgoings__c(Business_Unit_Key__c = '75', Amenity_Code__c = 'CRNR', Rate__c = 234, Critical_Date__c = Date.newInstance(2018, 07, 01), Business_Unit__c = business_unitsToInsert[1].Id, Begin_Date__c = Date.newInstance(2017, 07, 01));
        Centre_Outgoings__c centreOutgoing5 = new Centre_Outgoings__c(Business_Unit_Key__c = '76', Amenity_Code__c = 'CRN', Rate__c = 934, Critical_Date__c = Date.newInstance(2016, 07, 01), Business_Unit__c = business_unitsToInsert[3].Id, Begin_Date__c = Date.newInstance(2016, 07, 01));

        centre_outgoingsToInsert.add(centreOutgoing1);
        centre_outgoingsToInsert.add(centreOutgoing2);
        centre_outgoingsToInsert.add(centreOutgoing3);
        centre_outgoingsToInsert.add(centreOutgoing4);
        centre_outgoingsToInsert.add(centreOutgoing5);


        insert centre_outgoingsToInsert;

    }
}