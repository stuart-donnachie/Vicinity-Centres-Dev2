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
private class SpecialConditionsHelper_UT {

    static testMethod void myUnitTest1() {

        Centre__c objCentre = VC_UnitTestFactory.buildTestCentre();

        insert objCentre;

        Building__c objBuilding = VC_UnitTestFactory.buildTestBuilding();
        objBuilding.Centre_Key__c = objCentre.Centre_Key__c;
        objBuilding.Centre__c = objCentre.Id;
        insert objBuilding;

        Unit__c newUnit1 = VC_UnitTestFactory.buildTestUnit();
        newUnit1.Centre_Key__c = objCentre.Centre_Key__c;
        newUnit1.Centre__c = objCentre.Id;
        newUnit1.Building_Key__c = objBuilding.Building_Key__c;
        newUnit1.Unit_Code__c = '45ATM';
        newUnit1.Building__c = objBuilding.Id;
        insert newUnit1;

        Opportunity newOpp1 = new Opportunity();
        newOpp1.Name = 'test';
        newOpp1.StageName = 'test';
        newOpp1.CloseDate = Date.today();
        newOpp1.API_Error__c = false;
        newOpp1.Is_Incomplete__c = false;
        newOpp1.Liquor_Licence__c = false;
        newOpp1.Common_Area_Trading_Flag__c = true;
        newOpp1.Lease_Incentive_Amount__c = 5;
        newOpp1.Surrender_other_premises_Fees__c = 5;
        newOpp1.Bank_Guarantee_Requirement__c = 'Group';
        newOpp1.Group_Security_No_of_Months_Required__c = 5;
        newOpp1.Unit__c = newUnit1.Id;
        newOpp1.Deal_Key__c = 'AA11035';
        newOpp1.Waiver_Certificate_Required__c = true;
        newOpp1.Deal_Type__c = 'New Tenant Standard';
        newOpp1.Is_Taking_Existing_Fitout__c = true;
        newOpp1.Exclusive_Zone__c = true;
        newOpp1.Franchisor__c = 'O';
        newOpp1.Bank_Guarantee_Requirement__c = 'Existing';
        newOpp1.Non_Standard_Special_Conditions__c = 'LON038';
        /*newOpp1.Non_Standard_Special_Conditions__c = 'LON038;LON001;LON065;LON046;LON003;LON004;LON053;' +
                'LON007;XDISTR;LON009;LON008;LON045;LON010;LON011;LON012;' +
                'LON067;LON017;LQRLIC;LON019;LON020;OPTDET;OPTRRV;PROMRV;' +
                'RENTRV;LON050;LON021;LON044;LON066;LON061;XREPRE;LON025;' +
                'LON049;LON026;LON062;LON033;SURFEE;LON031;LON032;LON034;' +
                'LON054;LON037;WAMTE5YT;WAMTLMT;WAMTLT;BGED;DSA;FROR;' +
                'HOARDSKIN;LICCPFP;LICCPFL;LICCWCP;LICSIGNS;MGNR;OLLTS;' +
                'OLLTL;PRNOC;REBRAND;SPRUIK;SFNPBT;TTALL;TTSA;NOBIND;' +
                'LOGO;CONF;DISCAMEND';*/
        insert newOpp1;


        newUnit1.Preferred_Tenant__c = newOpp1.Id;
        update newUnit1;

        test.startTest();

        SpecialConditionsHelper helper = new SpecialConditionsHelper();
        helper = new SpecialConditionsHelper(newOpp1);
        helper.setSpecialConditions(newOpp1, 'Non_Standard_Special_Conditions__c', false);

        newOpp1.Waiver_Certificate_Required__c = false;
        newOpp1.Is_Taking_Existing_Fitout__c = false;
        newOpp1.Exclusive_Zone__c = false;
        newOpp1.Liquor_Licence__c = true;
        newOpp1.LQRLIC_Options__c = '1';
        newOpp1.Liqour_Licence_Date__c = Date.today();
        newOpp1.Fitout_Contribution__c = true;
        newOpp1.Rent_Review_Rate_And_Type__c = 'Non Standard';
        newOpp1.Promo_Review_Rate_And_Type__c = 'Non Standard';
        newOpp1.Deal_Type__c = 'New Tenant As Is';
        newOpp1.recalculateFormulas();
        helper.setSpecialConditions(newOpp1, 'Non_Standard_Special_Conditions__c', false);

        newOpp1.Liquor_Licence__c = true;
        newOpp1.LQRLIC_Options__c = '2';
        newOpp1.Deal_Type__c = 'Renewal';
        newOpp1.recalculateFormulas();
        helper.setSpecialConditions(newOpp1, 'Non_Standard_Special_Conditions__c', false);

        newOpp1.Liquor_Licence__c = true;
        newOpp1.LQRLIC_Options__c = '3';
        newOpp1.recalculateFormulas();
        helper.setSpecialConditions(newOpp1, 'Non_Standard_Special_Conditions__c', false);

        newOpp1.Non_Standard_Special_Conditions__c = null;
        newOpp1.recalculateFormulas();
        helper.setSpecialConditions(newOpp1, 'Non_Standard_Special_Conditions__c', false);

        newOpp1.Non_Standard_Special_Conditions__c = 'LON038';
        /*newOpp1.Non_Standard_Special_Conditions__c = 'LON038;LON001;LON065;LON046;LON003;LON004;LON053;' +
                'LON007;XDISTR;LON009;LON008;LON045;LON010;LON011;LON012;' +
                'LON067;LON017;LQRLIC;LON019;LON020;OPTDET;OPTRRV;PROMRV;' +
                'RENTRV;LON050;LON021;LON044;LON066;LON061;XREPRE;LON025;' +
                'LON049;LON026;LON062;LON033;SURFEE;LON031;LON032;LON034;' +
                'LON054;LON037;WAMTE5YT;WAMTLMT;WAMTLT;BGED;DSA;FROR;' +
                'HOARDSKIN;LICCPFP;LICCPFL;LICCWCP;LICSIGNS;MGNR;OLLTS;' +
                'OLLTL;PRNOC;REBRAND;SPRUIK;SFNPBT;TTALL;TTSA;NOBIND;' +
                'LOGO;CONF;DISCAMEND';*/
        newOpp1.recalculateFormulas();
        helper.setSpecialConditions(newOpp1, null, false);

        newOpp1.Bank_Guarantee_Requirement__c = 'Group';
        newOpp1.Group_Security_Percentage_Required__c = 5;
        newOpp1.recalculateFormulas();
        helper.setSpecialConditions(newOpp1, null, false);

        newOpp1.Bank_Guarantee_Requirement__c = 'Group';
        newOpp1.Group_Security_Percentage_Required__c = 0;
        newOpp1.Group_Security_No_of_Months_Required__c = 5;
        newOpp1.recalculateFormulas();
        helper.setSpecialConditions(newOpp1, null, false);

        newOpp1.Bank_Guarantee_Requirement__c = 'Group';
        newOpp1.Group_Security_Percentage_Required__c = 0;
        newOpp1.Group_Security_No_of_Months_Required__c = 0;
        newOpp1.Group_Security_Amount__c = 5;
        newOpp1.Deal_Type__c = 'New Tenant As Is';
        newOpp1.Fitout_Contribution__c = false;
        newOpp1.recalculateFormulas();
        helper.setSpecialConditions(newOpp1, null, false);


        objCentre.State__c = 'ACT';
        update objCentre;
        newOpp1.Non_Standard_Special_Conditions__c = 'LON038';
        newOpp1.Waiver_Certificate_Required__c = true;
        helper.setSpecialConditions(newOpp1, null, false);

        objCentre.State__c = 'NSW';
        update objCentre;
        newOpp1.Non_Standard_Special_Conditions__c = 'LON038';
        newOpp1.Waiver_Certificate_Required__c = true;
        helper.setSpecialConditions(newOpp1, null, false);

        newOpp1.Surrender_other_premises_in_Centre__c = true;
        newOpp1.Surrender_these_premises_in_Centre__c = false;
        newOpp1.Surrender_other_premises_Legal_Cost__c = 'Landlord';
        helper.setSpecialConditions(newOpp1, null, false);

        newOpp1.Surrender_other_premises_in_Centre__c = true;
        newOpp1.Surrender_these_premises_in_Centre__c = false;
        newOpp1.Surrender_other_premises_Legal_Cost__c = 'Tenant';
        helper.setSpecialConditions(newOpp1, null, false);

        newOpp1.Surrender_other_premises_in_Centre__c = true;
        newOpp1.Surrender_these_premises_in_Centre__c = false;
        newOpp1.Surrender_other_premises_Make_Good__c = 'Yes';
        helper.setSpecialConditions(newOpp1, null, false);

        newOpp1.Surrender_other_premises_in_Centre__c = true;
        newOpp1.Surrender_these_premises_in_Centre__c = false;
        newOpp1.Surrender_other_premises_Make_Good__c = 'No';
        helper.setSpecialConditions(newOpp1, null, false);

        newOpp1.Storage__c = true;
        helper.setSpecialConditions(newOpp1, null, false);

        test.stopTest();

    }

