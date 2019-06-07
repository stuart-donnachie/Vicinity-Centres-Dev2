/*
Date        : 22-08-2016
Project     : Lease Management System
Description : Customised opportunity/deals controller

Change History
--------------

*/
public with sharing class VC_Deal_DetailsController {
    public String debug { get; set; }
    public VC_DealsCommon dealsCommon = new VC_DealsCommon();
    public DealValidator validator;
    public SpecialConditionsHelper specialConditionHelper;
    public Opportunity objOpp { get; set; }
    public String tenantName { get; set; }
    public String tenantEntity { get; set; }
    public String tenantCABID { get; set; }
    public String tenantACN { get; set; }
    public String tenantBillingAddress { get; set; }
    public String conAuthRep { get; set; }
    public String conAuthAddress { get; set; }
    public String conAuthRep_FirstName { get; set; }
    public String conAuthAddress_Street { get; set; }
    public String conAuthAddress_City { get; set; }
    public String conAuthAddress_State { get; set; }
    public String conAuthAddress_PostCode { get; set; }
    public String conAuthAddress_Country { get; set; }
    public String conAuthAddress_Desc { get; set; }
    public String conAuthEmail { get; set; }
    public String conAuthPhone { get; set; }
    public String conLegRep { get; set; }
    public String conLegAddress { get; set; }
    public String conLegEmail { get; set; }
    public String conLegPhone { get; set; }
    public String conBillRep { get; set; }
    public String conBillAddress { get; set; }
    public String conBillEmail { get; set; }
    public String conBillPhone { get; set; }
    public String conGarRep1 { get; set; }
    public String conGarAddress1 { get; set; }
    public String conGar1Email { get; set; }
    public String conGar1Phone { get; set; }
    public String conGarRep2 { get; set; }
    public String conGarAddress2 { get; set; }
    public String conGar2Email { get; set; }
    public String conGar2Phone { get; set; }
    public String conGarRep3 { get; set; }
    public String conGarAddress3 { get; set; }
    public String conGar3Email { get; set; }
    public String conGar3Phone { get; set; }
    public String conRegAddress { get; set; }
    public String conRegEmail { get; set; }
    public String conRegPhone { get; set; }
    public String conNotEmail { get; set; }
    public String conNotPhone { get; set; }
    public String conNotAddress { get; set; }
    public Boolean defaultTenant { get; set; }
    public string selectedauthrep { get; set; }
    public string unselectauthrep { get; set; }
    public string selectedbillrep { get; set; }
    public string unselectbillrep { get; set; }
    public string selectedguarrep { get; set; }
    public string unselectguarrep { get; set; }
    public string selectedlegrep { get; set; }
    public string unselectlegrep { get; set; }
    public string selectednoticerep { get; set; }
    public string unselectnoticerep { get; set; }
    public string selectedregrep { get; set; }
    public string unselectregrep { get; set; }
    public String pageUrl { get; set; }
    public String refreshSource { get; set; }
    public String nsscId { get; set; }
    public Boolean errMsg { get; set; }
    public Boolean errMsgITL { get; set; }
    public Boolean lonGenerated { get; set; }
    public Boolean eoiGenerated { get; set; }
    public Boolean IsEditable { get; set; }
    public String[] ExistingFitouts { get; set; }
    public List<String> SpecialCons { get; set; }
    public String[] GuarRepsG { get; set; }
    public Set<String> extAuthRepIds = new Set<String>();
    public Set<String> extBillRepIds = new Set<String>();
    public Set<String> extGuarRepIds = new Set<String>();
    public Set<String> extLegalRepIds = new Set<String>();
    public Set<String> extNoticeRepIds = new Set<String>();
    public Set<String> extRegRepIds = new Set<String>();
    public Map<String, String> specialConValueMap = new Map<String, String>();
    public Map<String, String> specialConLabelMap = new Map<String, String>();
    public List<Non_Standard_Special_Conditions__c> nSSpecialCons { get; set; }
    public Date exsistingCommDate;
    public String unapprovedSpecialCons;
    public String approvedSpecialCons;
    public Boolean isWAPerronUnit { get; set; }
    public String errString { get; set; }


    // Constructor
    public VC_Deal_DetailsController(ApexPages.StandardController stdController) {
        errMsg = false;
        errMsgITL = false;
        lonGenerated = false;
        eoiGenerated = false;
        isWAPerronUnit = false;
        SpecialCons = new List<String>();

        //Get the record
        objOpp = (Opportunity) stdController.getRecord();

        //Query deal information
        objOpp = dealsCommon.getDeal((ApexPages.currentPage() != null) ?
                ApexPages.currentPage().getParameters().get('id') : objOpp.Id);

        // Common method class
        dealsCommon = new VC_DealsCommon(objOpp);

        // Deal validator
        validator = new DealValidator(objOpp);

        // Special conditions helper
        specialConditionHelper = new SpecialConditionsHelper(objOpp);

        // Check to work out if the deal is being done for a WA Perron unit. unique logic attached to only these units.
        if (new Set<String>{
                '86810', '86811', '86911', '86910', '87010'
        }.contains(objOpp.Unit__r.Building__r.Building_Code__c)) {
            isWAPerronUnit = true;
        }

        System.debug('WA Perron unit - ' + isWAPerronUnit);

        // Getting related tenant information
        getAccount();

        //Get special conditions
        getSpecialCons(objOpp.Id);

        //Set form editablity
        checkEditablity();

        // Setting up values for contact multipicklists
        getExistingReps();

        // Setting up values
        if (!objOpp.Is_Incomplete__c) {
            getFieldValues();
        }

        //Populate values for mobile multi-select fields
        loadMobileSelectLists();

        //Check approved condtions
        checkApprovedSpecialCons();

        //Init values
        refreshField();
    }

    public void checkEditablity() {
        if (((objOpp.StageName == 'Deal Builder')
                || objOpp.Process_Status__c == 'Generate LO'
                || objOpp.Process_Status__c == 'Tenants LO Received'
        )
                && !objOpp.LON_Pending__c
                && !objOpp.Is_Incomplete__c
                && !objOpp.API_Error__c) {
            IsEditable = true;
        }
    }

    //Query Non Std Special Conditions
    public void getSpecialCons(Id oppId) {
        nSSpecialCons = [
                SELECT Name, Id, Deal__c, Special_Condition__c
                FROM Non_Standard_Special_Conditions__c
                WHERE Deal__c = :oppId
        ];
    }

    // LAD Approved Permission
    public Boolean ladPermission {
        get {
            if (Schema.sObjectType.Opportunity.fields.LAD_Approved__c.isUpdateable()) {
                return true;
            } else {
                return false;
            }
        }
    }

    //Query Deal
    public void queryDeal() {
        objOpp = dealsCommon.getDeal(objOpp.Id);
    }

    //Check LAD Approvel
    public void checkApprovedSpecialCons() {
        if (objOpp.LAD_Approved__c) {
            approvedSpecialCons = objOpp.Non_Standard_Special_Conditions__c;
            if (approvedSpecialCons != null && approvedSpecialCons.contains('LON044') && !objOpp.LON044_Custom_Refit_Condition__c) {
                approvedSpecialCons = approvedSpecialCons.replace('LON044', '');
            }
            if (approvedSpecialCons != null && approvedSpecialCons.contains('LON001') && !objOpp.LON001_Custom_Text__c) {
                approvedSpecialCons = approvedSpecialCons.replace('LON001', '');
            }
            if (approvedSpecialCons != null && approvedSpecialCons.contains('LON007') && !objOpp.LON007_Custom_Text__c) {
                approvedSpecialCons = approvedSpecialCons.replace('LON007', '');
            }
            if (approvedSpecialCons != null && approvedSpecialCons.contains('LON010') && !objOpp.LON010_Custom_Text__c) {
                approvedSpecialCons = approvedSpecialCons.replace('LON010', '');
            }
            if (approvedSpecialCons != null && approvedSpecialCons.contains('LON045') && !objOpp.LON045_Custom_Text__c) {
                approvedSpecialCons = approvedSpecialCons.replace('LON045', '');
            }
            if (approvedSpecialCons != null && approvedSpecialCons.contains('LON046') && !objOpp.LON046_Custom_Text__c) {
                approvedSpecialCons = approvedSpecialCons.replace('LON046', '');
            }
            if (approvedSpecialCons != null && approvedSpecialCons.contains('LON049') && !objOpp.LON049_Custom_Text__c) {
                approvedSpecialCons = approvedSpecialCons.replace('LON049', '');
            }
            if (approvedSpecialCons != null && approvedSpecialCons.contains('LON020') && (!objOpp.LON020_Custom_Text__c || objOpp.LON020_Options__c != '3')) {
                approvedSpecialCons = approvedSpecialCons.replace('LON020', '');
            }
            if (approvedSpecialCons != null && approvedSpecialCons.contains('LON067') && !objOpp.LON067_Custom_Text__c) { // Added to incorporate Lease Incentive into this Custom Text logic
                approvedSpecialCons = approvedSpecialCons.replace('LON067', '');
            }
            if (approvedSpecialCons != null && approvedSpecialCons.contains('LON066') && !objOpp.LON066_Custom_Text__c) { // Added to incorporate Lease Incentive into this Custom Text logic
                approvedSpecialCons = approvedSpecialCons.replace('LON066', '');
            }
        } else {
            unapprovedSpecialCons = objOpp.Non_Standard_Special_Conditions__c;
        }
    }

    //Set LAD Approvel
    public void setLADApproved() {

        if (refreshSource != null
                && refreshSource != 'LAD_Approved__c'
                && approvedSpecialCons != null
                && objOpp.Non_Standard_Special_Conditions__c != null
                &&
                (
                        (!approvedSpecialCons.contains('XDISTR') && objOpp.Non_Standard_Special_Conditions__c.contains('XDISTR')) ||
                                (!approvedSpecialCons.contains('LON003') && objOpp.Non_Standard_Special_Conditions__c.contains('LON003')) ||
                                (!approvedSpecialCons.contains('LON004') && objOpp.Non_Standard_Special_Conditions__c.contains('LON004')) ||
                                (!approvedSpecialCons.contains('LON007') && objOpp.Non_Standard_Special_Conditions__c.contains('LON007') && objOpp.LON007_Custom_Text__c) ||
                                (!approvedSpecialCons.contains('LON008') && objOpp.Non_Standard_Special_Conditions__c.contains('LON008')) ||
                                (!approvedSpecialCons.contains('LON010') && objOpp.Non_Standard_Special_Conditions__c.contains('LON010') && objOpp.LON010_Custom_Text__c) ||
                                (!approvedSpecialCons.contains('LON067') && objOpp.Non_Standard_Special_Conditions__c.contains('LON067') && objOpp.LON067_Custom_Text__c) ||
                                (!approvedSpecialCons.contains('LON066') && objOpp.Non_Standard_Special_Conditions__c.contains('LON066') && objOpp.LON066_Custom_Text__c) ||
                                //(!approvedSpecialCons.contains('LQRLIC') && objOpp.Non_Standard_Special_Conditions__c.contains('LQRLIC')) ||
                                (!approvedSpecialCons.contains('SURFEE') && objOpp.Non_Standard_Special_Conditions__c.contains('SURFEE')) ||
                                (!approvedSpecialCons.contains('OPTDET') && objOpp.Non_Standard_Special_Conditions__c.contains('OPTDET')) ||
                                (!approvedSpecialCons.contains('LON020') && objOpp.Non_Standard_Special_Conditions__c.contains('LON020') && (objOpp.LON020_Options__c == '3' || objOpp.LON020_Custom_Text__c)) ||
                                (!approvedSpecialCons.contains('OPTRRV') && objOpp.Non_Standard_Special_Conditions__c.contains('OPTRRV')) ||
                                (!approvedSpecialCons.contains('PROMRV') && objOpp.Non_Standard_Special_Conditions__c.contains('PROMRV')) ||
                                (!approvedSpecialCons.contains('RENTRV') && objOpp.Non_Standard_Special_Conditions__c.contains('RENTRV')) ||
                                (!approvedSpecialCons.contains('LON044') && objOpp.Non_Standard_Special_Conditions__c.contains('LON044') && objOpp.LON044_Custom_Refit_Condition__c) ||
                                (!approvedSpecialCons.contains('LON066') && objOpp.Non_Standard_Special_Conditions__c.contains('LON066')) ||
                                (!approvedSpecialCons.contains('XREPRE') && objOpp.Non_Standard_Special_Conditions__c.contains('XREPRE')) ||
                                (!approvedSpecialCons.contains('WAMTE5YT') && objOpp.Non_Standard_Special_Conditions__c.contains('WAMTE5YT')) ||
                                (!approvedSpecialCons.contains('WAMTLMT') && objOpp.Non_Standard_Special_Conditions__c.contains('WAMTLMT')) ||
                                (!approvedSpecialCons.contains('WAMTLT') && objOpp.Non_Standard_Special_Conditions__c.contains('WAMTLT')) ||
                                (!approvedSpecialCons.contains('LON001') && objOpp.Non_Standard_Special_Conditions__c.contains('LON001') && objOpp.LON001_Custom_Text__c) ||
                                (!approvedSpecialCons.contains('LON045') && objOpp.Non_Standard_Special_Conditions__c.contains('LON045') && objOpp.LON045_Custom_Text__c) ||
                                (!approvedSpecialCons.contains('LON046') && objOpp.Non_Standard_Special_Conditions__c.contains('LON046') && objOpp.LON046_Custom_Text__c) ||
                                (!approvedSpecialCons.contains('LON049') && objOpp.Non_Standard_Special_Conditions__c.contains('LON049') && objOpp.LON049_Custom_Text__c)
                                //added by nitin
                                ||
                                (!approvedSpecialCons.contains('BGED') && objOpp.Non_Standard_Special_Conditions__c.contains('BGED')) ||
                                (!approvedSpecialCons.contains('DSA') && objOpp.Non_Standard_Special_Conditions__c.contains('DSA')) ||
                                (!approvedSpecialCons.contains('FROR') && objOpp.Non_Standard_Special_Conditions__c.contains('FROR')) ||
                                (!approvedSpecialCons.contains('HOARDSKIN') && objOpp.Non_Standard_Special_Conditions__c.contains('HOARDSKIN')) ||
                                (!approvedSpecialCons.contains('LICCPFP') && objOpp.Non_Standard_Special_Conditions__c.contains('LICCPFP')) ||
                                (!approvedSpecialCons.contains('LICCPFL') && objOpp.Non_Standard_Special_Conditions__c.contains('LICCPFL')) ||
                                (!approvedSpecialCons.contains('LICCWCP') && objOpp.Non_Standard_Special_Conditions__c.contains('LICCWCP')) ||
                                (!approvedSpecialCons.contains('LICSIGNS') && objOpp.Non_Standard_Special_Conditions__c.contains('LICSIGNS')) ||
                                (!approvedSpecialCons.contains('LICSIGNEX') && objOpp.Non_Standard_Special_Conditions__c.contains('LICSIGNEX')) ||
                                (!approvedSpecialCons.contains('LICSIGNCP') && objOpp.Non_Standard_Special_Conditions__c.contains('LICSIGNCP')) ||
                                (!approvedSpecialCons.contains('MGNR') && objOpp.Non_Standard_Special_Conditions__c.contains('MGNR')) ||
                                (!approvedSpecialCons.contains('OLLTS') && objOpp.Non_Standard_Special_Conditions__c.contains('OLLTS')) ||
                                (!approvedSpecialCons.contains('OLLTL') && objOpp.Non_Standard_Special_Conditions__c.contains('OLLTL')) ||
                                (!approvedSpecialCons.contains('PRNOC') && objOpp.Non_Standard_Special_Conditions__c.contains('PRNOC')) ||
                                (!approvedSpecialCons.contains('REBRAND') && objOpp.Non_Standard_Special_Conditions__c.contains('REBRAND')) ||
                                (!approvedSpecialCons.contains('SPRUIK') && objOpp.Non_Standard_Special_Conditions__c.contains('SPRUIK')) ||
                                (!approvedSpecialCons.contains('SFNPBT') && objOpp.Non_Standard_Special_Conditions__c.contains('SFNPBT')) ||
                                (!approvedSpecialCons.contains('TTALL') && objOpp.Non_Standard_Special_Conditions__c.contains('TTALL')) ||
                                (!approvedSpecialCons.contains('TTSA') && objOpp.Non_Standard_Special_Conditions__c.contains('TTSA')) ||
                                (!approvedSpecialCons.contains('NOBIND') && objOpp.Non_Standard_Special_Conditions__c.contains('NOBIND')) ||
                                (!approvedSpecialCons.contains('LOGO') && objOpp.Non_Standard_Special_Conditions__c.contains('LOGO')) ||
                                (!approvedSpecialCons.contains('CONF') && objOpp.Non_Standard_Special_Conditions__c.contains('CONF')) ||
                                (!approvedSpecialCons.contains('DISCAMEND') && objOpp.Non_Standard_Special_Conditions__c.contains('DISCAMEND')) ||
                                (!approvedSpecialCons.contains('AFFPBC') && objOpp.Non_Standard_Special_Conditions__c.contains('AFFPBC')) ||
                                (!approvedSpecialCons.contains('AFFPAC') && objOpp.Non_Standard_Special_Conditions__c.contains('AFFPAC')) ||
                                (!approvedSpecialCons.contains('COT') && objOpp.Non_Standard_Special_Conditions__c.contains('COT')) ||
                                (!approvedSpecialCons.contains('EZPK') && objOpp.Non_Standard_Special_Conditions__c.contains('EZPK')) ||
                                (!approvedSpecialCons.contains('EZCML') && objOpp.Non_Standard_Special_Conditions__c.contains('EZCML')) ||
                                (!approvedSpecialCons.contains('FFTRN') && objOpp.Non_Standard_Special_Conditions__c.contains('FFTRN')) ||
                                (!approvedSpecialCons.contains('FSTSF') && objOpp.Non_Standard_Special_Conditions__c.contains('FSTSF')) ||
                                (!approvedSpecialCons.contains('HDTRORD') && objOpp.Non_Standard_Special_Conditions__c.contains('HDTRORD')) ||
                                (!approvedSpecialCons.contains('HDDABP') && objOpp.Non_Standard_Special_Conditions__c.contains('HDDABP')) ||
                                (!approvedSpecialCons.contains('LLWDTPP') && objOpp.Non_Standard_Special_Conditions__c.contains('LLWDTPP')) ||
                                (!approvedSpecialCons.contains('RPSMA') && objOpp.Non_Standard_Special_Conditions__c.contains('RPSMA')) ||
                                (!approvedSpecialCons.contains('FRL') && objOpp.Non_Standard_Special_Conditions__c.contains('FRL')) ||
                                (!approvedSpecialCons.contains('TRADHRS') && objOpp.Non_Standard_Special_Conditions__c.contains('TRADHRS')) ||
                                (!approvedSpecialCons.contains('STPAN') && objOpp.Non_Standard_Special_Conditions__c.contains('STPAN')) ||
                                (!approvedSpecialCons.contains('ROL') && objOpp.Non_Standard_Special_Conditions__c.contains('ROL')) ||
                                (!approvedSpecialCons.contains('CAT1CAP') && objOpp.Non_Standard_Special_Conditions__c.contains('CAT1CAP')) ||
                                (!approvedSpecialCons.contains('STCBA') && objOpp.Non_Standard_Special_Conditions__c.contains('STCBA')) ||
                                (!approvedSpecialCons.contains('VPTR') && objOpp.Non_Standard_Special_Conditions__c.contains('VPTR')) ||
                                (!approvedSpecialCons.contains('HDOVR') && objOpp.Non_Standard_Special_Conditions__c.contains('HDOVR')) ||
                                (!approvedSpecialCons.contains('HOARDCAP') && objOpp.Non_Standard_Special_Conditions__c.contains('HOARDCAP')) ||
                                (!approvedSpecialCons.contains('HOARD50') && objOpp.Non_Standard_Special_Conditions__c.contains('HOARD50')) ||
                                (!approvedSpecialCons.contains('INTER') && objOpp.Non_Standard_Special_Conditions__c.contains('INTER')) ||
                                (!approvedSpecialCons.contains('DIRDEB') && objOpp.Non_Standard_Special_Conditions__c.contains('DIRDEB'))

                )
                ) {
            objOpp.LAD_Approved__c = false;
        } else if (refreshSource != 'LAD_Approved__c' && refreshSource != null && (nSSpecialCons == null || nSSpecialCons.size() == 0)) {
            objOpp.LAD_Approved__c = true;
        }

        checkApprovedSpecialCons();
    }

    // Promotion contribution is calculated from the rent but it cannot exceed the centre's cap
    public void calcPromoContribution() {
        if (objOpp.Promotion_Contribution_Percent__c > 0 && objOpp.Base_Rent__c > 0) {
            objOpp.Promo_Amt_Year_1__c = (objOpp.Promotion_Contribution_Percent__c * objOpp.Base_Rent__c) * (0.01);

            if (objOpp.Promo_Amt_Year_1__c > objOpp.Unit__r.Building__r.Centre__r.Conditional_Cap__c) {
                objOpp.Promo_Amt_Year_1__c = objOpp.Unit__r.Building__r.Centre__r.Conditional_Cap__c;
            }
        }else if (objOpp.Promotion_Contribution_Percent__c > 0 && objOpp.Gross_Rent__c > 0 && objOpp.Recovery_Type__c == 'Gross + Promo') {
            objOpp.Promo_Amt_Year_1__c = (objOpp.Promotion_Contribution_Percent__c * objOpp.Gross_Rent__c) * (0.01);

            if (objOpp.Promo_Amt_Year_1__c > objOpp.Unit__r.Building__r.Centre__r.Conditional_Cap__c) {
                objOpp.Promo_Amt_Year_1__c = objOpp.Unit__r.Building__r.Centre__r.Conditional_Cap__c;
            }
        }
    }

    //Popuplate mobile multi-select lists
    public void loadMobileSelectLists() {
        if (objOpp.Existing_Fitout_Taken_Over_By_Tenant__c != null) {
            ExistingFitouts = objOpp.Existing_Fitout_Taken_Over_By_Tenant__c.split(';');
        } else {
            ExistingFitouts = new List<String>();
        }

        if (objOpp.Guarantor_Reps__c != null) {
            GuarRepsG = objOpp.Guarantor_Reps__c.split(';');
        } else {
            GuarRepsG = new List<String>();
        }
    }

    // Authorised tenant representatives
    public List<SelectOption> getAuthReps() {
        List<SelectOption> authReps = new List<SelectOption>();
        for (Contact c : [
                SELECT Id, LastName, Tenant_Rep_Type__c, Tenant_Rep_ACN__c
                FROM Contact
                WHERE Tenant_Rep_Type__c = 'Authorised Representative'
                AND Whos_Who_Line_Number__c != NULL
                AND Id NOT IN :extAuthRepIds
                AND AccountId = :objOpp.AccountId
                ORDER BY LastName
        ]) {
            authReps.add(new SelectOption(c.Id, c.LastName));
        }
        return authReps;
    }

    // Returns all auth reps
    public List<SelectOption> getAllAuthReps() {
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
        return authReps;
    }

    // Selected authorised representatives for the opportunity
    public List<SelectOption> getOpportunityAuthReps() {
        List<SelectOption> authReps = new List<SelectOption>();
        Set<String> setIds = new Set<String>();

        if (objOpp.Authorised_Reps__c != null) {
            string repId = objOpp.Authorised_Reps__c;
            string[] repIds = repId.split(';');

            for (String s : repIds) {
                setIds.add(s);
            }

            for (Contact c : [SELECT Id, LastName FROM Contact WHERE Id IN :setIds ORDER BY LastName]) {
                authReps.add(new SelectOption(c.Id, c.LastName));
            }
        }
        return authReps;
    }

    // Billing tenant representatives
    public List<SelectOption> getBillReps() {
        List<SelectOption> BillReps = new List<SelectOption>();
        for (Contact c : [
                SELECT Id, LastName, Tenant_Rep_Type__c
                FROM Contact
                WHERE Tenant_Rep_Type__c = 'Billing Representative'
                AND Id NOT IN :extBillRepIds
                AND AccountId = :objOpp.AccountId
                AND Whos_Who_Line_Number__c != NULL
                ORDER BY LastName
        ]) {
            BillReps.add(new SelectOption(c.Id, c.LastName));
        }
        return BillReps;
    }

    // Returns all bill reps
    public List<SelectOption> getAllBillReps() {
        List<SelectOption> br = new List<SelectOption>();
        for (Contact c : [
                SELECT Id, LastName, Tenant_Rep_Type__c
                FROM Contact
                WHERE Tenant_Rep_Type__c = 'Billing Representative'
                AND AccountId = :objOpp.AccountId
                AND Whos_Who_Line_Number__c != NULL
                ORDER BY LastName
        ]) {
            br.add(new SelectOption(c.Id, c.LastName));
        }
        return br;
    }

    // Selected billing representatives for the opportunity
    public List<SelectOption> getOpportunityBillReps() {
        List<SelectOption> BillReps = new List<SelectOption>();
        Set<String> setIds = new Set<String>();

        if (objOpp.Billing_Reps__c != null) {
            string repId = objOpp.Billing_Reps__c;
            string[] repIds = repId.split(';');

            for (String s : repIds) {
                setIds.add(s);
            }

            for (Contact c : [SELECT Id, LastName FROM Contact WHERE Id IN :setIds ORDER BY LastName]) {
                BillReps.add(new SelectOption(c.Id, c.LastName));
            }
        }
        return BillReps;
    }

    // Guarantor tenant representatives
    public List<SelectOption> getGuarReps() {
        List<SelectOption> GuarReps = new List<SelectOption>();
        for (Contact c : [
                SELECT Id, LastName, Tenant_Rep_Type__c, Tenant_Rep_ACN__c
                FROM Contact
                WHERE Tenant_Rep_Type__c = 'Gaurantor Representative'
                AND Id NOT IN :extGuarRepIds
                AND AccountId = :objOpp.AccountId
                AND Whos_Who_Line_Number__c != NULL
                ORDER BY LastName
        ]) {
            GuarReps.add(new SelectOption(c.Id, c.LastName));
            // Parent Guarantor Name
            if(c.Tenant_Rep_ACN__c != null){
                objOpp.Parent_Guarantor_Name__c = c.LastName;
            }
        }
        return GuarReps;
    }

    // Returns all Guarantors
    public List<SelectOption> getAllGuarReps() {
        List<SelectOption> GuarReps = new List<SelectOption>();
        for (Contact c : [
                SELECT Id, LastName, Tenant_Rep_Type__c, Tenant_Rep_ACN__c
                FROM Contact
                WHERE Tenant_Rep_Type__c = 'Gaurantor Representative'
                AND AccountId = :objOpp.AccountId
                AND Whos_Who_Line_Number__c != NULL
                ORDER BY LastName
        ]) {
            GuarReps.add(new SelectOption(c.Id, c.LastName));
            // Parent Guarantor Name
            if(c.Tenant_Rep_ACN__c != null){
                objOpp.Parent_Guarantor_Name__c = c.LastName;
            }
        }
        return GuarReps;
    }

    // Selected guarantor representatives for the opportunity
    public List<SelectOption> getOpportunityGuarReps() {
        List<SelectOption> GuarReps = new List<SelectOption>();
        Set<String> setIds = new Set<String>();

        if (objOpp.Guarantor_Reps__c != null) {
            string repId = objOpp.Guarantor_Reps__c;
            string[] repIds = repId.split(';');

            for (String s : repIds) {
                setIds.add(s);
            }

            for (Contact c : [SELECT Id, LastName FROM Contact WHERE Id IN :setIds ORDER BY LastName]) {
                GuarReps.add(new SelectOption(c.Id, c.LastName));
            }
        }
        return GuarReps;
    }

    // Legal tenant representatives
    public List<SelectOption> getLegalReps() {
        List<SelectOption> LegalReps = new List<SelectOption>();
        for (Contact c : [
                SELECT Id, LastName, Tenant_Rep_Type__c
                FROM Contact
                WHERE Tenant_Rep_Type__c = 'Legal Representative'
                AND Id NOT IN :extLegalRepIds
                AND AccountId = :objOpp.AccountId
                AND Whos_Who_Line_Number__c != NULL
                ORDER BY LastName
        ]) {
            LegalReps.add(new SelectOption(c.Id, c.LastName));
        }
        return LegalReps;
    }

    // Returns all legal reps
    public List<SelectOption> getAllLegalReps() {
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
        return LegalReps;
    }

    // Selected legal representatives for the opportunity
    public List<SelectOption> getOpportunityLegalReps() {
        List<SelectOption> LegalReps = new List<SelectOption>();
        Set<String> setIds = new Set<String>();

        if (objOpp.Legal_Reps__c != null) {
            string repId = objOpp.Legal_Reps__c;
            string[] repIds = repId.split(';');

            for (String s : repIds) {
                setIds.add(s);
            }

            for (Contact c : [SELECT Id, LastName FROM Contact WHERE Id IN :setIds ORDER BY LastName]) {
                LegalReps.add(new SelectOption(c.Id, c.LastName));
            }
        }
        return LegalReps;
    }

    // Notice tenant representatives
    public List<SelectOption> getNoticeReps() {
        List<SelectOption> NoticeReps = new List<SelectOption>();
        for (Contact c : [
                SELECT Id, LastName, Tenant_Rep_Type__c
                FROM Contact
                WHERE Tenant_Rep_Type__c = 'Notice Representative'
                AND Id NOT IN :extNoticeRepIds
                AND AccountId = :objOpp.AccountId
                AND Whos_Who_Line_Number__c != NULL
                ORDER BY LastName
        ]) {
            NoticeReps.add(new SelectOption(c.Id, c.LastName));
        }
        return NoticeReps;
    }

    // Returns all notice reps
    public List<SelectOption> getAllNoticeReps() {
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
        return NoticeReps;
    }

    // Selected notice representatives for the opportunity
    public List<SelectOption> getOpportunityNoticeReps() {
        List<SelectOption> NoticeReps = new List<SelectOption>();
        Set<String> setIds = new Set<String>();

        if (objOpp.Notice_Reps__c != null) {
            string repId = objOpp.Notice_Reps__c;
            string[] repIds = repId.split(';');

            for (String s : repIds) {
                setIds.add(s);
            }

            for (Contact c : [SELECT Id, LastName FROM Contact WHERE Id IN :setIds ORDER BY LastName]) {
                NoticeReps.add(new SelectOption(c.Id, c.LastName));
            }
        }
        return NoticeReps;
    }

    // Registered tenant representatives
    public List<SelectOption> getRegiReps() {
        List<SelectOption> RegReps = new List<SelectOption>();
        for (Contact c : [
                SELECT Id, LastName, Tenant_Rep_Type__c
                FROM Contact
                WHERE Tenant_Rep_Type__c = 'Registered Representative'
                AND Id NOT IN :extRegRepIds
                AND AccountId = :objOpp.AccountId
                AND Whos_Who_Line_Number__c != NULL
                ORDER BY LastName
        ]) {
            RegReps.add(new SelectOption(c.Id, c.LastName));
        }
        return RegReps;
    }

    // Returns all reg reps
    public List<SelectOption> getAllRegReps() {
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
        return RegReps;
    }

    // Selected registered representatives for the opportunity
    public List<SelectOption> getOpportunityRegReps() {
        List<SelectOption> RegReps = new List<SelectOption>();
        Set<String> setIds = new Set<String>();

        if (objOpp.Registration_Reps__c != null) {
            string repId = objOpp.Registration_Reps__c;
            string[] repIds = repId.split(';');

            for (String s : repIds) {
                setIds.add(s);
            }

            for (Contact c : [SELECT Id, LastName FROM Contact WHERE Id IN :setIds ORDER BY LastName]) {
                RegReps.add(new SelectOption(c.Id, c.LastName));
            }
        }
        return RegReps;
    }

    //Calculate percentage rent rate
    public void calcPercentageRentRate() {

        if (objOpp.Percentage_Rent_Category__c == 'FOOD') {
            objOpp.Percentage_Rent_Rate__c = 8;
        } else if (objOpp.Percentage_Rent_Category__c == 'RETAIL') {
            objOpp.Percentage_Rent_Rate__c = 10;
        } else if (objOpp.Percentage_Rent_Category__c == 'LIQUOR') {
            objOpp.Percentage_Rent_Rate__c = 2;
        } else if (objOpp.Percentage_Rent_Category__c == 'REST') {
            objOpp.Percentage_Rent_Rate__c = 10;
        } else if (objOpp.Percentage_Rent_Category__c == 'TATTRV') {
            objOpp.Percentage_Rent_Rate__c = 1;
        } else if (objOpp.Percentage_Rent_Category__c == 'SERV') {
            objOpp.Percentage_Rent_Rate__c = 10;
        } else if (objOpp.Percentage_Rent_Category__c == 'CAFE') {
            objOpp.Percentage_Rent_Rate__c = 12;
        } else if (objOpp.Percentage_Rent_Category__c == 'TOBACC') {
            objOpp.Percentage_Rent_Rate__c = 1;
        } else {
            objOpp.Percentage_Rent_Rate__c = 0;
        }
    }

    // Getting related tenant information
    public void getAccount() {

        if (objOpp.AccountId != null) {
            List<Account> lstAccount = [
                    SELECT Id,Tenant_ACN__c,Tenant_CABID__c,Tenant_Entity__c,BillingAddress
                    FROM Account
                    WHERE Id = :objOpp.AccountId
            ];

            if (lstAccount.size() > 0) {
                if (lstAccount[0].Tenant_CABID__c == '276050') {
                    defaultTenant = true;
                    tenantName = objOpp.New_Trading_Name__c;
                    tenantACN = objOpp.New_Tenant_ACN__c;
                    tenantEntity = objOpp.New_Tenant_Entity__c;
                } else {
                    defaultTenant = false;
                    tenantName = objOpp.Account.Name;
                    tenantACN = lstAccount[0].Tenant_ACN__c;
                    tenantCABID = lstAccount[0].Tenant_CABID__c;
                    tenantEntity = lstAccount[0].Tenant_Entity__c;
                }
            }
        }

    }

    // Setting up conditional data for the LOIF
    public void getFieldValues() {

        // Tenant Representative Details
        if (objOpp.Existing_Retailer__c == true) {

            Set<Id> contactId = new Set<Id>();

            for (OpportunityContactRole oppcon : [
                    SELECT Id,ContactId,OpportunityId
                    FROM OpportunityContactRole
                    WHERE OpportunityId = :objOpp.Id
            ]) {
                contactId.add(oppcon.ContactId);
            }

            for (Contact c : [
                    SELECT Id, Name, FirstName, LastName, Tenant_Rep_Type__c, MailingStreet, MailingCity, MailingState, Tenant_Description__c,
                            MailingCountry, MailingPostalCode, Tenant_Email__c, Phone_Number__c, Phone_Number_Prefix__c
                    FROM Contact
                    WHERE Id IN :contactId
            ]) {
                if (c.Tenant_Rep_Type__c == 'Authorised Representative') {
                    conAuthRep = c.Name;
                    conAuthRep_FirstName = (conAuthRep != null && conAuthRep.contains(' ')
                            && conAuthRep.split(' ').size() > 1) ? conAuthRep.split(' ')[0] : conAuthRep;
                    conAuthAddress = c.MailingStreet;
                    conAuthEmail = c.Tenant_Email__c;
                    conAuthPhone = (c.Phone_Number_Prefix__c != null) ? c.Phone_Number_Prefix__c + ' ' + c.Phone_Number__c : c.Phone_Number__c;
                    if (c.mailingStreet != null) {
                        conAuthAddress = c.MailingStreet + ',';
                        conAuthAddress_Street = c.MailingStreet;
                    }if (c.MailingCity != null) {
                        conAuthAddress = conAuthAddress + c.MailingCity + ',';
                        conAuthAddress_City = c.MailingCity;
                    }if (c.MailingState != null) {
                        conAuthAddress = conAuthAddress + c.MailingState + ',';
                        conAuthAddress_State = c.MailingState;
                    }if (c.MailingPostalCode != null) {
                        conAuthAddress = conAuthAddress + c.MailingPostalCode + ',';
                        conAuthAddress_PostCode = c.MailingPostalCode;
                    }if (c.MailingCountry != null) {
                        conAuthAddress = conAuthAddress + c.MailingCountry;
                        conAuthAddress_Country = c.MailingCountry;
                    }if (c.Tenant_Description__c != null) {
                        conAuthAddress_Desc = c.Tenant_Description__c;
                    }
                } else if (c.Tenant_Rep_Type__c == 'Legal Representative') {
                    conLegRep = c.Name;
                    conLegAddress = '';
                    conLegEmail = c.Tenant_Email__c;
                    conLegPhone = (c.Phone_Number_Prefix__c != null) ? c.Phone_Number_Prefix__c + ' ' + c.Phone_Number__c : c.Phone_Number__c;

                    if (c.mailingStreet != null){
                        conLegAddress = c.mailingStreet + ',';
                    }

                    if (c.mailingCity != null){
                        conLegAddress = conLegAddress + c.mailingCity + ',';
                    }

                    if (c.mailingState != null){
                        conLegAddress = conLegAddress + c.mailingState + ',';
                    }

                    if (c.mailingPostalCode != null){
                        conLegAddress = conLegAddress + c.mailingPostalCode + ',';
                    }

                    if (c.mailingCountry != null){
                        conLegAddress = conLegAddress + c.mailingCountry;
                    }

                } else if (c.Tenant_Rep_Type__c == 'Billing Representative') {
                    conBillRep = c.Name;
                    conBillAddress = '';
                    conBillEmail = c.Tenant_Email__c;
                    conBillPhone = (c.Phone_Number_Prefix__c != null) ? c.Phone_Number_Prefix__c + ' ' + c.Phone_Number__c : c.Phone_Number__c;

                    if (c.mailingStreet != null){
                        conBillAddress = c.mailingStreet + ',';
                    }

                    if (c.mailingCity != null){
                        conBillAddress = conBillAddress + c.mailingCity + ',';
                    }

                    if (c.mailingState != null){
                        conBillAddress = conBillAddress + c.mailingState + ',';
                    }

                    if (c.mailingPostalCode != null){
                        conBillAddress = conBillAddress + c.mailingPostalCode + ',';
                    }

                    if (c.mailingCountry != null){
                        conBillAddress = conBillAddress + c.mailingCountry;
                    }

                } else if (c.Tenant_Rep_Type__c == 'Gaurantor Representative') {
                    if (conGarRep1 == null) {
                        conGarRep1 = c.Name;
                        conGarAddress1 = '';
                        conGar1Email = c.Tenant_Email__c;
                        conGar1Phone = (c.Phone_Number_Prefix__c != null) ? c.Phone_Number_Prefix__c + ' ' + c.Phone_Number__c : c.Phone_Number__c;

                        if (c.mailingStreet != null){
                            conGarAddress1 = c.mailingStreet + ',';
                        }

                        if (c.mailingCity != null){
                            conGarAddress1 = conGarAddress1 + c.mailingCity + ',';
                        }

                        if (c.mailingState != null){
                            conGarAddress1 = conGarAddress1 + c.mailingState + ',';
                        }

                        if (c.mailingPostalCode != null){
                            conGarAddress1 = conGarAddress1 + c.mailingPostalCode + ',';
                        }

                        if (c.mailingCountry != null){
                            conGarAddress1 = conGarAddress1 + c.mailingCountry;
                        }

                    } else if (conGarRep2 == null) {
                        conGarRep2 = c.Name;
                        conGarAddress2 = '';
                        conGar2Email = c.Tenant_Email__c;
                        conGar2Phone = (c.Phone_Number_Prefix__c != null) ? c.Phone_Number_Prefix__c + ' ' + c.Phone_Number__c : c.Phone_Number__c;
                        if (c.mailingStreet != null){
                            conGarAddress2 = c.mailingStreet + ',';
                        }
                        if (c.mailingCity != null){
                            conGarAddress2 = conGarAddress2 + c.mailingCity + ',';
                        }
                        if (c.mailingState != null){
                            conGarAddress2 = conGarAddress2 + c.mailingState + '.';
                        }
                        if (c.mailingPostalCode != null){
                            conGarAddress2 = conGarAddress2 + c.mailingPostalCode + ',';
                        }
                        if (c.mailingCountry != null){
                            conGarAddress2 = conGarAddress2 + c.mailingCountry;
                        }

                    } else if (conGarRep3 == null) {
                        conGarRep3 = c.Name;
                        conGarAddress3 = '';
                        conGar3Email = c.Tenant_Email__c;
                        conGar3Phone = (c.Phone_Number_Prefix__c != null) ? c.Phone_Number_Prefix__c + ' ' + c.Phone_Number__c : c.Phone_Number__c;

                        if (c.mailingStreet != null){
                            conGarAddress3 = c.mailingStreet + ',';
                        }

                        if (c.mailingCity != null){
                            conGarAddress3 = conGarAddress3 + c.mailingCity + ',';
                        }

                        if (c.mailingState != null){
                            conGarAddress3 = conGarAddress3 + c.mailingState + ',';
                        }

                        if (c.mailingPostalCode != null){
                            conGarAddress3 = conGarAddress3 + c.mailingPostalCode + ',';
                        }

                        if (c.mailingCountry != null){
                            conGarAddress3 = conGarAddress3 + c.mailingCountry;
                        }

                    }
                } else if (c.Tenant_Rep_Type__c == 'Registered Representative') {
                    conRegAddress = '';
                    conRegEmail = c.Tenant_Email__c;
                    conRegPhone = (c.Phone_Number_Prefix__c != null) ? c.Phone_Number_Prefix__c + ' ' + c.Phone_Number__c : c.Phone_Number__c;

                    if (c.mailingStreet != null){
                        conRegAddress = c.mailingStreet + ',';
                    }

                    if (c.mailingCity != null){
                        conRegAddress = conRegAddress + c.mailingCity + ',';
                    }

                    if (c.mailingState != null){
                        conRegAddress = conRegAddress + c.mailingState + ',';
                    }

                    if (c.mailingPostalCode != null){
                        conRegAddress = conRegAddress + c.mailingPostalCode + ',';
                    }

                    if (c.mailingCountry != null){
                        conRegAddress = conRegAddress + c.mailingCountry;
                    }


                } else if (c.Tenant_Rep_Type__c == 'Notice Representative') {
                    conNotAddress = '';
                    conNotEmail = c.Tenant_Email__c;
                    conNotPhone = (c.Phone_Number_Prefix__c != null) ? c.Phone_Number_Prefix__c + ' ' + c.Phone_Number__c : c.Phone_Number__c;

                    if (c.mailingStreet != null){
                        conNotAddress = c.mailingStreet + ',';
                    }

                    if (c.mailingCity != null){
                        conNotAddress = conNotAddress + c.mailingCity + ',';
                    }

                    if (c.mailingState != null){
                        conNotAddress = conNotAddress + c.mailingState + ',';
                    }

                    if (c.mailingPostalCode != null){
                        conNotAddress = conNotAddress + c.mailingPostalCode + ',';
                    }

                    if (c.mailingCountry != null){
                        conNotAddress = conNotAddress + c.mailingCountry;
                    }


                }
            }

        }
        //Override Reps
        if (objOpp.New_Leg_Rep_Added__c == true) {
            conLegRep = objOpp.New_Leg_Rep_Name__c;
            conLegEmail = objOpp.New_Leg_Rep_Email__c;
            conLegAddress = objOpp.New_Leg_Rep_Address__c;
            conLegPhone = objOpp.New_Leg_Rep_Phone_1__c;
        }

        if (objOpp.New_Auth_Rep_Added__c == true) {
            conAuthRep = objOpp.New_Auth_Rep_Name__c;
            conAuthRep_FirstName = (conAuthRep != null && conAuthRep.contains(' ')
                    && conAuthRep.split(' ').size() > 1) ? conAuthRep.split(' ')[0] : conAuthRep;
            //conAuthRep_FirstName = objOpp.New_Auth_Rep_Name__c;
            conAuthAddress = objOpp.New_Auth_Rep_Address__c;
            conAuthEmail = objOpp.New_Auth_Rep_Email__c;
            conAuthPhone = objOpp.New_Auth_Rep_Phone1__c;
        }
    }

    //Validate EOI
    public Boolean checkEOI() {
        validator.errorMsgs.clear();
        if (!validator.validateEOI(objOpp)) {
            if (ApexPages.currentPage() != null) {
                for (String errorMsg : validator.errorMsgs) {
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, errorMsg);
                    ApexPages.addMessage(myMsg);
                    System.debug('EOI Validation Error : ' + errorMsg);
                }
            }
            errMsgITL = true;
        }

        return errMsgITL;
    }

    //Validate LON
    public Boolean checkLON() {
        validator.errorMsgs.clear();

        validator.nsSpecialCons = this.nSSpecialCons;
        if (!validator.validateLON(objOpp, validator.validateEOI(objOpp))) {
            if (ApexPages.currentPage() != null) {
                for (String errorMsg : validator.errorMsgs) {
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, errorMsg);
                    ApexPages.addMessage(myMsg);
                    System.debug('LON Validation Error : ' + errorMsg);
                }
            }
            errMsg = true;
        }

        return errMsg;
    }

    public PageReference saveAndRefresh() {
        saveDeal();
        return pageReload();
    }

    public void updateRetailer() {
        if (objOpp.AccountId != null) {
            objOpp.New_Retailer__c = false;
            objOpp.Existing_Retailer__c = true;

            saveDeal();
        }
    }

    //Save Mobile Select List Values
    public void saveMobilePicklists() {

        objOpp.Existing_Fitout_Taken_Over_By_Tenant__c = null;
        for (String i : ExistingFitouts) {
            if (objOpp.Existing_Fitout_Taken_Over_By_Tenant__c != null) {
                objOpp.Existing_Fitout_Taken_Over_By_Tenant__c = objOpp.Existing_Fitout_Taken_Over_By_Tenant__c + ';' + i ;
            } else {
                objOpp.Existing_Fitout_Taken_Over_By_Tenant__c = i;
            }
        }

        objOpp.Guarantor_Reps__c = null;
        for (String i : GuarRepsG) {
            if (objOpp.Guarantor_Reps__c != null) {
                objOpp.Guarantor_Reps__c = objOpp.Guarantor_Reps__c + ';' + i ;
            } else {
                objOpp.Guarantor_Reps__c = i;
            }
        }
    }

    // Save
    public void saveDeal() {
        errMsg = false;
        errMsgITL = false;
        lonGenerated = false;
        eoiGenerated = false;

        refreshField();

        if (UserInfo.getUiThemeDisplayed() == 'Theme4t') {
            saveMobilePicklists();
        }

        try {
            update objOpp;
            update nSSpecialCons;

        } catch (Exception e) {
            ErrorLogHandler.log('Deal Save Exception #1 :', e);
            ErrorLogHandler.log('Deal Save Exception #2 :', String.valueOf(objOpp));
        } finally {
            objOpp = dealsCommon.getDeal(objOpp.Id);
        }

        getFieldValues();

    }

    //Clear prefered tenant
    @Future
    public static void clearPreferredTenant(Id dealId) {

        List<Unit__c> unitsToUpdate = [
                SELECT Name, Id,
                        Preferred_Tenant__c
                FROM Unit__c
                WHERE Preferred_Tenant__c = :dealId
        ];

        for (Unit__c units : unitsToUpdate) {
            units.Preferred_Tenant__c = null;
        }

        update unitsToUpdate;
    }

    //Get ECM Document Links
    public Map<String, String> ecmDocLinks {
        get {
            Map<String, String> tempLinks = new Map<String, String>();
            if (objOpp.EOI_Documents__c != null) {
                List<EcmLink> ecmLinks = (List<EcmLink>) System.JSON.deserialize(objOpp.EOI_Documents__c, List<EcmLink>.class);
                for (EcmLink ecmLink : ecmLinks) {
                    tempLinks.put(ecmLink.title, ecmLink.link);
                }
            }
            return tempLinks;
        }
    }

    // Uncomment this when deploying again - just commented out to test the email
    @Future(Callout=true)
    public static void generateEOI(Id oppId) {

        try {
            //if(!checkEOI()){ //If EOI is valid
            //PageReference eoiPDF = new PageReference('/apex/VC_Exp_of_InterestVF?id='+oppObj.Id);
            Opportunity opp = [
                    SELECT Name, Id, CreatedDate, Owner.Email, Owner.Name
                    FROM Opportunity
                    WHERE Id = :oppId
                    LIMIT 1
            ];

            PageReference eoiPDF = Page.VC_Exp_of_InterestVF;
            eoiPDF.getParameters().put('id', oppId);

            // Upload EOI
            ContentVersion eoiToInsert = new ContentVersion();
            eoiToInsert.versionData = eoiPDF.getContentAsPDF();
            eoiToInsert.title = opp.Name + ' - ' + opp.CreatedDate;
            eoiToInsert.pathOnclient = opp.Name + ' - ' + system.now() + '.pdf';
            insert eoiToInsert;

            List<ContentVersion> eoi = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id = :eoiToInsert.Id];

            ContentDocumentLink eoiDocLink = new ContentDocumentLink();
            eoiDocLink.ContentDocumentId = eoi[0].ContentDocumentId;
            eoiDocLink.LinkedEntityId = opp.Id;
            eoiDocLink.ShareType = 'V';
            eoiDocLink.Visibility = 'AllUsers';
            insert eoiDocLink;

            // Attach files into email
            List<Messaging.Emailfileattachment> attachList = new List<Messaging.Emailfileattachment>();

            Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
            attach.setContentType('application/pdf');
            attach.setFileName(eoiToInsert.pathOnclient);
            attach.Body = eoiToInsert.versionData;
            attachList.add(attach);

            // Send Email
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setUseSignature(false);
            mail.setToAddresses(new String[]{
                    opp.Owner.Email
            });
            //mail.setTargetObjectId(UserInfo.getUserId());
            mail.setSenderDisplayName('Salesforce Administrator');
            mail.setSaveAsActivity(false);
            mail.setSubject('Expression of Interest - ' + opp.Name);
            mail.setHtmlBody('<p>Hi ' + opp.Owner.Name + ',' + '<br/><br/> Here is the form you requested - ' + eoiToInsert.title + '<br/><br/>Vicinity Centres<br/><br/></p>');
            mail.setFileAttachments(attachList);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[]{
                    mail
            });


            //eoiGenerated = true;
            //}else{

            //}
        } catch (exception ex) {
            ErrorLogHandler.log('EOI Generation Exception: ' + ex.getMessage(), ex.getStackTraceString());
        }

    }

    //Query API Fields
    public void requeryApiFieds() {
        Opportunity op = [
                SELECT Name, Id,
                        EOI_Documents__c,
                        TDP_Created__c,
                        TDP_Creation_Error__c,
                        Process_Status__c,
                        Process_Status_Identifier__c,
                        Process_Status_Date__c,
                        TDP_Milestone__c,
                        TDP_Milestone_Date__c,
                        Open_for_Trade_Date__c,
                        Last_Updated_By_API__c,
                        LON_Pending__c,
                        LON_Generated__c
                FROM Opportunity
                WHERE Id = :objOpp.Id
                LIMIT 1
        ];
        objOpp.EOI_Documents__c = op.EOI_Documents__c;
        objOpp.TDP_Created__c = op.TDP_Created__c;
        objOpp.TDP_Creation_Error__c = op.TDP_Creation_Error__c;
        objOpp.LON_Generated__c = op.LON_Generated__c;
        objOpp.LON_Pending__c = op.LON_Pending__c;
        objOpp.Process_Status__c = op.Process_Status__c;
        objOpp.Process_Status_Identifier__c = op.Process_Status_Identifier__c;
        objOpp.Process_Status_Date__c = op.Process_Status_Date__c;
        objOpp.TDP_Milestone__c = op.TDP_Milestone__c;
        objOpp.TDP_Milestone_Date__c = op.TDP_Milestone_Date__c;
        objOpp.Open_for_Trade_Date__c = op.Open_for_Trade_Date__c;
        objOpp.Last_Updated_By_API__c = op.Last_Updated_By_API__c;
    }

    // Method called to refersh fields
    public void refreshField() {

        requeryApiFieds();

        checkEditablity();

        if (objOpp.LON044_Custom_Refit_Condition__c != true) {
            objOpp.LON044_NTSD__c = null;
        }

        if (objOpp.LON001_Custom_Text__c != true) {
            objOpp.LON001_NTSD__c = null;
        }

        if (objOpp.LON007_Custom_Text__c != true) {
            objOpp.LON007_NTSD__c = null;
        }

        if (objOpp.LON010_Custom_Text__c != true) {
            objOpp.LON010_NTSD__c = null;
        }

        if (objOpp.LON045_Custom_Text__c != true) {
            objOpp.LON045_NTSD__c = null;
        }

        if (objOpp.LON046_Custom_Text__c != true) {
            objOpp.LON046_NTSD__c = null;
        }

        if (objOpp.LON020_Custom_Text__c != true) {
            objOpp.LON020_NTSD__c = null;
        }

        if (objOpp.LON049_Custom_Text__c != true) {
            objOpp.LON049_NTSD__c = null;
        }

        if (objOpp.Percentage_Rent_Threshold__c != 'Artificial') {
            objOpp.Artificial_Threshold_Amount__c = null;
        }

        if (objOpp.Promotion_Contribution_Percent__c == 0) {
            objOpp.Promo_Amt_Year_1__c = 0;
        }

        if (objOpp.Liquor_Licence__c != true) {
            objOpp.LQRLIC_NTSD__c = null;
            objOpp.LQRLIC_Options__c = null;
            objOpp.Liqour_Licence_Date__c = null;
        }


        if (objOpp.Early_Renewal__c) {
            objOpp.Surrender_other_premises_in_Centre__c = false;
        } else {
            objOpp.Surrender_these_premises_in_Centre__c = false;
        }

        objOpp.LON031_Tenants_Current_Lease_Unit__c = objOpp.Surrender_other_premises_Unit__c;

        // Stuart Donnachie - change of below if logic that was blowing away the Surrender Other Premises values on save. First logic was previously !objOpp.Surrender_other_premises_in_Centre__c != true
        if (objOpp.Surrender_other_premises_in_Centre__c != true || objOpp.Surrender_these_premises_in_Centre__c) {
            objOpp.Surrender_other_premises_Date_Options__c = null;
            objOpp.Surrender_other_premises_Date__c = null;
            objOpp.Surrender_other_premises_Cost__c = null;
            objOpp.Surrender_other_premises_Fees__c = null;
            objOpp.Surrender_other_premises_Legal_Cost__c = null;
            objOpp.Surrender_other_premises_Make_Good__c = null;
            objOpp.Surrender_other_premises_Unit__c = null;
            objOpp.LON031_Options__c = null;
            objOpp.LON031_Tenants_Current_Lease_Unit__c = null;
        }

        if (objOpp.Surrender_these_premises_in_Centre__c != true || objOpp.Surrender_other_premises_in_Centre__c) {
            objOpp.Surrender_these_premises_Date_Options__c = null;
            objOpp.Surrender_these_premises_Date__c = null;
            objOpp.Surrender_these_premises_Cost__c = null;
            objOpp.Surrender_these_premises_Fees__c = null;
            objOpp.Surrender_these_premises_Legal_Cost__c = null;
            objOpp.Surrender_these_premises_Make_Good__c = null;
            objOpp.Surrender_these_premises_Unit__c = null;
            objOpp.LON032_Options__c = null;
        }

        if (objOpp.Bank_Guarantee_Requirement__c != 'Yes') {
            objOpp.Bank_Guarantee_Months__c = null;
        }

        //if(refreshSource == 'Bank_Guarantee_Requirement__c' || objOpp.Bank_Guarantee_Requirement__c == 'No'){
        //objOpp.Type_of_Guarantor_Required__c = 'NA';
        //}

        if (objOpp.Type_of_Guarantor_Required__c == 'NA') {
            objOpp.No_of_Personal_Guarantee__c = null;
        }

        if (objOpp.Estimated_Lease_Commencement_Date__c != null) {
            objOpp.Refit_Completion_Date__c = objOpp.Estimated_Lease_Commencement_Date__c.addMonths(3);
        }

        if (String.isEmpty(refreshSource) || refreshSource == 'Promotion_Contribution_Percent__c'
                || refreshSource == 'Base_Rent__c' || refreshSource == 'Promo_Amt_Year_1__c' || objOpp.Recovery_Type__c == 'Gross + Promo') {
            calcPromoContribution();
        }
        /*
if(String.isEmpty(refreshSource) ||  refreshSource == 'Base_Rent__c' || refreshSource == 'Lease_Incentive_Days__c'){
if(objOpp.Base_Rent__c > 0 && objOpp.Lease_Incentive_Days__c >0){
objOpp.Lease_Incentive_Amount__c = ((objOpp.Base_Rent__c )/365)* objOpp.Lease_Incentive_Days__c;
}
}
*/
        if (String.isEmpty(refreshSource) || refreshSource == 'Estimated_Lease_Commencement_Date__c') {
            if (objOpp.Estimated_Lease_Commencement_Date__c != null) {
                objOpp.Refit_Completion_Date__c = objOpp.Estimated_Lease_Commencement_Date__c + 90;
            }
        }

        if (objOpp.Deal_Type__c != 'Renewal') {
            if (objOpp.Gross_Rent__c != null && (objOpp.Recovery_Type__c == 'Gross' || objOpp.Recovery_Type__c == 'Gross + Promo')) {
                objOpp.Rent_Advance__c = objOpp.Gross_Rent__c / 12;
            } else if (objOpp.Base_Rent__c != null && objOpp.Recovery_Type__c == 'Net') {
                objOpp.Rent_Advance__c = objOpp.Base_Rent__c / 12;
            } else {
                objOpp.Rent_Advance__c = 0;
            }
        } else {
            objOpp.Rent_Advance__c = 0;
        }

        /*
		if(objOpp.Gross_Rent__c !=null && objOpp.Recovery_Type__c == 'Gross'){
		objOpp.Natural_Threshold__c = (objOpp.Gross_Rent__c/12) * 100;
		}else if(objOpp.Base_Rent__c !=null && objOpp.Recovery_Type__c == 'Net'){
		objOpp.Natural_Threshold__c = (objOpp.Base_Rent__c/12) * 100;
		}else{
		objOpp.Natural_Threshold__c = 0;
		}
		*/
        if (objOpp.Gross_Rent__c != null && (objOpp.Recovery_Type__c == 'Gross' || objOpp.Recovery_Type__c == 'Gross + Promo')
                && objOpp.Percentage_Rent_Rate__c != null && objOpp.Percentage_Rent_Rate__c != 0) {
            objOpp.Natural_Threshold__c = (objOpp.Gross_Rent__c / objOpp.Percentage_Rent_Rate__c) * 100;
        } else if (objOpp.Base_Rent__c != null && objOpp.Recovery_Type__c == 'Net'
                && objOpp.Percentage_Rent_Rate__c != null && objOpp.Percentage_Rent_Rate__c != 0) {
            objOpp.Natural_Threshold__c = (objOpp.Base_Rent__c / objOpp.Percentage_Rent_Rate__c) * 100;
        } else {
            objOpp.Natural_Threshold__c = 0;
        }

        if (String.isEmpty(refreshSource) || refreshSource == 'Promotion_Contribution_Percent__c') {
            if (objOpp.Promotion_Contribution_Percent__c == 0) {
                objOpp.Promo_Amt_Year_1__c = 0;
            }
        }

        if (!objOpp.New_Auth_Rep_Added__c) {
            objOpp.New_Auth_Rep_Name__c = null;
            objOpp.New_Auth_Rep_Address__c = null;
            objOpp.New_Auth_Rep_Phone1__c = null;
            objOpp.New_Auth_Rep_Phone2__c = null;
            objOpp.New_Auth_Rep_Email__c = null;
        }

        if (!objOpp.New_Leg_Rep_Added__c) {
            objOpp.New_Leg_Rep_Name__c = null;
            objOpp.New_Leg_Rep_Address__c = null;
            objOpp.New_Leg_Rep_Phone_1__c = null;
            objOpp.New_Leg_Rep_Phone_2__c = null;
            objOpp.New_Leg_Rep_Email__c = null;
        }

        if (!objOpp.Lease_Incentive__c) {
            objOpp.Lease_Incentive_Days__c = null;
            objOpp.Lease_Incentive_Amount__c = null;
        }

        if (!objOpp.Is_Taking_Existing_Fitout__c) {
            objOpp.Existing_Fitout_Taken_Over_By_Tenant__c = null;
        }

        if (!objOpp.Refurbishment_Contribution__c) {
            objOpp.Refurbishment_Contribution_Amount__c = null;
            if (isWAPerronUnit) {
                objOpp.LON066_NTSD__c = null; // If the unit is a WA Perron one then we also clear the NSSC text
            }
        }

        if (!objOpp.Deal_Cancelled__c) {
            objOpp.Deal_Closure_Reason__c = null;
        }

        if (!objOpp.Car_park_exclusive_for_tenant__c) {
            objOpp.Number_of_exclusive_car_parks__c = null;
            objOpp.Car_park_fee_amount__c = null;
            objOpp.Car_park_signage_by_tenant__c = false;
        }

        if (!objOpp.Opening_Promotion__c) {
            objOpp.Opening_Promotion_Amount__c = null;
        }

        //if(!objOpp.Design_Review_Fees_At_Commencement__c){
        //    objOpp.Design_Review_Fees_During_Term__c = false;
        //}

        if (!objOpp.Seating_Licence__c) {
            objOpp.Seating_License_Area__c = null;
        }

        if (!objOpp.Storage__c) {
            objOpp.Area_of_Storage__c = null;
        }
        /*
		if(String.isEmpty(refreshSource) ||  refreshSource == 'Rent_Advance__c'){
		if(objOpp.Rent_Advance__c != null && objOpp.Rent_Advance__c !=0){
		objOpp.Rent_Advance__c = objOpp.Rent_Advance__c.setScale(2);
		}
		}
		*/
        if (objOpp.Surrender_other_premises_Date_Options__c != 'Fixed Date') {
            objOpp.Surrender_other_premises_Date__c = null;
        }

        if (objOpp.Surrender_these_premises_Date_Options__c != 'Fixed Date') {
            objOpp.Surrender_these_premises_Date__c = null;
        }

        if (!objOpp.Design_Review_Fees_At_Commencement__c && !objOpp.Design_Review_Fees_During_Term__c) {
            objOpp.Design_Review_Fees_Rate_at_commencement__c = null;
        }

        // NITIN
        /*if (!objOpp.Hoarding_At_Commencement__c && !objOpp.Hoarding_Development_Unit__c && !objOpp.Hoarding_During_End_Term__c && !objOpp.Hoardings_Capped_at_Commencement__c && !objopp.Hoarding_at_commencement_50_Split__c) {
            objOpp.Hoarding_Rate_at_Commencement__c = null;
        }*/

        if (!objOpp.Hoarding_At_Commencement__c && !objOpp.Hoarding_Development_Unit__c && !objOpp.Hoarding_During_End_Term__c) {
            objOpp.Hoarding_Rate_at_Commencement__c = null;
        }

        if (objOpp.Development_Unit__c == true && objOpp.Hoarding_At_Commencement__c == true) {
            objOpp.Hoarding_Development_Unit__c = false;
        }

        if (objOpp.Development_Unit__c == true) {
            // Commented below line out due to VMS-26 - Not Setting Hoarding Development to true automatically. It can be unchecked
            //objOpp.Hoarding_Development_Unit__c = true;
            objOpp.Hoarding_At_Commencement__c = false;
        } else {
            objOpp.Hoarding_Development_Unit__c = false;
        }

        if (objOpp.Recovery_Type__c == 'Gross') {
            objOpp.Promo_Review_Rate_and_Type__c = null;
        }

        if (String.isEmpty(refreshSource) || (refreshSource == 'Estimated_Lease_Commencement_Date__c' || refreshSource == 'Estimated_Handover_Date__c' || refreshSource == 'Fit_out_Period__c')) {
            if (objOpp.Deal_Type__c == 'New Tenant Standard' && objOpp.Development_Unit__c
                    ) {
                objOpp.Estimated_Lease_Commencement_Date__c = objOpp.Estimated_Handover_Date__c;
                objOpp.Estimated_Rent_Commencement_Date__c = objOpp.Estimated_Lease_Commencement_Date__c;

                if (objOpp.Fit_out_Period__c != null && objOpp.Fit_out_Period__c != 0) {
                    objOpp.Estimated_Lease_Commencement_Date__c = (objOpp.Estimated_Lease_Commencement_Date__c != null)
                            ? objOpp.Estimated_Lease_Commencement_Date__c.addDays(Integer.valueOf(objOpp.Fit_out_Period__c)) : null;
                    objOpp.Estimated_Rent_Commencement_Date__c = (objOpp.Estimated_Rent_Commencement_Date__c != null)
                            ? objOpp.Estimated_Rent_Commencement_Date__c.addDays(Integer.valueOf(objOpp.Fit_out_Period__c)) : null;
                }
            }

            if (objOpp.Deal_Type__c == 'New Tenant Standard' && !objOpp.Development_Unit__c) {
                objOpp.Estimated_Lease_Commencement_Date__c = objOpp.Estimated_Handover_Date__c;
                objOpp.Estimated_Rent_Commencement_Date__c = objOpp.Estimated_Lease_Commencement_Date__c;

                if (objOpp.Fit_out_Period__c != null && objOpp.Fit_out_Period__c != 0) {
                    objOpp.Estimated_Rent_Commencement_Date__c = (objOpp.Estimated_Rent_Commencement_Date__c != null)
                            ? objOpp.Estimated_Rent_Commencement_Date__c.addDays(Integer.valueOf(objOpp.Fit_out_Period__c)) : null;
                }
            }

            if (objOpp.Deal_Type__c == 'New Tenant As Is') {
                objOpp.Estimated_Rent_Commencement_Date__c = objOpp.Estimated_Lease_Commencement_Date__c;
            }

            if (objOpp.Deal_Type__c == 'Renewal') {
                objOpp.Estimated_Rent_Commencement_Date__c = objOpp.Estimated_Lease_Commencement_Date__c;
            }


        }

        //VMS-44
        if (refreshSource == 'Estimated_Handover_Date__c') {
            if (objOpp.Deal_Type__c == 'New Tenant Standard' || objOpp.Deal_Type__c == 'New Tenant As Is') {
                objOpp.LON037_Vacant_Possession_Date__c = objOpp.Estimated_Handover_Date__c.addDays(-1);
            }
        }

        System.debug('xxx  LON037_Vacant_Possession_Date__c - ' + objOpp.LON037_Vacant_Possession_Date__c);

        if (exsistingCommDate == null) {
            exsistingCommDate = objOpp.Estimated_Lease_Commencement_Date__c;
        }

        if ((objOpp.Estimated_Lease_Commencement_Date__c != null && objOpp.Recovery_Type__c == 'Net') &&
                ((dealsCommon.getFiscalYear(exsistingCommDate) != dealsCommon.getFiscalYear(objOpp.Estimated_Lease_Commencement_Date__c)) ||
                        refreshSource == 'Area_of_premises_sqmt__c' || refreshSource == 'Recovery_Type__c' || refreshSource == 'Retail_Act_Applies__c' ||
                        refreshSource == 'Fit_out_Period__c' || refreshSource == 'Estimated_Handover_Date__c' || objOpp.Outgoings_Rate__c == null)) {
            objOpp.Outgoings_Rate__c = dealsCommon.calculateOutgoings();

            if ((objOpp.Outgoings_Rate__c == null || objOpp.Outgoings_Rate__c == 0)
                    && objOpp.Estimated_Lease_Commencement_Date__c != null && objOpp.Recovery_Type__c == 'Net'
                    && objOpp.Retail_Act_Applies__c != null) {
                objOpp.Custom_Outgoings__c = true;
            } else {
                objOpp.Custom_Outgoings__c = false;
            }

            exsistingCommDate = null;
        }

        if ((objOpp.Estimated_Lease_Commencement_Date__c != null && objOpp.Recovery_Type__c == 'Net' && objOpp.Retail_Act_Applies__c != null) &&
                ((dealsCommon.getFiscalYear(exsistingCommDate) != dealsCommon.getFiscalYear(objOpp.Estimated_Lease_Commencement_Date__c)) ||
                        refreshSource == 'Area_of_premises_sqmt__c' || refreshSource == 'Estimated_Handover_Date__c' || refreshSource == 'Recovery_Type__c' || refreshSource == 'Fit_out_Period__c' ||
                        objOpp.Rates_and_Taxes_Amount__c == null)) {

            objOpp.Rates_and_Taxes_Amount__c = dealsCommon.calculateRatesAndTaxes();

            if ((objOpp.Rates_and_Taxes_Amount__c == null || objOpp.Rates_and_Taxes_Amount__c == 0)
                    && (objOpp.Unit__r.Building__r.Centre__r.State__c == 'VIC' || objOpp.Unit__r.Building__r.Centre__r.Name == 'Northgate')
                    && objOpp.Estimated_Lease_Commencement_Date__c != null && objOpp.Recovery_Type__c == 'Net') {
                objOpp.Custom_Ratestaxes__c = true;
            } else {
                objOpp.Custom_Ratestaxes__c = false;
            }

            if (refreshSource == 'Area_of_premises_sqmt__c') {
                objOpp.Custom_Ratestaxes__c = true;
            }

            exsistingCommDate = null;
        }

        if (objOpp.Recovery_Type__c == 'Net') { // Clearing Base/Gross Rent
            objOpp.Gross_Rent__c = null;
        } else {
            objOpp.Base_Rent__c = null;
        }

        if (objOpp.Estimated_Lease_Commencement_Date__c != null &&
                objOpp.Lease_Incentive_Days__c != null &&
                (refreshSource == 'Base_Rent__c' || refreshSource == 'Gross_Rent__c' || refreshSource == 'Outgoings_Rate__c' || refreshSource == 'Custom_Outgoings__c'
                        || refreshSource == 'Promo_Amt_Year_1__c' || refreshSource == 'Rates_and_Taxes_Amount__c' || refreshSource == 'Custom_RatesTaxes__c' || refreshSource == 'Area_of_premises_sqmt__c'
                        || refreshSource == 'Estimated_Lease_Commencement_Date__c' || refreshSource == 'Lease_Incentive_Days__c' || objOpp.Lease_Incentive_Amount__c == null)) {
            objOpp.Lease_Incentive_Amount__c = calculateLeaseIncentiveAmount();
        }

        if (objOpp.Recovery_Type__c == 'Gross') { // Override Outs/Rates
            objOpp.Custom_Outgoings__c = false;
            objOpp.Custom_Ratestaxes__c = false;

            objOpp.Outgoings_Rate__c = 0;
            objOpp.Rates_and_Taxes_Amount__c = 0;
        }

        if (objOpp.Unit__r.Unit_Code__c == '40OFF') {
            objOpp.Promo_Amt_Year_1__c = 0;
            objOpp.Year_1_Sales_Estimate__c = 0;
        }

        if (objOpp.Unit__r.Unit_Code__c == '45ATM' || objOpp.Unit__r.Unit_Code__c == '40OFF') {
            objOpp.Percentage_Rent_Rate__c = 0;
        }

        if (UserInfo.getUiThemeDisplayed() == 'Theme4t') { // For mobile
            objOpp.Non_Standard_Special_Conditions__c = null;
            for (String i : SpecialCons) {
                if (objOpp.Non_Standard_Special_Conditions__c != null) {
                    objOpp.Non_Standard_Special_Conditions__c += ';' + i ;
                } else {
                    objOpp.Non_Standard_Special_Conditions__c = i;
                }
            }
        }

        specialConditionHelper.setSpecialConditions(objOpp, refreshSource, isWAPerronUnit);

        setLADApproved();

        //------ Load special conditions into mobile picklist
        SpecialCons.clear();
        if (objOpp.Non_Standard_Special_Conditions__c != null) {
            List<String> spConValues = objOpp.Non_Standard_Special_Conditions__c.split(';');
            for (String i : spConValues) {
                SpecialCons.add(i);
            }
        }

        refreshSource = null;
    }

    public Decimal calculateLeaseIncentiveAmount() {
        return ((((objOpp.Recovery_Type__c == 'Net' ? (objOpp.Base_Rent__c != null ? objOpp.Base_Rent__c : 0)
                : (objOpp.Gross_Rent__c != null ? objOpp.Gross_Rent__c : 0))
                + (objOpp.Promo_Amt_Year_1__c != null ? objOpp.Promo_Amt_Year_1__c : 0)
                + (objOpp.Outgoings_Rate__c != null ? objOpp.Outgoings_Rate__c : 0)
                + (objOpp.Rates_and_Taxes_Amount__c != null ? objOpp.Rates_and_Taxes_Amount__c : 0)
        ) / daysInYear(objOpp.Estimated_Lease_Commencement_Date__c))
                * objOpp.Lease_Incentive_Days__c);
    }

    public Integer daysInYear(Date input) {
        return Date.isLeapYear(input.year()) ? 366 : 365;
    }

    public PageReference pageReload() {
        String hostURL = URL.getSalesforceBaseUrl().toExternalForm();
        String serverId = hostURL.substring(10, 14);
        serverId = serverId.replace('.', '');
        //String finalURL = serverId.trim(); // Variable never used
        Pagereference pRef = new PageReference(Global_Settings__c.getInstance().Base_URL__c + '/one/one.app#/sObject/' + objOpp.Id + '/view');
        pRef.setRedirect(false);
        return pRef;
    }

    // Associating selected authorised representatives
    public void setReps() {
        String authReps = selectedauthrep;
        if (String.isNotEmpty(selectedauthrep)) {
            authReps = authReps.replace('[', '');
            authReps = authReps.replace(']', '');
            authReps = authReps.replace(', ', ';');
            authReps += ';';
        }

        if (objOpp.Authorised_Reps__c != null) {
            string[] exReps = objOpp.Authorised_Reps__c.split(';');
            extAuthRepIds.remove(exReps[0]);
        }

        objOpp.Authorised_Reps__c = authReps;
        getExistingReps();
    }

    // Deleting unselected authorised representatives
    public void delReps() {
        String authReps = unselectauthrep;
        if (String.isNotEmpty(unselectauthrep)) {
            authReps = authReps.replace('[', '');
            authReps = authReps.replace(']', '');
            authReps = authReps.replace(', ', ';');
            authReps += ';';
        }

        if (authReps != null) {
            string repId = authReps;
            string[] repIds = repId.split(';');

            for (String s : repIds) {
                objOpp.Authorised_Reps__c = objOpp.Authorised_Reps__c.replace(s + ';', '');
                objOpp.Authorised_Reps__c = objOpp.Authorised_Reps__c.trim();
                extAuthRepIds.remove(s);
            }
        }
    }

    // Associating selected billing representatives
    public void setBillReps() {
        String billReps = selectedbillrep;
        if (String.isNotEmpty(selectedbillrep)) {
            billReps = billReps.replace('[', '');
            billReps = billReps.replace(']', '');
            billReps = billReps.replace(', ', ';');
            billReps += ';';
        }

        if (objOpp.Billing_Reps__c != null) {
            string[] exReps = objOpp.Billing_Reps__c.split(';');
            extBillRepIds.remove(exReps[0]);
        }

        objOpp.Billing_Reps__c = billReps;

        getExistingReps();
    }

    // Deleting unselected billing representatives
    public void delBillReps() {
        String billReps = unselectbillrep;
        if (String.isNotEmpty(unselectbillrep)) {
            billReps = billReps.replace('[', '');
            billReps = billReps.replace(']', '');
            billReps = billReps.replace(', ', ';');
            billReps += ';';
        }

        if (billReps != null) {
            string repId = billReps;
            string[] repIds = repId.split(';');

            for (String s : repIds) {
                objOpp.Billing_Reps__c = objOpp.Billing_Reps__c.replace(s + ';', '');
                objOpp.Billing_Reps__c = objOpp.Billing_Reps__c.trim();
                extBillRepIds.remove(s);
            }
        }
    }

    // Associating selected guarantor representatives
    public void setGuarReps() {
        String guarReps = selectedguarrep;
        if (String.isNotEmpty(selectedguarrep)) {
            guarReps = guarReps.replace('[', '');
            guarReps = guarReps.replace(']', '');
            guarReps = guarReps.replace(', ', ';');
            guarReps += ';';
        }

        if (objOpp.Guarantor_Reps__c != null){
            objOpp.Guarantor_Reps__c = objOpp.Guarantor_Reps__c + guarReps;
        }else{
            objOpp.Guarantor_Reps__c = guarReps;
        }

        getExistingReps();
    }

    // Deleting unselected guarantor representatives
    public void delGuarReps() {
        String guarReps = unselectguarrep;
        if (String.isNotEmpty(unselectguarrep)) {
            guarReps = guarReps.replace('[', '');
            guarReps = guarReps.replace(']', '');
            guarReps = guarReps.replace(', ', ';');
            guarReps += ';';
        }

        if (guarReps != null) {
            string repId = guarReps;
            string[] repIds = repId.split(';');

            for (String s : repIds) {
                objOpp.Guarantor_Reps__c = objOpp.Guarantor_Reps__c.replace(s + ';', '');
                objOpp.Guarantor_Reps__c = objOpp.Guarantor_Reps__c.trim();
                extGuarRepIds.remove(s);
            }
        }
    }

    // Associating selected legal representatives
    public void setlegalReps() {
        String legalReps = selectedlegrep;
        if (String.isNotEmpty(selectedlegrep)) {
            legalReps = legalReps.replace('[', '');
            legalReps = legalReps.replace(']', '');
            legalReps = legalReps.replace(', ', ';');
            legalReps += ';';
        }

        if (objOpp.Legal_Reps__c != null) {
            string[] exReps = objOpp.Legal_Reps__c.split(';');
            extLegalRepIds.remove(exReps[0]);
        }

        objOpp.Legal_Reps__c = legalReps;

        getExistingReps();
    }

    // Deleting unselected legal representatives
    public void dellegalReps() {
        String legalReps = unselectlegrep;
        if (String.isNotEmpty(unselectlegrep)) {
            legalReps = legalReps.replace('[', '');
            legalReps = legalReps.replace(']', '');
            legalReps = legalReps.replace(', ', ';');
            legalReps += ';';
        }

        if (legalReps != null) {
            string repId = legalReps;
            string[] repIds = repId.split(';');

            for (String s : repIds) {
                objOpp.Legal_Reps__c = objOpp.Legal_Reps__c.replace(s + ';', '');
                objOpp.Legal_Reps__c = objOpp.Legal_Reps__c.trim();
                extLegalRepIds.remove(s);
            }
        }
    }

    // Associating selected notice representatives
    public void setnoticeReps() {
        String noticeReps = selectednoticerep;
        if (String.isNotEmpty(selectednoticerep)) {
            noticeReps = noticeReps.replace('[', '');
            noticeReps = noticeReps.replace(']', '');
            noticeReps = noticeReps.replace(', ', ';');
            noticeReps += ';';
        }

        if (objOpp.Notice_Reps__c != null) {
            string[] exReps = objOpp.Notice_Reps__c.split(';');
            extNoticeRepIds.remove(exReps[0]);
        }

        objOpp.Notice_Reps__c = noticeReps;

        getExistingReps();
    }

    // Deleting unselected notice representatives
    public void delnoticeReps() {
        String noticeReps = unselectnoticerep;
        if (String.isNotEmpty(unselectnoticerep)) {
            noticeReps = noticeReps.replace('[', '');
            noticeReps = noticeReps.replace(']', '');
            noticeReps = noticeReps.replace(', ', ';');
            noticeReps += ';';
        }

        if (noticeReps != null) {
            string repId = noticeReps;
            string[] repIds = repId.split(';');

            for (String s : repIds) {
                objOpp.Notice_Reps__c = objOpp.Notice_Reps__c.replace(s + ';', '');
                objOpp.Notice_Reps__c = objOpp.Notice_Reps__c.trim();
                extNoticeRepIds.remove(s);
            }
        }
    }

    // Associating selected registration representatives
    public void setregReps() {
        String regReps = selectedregrep;
        if (String.isNotEmpty(selectedregrep)) {
            regReps = regReps.replace('[', '');
            regReps = regReps.replace(']', '');
            regReps = regReps.replace(', ', ';');
            regReps += ';';
        }

        if (objOpp.Registration_Reps__c != null) {
            string[] exReps = objOpp.Registration_Reps__c.split(';');
            extRegRepIds.remove(exReps[0]);
        }

        objOpp.Registration_Reps__c = regReps;

        getExistingReps();
    }

    // Deleting unselected registration representatives
    public void delregReps() {
        String regReps = unselectregrep;
        if (String.isNotEmpty(unselectregrep)) {
            regReps = regReps.replace('[', '');
            regReps = regReps.replace(']', '');
            regReps = regReps.replace(', ', ';');
            regReps += ';';
        }

        if (regReps != null) {
            string repId = regReps;
            string[] repIds = repId.split(';');

            for (String s : repIds) {
                objOpp.Registration_Reps__c = objOpp.Registration_Reps__c.replace(s + ';', '');
                objOpp.Registration_Reps__c = objOpp.Registration_Reps__c.trim();
                extRegRepIds.remove(s);
            }
        }
    }

    public void getExistingReps() {
        // Authorised
        if (objOpp.Authorised_Reps__c != null) {
            string repId = objOpp.Authorised_Reps__c;
            string[] repIds = repId.split(';');

            for (String s : repIds) {
                extAuthRepIds.add(s);
            }
        }

        // Billing
        if (objOpp.Billing_Reps__c != null) {
            string repId = objOpp.Billing_Reps__c;
            string[] repIds = repId.split(';');

            for (String s : repIds) {
                extBillRepIds.add(s);
            }
        }

        // Guarantor
        if (objOpp.Guarantor_Reps__c != null) {
            string repId = objOpp.Guarantor_Reps__c;
            string[] repIds = repId.split(';');

            for (String s : repIds) {
                extGuarRepIds.add(s);
            }
        }

        // Legal
        if (objOpp.Legal_Reps__c != null) {
            string repId = objOpp.Legal_Reps__c;
            string[] repIds = repId.split(';');

            for (String s : repIds) {
                extLegalRepIds.add(s);
            }
        }

        // Notice
        if (objOpp.Notice_Reps__c != null) {
            string repId = objOpp.Notice_Reps__c;
            string[] repIds = repId.split(';');

            for (String s : repIds) {
                extNoticeRepIds.add(s);
            }
        }

        // Registered
        if (objOpp.Registration_Reps__c != null) {
            string repId = objOpp.Registration_Reps__c;
            string[] repIds = repId.split(';');

            for (String s : repIds) {
                extRegRepIds.add(s);
            }
        }
    }

    //Cancel Deal
    public void cancelDeal() {
        objOpp.Deal_Cancelled__c = true;
        objOpp.StageName = 'Deal Not Proceeding';
        objOpp.CloseDate = System.today();
        saveDeal();
        clearPreferredTenant(objOpp.Id);
        //pageReload();
        //IsEditable = false;
    }

    //Send ECM Document Request
    public void sendECMDocRequest() {
        ECMConnector ecmConnector = new ECMConnector(objOpp);

        if (!checkEOI()) {


            ApexPages.getMessages().clear();
            if (ecmConnector.sendRequest(ecmConnector.getToken())) {
                eoiGenerated = true;
                errMsgITL = false;
            } else {
                eoiGenerated = false;
                errMsgITL = true;
                for (String e : ecmConnector.errors) {
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, e);
                    ApexPages.addMessage(myMsg);
                }
            }
        }

        // mimicking the send below - just delete when done testing
        //generateEOI(objOpp.Id);

    }

    //Generate LON
    public void generateLON() {
        requeryApiFieds();

        JDEConnector jdec = new JDEConnector(objOpp);

        if (!objOpp.LON_Pending__c) {
            if (!checkLON()) {
                ApexPages.getMessages().clear();
                objOpp.LON_Pending__c = true;
                objOpp.LON_Generated__c = true;
                IsEditable = false;
                if (jdec.sendRequest(jdec.getToken(), 'O')) {
                    //if(true){
                    errMsg = false;
                    lonGenerated = true;

                    update objOpp;
                } else {
                    lonGenerated = false;
                    errMsg = true;
                    for (String e : jdec.errors) {
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, e);
                        ApexPages.addMessage(myMsg);
                    }
                }
            }
        } else {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'LON Generation Error');
            ApexPages.addMessage(myMsg);
            lonGenerated = false;
            errMsg = true;
        }
    }

    //Re-generate LON
    public void regenerateLON() {
        requeryApiFieds();

        JDEConnector jdec = new JDEConnector(objOpp);

        if (objOpp.Process_Status__c == 'Tenants LO Received') {
            if (!checkLON()) {
                ApexPages.getMessages().clear();
                objOpp.LON_Pending__c = true;
                objOpp.LON_Regenerated__c = true;
                IsEditable = false;
                if (jdec.sendRequest(jdec.getToken(), objOpp.LON_Regeneration_Type__c)) {
                    //if(true){
                    errMsg = false;
                    lonGenerated = true;
                    update objOpp;
                } else {
                    lonGenerated = false;
                    errMsg = true;
                    for (String e : jdec.errors) {
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, e);
                        ApexPages.addMessage(myMsg);
                    }
                }
            }
        } else {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'LON Re-generation Error');
            ApexPages.addMessage(myMsg);
            lonGenerated = false;
            errMsg = true;
        }

    }

    // Redirects to list view
    public PageReference customCancel() {
        String hostURL = URL.getSalesforceBaseUrl().toExternalForm();
        String serverId = hostURL.substring(10, 14);
        serverId = serverId.replace('.', '');
        //String finalURL = serverId.trim(); // Variable never used
        //Pagereference pRef = new PageReference('https://' + finalURL +'.lightning.force.com/one/one.app#/sObject/Opportunity/list');
        Pagereference pRef = new PageReference(Global_Settings__c.getInstance().Base_URL__c + '/one/one.app#/sObject/Opportunity/list');
        pRef.setRedirect(false);
        return pRef;
    }

    public void refreshTenantProfile() {
        LiveTenantProfile ltp = new LiveTenantProfile(objOpp);
        String token = !Test.isRunningTest() ? ltp.getToken() : 'TESTTOKEN'; //Get the API token

        if (Test.isRunningTest() || (ltp.updateDeal(ltp.getTenantProfile(token)) && validator.validateTenantProfile(objOpp))) {
            pageReload();
        } else {
            errMsg = true;
            errMsgITL = true;

            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Tenant Profile Update Error');
            ApexPages.addMessage(myMsg);

            ErrorLogHandler.log('Tenant profile update error', String.valueOf(objOpp));
        }
    }

    //Get exsisting special conditions for multiselect
    public List<SelectOption> getSpecialConsList() {
        List<SelectOption> options = new List<SelectOption>();

        Schema.DescribeFieldResult fieldResult =
                Opportunity.Non_Standard_Special_Conditions__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();

        for (Schema.PicklistEntry f : ple) {
            options.add(new SelectOption(f.getValue(), f.getLabel()));
            specialConValueMap.put(f.getValue(), f.getLabel());
            specialConLabelMap.put(f.getLabel(), f.getValue());
        }
        return options;
    }

    //Get exsisting fitouts for multiselect
    public List<SelectOption> getExistingFitoutList() {
        List<SelectOption> options = new List<SelectOption>();

        Schema.DescribeFieldResult fieldResult =
                Opportunity.Existing_Fitout_Taken_Over_By_Tenant__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();

        for (Schema.PicklistEntry f : ple) {
            options.add(new SelectOption(f.getValue(), f.getLabel()));
        }
        return options;
    }

    //Get Selected Special Conditions
    public Set<String> selectedSpCons {
        get {
            getSpecialConsList();
            Set<String> tempSpCons = new Set<String>();

            if (objOpp.Non_Standard_Special_Conditions__c != null) {
                String[] sPConIds = objOpp.Non_Standard_Special_Conditions__c.split(';');

                for (String sp : sPConIds) {
                    //tempSpCons.add(sp);
                    tempSpCons.add(specialConValueMap.get(sp));
                }
            }
            return tempSpCons;
        }
    }

    @RemoteAction
    public static List<Unit__c> queryUnits(String keyword, String buildingId) {
        List<Unit__c> unitsList = new List<Unit__c>();
        String keywordFront;
        if (keyword != null && keyword.trim() != '') {
            keywordFront = keyword + '%';
            keyword = '%' + keyword + '%';
            unitsList = [
                    SELECT Id, Name
                    FROM Unit__c
                    WHERE Building__c = :buildingId AND Name LIKE :keywordFront
                    LIMIT 50
            ];
        }
        return unitsList;
    }

    //Add new non std special condition
    public void addNSSpecialCon() {
        update nSSpecialCons;

        Non_Standard_Special_Conditions__c nssc = new Non_Standard_Special_Conditions__c();
        nssc.Deal__c = objOpp.Id;
        insert nssc;

        getSpecialCons(objOpp.Id);

        objOpp.LAD_Approved__c = false;
        update objOpp;
    }

    //Remove non std special condition
    public void removeNSSpecialCon() {

        // set refresh source here. It seems to be dropping it after the first remove button is clicked.
        if (refreshSource == null) {
            refreshSource = 'Non_Standard_Special_Conditions';
        }

        update nSSpecialCons;

        delete [SELECT Name, Id FROM Non_Standard_Special_Conditions__c WHERE Id = :nsscId];

        getSpecialCons(objOpp.Id);

        refreshField();

        update objOpp;
    }

    //Get permitted use list
    public List<SelectOption> permittedUseList {
        get {
            List<SelectOption> pUse = new List<SelectOption>();
            pUse.add(new SelectOption('', '--None--'));
            for (UDC_Codes__c o : [
                    SELECT Id, Name, Category_Code__c,
                            Code_Notes__c, Code_Type__c,
                            Code_Type_Description__c, Code_Value__c
                    FROM UDC_Codes__c
                    WHERE Category_Code__c = '1-PU'
                    ORDER BY Name
            ]) {
                pUse.add(new SelectOption(o.Id, o.Name));
            }

            return pUse;
        }
    }

    //ECM Link Wrapper
    public class EcmLink {
        public String title;
        public String link;
    }

    public void recreateTDP() {
        errMsg = false;
        errString = null;
        validator.errorMsgs.clear();

        LiveTenantProfile ltp = new LiveTenantProfile(objOpp);
        JDEConnector jdec = new JDEConnector(objOpp);
        String token = !Test.isRunningTest() ? ltp.getToken() : 'TESTTOKEN'; //Get the API token

        if (objOpp.Existing_Retailer__c) { //Create TDP
            if (jdec.sendRequest(token, 'S') || Test.isRunningTest()) {
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
                System.debug('TDP Created');
            } else {
                errMsg = true;
                errString = 'Error occurred while creating the TDP. Please contact the administrator. ';
                if (jdec.errors != null && jdec.errors.size() > 0) {
                    errString += 'Reason - ';

                    for (String e : jdec.errors) {
                        errString += e;
                    }
                }

                ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.Severity.ERROR, errString);
                ApexPages.addMessage(errorMessage);

                System.debug('TDP Error String - ' + errString);
            }
        }
    }
}