/**
 * Created by stuartdonnachie on 9/2/18.
 */

public with sharing class BulkUploadDealsManipulation {

    // Definitions
    public Opportunity objOpp { get; set; }
    public Boolean errMsg { get; set; }
    public String oppId { get; set; }

    public String RetailerName { get; set; }
    public String errString { get; set; }
    public VC_DealsCommon dealsCommon = new VC_DealsCommon();
    public DealValidator validator;
    public String defaultTenantCAB = '276050';
    public List<Landlord__c> landlords {get; set;}



    public void doWork(Id opportunityId) {
        objOpp = dealsCommon.getDeal(opportunityId);
        dealsCommon = new VC_DealsCommon(objOpp); // Common method class
        validator = new DealValidator(objOpp); // Deal validator
        System.debug('X1');
        runUnitRules();
        runCentreRules();
        refreshFields();

        errMsg = false;
        errString = null;
        validator.errorMsgs.clear();
        System.debug('X2');

        try {
            //if (setDeal()) {
            System.debug('X3');

            LiveTenantProfile ltp = new LiveTenantProfile(objOpp);
            JDEConnector jdec = new JDEConnector(objOpp);
            //String token = ltp.getToken(); //Get the API token
            //System.debug('xxxxx - ' + token);
            System.debug('X4');

            validator.errorMsgs.clear(); // Clear existing error messages

            if (Test.isRunningTest() || (ltp.updateDeal(ltp.getTenantProfile(ltp.getToken())))) {
                //if (Test.isRunningTest() || (ltp.updateDeal(ltp.getTenantProfileTestNewApi(token)) && validator.validateTenantProfile(objOpp))) {
                runCentreRules();//Override DRF

                setLADApproved(); //LAD approved logic

                if (objOpp.Existing_Retailer__c) { //Create TDP
                    if (Test.isRunningTest() || (jdec.sendRequest(ltp.getToken(), 'S'))) {

                        // BEGIN modifications were done for the Auscoin bulk upload ------------------------------------------

                        // Set the LAD Approved to False here so that the deal is editable
                        objOpp.LAD_Approved__c = true;
                        objOpp.Bulk_Upload_Record__c = false;

                        // Set Tenant checks to False as well as specify the reason as Tenant National
                        objOpp.Tenant_Checks_Required__c = false;
                        objOpp.Tenant_Checks_Exclusion_Reason__c = '01';

                        // Set the Year 1 sales estimate to $1
                        objOpp.Year_1_Sales_Estimate__c = 1;

                        // Set the Vacant Possession Date to one day prior to estimated handover date
                        //objOpp.LON037_Vacant_Possession_Date__c = objOpp.Estimated_Handover_Date__c.addDays(-1); -- These seem to be populated in the Sheet

                       /* objOpp.Exclusivity_of_Permitted_Use__c = true;
                        objOpp.LON008_NTSD__c = 'If during the Term of this Licence the Landlord proposes to grant a further licence in the Centre to a third party for the installation and operation of a cryptocurrency ATM and provided the Licensee is not in breach of this Licence, the Licensor must first offer the licence to the Licensee on the same terms and conditions.  If the Licensee does not accept the Licensor’s offer within 14 days the Licensor can grant the licence to a third party.' + '\n' +
                                'Nothing in this clause:' + '\n' +
                                '(a) obliges the Licensor to make any further or other offers to the Licensee once the Licensee has either agreed to take the further lease or has rejected the Licensors Offer or the Licensor’s Offer has lapsed; or' + '\n' +
                                '(b) precludes the Licensor from making an offer to a third party which is conditional on the Licensee not accepting the Licensor’s Offer.' + '\n' +
                                'For the avoidance of doubt, any current lease or licence for the Centre which permits the installation and operation of a cryptocurrency ATM and any renewal or assignment of such lease or licence is expressly excluded from the operation of this clause and the Licensor will not be held in breach.'  + '\n' +
                                'Further, Westpac, Commonwealth Bank of Australia, National Australia Bank and the ANZ and/or their subsidiaries are expressly excluded from the operation of this special condition.' + '\n' +
                                'This special condition will cease to apply on the first to occur of:' + '\n' +
                                '(a) the expiry of this Licence;' + '\n' +
                                '(b) the Licensee breaching this Licence or otherwise committing a default; or' + '\n' +
                                '(c) the Licensee entity set out in this Lease Offer ceasing to be the Licensor holding the Licence for the Licensed Area.';*/

                       /* // Authorised Representative
                        List<SelectOption> authReps = new List<SelectOption>();
                        for (Contact c : [
                                SELECT Id, LastName, Tenant_Rep_Type__c, Tenant_Rep_ACN__c
                                FROM Contact
                                WHERE Tenant_Rep_Type__c = 'Authorised Representative'
                                AND Whos_Who_Line_Number__c != NULL
                                AND AccountId = :objOpp.AccountId
                                ORDER BY LastName
                        ]) {
                            authReps.add(new SelectOption(c.Id, c.LastName));
                        }

                        if (authReps.size() > 0) {
                            objOpp.Authorised_Reps__c = authReps[0].getValue() + ';';
                        }

                        // Legal Representative
                        List<SelectOption> LegalReps = new List<SelectOption>();
                        for (Contact c : [
                                SELECT Id, LastName, Tenant_Rep_Type__c
                                FROM Contact
                                WHERE Tenant_Rep_Type__c = 'Legal Representative'
                                AND AccountId = :objOpp.AccountId
                                AND Whos_Who_Line_Number__c != NULL
                                ORDER BY LastName
                        ]) {
                            LegalReps.add(new SelectOption(c.Id, c.LastName));
                        }

                        if (LegalReps.size() > 0) {
                            objOpp.Legal_Reps__c = LegalReps[0].getValue() + ';';
                        }

                        // Billing Representative
                        List<SelectOption> billingReps = new List<SelectOption>();
                        for (Contact c : [
                                SELECT Id, LastName, Tenant_Rep_Type__c
                                FROM Contact
                                WHERE Tenant_Rep_Type__c = 'Billing Representative'
                                AND AccountId = :objOpp.AccountId
                                AND Whos_Who_Line_Number__c != NULL
                                ORDER BY LastName
                        ]) {
                            billingReps.add(new SelectOption(c.Id, c.LastName));
                        }

                        if (billingReps.size() > 0) {
                            objOpp.Billing_Reps__c = billingReps[0].getValue() + ';';
                        }

                        // Notice Address Reps
                        List<SelectOption> NoticeReps = new List<SelectOption>();
                        for (Contact c : [
                                SELECT Id, LastName, Tenant_Rep_Type__c
                                FROM Contact
                                WHERE Tenant_Rep_Type__c = 'Notice Representative'
                                AND AccountId = :objOpp.AccountId
                                AND Whos_Who_Line_Number__c != NULL
                                ORDER BY LastName
                        ]) {
                            NoticeReps.add(new SelectOption(c.Id, c.LastName));
                        }

                        if (NoticeReps.size() > 0) {
                            objOpp.Notice_Reps__c = NoticeReps[0].getValue() + ';';
                        }

                        // Registered Address Reps
                        List<SelectOption> RegReps = new List<SelectOption>();
                        for (Contact c : [
                                SELECT Id, LastName, Tenant_Rep_Type__c
                                FROM Contact
                                WHERE Tenant_Rep_Type__c = 'Registered Representative'
                                AND AccountId = :objOpp.AccountId
                                AND Whos_Who_Line_Number__c != NULL
                                ORDER BY LastName
                        ]) {
                            RegReps.add(new SelectOption(c.Id, c.LastName));
                        }

                        if (RegReps.size() > 0) {
                            objOpp.Registration_Reps__c = RegReps[0].getValue() + ';';
                        }
*/
                        // END modifications were done for the Auscoin bulk upload --------------------------------------------

                        update objOpp;
                        System.debug('+++++ Deal @@@ : ' + objOpp);
                        System.debug('+++++ Deal Permitted Use @@@ : ' + objOpp.Permitted_Use_Profile__c);

                        if (objOpp.Permitted_Use_Profile__c == null) {
                            errMsg = true;
                            errString = 'No tenant profile found. Please contact your leasing coordinator.';
                        } else {
                            errMsg = false;
                            errString = null;
                        }
                    } else {
                        errMsg = true;
                        errString = 'Error occurred while creating the TDP. Please contact the administrator.';
                        if (jdec.errors != null && jdec.errors.size() > 0) {
                            errString += '<br/><br/>';

                            for (String e : jdec.errors) {
                                errString += e + '<br/>';
                            }
                        }

                        errString = 'Error occurred while retrieving the tenant profile. Please try again.';
                        errMsg = true;

                        ErrorLogHandler.log('Deal Creation Error #1 : ', String.valueOf(objOpp));

                    }
                } else { // Skip TDP creation for new retailers
                    update objOpp;
                }

            } else {
                errString = 'Error occurred while retrieving the tenant profile. Please try again.';
                errMsg = true;

                ErrorLogHandler.log('Deal Creation Error #1 : ', String.valueOf(objOpp));
            }

            //}

        } catch (Exception e) {
            ErrorLogHandler.log('Deal Creation Exception #1 : ', e);
            ErrorLogHandler.log('Deal Creation Exception #2 : ', String.valueOf(objOpp));
            errMsg = true;
            errString = 'Error occured. Please contact the administrator.';
        }
    }

    // Unit specific rules
    public void runUnitRules() {

       /* if (objOpp.Unit__r.Unit_Code__c == '40OFF') {
            objOpp.Works_Type__c = 'OFFICE';
        }

        if (objOpp.Unit__r.Unit_Code__c == '45ATM') {
            objOpp.Works_Type__c = 'ATM';
        }

        //if(objOpp.Unit__r.Unit_Code__c == '40OFF' || objOpp.Unit__r.Unit_Code__c == '45ATM' || objOpp.Unit__r.Unit_Code__c == '55OUT') {
        //    objOpp.Recovery_Type__c = 'Gross';
        //}

        if (objOpp.Unit__r.Unit_Code__c == '40OFF' || objOpp.Unit__r.Unit_Code__c == '45ATM') {
            objOpp.Fit_out_Period__c = 0;
        }*/
    }

    // Cetre specific rules
    public void runCentreRules() {
        if (objOpp.Unit__r.Building__r.Centre__r.Centre_Code__c == '46') {
            objOpp.Design_Review_Fees_Rate_at_commencement__c = 3000;
        }
        if (objOpp.Unit__r.Building__r.Centre__r.Centre_Code__c == '100') {
            objOpp.Design_Review_Fees_Rate_at_commencement__c = 3000;
        }
        if (objOpp.Unit__r.Building__r.Centre__r.Centre_Code__c == '11') {
            objOpp.Design_Review_Fees_Rate_at_commencement__c = 3000;
        }
    }

    public void refreshFields() {

        if (!objOpp.Existing_Retailer__c) {
            objOpp.AccountId = null;
        }

        if (!objOpp.New_Retailer__c) {
            objOpp.New_Tenant_Entity__c = null;
            objOpp.New_Tenant_ACN__c = null;
            objOpp.New_Trading_Name__c = null;
        }

        if (!objOpp.Dev_Clause__c) {
            objOpp.Development_Unit__c = false;
            objOpp.Dev_Budget__c = false;
        }

        if (objOpp.Estimated_Lease_Commencement_Date__c != null && objOpp.Recovery_Type__c == 'Net') {

            //Get Outs
            objOpp.Rates_and_Taxes_Amount__c = dealsCommon.calculateRatesAndTaxes();


            // Set Outs/Rates Editablity
            if ((objOpp.Rates_and_Taxes_Amount__c == null || objOpp.Rates_and_Taxes_Amount__c == 0)
                    && (objOpp.Unit__r.Building__r.Centre__r.State__c == 'VIC' || objOpp.Unit__r.Building__r.Centre__r.Name == 'Northgate')
                    && objOpp.Estimated_Lease_Commencement_Date__c != null && objOpp.Recovery_Type__c == 'Net') {
                objOpp.Custom_Ratestaxes__c = true;
            } else {
                objOpp.Custom_Ratestaxes__c = false;
            }


        }

        // These ones from MAria are all GROSS deals
       /* if (objOpp.Estimated_Lease_Commencement_Date__c != null && objOpp.Recovery_Type__c == 'Net' && objOpp.Retail_Act_Applies__c != null) {

            objOpp.Outgoings_Rate__c = dealsCommon.calculateOutgoings();


            if ((objOpp.Outgoings_Rate__c == null || objOpp.Outgoings_Rate__c == 0)
                    && objOpp.Estimated_Lease_Commencement_Date__c != null && objOpp.Recovery_Type__c == 'Net'
                    && objOpp.Retail_Act_Applies__c != null) {
                objOpp.Custom_Outgoings__c = true;
            } else {
                objOpp.Custom_Outgoings__c = false;
            }


        }*/

        //Override Gross Rate & Outs for Gross Deals
        if (objOpp.Recovery_Type__c == 'Gross') {
            objOpp.Custom_Outgoings__c = false;
            objOpp.Custom_Ratestaxes__c = false;

            objOpp.Outgoings_Rate__c = 0;
            objOpp.Rates_and_Taxes_Amount__c = 0;
        }

    }

    public Boolean setDeal(Id opportunityId) {
        objOpp = dealsCommon.getDeal(opportunityId);
        validator = new DealValidator(objOpp);

        objOpp.Centre__c = objOpp.Unit__r.Building__r.Centre__c;
        objOpp.Building__c = objOpp.Unit__r.Building__c;
        objOpp.Selected_Centre__c = objOpp.Unit__r.Building__r.Centre__r.Name;
        objOpp.Contract_Number__c = objOpp.Unit__r.Building__r.Centre__r.Contract_Number__c;
        objOpp.Hoarding_Rate_at_Commencement__c = objOpp.Unit__r.Building__r.Centre__r.Default_Hoardings_Rate__c;
        objOpp.Design_Review_Fees_Rate_at_commencement__c = objOpp.Unit__r.Building__r.Centre__r.Design_Review_Fees__c;
        objOpp.Storage_Rate__c = objOpp.Unit__r.Building__r.Centre__r.Default_Storage_Rate__c;
        objOpp.Area_of_premises_sqmt__c = objOpp.Unit__r.Area_of_Premises__c;
        objOpp.Unit_Type__c = objOpp.Unit__r.Unit_Type__c;
        objOpp.Unit_Code__c = objOpp.Unit__r.Unit_Code__c;
        objOpp.CloseDate = System.today() + 730;
        objOpp.Document_Date__c = System.today();
        //objOpp.Deal_Type__c = selectedDealType;
        objOpp.Is_Incomplete__c = false;
        objOpp.LAD_Approved__c = true;
        objOpp.Target_Lease_Commencement_Date__c = objOpp.Estimated_Lease_Commencement_Date__c;
        objOpp.Estimated_Handover_Date__c = objOpp.Estimated_Lease_Commencement_Date__c;
        // VMS-44
        objOpp.LON037_Vacant_Possession_Date__c = objOpp.Estimated_Handover_Date__c.addDays(-1);
        System.debug('sss');
        System.debug('ccc - ' + UserInfo.getUserId());
        objOpp.Leasing_Executive__c = UserInfo.getUserId();
        if (objOpp.Development_Unit__c) {
            objOpp.Hoarding_Development_Unit__c = true;
            objOpp.Opening_Promotion__c = true;
        }
        //if(objOpp.Deal_Type__c == 'New Tenant Standard' || objOpp.Deal_Type__c == 'New Tenant As Is'){
        //objOpp.Estimated_Handover_Date__c = System.today().addDays(14);
        //}

        // All of the records in the file MAria sent had refit as FALSE so commenting out the below logic.
       /* if (objOpp.Deal_Type__c == 'Renewal') {
            objOpp.Refit__c = true;
        }*/

        if (objOpp.Deal_Type__c == 'Renewal' && objOpp.Refit__c == false) {
            objOpp.Hoarding_Development_Unit__c = false;
            objOpp.Design_Review_Fees_At_Commencement__c = false;
        }

        if (objOpp.Deal_Type__c == 'New Tenant As Is') {
            objOpp.Is_Taking_Existing_Fitout__c = true;
        }

        if (objOpp.Development_Unit__c) {
            objOpp.Survey_Required__c = true;
        }

        if (objOpp.New_Retailer__c == true) {
            Account defAcc = [SELECT Name, Id, Tenant_CABID__c, Tenant_Key__c FROM Account WHERE Tenant_CABID__c = :defaultTenantCAB LIMIT 1];
            objOpp.Account = defAcc;
            objOpp.Tenant_Key__c = defAcc.Tenant_Key__c;
            objOpp.Name = objOpp.New_Trading_Name__c + '/' + objOpp.Unit__r.Name + '/' + objOpp.Unit__r.Building__r.Name + '/' + Date.today().format().replaceAll('/', '-') + '/' + objOpp.Deal_Key__c;
        } else if (objOpp.Existing_Retailer__c == true && String.isNotEmpty(objOpp.AccountId)) {
            Account exAcc = [SELECT Name, Id, Tenant_CABID__c, Tenant_Key__c, Tenant_Entity__c FROM Account WHERE Id = :objOpp.AccountId LIMIT 1];
            RetailerName = exAcc.Name;
            objOpp.Account = exAcc;
            objOpp.Account.Tenant_Entity__c = exAcc.Tenant_Entity__c;
            objOpp.Account.Name = exAcc.Name;
            objOpp.Account.Tenant_CABID__c = exAcc.Tenant_CABID__c;
            objOpp.Tenant_Key__c = exAcc.Tenant_Key__c;
            objOpp.Name = exAcc.Name + '/' + objOpp.Unit__r.Name + '/' + objOpp.Unit__r.Building__r.Name + '/' + Date.today().format().replaceAll('/', '-') + '/' + objOpp.Deal_Key__c;
        }

        if (!validator.validateTDP(objOpp)) {
            errMsg = true;
            errString = 'Please review the errors.';
            if (validator.errorMsgs != null && validator.errorMsgs.size() > 0) {
                errString += '<br/><br/>';

                for (String e : validator.errorMsgs) {
                    errString += e + '<br/>';
                }
            }

        } else {
            errMsg = false;
            oppId = objOpp.Id;
        }

        // VMS-33 For deals that match the below criteria we automatically set Preferential Rights to No. This solves the EOI paragraph wording from not appearing for SA Units
        if (objOpp.Retail_Act_Applies__c == 'Y' && objOpp.Unit__r.Building__r.Centre__r.State__c == 'SA' && objOpp.Deal_Type__c == 'Renewal') {
            objOpp.Preferential_Rights__c = 'No';
        }

        //Query landloards
        landlords = [SELECT Name, Id FROM Landlord__c WHERE Building__c = :objOpp.Building__c];
        if(landlords !=null && landlords.size() > 0) {
            objOpp.Selected_Landlord__c = landlords[0].Id;
        }

        objOpp.Set_Deal_Needed__c = false;


        update objOpp;

        return !errMsg;
    }

    //LAD approved logic
    public void setLADApproved() {
        if (objOpp.Promo_Review_Rate_and_Type__c == 'Non Standard') {
            objOpp.LAD_Approved__c = false;
        }
    }
}