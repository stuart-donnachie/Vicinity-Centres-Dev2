/*
    Date        : 16-09-2016
    Project     : Lease Management System
    Description : REST API call to fetch the on demand tenant profile
    
    Change History
    --------------      

*/
public with sharing class RestAPI {
	
	public String oppVal{get;set;}
	public List<Opportunity> lstOpp{get;set;}
	public String paramTenant_Key{get;set;}
	public String paramContractNo{get;set;}
	public String paramUnitType{get;set;}
	public String paramBuildingId{get;set;}
	
	// Extension variables
	private ApexPages.StandardController ctrl; 
    
    // Unique label corresponding to the continuation
    public String oauthRequestLabel;
    public String apiRequestLabel;

    // Result of callout
    public String result {get;set;}
        
    public RestAPI(ApexPages.StandardController ctrl) {
    	this.ctrl = ctrl;
    }
    
    // Action method
    public Object startRequest() {
		// Create continuation with a timeout
		Continuation con = new Continuation(20);
		// Set callback method
		con.continuationMethod = 'processOauthToken';
      
      	try{
			// Create callout request
			HttpRequest req = new HttpRequest();
			req.setMethod('POST');
			req.setEndpoint('callout:Vicinity_Apigee_Prod');
			req.setTimeout(30000);
	      
			// Add callout request to continuation
			this.oauthRequestLabel = con.addHttpRequest(req);
      	}catch(exception ex){
      		ErrorLogHandler.log('Tenant Profile on demand fetch failure - Opportunity '+ oppVal,ex);
			System.debug('++++++++++++++++++++++ ERROR'+ ex);
      	}
      	
		// Return the continuation
		return con;  
    }
    
    // Callback method 
    public Object processOauthToken() {
		System.debug('processing token response');   
		// Get the response by using the unique label
		HttpResponse response = Continuation.getResponse(this.oauthRequestLabel);
		// New continuation for the actual API call
		Continuation con = new Continuation(20);
		con.continuationMethod = 'processFinalResponse';
		
		try {
		Map<String, Object> jsonResponse = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
		String accessToken = jsonResponse.containsKey('access_token') ? String.valueOf(jsonResponse.get('access_token')) : '';
		// TODO: Logic for refresh token if exists

		// Setting up the parameteres
      
		lstOpp = new List<Opportunity>();
		lstOpp = [Select Id, Account.Tenant_Key__c,Contract_Number__c,Unit_Code__c From Opportunity Where Id = :oppVal];
					
		if(lstOpp.size()>0)	{											
			paramTenant_Key = lstOpp[0].Account.Tenant_Key__c;
			paramContractNo = lstOpp[0].Contract_Number__c;
			paramUnitType = lstOpp[0].Unit_Code__c;
			
			System.debug('*** Opportunity data for parameters *** ' + lstOpp);
			System.debug('*** API Parameters ***' + paramTenant_Key + paramContractNo + paramUnitType);	
		}
			// Create callout request
			HttpRequest req = new HttpRequest();
			req.setMethod('GET');
			req.setEndpoint(Global_Settings__c.getInstance().API_URL_2__c+'/tenant_profiles/'+paramTenant_Key+'/'+paramContractNo+'/'+paramUnitType);
			req.setHeader('Authorization', 'Bearer ' + accessToken);
			req.setTimeout(30000);

			// Add callout request to continuation
			this.apiRequestLabel = con.addHttpRequest(req);
      	}catch(exception ex) {
      		ErrorLogHandler.log('Tenant Profile on demand oauth fetch failure - Opportunity '+ oppVal,ex);
			System.debug('++++++++++++++++++++++ ERROR'+ ex);
      	}

		// Return the continuation
		return con;
    }
    

	public Object processFinalResponse() {
		Boolean parseStatus = true;
		
		String hostURL = URL.getSalesforceBaseURL().toExternalForm();
    	String serverId = hostURL.substring(10,14);
    	serverId = serverId.replace('.',''); 
    	String finalURL = serverId.trim();
		
		try{
			System.debug('Inside final callback: ' + oppVal);
			HttpResponse response = Continuation.getResponse(this.apiRequestLabel);
			if (hasRedirect(response)) {
				return handleRedirect(response);
			}
			
			// Updating the opportunity with the tenant profile details
	        parseStatus = parseResponse(response.getBody());
	        
	        if(!parseStatus){
	        	Opportunity OppErr = [Select Id, API_Error__c From Opportunity where Id = :oppVal];
        		OppErr.API_Error__c = true;
        		update OppErr;
        		ErrorLogHandler.log('Tenant profile update failure', String.valueOf(response.getBody()));
	        }
	        
	        System.debug(' -------- '+String.valueOf(response.getBody()));
	        System.debug(' -------- parseStatus '+String.valueOf(parseStatus));
	        

		}catch(exception ex) {
      		ErrorLogHandler.log('Tenant Profile on demand oauth fetch failure - Opportunity '+ oppVal,ex);
			System.debug('++++++++++++++++++++++ ERROR'+ ex);
      	}
    	
    	if(parseStatus){
			//Pagereference pRef = new PageReference('https://' + finalURL +'.lightning.force.com/one/one.app?isdtp=p1#/sObject/' + oppVal + '/view');
			Pagereference pRef = new PageReference(Global_Settings__c.getOrgDefaults().Base_URL__c +'/one/one.app?isdtp=p1#/sObject/' + oppVal + '/view');
			pRef.setRedirect(true);
			return pRef;
    	}else
    	{
    		//ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error!');
            //ApexPages.addMessage(myMsg);
    		return null;
    	}
	}
	
	public Boolean hasRedirect(HttpResponse res) {
		if (res.getStatusCode() >= 300 && res.getStatusCode() <= 307 && res.getStatusCode() != 306) {
			String loc = res.getHeader('Location');
			if (loc != null) {
				System.debug('has redirect: ' + loc);
				return true;
			}
		}
		return false;
	}
	
	public Object handleRedirect(HttpResponse res) {
		System.debug('handling redirect');
		Continuation con = new Continuation(20);
      	con.continuationMethod = 'processFinalResponse';
      
      	// Create callout request
      	HttpRequest req = new HttpRequest();
      	req.setMethod('GET');
      	req.setEndpoint(res.getHeader('Location'));
      	req.setTimeout(30000);
      
      	// Add callout request to continuation
      	this.apiRequestLabel = con.addHttpRequest(req);
      	return con;	
	}
	
	public Boolean parseResponse(String jsonResponse) {
		JSONParser parser = JSON.createParser(jsonResponse);
		//ErrorLogHandler.log('Tenant LOG', String.valueOf(jsonResponse));
		System.debug('jsonResponse --' + String.valueOf(jsonResponse));
		Boolean returnVal = false;
		
		while(parser.nextToken() != null) { 
            if(parser.getCurrentToken() == JSONToken.START_ARRAY) {
            	System.debug('parser ++ ' +String.valueOf(parser.getCurrentToken()));
            	       
            	while(parser.nextToken() != null) {
                	if(parser.getCurrentToken() == JSONToken.START_OBJECT) {
                        tenant_profileWrapper tp = (tenant_profileWrapper)parser.readValueAs(tenant_profileWrapper.class);
                        
                        Opportunity objUpdateOpp = [Select Id, Deal_Type__c, Refit__c From Opportunity where Id = :oppVal];

                        if(tp.design_review_fees_at_commencement == 'Yes')
							objUpdateOpp.Design_Review_Fees_At_Commencement__c = true;
							
						if(tp.contract_number != null && tp.contract_number != '')
							objUpdateOpp.Contract_Number__c = tp.contract_number;
						
						if(tp.percentage_rent_category != null)	{
							if(tp.percentage_rent_category == 'BANK')
								objUpdateOpp.Percentage_Rent_Category__c = 'Banks/ATMs';
							else if(tp.percentage_rent_category == 'CAFE')
								objUpdateOpp.Percentage_Rent_Category__c = 'Specialty Food/Cafes';
							else if(tp.percentage_rent_category == 'CHAR')
								objUpdateOpp.Percentage_Rent_Category__c = 'Charities';
							else if(tp.percentage_rent_category == 'FOOD')
								objUpdateOpp.Percentage_Rent_Category__c = 'Fresh Food';
							else if(tp.percentage_rent_category == 'GOVSRV')
								objUpdateOpp.Percentage_Rent_Category__c = 'Government Services';
							else if(tp.percentage_rent_category == 'LIQUOR')
								objUpdateOpp.Percentage_Rent_Category__c = 'Liquor';
							else if(tp.percentage_rent_category == 'PHARM')
								objUpdateOpp.Percentage_Rent_Category__c = 'Pharmacies';
							else if(tp.percentage_rent_category == 'REST')
								objUpdateOpp.Percentage_Rent_Category__c = 'Restaurants (250 sqm+)';
							else if(tp.percentage_rent_category == 'RETAIL')
								objUpdateOpp.Percentage_Rent_Category__c = 'General Retail';
							else if(tp.percentage_rent_category == 'SERV')
								objUpdateOpp.Percentage_Rent_Category__c = 'Other Services';
							else if(tp.percentage_rent_category == 'TATTRV')
								objUpdateOpp.Percentage_Rent_Category__c = 'Tatts and Travel Agents';
							else if(tp.percentage_rent_category == 'TOBACC')
								objUpdateOpp.Percentage_Rent_Category__c = 'Tobacconists';
						}
							
						if(tp.parent_guarantee == 'Yes')
							objUpdateOpp.Parent_Guarentee__c = true;
						
						if(tp.rent_review_type != null)	{
							if(tp.rent_review_type == '01')
								objUpdateOpp.Rent_Review_Rate_And_Type__c = 'Fixed';
							else if(tp.rent_review_type == '02')
								objUpdateOpp.Rent_Review_Rate_And_Type__c = 'Market';
							else if(tp.rent_review_type == '03')
								objUpdateOpp.Rent_Review_Rate_And_Type__c = 'CPI';
							else if(tp.rent_review_type == '04')
								objUpdateOpp.Rent_Review_Rate_And_Type__c = 'Non Standard';
							else if(tp.rent_review_type == 'NA')
								objUpdateOpp.Rent_Review_Rate_And_Type__c = 'Not Applicable';
						}
							
						if(tp.hoarding_at_commencement == 'Yes')
							objUpdateOpp.Hoarding_At_Commencement__c = true;

						if(tp.permitted_use != null && tp.permitted_use != '')
							objUpdateOpp.Permitted_Use_Profile__c = tp.permitted_use;
							
						if(tp.tenant_key =='15995'){ 
							objUpdateOpp.Permitted_Use_Profile__c = null;
						}	
						
						if(tp.unit_type != null && tp.unit_type != '')
							objUpdateOpp.Unit_Type__c = tp.unit_type;
							
						if(tp.group_security == '1')	
							objUpdateOpp.Group_Security__c = true;
						
						if(tp.bank_guarantee_required != null && tp.bank_guarantee_required != '')	
							objUpdateOpp.Bank_Guarantee_Requirement__c = tp.bank_guarantee_required;
						
						if(tp.personal_guarantee == 'Yes')	
							objUpdateOpp.Personal_Guarantee__c = true;
						
						if(tp.bank_guarantee_months != null && tp.bank_guarantee_months != '')	
							objUpdateOpp.Bank_Guarantee_Months__c = Integer.valueOf(tp.bank_guarantee_months);
						
						if(tp.no_of_personal_guarantees != null && tp.no_of_personal_guarantees != '')	
							objUpdateOpp.No_of_Personal_Guarantee__c = Decimal.valueOf(tp.no_of_personal_guarantees);
							
						if(tp.no_of_personal_guarantees != null && tp.no_of_personal_guarantees != '' && Decimal.valueOf(tp.no_of_personal_guarantees) < 1){
							objUpdateOpp.Personal_Guarantee__c = false;
							objUpdateOpp.No_of_Personal_Guarantee__c = null;
						}	
						
						if(tp.promo_review_type != null){	
							if(tp.promo_review_type == '01')
								objUpdateOpp.Promo_Review_Rate_and_Type__c = 'Fixed';
							else if(tp.promo_review_type == '02')
								objUpdateOpp.Promo_Review_Rate_and_Type__c = 'Non Standard';
							else if(tp.promo_review_type == '03')
								objUpdateOpp.Promo_Review_Rate_and_Type__c = 'Not Applicable';
							else if(tp.promo_review_type == 'NA')
								objUpdateOpp.Promo_Review_Rate_and_Type__c = 'Other';
						}
							
						if(tp.percentage_rent_rate != null && tp.percentage_rent_rate != '')
							objUpdateOpp.Percentage_Rent_Rate__c = Decimal.valueOf(tp.percentage_rent_rate);
							
						if(tp.rent_review_rate != null && tp.rent_review_rate != '')
							objUpdateOpp.Rent_Review_Percentage__c = Decimal.valueOf(tp.rent_review_rate);
							
						if(tp.promo_review_rate != null && tp.promo_review_rate != '')
							objUpdateOpp.Promo_ReviewRate__c = Integer.valueOf(tp.promo_review_rate);  
							
						if(tp.promo_contribution_percentage != null && tp.promo_contribution_percentage != '')
							objUpdateOpp.Promotion_Contribution_Percent__c = Decimal.valueOf(tp.promo_contribution_percentage);    
  		
			    		if(objUpdateOpp.Deal_Type__c =='Renewal' && !objUpdateOpp.Refit__c){
			    			objUpdateOpp.Hoarding_At_Commencement__c = false;
			    			objUpdateOpp.Design_Review_Fees_At_Commencement__c = false;
			    		} 
			    		
			    		if(!String.isEmpty(tp.national_tenant_flag)){
			    			objUpdateOpp.National_Retailer__c = tp.national_tenant_flag;
			    		}
                        
                        try {
                        	System.debug('*** Opportunity with tenant profile details *** ' + objUpdateOpp);
                        	objUpdateOpp.API_Error__c = false;
                        	update objUpdateOpp;
                        } catch (exception e) {
                        	ErrorLogHandler.log('Tenant profile update failure', e);
                        }
                        returnVal = true;
                	}
            	}
            	
        	}
        	
        }	
        
        return returnVal;
	}
	
	public class tenant_profileWrapper {
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
		public String no_of_personal_guarantees;
		public String promo_review_type;
		public String percentage_rent_rate;
		public String rent_review_rate;
		public String tenant_key;
		public String promo_review_rate;
		public String promo_contribution_percentage;
		public String national_tenant_flag;
		
	}
}