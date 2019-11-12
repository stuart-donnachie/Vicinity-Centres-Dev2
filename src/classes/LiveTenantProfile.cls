public with sharing class LiveTenantProfile {
	private Opportunity deal;

	public LiveTenantProfile(Opportunity deal){
		this.deal = deal;
	}

    public String getToken() {
		HttpRequest request = new HttpRequest();
		request.setMethod('POST');
		request.setEndpoint('callout:Vicinity_Apigee_Prod');
		request.setHeader('Content-Length', '0');
		request.setTimeout(120000);

		Http http = new Http();
		HttpResponse response = http.send(request);
		Map<String, Object> jsonResponse = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
		return String.valueOf(jsonResponse.get('access_token'));
	}

	public String getTenantProfile(String token){
		String filter = 'tenant_key in [' + deal.Tenant_Key__c+ ']';


		HttpRequest request = new HttpRequest();
		request.setMethod('GET');
		request.setHeader('Authorization', 'Bearer ' + token);
		// Old call
		//request.setEndpoint(Global_Settings__c.getInstance().API_URL_3__c+'/tenant-profile-daily-changes/'+deal.Tenant_Key__c+'/'+deal.Contract_Number__c+'/'+deal.Unit_Code__c+'/'+deal.Unit__r.Building__r.Building_Key__c);

		// New Call
		// We now call the GET /v3/temp-tenants/temp-tenant-profiles API method using a filter and passing in the Deal Tenant Key
		//request.setEndpoint(Global_Settings__c.getInstance().API_URL_3__c+'/temp-tenant-profiles-daily-changes/'+deal.Tenant_Key__c+'/'+deal.Contract_Number__c+'/'+deal.Unit_Code__c+'/'+deal.Unit__r.Building__r.Building_Key__c);
		request.setEndpoint(Global_Settings__c.getInstance().API_URL_4__c+'/temp-tenants/temp-tenant-profiles?filter='+filter);

		System.debug('Tenant Profile Call - ' + Global_Settings__c.getInstance().API_URL_4__c+'/temp-tenants/temp-tenant-profiles?filter='+filter);


		request.setTimeout(120000);

		Http http = new Http();
		HttpResponse response = http.send(request);

		if (hasRedirect(response)) {
			response = handleRedirect(response);
		}

		System.debug(String.valueOf(request.toString()));
		System.debug(String.valueOf(response.getBody()));

		return String.valueOf(response.getBody());
	}
	/*
	public Map<String, String> percentageRentCategoryMap{
		get{
			Map<String, String> tempMap = new Map<String, String> ();
			tempMap.put('BANK', 'Banks/ATMs');
			tempMap.put('CAFE', 'Specialty Food/Cafes');
			tempMap.put('CHAR', 'Charities');
			tempMap.put('FOOD', 'Fresh Food');
			tempMap.put('GOVSRV', 'Government Services');
			tempMap.put('LIQUOR', 'Liquor');
			tempMap.put('PHARM', 'Pharmacies');
			tempMap.put('REST', 'Restaurants (250 sqm+)');
			tempMap.put('RETAIL', 'General Retail');
			tempMap.put('SERV', 'Other Services');
			tempMap.put('TATTRV', 'Tatts and Travel Agents');
			tempMap.put('TOBACC', 'Tobacconists');
			return tempMap;
		}
	}
	*/
	public Map<String, String> rentReviewTypeMap{
		get{
			Map<String, String> tempMap = new Map<String, String> ();
			tempMap.put('01', 'Fixed');
			tempMap.put('02', 'Market');
			tempMap.put('03', 'CPI');
			tempMap.put('04', 'Non Standard');
			tempMap.put('NA', 'Not Applicable');

			return tempMap;
		}
	}

	public Map<String, String> promoReviewTypeMap{
		get{
			Map<String, String> tempMap = new Map<String, String> ();
			tempMap.put('01', 'Fixed');
			tempMap.put('02', 'Non Standard');
			tempMap.put('03', 'Not Applicable');
			tempMap.put('NA', 'Other');

			return tempMap;
		}
	}

	public Boolean ynFormatter(String value){
		return (value == 'Yes' ? true : false);
	}

	public Boolean binaryFormatter(String value){
		return (value == '1' ? true : false);
	}

	public String stringNullChecker(String value){
		return (String.isNotEmpty(value) ? value : null);
	}

	public String stringNoNullChecker(String value){
		return (String.isNotEmpty(value) ? value : 'No');
	}

	public Integer integerNullChecker(String value){
		return (String.isNotEmpty(value) ? Integer.valueOf(value) : null);
	}

	public Integer integerZeroChecker(String value){
		return (String.isNotEmpty(value) && Integer.valueOf(value) != 0  ? Integer.valueOf(value) : null);
	}

	public Decimal decimalZeroChecker(String value){
		return (String.isNotEmpty(value) && Decimal.valueOf(value) != 0 ? Decimal.valueOf(value) : null);
	}

	public Decimal decimalNullChecker(String value){
		return (String.isNotEmpty(value) ? Decimal.valueOf(value) : null);
	}

	public String setProperCase(String str){
	    String upDatedstr = '';
	    if(String.isNotEmpty(str)){
	        for(String s : str.split(';') ){
	            if(upDatedstr == '')
	                upDatedstr = s.substring(0,1).toUpperCase()+''+s.substring(1, s.length()).toLowerCase();
	            else
	                upDatedstr += ';'+ s.substring(0,1).toUpperCase()+''+s.substring(1, s.length()).toLowerCase();
	        }
		}
	    return upDatedstr;
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

	public HttpResponse handleRedirect(HttpResponse res) {
      	HttpRequest req = new HttpRequest();
      	req.setMethod('GET');
      	req.setEndpoint(res.getHeader('Location'));

		Http http = new Http();
		HttpResponse response = http.send(req);

		return response;
	}

	public Boolean updateDeal(String tenantProfileJSON){

		Boolean returnValue = false;

		if(!String.isEmpty(tenantProfileJSON) && tenantProfileJSON != '[]'){
			JSONParser parser = JSON.createParser(tenantProfileJSON);

			while(parser.nextToken() != null) {
	            if(parser.getCurrentToken() == JSONToken.START_ARRAY) {

	            	while(parser.nextToken() != null) {
	                	if(parser.getCurrentToken() == JSONToken.START_OBJECT) {
	                        TenantProfileWrapper tp = (TenantProfileWrapper)parser.readValueAs(TenantProfileWrapper.class);

	                        deal.Design_Review_Fees_At_Commencement__c = ynFormatter(tp.design_review_fees_at_commencement);
							//deal.Contract_Number__c = stringNullChecker(tp.contract_number);
							deal.Percentage_Rent_Category__c = tp.percentage_rent_category;
							deal.Parent_Guarentee__c = ynFormatter(tp.parent_guarantee);
							deal.Rent_Review_Rate_And_Type__c = (tp.rent_review_type != null) ? rentReviewTypeMap.get(tp.rent_review_type) : null;
							deal.Hoarding_At_Commencement__c = ynFormatter(tp.hoarding_at_commencement);
							deal.Permitted_Use_Profile__c = (String.isNotEmpty(tp.permitted_use) && tp.tenant_code !='276050' ? tp.permitted_use : null);
							//deal.Unit_Type__c = stringNullChecker(tp.unit_type);
							//deal.Group_Security__c = binaryFormatter(tp.group_security);
							deal.Group_Security_Percentage_Required__c = decimalZeroChecker(tp.group_security);
							deal.TP_Group_Security_Percentage_Required__c = decimalNullChecker(tp.group_security);	//TP
							deal.Bank_Guarantee_Requirement__c = stringNoNullChecker(setProperCase(tp.bank_guarantee_required));
							deal.TP_Bank_Guarantee_Requirement__c = stringNoNullChecker(setProperCase(tp.bank_guarantee_required)); // TP
							deal.Personal_Guarantee__c = ynFormatter(tp.personal_guarantee);
							deal.Bank_Guarantee_Months__c = integerZeroChecker(tp.bank_guarantee_months);
							deal.TP_Bank_Gaurantee_Months__c = integerNullChecker(tp.bank_guarantee_months);//TP
							deal.Promo_ReviewRate__c = decimalZeroChecker(tp.promo_review_rate);
							deal.Group_Security_Amount__c = decimalZeroChecker(tp.group_security_amount);
							deal.TP_Group_Security_Amount__c = decimalNullChecker(tp.group_security_amount); // TP
							deal.Percentage_Rent_Rate__c = decimalZeroChecker(tp.percentage_rent_rate);
							deal.TP_Percentage_Rent_Rate__c = decimalZeroChecker(tp.percentage_rent_rate); //TP
							deal.Rent_Review_Percentage__c = decimalZeroChecker(tp.rent_review_rate);
							//deal.No_of_Personal_Guarantee__c = decimalNullChecker(tp.no_of_personal_guarantees);
							deal.Promotion_Contribution_Percent__c = decimalZeroChecker(tp.promo_contribution_percentage);
							deal.TP_Promotion_Contribution_Percentage__c = decimalZeroChecker(tp.promo_contribution_percentage); //TP
							deal.Promo_Review_Rate_and_Type__c = (tp.promo_review_type != null) ? promoReviewTypeMap.get(tp.promo_review_type) : null;
							deal.National_Retailer__c = stringNullChecker(tp.national_tenant_flag);
							deal.Agreed_National_Lease_Exists__c = stringNullChecker(tp.national_tenant_flag);
							deal.Type_of_Guarantor_Required__c = stringNullChecker(tp.type_of_guarantor_required);
							deal.TP_Type_of_Guarantor_Required__c = stringNullChecker(tp.type_of_guarantor_required); // TP
							deal.Publicly_Listed_Company__c = stringNullChecker(tp.public_listed_company);
							//deal.No_of_Personal_Guarantee__c = integerZeroChecker(tp.no_of_guarantees_required);
							deal.TP_No_of_Personal_Guarantee__c = integerZeroChecker(tp.no_of_guarantees_required); // TP
							deal.Group_Security_No_of_Months_Required__c = integerZeroChecker(tp.group_security_no_of_months_required);
							deal.TP_Group_Security_Months_Required__c = integerNullChecker(tp.group_security_no_of_months_required); // TP
							deal.Franchisor__c = stringNullChecker(tp.franchisor);
							deal.Hoarding_At_Commencement__c = ynFormatter(tp.hoardings_at_commencement);
							deal.No_of_Personal_Guarantee__c = integerZeroChecker(tp.no_of_guarantees_required);
							deal.Profile_Updated_Date__c = System.now();

							//if(String.isNotEmpty(tp.no_of_personal_guarantees) && Decimal.valueOf(tp.no_of_personal_guarantees) < 1){
							//	deal.Personal_Guarantee__c = false;
							//	deal.No_of_Personal_Guarantee__c = null;
							//}

				    		if(deal.Deal_Type__c =='Renewal' && !deal.Refit__c){
				    			deal.Hoarding_At_Commencement__c = false;
				    			deal.Design_Review_Fees_At_Commencement__c = false;
				    		}

							deal.API_Error__c = false;
							returnValue = true;
	                	}
	            	}

	        	}

	        }

            //try {
            //	update deal;
            //} catch (exception e) {
            //	ErrorLogHandler.log('Tenant profile update exception #1 - Exception', e);
            //	ErrorLogHandler.log('Tenant profile update exception #2 - JSON', tenantProfileJSON);
            //	ErrorLogHandler.log('Tenant profile update exception #3 - Record', String.valueOf(deal));
            //}
		}

		if(!returnValue){
			ErrorLogHandler.log('Tenant profile update failure #1 - JSON', tenantProfileJSON);
        	ErrorLogHandler.log('Tenant profile update failure #2 - Record', String.valueOf(deal));
		}

		return returnValue;
	}

	public class TenantProfileWrapper {
		public String design_review_fees_at_commencement;
		public String code;
		public String contract_number;
		public String percentage_rent_category;
		public String building_key;
		public String timestamp;
		public String parent_guarantee;
		public String rent_review_type;
		public String hoarding_at_commencement;
		public String permitted_use;
		public String unit_type;
		public String group_security;
		public String bank_guarantee_required;
		public String personal_guarantee;
		public String bank_guarantee_months;
		public String hoardings_at_commencement;
		public String no_of_personal_guarantees;
		public String promo_review_type;
		public String percentage_rent_rate;
		public String rent_review_rate;
		public String tenant_key;
		public String tenant_code;
		public String promo_review_rate;
		public String promo_contribution_percentage;
		public String national_tenant_flag;
		public String type_of_guarantor_required;
		public String public_listed_company;
		public String no_of_guarantees_required;
		public String group_security_no_of_months_required;
		public String franchisor;
		public String group_security_amount;

	}
}