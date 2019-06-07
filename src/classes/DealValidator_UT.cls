/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class DealValidator_UT {

    static testMethod void validateTP() {

        Unit__c newUnit1 = new Unit__c();
        insert newUnit1;

        Opportunity newOpp1 = new Opportunity();
        newOpp1.Unit__c = newUnit1.Id;
        newOpp1.Name = 'test';
        newOpp1.Deal_Key__c = 'AA00060';
        newOpp1.StageName = 'Deal Builder';
        newOpp1.CloseDate = Date.today();
        newOpp1.Lease_Incentive_Amount__c = 5;
        insert newOpp1;

        test.startTest();

        DealValidator validator = new DealValidator();

        Boolean errors = validator.hasError;

        validator.validateTenantProfile(newOpp1);

        test.stopTest();
    }

    static testMethod void validateTDP1() {

        Unit__c newUnit1 = new Unit__c();
        insert newUnit1;

        Opportunity newOpp1 = new Opportunity();
        newOpp1.Unit__c = newUnit1.Id;
        newOpp1.Name = 'test';
        newOpp1.Deal_Key__c = 'AA00060';
        newOpp1.StageName = 'Deal Builder';
        newOpp1.CloseDate = Date.today();
        newOpp1.Lease_Incentive_Amount__c = 5;
        insert newOpp1;

        test.startTest();

        DealValidator validator = new DealValidator(newOpp1);

        Boolean errors = validator.hasError;

        validator.validateTDP();

        test.stopTest();
    }


    static testMethod void validateTDP2() {

        Unit__c newUnit1 = new Unit__c();
        insert newUnit1;

        Opportunity newOpp1 = new Opportunity();
        newOpp1.Unit__c = newUnit1.Id;
        newOpp1.Name = 'test';
        newOpp1.Deal_Key__c = 'AA00060';
        newOpp1.StageName = 'Deal Builder';
        newOpp1.New_Retailer__c = true;
        newOpp1.Recovery_Type__c = 'Gross';
        newOpp1.CloseDate = Date.today();
        newOpp1.Lease_Incentive_Amount__c = 5;
        insert newOpp1;

        test.startTest();

        DealValidator validator = new DealValidator();

        Boolean errors = validator.hasError;

        validator.validateTDP(newOpp1);

        test.stopTest();
    }

    static testMethod void validateTDP3() {

        Centre__c objCentre = VC_UnitTestFactory.buildTestCentre();
        objCentre.State__c = 'VIC';
        insert objCentre;

        Building__c objBuilding = VC_UnitTestFactory.buildTestBuilding();
        objBuilding.Centre_Key__c = objCentre.Centre_Key__c;
        objBuilding.Centre__c = objCentre.Id;
        insert objBuilding;

        Unit__c newUnit1 = new Unit__c();
        newUnit1.Building__c = objBuilding.Id;
        insert newUnit1;

        Opportunity newOpp1 = new Opportunity();
        newOpp1.Unit__c = newUnit1.Id;
        newOpp1.Name = 'test';
        newOpp1.Deal_Key__c = 'AA00060';
        newOpp1.StageName = 'Deal Builder';
        newOpp1.Existing_Retailer__c = true;
        newOpp1.Recovery_Type__c = 'Net';
        newOpp1.CloseDate = Date.today();
        newOpp1.Lease_Incentive_Amount__c = 5;
        insert newOpp1;

        test.startTest();

        DealValidator validator = new DealValidator();

        Boolean errors = validator.hasError;

        validator.validateTDP(newOpp1);

        test.stopTest();
    }

    static testMethod void validateEOI1() {

        Unit__c newUnit1 = new Unit__c();
        insert newUnit1;

        Opportunity newOpp1 = new Opportunity();
        newOpp1.Unit__c = newUnit1.Id;
        newOpp1.Name = 'test';
        newOpp1.Deal_Key__c = 'AA00060';
        newOpp1.StageName = 'Deal Builder';
        newOpp1.CloseDate = Date.today();
        newOpp1.Lease_Incentive_Amount__c = 5;
        newOpp1.New_Retailer__c = true;
        newOpp1.Recovery_Type__c = 'Net';
        insert newOpp1;

        test.startTest();

        DealValidator validator = new DealValidator();

        Boolean errors = validator.hasError;

        validator.validateEOI(newOpp1);

        test.stopTest();
    }

    static testMethod void validateLON1() {

        Unit__c newUnit1 = new Unit__c();
        insert newUnit1;

        Opportunity newOpp1 = new Opportunity();
        newOpp1.Unit__c = newUnit1.Id;
        newOpp1.Name = 'test';
        newOpp1.Deal_Key__c = 'AA00060';
        newOpp1.StageName = 'Deal Builder';
        newOpp1.CloseDate = Date.today();
        newOpp1.New_Auth_Rep_Added__c = true;
        newOpp1.New_Leg_Rep_Added__c = true;
        newOpp1.Type_of_Guarantor_Required__c = 'PA';
        newOpp1.Percentage_Rent_Threshold__c = 'Artificial';
        newOpp1.Surrender_these_premises_in_Centre__c = true;
        newOpp1.Storage__c = true;
        newOpp1.Is_Taking_Existing_Fitout__c = true;
        newOpp1.Bank_Guarentee__c = 1;
        newOpp1.Bank_Guarantee_Months__c = 1;
        newOpp1.Bank_Guarantee_Requirement__c = 'Existing';
        newOpp1.Rent_Review_Rate_And_Type__c = 'Fixed';
        newOpp1.Existing_Fitout_Taken_Over_By_Tenant__c = 'OT;';
        newOpp1.Lease_Incentive__c = true;
        newOpp1.Deal_Type__c = 'New Tenant As Is';
        newOpp1.Non_Standard_Special_Conditions__c = 'LON038';
        /*newOpp1.Non_Standard_Special_Conditions__c = 'LON038;LON001;LON065;LON046;LON003;LON004;LON053;' +
                'LON007;XDISTR;LON009;LON008;LON045;LON010;LON011;LON012;' +
                'LON067;LON017;LQRLIC;LON019;LON020;OPTDET;OPTRRV;PROMRV;' +
                'RENTRV;LON050;LON021;LON044;LON066;LON061;XREPRE;LON025;' +
                'LON049;LON026;LON062;LON033;SURFEE;LON031;LON032;LON034;' +
                'LON054;LON037;WAMTE5YT;WAMTLMT;WAMTLT'
                ;*/
        newOpp1.Lease_Incentive_Amount__c = 5;

        insert newOpp1;

        test.startTest();

        DealValidator validator = new DealValidator();

        Boolean errors = validator.hasError;

        validator.validateLON(newOpp1, true);

        test.stopTest();
    }

    static testMethod void validateEOIConditions() {

        test.startTest();

        //Centre
        Centre__c myCentre = VC_UnitTestFactory.buildTestCentre();

        insert myCentre;

        //Building
        Building__c myBuilding = VC_UnitTestFactory.buildTestBuilding();
        myBuilding.Centre__c = myCentre.Id;

        insert myBuilding;

        //Unit
        Unit__c theUnit = new Unit__c();
        theUnit.Unit_Type__c = 'Kiosk';
        theUnit.Building__c = myBuilding.Id;

        insert theUnit;


        Opportunity theOpportunity = new Opportunity();
        theOpportunity.Unit__c = theUnit.Id;
        theOpportunity.Name = 'test';
        theOpportunity.Deal_Key__c = 'AA00060';
        theOpportunity.StageName = 'Deal Builder';
        theOpportunity.CloseDate = Date.today();
        theOpportunity.Lease_Incentive_Amount__c = 5;
        theOpportunity.New_Retailer__c = true;
        theOpportunity.Recovery_Type__c = 'Gross';
        theOpportunity.Deal_Type__c = 'New Tenant Standard';
        theOpportunity.Dev_Clause__c = true;
        theOpportunity.Lease_Term_Months__c = 12;
        theOpportunity.Design_Review_Fees_At_Commencement__c = true;
        theOpportunity.Hoarding_At_Commencement__c = true;
        theOpportunity.Surrender_these_premises_in_Centre__c = true; // With no Surrender_these_premises_Date_Options__c - Throws the error - errorMsgs.add('Tenant Surrender These Premises: Surrender Date is required.');
        // With no Surrender_these_premises_Make_Good__c - Throws the error - errorMsgs.add('Tenant Surrender These Premises: Make Good by Tenant is required.');


        insert theOpportunity;

        Opportunity theOpportunity2 = new Opportunity();
        theOpportunity2.Unit__c = theUnit.Id;
        theOpportunity2.Name = 'test';
        theOpportunity2.Deal_Key__c = 'AA00061';
        theOpportunity2.StageName = 'Deal Builder';
        theOpportunity2.CloseDate = Date.today().addDays(2);
        theOpportunity2.Lease_Incentive_Amount__c = 5;
        theOpportunity2.New_Retailer__c = true; // With no New_Trading_Name__c - Throws the error - errorMsgs.add('Trading Name is required.');
        theOpportunity2.Deal_Type__c = 'New Tenant Standard';
        theOpportunity2.Dev_Clause__c = true; // With no Area_of_premises_sqmt__c - Throws the error - errorMsgs.add('Area of premises is required.');
        theOpportunity2.Lease_Term_Months__c = 12; // Throws the error - errorMsgs.add('Invalid Lease Term Months.');
        theOpportunity2.Design_Review_Fees_At_Commencement__c = true; // Throws the error - errorMsgs.add('Design Review Fee is required');
        theOpportunity2.Hoarding_At_Commencement__c = true; // Throws the error - errorMsgs.add('Hoarding rate is required.');
        theOpportunity2.Lease_Term_Days__c = 32; //Throws the error - errorMsgs.add('Invalid Lease Term Days.');
        theOpportunity2.Surrender_other_premises_Date_Options__c = 'Fixed Date'; // With no Surrender_other_premises_Date__c - Throws the error - errorMsgs.add('Tenant Surrender Other Premises: Surrender Date is required.');
        theOpportunity2.Surrender_other_premises_in_Centre__c = true; // With no Surrender_other_premises_Make_Good__c - Throws the error - errorMsgs.add('Tenant Surrender Other Premises: Make Good by Tenant is required.');
        // With no Surrender_other_premises_Unit__c - Throws the error - errorMsgs.add('Tenant Surrender Other Premises: Unit No is required.');
        // With no Surrender_these_premises_Date_Options__c - Throws the error - errorMsgs.add('Tenant Surrender These Premises: Surrender Date is required.');
        theOpportunity2.Liquor_Licence__c = true;
        theOpportunity2.LQRLIC_Options__c = '1'; // With no Liqour_Licence_Date__c - Throws the error - errorMsgs.add(fieldMap.get('Liqour_Licence_Date__c').getDescribe().getLabel() + ' is required.');
        theOpportunity2.Seating_Licence__c = true;

        insert theOpportunity2;

        Opportunity theOpportunity3 = new Opportunity();
        theOpportunity3.Unit__c = theUnit.Id;
        theOpportunity3.Name = 'test';
        theOpportunity3.Deal_Key__c = 'AA00062';
        theOpportunity3.StageName = 'Deal Builder';
        theOpportunity3.CloseDate = Date.today().addDays(2);
        theOpportunity3.Surrender_other_premises_in_Centre__c = true; // With no Surrender_other_premises_Date_Options__c - Throws the error - errorMsgs.add('Tenant Surrender Other Premises: Surrender Date is required.');
        theOpportunity3.Surrender_these_premises_Date_Options__c = 'Fixed Date'; // With no Surrender_these_premises_Date__c - Throws the error - errorMsgs.add('Tenant Surrender These Premises: Surrender Date is required.');
        theOpportunity3.Liquor_Licence__c = true; // With no LQRLIC_Options__c - Throws the error - errorMsgs.add(fieldMap.get('LQRLIC_Options__c').getDescribe().getLabel() + ' is required.');
        theOpportunity3.Recovery_Type__c = 'Net';
        theOpportunity3.Rates_and_Taxes_Amount__c = 0;
        theOpportunity3.Storage__c = true; // With no Area_of_Storage__c - Throws the error - errorMsgs.add(fieldMap.get('Area_of_Storage__c').getDescribe().getLabel() + ' is required.');
        theOpportunity3.Fitout_Contribution__c = true; // With no Fitout_Contribution_Amount__c - Throws the error - errorMsgs.add(fieldMap.get('Fitout_Contribution_Amount__c').getDescribe().getLabel() + ' is required.');
        theOpportunity3.Refurbishment_Contribution__c = true; // With no Refurbishment_Contribution_Amount__c - Throws the error -  errorMsgs.add(fieldMap.get('Refurbishment_Contribution_Amount__c').getDescribe().getLabel() + ' is required.');
        theOpportunity3.Seating_Licence__c = true; // With no Seating_Licence_Type__c - Throws the error - errorMsgs.add(fieldMap.get('Seating_Licence_Type__c').getDescribe().getLabel() + ' is required.');
        // With no Seating_License_Area__c - Throws the error - errorMsgs.add(fieldMap.get('Seating_License_Area__c').getDescribe().getLabel() + ' is required.');
        theOpportunity3.Seating_Licence_Type__c = 'S';


        insert theOpportunity3;


        DealValidator validator = new DealValidator();
        Boolean errors = validator.hasError;
        validator.validateEOI(theOpportunity);

        DealValidator validator2 = new DealValidator();
        Boolean errors2 = validator2.hasError;
        validator2.validateEOI(theOpportunity2);

        DealValidator validator3 = new DealValidator();
        Boolean errors3 = validator3.hasError;
        validator3.validateEOI(theOpportunity3);

        test.stopTest();
    }

    static testMethod void validateLONConditions() {

        // LON025;LON035 can't test for as no longer Active in Picklist

        test.startTest();

        //Centre
        Centre__c myCentre = VC_UnitTestFactory.buildTestCentre();

        insert myCentre;

        //Building
        Building__c myBuilding = VC_UnitTestFactory.buildTestBuilding();
        myBuilding.Centre__c = myCentre.Id;

        insert myBuilding;

        //Unit
        Unit__c theUnit = new Unit__c();
        theUnit.Unit_Type__c = 'Kiosk';
        theUnit.Building__c = myBuilding.Id;

        insert theUnit;


        Opportunity theOpportunity = new Opportunity();
        theOpportunity.Unit__c = theUnit.Id;
        theOpportunity.Name = 'test';
        theOpportunity.Deal_Key__c = 'AA00060';
        theOpportunity.StageName = 'Deal Builder';
        theOpportunity.CloseDate = Date.today();
        theOpportunity.Lease_Incentive_Amount__c = 5;
        theOpportunity.New_Retailer__c = true;
        theOpportunity.Recovery_Type__c = 'Gross';
        theOpportunity.Deal_Type__c = 'New Tenant Standard';
        theOpportunity.Dev_Clause__c = true;
        theOpportunity.Lease_Term_Months__c = 12;
        theOpportunity.Design_Review_Fees_At_Commencement__c = true;
        theOpportunity.Hoarding_At_Commencement__c = true;
        theOpportunity.Surrender_these_premises_in_Centre__c = true; // With no Surrender_these_premises_Date_Options__c - Throws the error - errorMsgs.add('Tenant Surrender These Premises: Surrender Date is required.');
        // With no Surrender_these_premises_Make_Good__c - Throws the error - errorMsgs.add('Tenant Surrender These Premises: Make Good by Tenant is required.');
        theOpportunity.Is_Taking_Existing_Fitout__c = true; // With no Existing_Fitout_Taken_Over_By_Tenant__c - Throws the error - errorMsgs.add('Existing Fitout Taken Over By Tenant is required.');
        theOpportunity.Rent_Review_Rate_And_Type__c = 'Fixed';
        theOpportunity.Rent_Review_Free_Format_Clause__c = 'xxx';
        theOpportunity.Bank_Guarantee_Requirement__c = 'Existing';

        insert theOpportunity;

        Opportunity theOpportunity2 = new Opportunity();
        theOpportunity2.Unit__c = theUnit.Id;
        theOpportunity2.Name = 'test';
        theOpportunity2.Deal_Key__c = 'AA00061';
        theOpportunity2.StageName = 'Deal Builder';
        theOpportunity2.CloseDate = Date.today().addDays(2);
        theOpportunity2.Lease_Incentive_Amount__c = 5;
        theOpportunity2.New_Retailer__c = true; // With no New_Trading_Name__c - Throws the error - errorMsgs.add('Trading Name is required.');
        theOpportunity2.Deal_Type__c = 'New Tenant Standard';
        theOpportunity2.Dev_Clause__c = true; // With no Area_of_premises_sqmt__c - Throws the error - errorMsgs.add('Area of premises is required.');
        theOpportunity2.Lease_Term_Months__c = 12; // Throws the error - errorMsgs.add('Invalid Lease Term Months.');
        theOpportunity2.Design_Review_Fees_At_Commencement__c = true; // Throws the error - errorMsgs.add('Design Review Fee is required');
        theOpportunity2.Hoarding_At_Commencement__c = true; // Throws the error - errorMsgs.add('Hoarding rate is required.');
        theOpportunity2.Lease_Term_Days__c = 32; //Throws the error - errorMsgs.add('Invalid Lease Term Days.');
        theOpportunity2.Surrender_other_premises_Date_Options__c = 'Fixed Date'; // With no Surrender_other_premises_Date__c - Throws the error - errorMsgs.add('Tenant Surrender Other Premises: Surrender Date is required.');
        theOpportunity2.Surrender_other_premises_in_Centre__c = true; // With no Surrender_other_premises_Make_Good__c - Throws the error - errorMsgs.add('Tenant Surrender Other Premises: Make Good by Tenant is required.');
        // With no Surrender_other_premises_Unit__c - Throws the error - errorMsgs.add('Tenant Surrender Other Premises: Unit No is required.');
        // With no Surrender_these_premises_Date_Options__c - Throws the error - errorMsgs.add('Tenant Surrender These Premises: Surrender Date is required.');
        theOpportunity2.Liquor_Licence__c = true;
        theOpportunity2.LQRLIC_Options__c = '1'; // With no Liqour_Licence_Date__c - Throws the error - errorMsgs.add(fieldMap.get('Liqour_Licence_Date__c').getDescribe().getLabel() + ' is required.');
        theOpportunity2.Rent_Review_Rate_And_Type__c = 'Market';
        theOpportunity2.Rent_Review_Free_Format_Clause__c = 'xxx';
        theOpportunity2.Rent_Review_Percentage__c = 2;
        theOpportunity2.Bank_Guarantee_Requirement__c = 'Group';

        insert theOpportunity2;

        Opportunity theOpportunity3 = new Opportunity();
        theOpportunity3.Unit__c = theUnit.Id;
        theOpportunity3.Deal_Type__c = 'Renewal';
        theOpportunity3.Name = 'test';
        theOpportunity3.Deal_Key__c = 'AA00062';
        theOpportunity3.StageName = 'Deal Builder';
        theOpportunity3.CloseDate = Date.today().addDays(2);
        theOpportunity3.Surrender_other_premises_in_Centre__c = true; // With no Surrender_other_premises_Date_Options__c - Throws the error - errorMsgs.add('Tenant Surrender Other Premises: Surrender Date is required.');
        theOpportunity3.Surrender_these_premises_Date_Options__c = 'Fixed Date'; // With no Surrender_these_premises_Date__c - Throws the error - errorMsgs.add('Tenant Surrender These Premises: Surrender Date is required.');
        theOpportunity3.Liquor_Licence__c = true; // With no LQRLIC_Options__c - Throws the error - errorMsgs.add(fieldMap.get('LQRLIC_Options__c').getDescribe().getLabel() + ' is required.');
        theOpportunity3.Recovery_Type__c = 'Net';
        theOpportunity3.Rates_and_Taxes_Amount__c = 0;
        theOpportunity3.Storage__c = true; // With no Area_of_Storage__c - Throws the error - errorMsgs.add(fieldMap.get('Area_of_Storage__c').getDescribe().getLabel() + ' is required.');
        theOpportunity3.Fitout_Contribution__c = true; // With no Fitout_Contribution_Amount__c - Throws the error - errorMsgs.add(fieldMap.get('Fitout_Contribution_Amount__c').getDescribe().getLabel() + ' is required.');
        theOpportunity3.Refurbishment_Contribution__c = true; // With no Refurbishment_Contribution_Amount__c - Throws the error -  errorMsgs.add(fieldMap.get('Refurbishment_Contribution_Amount__c').getDescribe().getLabel() + ' is required.');
        theOpportunity3.Seating_Licence__c = true; // With no Seating_Licence_Type__c - Throws the error - errorMsgs.add(fieldMap.get('Seating_Licence_Type__c').getDescribe().getLabel() + ' is required.');
        // With no Seating_License_Area__c - Throws the error - errorMsgs.add(fieldMap.get('Seating_License_Area__c').getDescribe().getLabel() + ' is required.');
        theOpportunity3.Seating_Licence_Type__c = 'S';

        // Non Standard Special Conditions testing work.
        theOpportunity3.Non_Standard_Special_Conditions__c = 'LON001';
        /*theOpportunity3.Non_Standard_Special_Conditions__c = 'LON001;LON044;LON007;LON010;LON020;LON045;LON046;LON049;LON003;LON004;LON008;LON009;LON066;LON067;' +
                'LQRLIC;BGED;DSA;FROR;HOARDSKIN;LICCPFP;LICCWCP;LICSIGNS;LICSIGNEX;LICSIGNCP;MGNR;OLLTS;OLLTL;PRNOC;REBRAND;SPRUIK;SFNPBT;TTALL;TTSA;NOBIND;LOGO;CONF;DISCAMEND;' +
                'AFFPBC;AFFPAC;COT;EZPK;EZCML;FFTRN;FSTSF;HDTRORD;HDDABP;LLWDTPP;RPSMA;FRL;TRADHRS;STPAN;HOARDCAP;HOARD50;ROL;CAT1CAP;STCBA;HDOVR;INTER;DIRDEB;' +
                'LON017;LON020;LON031;LON037;LON044;LON054;OPTDET;OPTRRV;XDISTR;XREPRE;LQRLIC;VPTR;LON025';*/
        theOpportunity3.LON001_Custom_Text__c = true;
        theOpportunity3.LON044_Custom_Refit_Condition__c = true;
        theOpportunity3.LON007_Custom_Text__c = true;
        theOpportunity3.LON010_Custom_Text__c = true;
        theOpportunity3.LON020_Custom_Text__c = true;
        theOpportunity3.LON045_Custom_Text__c = true;
        theOpportunity3.LON046_Custom_Text__c = true;
        theOpportunity3.LON049_Custom_Text__c = true;
        theOpportunity3.LON003_Options__c = '1';
        theOpportunity3.LON004_Options__c = '1';
        theOpportunity3.LON008_Options__c = '1';
        theOpportunity3.LON009_Options__c = '1';
        theOpportunity3.LON066_Options__c = '1';
        theOpportunity3.LON067_Custom_Text__c = true;
        theOpportunity3.LON017_Options__c = '2';
        theOpportunity3.LON020_Options__c = '1';
        theOpportunity3.LON020_Options__c = '2';
        theOpportunity3.LON025_Options__c = '1';
        theOpportunity3.LON037_Options__c = '1';
        theOpportunity3.LON044_Options__c = '1';
        theOpportunity3.LON054_Options__c = '1';
        //theOpportunity3.LON059_Options__c = '1';
        theOpportunity3.OPTDET_Options__c = '1';
        theOpportunity3.OPTRRV_Options__c = '1';
        theOpportunity3.XDISTR_Options__c = '1';
        theOpportunity3.XREPRE_Options__c = '1';
        theOpportunity3.LQRLIC_Options__c = '1';
        theOpportunity3.Opening_Promotion_Amount__c = 10;
        theOpportunity3.LON025_Options__c = '1';
        theOpportunity3.Rent_Review_Rate_And_Type__c = 'Non Standard';
        theOpportunity3.Rent_Review_Percentage__c = 10;
        theOpportunity3.Bank_Guarantee_Requirement__c = 'No';
        theOpportunity3.Bank_Guarentee__c = 2;
        theOpportunity3.Type_of_Guarantor_Required__c = 'NA';
        theOpportunity3.No_of_Personal_Guarantee__c = 2;
        theOpportunity3.Storage__c = true;
        theOpportunity3.Surrender_other_premises_Fees__c = 1;



        insert theOpportunity3;

        Opportunity theOpportunity4 = new Opportunity();
        theOpportunity4.Unit__c = theUnit.Id;
        theOpportunity4.Deal_Type__c = 'Renewal';
        theOpportunity4.Name = 'test';
        theOpportunity4.Deal_Key__c = 'AA00063';
        theOpportunity4.StageName = 'Deal Builder';
        theOpportunity4.CloseDate = Date.today().addDays(2);
        // Non Standard Special Conditions testing work.
        theOpportunity4.Non_Standard_Special_Conditions__c = 'LON020;LON031';
        theOpportunity4.LON020_Options__c = '1';
        theOpportunity4.TP_Promotion_Contribution_Percentage__c = 5;
        theOpportunity4.TP_Percentage_Rent_Rate__c = 5;
        theOpportunity4.Promo_Review_Rate_and_Type__c = 'Non Standard';
        theOpportunity4.Bank_Guarantee_Requirement__c   = 'Yes';
        theOpportunity4.Type_of_Guarantor_Required__c = 'PE';
        theOpportunity4.Storage__c = true;
        theOpportunity4.Storage_Rate_Type__c = 'MT';
        theOpportunity4.Lease_Incentive__c = true;
        theOpportunity4.Car_park_exclusive_for_tenant__c = true;
        theOpportunity4.Surrender_other_premises_Fees__c = 1;
        theOpportunity4.SURFEE_Options__c = '1';

        Opportunity theOpportunity5 = new Opportunity();
        theOpportunity5.Unit__c = theUnit.Id;
        theOpportunity5.Deal_Type__c = 'Renewal';
        theOpportunity5.Name = 'test';
        theOpportunity5.Deal_Key__c = 'AA00063';
        theOpportunity5.StageName = 'Deal Builder';
        theOpportunity5.CloseDate = Date.today().addDays(2);


        insert theOpportunity4;
        DealValidator validator = new DealValidator();
        Boolean errors = validator.hasError;
        Boolean valid1 = validator.validateLON(theOpportunity, true);

        DealValidator validator2 = new DealValidator();
        Boolean errors2 = validator2.hasError;
        Boolean valid2 = validator2.validateLON(theOpportunity2, true);

        DealValidator validator3 = new DealValidator();
        Boolean errors3 = validator3.hasError;
        Boolean valid3 = validator3.validateLON(theOpportunity3, true);

        DealValidator validator4 = new DealValidator();
        Boolean errors4 = validator4.hasError;
        Boolean valid4 = validator4.validateLON(theOpportunity4, true);

        DealValidator validator5 = new DealValidator();
        Boolean errors5 = validator5.hasError;
        Boolean valid5 = validator5.validateLON(theOpportunity5, true);

        test.stopTest();
    }
}