    static testMethod void myUnitTest2() {

        Centre__c objCentre = VC_UnitTestFactory.buildTestCentre();

        insert objCentre;

        Building__c objBuilding = VC_UnitTestFactory.buildTestBuilding();
        objBuilding.Centre_Key__c = objCentre.Centre_Key__c;
        objBuilding.Centre__c = objCentre.Id;
        insert objBuilding;

        Unit__c newUnit1 = VC_UnitTestFactory.buildTestUnit();
        newUnit1.Centre_Key__c = objCentre.Centre_Key__c;
        newUnit1.Centre__c = objCentre.Id;
        newUnit1.Building_Key__c = objBuilding.Building_Key__c;
        newUnit1.Unit_Code__c = '45ATM';
        newUnit1.Building__c = objBuilding.Id;
        insert newUnit1;

        Opportunity newOpp1 = new Opportunity();
        newOpp1.Name = 'test';
        newOpp1.StageName = 'test';
        newOpp1.CloseDate = Date.today();
        newOpp1.API_Error__c = false;
        newOpp1.Is_Incomplete__c = false;
        newOpp1.Liquor_Licence__c = false;
        newOpp1.Common_Area_Trading_Flag__c = true;
        newOpp1.Lease_Incentive_Amount__c = 5;
        newOpp1.Surrender_other_premises_Fees__c = 5;
        newOpp1.Bank_Guarantee_Requirement__c = 'Group';
        newOpp1.Group_Security_No_of_Months_Required__c = 5;
        newOpp1.Unit__c = newUnit1.Id;
        newOpp1.Deal_Key__c = 'AA11035';
        newOpp1.Waiver_Certificate_Required__c = true;
        newOpp1.Deal_Type__c = 'New Tenant Standard';
        newOpp1.Is_Taking_Existing_Fitout__c = true;
        newOpp1.Exclusive_Zone__c = true;
        newOpp1.Franchisor__c = 'O';
        newOpp1.Storage__c = true;
        newOpp1.Bank_Guarantee_Requirement__c = 'Existing';
        newOpp1.Surrender_other_premises_in_Centre__c = true;

        insert newOpp1;

        newUnit1.Preferred_Tenant__c = newOpp1.Id;
        update newUnit1;

        test.startTest();

        SpecialConditionsHelper helper = new SpecialConditionsHelper();
        helper = new SpecialConditionsHelper(newOpp1);
        newOpp1.Surrender_other_premises_Legal_Cost__c = 'Landlord';
        newOpp1.Surrender_other_premises_Date_Options__c = 'Fixed Date';
        helper.setSpecialConditions(newOpp1, 'Non_Standard_Special_Conditions__c', false);

        newOpp1.Surrender_other_premises_Legal_Cost__c = 'Tenant';
        helper.setSpecialConditions(newOpp1, 'Non_Standard_Special_Conditions__c', false);

        newOpp1.Surrender_other_premises_Make_Good__c = 'Yes';
        helper.setSpecialConditions(newOpp1, 'Non_Standard_Special_Conditions__c', false);

        newOpp1.Surrender_other_premises_Make_Good__c = 'No';
        helper.setSpecialConditions(newOpp1, 'Non_Standard_Special_Conditions__c', false);

        newOpp1.Surrender_other_premises_Date_Options__c = 'One day prior to comm date of new lease';
        helper.setSpecialConditions(newOpp1, 'Non_Standard_Special_Conditions__c', false);

        newOpp1.Surrender_other_premises_Date_Options__c = 'Same day as comm date of new lease';
        helper.setSpecialConditions(newOpp1, 'Non_Standard_Special_Conditions__c', false);

        newOpp1.Surrender_other_premises_in_Centre__c = false;
        newOpp1.Non_Standard_Special_Conditions__c = 'LON031';
        helper.setSpecialConditions(newOpp1, 'Non_Standard_Special_Conditions__c', false);

        test.stopTest();

    }

