public without sharing class VC_DealsCommon {
    public Opportunity objOpp{get;set;}
    public Decimal ratesAndTaxesAmount;
    public Decimal outgoingsAmount;

    public VC_DealsCommon() {
        objOpp = new Opportunity();
    }

    public VC_DealsCommon(Opportunity objOpp) {
        this.objOpp = objOpp;
    }

    public VC_DealsCommon(ApexPages.StandardController stdController) {
        this.objOpp = (Opportunity)stdController.getRecord();
    }

    public Opportunity getDeal(Id oppId){
        String objectName = 'Opportunity';
        String query = 'SELECT';
        Map<String, Schema.SObjectField> objectFields = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap();

        for(String s : objectFields.keySet()) {
        	//if(s != 'TDP_Creation_Error__c' &&
        	//   s != 'TDP_Created__c'&&
        	//   s != 'EOI_Documents__c' &&
        	//   s != 'LON_Requested__c'
        	//   ){
            	query += ' ' + s + ',';
        	//}
        }
        query += 'Owner.Address_Number__c,';
        query += 'Owner.Manager.Address_Number__c,';
        query += 'Owner.Name,';
        query += 'Owner.Title,';
        query += 'Owner.MobilePhone,';
        query += 'Owner.Email,';
        query += 'Owner.Phone,';
        query += 'Account.Name,';
        query += 'Account.Tenant_CABID__c,';
        query += 'Account.Tenant_ACN__c,';
        query += 'Account.ABN__c,';
        query += 'Unit__r.Current_Tenant_Lease_Status__c,';
        query += 'Unit__r.Fitout_Contribution_Budget__c,';
        query += 'Unit__r.Future_Tenant_Landlord_Works_Budget__c,';
        query += 'Centre__r.Name,';
        query += 'Centre__r.Is_DFO__c,';
        query += 'Unit__r.Building__r.Centre_Key__c,';
        query += 'Building__r.Name,';
        query += 'Unit__r.Building__r.Name,';
        query += 'Unit__r.Name,';
        query += 'Unit__r.Building__c,';
        query += 'Unit__r.Is_Active__c,';
        query += 'Unit__r.Unit_Type__c,';
        query += 'Unit__r.Area_of_Premises__c,';
        query += 'Unit__r.Estimated_Rent_Start__c,';
        query += 'Unit__r.Centre__c,';
        query += 'Unit__r.Is_Building_Active__c,';
        query += 'Unit__r.Building__r.Centre__r.Contract_Number__c,';
        query += 'Unit__r.Centre__r.Name,';
        query += 'Unit__r.Centre__r.State__c,';
        query += 'Unit__r.Building__r.Centre__c,';
        query += 'Unit__r.Building__r.Centre__r.Is_DFO__c,';
        query += 'Unit__r.Building__r.Centre__r.Name,';
        query += 'Unit__r.Building__r.State__c,';
        query += 'Unit__r.Building__r.Building_Key__c,';
        query += 'Unit__r.Building__r.Centre__r.State__c,';
        query += 'Unit__r.Unit_Code__c,';
        query += 'Unit__r.Centre__r.Is_DFO__c,';
        query += 'Unit__r.Building__r.Centre__r.Default_Hoardings_Rate__c,';
        query += 'Unit__r.Building__r.Centre__r.Default_Storage_Rate__c,';
        query += 'Unit__r.Building__r.Centre__r.Design_Review_Fees__c,';
        query += 'Unit__r.Building__r.Building_Code__c,';
        query += 'Unit__r.Centre__r.Conditional_Cap__c,';
        query += 'Unit__r.Building__r.Centre__r.Conditional_Cap__c,';
        query += 'Account.Tenant_Entity__c,';
        query += 'Account.Legal_Name__c,';
        query += 'LON002_Tenants_Previous_Lease_Unit__r.Name,';
        query += 'LON031_Tenants_Current_Lease_Unit__r.Name,';
        query += 'Unit__r.Building__r.Centre__r.Centre_Code__c,';
        query += 'Unit__r.Budget_Base_Rent_This_FY__c,';
        query += 'Surrender_other_premises_Unit__r.Name,';
        query += 'Surrender_these_premises_Unit__r.Name,';
        query += 'Building__r.Business_Unit__c,';
        query += 'Unit__r.Business_Unit__c,';
        query += 'Selected_Landlord__r.Name,';
        query += 'Selected_Permitted_Use__r.Name,';
        query += 'Selected_Permitted_Use__r.Category_Code__c,';
        query += 'Selected_Permitted_Use__r.Code_Notes__c,';
        query += 'Selected_Permitted_Use__r.Code_Type__c,';
        query += 'Selected_Permitted_Use__r.Code_Type_Description__c,';
        query += 'Selected_Permitted_Use__r.Code_Value__c,';
        query += 'Unit__r.Building__r.Centre__r.Lease_Admin__r.Address_Number__c,';
        query += 'Unit__r.Building__r.Hartnett_Asset__c,';
        query += 'Unit__r.Floor_Level__c,';


        if (query.subString(query.Length()-1,query.Length()) == ','){
            query = query.subString(0,query.Length()-1);
        }

        query += ' FROM ' + objectName;
        query += ' WHERE Id = \''+oppId+'\'';

        return database.query(query);
    }


    public List<Centre_Outgoings__c> queryOutgoings(String outgoingsCode, Date outgoingsDate){
        return [SELECT Name, Id, Amenity_Code__c, Rate__c, Critical_Date__c
                                                            FROM Centre_Outgoings__c
                                                            WHERE Business_Unit__c = :objOpp.Building__r.Business_Unit__c
                                                            AND Amenity_Code__c = :outgoingsCode
                                                            AND Begin_Date__c = :getFiscalYear(outgoingsDate)
                                                            ];
    }

    public List<Rates_and_Taxes__c> queryNortgateOutgoings(Date outgoingsDate){
        return [SELECT Name, Id, Amenity_Code__c, Rate__c
                                                            FROM Rates_and_Taxes__c
                                                            WHERE Business_Unit__c = :objOpp.Building__r.Business_Unit__c
                                                            AND Amenity_Code__c = 'AAVB'
                                                            AND Begin_Date__c = :getFiscalYear(outgoingsDate)
                                                            AND Unit__c = :objOpp.Unit__c
                                                            AND Log_Class__c = 'EP'
                                                            ];
    }

    public List<Centre_Outgoings__c> queryOutgoingsCrit(String outgoingsCode){
        return [SELECT Name, Id, Amenity_Code__c, Rate__c, Critical_Date__c
                                                            FROM Centre_Outgoings__c
                                                            WHERE Business_Unit__c = :objOpp.Building__r.Business_Unit__c
                                                            AND Amenity_Code__c = :outgoingsCode
                                                            AND Critical_Date__c < :getFiscalYear(objOpp.Estimated_Lease_Commencement_Date__c)
                                                            ORDER BY Critical_Date__c DESC
                                                            ];
    }

  public Integer checkRate(String outgoingsPrefix, String outgoingsCode, Date outgoingsDate){
        System.debug('outgoingsPrefix A-'+outgoingsPrefix);
        System.debug('outgoingsCode A -'+outgoingsCode);
        System.debug('outgoingsDate A -'+outgoingsDate);

        List<Centre_Outgoings__c> tempOutgoings;
        List<Rates_and_Taxes__c> tempOutgoingsRT;
        Decimal ntRate1;
        Decimal ntRate2;
        Decimal ntRate3;
        Integer rCount = 0;


        if(objOpp.Area_of_premises_sqmt__c == null){ //Area of prem fix
            objOpp.Area_of_premises_sqmt__c = objOpp.Unit__r.Area_of_Premises__c;
        }

        System.debug('outgoingsCode B -'+outgoingsCode);

        if(outgoingsPrefix+outgoingsCode == 'CRNL' && objOpp.Unit__r.Building__r.State__c == 'VIC'
                && getFiscalYear(outgoingsDate) < getFiscalYear(Date.today())){ // Capt Mgt Fee
                outgoingsCode = 'ML';
        }

        System.debug('outgoingsCode C -'+outgoingsCode);

        if(objOpp.Unit__r.Building__r.Centre__r.Name == 'Paradise Centre'){ //TEMP FIX FOR PARADISE CENTRE. Sets outs to 0, and opens up field for modification.

        outgoingsAmount = 0;

        }else{
            tempOutgoings = queryOutgoings(outgoingsPrefix+outgoingsCode,outgoingsDate);

            System.debug('xxx : ' + outgoingsPrefix + ' - ' + outgoingsCode + ' - ' +outgoingsDate);


            if(tempOutgoings.size() > 0 ){
                outgoingsAmount = tempOutgoings[0].Rate__c * objOpp.Area_of_premises_sqmt__c;
                rCount = tempOutgoings.size();
            }


            System.debug('rCount C -'+rCount);
        }

        if(outgoingsCode == 'N' && tempOutgoings.size()==0){ // Fall back to NL
            tempOutgoings = queryOutgoings(outgoingsPrefix+'NL',outgoingsDate);

            if(tempOutgoings.size() > 0){
                outgoingsAmount = tempOutgoings[0].Rate__c * objOpp.Area_of_premises_sqmt__c;
                rCount = tempOutgoings.size();
            }
            System.debug('rCount D -'+rCount);
        }


        System.debug('rCount E -'+rCount);

        return rCount;

    }

    public Decimal calculateOutgoings(){
        String outgoingsCode;
        String outgoingsPrefix = 'CR';
        List<Centre_Outgoings__c> tempOutgoings;
        Integer recordCount;
        outgoingsAmount = 0;

        // Get Outgoings Code
        if(objOpp.Recovery_Type__c == 'Net' && objOpp.Retail_Act_Applies__c !=null){
            if (objOpp.Unit__r.Building__r.State__c == 'QLD'){
                outgoingsCode = 'NL';
            }else if (objOpp.Retail_Act_Applies__c == 'Y' && (objOpp.Unit__r.Building__r.State__c == 'VIC'
                                                            || objOpp.Unit__r.Building__r.State__c == 'SA'))
            {
                outgoingsCode = 'NL';
            }else if (objOpp.Retail_Act_Applies__c == 'Y' && objOpp.Unit__r.Building__r.State__c == 'WA')
            {
                outgoingsCode = 'MM';
            }else{
                outgoingsCode = 'N';
            }
        }

        System.debug('outgoingsCode D -'+outgoingsCode);

        if(String.isNotEmpty(outgoingsCode)){ // If outgoings code is not empty
            //tempOutgoings = queryOutgoings(outgoingsPrefix+outgoingsCode,objOpp.Estimated_Lease_Commencement_Date__c); // Get the record

            //if(tempOutgoings.size() > 0){
                /*
                if(tempOutgoings[0].Remark__c == 'OUTS'){ // Check for overrides
                    outgoingsCode = tempOutgoings[0].Centre_Override_Code__c;
                }
                */
            //}

            if(objOpp.Dev_Budget__c){ // Check for dev budget and change prefix
                    outgoingsPrefix = 'DV';
            }

            System.debug('outgoingsPrefix B -'+outgoingsPrefix);
            System.debug('outgoingsCode -'+outgoingsCode);
            System.debug('objOpp.Estimated_Lease_Commencement_Date__c -'+objOpp.Estimated_Lease_Commencement_Date__c);

            recordCount = checkRate(outgoingsPrefix, outgoingsCode, objOpp.Estimated_Lease_Commencement_Date__c);

            if(outgoingsPrefix == 'DV' && recordCount == 0){
                outgoingsPrefix = 'CR';

                recordCount = checkRate(outgoingsPrefix, outgoingsCode, objOpp.Estimated_Lease_Commencement_Date__c);

                System.debug('recordCount A -'+recordCount);
            }

            System.debug('outgoingsPrefix C -'+outgoingsPrefix);

            if(recordCount == 0){
                tempOutgoings = queryOutgoingsCrit(outgoingsPrefix+outgoingsCode);

                System.debug('tempOutgoings.size A -'+tempOutgoings.size());

                if(tempOutgoings.size() > 0){
                        System.debug('outgoingsPrefix -'+outgoingsPrefix);
                        System.debug('outgoingsCode -'+outgoingsCode);
                        System.debug('tempOutgoings[0].Critical_Date__c -'+tempOutgoings[0].Critical_Date__c);

                        recordCount = checkRate(outgoingsPrefix, outgoingsCode, tempOutgoings[0].Critical_Date__c);

                        System.debug('recordCount B-'+recordCount);
                }
            }

        }
        System.debug('stu2 - ' + outgoingsAmount);

        return outgoingsAmount;
    }

    public Date getFiscalYear(Date dateField){
        System.debug(String.valueOf('IN FY CONVERSION'));
            if(dateField != null && dateField.month() <= 6){
            System.debug(String.valueOf('DATE SET:' + Date.newinstance(dateField.year() - 1, 07, 01)));

            return Date.newinstance(dateField.year() - 1, 07, 01);
        }else if (dateField != null && dateField.month() >= 7){

            System.debug(String.valueOf('DATE SET:' + Date.newinstance(dateField.year(), 07, 01)));
            return Date.newinstance(dateField.year(), 07, 01);
        }else{

            System.debug(String.valueOf('DATE SET:' + Date.newinstance(0, 0, 0)));
            return Date.newinstance(0, 0, 0);
        }

    }

public Decimal calculateRatesAndTaxes(){

        System.debug(String.valueOf('IN RATES AND TAXES'));
        ratesAndTaxesAmount = 0;

        if (objOpp.Unit__r.Building__r.State__c == 'VIC'){
        System.debug(String.valueOf('IN VIC'));
        Decimal rates = 0;

        List<Rates_and_Taxes__c> tempRates;
        String [] rateType = new String[]{'ANCR', 'ANPG', 'ANWR'};
        if(objOpp.Estimated_Lease_Commencement_Date__c != null){
        for (String rtype : rateType) {
        System.debug(String.valueOf('RATE TYPE: ' + rtype));
            tempRates = [SELECT Name, Id, Amenity_Code__c, Rate__c
                         FROM Rates_and_Taxes__c
                         WHERE Business_Unit__c = :objOpp.Building__r.Business_Unit__c
                         AND Unit__c = :objOpp.Unit__c
                         AND Begin_Date__c = :getFiscalYear(objOpp.Estimated_Lease_Commencement_Date__c)
                         AND Log_Class__c = 'AS'
                         AND Log_Level__c = 'U'
                         AND Amenity_Code__c = :rtype
                        ];

                if(tempRates.size()==0){
                System.debug(String.valueOf('RATE TYPE: ' + rtype));
                 tempRates = [SELECT Name, Id, Amenity_Code__c, Rate__c
                             FROM Rates_and_Taxes__c
                             WHERE Business_Unit__c = :objOpp.Building__r.Business_Unit__c
                             AND Unit__c = :objOpp.Unit__c
                             AND Begin_Date__c = :getFiscalYear(objOpp.Estimated_Lease_Commencement_Date__c)
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

    }


        }else if(objOpp.Unit__r.Building__r.Centre__r.Name == 'Northgate'){
            System.debug(String.valueOf('IN NEW NORTHGATE'));

        List<Centre_Outgoings__c> tempOuts;
        List<Rates_and_Taxes__c> tempsRT;
        Integer rCount = 0;

        Decimal grossMonthlyAAV;
        Decimal newCentreRate;
        Decimal annualisedAAV;

        String outsCode = 'CRNR';

            tempOuts = queryOutgoings(outsCode,objOpp.Estimated_Lease_Commencement_Date__c);
            rCount = tempOuts.size();

            System.debug('rCount A -'+rCount);
            System.debug('OUTS CODE: ' + outsCode);
            System.debug('ELCD: ' + objOpp.Estimated_Lease_Commencement_Date__c);
            System.debug('CONV DATE: ' + getFiscalYear(objOpp.Estimated_Lease_Commencement_Date__c));

            if(tempOuts.size()> 0){

            System.debug('IN THE NORTHGATE QUERY');
            System.debug(String.valueOf('FOUND A RATE'));
                tempsRT = queryNortgateOutgoings(objOpp.Estimated_Lease_Commencement_Date__c);
                rCount = tempsRT.size();

                System.debug('rCount B -'+rCount);

                if(tempsRT.size() > 0){

                    grossMonthlyAAV = tempsRT[0].Rate__c * (tempOuts[0].Rate__c/10000)/12;
                    newCentreRate = tempsRT[0].Rate__c * (tempOuts[0].Rate__c/10000)/objOpp.Area_of_premises_sqmt__c;
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

 public static void updateDealKey(List<Opportunity> opps){
		for(Opportunity opp : opps)
	    	{
	    		String uniqueNumber = opp.Record_Number__c;

	    		Integer leftKey = Integer.valueOf(uniqueNumber.left(5));
	    		String rightKey = uniqueNumber.right(5);

	    		Integer tempLeftKey = leftKey;
	    		Integer tempLeftKeyCount = 0;
	    		Integer tempLeftKeyReminder = 0;

	    		String firstAlpha = 'A';
	    		String secondAlpha = 'A';

	    		Map<Integer, String> charMap = new Map<Integer, String> {1 => 'A',2 => 'B',3 => 'C',4 => 'D',5 => 'E',6 => 'F',7 => 'G',8 => 'H',9 => 'I',10 => 'J',
	    																11 => 'K',12 => 'L',13 => 'M',14 => 'N',15 => 'O',16 => 'P',17 => 'Q',18 => 'R',19 => 'S',20 => 'T',
	    																21 => 'U',22 => 'V',23 => 'W',24 => 'X',25 => 'Y',26 => 'Z'
	    																};

	    		if(leftKey < 26){
	    			secondAlpha = charMap.get(leftKey + 1);
	    		}else{
	    			tempLeftKeyCount = leftKey/26;
	    			tempLeftKeyReminder = Math.mod(leftKey,26);

	    			firstAlpha = charMap.get(tempLeftKeyCount + 1);
	    			secondAlpha = charMap.get(tempLeftKeyReminder + 1);
	    		}

    			opp.Deal_Key__c	= firstAlpha + secondAlpha + rightKey;

    			//opp.Deal_Key__c	= 'AX' + rightKey;
		}
 }


} //end class