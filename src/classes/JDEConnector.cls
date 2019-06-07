public with sharing class JDEConnector {
    public Opportunity deal{get;set;}
    public List<String> errors {get; set;}

    public JDEConnector(Opportunity deal){
        this.deal = deal;
        errors = new List<String>();
    }

    public Boolean hasRedirect(HttpResponse res) {
        System.debug('HTTP status code: ' + res.getStatusCode());
        if (res.getStatusCode() >= 300 && res.getStatusCode() <= 307 && res.getStatusCode() != 306) {
            String loc = res.getHeader('Location');
            if (loc != null) {
                System.debug('has redirect: ' + loc);
                return true;
            }
        }
        return false;
    }

    public HttpResponse handleRedirect(HttpRequest req, HttpResponse res) {
        req.setEndpoint(res.getHeader('Location'));

        System.debug('request 2 -- '+req.getBody());
        System.debug('request 2 -- '+req.toString());

        Http http = new Http();
        HttpResponse response = http.send(req);

        return response;
    }

    public String getToken() {
        HttpRequest request = new HttpRequest();
        request.setMethod('POST');
        request.setEndpoint('callout:Vicinity_Apigee_Prod');
        request.setHeader('Content-Length', '0');
        request.setTimeout(100000);

        Http http = new Http();
        HttpResponse response = http.send(request);
        Map<String, Object> jsonResponse = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
        return String.valueOf(jsonResponse.get('access_token'));
    }

    public Boolean sendRequest(String token, String generationtype){
        Boolean returnStatus = false;

        try{
            HttpRequest request = new HttpRequest();
            request.setMethod('PUT');
            request.setHeader('Authorization', 'Bearer ' + token);
            if(generationtype == 'S'){
                request.setEndpoint(Global_Settings__c.getInstance().API_URL_1__c+'/createtdp');
            }else {
                request.setEndpoint(Global_Settings__c.getInstance().API_URL_1__c+'/createlon');
            }

            request.setTimeout(100000);
            request.setBody(generateLonJSON(generationtype));
            request.setHeader('Content-Type', 'application/json');

            System.debug('request 1 -- '+request.getBody());
            System.debug('request 1 -- '+request.toString());

            Http http = new Http();
            HttpResponse response = http.send(request);

            System.debug('response 1 -- '+response.getBody());
            System.debug('response 1 -- '+response.toString());

            if (hasRedirect(response)) {
                response = handleRedirect(request,response);
            }

            System.debug('response 2 -- '+response.getBody());
            System.debug('response 2 -- '+response.toString());

            ApiResonse apiResponse = (ApiResonse) System.JSON.deserialize(String.valueOf(response.getBody()), ApiResonse.class);
            //if(apiResponse.status !=null && !Boolean.valueOf(apiResponse.status) && apiResponse.message !=null){
            if(apiResponse.status !=null && apiResponse.status == 'error' && apiResponse.reason !=null){
                /*for(String error : apiResponse.message){
                    errors.add(error);
                }*/
                errors.add(apiResponse.reason);
            }

            //System.debug('API Response Status - ' + apiResponse.status);
            //System.debug('API Response Message - ' + apiResponse.message);


            ErrorLogHandler.log('JDE.Connector.Request',String.valueOf(request.getBody().left(131000)), apiResponse.deal_key);
            ErrorLogHandler.log('JDE.Connector.Response',String.valueOf(response.getBody().left(131000)), apiResponse.deal_key);
            System.debug('JDECONNECTOR REQUEST -'+String.valueOf(request.getBody()));
            System.debug('JDECONNECTOR RESPONSE -'+String.valueOf(response.getBody()));


            returnStatus = Boolean.valueOf(apiResponse.status);
        }catch(exception ex){
            ErrorLogHandler.log('JDE.Connector.Exception' ,ex);
        }

        return returnStatus;
    }

    /* Stuart Donnachie - Not being used in code currently - commenting it out
        public Map<String, String> percentageRentCategoryMap{
        get{
            Map<String, String> tempMap = new Map<String, String> ();
            tempMap.put('Banks/ATMs','BANK');
            tempMap.put('Specialty Food/Cafes','CAFE');
            tempMap.put('Charities','CHAR');
            tempMap.put('Fresh Food','FOOD');
            tempMap.put('Government Services','GOVSRV');
            tempMap.put('Liquor','LIQUOR');
            tempMap.put('Pharmacies','PHARM');
            tempMap.put('Restaurants (250 sqm+)','REST');
            tempMap.put('General Retail','RETAIL');
            tempMap.put('Other Services','SERV');
            tempMap.put('Tatts and Travel Agents','TATTRV');
            tempMap.put('Tobacconists','TOBACC');
            return tempMap;
        }
    }*/

    public Map<String, String> rentReviewTypeMap{
        get{
            Map<String, String> tempMap = new Map<String, String> ();
            tempMap.put('Fixed','01');
            tempMap.put('Market','02');
            tempMap.put('CPI','03');
            tempMap.put('Non Standard','04');
            tempMap.put('Not Applicable','NA');

            return tempMap;
        }
    }

    public Map<String, String> promoReviewTypeMap{
        get{
            Map<String, String> tempMap = new Map<String, String> ();
            tempMap.put('Fixed','01');
            tempMap.put('Non Standard','02');
            tempMap.put('Not Applicable','03');
            tempMap.put('Other','NA');

            return tempMap;
        }
    }

    public Map<String, String> retailerCatMap{
        get{
            Map<String, String> tempMap = new Map<String, String> ();
            tempMap.put('Iconic','I');
            tempMap.put('Aspirational','A');
            tempMap.put('Base','B');

            return tempMap;
        }
    }

    public Map<String, String> outgoingsTypeMap{
        get{
            Map<String, String> tempMap = new Map<String, String> ();
            tempMap.put('Gross','01');
            tempMap.put('Semi Gross','02');
            tempMap.put('Net','03');
            tempMap.put('Non Standard','04');
            tempMap.put('Gross + Promo','05');

            return tempMap;
        }
    }

    public Map<String, String> recoveryTypeMap{
        get{
            Map<String, String> tempMap = new Map<String, String> ();
            tempMap.put('Gross','01');
            tempMap.put('Semi Gross','02');
            tempMap.put('Net','03');
            tempMap.put('Non Standard','04');
            tempMap.put('Gross + Promo','05');

            return tempMap;
        }
    }

    public Map<String, String> contactTypeMap{
        get{
            Map<String, String> tempMap = new Map<String, String> ();
            tempMap.put('Authorised Representative','A');
            tempMap.put('Billing Representative','B');
            tempMap.put('Gaurantor Representative','G');
            tempMap.put('Legal Representative','L');
            tempMap.put('Registered Representative','R');
            tempMap.put('Notice Representative','Z');

            return tempMap;
        }
    }

    public Map<String, String> bankGuaranteeReqMap{
        get{
            Map<String, String> tempMap = new Map<String, String> ();
            tempMap.put('Existing','E');
            tempMap.put('Yes','Y');
            tempMap.put('Group','G');
            tempMap.put('No','N');

            return tempMap;
        }
    }

    public Map<String, String> jdeDealType{
        get{
            Map<String, String> tempMap = new Map<String, String> ();
            tempMap.put('New Tenant Standard','TS');
            tempMap.put('New Tenant As Is','TA');
            tempMap.put('Renewal','RN');

            return tempMap;
        }
    }

    public List<Non_Standard_Special_Conditions__c> getNSSC(){
        return [SELECT Name, Id, Special_Condition__c FROM Non_Standard_Special_Conditions__c
         WHERE Deal__c = :deal.Id];
    }

    public List<Contact> getContacts(){
        Set<Id> contactIds = new Set<Id>();

        for(OpportunityContactRole oppcon : [SELECT Id,ContactId,OpportunityId FROM OpportunityContactRole
            WHERE OpportunityId = :deal.Id]){
             contactIds.add(oppcon.ContactId);
         }

        return [SELECT Name, Id, Whos_Who_Line_Number__c, Contact_Code__c,Tenant_Rep_Type__c, Account.Tenant_CABID__c
        FROM Contact WHERE Id IN :contactIds];
    }

    public Integer leaseTermInMonths{
        get{
            if(deal.Lease_Term_Years__c != null && deal.Lease_Term_Years__c > 0 && deal.Lease_Term_Months__c !=null
            && deal.Lease_Term_Months__c > 0){
                return Integer.valueOf(deal.Lease_Term_Years__c * 12) + Integer.valueOf(deal.Lease_Term_Months__c);
            }else if(deal.Lease_Term_Years__c != null && deal.Lease_Term_Years__c > 0){
                return Integer.valueOf(deal.Lease_Term_Years__c) * 12;
            }else if(deal.Lease_Term_Months__c != null){
                return  Integer.valueOf(deal.Lease_Term_Months__c);
            }else{
                return 0;
            }
        }
    }

    public String generateLonJSON(String generationtype){
        Map<String, Object> tempRecord = new Map<String, Object>();

        List<Object> tempContacts = new List<Object>();
        List<Object> tempSpecialConditions = new List<Object>();

        tempRecord.put('GenerationType', generationtype);
        tempRecord.put('SalesforceId', deal.Deal_Key__c);
        tempRecord.put('RecordId', deal.Id);
        tempRecord.put('Timestamp', System.now());

        Map<String, Object> fieldsToValue = deal.getPopulatedFieldsAsMap();

        System.debug('Deal for LON - ' + String.valueOf(deal));

        //-- TDP Fields
        tempRecord.put('DateBeginningCommitment', (deal.Estimated_Handover_Date__c != null && deal.Deal_Type__c == 'New Tenant Standard') ? formatDate(deal.Estimated_Handover_Date__c)
                                                                                            : formatDate(deal.Estimated_Lease_Commencement_Date__c));
        tempRecord.put('MercuryDealType', jdeDealType.get(deal.Deal_Type__c));
        tempRecord.put('NameAlpha', (deal.Account !=null) ? deal.Account.Name : deal.New_Trading_Name__c);
        tempRecord.put('NameMailing', (deal.Account !=null) ? deal.Account.Tenant_Entity__c : deal.New_Tenant_Entity__c);
        tempRecord.put('TDPJDECostCenter', deal.Unit__r.Building__r.Building_Code__c);
        tempRecord.put('TenantAddressNumber', deal.Account.Tenant_CABID__c);
        tempRecord.put('TDPUnitName', deal.Unit__r.Name);
        tempRecord.put('TDPAddressNumberSalesman', deal.Owner.Address_Number__c);
        tempRecord.put('TDPAddressNumberManager', deal.Owner.Manager.Address_Number__c);
        tempRecord.put('TDPLeaseAdminAddressNumber', deal.Unit__r.Building__r.Centre__r.Lease_Admin__r.Address_Number__c);
        //tempRecord.put('TDPBudgetBaseRentAmount', deal.Unit__r.Budget_Base_Rent_This_FY__c);
        tempRecord.put('TDPDevelopmentBudget', booleanFormatter(deal.Dev_Budget__c));
        tempRecord.put('TDPDevelopment', booleanFormatter(deal.Development_Unit__c));
        tempRecord.put('TDPDevelopmentClauseApplies', booleanFormatter(deal.Dev_Clause__c));
        //tempRecord.put('TDPFitoutContributionBudget', deal.Unit__r.Fitout_Contribution_Budget__c);
        //tempRecord.put('TDPLandlordWorksAmountBudget', deal.Unit__r.Future_Tenant_Landlord_Works_Budget__c);
        tempRecord.put('TDPLessorTextUniqueKeyID', deal.Selected_Landlord__r.Name);
        tempRecord.put('TDPProratedOutgoingsAmount', deal.Outgoings_Rate__c);
        tempRecord.put('TDPBudgetedRecoveryType', recoveryTypeMap.get(deal.Recovery_Type__c));
        tempRecord.put('TDPPLMApprovalRequired', booleanFormatter(deal.PLM_Approval_Required__c));
        tempRecord.put('TDPProratedRatesAndTaxesAmo', deal.Rates_and_Taxes_Amount__c);
        tempRecord.put('TDPReconfiguration', booleanFormatter(deal.Reconfig__c));
        tempRecord.put('TDPSurveyRequiredFlag', booleanFormatter(deal.Survey_Required__c));
        tempRecord.put('TDPTargetRentDate', (deal.Target_Lease_Commencement_Date__c != null ) ? formatDate(deal.Target_Lease_Commencement_Date__c)
        : formatDate(deal.Estimated_Lease_Commencement_Date__c));
        tempRecord.put('TDPLandlordWorksAmountBudget', deal.Landlord_Works_Budget__c);
        tempRecord.put('TDPBudgetBaseRentAmount', deal.Base_Rent_Budget__c);
        tempRecord.put('TDPFitoutContributionBudget', deal.Fitout_Contribution_Budget__c);

        //LON Fields
        tempRecord.put('RelocationClauseFlag', 'Y');
        tempRecord.put('DocumentDate', formatDate(Datetime.now()));
        tempRecord.put('StorageType', deal.Storage_Rate_Type__c);
        tempRecord.put('OptionClauseFlag', booleanFormatter(deal.Non_Standard_Special_Conditions__c != null ? deal.Non_Standard_Special_Conditions__c.contains( 'LON020' ) : null));
        //tempRecord.put('DateBeginningCommitment', (deal.Estimated_Handover_Date__c != null) ? formatDate(deal.Estimated_Handover_Date__c)
        //                                                                                  : formatDate(deal.Estimated_Lease_Commencement_Date__c));
        tempRecord.put('FitoutDays', (deal.Fit_out_Period__c !=null) ? String.valueOf(deal.Fit_out_Period__c).leftPad(3,'0') : null);
        tempRecord.put('TermOfLease', leaseTermInMonths);
        tempRecord.put('BaseRentAmount', (deal.Recovery_Type__c == 'Net') ? deal.Base_Rent__c : deal.Gross_Rent__c);
        tempRecord.put('RentReviewType', rentReviewTypeMap.get(deal.Rent_Review_Rate_And_Type__c));
        tempRecord.put('RentReviewPercentageRate', deal.Rent_Review_Percentage__c);
        tempRecord.put('OutgoingsType', outgoingsTypeMap.get(deal.Recovery_Type__c));
        tempRecord.put('PercentageRentRevenueThr', (deal.Percentage_Rent_Threshold__c =='Artificial') ? deal.Artificial_Threshold_Amount__c : deal.Natural_Threshold__c);
        tempRecord.put('PercentageRent', deal.Percentage_Rent_Category__c);
        tempRecord.put('PromotionContributionPer', deal.Promotion_Contribution_Percent__c);
        tempRecord.put('PromotionContributionAmo', deal.Promo_Amt_Year_1__c);
        tempRecord.put('OpeningPromotionAmount', deal.Opening_Promotion_Amount__c);
        tempRecord.put('RentInAdvanceFlag', deal.Rent_in_Advance_Payable__c);
        tempRecord.put('RentInAdvanceAmount', (deal.Rent_Advance__c > 0 && deal.Rent_Advance__c !=null) ? deal.Rent_Advance__c.setScale(2) : deal.Rent_Advance__c);
        tempRecord.put('HoardingsFlag', deal.Hoardings_Fee_Payable__c);
        tempRecord.put('HoardingsEstAmount', deal.Hoarding_Rate_at_Commencement__c);
        tempRecord.put('DesignReviewFeeFlag', booleanFormatter(deal.Design_Review_Fees_At_Commencement__c));
        tempRecord.put('RentReviewDescription', deal.Rent_Review_Free_Format_Clause__c);
        tempRecord.put('PromotionContribReviewPe', deal.Promo_ReviewRate__c);
        tempRecord.put('PermittedExclusivityFlag', booleanFormatter(deal.Exclusivity_of_Permitted_Use__c));
        tempRecord.put('NumberofTenantCarParks', deal.Number_of_exclusive_car_parks__c);
        tempRecord.put('CommonAreaTradingFlag', booleanFormatter(deal.Non_Standard_Special_Conditions__c != null ? deal.Non_Standard_Special_Conditions__c.contains( 'LON004' ) : null));
        tempRecord.put('TerminationClauseFlag', 'Y');
        tempRecord.put('DemolitionClauseFlag', 'Y');
        tempRecord.put('SenderName', deal.Owner.Name);
        tempRecord.put('SenderTitle', deal.Owner.Title);
        tempRecord.put('SenderMobileNumber', deal.Owner.MobilePhone);
        tempRecord.put('SenderEmailAddressow', deal.Owner.Email);
        tempRecord.put('PermittedUageClause', String.isEmpty(deal.Permitted_Use_Profile__c) && deal.Selected_Permitted_Use__c != null ?
                                                deal.Selected_Permitted_Use__r.Code_Notes__c : deal.Permitted_Use_Profile__c);
        tempRecord.put('SenderPhoneNumber', deal.Owner.Phone);
        tempRecord.put('MercuryDealType', jdeDealType.get(deal.Deal_Type__c));
        tempRecord.put('TermofLeaseYears', deal.Lease_Term_Years__c);
        tempRecord.put('TermofLeaseMonths', deal.Lease_Term_Months__c);
        tempRecord.put('NumberofLeaseDays', deal.Lease_Term_Days__c);
        tempRecord.put('LeasedOccupiedCount', deal.Units_Leased_and_Occupied__c);
        tempRecord.put('LeasedUnoccupiedCount', deal.Units_Leased_and_Unoccupied__c);
        tempRecord.put('UnleasedOccupiedCount', deal.Units_Unleased_and_Occupied__c);
        tempRecord.put('UnleasedUnoccupiedCount', deal.Units_Unleased_and_Unoccupied__c);
        tempRecord.put('OpeningPromotionFlag', booleanFormatter(deal.Opening_Promotion__c));
        tempRecord.put('NationalLeaseFlag', deal.Agreed_National_Lease_Exists__c);
        tempRecord.put('PromotionContribReviewTy', promoReviewTypeMap.get(deal.Promo_Review_Rate_and_Type__c));
        tempRecord.put('RetailActApplies', deal.Retail_Act_Applies__c);
        tempRecord.put('NameAlpha', (deal.Account !=null) ? deal.Account.Name : deal.New_Trading_Name__c);
        tempRecord.put('NameMailing', (deal.Account !=null) ? deal.Account.Tenant_Entity__c : deal.New_Tenant_Entity__c);
        tempRecord.put('TaxIdABN', deal.Account.ABN__c);
        tempRecord.put('TaxId2ACN', deal.Account.Tenant_ACN__c);
        tempRecord.put('PercentageRentPercentage', deal.Percentage_Rent_Rate__c);
        tempRecord.put('ExclusivityAreaZoneRequir', booleanFormatter(deal.Non_Standard_Special_Conditions__c != null ? deal.Non_Standard_Special_Conditions__c.contains( 'LON009' ): null));
        tempRecord.put('WaiverCertificateReceived', booleanFormatter(deal.Waiver_Certificate_Received__c));
        tempRecord.put('WaiverCertificateReqd', booleanFormatter(deal.Waiver_Certificate_Required__c));
        tempRecord.put('DesignReviewFeeAmount', deal.Design_Review_Fees_Rate_at_commencement__c);
        tempRecord.put('DesignReviewRefurbFlag', booleanFormatter(deal.Design_Review_Fees_During_Term__c));
        tempRecord.put('PromotionContribReviewDe', deal.Promo_Contribution_Free_Format_Clause__c);
        tempRecord.put('SecurityAmount', (deal.Bank_Guarantee_Requirement__c == 'Existing') ? deal.Bank_Guarentee__c : deal.Group_Security_Amount__c);
        tempRecord.put('FitoutContributionRequired', booleanFormatter(deal.Fitout_Contribution__c));
        tempRecord.put('FitoutContributionAmount', deal.Fitout_Contribution_Amount__c);
        tempRecord.put('LandlordWorksAmount', deal.Future_Tenant_Landlord_Works_Estimate__c);
        tempRecord.put('BankGuaranteeMonths', deal.Bank_Guarantee_Months__c);
        tempRecord.put('GroupSecurityPercentage', deal.Group_Security_Percentage_Required__c);
        tempRecord.put('BankGuaranteeReqd', bankGuaranteeReqMap.get(deal.Bank_Guarantee_Requirement__c));
        tempRecord.put('GroupSecurityMonths', deal.Group_Security_No_of_Months_Required__c);
        tempRecord.put('NumberofGuarantors', deal.No_of_Personal_Guarantee__c);
        tempRecord.put('TypeofGuarantor', deal.Type_of_Guarantor_Required__c);
        tempRecord.put('Franchisor', deal.Franchisor__c);
        tempRecord.put('LandlordWorksType', deal.ECM_Works_Type__c);
        tempRecord.put('PublicListedCompany', deal.Publicly_Listed_Company__c);
        tempRecord.put('SurrenderClauseNo', deal.LON032_Options__c);
        tempRecord.put('SurrenderOtherClauseNo', deal.LON031_Options__c);
        // We were throwing the checkbox value across when VC were expecting S (Standard). We were sending across Y which was transformed from the True value.
        tempRecord.put('SeatingLicence', (deal.Seating_Licence__c) ? 'S' : '');
        tempRecord.put('SeatingAreaM2', deal.Seating_License_Area__c);
        tempRecord.put('StorageRequired', booleanFormatter(deal.Storage__c));
        tempRecord.put('StorageAreaM2', deal.Area_of_Storage__c);
        tempRecord.put('StorageRatePerM2', deal.Storage_Rate__c);
        tempRecord.put('SubjectToVacantPossession', deal.Subject_to_Vacant_Possession__c);
        //tempRecord.put('CentreUniqueKeyID', deal.Unit__r.Building__r.Centre__r.Centre_Code__c);
        tempRecord.put('CentreUniqueKeyID', '0');
        tempRecord.put('SurrenderThesePremDate', formatDate(deal.Surrender_these_premises_Date__c));
        tempRecord.put('SurrenderOtherPremDate', formatDate(deal.Surrender_other_premises_Date__c));
        tempRecord.put('UnitProposedAreaSqMt', deal.Area_of_premises_sqmt__c);
        tempRecord.put('Refit', booleanFormatter(deal.Refit__c));
        tempRecord.put('ProratedOutgoingsAmount', deal.Outgoings_Rate__c);
        //tempRecord.put('ProratedRatesAndTaxesAmo', deal.Rates_and_Taxes__r.Rate__c);
        tempRecord.put('ProratedRatesAndTaxesAmo', deal.Rates_and_Taxes_Amount__c);
        tempRecord.put('GMLApprovalRequired', 'N');
        tempRecord.put('GMLApprovalObtained', 'N');
        tempRecord.put('HROApprovalRequired', 'N');
        tempRecord.put('HROApprovalObtained', 'N');
        tempRecord.put('PercentageRentThrsType', (deal.Percentage_Rent_Threshold__c == 'Artificial' ? 'A' : 'N'));
        tempRecord.put('ReconfigurationApproved', 'N');
        tempRecord.put('HoardingsFitoutFlag', booleanFormatter(deal.Hoarding_At_Commencement__c));
        tempRecord.put('HoardingsRefurbFlag', booleanFormatter(deal.Hoarding_During_End_Term__c));
        tempRecord.put('HoardingsDevFlag', booleanFormatter(deal.Hoarding_Development_Unit__c));
        tempRecord.put('TenantChecksRequired', booleanFormatter(deal.Tenant_Checks_Required__c));
        tempRecord.put('TenantChecksStarted', deal.Tenant_Checks_Started__c);
        tempRecord.put('CommonOpeningFlag', booleanFormatter(deal.Is_Common_Opening_Date__c));
        tempRecord.put('EarlyRenewal', booleanFormatter(deal.Early_Renewal__c));
        tempRecord.put('FixedRentInAdvance', 'N');
        tempRecord.put('StorageComment', deal.Storage_Comment__c);
        tempRecord.put('ContractUniqueKeyID', deal.Unit__r.Building__r.Centre__r.Contract_Number__c);
        tempRecord.put('RentCommencementDate', formatDate(deal.Estimated_Rent_Commencement_Date__c));
        tempRecord.put('RefurbContributionRequired', booleanFormatter(deal.Refurbishment_Contribution__c));
        tempRecord.put('RefurbishmentContributio', deal.Refurbishment_Contribution_Amount__c);
        tempRecord.put('LeaseIncentiveRequired', booleanFormatter(deal.Lease_Incentive__c));
        tempRecord.put('LeaseIncentiveAmount', deal.Lease_Incentive_Amount__c);
        tempRecord.put('CurrentRetailerCategory', retailerCatMap.get(deal.Tenant_Category__c));
        tempRecord.put('CurrentTenantClassificat', deal.Tenant_Classification__c);
        tempRecord.put('AirConditioningFlag', booleanFormatter((deal.Existing_Fitout_Taken_Over_By_Tenant__c != null) ? deal.Existing_Fitout_Taken_Over_By_Tenant__c.contains( 'AC' ) : null));
        tempRecord.put('CoolRoomFlag', booleanFormatter((deal.Existing_Fitout_Taken_Over_By_Tenant__c != null) ? deal.Existing_Fitout_Taken_Over_By_Tenant__c.contains( 'CR' ): null));
        tempRecord.put('FloorCoverageFlag', booleanFormatter((deal.Existing_Fitout_Taken_Over_By_Tenant__c != null) ?deal.Existing_Fitout_Taken_Over_By_Tenant__c.contains( 'FC' ): null));
        tempRecord.put('GreaseTrapFlag', booleanFormatter((deal.Existing_Fitout_Taken_Over_By_Tenant__c != null) ?deal.Existing_Fitout_Taken_Over_By_Tenant__c.contains( 'GT' ): null));

        // VPDS-107 This has been done as the value for Water Service is WS but if HotWaterServiceFlag is selected it's value HWS with the contains function flags it as a Water Supply too when it actually shouldn't
        if(deal.Existing_Fitout_Taken_Over_By_Tenant__c != null){
            if(deal.Existing_Fitout_Taken_Over_By_Tenant__c.length() == 3){
                tempRecord.put('HotWaterServiceFlag', booleanFormatter((deal.Existing_Fitout_Taken_Over_By_Tenant__c != null) ?deal.Existing_Fitout_Taken_Over_By_Tenant__c.contains( 'HWS' ): null));

            }else{
                tempRecord.put('HotWaterServiceFlag', booleanFormatter((deal.Existing_Fitout_Taken_Over_By_Tenant__c != null) ?deal.Existing_Fitout_Taken_Over_By_Tenant__c.contains( ';HWS' ): null));
            }
        }

        tempRecord.put('LightingFlag', booleanFormatter((deal.Existing_Fitout_Taken_Over_By_Tenant__c != null) ? deal.Existing_Fitout_Taken_Over_By_Tenant__c.contains( 'LI' ): null));

        // VPDS-107 This has been done as the value for Mechanical Exhaust is ME but if SepUtilityMeterElecFlag is selected it's value  SUME with the contains function flags it as a Mechanical exhaust too when it actually shouldn't
        if(deal.Existing_Fitout_Taken_Over_By_Tenant__c != null){
            if(deal.Existing_Fitout_Taken_Over_By_Tenant__c.length() == 2){
                tempRecord.put('MechanicalExhaustFlag', booleanFormatter((deal.Existing_Fitout_Taken_Over_By_Tenant__c != null) ? deal.Existing_Fitout_Taken_Over_By_Tenant__c.contains( 'ME' ): null));
            }else{
                tempRecord.put('MechanicalExhaustFlag', booleanFormatter((deal.Existing_Fitout_Taken_Over_By_Tenant__c != null) ? deal.Existing_Fitout_Taken_Over_By_Tenant__c.contains( ';ME' ): null));
            }
        }


        tempRecord.put('PaintedWallsFlag', booleanFormatter((deal.Existing_Fitout_Taken_Over_By_Tenant__c != null) ? deal.Existing_Fitout_Taken_Over_By_Tenant__c.contains( 'PW' ): null));
        tempRecord.put('ElectricalThreePhaseFlag', booleanFormatter((deal.Existing_Fitout_Taken_Over_By_Tenant__c != null) ? deal.Existing_Fitout_Taken_Over_By_Tenant__c.contains( 'EDL3' ): null));
        tempRecord.put('ElectricalSinglePhaseFlag', booleanFormatter((deal.Existing_Fitout_Taken_Over_By_Tenant__c != null) ? deal.Existing_Fitout_Taken_Over_By_Tenant__c.contains( 'EDLS' ): null));
        tempRecord.put('SepUtilityMeterGasFlag', booleanFormatter((deal.Existing_Fitout_Taken_Over_By_Tenant__c != null) ? deal.Existing_Fitout_Taken_Over_By_Tenant__c.contains( 'SUMG' ): null));
        tempRecord.put('SepUtilityMeterWaterFlag', booleanFormatter((deal.Existing_Fitout_Taken_Over_By_Tenant__c != null) ? deal.Existing_Fitout_Taken_Over_By_Tenant__c.contains( 'SUMW' ): null));
        tempRecord.put('SepUtilityMeterElecFlag', booleanFormatter((deal.Existing_Fitout_Taken_Over_By_Tenant__c != null) ? deal.Existing_Fitout_Taken_Over_By_Tenant__c.contains( 'SUME' ): null));
        tempRecord.put('DisclosureOtherFlag', booleanFormatter((deal.Existing_Fitout_Taken_Over_By_Tenant__c != null) ? deal.Existing_Fitout_Taken_Over_By_Tenant__c.contains( 'OT' ): null));
        tempRecord.put('PlasteredWallsFlag', booleanFormatter((deal.Existing_Fitout_Taken_Over_By_Tenant__c != null) ? deal.Existing_Fitout_Taken_Over_By_Tenant__c.contains( 'PLW' ): null));
        tempRecord.put('ShopFrontFlag', booleanFormatter((deal.Existing_Fitout_Taken_Over_By_Tenant__c != null) ? deal.Existing_Fitout_Taken_Over_By_Tenant__c.contains( 'SF' ): null));
        tempRecord.put('SinkFlag', booleanFormatter((deal.Existing_Fitout_Taken_Over_By_Tenant__c != null) ? deal.Existing_Fitout_Taken_Over_By_Tenant__c.contains( 'SI' ): null));
        tempRecord.put('SprinklersFlag', booleanFormatter((deal.Existing_Fitout_Taken_Over_By_Tenant__c != null) ? deal.Existing_Fitout_Taken_Over_By_Tenant__c.contains( 'SP' ): null));
        tempRecord.put('SuspendedCeilingsFlag', booleanFormatter((deal.Existing_Fitout_Taken_Over_By_Tenant__c != null) ? deal.Existing_Fitout_Taken_Over_By_Tenant__c.contains( 'SC' ): null));
        tempRecord.put('TelephoneFlag', booleanFormatter((deal.Existing_Fitout_Taken_Over_By_Tenant__c != null) ? deal.Existing_Fitout_Taken_Over_By_Tenant__c.contains( 'TE' ): null));

        // VPDS-107 This has been done as the value for Water Service is WS but if HotWaterServiceFlag is selected it's value HWS with the contains function flags it as a Water Supply too when it actually shouldn't
        if(deal.Existing_Fitout_Taken_Over_By_Tenant__c != null){
            if(deal.Existing_Fitout_Taken_Over_By_Tenant__c.length() == 2){
                tempRecord.put('WaterSupplyFlag', booleanFormatter((deal.Existing_Fitout_Taken_Over_By_Tenant__c != null) ?deal.Existing_Fitout_Taken_Over_By_Tenant__c.contains( 'WS' ): null));

            }else{
                tempRecord.put('WaterSupplyFlag', booleanFormatter((deal.Existing_Fitout_Taken_Over_By_Tenant__c != null) ?deal.Existing_Fitout_Taken_Over_By_Tenant__c.contains( ';WS' ): null));
            }
        }

        tempRecord.put('WasteFlag', booleanFormatter((deal.Existing_Fitout_Taken_Over_By_Tenant__c != null) ? deal.Existing_Fitout_Taken_Over_By_Tenant__c.contains( 'WA' ): null));
        tempRecord.put('Description01', deal.Existing_Fitout_Other__c);
        //tempRecord.put('BuildingUniqueKeyID', deal.Unit__r.Building__r.Building_Code__c);
        tempRecord.put('BuildingUniqueKeyID', '0');
        tempRecord.put('TDPJDECostCenter', deal.Unit__r.Building__r.Building_Code__c);
        tempRecord.put('TenantAddressNumber', deal.Account.Tenant_CABID__c);
        tempRecord.put('TDPUnitName', deal.Unit__r.Name);
        tempRecord.put('TDPAddressNumberSalesman', deal.Owner.Address_Number__c);
        tempRecord.put('TDPAddressNumberManager', deal.Owner.Manager.Address_Number__c);
        tempRecord.put('TDPUnitRentableAreaSqFt', deal.Area_of_premises_sqmt__c);
        tempRecord.put('TDPPropmanUnitType', deal.Unit__r.Unit_Code__c);
        tempRecord.put('TDPLeaseAdminAddressNumber', deal.Unit__r.Building__r.Centre__r.Lease_Admin__r.Address_Number__c);
        //tempRecord.put('TDPBudgetBaseRentAmount', deal.Unit__r.Budget_Base_Rent_This_FY__c);
        tempRecord.put('TDPDevelopmentBudget', booleanFormatter(deal.Dev_Budget__c));
        tempRecord.put('TDPDevelopment', booleanFormatter(deal.Development_Unit__c));
        tempRecord.put('TDPDevelopmentClauseApplies', booleanFormatter(deal.Dev_Clause__c));
        //tempRecord.put('TDPFitoutContributionBudget', deal.Unit__r.Fitout_Contribution_Budget__c);
        //tempRecord.put('TDPLandlordWorksAmountBudget', deal.Unit__r.Future_Tenant_Landlord_Works_Budget__c);
        tempRecord.put('TDPLessorTextUniqueKeyID', deal.Selected_Landlord__r.Name);
        tempRecord.put('TDPProratedOutgoingsAmount', deal.Outgoings_Rate__c);
        tempRecord.put('TDPPLMApprovalRequired', booleanFormatter(deal.PLM_Approval_Required__c));
        //tempRecord.put('TDPProratedRatesAndTaxesAmo', deal.Rates_and_Taxes__r.Rate__c);
        tempRecord.put('TDPProratedRatesAndTaxesAmo', deal.Rates_and_Taxes_Amount__c);
        tempRecord.put('TDPReconfiguration', booleanFormatter(deal.Reconfig__c));
        tempRecord.put('TDPSurveyRequiredFlag', booleanFormatter(deal.Survey_Required__c));
        tempRecord.put('TDPTargetRentDate', (deal.Target_Lease_Commencement_Date__c != null ) ? formatDate(deal.Target_Lease_Commencement_Date__c)
        : formatDate(deal.Estimated_Lease_Commencement_Date__c));
        tempRecord.put('PreferentialRights', deal.Preferential_Rights__c);

        //------------------------------------------
        // Contacts
        for(Contact c: getContacts()){
            Map<String, Object> tempContact = new Map<String, Object>();
            //tempContact.put('ContactName', c.Name);
            tempContact.put('ContactType', contactTypeMap.get(c.Tenant_Rep_Type__c));
            tempContact.put('WhosWhoLineNumberID', c.Whos_Who_Line_Number__c);
            tempContact.put('JDEAddressNumber', c.Account.Tenant_CABID__c);

            tempContacts.add(tempContact);
        }

        tempRecord.put('Contacts', tempContacts);

        //------------------------------------------
        Map<String, Object> tempSpecialCondition;

        //Special Conditions
        Set<String> specialCons = new Set<String>();
        if(deal.Non_Standard_Special_Conditions__c !=null){
            for(String sp : deal.Non_Standard_Special_Conditions__c.split(';')){
                 tempSpecialCondition = new Map<String, Object>();

                if( sp != 'WAMTLT' &&  // Filter NONSTD Special Cons
                    sp != 'WAMTLMT' &&
                    sp != 'WAMTE5YT' &&
                    sp != 'SURFEE' &&
                    sp != 'LQRLIC'
                    // added by nitin
                    &&
                    sp != 'BGED' &&
                    sp != 'DSA' &&
                    sp != 'FROR' &&
                    sp != 'HOARDSKIN' &&
                    sp != 'LICPFP' &&
                    sp != 'LICCPFL' &&
                    sp != 'LICCWCP' &&
                    sp != 'LICSIGNS' &&
                    sp != 'LICSIGNEX' &&
                    sp != 'LICSIGNCP' &&
                    sp != 'MGNR' &&
                    sp != 'OLLTS' &&
                    sp != 'OLLTL' &&
                    sp != 'PRNOC' &&
                    sp != 'REBRAND' &&
                    sp != 'SPRUIK' &&
                    sp != 'SFNPBT' &&
                    sp != 'TTALL' &&
                    sp != 'TTSA' &&
                    sp != 'NOBIND' &&
                    sp != 'LOGO' &&
                    sp != 'CONF' &&
                    sp != 'DISCAMEND' &&
                    sp != 'AFFPBC' &&
                    sp != 'AFFPBC' &&
                    sp != 'COT' &&
                    sp != 'EZPK' &&
                    sp != 'EZCML' &&
                    sp != 'FFTRN' &&
                    sp != 'FSTSF' &&
                    sp != 'HDTRORD' &&
                    sp != 'HDDABP' &&
                    sp != 'LLWDTPP' &&
                    sp!= 'RPSMA' &&
                    sp!= 'FRL' &&
                    sp!= 'TRADHRS' &&
                    sp!= 'ROL' &&
                    sp!= 'CAT1CAP' &&
                    sp!= 'STCBA' &&
                    sp!= 'STPAN' &&
                    sp!= 'VPTR' &&
                    sp!= 'HDOVR' &&
                    sp!= 'HOARDCAP' &&
                    sp!= 'HOARD50' &&
                    sp!= 'INTER'&&
                    //sp!= 'LON010' && - removed as NITIN had it in here an dit should not have been
                    sp!= 'DIRDEB'
                    
                    ){
                    specialCons.add(sp);
                }else{ // Add NONSTD Special Cons from Std Cons picklist
                    tempSpecialCondition.put('StdClauseIdentifier', 'NONSTD');
                    tempSpecialCondition.put('ClauseOptionNo', '0');
                    if(fieldsToValue.containsKey(sp+'_NTSD__c')){
                        tempSpecialCondition.put('GenericShortString', fieldsToValue.get(sp+'_NTSD__c'));
                    }else if(fieldsToValue.containsKey(sp+'_NSSC__c')){
                        tempSpecialCondition.put('GenericShortString', fieldsToValue.get(sp+'_NSSC__c'));
                    }else{
                        tempSpecialCondition.put('GenericShortString', null);
                    }

                    tempSpecialConditions.add(tempSpecialCondition);
                }
            }
        }
        for(String spCon: specialCons){ // Add Std Cons
            tempSpecialCondition = new Map<String, Object>();

            //ID
            tempSpecialCondition.put('StdClauseIdentifier', spCon);

            //Options
            if(fieldsToValue.containsKey(spCon+'_Options__c')){
                if(String.isEmpty(String.valueOf(fieldsToValue.get(spCon+'_Options__c')))){
                    tempSpecialCondition.put('ClauseOptionNo', '99');
                }else{
                    tempSpecialCondition.put('ClauseOptionNo', fieldsToValue.get(spCon+'_Options__c'));
                }
            }else{
                tempSpecialCondition.put('ClauseOptionNo', '0');
            }
            //NSSC
            if(fieldsToValue.containsKey(spCon+'_NTSD__c')){
                tempSpecialCondition.put('GenericShortString', fieldsToValue.get(spCon+'_NTSD__c'));
            }

            //Value
            if(spCon == 'LON017'){
                tempSpecialCondition.put('MathNumeric80', deal.LON017_Capped_Legal_Fees__c);
            }else if(spCon == 'LON020'){
                tempSpecialCondition.put('MathNumeric80', deal.LON020_Number_of_Option_Terms__c);
                tempSpecialCondition.put('MathNumeric03', deal.LON020_Review_Percentage__c);
                tempSpecialCondition.put('MathNumeric02', deal.LON020_Time_Period_in_Years__c);
            }else if(spCon == 'LON044'){
                tempSpecialCondition.put('DateEndofPeriod01Ju', formatDate(deal.LON044_Refit_Completion_Date__c));
            //}else if(spCon == 'LON025'){
            //  tempSpecialCondition.put('SeatingLicence', deal.LON025_Seating_Licence_Fee__c);
            }else if(spCon == 'LON031'){
                tempSpecialCondition.put('UnitName', deal.LON031_Tenants_Current_Lease_Unit__r.Name);
            }else if(spCon == 'LON054'){
                tempSpecialCondition.put('DateEndofPeriod01Ju', formatDate(deal.LON054_Tenant_Board_Approval__c));
            //}else if(spCon == 'LON002'){
            //  tempSpecialCondition.put('UnitName', deal.LON002_Tenants_Previous_Lease_Unit__r.Name);
            //}else if(spCon == 'LON035'){
            //  tempSpecialCondition.put('TerminationOfConvenienceDate', deal.LON035_Termination_of_Convenience_Date__c);
            }else if(spCon == 'LON037'){
                tempSpecialCondition.put('DateEndofPeriod01Ju', formatDate(deal.LON037_Vacant_Possession_Date__c));
            }else if(spCon == 'LON059'){
                tempSpecialCondition.put('MathNumeric01', deal.LON059_Cost_of_Category_1_Works__c);
            }else if(spCon == 'RENTRV'){
                tempSpecialCondition.put('GenericShortString', deal.Rent_Review_Free_Format_Clause__c);
            }else if(spCon == 'PROMRV'){
                tempSpecialCondition.put('GenericShortString', deal.Promo_Contribution_Free_Format_Clause__c);
            }

            tempSpecialConditions.add(tempSpecialCondition);
        }

        for(Non_Standard_Special_Conditions__c nssc : getNSSC()){ // Add NONSTD cons from Obj
            tempSpecialCondition = new Map<String, Object>();

            tempSpecialCondition.put('StdClauseIdentifier', 'NONSTD');
            tempSpecialCondition.put('ClauseOptionNo', '0');
            tempSpecialCondition.put('GenericShortString', nssc.Special_Condition__c);

            tempSpecialConditions.add(tempSpecialCondition);
        }

        tempRecord.put('SpecialConditions', tempSpecialConditions);
        //------------------------------------------
        System.debug('Serialized JSON - ' + JSON.serialize(tempRecord));
        System.debug('Serialized JSON after format - ' + JSON.serialize(tempRecord).replace('\\u001A', ''));

        return JSON.serialize(tempRecord).replace('\\u001A', '');
    }


    public String booleanFormatter(Boolean value){
        if(value != null){
            return (value ? 'Y' : 'N');
        }else{
            return 'N';
        }

    }

    public Integer binaryFormatter(String value, String text){
        if(value != null){
            return (value == text ? 1 : 0);
        }else{
            return 0;
        }
    }

    public String formatDate(Datetime dateToFormat){
        if(dateToFormat !=null){
            return dateToFormat.format('yyy/MM/dd');
        }else{
            return null;
        }
    }

    public class ApiResonse{
        String status;
        List<String> message;
        String reason;
        String deal_key;

        public ApiResonse(){
            message = new List<String>();
        }
    }
}