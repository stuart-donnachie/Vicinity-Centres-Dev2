/*
    Date        : 09-12-2016
    Project     : 
    Description : 
    
    Change History
    --------------      

*/
public with sharing class VC_Units_Controller {
	//--------------- FIELDS ----------------------
	private final Unit__c unit;
	private List<Opportunity> opportunities;
	public String debug {get; set;}
	public Opportunity Deal {get; set;}
	public Id SelectedOpportunity {get; set;} 
	public Boolean IsEdit {get; set;}
	public String pageName {get; set;}
	public String defaultTenantCABId {get; set;}
	public List<Landlord__c> landloards {get; set;}
	public VC_DealsCommon dealsCommon = new VC_DealsCommon();
    public Decimal ratesAndTaxesAmount;
    public Decimal outgoingsAmount;


	//--------------- CONSTRUCTORS ----------------
    public VC_Units_Controller(ApexPages.StandardController stdController) {
    	defaultTenantCABId = '276050';
    	
    	if (!Test.isRunningTest()) stdController.addFields(new List<String>{'Unit_Code__c'});  
    		
    	this.unit = (Unit__c)stdController.getRecord(); // Get Record

    	opportunities = [SELECT Name, Id FROM Opportunity // Query Deals
    					 WHERE Unit__c = :this.unit.Id
    					 AND API_Error__c = false 
    					 AND Is_Incomplete__c	= false
						 AND Is_Proceeded__c = false
						 AND StageName != 'Shop Opened'
						 AND StageName != 'Deal Not Proceeding'
    					 ];
    					 
        pageName =  String.valueof(ApexPages.currentPage().getUrl());
        
        if(ApexPages.currentPage().getParameters().get('Mode') == 'edit' || ApexPages.currentPage().getParameters().get('RecordType') == 'edit' || IsEdit == true || pageName.contains('VC_Unit_Edit') || String.valueOf(ApexPages.currentPage().getParameters().get('common.udd.actions.ActionsUtilORIG_URI')) != null){ // Check edit page
            IsEdit = true;
        }else{
            IsEdit = false;
        }
        
        //Query landloards
        landloards = [SELECT Name, Id FROM Landlord__c WHERE Building__c = :unit.Building__c];
        
		SetDeal();
		CalculateUnitRatesTaxesAndOutgoings();
        CalculateCurrentGrossRentExPromo();
       // CalculateBudgetedOccCostAtExpiry();
        CalculateForecastOccCostAtExpiry();
    }
    
    //--------------- METHODS ----------------
    // Query deal
   public void SetDeal(){
	   	if(unit.Preferred_Tenant__c != null){
		
			String objectName = 'Opportunity'; 
			String query = 'SELECT';
			Map<String, Schema.SObjectField> objectFields = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap();
		
			for(String s : objectFields.keySet()) {
			   query += ' ' + s + ',';
			}

			query += 'Account.Name,'; 
			query += 'Account.Sales_Category__c,'; 
			query += 'Account.Tenant_CABID__c,'; 
			query += 'Account.Tenant_Entity__c,'; 
			query += 'Account.Tenant_ACN__c,'; 
			query += 'Account.Trading_Group__c,'; 
		
			if (query.subString(query.Length()-1,query.Length()) == ','){
			    query = query.subString(0,query.Length()-1);
			}
		
			query += ' FROM ' + objectName;
			query += ' WHERE Id = \''+unit.Preferred_Tenant__c+'\' LIMIT 1'; 
			  
			Deal = database.query(query);
		
   		}else{
   			Deal = new Opportunity();
   		}
   		
    }
    
    //List of deals
    public List<SelectOption> OpportunitiesForSearch 
    {
        get 
        {
            OpportunitiesForSearch = new List<SelectOption>();

            OpportunitiesForSearch.add(new SelectOption('','--None--'));
            for(Opportunity tempOpp : opportunities)
            {
                OpportunitiesForSearch.add(new SelectOption(tempOpp.Id, tempOpp.Name));
            }

            return OpportunitiesForSearch;
        }
        set;
    }

	//Override Save
	public PageReference customSave() {
		PageReference viewPage = null;
		
        try {
        	Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
			Schema.SObjectType objSchema = schemaMap.get('Unit__c');
			Map<String, Schema.SObjectField> fieldMap = objSchema.getDescribe().fields.getMap();
        	
        	if(unit.Reconfig_Stage__c == null || unit.Reconfig_Stage__c=='')
        	{
        		unit.Is_Reconfig__c = false;
        	}
        	
        	unit.Last_Updated_By_User__c = system.now();

            String errorMessage = fieldMap.get('Current_Tenant_Planned_End__c').getDescribe().getLabel() + ', '+ fieldMap.get('Estimated_Rent_Start__c').getDescribe().getLabel() + ', '+ fieldMap.get('Estimated_Rent_End__c').getDescribe().getLabel() + ', '+ fieldMap.get('Estimated_Instruction_Date__c').getDescribe().getLabel()  + ', '+ fieldMap.get('Forecast_Base_Rent__c').getDescribe().getLabel() + ' and '+fieldMap.get('Current_Tenant_Strategy_on_Expiry__c').getDescribe().getLabel()+' are required';

            // Only want to run this validation if one of the values of the five fields have changed...
            // Perhaps grab the record and then compare the values with what is returned by the SOQL?
            Unit__c currentUnit = [SELECT Id, Current_Tenant_Planned_End__c,
                    Estimated_Rent_Start__c,
                    Estimated_Rent_End__c,
                    Estimated_Instruction_Date__c,
                    Forecast_Base_Rent__c,
                    Current_Tenant_Strategy_on_Expiry__c
                    FROM Unit__c
                    WHERE Id =: unit.Id];

            Boolean valueHasChanged = false;

            If(currentUnit.Current_Tenant_Planned_End__c != unit.Current_Tenant_Planned_End__c){
                valueHasChanged = true;
            }

            If(currentUnit.Estimated_Rent_Start__c != unit.Estimated_Rent_Start__c){
                valueHasChanged = true;
            }

            If(currentUnit.Estimated_Rent_End__c != unit.Estimated_Rent_End__c){
                valueHasChanged = true;
            }

            If(currentUnit.Estimated_Instruction_Date__c != unit.Estimated_Instruction_Date__c){
                valueHasChanged = true;
            }

            If((Integer) currentUnit.Forecast_Base_Rent__c != (Integer) unit.Forecast_Base_Rent__c){
                valueHasChanged = true;
            }

            If(currentUnit.Current_Tenant_Strategy_on_Expiry__c != unit.Current_Tenant_Strategy_on_Expiry__c){
                valueHasChanged = true;
            }

            // VALIDATIONS
            If(valueHasChanged){
                if(unit.Current_Tenant_Planned_End__c != null && (unit.Estimated_Instruction_Date__c == null || unit.Estimated_Rent_Start__c == null || unit.Estimated_Rent_End__c == null || unit.Forecast_Base_Rent__c == null || unit.Current_Tenant_Strategy_on_Expiry__c == null)){
                    ApexPages.Message myMsg = new ApexPages.Message(
                            ApexPages.Severity.ERROR, errorMessage);
                    ApexPages.addMessage(myMsg);
                }else if(unit.Estimated_Rent_Start__c != null && (unit.Estimated_Instruction_Date__c == null || unit.Current_Tenant_Planned_End__c == null || unit.Estimated_Rent_End__c == null || unit.Forecast_Base_Rent__c == null || unit.Current_Tenant_Strategy_on_Expiry__c == null)){
                    ApexPages.Message myMsg = new ApexPages.Message(
                            ApexPages.Severity.ERROR, errorMessage);
                    ApexPages.addMessage(myMsg);
                }else if(unit.Estimated_Rent_End__c != null && (unit.Estimated_Instruction_Date__c == null || unit.Current_Tenant_Planned_End__c == null || unit.Estimated_Rent_Start__c == null || unit.Forecast_Base_Rent__c == null || unit.Current_Tenant_Strategy_on_Expiry__c == null)){
                    ApexPages.Message myMsg = new ApexPages.Message(
                            ApexPages.Severity.ERROR, errorMessage);
                    ApexPages.addMessage(myMsg);
                }else if(unit.Estimated_Instruction_Date__c != null && (unit.Estimated_Rent_End__c == null || unit.Current_Tenant_Planned_End__c == null || unit.Estimated_Rent_Start__c == null || unit.Forecast_Base_Rent__c == null || unit.Current_Tenant_Strategy_on_Expiry__c == null)){
                    ApexPages.Message myMsg = new ApexPages.Message(
                            ApexPages.Severity.ERROR, errorMessage);
                    ApexPages.addMessage(myMsg);
                }else if(unit.Forecast_Base_Rent__c != null && (unit.Estimated_Instruction_Date__c == null || unit.Current_Tenant_Planned_End__c == null || unit.Estimated_Rent_Start__c == null || unit.Estimated_Rent_End__c == null || unit.Current_Tenant_Strategy_on_Expiry__c == null)){
                    ApexPages.Message myMsg = new ApexPages.Message(
                            ApexPages.Severity.ERROR, errorMessage);
                    ApexPages.addMessage(myMsg);
                }else if(unit.Current_Tenant_Strategy_on_Expiry__c != null && (unit.Forecast_Base_Rent__c == null || unit.Estimated_Instruction_Date__c == null || unit.Current_Tenant_Planned_End__c == null || unit.Estimated_Rent_Start__c == null || unit.Estimated_Rent_End__c == null)){
                    ApexPages.Message myMsg = new ApexPages.Message(
                            ApexPages.Severity.ERROR, errorMessage);
                    ApexPages.addMessage(myMsg);
                }else{
                    upsert unit;
                    IsEdit = false;
                    viewPage = new ApexPages.StandardController(unit).view();
                    viewPage.setRedirect(false);
                }
            }
        	else{
        		upsert unit;
            	IsEdit = false;
            	viewPage = new ApexPages.StandardController(unit).view();
            	viewPage.setRedirect(false); 
        	}
            
        } catch(System.DMLException e) {
            ApexPages.addMessages(e);
        }

        return viewPage;

    }
    
	//Override Edit
	public PageReference customEdit() {
		
		IsEdit = true;
        Pagereference viewPage = new PageReference(Global_Settings__c.getInstance().Base_URL__c + '/apex/VC_Unit?Id=' + unit.Id + '&Mode=edit');
        viewPage.setRedirect(false); 
        return viewPage;
    }
    
    public void refreshFields(){
    	if(!unit.Is_Reconfig__c){
    		unit.Reconfig_Stage__c = null;
    	}
    }
    
    public String getFinalUrl(){
    	String hostURL = URL.getSalesforceBaseURL().toExternalForm();
    	String serverId = hostURL.substring(10,14);
    	serverId = serverId.replace('.',''); 
    	String finalURL = serverId.trim();
    	
    	return finalURL;
    }
    
    //Create Deal
    public PageReference createDeal() {
    	PageReference pRef = null;
    	
    	try {
	    	Opportunity opp = new Opportunity();	
	    	opp.Name = 'Temp Deal - '+ Date.today();
	    	opp.CloseDate = Date.today() + 1;
	    	opp.StageName = 'Deal Builder';
	    	opp.Building__c = unit.Building__c;
	    	opp.Unit__c = unit.Id;
	    	opp.Is_Incomplete__c = true;
	    	opp.Area_of_premises_sqmt__c = unit.Area_of_Premises__c;
            opp.Recovery_Type__c = (unit.Unit_Code__c == '40OFF' || unit.Unit_Code__c == '45ATM' || unit.Unit_Code__c == '55OUT') ? 'Gross' : null; 
	    	
	    	if(landloards !=null && landloards.size() > 0){
	    		opp.Selected_Landlord__c = landloards[0].Id;
	    		
		    	insert opp;
		    	pRef = new PageReference(Global_Settings__c.getInstance().Base_URL__c + '/apex/VC_DealsVF?Id=' + opp.Id);
				pRef.setRedirect(true);
	    	}else{
	    		ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Error occured. Please contact the administrator.');
	    	}
    	 }catch(Exception e) {
    	 	ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Error occured. Please contact the administrator.');
        	ApexPages.addMessage(myMsg);
            ErrorLogHandler.log('Deal Creation Exception', e);
        }
        return pRef;
    }

	public void	CalculateUnitRatesTaxesAndOutgoings(){

		//First step
        Decimal outgoingsAmount;
        Decimal ratesAndTaxesAmount;

        if(calculateOutgoings() != null){
            outgoingsAmount = calculateOutgoings();
        }else{
            outgoingsAmount = 0;
        }

        if(calculateRatesAndTaxes() != null){
            ratesAndTaxesAmount = calculateRatesAndTaxes();
        }else{
            ratesAndTaxesAmount = 0;
        }

        System.debug('Outgoings Amount : ' + outgoingsAmount);
        System.debug('Rates And Taxes Amount : ' + ratesAndTaxesAmount);


        // I have changed this back from the Outgoings_Rates_Taxes_Amount_New__c to the original field as the value is apparently now uploaded according to JIRA VPDS-103
        this.unit.Outgoings_Rates_Taxes_Amount__c = outgoingsAmount + ratesAndTaxesAmount;

	}

    public void	CalculateCurrentGrossRentExPromo(){

        //First step
        Decimal baseRent;
        Decimal outgoingsRate;

        baseRent = this.unit.Current_Base_Rent_Amount__c;
        outgoingsRate = this.unit.Outgoings_Rates_Taxes_Amount_New__c;

        if (baseRent != null && outgoingsRate != null) {
            this.unit.Current_Gross_Rent_Ex_Promo_New__c = baseRent + outgoingsRate;
        }

        // If the Leasing defined unit category = Vacancy we make the Current Gross Rent (Ex Promo) = $0 VPDS-96
        if(this.unit.Current_Tenant_Lease_Status__c == 'Vacancy'){
            this.unit.Current_Gross_Rent_Ex_Promo_New__c = 0;
        }

    }

    public void	CalculateForecastOccCostAtExpiry(){

        if(this.unit.Forecast_Base_Rent__c != NULL && this.unit.Current_MAT__c != NULL && this.unit.Forecast_Base_Rent__c > 0){
            this.unit.Forecast_Occ_Cost_at_Expiry__c = (this.unit.Forecast_Base_Rent__c / this.unit.Current_MAT__c ) * 100;
        }

    }

	public Decimal calculateOutgoings(){
		String outgoingsCode;
		String outgoingsPrefix = 'CR';
		List<Centre_Outgoings__c> tempOutgoings;
		Integer recordCount;
        Date leaseCommencementDate = System.Date.today();

		String recoveryType = 'Net';
		String retailActApplies = 'Y';

		// Get Outgoings Code
		if(recoveryType == 'Net' && retailActApplies !=null){
			if (this.unit.Building__r.State__c == 'QLD'){
				outgoingsCode = 'NL';
			}else if (retailActApplies == 'Y' && (this.unit.Building__r.State__c == 'VIC'
					|| this.unit.Building__r.State__c == 'SA'))
			{
				outgoingsCode = 'NL';
			}else if (retailActApplies== 'Y' && this.unit.Building__r.State__c == 'WA')
			{
				outgoingsCode = 'MM';
			}else{
				outgoingsCode = 'N';
			}
		}

		System.debug('outgoingsCode D -'+outgoingsCode);

		if(String.isNotEmpty(outgoingsCode)){

			recordCount = checkRate(outgoingsPrefix, outgoingsCode, leaseCommencementDate);

			/*if(outgoingsPrefix == 'DV' && recordCount == 0){
                // Not too sure that I need this logic here with regard to the DV prefix...
				outgoingsPrefix = 'CR';

				recordCount = checkRate(outgoingsPrefix, outgoingsCode, leaseCommencementDate);
			}*/

			if(recordCount == 0){
				tempOutgoings = queryOutgoingsCrit(outgoingsPrefix+outgoingsCode);
                System.debug('xxx queryOutgoingsCrit - ' + outgoingsPrefix+outgoingsCode);
				if(tempOutgoings.size() > 0){
					recordCount = checkRate(outgoingsPrefix, outgoingsCode, tempOutgoings[0].Critical_Date__c);
				}
			}

		}
		return outgoingsAmount;
	}

    public Decimal calculateRatesAndTaxes(){

        System.debug(String.valueOf('IN RATES AND TAXES'));
        ratesAndTaxesAmount = 0;

        if (this.unit.Building__r.State__c == 'VIC'){
            System.debug(String.valueOf('IN VIC'));
            Decimal rates = 0;

            List<Rates_and_Taxes__c> tempRates;
            String [] rateType = new String[]{'ANCR', 'ANPG', 'ANWR'};

                for (String rtype : rateType) {
                    System.debug(String.valueOf('RATE TYPE: ' + rtype));
                    tempRates = [SELECT Name, Id, Amenity_Code__c, Rate__c
                    FROM Rates_and_Taxes__c
                    WHERE Business_Unit__c = :this.unit.Building__r.Business_Unit__c // need to include this on VF_Units page I reckon
                    AND Unit__c = :this.unit.Id
                    AND Begin_Date__c = :dealsCommon.getFiscalYear(System.today())
                    AND Log_Class__c = 'AS'
                    AND Log_Level__c = 'U'
                    AND Amenity_Code__c = :rtype
                    ];

                    if(tempRates.size()==0){
                        System.debug(String.valueOf('RATE TYPE: ' + rtype));
                        tempRates = [SELECT Name, Id, Amenity_Code__c, Rate__c
                        FROM Rates_and_Taxes__c
                        WHERE Business_Unit__c = :this.unit.Building__r.Business_Unit__c // need to include this on VF_Units page I reckon
                        AND Unit__c = :this.unit.Id
                        AND Begin_Date__c = :dealsCommon.getFiscalYear(System.today())
                        AND Log_Class__c = 'AB'
                        AND Log_Level__c = 'U'
                        AND Amenity_Code__c = :rtype
                        ];
                    }
                    System.debug(String.valueOf('Rate: ' + rates));

                    for(Rates_and_Taxes__c rt: tempRates){
                        System.debug(String.valueOf('Rate: ' + rates));
                        rates += rt.Rate__c;
                    }

                }

                ratesAndTaxesAmount = rates + 0;

        }else if(this.unit.Building__r.Centre__r.Name == 'Northgate'){ // need to include this on VF_Units page I reckon
            System.debug(String.valueOf('IN NEW NORTHGATE'));

            List<Centre_Outgoings__c> tempOuts;
            List<Rates_and_Taxes__c> tempsRT;
            Integer rCount = 0;

            Decimal grossMonthlyAAV;
            Decimal newCentreRate;
            Decimal annualisedAAV;

            String outsCode = 'CRNR';

            tempOuts = queryOutgoings(outsCode, System.today());
            rCount = tempOuts.size();

            if(tempOuts.size()> 0){

                System.debug('IN THE NORTHGATE QUERY');
                System.debug(String.valueOf('FOUND A RATE'));
                tempsRT = queryNorthgateOutgoings(System.today());
                rCount = tempsRT.size();

                System.debug('rCount B -'+rCount);

                if(tempsRT.size() > 0){

                    grossMonthlyAAV = tempsRT[0].Rate__c * (tempOuts[0].Rate__c/10000)/12;
                    newCentreRate = tempsRT[0].Rate__c * (tempOuts[0].Rate__c/10000)/this.unit.Area_of_premises__c;
                    annualisedAAV = grossMonthlyAAV * 12; //Prash Brackets


                    System.debug('RATE1: ' + grossMonthlyAAV);
                    System.debug('RATE2: ' + newCentreRate);
                    System.debug('RATE3: ' + annualisedAAV);

                    ratesAndTaxesAmount = annualisedAAV; //SET RATES AND TAXES

                }else{
                    ratesAndTaxesAmount = 0;
                }
                System.debug('objOpp.Rates_and_Taxes_Amount__c -'+ratesAndTaxesAmount);

            }else{
                ratesAndTaxesAmount = 0;
            }
        }
        else{
            System.debug(String.valueOf('KICK OUT NON NORTHGATE OR NON VIC'));
            ratesAndTaxesAmount = 0;
        } //end vic+northgate statement

        return ratesAndTaxesAmount;
    }//end rates and taxes


    public Integer checkRate(String outgoingsPrefix, String outgoingsCode, Date outgoingsDate){
        List<Centre_Outgoings__c> tempOutgoings;
        List<Rates_and_Taxes__c> tempOutgoingsRT;
        Decimal ntRate1;
        Decimal ntRate2;
        Decimal ntRate3;
        Integer rCount = 0;

        if(outgoingsPrefix+outgoingsCode == 'CRNL' && this.unit.Building__r.State__c == 'VIC'
                && dealsCommon.getFiscalYear(outgoingsDate) < dealsCommon.getFiscalYear(Date.today())){ // Capt Mgt Fee
            outgoingsCode = 'ML';
        }

        tempOutgoings = queryOutgoings(outgoingsPrefix+outgoingsCode,outgoingsDate);

        if(tempOutgoings.size() > 0 ){
            outgoingsAmount = tempOutgoings[0].Rate__c * this.unit.Area_of_Premises__c;
            rCount = tempOutgoings.size();
        }

        if(outgoingsCode == 'N' && tempOutgoings.size()==0){ // Fall back to NL
            tempOutgoings = queryOutgoings(outgoingsPrefix+'NL',outgoingsDate);

            if(tempOutgoings.size() > 0){
                outgoingsAmount = tempOutgoings[0].Rate__c * this.unit.Area_of_Premises__c;
                rCount = tempOutgoings.size();
            }
        }

        return rCount;

    }

    public List<Centre_Outgoings__c> queryOutgoings(String outgoingsCode, Date outgoingsDate){
        return [SELECT Name, Id, Amenity_Code__c, Rate__c, Critical_Date__c
        FROM Centre_Outgoings__c
        WHERE Business_Unit__c = :this.unit.Building__r.Business_Unit__c
        AND Amenity_Code__c = :outgoingsCode
        AND Begin_Date__c = :dealsCommon.getFiscalYear(outgoingsDate)
        ];
    }

    public List<Rates_and_Taxes__c> queryNorthgateOutgoings(Date outgoingsDate){

        System.debug('AA - ' + this.unit.Building__r.Business_Unit__c);
        System.debug('BB - ' + this.unit.Id);

        return [SELECT Name, Id, Amenity_Code__c, Rate__c
        FROM Rates_and_Taxes__c
        WHERE Business_Unit__c = :this.unit.Building__r.Business_Unit__c
        AND Amenity_Code__c = 'AAVB'
        AND Begin_Date__c = :dealsCommon.getFiscalYear(outgoingsDate)
        AND Unit__c = :this.unit.Id
        AND Log_Class__c = 'EP'
        ];

    }

    public List<Centre_Outgoings__c> queryOutgoingsCrit(String outgoingsCode){
        return [SELECT Name, Id, Amenity_Code__c, Rate__c, Critical_Date__c
        FROM Centre_Outgoings__c
        WHERE Business_Unit__c = :this.unit.Building__r.Business_Unit__c
        AND Amenity_Code__c = :outgoingsCode
        AND Critical_Date__c < :dealsCommon.getFiscalYear(System.today())
        ORDER BY Critical_Date__c DESC
        ];
    }


}