    static testMethod void myUnitTest3() {

        Centre__c objCentre = VC_UnitTestFactory.buildTestCentre();

        insert objCentre;

        Building__c objBuilding = VC_UnitTestFactory.buildTestBuilding();
        objBuilding.Centre_Key__c = objCentre.Centre_Key__c;
        objBuilding.Centre__c = objCentre.Id;
        insert objBuilding;

        Unit__c newUnit1 = VC_UnitTestFactory.buildTestUnit();
        newUnit1.Centre_Key__c = objCentre.Centre_Key__c;
        newUnit1.Centre__c = objCentre.Id;
        newUnit1.Building_Key__c = objBuilding.Building_Key__c;
        newUnit1.Unit_Code__c = '45ATM';
        newUnit1.Building__c = objBuilding.Id;
        insert newUnit1;

        Opportunity newOpp1 = new Opportunity();
        newOpp1.Name = 'test';
        newOpp1.StageName = 'test';
        newOpp1.CloseDate = Date.today();
        newOpp1.API_Error__c = false;
        newOpp1.Is_Incomplete__c = false;
        newOpp1.Liquor_Licence__c = false;
        newOpp1.Common_Area_Trading_Flag__c = true;
        newOpp1.Lease_Incentive_Amount__c = 5;
        newOpp1.Surrender_other_premises_Fees__c = 5;
        newOpp1.Bank_Guarantee_Requirement__c = 'Group';
        newOpp1.Group_Security_No_of_Months_Required__c = 5;
        newOpp1.Unit__c = newUnit1.Id;
        newOpp1.Deal_Key__c = 'AA11035';
        newOpp1.Waiver_Certificate_Required__c = true;
        newOpp1.Deal_Type__c = 'New Tenant Standard';
        newOpp1.Is_Taking_Existing_Fitout__c = true;
        newOpp1.Exclusive_Zone__c = true;
        newOpp1.Franchisor__c = 'O';
        newOpp1.Storage__c = true;
        insert newOpp1;

        newUnit1.Preferred_Tenant__c = newOpp1.Id;
        update newUnit1;

        test.startTest();

        SpecialConditionsHelper helper = new SpecialConditionsHelper();

        newOpp1.Surrender_other_premises_in_Centre__c = true;
        newOpp1.Surrender_these_premises_in_Centre__c = false;
        newOpp1.Bank_Guarantee_Requirement__c = 'Existing';
        newOpp1.Surrender_these_premises_Legal_Cost__c = 'Landlord';
        newOpp1.Surrender_these_premises_Date_Options__c = 'Fixed Date';

        helper = new SpecialConditionsHelper(newOpp1);
        helper.setSpecialConditions(newOpp1, 'Non_Standard_Special_Conditions__c', false);

        newOpp1.Surrender_other_premises_Date_Options__c = 'One day prior to comm date of new lease';
        helper.setSpecialConditions(newOpp1, 'Non_Standard_Special_Conditions__c', false);

        newOpp1.Surrender_other_premises_Date_Options__c = 'Same day as comm date of new lease';
        helper.setSpecialConditions(newOpp1, 'Non_Standard_Special_Conditions__c', false);

        newOpp1.Surrender_other_premises_in_Centre__c = false;
        newOpp1.Surrender_these_premises_in_Centre__c = true;
        helper.setSpecialConditions(newOpp1, 'Non_Standard_Special_Conditions__c', false);

        newOpp1.Surrender_these_premises_in_Centre__c = true;
        newOpp1.Surrender_these_premises_Legal_Cost__c = 'Landlord';
        helper.setSpecialConditions(newOpp1, 'Non_Standard_Special_Conditions__c', false);

        newOpp1.Surrender_these_premises_Legal_Cost__c = 'Tenant';
        helper.setSpecialConditions(newOpp1, 'Non_Standard_Special_Conditions__c', false);

        newOpp1.Surrender_these_premises_Make_Good__c = 'Yes';
        helper.setSpecialConditions(newOpp1, 'Non_Standard_Special_Conditions__c', false);

        newOpp1.Surrender_these_premises_Make_Good__c = 'No';
        helper.setSpecialConditions(newOpp1, 'Non_Standard_Special_Conditions__c', false);

        newOpp1.Surrender_these_premises_in_Centre__c = false;
        newOpp1.Non_Standard_Special_Conditions__c = 'LON033';
        helper.setSpecialConditions(newOpp1, 'Non_Standard_Special_Conditions__c', false);

        test.stopTest();

    }

