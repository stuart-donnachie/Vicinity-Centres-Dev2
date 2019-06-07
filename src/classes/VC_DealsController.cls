/*
Date        : 22-08-2016
Project     : Lease Management System
Description : Customised opportunity/deals controller

Change History
--------------      
*/
public with sharing class VC_DealsController {

    // Definitions
    public Opportunity objOpp { get; set; }
    public Boolean errMsg { get; set; }
    public String oppId { get; set; }
    public Account retailer { get; set; }
    public Boolean apiError { get; set; }
    public String debug { get; set; }
    public String SelectedRetailerType { get; set; }
    public String RetailerName { get; set; }
    public String errString { get; set; }
    public VC_DealsCommon dealsCommon = new VC_DealsCommon();
    public DealValidator validator;
    public String defaultTenantCAB = '276050';

    // Constructor
    public VC_DealsController(ApexPages.StandardController stdController) {
        objOpp = (Opportunity) stdController.getRecord(); // Get the record
        objOpp = dealsCommon.getDeal((ApexPages.currentPage() != null) ?
                ApexPages.currentPage().getParameters().get('id') : objOpp.Id);
        dealsCommon = new VC_DealsCommon(objOpp); // Common method class
        validator = new DealValidator(objOpp); // Deal validator

        if (objOpp.Existing_Retailer__c == true) {
            SelectedRetailerType = 'EXISTING';
        } else if (objOpp.New_Retailer__c == true) {
            SelectedRetailerType = 'NEW';
        } else {
            SelectedRetailerType = 'EXISTING';
            objOpp.Existing_Retailer__c = true;
            objOpp.New_Retailer__c = false;
        }

        runUnitRules();
        runCentreRules();
    }

    //LAD approved logic
    public void setLADApproved() {
        if (objOpp.Promo_Review_Rate_and_Type__c == 'Non Standard') {
            objOpp.LAD_Approved__c = false;
        }
    }

    //Create deal action
    public Pagereference createDeal() {
        errMsg = false;
        errString = null;
        validator.errorMsgs.clear();
        Pagereference pRef = null;
        try {
            if (setDeal()) { //Initiates the deal
                LiveTenantProfile ltp = new LiveTenantProfile(objOpp);
                JDEConnector jdec = new JDEConnector(objOpp);
                String token = !Test.isRunningTest() ? ltp.getToken() : 'TESTTOKEN'; //Get the API token
                validator.errorMsgs.clear(); // Clear exsisting error messages
                if (Test.isRunningTest() || (ltp.updateDeal(ltp.getTenantProfile(token)) && validator.validateTenantProfile(objOpp))) {
                //if (Test.isRunningTest() || (ltp.updateDeal(ltp.getTenantProfileTestNewApi(token)) && validator.validateTenantProfile(objOpp))) {
                    runCentreRules();//Override DRF

                    setLADApproved(); //LAD approved logic

                    if (objOpp.Existing_Retailer__c) { //Create TDP
                        if (jdec.sendRequest(token, 'S') || Test.isRunningTest()) {
                            update objOpp;
                            System.debug('+++++ Deal @@@ : ' + objOpp);
                            System.debug('+++++ Deal Permitted Use @@@ : ' + objOpp.Permitted_Use_Profile__c);

                            if (objOpp.Permitted_Use_Profile__c == NULL) {
                                errMsg = true;
                                errString = 'No tenant profile found. Please contact your leasing coordinator.';
                                return null;
                            } else {
                                errMsg = false;
                                errString = NULL;
                            }
                            if (UserInfo.getUiThemeDisplayed() == 'Theme4t') {
                                pRef = new PageReference(Global_Settings__c.getInstance().Base_URL__c + '/apex/VC_Deal_DetailsVF?Id=' + objOpp.Id + '&mode=view');
                            } else {
                                pRef = new PageReference(Global_Settings__c.getInstance().Base_URL__c + '/one/one.app?isdtp=p1#/sObject/' + objOpp.Id + '/view');
                            }
                            pRef.setRedirect(true);
                            return pRef;
                        } else {
                            errMsg = true;
                            errString = 'Error occurred while creating the TDP. Please contact the administrator.';
                            if (jdec.errors != null && jdec.errors.size() > 0) {
                                errString += '<br/><br/>';

                                for (String e : jdec.errors) {
                                    errString += e + '<br/>';
                                }
                            }
                            return null;
                        }
                    } else { // Skip TDP creation for new retailers
                        update objOpp;
                        if (UserInfo.getUiThemeDisplayed() == 'Theme4t') {
                            pRef = new PageReference(Global_Settings__c.getInstance().Base_URL__c + '/apex/VC_Deal_DetailsVF?Id=' + objOpp.Id + '&mode=view');
                        } else {
                            pRef = new PageReference(Global_Settings__c.getInstance().Base_URL__c + '/one/one.app?isdtp=p1#/sObject/' + objOpp.Id + '/view');
                        }
                        pRef.setRedirect(true);
                        return pRef;
                    }

                } else {
                    errString = 'Error occurred while retrieving the tenant profile. Please try again.';
                    errMsg = true;

                    ErrorLogHandler.log('Deal Creation Error #1 : ', String.valueOf(objOpp));
                    return null;
                }

            } else {
                return null;
            }
        } catch (exception e) {

            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error occured. Please contact the administrator.'));
            ErrorLogHandler.log('Deal Creation Exception #1 : ', e);
            ErrorLogHandler.log('Deal Creation Exception #2 : ', String.valueOf(objOpp));
            errMsg = true;
            errString = 'Error occured. Please contact the administrator.';

            return null;
        }
    }

    // Unit specific rules
    public void runUnitRules() {

        if (objOpp.Unit__r.Unit_Code__c == '40OFF') {
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
        }
    }


    // Centre specific rules
    public void runCentreRules() {
        // If it is a Hartnett Asset then we don't want any Design Review Fees
        if(!objOpp.Unit__r.Building__r.Hartnett_Asset__c){
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

    }

    public Boolean setDeal() {

        objOpp.Centre__c = objOpp.Unit__r.Building__r.Centre__c;
        objOpp.Building__c = objOpp.Unit__r.Building__c;
        objOpp.Selected_Centre__c = objOpp.Unit__r.Building__r.Centre__r.Name;
        objOpp.Contract_Number__c = objOpp.Unit__r.Building__r.Centre__r.Contract_Number__c;
        objOpp.Hoarding_Rate_at_Commencement__c = objOpp.Unit__r.Building__r.Centre__r.Default_Hoardings_Rate__c;
        // If it is a Hartnett Asset then we don't want any Design Review Fees. Set it to zero here
        if(!objOpp.Unit__r.Building__r.Hartnett_Asset__c){
            objOpp.Design_Review_Fees_Rate_at_commencement__c = objOpp.Unit__r.Building__r.Centre__r.Design_Review_Fees__c;

        }else{
            objOpp.Design_Review_Fees_Rate_at_commencement__c = 0;
        }
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
        objOpp.Leasing_Executive__c = UserInfo.getUserId();
        if (objOpp.Development_Unit__c) {
            objOpp.Hoarding_Development_Unit__c = true;
            objOpp.Opening_Promotion__c = true;
        }
        //if(objOpp.Deal_Type__c == 'New Tenant Standard' || objOpp.Deal_Type__c == 'New Tenant As Is'){
        //objOpp.Estimated_Handover_Date__c = System.today().addDays(14);
        //}

        if (objOpp.Deal_Type__c == 'Renewal') {
            objOpp.Refit__c = true;
        }

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
            Account defAcc = [Select Name, Id, Tenant_CABID__c, Tenant_Key__c From Account where Tenant_CABID__c = :defaultTenantCAB LIMIT 1];
            objOpp.Account = defAcc;
            objOpp.Tenant_Key__c = defAcc.Tenant_Key__c;
            objOpp.Name = objOpp.New_Trading_Name__c + '/' + objOpp.Unit__r.Name + '/' + objOpp.Unit__r.Building__r.Name + '/' + Date.today().format().replaceAll('/', '-') + '/' + objOpp.Deal_Key__c;
        } else if (objOpp.Existing_Retailer__c == true && String.isNotEmpty(objOpp.AccountId)) {
            Account exAcc = [Select Name, Id, Tenant_CABID__c, Tenant_Key__c, Tenant_Entity__c From Account where Id = :objOpp.AccountId LIMIT 1];
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

        return !errMsg;
    }

    public void saveDeal() {
        setDeal();
        update objOpp;
    }

    // Cancel a deal (delete deal)
    public PageReference cancelDeal() {
        VC_DealsWSController.deleteDeal(objOpp);

        Schema.DescribeSObjectResult result = Unit__c.SObjectType.getDescribe();
        PageReference pageRef = new PageReference('/' + result.getKeyPrefix());
        pageRef.setRedirect(true);
        return pageRef;
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

        if (objOpp.Estimated_Lease_Commencement_Date__c != null && objOpp.Recovery_Type__c == 'Net' && objOpp.Retail_Act_Applies__c != null) {

            objOpp.Outgoings_Rate__c = dealsCommon.calculateOutgoings();


            if ((objOpp.Outgoings_Rate__c == null || objOpp.Outgoings_Rate__c == 0)
                    && objOpp.Estimated_Lease_Commencement_Date__c != null && objOpp.Recovery_Type__c == 'Net'
                    && objOpp.Retail_Act_Applies__c != null) {
                objOpp.Custom_Outgoings__c = true;
            } else {
                objOpp.Custom_Outgoings__c = false;
            }


        }

        //Override Gross Rate & Outs for Gross Deals
        if (objOpp.Recovery_Type__c == 'Gross') {
            objOpp.Custom_Outgoings__c = false;
            objOpp.Custom_Ratestaxes__c = false;

            objOpp.Outgoings_Rate__c = 0;
            objOpp.Rates_and_Taxes_Amount__c = 0;
        }

    }

    @RemoteAction
    public static List<Account> queryAccounts(String keyword) {
        List<Account> accountList = new List<Account>();
        String keywordFront;
        String keywordFirst;
        String keywordSecond;
        String keywordThird;
        if (keyword != null && keyword.trim() != '') {
            if (keyword.containsAny('-')) {
                keywordFirst = (keyword.split('-').size() > 0) ? keyword.split('-')[0].trim() + '%' : keyword + '%';
                keywordSecond = (keyword.split('-').size() > 0) ? keyword.split('-')[1].trim() + '%' : keyword + '%';
                //keywordThird = (keyword.split('-').size() > 1) ? keyword.split('-')[2] + '%' : keyword + '%';

                keywordFront = '****';
                keyword = '****';
            }

            keywordFront = keyword.trim() + '%';
            keyword = '%' + keyword.trim() + '%';
            accountList = [
                    SELECT Id, Name, Tenant_CABID__c, Tenant_ACN__c, Tenant_Entity__c
                    FROM Account
                    WHERE Name LIKE :keywordFront
                    OR Tenant_Entity__c like :keywordFront
                    OR Tenant_CABID__c like :keywordFront
                    //OR (Name LIKE :keywordFirst)
                    OR (Name LIKE :keywordFirst AND Tenant_Entity__c LIKE :keywordSecond)
                    //OR (Name LIKE :keywordFirst AND Tenant_Entity__c LIKE :keywordSecond AND Tenant_CABID__c LIKE :keywordThird)
                    LIMIT 50
            ];
        }
        return accountList;
    }

    public void SetRetailerType() {
        if (SelectedRetailerType == 'EXISTING') {
            RetailerName = null;
            objOpp.Existing_Retailer__c = true;
            objOpp.New_Retailer__c = false;
            objOpp.AccountId = null;
            objOpp.New_Tenant_Entity__c = null;
            objOpp.New_Tenant_ACN__c = null;
            objOpp.New_Trading_Name__c = null;
        } else {
            RetailerName = null;
            objOpp.Existing_Retailer__c = false;
            objOpp.New_Retailer__c = true;
            objOpp.AccountId = null;
            objOpp.New_Tenant_Entity__c = null;
            objOpp.New_Tenant_ACN__c = null;
            objOpp.New_Trading_Name__c = null;
        }
    }

}