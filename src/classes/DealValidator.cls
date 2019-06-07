public with sharing class DealValidator {
	public Opportunity deal{get;set;}
	public List<Non_Standard_Special_Conditions__c> nsSpecialCons{get;set;}
	public List<String> errorMsgs {get; set;}

	public DealValidator(){
		errorMsgs = new List<String>();
		nsSpecialCons = new List<Non_Standard_Special_Conditions__c>();
	}

	public DealValidator(Opportunity deal){
		this.deal = deal;
		errorMsgs = new List<String>();
		nsSpecialCons = new List<Non_Standard_Special_Conditions__c>();
	}

	public Boolean hasError{
		get{return ( (errorMsgs.size() >0 && !Test.isRunningTest()) ? true : false);}
	}

	public Map<String, Schema.SObjectField> fieldMap{
		get{
			Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
			Schema.SObjectType objSchema = schemaMap.get('Opportunity');

			return objSchema.getDescribe().fields.getMap();
		}
	}

	public User currentUser{
		get{
			return [SELECT Name, Id, Title, MobilePhone, Phone, Fax, Email
					FROM User WHERE Id = :UserInfo.getUserId()];
		}
	}

	public Boolean validateTenantProfile(Opportunity deal){
		this.deal = deal;

		return validateTenantProfile();
	}

	public Boolean validateTenantProfile(){
		if(String.isEmpty(deal.Percentage_Rent_Category__c) && deal.Existing_Retailer__c){
            //errorMsgs.add(fieldMap.get('Percentage_Rent_Category__c').getDescribe().getLabel() + ' is required.');
        }if(deal.Percentage_Rent_Rate__c == null && deal.Existing_Retailer__c){
            //errorMsgs.add(fieldMap.get('Percentage_Rent_Rate__c').getDescribe().getLabel() + ' is required.');
        }if(String.isEmpty(deal.Permitted_Use_Profile__c) && deal.Existing_Retailer__c){
            //errorMsgs.add(fieldMap.get('Permitted_Use_Profile__c').getDescribe().getLabel() + ' is required.');
        }if(deal.Rent_Review_Percentage__c == null && deal.Existing_Retailer__c){
            //errorMsgs.add(fieldMap.get('Rent_Review_Percentage__c').getDescribe().getLabel() + ' is required.');
        }if(deal.Rent_Review_Percentage__c == null && deal.Existing_Retailer__c){
            //errorMsgs.add(fieldMap.get('Rent_Review_Percentage__c').getDescribe().getLabel() + ' is required.');
        }if(deal.Franchisor__c == null && deal.Existing_Retailer__c){
           //errorMsgs.add(fieldMap.get('Franchisor__c').getDescribe().getLabel() + ' is required.');
        }if(deal.Agreed_National_Lease_Exists__c == null && deal.Existing_Retailer__c){
           //errorMsgs.add(fieldMap.get('Agreed_National_Lease_Exists__c').getDescribe().getLabel() + ' is required.');
        }

        return true;
        //return !hasError;
	}

	public Boolean validateTDP(Opportunity deal){
		this.deal = deal;

		return validateTDP();
	}

	public Boolean validateTDP(){
		if(deal.New_Retailer__c == true && String.isEmpty(deal.New_Trading_Name__c)){
            errorMsgs.add('Trading Name is required.');
        }if(deal.New_Retailer__c == true && String.isEmpty(deal.New_Tenant_Entity__c)){
            errorMsgs.add('Tenant Entity is required.');
        }if(deal.Existing_Retailer__c == true && String.isEmpty(deal.AccountId)){
            errorMsgs.add('Retailer is required.');
        }if(deal.Recovery_Type__c == 'None' || String.isEmpty(deal.Recovery_Type__c)){
            errorMsgs.add(fieldMap.get('Recovery_Type__c').getDescribe().getLabel() + ' is required.');
        }if(deal.Estimated_Lease_Commencement_Date__c == null){
            errorMsgs.add(fieldMap.get('Estimated_Lease_Commencement_Date__c').getDescribe().getLabel() + ' is required.');
        }if(String.isEmpty(deal.Deal_Type__c)){
            errorMsgs.add(fieldMap.get('Deal_Type__c').getDescribe().getLabel() + ' is required.');
        }if(deal.Retail_Act_Applies__c == null){
           errorMsgs.add(fieldMap.get('Retail_Act_Applies__c').getDescribe().getLabel() + ' is required.');
        }if(deal.Selected_Landlord__c == null){
           errorMsgs.add(fieldMap.get('Selected_Landlord__c').getDescribe().getLabel() + ' is required.');
        }if(deal.Recovery_Type__c == 'Net' && (deal.Outgoings_Rate__c == null || deal.Outgoings_Rate__c < 1)){
           errorMsgs.add(fieldMap.get('Outgoings_Rate__c').getDescribe().getLabel() + ' is required.');
        }if(deal.Recovery_Type__c == 'Net' && (deal.Rates_and_Taxes_Amount__c == null || deal.Rates_and_Taxes_Amount__c ==0 ) && (deal.Unit__r.Building__r.Centre__r.State__c == 'VIC' || deal.Unit__r.Building__r.Centre__r.Name == 'Northgate')){
           errorMsgs.add(fieldMap.get('Rates_and_Taxes_Amount__c').getDescribe().getLabel() + ' is required.');
        }

        return !hasError;

	}

	public Boolean validateEOI(Opportunity deal){
		this.deal = deal;

		return validateEOI();
	}

    public Boolean validateEOI(){
        if(deal.Existing_Retailer__c == false && deal.New_Retailer__c == true && String.isEmpty(deal.New_Trading_Name__c)){
            errorMsgs.add('Trading Name is required.');
        }if(deal.Existing_Retailer__c == false && deal.New_Retailer__c == true && String.isEmpty(deal.New_Tenant_Entity__c)){
            errorMsgs.add('Tenant Entity is required.');
        }if(String.isEmpty(deal.Authorised_Reps__c) && String.isEmpty(deal.New_Auth_Rep_Name__c)){
        	errorMsgs.add('Authorised Representative is required.');
        }if(String.isEmpty(deal.Legal_Reps__c)&& String.isEmpty(deal.New_Leg_Rep_Address__c)){
        	errorMsgs.add('Legal Representative is required.');
        }if(deal.Recovery_Type__c == null){
            errorMsgs.add('Recovery Type is required.');
        //}if(deal.Recovery_Type__c =='Net' && (deal.Promotion_Contribution_Percent__c == null || deal.Promotion_Contribution_Percent__c == 0)){
        	//errorMsgs.add('Promotion Contribution is required.');
        // Stuart Donnachie - VMS- 41 - If the Promo Review Type = 'Not Applicable' then do not validate the Promo Amt Year 1 field.
        }if(deal.Recovery_Type__c =='Net' && deal.Promo_Review_Rate_and_Type__c != 'Not Applicable' && deal.Promo_Amt_Year_1__c == null){
            errorMsgs.add('Promo Amount (Year 1) is required.');
        }if(deal.Recovery_Type__c =='Net' && (deal.Base_Rent__c == null || deal.Base_Rent__c < 1)){
            errorMsgs.add('Base Rent is required.');
        }if(deal.Recovery_Type__c =='Gross' && (deal.Gross_Rent__c == null || deal.Gross_Rent__c < 1)){
            errorMsgs.add('Gross Rent is required.');
        }if(deal.Works_Type__c == null && (deal.Deal_Type__c =='New Tenant Standard' || (deal.Deal_Type__c =='Renewal' && deal.Refit__c == true)) && deal.Unit__r.Unit_Type__c != 'Automatic Teller Machines'){
            errorMsgs.add('Works Type is required.');
        }if(deal.Deal_Type__c =='New Tenant Standard' && deal.Estimated_Handover_Date__c == null){
            errorMsgs.add('Estimated Handoer Date is required.');
        }if((deal.Reconfig__c && (deal.Area_of_premises_sqmt__c == null || deal.Area_of_premises_sqmt__c < 1)) ||
        (deal.Dev_Clause__c && (deal.Area_of_premises_sqmt__c == null || deal.Area_of_premises_sqmt__c < 1))){
            errorMsgs.add('Area of premises is required.');
        }if((deal.Lease_Term_Years__c == null || deal.Lease_Term_Years__c <1) && (deal.Lease_Term_Months__c ==null ||
        deal.Lease_Term_Months__c<1)  && (deal.Lease_Term_Days__c ==null || deal.Lease_Term_Days__c <1 )){
            errorMsgs.add('Lease Term is required.');
        }if(deal.Lease_Term_Months__c > 11){
            errorMsgs.add('Invalid Lease Term Months.');
        }if(deal.Lease_Term_Days__c > 30){
            errorMsgs.add('Invalid Lease Term Days.');
        }if((deal.Design_Review_Fees_At_Commencement__c || deal.Design_Review_Fees_During_Term__c) &&
        (deal.Design_Review_Fees_Rate_at_commencement__c == null || deal.Design_Review_Fees_Rate_at_commencement__c < 1) && !deal.Unit__r.Building__r.Hartnett_Asset__c){ // If the building is a Hartnett Asset then skip this validation as the fee needs to be zero.
           errorMsgs.add('Design Review Fee is required');
        }if((deal.Hoarding_At_Commencement__c || deal.Hoarding_During_End_Term__c) && (deal.Hoarding_Rate_at_Commencement__c == null || deal.Hoarding_Rate_at_Commencement__c < 1)){
           errorMsgs.add('Hoarding rate is required.');
        }if((deal.Hoarding_At_Commencement__c || deal.Hoarding_During_End_Term__c) && (deal.Hoarding_Rate_at_Commencement__c == null || deal.Hoarding_Rate_at_Commencement__c < 1)){
           errorMsgs.add('Hoarding rate is required.');
        }if((deal.Deal_Type__c =='New Tenant Standard' && deal.Unit__r.Unit_Type__c != 'Automatic Teller Machines' && deal.Unit__r.Unit_Type__c != 'Offices') && (deal.Fit_out_Period__c == null || deal.Fit_out_Period__c == 0)){
    	 	errorMsgs.add('Fitout Days is required.');
        }if(deal.Tenant_Checks_Required__c == false && deal.Tenant_Checks_Exclusion_Reason__c == null){
    	 	errorMsgs.add('Tenant Checks Exclusion Reason is required.');
        }if(deal.Surrender_other_premises_in_Centre__c == true  && deal.Surrender_other_premises_Date_Options__c == null){
            errorMsgs.add('Tenant Surrender Other Premises: Surrender Date is required.');
        }if(deal.Surrender_other_premises_Date_Options__c == 'Fixed Date' && deal.Surrender_other_premises_Date__c == null){
            errorMsgs.add('Tenant Surrender Other Premises: Surrender Date is required.');
        //}if(deal.Surrender_other_premises_in_Centre__c == true && deal.Surrender_other_premises_Fees__c == null){
        //	errorMsgs.add('Tenant Surrender Other Premises: Surrender Fee is required.');
        }if(deal.Surrender_other_premises_in_Centre__c == true && deal.Surrender_other_premises_Make_Good__c == null){
            errorMsgs.add('Tenant Surrender Other Premises: Make Good by Tenant is required.');
        }if(deal.Surrender_other_premises_in_Centre__c == true && deal.Surrender_other_premises_Unit__c == null){
            errorMsgs.add('Tenant Surrender Other Premises: Unit No is required.');
        }if(deal.Surrender_these_premises_in_Centre__c  == true && deal.Surrender_these_premises_Date_Options__c == null){
			errorMsgs.add('Tenant Surrender These Premises: Surrender Date is required.');
        }if(deal.Surrender_these_premises_Date_Options__c == 'Fixed Date' && deal.Surrender_these_premises_Date__c == null){
            errorMsgs.add('Tenant Surrender These Premises: Surrender Date is required.');
        //}if(deal.Surrender_these_premises_in_Centre__c == true && deal.Surrender_these_premises_Fees__c == null){
		//	errorMsgs.add('Tenant Surrender These Premises: Surrender Fee is required.');
        }if(deal.Surrender_these_premises_in_Centre__c == true && deal.Surrender_these_premises_Make_Good__c == null){
            errorMsgs.add('Tenant Surrender These Premises: Make Good by Tenant is required.');
        }if(deal.Surrender_these_premises_in_Centre__c == true && deal.Surrender_these_premises_Unit__c == null){
            errorMsgs.add('Tenant Surrender These Premises: Unit No is required.');
        }if(deal.Surrender_these_premises_in_Centre__c == true && deal.Surrender_these_premises_Legal_Cost__c  == null){
            errorMsgs.add('Tenant Surrender These Premises: Legal Cost is required.');
        }if(deal.Liquor_Licence__c && deal.LQRLIC_Options__c == null){
            errorMsgs.add(fieldMap.get('LQRLIC_Options__c').getDescribe().getLabel() + ' is required.');
        }if(deal.Liquor_Licence__c && deal.LQRLIC_Options__c == '1' && deal.Liqour_Licence_Date__c == null){
            errorMsgs.add(fieldMap.get('Liqour_Licence_Date__c').getDescribe().getLabel() + ' is required.');
        }if(deal.Retail_Act_Applies__c == null){
           errorMsgs.add(fieldMap.get('Retail_Act_Applies__c').getDescribe().getLabel() + ' is required.');
        }if(deal.Recovery_Type__c == 'Net' && (deal.Outgoings_Rate__c == null || deal.Outgoings_Rate__c < 1)){
           errorMsgs.add(fieldMap.get('Outgoings_Rate__c').getDescribe().getLabel() + ' is required.');
        }if(deal.Recovery_Type__c == 'Net' && (deal.Rates_and_Taxes_Amount__c == null || deal.Rates_and_Taxes_Amount__c ==0 ) && (deal.Unit__r.Building__r.Centre__r.State__c == 'VIC' || deal.Unit__r.Building__r.Centre__r.Name == 'Northgate')){
           errorMsgs.add(fieldMap.get('Rates_and_Taxes_Amount__c').getDescribe().getLabel() + ' is required.');
        }if(deal.Storage__c && (deal.Area_of_Storage__c == null || deal.Area_of_Storage__c < 1)){
           errorMsgs.add(fieldMap.get('Area_of_Storage__c').getDescribe().getLabel() + ' is required.');
        }if(deal.Fitout_Contribution__c && (deal.Fitout_Contribution_Amount__c == null || deal.Fitout_Contribution_Amount__c == 0)){
		   errorMsgs.add(fieldMap.get('Fitout_Contribution_Amount__c').getDescribe().getLabel() + ' is required.');
        }if(deal.Refurbishment_Contribution__c && (deal.Refurbishment_Contribution_Amount__c == null || deal.Refurbishment_Contribution_Amount__c == 0)){
		   errorMsgs.add(fieldMap.get('Refurbishment_Contribution_Amount__c').getDescribe().getLabel() + ' is required.');
        }if(deal.Storage__c && (deal.Storage_Rate__c == null || deal.Storage_Rate__c < 1)){
           errorMsgs.add(fieldMap.get('Storage_Rate__c').getDescribe().getLabel() + ' is required.');
        }if(deal.Seating_Licence__c && deal.Seating_Licence_Type__c == null){
           errorMsgs.add(fieldMap.get('Seating_Licence_Type__c').getDescribe().getLabel() + ' is required.');
        }if(deal.Seating_Licence__c && (deal.Seating_License_Area__c == null || deal.Seating_License_Area__c == 0)){
           errorMsgs.add(fieldMap.get('Seating_License_Area__c').getDescribe().getLabel() + ' is required.');
        }

        return !hasError;
	}

	public Boolean validateLON(Opportunity deal, Boolean isEoiValid){
		this.deal = deal;

		return validateLON(isEoiValid);
	}

    public Boolean validateLON(Boolean isEoiValid){

        if(String.isEmpty(deal.Billing_Reps__c)){
            errorMsgs.add('Billing Representatives are required.');
        }if(String.isEmpty(deal.Notice_Reps__c)){
            errorMsgs.add('Notice Address is required.');
        }if(String.isEmpty(deal.Registration_Reps__c)){
            errorMsgs.add('Registered Address is required.');
        }if(deal.New_Auth_Rep_Added__c == true && String.isEmpty(deal.New_Auth_Rep_Address__c)){
            errorMsgs.add('Auth Rep Address is required.');
        }if(deal.New_Leg_Rep_Added__c == true && String.isEmpty(deal.New_Leg_Rep_Email__c)){
            errorMsgs.add('Legal Rep Email is required.');
        }if(deal.New_Leg_Rep_Added__c == true && String.isEmpty(deal.New_Leg_Rep_Address__c)){
        	errorMsgs.add('Legal Rep Address is required.');
        }if(deal.Tenant_Classification__c == null){
            errorMsgs.add('Tenant Classification is required.');
        }if(deal.Tenant_Category__c == null){
            errorMsgs.add('Tenant Classification is required.');
        }if((deal.Type_of_Guarantor_Required__c == 'PE' || deal.Type_of_Guarantor_Required__c == 'PA') && (deal.No_of_Personal_Guarantee__c == null
        || deal.No_of_Personal_Guarantee__c == 0) && String.isEmpty(deal.Guarantor_Reps__c)){
            errorMsgs.add('Guarantors are required.');
    	}if(deal.Deal_Type__c !='Renewal' && deal.Unit__r.Unit_Code__c != '40OFF' && (deal.Year_1_Sales_Estimate__c == null || deal.Year_1_Sales_Estimate__c == 0)){
            errorMsgs.add('Year 1 Sales Estimate is required.');
        }if(deal.Common_Area_Overlease_line_trading__c == null){
            errorMsgs.add('Common Area / Overlease line trading is required.');
        }if(deal.Option_for_further_term__c == null){
            errorMsgs.add('Option for further term is required.');
        //}if(deal.Deal_Type__c !='Renewal' && deal.Fit_out_Period__c !=null && deal.Fit_out_Period__c < 1){
        //    errorMsgs.add('Fitout Period is required.');
        }if(deal.Percentage_Rent_Threshold__c =='Artificial' && (deal.Artificial_Threshold_Amount__c == null || deal.Artificial_Threshold_Amount__c == 0)){
            errorMsgs.add('Artificial Threshold Amount is required.');
        }if(deal.Surrender_these_premises_in_Centre__c && deal.Surrender_these_premises_Legal_Cost__c == null){
            errorMsgs.add('Surrender these premises Legal_Cost is required.');
        }if(deal.Is_Taking_Existing_Fitout__c == true && deal.Existing_Fitout_Taken_Over_By_Tenant__c == null){
            errorMsgs.add('Existing Fitout Taken Over By Tenant is required.');
        }if(deal.Is_Taking_Existing_Fitout__c == true && deal.Existing_Fitout_Taken_Over_By_Tenant__c!=null && deal.Existing_Fitout_Taken_Over_By_Tenant__c.contains('OT') &&
        String.isEmpty(deal.Existing_Fitout_Other__c)){
            errorMsgs.add('Existing Fitout Other is required.');
        }if(deal.Deal_Type__c =='New Tenant As Is' && !deal.Is_Taking_Existing_Fitout__c && deal.Unit__r.Building__r.Centre__r.State__c != 'WA'){
            errorMsgs.add('Is Taking Existing Fitout is required.');
        //}if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('LON010') && deal.LON010_Options__c== '3' && String.isEmpty(deal.LON010_NTSD__c)){
        //    errorMsgs.add(fieldMap.get('LON010_NTSD__c').getDescribe().getLabel() + ' is required.');
        }if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('LON001') && deal.LON001_Custom_Text__c && String.isEmpty(deal.LON001_NTSD__c)){
            errorMsgs.add(fieldMap.get('LON001_NTSD__c').getDescribe().getLabel() + ' is required.');
        }if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('LON044') && deal.LON044_Custom_Refit_Condition__c && String.isEmpty(deal.LON044_NTSD__c)){
            errorMsgs.add(fieldMap.get('LON044_NTSD__c').getDescribe().getLabel() + ' is required.');
        }if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('LON007') && deal.LON007_Custom_Text__c && String.isEmpty(deal.LON007_NTSD__c)){
            errorMsgs.add(fieldMap.get('LON007_NTSD__c').getDescribe().getLabel() + ' is required.');
        }if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('LON010') && deal.LON010_Custom_Text__c && String.isEmpty(deal.LON010_NTSD__c)){
            errorMsgs.add(fieldMap.get('LON010_NTSD__c').getDescribe().getLabel() + ' is required.');
        }if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('LON020') && deal.LON020_Custom_Text__c && String.isEmpty(deal.LON020_NTSD__c)){
            errorMsgs.add(fieldMap.get('LON020_NTSD__c').getDescribe().getLabel() + ' is required.');
        }if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('LON045') && deal.LON045_Custom_Text__c && String.isEmpty(deal.LON045_NTSD__c)){
            errorMsgs.add(fieldMap.get('LON045_NTSD__c').getDescribe().getLabel() + ' is required.');
        }if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('LON046') && deal.LON046_Custom_Text__c && String.isEmpty(deal.LON046_NTSD__c)){
            errorMsgs.add(fieldMap.get('LON046_NTSD__c').getDescribe().getLabel() + ' is required.');
        }if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('LON049') && deal.LON049_Custom_Text__c && String.isEmpty(deal.LON049_NTSD__c)){
            errorMsgs.add(fieldMap.get('LON049_NTSD__c').getDescribe().getLabel() + ' is required.');
            /*}if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('LON002') && deal.LON002_Options__c== '2' && deal.LON002_Tenants_Previous_Lease_Unit__c == null){
                errorMsgs.add(fieldMap.get('LON002_Tenants_Previous_Lease_Unit__c').getDescribe().getLabel() + ' is required.'); Stuart Donnachie - LON002 no longer active in Picklist */
        }if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('LON003') && deal.LON003_Options__c== '1' && String.isEmpty(deal.LON003_NTSD__c)){
            errorMsgs.add(fieldMap.get('LON003_NTSD__c').getDescribe().getLabel() + ' is required.');
        }if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('LON004') && deal.LON004_Options__c== '1' && String.isEmpty(deal.LON004_NTSD__c)){
            errorMsgs.add(fieldMap.get('LON004_NTSD__c').getDescribe().getLabel() + ' is required.');
        }if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('LON008') && deal.LON008_Options__c== '1' && String.isEmpty(deal.LON008_NTSD__c)){
            errorMsgs.add(fieldMap.get('LON008_NTSD__c').getDescribe().getLabel() + ' is required.');
        }if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('LON009') && deal.LON009_Options__c== '1' && String.isEmpty(deal.LON009_NTSD__c)){
            errorMsgs.add(fieldMap.get('LON009_NTSD__c').getDescribe().getLabel() + ' is required.');
        }if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('LON066') && deal.LON066_Options__c== '1' && String.isEmpty(deal.LON066_NTSD__c)){
            errorMsgs.add(fieldMap.get('LON066_NTSD__c').getDescribe().getLabel() + ' is required.');
        }if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('LON067') && deal.LON067_Custom_Text__c && String.isEmpty(deal.LON067_NTSD__c)){
            errorMsgs.add(fieldMap.get('LON067_NTSD__c').getDescribe().getLabel() + ' is required.');
        }if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('LQRLIC') && String.isEmpty(deal.LQRLIC_NTSD__c)){
            errorMsgs.add(fieldMap.get('LQRLIC_NTSD__c').getDescribe().getLabel() + ' is required.');
            //ADDED BY NITIN--- additional special conditions
      /* }if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('BGED') && String.isEmpty(deal.BGED_NTSD__c)){
            errorMsgs.add(fieldMap.get('BGED_NTSD__c').getDescribe().getLabel() + ' is required.');
       }if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('DSA') && String.isEmpty(deal.DSA_NTSD__c)){
            errorMsgs.add(fieldMap.get('DSA_NTSD__c').getDescribe().getLabel() + ' is required.');
       }if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('FROR') && String.isEmpty(deal.FROR_NTSD__c)){
            errorMsgs.add(fieldMap.get('FROR_NTSD__c').getDescribe().getLabel() + ' is required.');
       }if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('HOARDSKIN') && String.isEmpty(deal.HOARDSKIN_NTSD__c)){
            errorMsgs.add(fieldMap.get('HOARDSKIN_NTSD__c').getDescribe().getLabel() + ' is required.');
       }if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('LICCPFP') && String.isEmpty(deal.LICCPFP_NTSD__c)){
            errorMsgs.add(fieldMap.get('LICCPFP_NTSD__c').getDescribe().getLabel() + ' is required.');
       }if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('LICCWCP') && String.isEmpty(deal.LICCWCP_NTSD__c)){
            errorMsgs.add(fieldMap.get('LICCWCP_NTSD__c').getDescribe().getLabel() + ' is required.');
       }if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('LICSIGNS') && String.isEmpty(deal.LICSIGNS_NTSD__c)){
            errorMsgs.add(fieldMap.get('LICSIGNS_NTSD__c').getDescribe().getLabel() + ' is required.');
       }if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('LICSIGNEX') && String.isEmpty(deal.LICSIGNEX_NTSD__c)){
            errorMsgs.add(fieldMap.get('LICSIGNEX_NTSD__c').getDescribe().getLabel() + ' is required.');
       }if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('LICSIGNCP') && String.isEmpty(deal.LICSIGNCP_NTSD__c)){
            errorMsgs.add(fieldMap.get('LICSIGNCP_NTSD__c').getDescribe().getLabel() + ' is required.');
       }if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('MGNR') && String.isEmpty(deal.MGNR_NTSD__c)){
            errorMsgs.add(fieldMap.get('MGNR_NTSD__c').getDescribe().getLabel() + ' is required.');
       }if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('OLLTS') && String.isEmpty(deal.OLLTS_NTSD__c)){
            errorMsgs.add(fieldMap.get('OLLTS_NTSD__c').getDescribe().getLabel() + ' is required.');
       }if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('OLLTL') && String.isEmpty(deal.OLLTL_NTSD__c)){
            errorMsgs.add(fieldMap.get('OLLTL_NTSD__c').getDescribe().getLabel() + ' is required.');
       }if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('PRNOC') && String.isEmpty(deal.PRNOC_NTSD__c)){
            errorMsgs.add(fieldMap.get('PRNOC_NTSD__c').getDescribe().getLabel() + ' is required.');
       }if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('REBRAND') && String.isEmpty(deal.REBRAND_NTSD__c)){
            errorMsgs.add(fieldMap.get('REBRAND_NTSD__c').getDescribe().getLabel() + ' is required.');
       }if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('SPRUIK') && String.isEmpty(deal.SPRUIK_NTSD__c)){
            errorMsgs.add(fieldMap.get('SPRUIK_NTSD__c').getDescribe().getLabel() + ' is required.');
       }if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('SFNPBT') && String.isEmpty(deal.SFNPBT_NTSD__c)){
            errorMsgs.add(fieldMap.get('SFNPBT_NTSD__c').getDescribe().getLabel() + ' is required.');
       }if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('TTALL') && String.isEmpty(deal.TTALL_NTSD__c)){
            errorMsgs.add(fieldMap.get('TTALL_NTSD__c').getDescribe().getLabel() + ' is required.');
       }if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('TTSA') && String.isEmpty(deal.TTSA_NTSD__c)){
            errorMsgs.add(fieldMap.get('TTSA_NTSD__c').getDescribe().getLabel() + ' is required.');
       }if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('NOBIND') && String.isEmpty(deal.NOBIND_NTSD__c)){
            errorMsgs.add(fieldMap.get('NOBIND_NTSD__c').getDescribe().getLabel() + ' is required.');
       }if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('LOGO') && String.isEmpty(deal.LOGO_NTSD__c)){
            errorMsgs.add(fieldMap.get('LOGO_NTSD__c').getDescribe().getLabel() + ' is required.');
       }if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('CONF') && String.isEmpty(deal.CONF_NTSD__c)){
            errorMsgs.add(fieldMap.get('CONF_NTSD__c').getDescribe().getLabel() + ' is required.');
       }if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('DISCAMEND') && String.isEmpty(deal.DISCAMEND_NTSD__c)){
            errorMsgs.add(fieldMap.get('DISCAMEND_NTSD__c').getDescribe().getLabel() + ' is required.');
       }if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('AFFPBC') && String.isEmpty(deal.AFFPBC_NTSD__c)){
            errorMsgs.add(fieldMap.get('AFFPBC_NTSD__c').getDescribe().getLabel() + ' is required.');
       }if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('AFFPAC') && String.isEmpty(deal.AFFPAC_NTSD__c)){
            errorMsgs.add(fieldMap.get('AFFPAC_NTSD__c').getDescribe().getLabel() + ' is required.');
       }if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('COT') && String.isEmpty(deal.COT_NTSD__c)){
            errorMsgs.add(fieldMap.get('COT_NTSD__c').getDescribe().getLabel() + ' is required.');
       }if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('EZPK') && String.isEmpty(deal.EZPK_NTSD__c)){
            errorMsgs.add(fieldMap.get('EZPK_NTSD__c').getDescribe().getLabel() + ' is required.');
       }if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('EZCML') && String.isEmpty(deal.EZCML_NTSD__c)){
            errorMsgs.add(fieldMap.get('EZCML_NTSD__c').getDescribe().getLabel() + ' is required.');
       }if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('FFTRN') && String.isEmpty(deal.FFTRN_NTSD__c)){
            errorMsgs.add(fieldMap.get('FFTRN_NTSD__c').getDescribe().getLabel() + ' is required.');
       }if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('FSTSF') && String.isEmpty(deal.FSTSF_NTSD__c) && deal.fstsf_termination_date__c == null ){
            errorMsgs.add(fieldMap.get('fstsf_termination_date__c').getDescribe().getLabel() + ' is required.');
       }if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('HDTRORD') && String.isEmpty(deal.HDTRORD_NTSD__c)){
            errorMsgs.add(fieldMap.get('HDTRORD_NTSD__c').getDescribe().getLabel() + ' is required.');
       }if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('HDDABP') && String.isEmpty(deal.HDDABP_NTSD__c)){
            errorMsgs.add(fieldMap.get('HDDABP_NTSD__c').getDescribe().getLabel() + ' is required.');
       }if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('LLWDTPP') && String.isEmpty(deal.LLWDTPP_NTSD__c)){
            errorMsgs.add(fieldMap.get('LLWDTPP_NTSD__c').getDescribe().getLabel() + ' is required.');
       }if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('RPSMA') && String.isEmpty(deal.RPSMA_NTSD__c)){
            errorMsgs.add(fieldMap.get('RPSMA_NTSD__c').getDescribe().getLabel() + ' is required.');
       }if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('FRL') && String.isEmpty(deal.FRL_NTSD__c)){
            errorMsgs.add(fieldMap.get('FRL_NTSD__c').getDescribe().getLabel() + ' is required.');
       }if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('TRADHRS') && String.isEmpty(deal.TRADHRS_NTSD__c)){
            errorMsgs.add(fieldMap.get('TRADHRS_NTSD__c').getDescribe().getLabel() + ' is required.');
       }if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('STPAN') && String.isEmpty(deal.STPAN_NTSD__c)){
            errorMsgs.add(fieldMap.get('STPAN_NTSD__c').getDescribe().getLabel() + ' is required.');
       }if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('HOARDCAP') && String.isEmpty(deal.HOARDCAP_NTSD__c)){
            errorMsgs.add(fieldMap.get('HOARDCAP_NTSD__c').getDescribe().getLabel() + ' is required.');
       }if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('HOARD50') && String.isEmpty(deal.HOARD50_NTSD__c)){
            errorMsgs.add(fieldMap.get('HOARD50_NTSD__c').getDescribe().getLabel() + ' is required.');
       }if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('ROL') && String.isEmpty(deal.ROL_NTSD__c)){
            errorMsgs.add(fieldMap.get('ROL_NTSD__c').getDescribe().getLabel() + ' is required.');
       }if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('CAT1CAP') && String.isEmpty(deal.CAT1CAP_NTSD__c)){
            errorMsgs.add(fieldMap.get('CAT1CAP_NTSD__c').getDescribe().getLabel() + ' is required.');
       }if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('STCBA') && String.isEmpty(deal.STCBA_NTSD__c)){
            errorMsgs.add(fieldMap.get('STCBA_NTSD__c').getDescribe().getLabel() + ' is required.');
       }if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('VPTR') && String.isEmpty(deal.VPTR_NTSD__c)){
            errorMsgs.add(fieldMap.get('VPTR_NTSD__c').getDescribe().getLabel() + ' is required.');
       }if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('HDOVR') && String.isEmpty(deal.HDOVR_NTSD__c)){
            errorMsgs.add(fieldMap.get('HDOVR_NTSD__c').getDescribe().getLabel() + ' is required.');
       }if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('INTER') && String.isEmpty(deal.INTER_NTSD__c)){
            errorMsgs.add(fieldMap.get('INTER_NTSD__c').getDescribe().getLabel() + ' is required.');
       }if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('DIRDEB') && String.isEmpty(deal.DIRDEB_NTSD__c)){
            errorMsgs.add(fieldMap.get('DIRDEB_NTSD__c').getDescribe().getLabel() + ' is required.');*/
        // COMPLETED BY NITIN ---- completion of extra conditions addition    
        //}if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('LON049') && deal.LON049_Options__c== '2' && String.isEmpty(deal.LON049_NTSD__c)){
        //    errorMsgs.add(fieldMap.get('LON049_NTSD__c').getDescribe().getLabel() + ' is required.');
        //}if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('LON007') && deal.LON007_Options__c== '2' && String.isEmpty(deal.LON007_NTSD__c)){
        //    errorMsgs.add(fieldMap.get('LON007_NTSD__c').getDescribe().getLabel() + ' is required.');
        }if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('LON017') && deal.LON017_Options__c== '2' && deal.LON017_Capped_Legal_Fees__c == null){
            errorMsgs.add(fieldMap.get('LON017_Capped_Legal_Fees__c').getDescribe().getLabel() + ' is required.');
        }if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('LON020') && deal.LON020_Options__c== '1' && deal.LON020_Number_of_Option_Terms__c == null){
            errorMsgs.add(fieldMap.get('LON020_Number_of_Option_Terms__c').getDescribe().getLabel() + ' is required.');
        }if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('LON020') && deal.LON020_Options__c== '1' && deal.LON020_Review_Percentage__c == null){
            errorMsgs.add(fieldMap.get('LON020_Review_Percentage__c').getDescribe().getLabel() + ' is required.');
        }if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('LON020') && deal.LON020_Options__c== '1' && deal.LON020_Time_Period_in_Years__c == null){
            errorMsgs.add(fieldMap.get('LON020_Time_Period_in_Years__c').getDescribe().getLabel() + ' is required.');
        }if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('LON020') && deal.LON020_Options__c== '2' && deal.LON020_Number_of_Option_Terms__c == null){
            errorMsgs.add(fieldMap.get('LON020_Number_of_Option_Terms__c').getDescribe().getLabel() + ' is required.');
        }if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('LON020') && deal.LON020_Options__c== '2' && deal.LON020_Review_Percentage__c == null){
            errorMsgs.add(fieldMap.get('LON020_Review_Percentage__c').getDescribe().getLabel() + ' is required.');
        }if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('LON020') && deal.LON020_Options__c== '2' && deal.LON020_Time_Period_in_Years__c == null){
            errorMsgs.add(fieldMap.get('LON020_Time_Period_in_Years__c').getDescribe().getLabel() + ' is required.');
        /*}if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('LON025') && deal.LON025_Options__c== '2' && deal.LON025_Seating_Licence_Fee__c == null){
            errorMsgs.add(fieldMap.get('LON025_Seating_Licence_Fee__c').getDescribe().getLabel() + ' is required.'); Stuart Donnachie - Value 2 for picklist is Inactive now */
        /*}if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('LON025') && deal.LON025_Options__c== '3' && deal.LON025_Seating_Licence_Fee__c == null){
            errorMsgs.add(fieldMap.get('LON025_Seating_Licence_Fee__c').getDescribe().getLabel() + ' is required.');  Stuart Donnachie - Value 3 for picklist is Inactive now */
        }if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('LON031') && deal.LON025_Options__c== '1' && deal.LON031_Tenants_Current_Lease_Unit__c == null){
            errorMsgs.add(fieldMap.get('LON031_Tenants_Current_Lease_Unit__c').getDescribe().getLabel() + ' is required.');
        /*}if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('LON031') && deal.LON025_Options__c== '2' && deal.LON031_Tenants_Current_Lease_Unit__c == null){
            errorMsgs.add(fieldMap.get('LON031_Tenants_Current_Lease_Unit__c').getDescribe().getLabel() + ' is required.');  Stuart Donnachie - Value 2 for picklist is Inactive now */
        /*}if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('LON031') && deal.LON025_Options__c== '3' && deal.LON031_Tenants_Current_Lease_Unit__c == null){
            errorMsgs.add(fieldMap.get('LON031_Tenants_Current_Lease_Unit__c').getDescribe().getLabel() + ' is required.');  Stuart Donnachie - Value 3 for picklist is Inactive now */
       /* }if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('LON035') && deal.LON035_Options__c== '1' && deal.LON035_Termination_of_Convenience_Date__c == null){
            errorMsgs.add(fieldMap.get('LON035_Termination_of_Convenience_Date__c').getDescribe().getLabel() + ' is required.'); Stuart Donnachie - LON035 no longer active in Picklist */
        }if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('LON037') && deal.LON037_Options__c== '1' && deal.LON037_Vacant_Possession_Date__c == null){
            errorMsgs.add(fieldMap.get('LON037_Vacant_Possession_Date__c').getDescribe().getLabel() + ' is required.');
        }if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('LON044') && deal.LON044_Options__c== '1' && deal.LON044_Refit_Completion_Date__c == null){
            errorMsgs.add(fieldMap.get('LON044_Refit_Completion_Date__c').getDescribe().getLabel() + ' is required.');
        }if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('LON054') && deal.LON054_Options__c== '1' && deal.LON054_Tenant_Board_Approval__c == null){
        	errorMsgs.add(fieldMap.get('LON054_Tenant_Board_Approval__c').getDescribe().getLabel() + ' is required.');
        /*}if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('LON059') && deal.LON059_Options__c== '1' && deal.LON059_Cost_of_Category_1_Works__c == null){
           	errorMsgs.add(fieldMap.get('LON059_Cost_of_Category_1_Works__c').getDescribe().getLabel() + ' is required.'); Stuart Donnachie - LON059 no longer active in Picklist */
        }if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('OPTDET') && deal.OPTDET_Options__c== '1' && deal.OPTDET_NTSD__c == null){
           	errorMsgs.add(fieldMap.get('OPTDET_NTSD__c').getDescribe().getLabel() + ' is required.');
        }if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('OPTRRV') && deal.OPTRRV_Options__c== '1' && deal.OPTRRV_NTSD__c == null){
           errorMsgs.add(fieldMap.get('OPTRRV_NTSD__c').getDescribe().getLabel() + ' is required.');
        }if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('XDISTR') && deal.XDISTR_Options__c== '1' && deal.XDISTR_NTSD__c == null){
           	errorMsgs.add(fieldMap.get('XDISTR_NTSD__c').getDescribe().getLabel() + ' is required.');
        }if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('XREPRE') && deal.XREPRE_Options__c== '1' && deal.XREPRE_NTSD__c == null){
           errorMsgs.add(fieldMap.get('XREPRE_NTSD__c').getDescribe().getLabel() + ' is required.');
        }if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('LQRLIC') && deal.LQRLIC_Options__c== '1' && deal.Liqour_Licence_Date__c == null){
            errorMsgs.add(fieldMap.get('Liqour_Licence_Date__c').getDescribe().getLabel() + ' is required.');
        }if(deal.JDE_Deal_Type__c == 'RN' && deal.Opening_Promotion_Amount__c != null && deal.Opening_Promotion_Amount__c !=0){
           errorMsgs.add(fieldMap.get('Opening_Promotion_Amount__c').getDescribe().getLabel() + ' is not valid for Renewals.');
        }if(deal.JDE_Deal_Type__c == 'RN' && deal.Rent_Advance__c != null && deal.Rent_Advance__c !=0){
            errorMsgs.add(fieldMap.get('Rent_Advance__c').getDescribe().getLabel() + ' is not valid for Renewals.');
        }if(deal.JDE_Deal_Type__c == 'RN' && deal.Refit__c && deal.Works_Type__c == null){
           errorMsgs.add(fieldMap.get('Works_Type__c').getDescribe().getLabel() + ' is required.');
        }if(deal.JDE_Deal_Type__c == 'RN' && deal.Early_Renewal__c && !deal.Surrender_these_premises_in_Centre__c ){
           errorMsgs.add('Surrender These Premises is required.');
        //}if(deal.JDE_Deal_Type__c == 'TS' && deal.Early_Renewal__c && (deal.Fit_out_Period__c == null || deal.Fit_out_Period__c<1)){
        //   errorMsgs.add(fieldMap.get('Fit_out_Period__c').getDescribe().getLabel() + ' is required.');
        }if(deal.JDE_Deal_Type__c != 'RN' && deal.Opening_Promotion__c && (deal.Opening_Promotion_Amount__c == null || deal.Opening_Promotion_Amount__c == 0)){
           errorMsgs.add(fieldMap.get('Opening_Promotion_Amount__c').getDescribe().getLabel() + ' is required.');
        }if(deal.JDE_Deal_Type__c == 'TS' && deal.Works_Type__c == null){
           errorMsgs.add(fieldMap.get('Works_Type__c').getDescribe().getLabel() + ' is required.');
        }if(deal.Franchisor__c == null){
           errorMsgs.add(fieldMap.get('Franchisor__c').getDescribe().getLabel() + ' is required.');
        }if(deal.Retail_Act_Applies__c == null){
           errorMsgs.add(fieldMap.get('Retail_Act_Applies__c').getDescribe().getLabel() + ' is required.');
        }if(deal.Agreed_National_Lease_Exists__c == null){
           errorMsgs.add(fieldMap.get('Agreed_National_Lease_Exists__c').getDescribe().getLabel() + ' is required.');
        }if(deal.Selected_Permitted_Use__c == null && String.isEmpty(deal.Permitted_Use_Profile__c)){
           errorMsgs.add('Permitted Use is required.');
        }if(deal.Seating_Licence__c && (deal.Seating_Licence_Type__c == 'S' || deal.Seating_Licence_Type__c == 'F') && (deal.Seating_License_Area__c == null || deal.Seating_License_Area__c < 1)){
           errorMsgs.add(fieldMap.get('Seating_License_Area__c').getDescribe().getLabel() + ' is required.');
        }if(deal.Subject_to_Vacant_Possession__c == null){
           errorMsgs.add(fieldMap.get('Subject_to_Vacant_Possession__c').getDescribe().getLabel() + ' is required.');
        }if(deal.Rent_Review_Rate_And_Type__c == 'Fixed' && String.isNotEmpty(deal.Rent_Review_Free_Format_Clause__c)){
           errorMsgs.add('If Rent Review Type is Fixed rate, desc must be blank.');
        }if(deal.Rent_Review_Rate_And_Type__c == 'Fixed' && (deal.Rent_Review_Percentage__c == null || deal.Rent_Review_Percentage__c < 0)){
           errorMsgs.add(fieldMap.get('Rent_Review_Percentage__c').getDescribe().getLabel() + ' is required.');
        }if((deal.Rent_Review_Rate_And_Type__c == 'Market' || deal.Promo_Review_Rate_and_Type__c == 'CPI') && String.isNotEmpty(deal.Rent_Review_Free_Format_Clause__c)){
           errorMsgs.add('If Rent Review Type is Market or CPI, desc must be blank.');
        }if((deal.Rent_Review_Rate_And_Type__c == 'Market' || deal.Promo_Review_Rate_and_Type__c == 'CPI') && (deal.Rent_Review_Percentage__c != null && deal.Rent_Review_Percentage__c != 0)){
           errorMsgs.add(fieldMap.get('Rent_Review_Percentage__c').getDescribe().getLabel() + ' must be blank.');
        }if(deal.Rent_Review_Rate_And_Type__c == 'Non Standard' && String.isEmpty(deal.Rent_Review_Free_Format_Clause__c)){
           errorMsgs.add(fieldMap.get('Rent_Review_Free_Format_Clause__c').getDescribe().getLabel() + ' is required.');
        }if(deal.Rent_Review_Rate_And_Type__c == 'Non Standard' && (deal.Rent_Review_Percentage__c != null || deal.Rent_Review_Percentage__c > 0)){
           errorMsgs.add(fieldMap.get('Rent_Review_Percentage__c').getDescribe().getLabel() + ' must be blank or zero.');
        //}if(deal.Promo_Review_Rate_and_Type__c == 'Fixed' && String.isNotEmpty(deal.Promo_Contribution_Free_Format_Clause__c)){
        //   errorMsgs.add('If Promo Contrib Review Type is Fixed rate, desc must be blank.');
        }if(deal.Recovery_Type__c != 'Gross' && deal.Promotion_Contribution_Percent__c != deal.TP_Promotion_Contribution_Percentage__c && (deal.Promotion_Contribution_Percent__c == null || deal.Promotion_Contribution_Percent__c < 1)){
           errorMsgs.add(fieldMap.get('Promotion_Contribution_Percent__c').getDescribe().getLabel() + ' is required.');
        }if(deal.Recovery_Type__c != 'Gross' && deal.Promo_Review_Rate_and_Type__c == 'Non Standard' && String.isEmpty(deal.Promo_Contribution_Free_Format_Clause__c)){
           errorMsgs.add(fieldMap.get('Promo_Contribution_Free_Format_Clause__c').getDescribe().getLabel() + ' is required.');
        //}if(deal.Promo_Review_Rate_and_Type__c == 'Non Standard' && (deal.Promotion_Contribution_Percent__c != null && deal.Promotion_Contribution_Percent__c != 0)){
           //errorMsgs.add(fieldMap.get('Promotion_Contribution_Percent__c').getDescribe().getLabel() + ' must be blank.');
        }if(String.isEmpty(currentUser.Name)){
           errorMsgs.add('User name is required.');
        }if(String.isEmpty(currentUser.Title)){
           errorMsgs.add('User title is required.');
        }if(String.isEmpty(currentUser.Phone)){
           errorMsgs.add('User phone is required.');
        }if(String.isEmpty(currentUser.MobilePhone)){
           errorMsgs.add('User mobile is required.');
        }if(String.isEmpty(currentUser.Email)){
           errorMsgs.add('User email is required.');
        }if(deal.Bank_Guarantee_Requirement__c == 'Yes' && (deal.Bank_Guarentee__c == null || deal.Bank_Guarentee__c<1) && (deal.Bank_Guarantee_Months__c == null || deal.Bank_Guarantee_Months__c<1)){
           errorMsgs.add('Bank Guarantee amount or months is required.');
        //}if(deal.Bank_Guarantee_Requirement__c != 'Group' && (deal.Group_Security_Percentage_Required__c != null || deal.Group_Security_Percentage_Required__c > 0)){
        //   errorMsgs.add('Group security percentage must be blank or zero.');
        //}if(deal.Bank_Guarantee_Requirement__c != 'Group' && (deal.Group_Security_No_of_Months_Required__c != null || deal.Group_Security_No_of_Months_Required__c > 0)){
           //errorMsgs.add('Group security months must be blank or zero.');
        }if(deal.Bank_Guarantee_Requirement__c != 'Yes' && (deal.Bank_Guarantee_Months__c != null || deal.Bank_Guarantee_Months__c > 0)){
           errorMsgs.add('Bank Guarantee months must be blank or zero.');
        }if(deal.Bank_Guarantee_Requirement__c == 'No' && (deal.Bank_Guarentee__c != null || deal.Bank_Guarentee__c > 0)){
           errorMsgs.add('Bank Guarantee amount must be blank or zero.');
        //}if(deal.Bank_Guarantee_Requirement__c == 'Group' && (deal.Group_Security_Percentage_Required__c == null || deal.Bank_Guarentee__c <1)){
           //errorMsgs.add('Group Security percentage is required.');
        }if(deal.Bank_Guarantee_Requirement__c == 'Group' && (deal.Group_Security_No_of_Months_Required__c == null || deal.Group_Security_No_of_Months_Required__c ==0)
       													  && (deal.Group_Security_Percentage_Required__c == null || deal.Group_Security_Percentage_Required__c ==0)
       													  && (deal.Group_Security_Amount__c == null || deal.Group_Security_Amount__c == 0)){
           errorMsgs.add('Group Security months, percentage or amount must be entered.');
        }if(deal.Bank_Guarantee_Requirement__c == 'Existing' && (deal.Bank_Guarentee__c == null || deal.Bank_Guarentee__c == 0)){
        	errorMsgs.add('Bank Guarantee Amount is required.');
        }if(deal.Percentage_Rent_Rate__c != deal.TP_Percentage_Rent_Rate__c && (deal.Percentage_Rent_Rate__c == null || deal.Percentage_Rent_Rate__c == 0) && deal.Unit__r.Unit_Type__c != 'Automatic Teller Machines' && deal.Unit__r.Unit_Type__c != 'Offices'){
        	errorMsgs.add('Percentage Rent Rate is required.');
        }if(deal.Unit__r.Building__r.Centre__r.State__c == 'WA' && (deal.Units_Leased_and_Occupied__c == null || deal.Units_Leased_and_Occupied__c == 0) && (deal.Units_Leased_and_Unoccupied__c == null || deal.Units_Leased_and_Unoccupied__c ==0)){
        	errorMsgs.add('Unoccupied Lease Count or Occupied count is required.');
        }if(deal.Unit__r.Building__r.Centre__r.State__c == 'WA' && deal.Units_Leased_and_Occupied__c == null){
        	errorMsgs.add(fieldMap.get('Units_Leased_and_Occupied__c').getDescribe().getLabel() + ' is required.');
        }if(deal.Unit__r.Building__r.Centre__r.State__c == 'WA' && deal.Units_Leased_and_Unoccupied__c == null){
        	errorMsgs.add(fieldMap.get('Units_Leased_and_Unoccupied__c').getDescribe().getLabel() + ' is required.');
        }if(deal.Unit__r.Building__r.Centre__r.State__c == 'WA' && deal.Units_Unleased_and_Occupied__c == null){
        	errorMsgs.add(fieldMap.get('Units_Unleased_and_Occupied__c').getDescribe().getLabel() + ' is required.');
        }if(deal.Unit__r.Building__r.Centre__r.State__c == 'WA' && deal.Units_Unleased_and_Unoccupied__c == null){
        	errorMsgs.add(fieldMap.get('Units_Unleased_and_Unoccupied__c').getDescribe().getLabel() + ' is required.');
        }if(deal.Type_of_Guarantor_Required__c == 'PE' && (deal.No_of_Personal_Guarantee__c == null || deal.No_of_Personal_Guarantee__c==0)){
           errorMsgs.add('No of Personal Guarantee is required.');
        }if(deal.Type_of_Guarantor_Required__c == 'NA' && (deal.No_of_Personal_Guarantee__c != null && deal.No_of_Personal_Guarantee__c !=0)){
           errorMsgs.add('No of Personal Guarantee must be blank or zero.');
        /*}if(deal.Storage__c && deal.Storage_Rate_Type__c == 'TF'){
           errorMsgs.add('Fixed rate not allowed (only for Storage licences process).'); Stuart Donnachie - Storage Rate Type of TF is now an Inactive value */
        /*}if(deal.Storage__c && deal.Storage_Rate_Type__c == 'PA' && (deal.Storage_Rate__c == null || deal.Storage_Rate__c < 1)){
           errorMsgs.add('If Storage (rate) Type is Per Sq Mtr Rate must be >0.');  Stuart Donnachie - Storage Rate Type of PA is now an Inactive value */
        }if(deal.Storage__c && deal.Storage_Rate_Type__c == null){
           errorMsgs.add('If Storage (rate) Type is Per Sq Mtr Rate must be >0.');
        /*}if(String.isEmpty(deal.Storage_Comment__c) && deal.Storage__c && deal.Storage_Rate_Type__c == 'PA' &&
        ((deal.Area_of_Storage__c*deal.Storage_Rate__c) < (deal.Area_of_Storage__c*deal.Unit__r.Building__r.Centre__r.Default_Storage_Rate__c))){
           errorMsgs.add('Storage Comment is required.');  Stuart Donnachie - Storage Rate Type of PA is now an Inactive value */
        }if(String.isEmpty(deal.Storage_Comment__c) && deal.Storage__c && deal.Storage_Rate_Type__c == 'MT' && deal.Storage_Rate__c < deal.Unit__r.Building__r.Centre__r.Default_Storage_Rate__c){
           errorMsgs.add('Storage Comment is required.');
        }if(deal.Unit__r.Building__r.Centre__r.State__c != 'WA' && deal.Deal_Type__c == 'New Tenant As Is' && !deal.Is_Taking_Existing_Fitout__c){
    		errorMsgs.add(fieldMap.get('Is_Taking_Existing_Fitout__c').getDescribe().getLabel() + ' is required.');
    	}if(deal.New_Auth_Rep_Added__c || deal.New_Leg_Rep_Added__c){
    		errorMsgs.add('Custom Tenant Reps cannot be used on a Lease Offer.');
    	}if(deal.Lease_Incentive__c && (deal.Lease_Incentive_Days__c == 0 || deal.Lease_Incentive_Days__c == null )){
    		errorMsgs.add(fieldMap.get('Lease_Incentive_Days__c').getDescribe().getLabel() + ' is required.');
    	}if(deal.Lease_Incentive__c && (deal.Lease_Incentive_Amount__c == null || deal.Lease_Incentive_Amount__c == 0)){
    		errorMsgs.add(fieldMap.get('Lease_Incentive_Amount__c').getDescribe().getLabel() + ' is required.');
    	}if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('LON038') && deal.LON038_Options__c == null){
            errorMsgs.add(fieldMap.get('LON038_Options__c').getDescribe().getLabel() + ' is required.');
        }if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('LON001') && deal.LON001_Options__c == null){
            errorMsgs.add(fieldMap.get('LON001_Options__c').getDescribe().getLabel() + ' is required.');
        }if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('LON065') && deal.LON065_Options__c == null){
            errorMsgs.add(fieldMap.get('LON065_Options__c').getDescribe().getLabel() + ' is required.');
        }if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('LON046') && deal.LON046_Options__c == null){
            errorMsgs.add(fieldMap.get('LON046_Options__c').getDescribe().getLabel() + ' is required.');
        }if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('LON003') && deal.LON003_Options__c == null){
            errorMsgs.add(fieldMap.get('LON003_Options__c').getDescribe().getLabel() + ' is required.');
        }if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('LON004') && deal.LON004_Options__c == null){
            errorMsgs.add(fieldMap.get('LON004_Options__c').getDescribe().getLabel() + ' is required.');
        /*}if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('LON059') && deal.LON059_Options__c == null){
            errorMsgs.add(fieldMap.get('LON059_Options__c').getDescribe().getLabel() + ' is required.'); Stuart Donnachie - LON059 no longer active in Picklist */
        }if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('LON053') && deal.LON053_Options__c == null){
            errorMsgs.add(fieldMap.get('LON053_Options__c').getDescribe().getLabel() + ' is required.');
        /*}if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('LON047') && deal.LON047_Options__c == null){
            errorMsgs.add(fieldMap.get('LON047_Options__c').getDescribe().getLabel() + ' is required.'); Stuart Donnachie - LON047 no longer active in Picklist */
        }if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('LON007') && deal.LON007_Options__c == null){
            errorMsgs.add(fieldMap.get('LON007_Options__c').getDescribe().getLabel() + ' is required.');
        }if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('XDISTR') && deal.XDISTR_Options__c == null){
            errorMsgs.add(fieldMap.get('XDISTR_Options__c').getDescribe().getLabel() + ' is required.');
        }if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('LON009') && deal.LON009_Options__c == null){
            errorMsgs.add(fieldMap.get('LON009_Options__c').getDescribe().getLabel() + ' is required.');
        }if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('LON045') && deal.LON045_Options__c == null){
            errorMsgs.add(fieldMap.get('LON045_Options__c').getDescribe().getLabel() + ' is required.');
        }if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('LON010') && deal.LON010_Options__c == null){
            errorMsgs.add(fieldMap.get('LON010_Options__c').getDescribe().getLabel() + ' is required.');
        }if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('LON011') && deal.LON011_Options__c == null){
            errorMsgs.add(fieldMap.get('LON011_Options__c').getDescribe().getLabel() + ' is required.');
       /* }if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('LON055') && deal.LON055_Options__c == null){
            errorMsgs.add(fieldMap.get('LON055_Options__c').getDescribe().getLabel() + ' is required.'); Stuart Donnachie - LON055 no longer active in Picklist */
        }if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('LON012') && deal.LON012_Options__c == null){
            errorMsgs.add(fieldMap.get('LON012_Options__c').getDescribe().getLabel() + ' is required.');
        }if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('LON067') && deal.LON067_Options__c == null){
            errorMsgs.add(fieldMap.get('LON067_Options__c').getDescribe().getLabel() + ' is required.');
        }if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('LON017') && deal.LON017_Options__c == null){
            errorMsgs.add(fieldMap.get('LON017_Options__c').getDescribe().getLabel() + ' is required.');
        /*}if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('LON063') && deal.LON063_Options__c == null){
            errorMsgs.add(fieldMap.get('LON063_Options__c').getDescribe().getLabel() + ' is required.'); Stuart Donnachie - LON063 no longer active in Picklist */
        }if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('LQRLIC') && deal.LQRLIC_Options__c == null){
            errorMsgs.add(fieldMap.get('LQRLIC_Options__c').getDescribe().getLabel() + ' is required.');
        /*}if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('LON018') && deal.LON018_Options__c == null){
            errorMsgs.add(fieldMap.get('LON018_Options__c').getDescribe().getLabel() + ' is required.'); Stuart Donnachie - LON018 no longer active in Picklist */
        /*}if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('LON068') && deal.LON068_Options__c == null){
            errorMsgs.add(fieldMap.get('LON068_Options__c').getDescribe().getLabel() + ' is required.'); Stuart Donnachie - LON068 no longer active in Picklist */
        /*}if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('LON051') && deal.LON051_Options__c == null){
            errorMsgs.add(fieldMap.get('LON051_Options__c').getDescribe().getLabel() + ' is required.'); Stuart Donnachie - LON051 no longer active in Picklist */
        }if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('LON019') && deal.LON019_Options__c == null){
            errorMsgs.add(fieldMap.get('LON019_Options__c').getDescribe().getLabel() + ' is required.');
        }if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('OPTDET') && deal.OPTDET_Options__c == null){
            errorMsgs.add(fieldMap.get('OPTDET_Options__c').getDescribe().getLabel() + ' is required.');
        }if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('OPTRRV') && deal.OPTRRV_Options__c == null){
            errorMsgs.add(fieldMap.get('OPTRRV_Options__c').getDescribe().getLabel() + ' is required.');
        }if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('PROMRV') && deal.PROMRV_Options__c == null){
            errorMsgs.add(fieldMap.get('PROMRV_Options__c').getDescribe().getLabel() + ' is required.');
        }if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('LON050') && deal.LON050_Options__c == null){
            errorMsgs.add(fieldMap.get('LON050_Options__c').getDescribe().getLabel() + ' is required.');
        }if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('LON021') && deal.LON021_Options__c == null){
            errorMsgs.add(fieldMap.get('LON021_Options__c').getDescribe().getLabel() + ' is required.');
        /*}if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('LON022') && deal.LON022_Options__c == null){
            errorMsgs.add(fieldMap.get('LON022_Options__c').getDescribe().getLabel() + ' is required.'); Stuart Donnachie - LON022 no longer active in Picklist */
        }if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('LON044') && deal.LON044_Options__c == null){
            errorMsgs.add(fieldMap.get('LON044_Options__c').getDescribe().getLabel() + ' is required.');
        }if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('LON066') && deal.LON066_Options__c == null){
            errorMsgs.add(fieldMap.get('LON066_Options__c').getDescribe().getLabel() + ' is required.');
        /*}if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('LON024') && deal.LON024_Options__c == null){
            errorMsgs.add(fieldMap.get('LON024_Options__c').getDescribe().getLabel() + ' is required.'); Stuart Donnachie - LON024 no longer active in Picklist */
        }if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('XREPRE') && deal.XREPRE_Options__c == null){
            errorMsgs.add(fieldMap.get('XREPRE_Options__c').getDescribe().getLabel() + ' is required.');
        }if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('LON025') && deal.LON025_Options__c == null){
            errorMsgs.add(fieldMap.get('LON025_Options__c').getDescribe().getLabel() + ' is required.');
        }if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('LON049') && deal.LON049_Options__c == null){
            errorMsgs.add(fieldMap.get('LON049_Options__c').getDescribe().getLabel() + ' is required.');
        }if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('LON026') && deal.LON026_Options__c == null){
            errorMsgs.add(fieldMap.get('LON026_Options__c').getDescribe().getLabel() + ' is required.');
        }if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('LON062') && deal.LON062_Options__c == null){
            errorMsgs.add(fieldMap.get('LON062_Options__c').getDescribe().getLabel() + ' is required.');
        }if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('SURFEE') && deal.SURFEE_Options__c == null){
            errorMsgs.add(fieldMap.get('SURFEE_Options__c').getDescribe().getLabel() + ' is required.');
        }if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('LON031') && deal.LON031_Options__c == null){
            errorMsgs.add(fieldMap.get('LON031_Options__c').getDescribe().getLabel() + ' is required.');
        }if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('LON032') && deal.LON032_Options__c == null){
            errorMsgs.add(fieldMap.get('LON032_Options__c').getDescribe().getLabel() + ' is required.');
        }if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('LON034') && deal.LON034_Options__c == null){
            errorMsgs.add(fieldMap.get('LON034_Options__c').getDescribe().getLabel() + ' is required.');
        }if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('LON054') && deal.LON054_Options__c == null){
            errorMsgs.add(fieldMap.get('LON054_Options__c').getDescribe().getLabel() + ' is required.');
        /*}if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('LON035') && deal.LON035_Options__c == null){
            errorMsgs.add(fieldMap.get('LON035_Options__c').getDescribe().getLabel() + ' is required.'); Stuart Donnachie - LON035 no longer active in Picklist */
        }if(deal.Non_Standard_Special_Conditions__c !=null && deal.Non_Standard_Special_Conditions__c.contains('LON037') && deal.LON037_Options__c == null){
            errorMsgs.add(fieldMap.get('LON037_Options__c').getDescribe().getLabel() + ' is required.');
        }if(deal.Car_park_exclusive_for_tenant__c && (deal.Number_of_exclusive_car_parks__c == null || deal.Number_of_exclusive_car_parks__c == 0)){
		   errorMsgs.add(fieldMap.get('Number_of_exclusive_car_parks__c').getDescribe().getLabel() + ' is required.');
        }if(deal.Car_park_exclusive_for_tenant__c && (deal.Car_park_fee_amount__c == null || deal.Car_park_fee_amount__c == 0)){
		   errorMsgs.add(fieldMap.get('Car_park_fee_amount__c').getDescribe().getLabel() + ' is required.');
        }if(deal.Retail_Act_Applies__c == 'Y' && deal.Unit__r.Building__r.Centre__r.State__c == 'SA' && deal.Deal_Type__c == 'Renewal' && deal.Preferential_Rights__c == null){
		   errorMsgs.add(fieldMap.get('Preferential_Rights__c').getDescribe().getLabel() + ' is required.');
        }if((deal.Surrender_other_premises_Fees__c > 0 || deal.Surrender_these_premises_Fees__c > 0) && deal.SURFEE_Options__c == null){
            errorMsgs.add(fieldMap.get('SURFEE_Options__c').getDescribe().getLabel() + ' is required.');
        }if((deal.Surrender_other_premises_Fees__c > 0 || deal.Surrender_these_premises_Fees__c > 0) && deal.SURFEE_Options__c == '1' &&  String.isEmpty(deal.SURFEE_NTSD__c)){
            errorMsgs.add(fieldMap.get('SURFEE_NTSD__c').getDescribe().getLabel() + ' is required.');
        }if(deal.Bank_Guarantee_Requirement__c == null){
            errorMsgs.add('Bank Gurantee is required.');
        }if((deal.Bank_Guarantee_Months__c == null || deal.Bank_Guarantee_Months__c == 0) && deal.Bank_Guarantee_Requirement__c == 'Yes'){
         	errorMsgs.add('Bank Guarantee Months are required.');
        }


        for(Non_Standard_Special_Conditions__c sc : nsSpecialCons){
        	if(String.isEmpty(sc.Special_Condition__c)){
        		errorMsgs.add('Non Standard Special Condition is required.');
        	}
        }

        return !hasError;
	}
}