    static testMethod void myUnitTest4() {

        Centre__c objCentre = VC_UnitTestFactory.buildTestCentre();

        insert objCentre;

        Building__c objBuilding = VC_UnitTestFactory.buildTestBuilding();
        objBuilding.Centre_Key__c = objCentre.Centre_Key__c;
        objBuilding.Centre__c = objCentre.Id;
        insert objBuilding;

        Unit__c newUnit1 = VC_UnitTestFactory.buildTestUnit();
        newUnit1.Centre_Key__c = objCentre.Centre_Key__c;
        newUnit1.Centre__c = objCentre.Id;
        newUnit1.Building_Key__c = objBuilding.Building_Key__c;
        newUnit1.Unit_Code__c = '45ATM';
        newUnit1.Building__c = objBuilding.Id;
        insert newUnit1;

        Opportunity newOpp1 = new Opportunity();
        newOpp1.Name = 'test';
        newOpp1.StageName = 'test';
        newOpp1.CloseDate = Date.today();
        newOpp1.API_Error__c = false;
        newOpp1.Is_Incomplete__c = false;
        newOpp1.Liquor_Licence__c = false;
        newOpp1.Common_Area_Trading_Flag__c = true;
        newOpp1.Lease_Incentive_Amount__c = 5;
        newOpp1.Surrender_other_premises_Fees__c = 5;
        newOpp1.Bank_Guarantee_Requirement__c = 'Group';
        newOpp1.Group_Security_No_of_Months_Required__c = 5;
        newOpp1.Unit__c = newUnit1.Id;
        newOpp1.Deal_Key__c = 'AA11035';
        newOpp1.Waiver_Certificate_Required__c = true;
        newOpp1.Deal_Type__c = 'New Tenant Standard';
        newOpp1.Is_Taking_Existing_Fitout__c = true;
        newOpp1.Exclusive_Zone__c = true;
        newOpp1.Franchisor__c = 'O';
        newOpp1.Storage__c = true;
        newOpp1.Exclusivity_of_Permitted_Use__c = true;
        newOpp1.LON008_Options__c = '1';
        insert newOpp1;

        newUnit1.Preferred_Tenant__c = newOpp1.Id;
        update newUnit1;

        test.startTest();

        SpecialConditionsHelper helper = new SpecialConditionsHelper();

        newOpp1.Surrender_other_premises_in_Centre__c = true;
        newOpp1.Surrender_these_premises_in_Centre__c = false;
        newOpp1.Bank_Guarantee_Requirement__c = 'Existing';
        newOpp1.Surrender_these_premises_Legal_Cost__c = 'Landlord';
        newOpp1.Surrender_these_premises_Date_Options__c = 'Fixed Date';

        helper = new SpecialConditionsHelper(newOpp1);
        helper.setSpecialConditions(newOpp1, 'Non_Standard_Special_Conditions__c', false);

        newOpp1.Surrender_other_premises_Date_Options__c = 'One day prior to comm date of new lease';
        helper.setSpecialConditions(newOpp1, 'Non_Standard_Special_Conditions__c', false);

        newOpp1.Surrender_other_premises_Date_Options__c = 'Same day as comm date of new lease';
        helper.setSpecialConditions(newOpp1, 'Non_Standard_Special_Conditions__c', false);

        newOpp1.Surrender_other_premises_in_Centre__c = false;
        newOpp1.Surrender_these_premises_in_Centre__c = true;
        helper.setSpecialConditions(newOpp1, 'Non_Standard_Special_Conditions__c', false);

        newOpp1.Surrender_these_premises_in_Centre__c = true;
        newOpp1.Surrender_these_premises_Legal_Cost__c = 'Landlord';
        helper.setSpecialConditions(newOpp1, 'Non_Standard_Special_Conditions__c', false);

        newOpp1.Surrender_these_premises_Legal_Cost__c = 'Tenant';
        helper.setSpecialConditions(newOpp1, 'Non_Standard_Special_Conditions__c', false);

        newOpp1.Surrender_these_premises_Make_Good__c = 'Yes';
        helper.setSpecialConditions(newOpp1, 'Non_Standard_Special_Conditions__c', false);

        newOpp1.Surrender_these_premises_Make_Good__c = 'No';
        helper.setSpecialConditions(newOpp1, 'Non_Standard_Special_Conditions__c', false);

        newOpp1.Surrender_these_premises_in_Centre__c = false;
        newOpp1.Non_Standard_Special_Conditions__c = 'LON008';
        helper.setSpecialConditions(newOpp1, 'Non_Standard_Special_Conditions__c', false);

        test.stopTest();

    }

    static testMethod void increaseCoverageMethodRefreshSourceLeaseIncentive() {
        Centre__c objCentre = VC_UnitTestFactory.buildTestCentre();
        insert objCentre;

        Building__c objBuilding = VC_UnitTestFactory.buildTestBuilding();
        objBuilding.Centre_Key__c = objCentre.Centre_Key__c;
        objBuilding.Centre__c = objCentre.Id;
        insert objBuilding;

        Unit__c objUnit = VC_UnitTestFactory.buildTestUnit();
        objUnit.Centre_Key__c = objCentre.Centre_Key__c;
        objUnit.Centre__c = objCentre.Id;
        objUnit.Building_Key__c = objBuilding.Building_Key__c;
        objUnit.Unit_Code__c = '45ATM';
        objUnit.Building__c = objBuilding.Id;
        insert objUnit;

        Opportunity objOpportunity = new Opportunity();
        objOpportunity.Name = 'test';
        objOpportunity.Unit__c = objUnit.Id;
        objOpportunity.StageName = 'test';
        objOpportunity.CloseDate = Date.today();
        objOpportunity.Promo_Review_Rate_And_Type__c = 'Non Standard';
        objOpportunity.Non_Standard_Special_Conditions__c = 'LON004';
        objOpportunity.Lease_Incentive__c = true;

        insert objOpportunity;

        Test.startTest();

        SpecialConditionsHelper helper = new SpecialConditionsHelper();
        helper = new SpecialConditionsHelper(objOpportunity);
        helper.setSpecialConditions(objOpportunity, 'Lease_Incentive__c', false);

        Test.stopTest();
    }

    static testMethod void increaseCoverageMethodRefreshSourceNumberOfExclusiveCarParks() {
        Centre__c objCentre = VC_UnitTestFactory.buildTestCentre();
        insert objCentre;

        Building__c objBuilding = VC_UnitTestFactory.buildTestBuilding();
        objBuilding.Centre_Key__c = objCentre.Centre_Key__c;
        objBuilding.Centre__c = objCentre.Id;
        insert objBuilding;

        Unit__c objUnit = VC_UnitTestFactory.buildTestUnit();
        objUnit.Centre_Key__c = objCentre.Centre_Key__c;
        objUnit.Centre__c = objCentre.Id;
        objUnit.Building_Key__c = objBuilding.Building_Key__c;
        objUnit.Unit_Code__c = '45ATM';
        objUnit.Building__c = objBuilding.Id;
        insert objUnit;

        Opportunity objOpportunity = new Opportunity();
        objOpportunity.Name = 'test';
        objOpportunity.Unit__c = objUnit.Id;
        objOpportunity.StageName = 'test';
        objOpportunity.CloseDate = Date.today();
        objOpportunity.Number_of_exclusive_car_parks__c = 2;
        objOpportunity.Non_Standard_Special_Conditions__c = 'LON004';
        objOpportunity.Lease_Incentive__c = true;

        insert objOpportunity;

        Test.startTest();

        SpecialConditionsHelper helper = new SpecialConditionsHelper();
        helper = new SpecialConditionsHelper(objOpportunity);
        helper.setSpecialConditions(objOpportunity, 'Number_of_exclusive_car_parks__c', false);

        Test.stopTest();
    }

    static testMethod void increaseCoverageMethodRefreshSourceOptionForFurtherTerm() {
        Centre__c objCentre = VC_UnitTestFactory.buildTestCentre();
        insert objCentre;

        Building__c objBuilding = VC_UnitTestFactory.buildTestBuilding();
        objBuilding.Centre_Key__c = objCentre.Centre_Key__c;
        objBuilding.Centre__c = objCentre.Id;
        insert objBuilding;

        Unit__c objUnit = VC_UnitTestFactory.buildTestUnit();
        objUnit.Centre_Key__c = objCentre.Centre_Key__c;
        objUnit.Centre__c = objCentre.Id;
        objUnit.Building_Key__c = objBuilding.Building_Key__c;
        objUnit.Unit_Code__c = '45ATM';
        objUnit.Building__c = objBuilding.Id;
        insert objUnit;

        Opportunity objOpportunity = new Opportunity();
        objOpportunity.Name = 'test';
        objOpportunity.Unit__c = objUnit.Id;
        objOpportunity.StageName = 'test';
        objOpportunity.CloseDate = Date.today();
        objOpportunity.Promo_Review_Rate_And_Type__c = 'Non Standard';
        objOpportunity.Non_Standard_Special_Conditions__c = 'LON004';
        objOpportunity.Lease_Incentive__c = true;
        objOpportunity.Option_for_further_term__c = 'Yes';

        insert objOpportunity;

        Test.startTest();

        SpecialConditionsHelper helper = new SpecialConditionsHelper();
        helper = new SpecialConditionsHelper(objOpportunity);
        helper.setSpecialConditions(objOpportunity, 'Option_for_further_term__c', false);

        Test.stopTest();
    }

    static testMethod void increaseCoverageMethodRefreshSourceNSSC() {
        Centre__c objCentre = VC_UnitTestFactory.buildTestCentre();
        insert objCentre;

        Building__c objBuilding = VC_UnitTestFactory.buildTestBuilding();
        objBuilding.Centre_Key__c = objCentre.Centre_Key__c;
        objBuilding.Centre__c = objCentre.Id;
        insert objBuilding;

        Unit__c objUnit = VC_UnitTestFactory.buildTestUnit();
        objUnit.Centre_Key__c = objCentre.Centre_Key__c;
        objUnit.Centre__c = objCentre.Id;
        objUnit.Building_Key__c = objBuilding.Building_Key__c;
        objUnit.Unit_Code__c = '45ATM';
        objUnit.Building__c = objBuilding.Id;
        insert objUnit;

        Opportunity objOpportunity = new Opportunity();
        objOpportunity.Name = 'test';
        objOpportunity.Unit__c = objUnit.Id;
        objOpportunity.StageName = 'test';
        objOpportunity.CloseDate = Date.today();
        objOpportunity.Promo_Review_Rate_And_Type__c = 'Non Standard';
        objOpportunity.Non_Standard_Special_Conditions__c = 'LON004';
        objOpportunity.Lease_Incentive__c = true;
        objOpportunity.Percentage_Rent_Threshold__c = 'Artificial';
        objOpportunity.Refurbishment_Contribution__c = true;
        objOpportunity.Dev_Clause__c = true;
        objOpportunity.Surrender_these_premises_Date_Options__c = 'One day prior to comm date of new lease';
        objOpportunity.Seating_Licence__c = true;
        objOpportunity.Surrender_these_premises_in_Centre__c = true;

        insert objOpportunity;

        Test.startTest();

        SpecialConditionsHelper helper = new SpecialConditionsHelper();
        helper = new SpecialConditionsHelper(objOpportunity);
        helper.setSpecialConditions(objOpportunity, 'Non_Standard_Special_Conditions__c', false);

        Test.stopTest();
    }

    static testMethod void increaseCoverageMethodRefreshSourceNSSCWithNoNSSCSet() {
        Centre__c objCentre = VC_UnitTestFactory.buildTestCentre();
        insert objCentre;

        Building__c objBuilding = VC_UnitTestFactory.buildTestBuilding();
        objBuilding.Centre_Key__c = objCentre.Centre_Key__c;
        objBuilding.Centre__c = objCentre.Id;
        insert objBuilding;

        Unit__c objUnit = VC_UnitTestFactory.buildTestUnit();
        objUnit.Centre_Key__c = objCentre.Centre_Key__c;
        objUnit.Centre__c = objCentre.Id;
        objUnit.Building_Key__c = objBuilding.Building_Key__c;
        objUnit.Unit_Code__c = '45ATM';
        objUnit.Building__c = objBuilding.Id;
        insert objUnit;

        Opportunity objOpportunity = new Opportunity();
        objOpportunity.Name = 'test';
        objOpportunity.Unit__c = objUnit.Id;
        objOpportunity.StageName = 'test';
        objOpportunity.CloseDate = Date.today();
        objOpportunity.Lease_Incentive__c = true;
        objOpportunity.Percentage_Rent_Threshold__c = 'Artificial';
        objOpportunity.Refurbishment_Contribution__c = true;
        objOpportunity.Dev_Clause__c = true;
        objOpportunity.Surrender_these_premises_Date_Options__c = 'One day prior to comm date of new lease';
        objOpportunity.Seating_Licence__c = true;
        objOpportunity.Surrender_these_premises_in_Centre__c = true;
        objOpportunity.Non_Standard_Special_Conditions__c = 'XDISTR';

        insert objOpportunity;

        Test.startTest();

        SpecialConditionsHelper helper = new SpecialConditionsHelper();
        helper = new SpecialConditionsHelper(objOpportunity);
        helper.setSpecialConditions(objOpportunity, 'Non_Standard_Special_Conditions__c', false);

        Test.stopTest();
    }

    static testMethod void increaseCoverageMethodWAPerron() {
        Test.startTest();
        Centre__c objCentre = VC_UnitTestFactory.buildTestCentre();
        insert objCentre;

        Building__c objBuilding = VC_UnitTestFactory.buildTestBuilding();
        objBuilding.Centre_Key__c = objCentre.Centre_Key__c;
        objBuilding.Centre__c = objCentre.Id;
        insert objBuilding;

        Unit__c objUnit = VC_UnitTestFactory.buildTestUnit();
        objUnit.Centre_Key__c = objCentre.Centre_Key__c;
        objUnit.Centre__c = objCentre.Id;
        objUnit.Building_Key__c = objBuilding.Building_Key__c;
        objUnit.Unit_Code__c = '45ATM';
        objUnit.Building__c = objBuilding.Id;
        insert objUnit;

        Opportunity objOpportunity = new Opportunity();
        objOpportunity.Name = 'test';
        objOpportunity.Unit__c = objUnit.Id;
        objOpportunity.StageName = 'test';
        objOpportunity.CloseDate = Date.today();
        objOpportunity.Promo_Review_Rate_And_Type__c = 'Non Standard';
        objOpportunity.Non_Standard_Special_Conditions__c = 'LON004';
        /*objOpportunity.Non_Standard_Special_Conditions__c = 'LON004;LON010;DIRDEB;BGED;DSA;FROR;HOARDSKIN;LICCPFP;LICCPFL;LICCWCP;LICSIGNS;LICSIGNEX;LICSIGNCP;MGNR;OLLTS;OLLTL;PRNOC;REBRAND;SPRUIK' +
                ';SFNPBT;TTALL;TTSA;NOBIND;LOGO;CONF;DISCAMEND;AFFPBC;AFFPAC;COT;EZCML;EZPK;FFTRN;FSTSF;HDTRORD;HDDABP;LLWDTPP;RPSMA;FRL;TRADHRS;STPAN;ROL;CAT1CAP;STCBA;VPTR;HDOVR;HOARDCAP;INTER';*/
        objOpportunity.Deal_Type__c = 'New Tenant Standard';
        objOpportunity.Perron_Fitout_Plan_Approval_Date__c = System.today();
        /*objOpportunity.DIRDEB_Options__c = '1';
        objOpportunity.BGED_Options__c = '1';
        objOpportunity.DSA_Options__c = '1';
        objOpportunity.FROR_Options__c = '1';
        objOpportunity.HOARDSKIN_Options__c = '1';
        objOpportunity.LICCPFP_Options__c = '1';
        objOpportunity.LICCPFL_Options__c = '1';
        objOpportunity.LICCWCP_Options__c = '1';
        objOpportunity.LICSIGNEX_Options__c = '1';
        objOpportunity.LICSIGNCP_Options__c = '1';
        objOpportunity.MGNR_Options__c = '1';
        objOpportunity.OLLTS_Options__c = '1';
        objOpportunity.OLLTL_Options__c = '1';
        objOpportunity.PRNOC_Options__c = '1';
        objOpportunity.REBRAND_Options__c = '1';
        objOpportunity.SPRUIK_Options__c = '1';
        objOpportunity.SFNPBT_Options__c = '1';
        objOpportunity.TTALL_Options__c = '1';
        objOpportunity.TTSA_Options__c = '1';
        objOpportunity.NOBIND_Options__c = '1';
        objOpportunity.LOGO_Options__c = '1';
        objOpportunity.CONF_Options__c = '1';
        objOpportunity.DISCAMEND_Options__c = '1';
        objOpportunity.AFFPBC_Options__c = '1';
        objOpportunity.AFFPAC_Options__c = '1';
        objOpportunity.COT_Options__c = '1';
        objOpportunity.EZCML_Options__c = '1';
        objOpportunity.EZPK_Options__c = '1';
        objOpportunity.FFTRN_Options__c = '1';
        objOpportunity.FSTSF_Options__c = '1';
        objOpportunity.FSTSF_Termination_Date__c = System.today();
        objOpportunity.HDTRORD_Options__c = '1';
        objOpportunity.HDDABP_Options__c = '1';
        objOpportunity.LLWDTPP_Options__c = '1';
        objOpportunity.RPSMA_Options__c = '1';
        objOpportunity.FRL_Options__c = '1';
        objOpportunity.TRADHRS_Options__c = '1';
        objOpportunity.STPAN_Options__c = '1';
        objOpportunity.ROL_Options__c = '1';
        objOpportunity.CAT1CAP_Options__c = '1';
        objOpportunity.STCBA_Options__c = '1';
        objOpportunity.VPTR_Options__c = '1';
        objOpportunity.HDOVR_Options__c = '1';
        objOpportunity.HOARDCAP_Options__c = '1';
        objOpportunity.HOARD50_Options__c = '1';
        objOpportunity.INTER_Options__c = '1';
        objOpportunity.HDTRORD_Last_Handover_Date__c = System.today();
        objOpportunity.LLWDTPP_Last_Date_For_Plan__c = System.today();
        objOpportunity.Stpan_date_to_be_obtained_by__c = System.today();
        objOpportunity.STCBA_Council_Approval_Date__c = System.today();
        objOpportunity.vptr_last_vp_date__c = System.today();
        objOpportunity.HDDABP_Last_Handover_Date__c = System.today();
        objOpportunity.Hoardings_Capped_At_Commencement__c = true;
        objOpportunity.LON010_Options__c = '1a';*/
        objOpportunity.LON044_Refit_Completion_Date__c = null;
        objOpportunity.Estimated_Handover_Date__c = System.today();
        objOpportunity.lon037_vacant_possession_date__c = System.today();
        objOpportunity.Refit__c = true;



        insert objOpportunity;


        Test.stopTest();

        objOpportunity.recalculateFormulas();

        System.debug('sss - ' + objOpportunity.JDE_Deal_Type__c );

        SpecialConditionsHelper helper = new SpecialConditionsHelper();
        helper = new SpecialConditionsHelper(objOpportunity);
        helper.setSpecialConditions(objOpportunity, 'Non_Standard_Special_Conditions__c', true);

        objOpportunity.Deal_Type__c = 'New Tenant As Is';
        objOpportunity.recalculateFormulas();

        helper = new SpecialConditionsHelper(objOpportunity);
        helper.setSpecialConditions(objOpportunity, 'Non_Standard_Special_Conditions__c', true);

    }
}