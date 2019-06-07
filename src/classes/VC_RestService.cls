/*
Date        : 09-12-2016
Project     : VC
Description : Rest Web Service API

Change History
--------------

*/
@RestResource(urlMapping='/api/*')
global without sharing class VC_RestService {

    /*
        * Method: Get
        * Request Body -
        * Request Params - content=unit | deal, request=latest_schedule_modified_date | latest_sf_modified_date | latest_api_modified_date
        * Respone Body (Success) - { "last_modified_date": "1967-02-20 10:00:00", "status": true }
        * Response Body (Fail) - { "message": "RestResourceException:[]: Invalid content request", "status": false }
    */
    @HttpGet
    global static void doGet() {
        String content = RestContext.request.params.containsKey('content') ? RestContext.request.params.get('content') : '';
        String request = RestContext.request.params.containsKey('request') ? RestContext.request.params.get('request') : '';
        Map<String, Object> returnMessage = new Map<String, Object>();

        try{
        if(content=='deal' && request=='latest_sf_modified_date'){

            Opportunity[] opps = [SELECT Name, Id, LastModifiedDate FROM Opportunity ORDER BY LastModifiedDate DESC LIMIT 1];

            returnMessage.put('status', true);
            returnMessage.put('last_modified_date', String.valueOf((opps.size() > 0) ? opps[0].LastModifiedDate : Date.today().addYears(-50)));

            RestContext.response.statusCode = 200;
        }else if(content=='unit' && request=='latest_sf_modified_date'){

            Unit__c[] units = [SELECT Name, Id, LastModifiedDate FROM Unit__c ORDER BY LastModifiedDate DESC LIMIT 1];

            returnMessage.put('status', true);
            returnMessage.put('last_modified_date', String.valueOf((units.size() > 0) ? units[0].LastModifiedDate : Date.today().addYears(-50)));

            RestContext.response.statusCode = 200;
        }else if(content=='unit' && request=='latest_schedule_modified_date'){

            Unit__c[] units = [SELECT Name, Id, Last_Updated_By_Job__c FROM Unit__c WHERE Last_Updated_By_Job__c != null ORDER BY Last_Updated_By_Job__c DESC LIMIT 1];

            returnMessage.put('status', true);
            returnMessage.put('last_modified_date', String.valueOf((units.size() > 0) && units[0].Last_Updated_By_Job__c !=null ? units[0].Last_Updated_By_Job__c : Date.today().addYears(-50)));

            RestContext.response.statusCode = 200;
        }else if(content=='unit' && request=='latest_api_modified_date'){

            Unit__c[] units = [SELECT Name, Id, Last_Updated_By_API__c FROM Unit__c WHERE Last_Updated_By_API__c != null ORDER BY Last_Updated_By_API__c DESC LIMIT 1];

            returnMessage.put('status', true);
            returnMessage.put('last_modified_date', String.valueOf((units.size() > 0) && units[0].Last_Updated_By_API__c !=null ? units[0].Last_Updated_By_API__c : Date.today().addYears(-50)));

            RestContext.response.statusCode = 200;
        }else if(content=='deal' && request=='latest_api_modified_date'){

            Opportunity[] opps = [SELECT Name, Id, Last_Updated_By_API__c, Last_Updated_By_Bulk_API__c FROM Opportunity WHERE Last_Updated_By_Bulk_API__c != null ORDER BY Last_Updated_By_Bulk_API__c DESC LIMIT 1];

            returnMessage.put('status', true);
            returnMessage.put('last_modified_date', String.valueOf((opps.size() > 0) && opps[0].Last_Updated_By_Bulk_API__c !=null ? opps[0].Last_Updated_By_Bulk_API__c : Date.today().addYears(-50)));

            RestContext.response.statusCode = 200;
        }else{
            throw new RestResourceException('Invalid content request');
        }

        }
        catch(exception ex){
            ErrorLogHandler.log('RestService.V1.Exception #1',ex);
            returnMessage.put('status', false);
            returnMessage.put('message', ex.getMessage());
            RestContext.response.statusCode = 400;
        }

        RestContext.response.addHeader('Content-Type', 'application/json');
        RestContext.response.responseBody = Blob.valueOf(JSON.serialize(returnMessage));
    }

    /*
        * Method: Put
        * Request Body (Unit) - [{"unit_key": "19","forecast_base_rent": 10, "current_tenant_planned_end": "1990-01-15", "fitout_contribution_forecast": 100,
                                "landlord_works_forecast": 1000, "estimated_rent_start": "1990-01-15", "estimated_rent_end": null}]
        * Request Body (Deal) - [ { "deal_key": "AA00060", "process_status": "Pending Approval", "process_status_date": "1990-10-10", "process_status_identifier": "LCRM01",
                                "milestone": null, "milestone_date": null, "open_for_trade_date": null } ]
        * Request Params - content=unit | deal
        * Respone Body (Success) - { "rows_affected": 1, "status": true }
        * Response Body (Fail) - [ { "message": "Session expired or invalid", "errorCode": "INVALID_SESSION_ID" } ]
    */
    @HttpPut
    global static void doPut() {

        Map<String, Object> returnMessage = new Map<String, Object>();
        Map<String, Map<String, String>> dealKeyMap = new Map<String, Map<String, String>>();
        Map<String, Map<String, String>> unitKeyMap = new Map<String, Map<String, String>>();

        String content = RestContext.request.params.containsKey('content') ? RestContext.request.params.get('content') : '';
        String requestBody = RestContext.request.requestBody.toString().trim();

        try{
            ErrorLogHandler.log('RestService.V1.Request.' + content, requestBody.left(131000));

            if(content=='deal'){
                List<Deal> deals = new List<Deal>();

                if(requestBody.substring(0,1) == '['){
                	 deals.addAll((List<Deal>) System.JSON.deserialize(requestBody, List<Deal>.class));
                }else if((requestBody.substring(0,1) == '{')){
                	deals.add((Deal) System.JSON.deserialize(requestBody, Deal.class));
                }

                Set<String> dealKeys = new Set<String>();

                for(Deal deal: deals){
                    dealKeys.add(deal.deal_key);

                    dealKeyMap.put(deal.deal_key, new Map<String, String> {'process_status' => deal.process_status,
                                                                            'process_status_date' => deal.process_status_date,
                                                                            'process_status_identifier' => deal.process_status_identifier,
                                                                            'milestone' => deal.milestone,
                                                                            'milestone_date' => deal.milestone_date,
                                                                            'open_for_trade_date' => deal.open_for_trade_date
                                                                            });
                }

                List <Opportunity> dealsToUpdate = [SELECT Name, Id, Deal_Key__c FROM Opportunity WHERE Deal_Key__c IN :dealKeyMap.keySet()
                                                    ];

                for(Opportunity deal : dealsToUpdate){
                    deal.Process_Status__c = dealKeyMap.get(deal.Deal_Key__c).get('process_status');
                    deal.Process_Status_Identifier__c = dealKeyMap.get(deal.Deal_Key__c).get('process_status_identifier');
                    deal.Process_Status_Date__c = !String.isBlank(dealKeyMap.get(deal.Deal_Key__c).get('process_status_date')) ? Date.valueof(dealKeyMap.get(deal.Deal_Key__c).get('process_status_date')) : null;
                    deal.TDP_Milestone__c = dealKeyMap.get(deal.Deal_Key__c).get('milestone');
                    deal.TDP_Milestone_Date__c = !String.isBlank(dealKeyMap.get(deal.Deal_Key__c).get('milestone_date')) ? Date.valueof(dealKeyMap.get(deal.Deal_Key__c).get('milestone_date')) : null;
                    deal.Open_for_Trade_Date__c = !String.isBlank(dealKeyMap.get(deal.Deal_Key__c).get('open_for_trade_date')) ? Date.valueof(dealKeyMap.get(deal.Deal_Key__c).get('open_for_trade_date')) : null;
                    deal.Last_Updated_By_API__c =  system.now();
                    if((requestBody.substring(0,1) == '[')){
                    	deal.Last_Updated_By_Bulk_API__c =  system.now();
                    }
                    deal.LON_Pending__c =  false;
                }

                if(deals != null && dealsToUpdate.size() != deals.size()){
                    ErrorLogHandler.log('RestService.V1.Error.deal_key', String.valueOf(dealKeys)); // TODO : Output only the mismatch keys.
                }

                //ErrorLogHandler.log('REST API LOG - Deal/Put', requestBody.left(32767));
                returnMessage.put('status', true);
                returnMessage.put('rows_affected', dealsToUpdate.size());

                RestContext.response.statusCode = 200;

                update dealsToUpdate;
            }else if(content=='unit'){

                List<Unit> units = (List<Unit>) System.JSON.deserialize(requestBody, List<Unit>.class);

                for(Unit unit: units){
                    unitKeyMap.put(unit.unit_key, new Map<String, String> {
                                                            'forecast_base_rent' => unit.forecast_base_rent,
                                                            'current_tenant_planned_end' => unit.current_tenant_planned_end,
                                                            //'fitout_contribution_budget' => unit.fitout_contribution_budget,
                                                            'fitout_contribution_forecast' => unit.fitout_contribution_forecast,
                                                            //'future_tenant_landlord_works_budget' => unit.future_tenant_landlord_works_budget,
                                                            'landlord_works_forecast' => unit.landlord_works_forecast,
                                                            'estimated_rent_start' => unit.estimated_rent_start,
                                                            'estimated_rent_end' => unit.estimated_rent_end
                                                            });
                }

                List <Unit__c> unitsToUpdate = [SELECT Name, Id, Unit_Key__c FROM Unit__c WHERE Unit_Key__c IN :unitKeyMap.keySet()
                                                    ];

                for(Unit__c unit : unitsToUpdate){
                    unit.Forecast_Base_Rent__c = !String.isBlank(unitKeyMap.get(unit.Unit_Key__c).get('forecast_base_rent')) ? Decimal.valueOf(unitKeyMap.get(unit.Unit_Key__c).get('forecast_base_rent')) : null;
                    unit.Current_Tenant_Planned_End__c = !String.isBlank(unitKeyMap.get(unit.Unit_Key__c).get('current_tenant_planned_end')) ? Date.valueOf(unitKeyMap.get(unit.Unit_Key__c).get('current_tenant_planned_end')) : null;
                    //unit.Fitout_Contribution_Budget__c = Decimal.valueOf(unitKeyMap.get(unit.Unit_Key__c).get('fitout_contribution_budget'));
                    unit.Fitout_Contribution_Forecast__c = !String.isBlank(unitKeyMap.get(unit.Unit_Key__c).get('fitout_contribution_forecast')) ? Decimal.valueOf(unitKeyMap.get(unit.Unit_Key__c).get('fitout_contribution_forecast')) : null;
                    //unit.Future_Tenant_Landlord_Works_Budget__c = Decimal.valueOf(unitKeyMap.get(unit.Unit_Key__c).get('future_tenant_landlord_works_budget'));
                    unit.Landlord_Works_Forecast__c = !String.isBlank(unitKeyMap.get(unit.Unit_Key__c).get('landlord_works_forecast')) ? Decimal.valueOf(unitKeyMap.get(unit.Unit_Key__c).get('landlord_works_forecast')) : null;
                    unit.Estimated_Rent_Start__c = !String.isBlank(unitKeyMap.get(unit.Unit_Key__c).get('estimated_rent_start')) ? Date.valueOf(unitKeyMap.get(unit.Unit_Key__c).get('estimated_rent_start')) : null;
                    unit.Estimated_Rent_End__c = !String.isBlank(unitKeyMap.get(unit.Unit_Key__c).get('estimated_rent_end')) ? Date.valueOf(unitKeyMap.get(unit.Unit_Key__c).get('estimated_rent_end')) : null;
                    unit.Last_Updated_By_API__c =  system.now();
                }

                //ErrorLogHandler.log('REST API LOG - Unit/Put', requestBody.left(32767));
                returnMessage.put('status', true);
                returnMessage.put('rows_affected', unitsToUpdate.size());

                RestContext.response.statusCode = 200;

                update unitsToUpdate;

            }else{
                throw new RestResourceException('Invalid content request');
            }

        }catch(exception ex){
            ErrorLogHandler.log('RestService.V1.Exception #1',ex);
            ErrorLogHandler.log('RestService.V1.Exception #2',requestBody);
            returnMessage.put('status', false);
            returnMessage.put('message', ex.getMessage());
            RestContext.response.statusCode = 400;
        }

        RestContext.response.addHeader('Content-Type', 'application/json');
        RestContext.response.responseBody = Blob.valueOf(JSON.serialize(returnMessage));

    }

    /*
        * Method: Post
        * Request Body - {"recordNumberStart":1,"recordNumberEnd":2}
        * Request Params - content=unit | deal, filter=preferred
    */
    @HttpPost
    global static void doPost(Integer recordNumberStart, Integer recordNumberEnd, Date modifiedFrom, Date modifiedTo) {

        String defaultTenantCABId = '276050';

        //Retrevie URL parameters
        String content = RestContext.request.params.containsKey('content') ? RestContext.request.params.get('content') : '';
        String filter = RestContext.request.params.containsKey('filter') ? RestContext.request.params.get('filter') : 'all';

        //Variable parameters
        Integer totalRecords = 0;
        Integer recordsCount = 0;
        Map<String, Object> returnMessage = new Map<String, Object>();

        Map<String, Object> tempRecord;
        List<Map<String, Object>> tempRecords = new List<Map<String, Object>>();

        modifiedFrom = modifiedFrom !=null ? modifiedFrom : Date.valueOf('1990-01-01');
        modifiedTo = modifiedTo !=null ? modifiedTo : Date.today() + 1;

        try{
            if(content=='ecm_response'){
            	returnMessage.put('status', false);
            	returnMessage.put('message', 'Endpoint is depreciated');
            }else if(content=='lon_response'){
            	returnMessage.put('status', false);
            	returnMessage.put('message', 'Endpoint is depreciated');
            }else if(content == 'deal'){

                //--- Filter preferred tenants
                Set<Id> PreferredTenants = new Set<Id>();

                if(filter == 'preferred'){
                    for (Unit__c unit: [SELECT Name, Id, Preferred_Tenant__c
                        FROM Unit__c
                        WHERE Preferred_Tenant__c != null
                       ]){
                           PreferredTenants.add(unit.Preferred_Tenant__c);
                    }
                }else{
                    PreferredTenants = (new Map<Id, Opportunity>([SELECT Id FROM Opportunity])).keySet();
                }

                // -----------------------------------
                totalRecords = [SELECT COUNT () FROM Opportunity WHERE Id IN :PreferredTenants AND API_Error__c = false AND Is_Incomplete__c = false];

                Opportunity lastRecordO = [SELECT Id,
                                                  //Record_Number__c,
                                                  Record_Number_Cast__c
                                                  FROM Opportunity
                                                  WHERE API_Error__c = false
                                                  AND Is_Incomplete__c = false
                                                  ORDER BY Record_Number_Cast__c DESC LIMIT 1
                                                  ];

                for(Opportunity record : [SELECT  Name, Id,
                                            Tenant_Classification__c,
                                            Estimated_Lease_Commencement_Date__c,
                                            Future_Tenant_Lease_Expiry_Date__c,
                                            Tenant_Category__c,
                                            //Future_Tenant_Sales_Category__c,
                                            Account.Sales_Category__c,
                                            Lease_Incentive__c,
                                            Future_Tenant_Landlord_Works_Estimate__c,
                                            Recovery_Type__c,
                                            Percentage_Rent_Threshold__c,
                                            //Percentage_Rent_Amount__c,
                                            Rent_Review_Percentage__c,
                                            Lease_Incentive_Days__c,
                                            Lease_Incentive_Amount__c,
                                            Fitout_Contribution__c,
                                            Fitout_Contribution_Amount__c,
                                            Refurbishment_Contribution__c,
                                            Refurbishment_Contribution_Amount__c,
                                            Estimated_Handover_Date__c,
                                            Future_Tenant_Rent_Commencement_Date__c,
                                            //Future_Tenant_Strategy_ID__c,
                                            Unit__r.Forecast_Base_Rent__c,
                                            Unit__r.Unit_Key__c,
                                            Unit__r.Unit_Code__c,
                                            Deal_Justification__c,
                                            Deal_Tracking_Lease_Status__c,
                                            Artificial_Threshold_Amount__c,
                                            Deal_Type__c,
                                            Year_1_Sales_Estimate__c,
                                            Rent_Review_Rate_And_Type__c,
                                            Percentage_Rent_Rate__c,
                                            Deal_Key__c,
                                            LastModifiedDate,
                                            CreatedDate,
                                            Account.Tenant_Entity__c,
                                            Account.Trading_Group__c,
                                            Account.Tenant_CABID__c,
                                            Account.Name,
                                            AccountId,
                                            StageName,
                                            Bank_Guarentee__c,
                                            Percentage_Rent_Category__c,
                                            Probability,
                                            CloseDate,
                                            OwnerId,
                                            Owner.Email,
                                            Owner.Name,
                                            CreatedById,
                                            LastModifiedById,
                                            FiscalQuarter,
                                            FiscalYear,
                                            Opening_Promotion_Amount__c,
                                            Fiscal,
                                            Base_Rent__c,
                                            Building__c,
                                            Building__r.Building_Key__c,
                                            Building__r.Building_Code__c,
                                            //Fitout_Period__c,
                                            Lease_Term_Years__c,
                                            //Promotion_Contribut__c,
                                            Works_Type__c,
                                            //Works_Type_Emporium__c,
                                            Seating_License_Area__c,
                                            Surrender_other_premises_Make_Good__c,
                                            Early_Renewal__c,
                                            Part_of_a_surrender_and_a_new_lease__c,
                                            Existing_Fitout_Taken_Over_By_Tenant__c,
                                            Hoarding_Development_Unit__c,
                                            Part_of_an_assignment_of_lease__c,
                                            Is_CAPEX_approval_required__c,
                                            Area_of_premises_sqmt__c,
                                            Dev_Budget__c,
                                            //Permitted_Use__c,
                                            Selected_Permitted_Use__c,
                                            Selected_Permitted_Use__r.Name,
                                            Selected_Permitted_Use__r.Code_Type_Description__c,
                                            Selected_Permitted_Use__r.Code_Value__c,
                                            Selected_Permitted_Use__r.Code_Type__c,
                                            Selected_Permitted_Use__r.Code_Notes__c,
                                            Selected_Permitted_Use__r.Category_Code__c,
                                            Dev_Clause__c,
                                            CHADSTONE_Luxury_Mall_Promotion__c,
                                            Liquor_Licence__c,
                                            Tenant_take_over_part_of_existing_fitout__c,
                                            Exclusivity_of_Permitted_Use__c,
                                            Refit__c,
                                            Opening_Promotion__c,
                                            Hoarding_At_Commencement__c,
                                            Refit_Completion_Date__c,
                                            //Works_Type_DFO_Homebush__c,
                                            Lease_Term_Days__c,
                                            Lease_Term_Months__c,
                                            Gross_Rent__c,
                                            Promo_Review_Rate_and_Type__c,
                                            Bank_Guarantee_Requirement__c,
                                            Group_Security__c,
                                            Design_Review_Fees_At_Commencement__c,
                                            No_of_Personal_Guarantee__c,
                                            Hoarding_Rate_at_Commencement__c,
                                            Hoarding_During_End_Term__c,
                                            Storage_Rate__c,
                                            Design_Review_Fees_Rate_at_commencement__c,
                                            Personal_Guarantee__c,
                                            Design_Review_Fees_During_Term__c,
                                            Seating_Licence__c,
                                            //Rent_in_Advance__c,
                                            Area_of_Storage__c,
                                            //Special_Condition__c,
                                            Exclusion_Zone_Detail__c,
                                            Surrender_other_premises_Cost__c,
                                            Surrender_other_premises_Date__c,
                                            Surrender_these_premises_Cost__c,
                                            No_of_further_terms__c,
                                            Surrender_these_premises_Date__c,
                                            Surrender_these_premises_Make_Good__c,
                                            //Years_per_further_term__c,
                                            Car_park_fee_amount__c,
                                            Number_of_exclusive_car_parks__c,
                                            Car_park_signage_by_tenant__c,
                                            Development_Unit__c,
                                            Contract_Number__c,
                                            //Leasing_Executive__c,
                                            //Leasing_Executive__r.Name,
                                            //Leasing_Executive__r.Email,
                                            Surrender_other_premises_in_Centre__c,
                                            Process_Status__c,
                                            Surrender_these_premises_in_Centre__c,
                                            Promotion_Contribution_Percent__c,
                                            Centre__c,
                                            Storage__c,
                                            Option_for_further_term__c,
                                            //Rent_further_term_commence_Market_Fixed__c,
                                            Bank_Guarantee_Months__c,
                                            Common_Area_Overlease_line_trading_Deta__c,
                                            Common_Area_Overlease_line_trading__c,
                                            Exclusion_Zone__c,
                                            Unit_Type__c,
                                            Rent_Advance__c,
                                            Unit_Code__c,
                                            Process_Status_Identifier__c,
                                            Fit_out_Period__c,
                                            Common_Opening_Date__c,
                                            Promo_ReviewRate__c,
                                            Surrender_other_premises_Fees__c,
                                            Promo_Amt_Year_1__c,
                                            //Non_standard_Special_condition__c,
                                            //Option_further_term_Annual_Reviews__c,
                                            Surrender_these_premises_Fees__c,
                                            Car_park_exclusive_for_tenant__c,
                                            Centre__r.Centre_Key__c,
                                            Centre__r.Centre_Code__c,
                                            New_Retailer__c,
                                            New_Tenant_Entity__c,
                                            New_Tenant_ACN__c,
                                            New_Trading_Name__c,
                                            New_Tenant_Address__c,
                                            New_Auth_Rep_Name__c,
                                            New_Auth_Rep_Address__c,
                                            New_Auth_Rep_Phone1__c,
                                            New_Auth_Rep_Phone2__c,
                                            New_Auth_Rep_Email__c,
                                            New_Auth_Rep_Added__c,
                                            New_Leg_Rep_Added__c,
                                            New_Leg_Rep_Name__c,
                                            New_Leg_Rep_Address__c,
                                            New_Leg_Rep_Phone_1__c,
                                            New_Leg_Rep_Phone_2__c,
                                            New_Leg_Rep_Email__c,
                                            Existing_Retailer__c,
                                            Permitted_Use_Profile__c,
                                            Deal_Closure_Reason__c,
                                            Surrender_other_premises_Legal_Cost__c,
                                            Surrender_these_premises_Legal_Cost__c,
                                            Deal_Cancelled__c,
                                            Authorised_Reps__c,
                                            Billing_Reps__c,
                                            Guarantor_Reps__c,
                                            Legal_Reps__c,
                                            Notice_Reps__c,
                                            Registration_Reps__c,
                                            //Add_New_Tenants__c,
                                            //New_Gar_1_Rep_ACN__c,
                                            Reconfig__c,
                                            //New_Gar_2_Rep_ACN__c,
                                            //New_Gar_3_Rep_ACN__c,
                                            //Account.National_Retailer__c,
                                            Is_Taking_Existing_Fitout__c,
                                            TDP_Milestone__c,
                                            Record_Number_Cast__c,
                                            TDP_Milestone_Date__c,
                                            Account.Tenant_Key__c,
                                            Unit__c,
                                            Unit__r.Floor_Level__c
                                          FROM Opportunity
                                          WHERE Id IN :PreferredTenants
                                          AND LastModifiedDate <= :modifiedTo AND LastModifiedDate > :modifiedFrom
                                          AND API_Error__c = false AND Is_Incomplete__c = false
                                          AND Record_Number_Cast__c >= :recordNumberStart AND Record_Number_Cast__c < :recordNumberEnd
                                          ORDER BY CreatedDate
                                          LIMIT 50000
                                         ])
                {

                    tempRecord = new Map<String, Object>();

                    tempRecord.put('Deal_Id', record.Id);
                    tempRecord.put('Deal_Name', record.Name);
                    tempRecord.put('Deal_Key', record.Deal_Key__c);
                    tempRecord.put('Leasing_Executive__c', record.OwnerId);
                    tempRecord.put('Leasing_Executive_Name', record.Owner.Name);
                    tempRecord.put('Leasing_Executive_Email', record.Owner.Email);
                    tempRecord.put('TDP_Milestone__c', record.TDP_Milestone__c);
                    tempRecord.put('TDP_Milestone_Date__c', record.TDP_Milestone_Date__c);
                    tempRecord.put('Storage_Rate__c', record.Storage_Rate__c);
                    tempRecord.put('National_Retailer__c', null);
                    tempRecord.put('Car_park_fee_amount__c', record.Car_park_fee_amount__c);
                    tempRecord.put('Car_park_signage_by_tenant__c', record.Car_park_signage_by_tenant__c);
                    tempRecord.put('Tenant_Id', record.AccountId);
                    tempRecord.put('Tenant_Key', record.Account.Tenant_Key__c);
                    tempRecord.put('Common_Opening_Date__c', record.Common_Opening_Date__c);
                    tempRecord.put('StageName', record.StageName);
                    tempRecord.put('Fit_out_Period__c', record.Fit_out_Period__c);
                    tempRecord.put('Surrender_other_premises_Fees__c', record.Surrender_other_premises_Fees__c);
                    tempRecord.put('Surrender_these_premises_Fees__c', record.Surrender_these_premises_Fees__c);
                    //tempRecord.put('Unit_Code__c', record.Unit_Code__c);
                    tempRecord.put('Promo_ReviewRate__c', record.Promo_ReviewRate__c);
                    tempRecord.put('Rent_Advance__c', record.Rent_Advance__c);
                    tempRecord.put('Promo_Amt_Year_1__c', record.Promo_Amt_Year_1__c);
                    tempRecord.put('Unit_Type__c', record.Unit_Type__c);
                    //tempRecord.put('Non_standard_Special_condition__c', record.Non_standard_Special_condition__c);
                    //tempRecord.put('Option_further_term_Annual_Reviews__c', record.Option_further_term_Annual_Reviews__c);
                    //tempRecord.put('Rent_further_term_commence_Market_Fixed__c', record.Rent_further_term_commence_Market_Fixed__c);
                    tempRecord.put('Storage__c', record.Storage__c);
                    tempRecord.put('Car_park_exclusive_for_tenant__c', record.Car_park_exclusive_for_tenant__c);
                    tempRecord.put('Option_for_further_term__c', record.Option_for_further_term__c);
                    tempRecord.put('Bank_Guarantee_Months__c', record.Bank_Guarantee_Months__c);
                    tempRecord.put('Common_Area_Overlease_line_trading_Deta__c', record.Common_Area_Overlease_line_trading_Deta__c);
                    tempRecord.put('Exclusion_Zone__c', record.Exclusion_Zone__c);
                    tempRecord.put('Common_Area_Overlease_line_trading__c', record.Common_Area_Overlease_line_trading__c);
                    tempRecord.put('Surrender_other_premises_in_Centre__c', record.Surrender_other_premises_in_Centre__c);
                    tempRecord.put('Surrender_these_premises_in_Centre__c', record.Surrender_these_premises_in_Centre__c);
                    tempRecord.put('Promotion_Contribution_Percent__c', record.Promotion_Contribution_Percent__c);
                    tempRecord.put('Process_Status__c', record.Process_Status__c);
                    tempRecord.put('Centre__Id', record.Centre__c);
                    tempRecord.put('Centre_Key__c', record.Centre__r.Centre_Key__c);
                    tempRecord.put('Centre_Code__c', record.Centre__r.Centre_Code__c);
                    tempRecord.put('Contract_Number__c', record.Contract_Number__c);
                    tempRecord.put('Number_of_exclusive_car_parks__c', record.Number_of_exclusive_car_parks__c);
                    tempRecord.put('Development_Unit__c', record.Development_Unit__c);
                    //tempRecord.put('Years_per_further_term__c', record.Years_per_further_term__c);
                    tempRecord.put('No_of_further_terms__c', record.No_of_further_terms__c);
                    tempRecord.put('Surrender_these_premises_Make_Good__c', record.Surrender_these_premises_Make_Good__c);
                    tempRecord.put('Surrender_other_premises_Date__c', record.Surrender_other_premises_Date__c);
                    tempRecord.put('Surrender_these_premises_Cost__c', record.Surrender_these_premises_Cost__c);
                    tempRecord.put('Surrender_other_premises_Cost__c', record.Surrender_other_premises_Cost__c);
                    tempRecord.put('Surrender_these_premises_Date__c', record.Surrender_these_premises_Date__c);
                    tempRecord.put('Area_of_Storage__c', record.Area_of_Storage__c);
                    tempRecord.put('Seating_Licence__c', record.Seating_Licence__c);
                    //tempRecord.put('Special_Condition__c', record.Special_Condition__c);
                    tempRecord.put('Exclusion_Zone_Detail__c', record.Exclusion_Zone_Detail__c);
                    tempRecord.put('Design_Review_Fees_Rate_at_commencement__c', record.Design_Review_Fees_Rate_at_commencement__c);
                    tempRecord.put('Design_Review_Fees_During_Term__c', record.Design_Review_Fees_During_Term__c);
                    tempRecord.put('Probability', record.Probability);
                    tempRecord.put('Design_Review_Fees_At_Commencement__c', record.Design_Review_Fees_At_Commencement__c);
                    tempRecord.put('CloseDate', record.CloseDate);
                    tempRecord.put('Hoarding_During_End_Term__c', record.Hoarding_During_End_Term__c);
                    tempRecord.put('Hoarding_Rate_at_Commencement__c', record.Hoarding_Rate_at_Commencement__c);
                    //tempRecord.put('Rent_in_Advance__c', record.Rent_in_Advance__c);
                    tempRecord.put('Hoarding_At_Commencement__c', record.Hoarding_At_Commencement__c);
                    tempRecord.put('Group_Security__c', record.Group_Security__c);
                    tempRecord.put('OwnerId', record.OwnerId);
                    tempRecord.put('Trading_Group', record.Account.Trading_Group__c);
                    tempRecord.put('Artificial_Threshold_Amount__c', record.Artificial_Threshold_Amount__c);
                    tempRecord.put('No_of_Personal_Guarantee__c', record.No_of_Personal_Guarantee__c);
                    tempRecord.put('Refit__c', record.Refit__c);
                    tempRecord.put('Personal_Guarantee__c', record.Personal_Guarantee__c);
                    tempRecord.put('Bank_Guarantee_Requirement__c', record.Bank_Guarantee_Requirement__c);
                    tempRecord.put('Opening_Promotion__c', record.Opening_Promotion__c);
                    tempRecord.put('Promo_Review_Rate_and_Type__c', record.Promo_Review_Rate_and_Type__c);
                    tempRecord.put('Gross_Rent__c', record.Gross_Rent__c);
                    tempRecord.put('Lease_Term_Months__c', record.Lease_Term_Months__c);
                    tempRecord.put('Lease_Term_Days__c', record.Lease_Term_Days__c);
                    //tempRecord.put('Works_Type_DFO_Homebush__c', record.Works_Type_DFO_Homebush__c);
                    tempRecord.put('Refit_Completion_Date__c', record.Refit_Completion_Date__c);
                    tempRecord.put('Tenant_take_over_part_of_existing_fitout__c', record.Tenant_take_over_part_of_existing_fitout__c);
                    tempRecord.put('Liquor_Licence__c', record.Liquor_Licence__c);
                    tempRecord.put('Exclusivity_of_Permitted_Use__c', record.Exclusivity_of_Permitted_Use__c);
                    tempRecord.put('Dev_Budget__c', record.Dev_Budget__c);
                    //tempRecord.put('Permitted_Use__c', record.Permitted_Use__c);
                    tempRecord.put('CHADSTONE_Luxury_Mall_Promotion__c', record.CHADSTONE_Luxury_Mall_Promotion__c);
                    tempRecord.put('Dev_Clause__c', record.Dev_Clause__c);
                    tempRecord.put('Hoarding_Development_Unit__c', record.Hoarding_Development_Unit__c);
                    tempRecord.put('Reconfig__c', record.Reconfig__c);
                    tempRecord.put('Area_of_premises_sqmt__c', record.Area_of_premises_sqmt__c);
                    tempRecord.put('Works_Type__c', record.Works_Type__c);
                    tempRecord.put('Is_CAPEX_approval_required__c', record.Is_CAPEX_approval_required__c);
                    tempRecord.put('Early_Renewal__c', record.Early_Renewal__c);
                    tempRecord.put('Part_of_an_assignment_of_lease__c', record.Part_of_an_assignment_of_lease__c);
                    //tempRecord.put('Works_Type_Emporium__c', record.Works_Type_Emporium__c);
                    tempRecord.put('Surrender_other_premises_Make_Good__c', record.Surrender_other_premises_Make_Good__c);
                    tempRecord.put('Part_of_a_surrender_and_a_new_lease__c', record.Part_of_a_surrender_and_a_new_lease__c);
                    tempRecord.put('Existing_Fitout_Taken_Over_By_Tenant__c', record.Existing_Fitout_Taken_Over_By_Tenant__c);
                    tempRecord.put('Seating_License_Area__c', record.Seating_License_Area__c);
                    tempRecord.put('Bank_Guarentee__c', record.Bank_Guarentee__c);
                    tempRecord.put('Percentage_Rent_Category__c', record.Percentage_Rent_Category__c);
                    //tempRecord.put('Promotion_Contribut__c', record.Promotion_Contribut__c);
                    tempRecord.put('Opening_Promotion_Amount__c', record.Opening_Promotion_Amount__c);
                    tempRecord.put('Building__Id', record.Building__c);
                    tempRecord.put('Building_Key__c', record.Building__r.Building_Key__c);
                    tempRecord.put('Building_Code__c', record.Building__r.Building_Code__c);
                    tempRecord.put('CreatedDate', record.CreatedDate);
                    tempRecord.put('CreatedById', record.CreatedById);
                    tempRecord.put('LastModifiedDate', record.LastModifiedDate);
                    tempRecord.put('LastModifiedById', record.LastModifiedById);
                    tempRecord.put('FiscalQuarter', record.FiscalQuarter);
                    tempRecord.put('FiscalYear', record.FiscalYear);
                    tempRecord.put('Fiscal', record.Fiscal);
                    tempRecord.put('Base_Rent__c', record.Base_Rent__c);
                    tempRecord.put('Lease_Term_Years__c', record.Lease_Term_Years__c);
                    //tempRecord.put('Fitout_Period__c', record.Fitout_Period__c);
                    tempRecord.put('Year_1_Sales_Estimate__c', record.Year_1_Sales_Estimate__c);
                    tempRecord.put('Percentage_Rent_Rate__c ', record.Percentage_Rent_Rate__c);
                    tempRecord.put('Rent_Review_Rate_And_Type__c', record.Rent_Review_Rate_And_Type__c);
                    tempRecord.put('Deal_Tracking_Lease_Status__c', record.Deal_Tracking_Lease_Status__c);
                    tempRecord.put('Deal_Justification__c', record.Deal_Justification__c);
                    tempRecord.put('Tenant_Entity', (record.Account.Tenant_CABID__c == defaultTenantCABId) ? record.New_Tenant_Entity__c : record.Account.Tenant_Entity__c);
                    tempRecord.put('Tenant_Classification__c', record.Tenant_Classification__c);
                    tempRecord.put('Estimated_Lease_Commencement_Date__c', record.Estimated_Lease_Commencement_Date__c);
                    tempRecord.put('Future_Tenant_Lease_Expiry_Date__c', record.Future_Tenant_Lease_Expiry_Date__c);
                    tempRecord.put('Tenant_Category__c', record.Tenant_Category__c);
                    tempRecord.put('Sales_Category__c', record.Account.Sales_Category__c);
                    tempRecord.put('Lease_Incentive__c', record.Lease_Incentive__c);
                    tempRecord.put('Future_Tenant_Landlord_Works_Estimate__c', record.Future_Tenant_Landlord_Works_Estimate__c);
                    tempRecord.put('Recovery_Type__c', record.Recovery_Type__c);
                    tempRecord.put('Percentage_Rent_Threshold__c', record.Percentage_Rent_Threshold__c);
                    tempRecord.put('Rent_Review_Percentage__c', record.Rent_Review_Percentage__c);
                    tempRecord.put('Trading_Name', (record.Account.Tenant_CABID__c == defaultTenantCABId) ? record.New_Trading_Name__c : record.Account.Name);
                    tempRecord.put('Lease_Incentive_Days__c', record.Lease_Incentive_Days__c);
                    tempRecord.put('Lease_Incentive_Amount__c', (record.Lease_Incentive_Amount__c != null) ? record.Lease_Incentive_Amount__c.setScale(2) : 0);
                    tempRecord.put('Fitout_Contribution__c', record.Fitout_Contribution__c);
                    tempRecord.put('Fitout_Contribution_Amount__c', record.Fitout_Contribution_Amount__c);
                    tempRecord.put('Refurbishment_Contribution__c', record.Refurbishment_Contribution__c);
                    tempRecord.put('Refurbishment_Contribution_Amount__c', record.Refurbishment_Contribution_Amount__c);
                    tempRecord.put('Estimated_Handover_Date__c', record.Estimated_Handover_Date__c);
                    tempRecord.put('Future_Tenant_Rent_Commencement_Date__c', record.Future_Tenant_Rent_Commencement_Date__c);
                    //tempRecord.put('Future_Tenant_Strategy_ID__c', record.Future_Tenant_Strategy_ID__c);
                    tempRecord.put('Forecast_Base_Rent__c', record.Unit__r.Forecast_Base_Rent__c);
                    //tempRecord.put('Reconfig__c', record.Unit__r.Reconfig__c);
                    tempRecord.put('Unit_Key__c', record.Unit__r.Unit_Key__c);
                    tempRecord.put('Unit_Code__c', record.Unit__r.Unit_Code__c);
                    tempRecord.put('Unit__Id', record.Unit__c);
                    tempRecord.put('Deal_Type__c', record.Deal_Type__c);
                    tempRecord.put('Last_Modified', record.LastModifiedDate);
                    tempRecord.put('Created_Date', record.CreatedDate);
                    tempRecord.put('New_Retailer__c', record.New_Retailer__c);
                    //tempRecord.put('New_Tenant_Entity__c', record.New_Tenant_Entity__c);
                    tempRecord.put('New_Tenant_ACN__c', record.New_Tenant_ACN__c);
                    //tempRecord.put('New_Trading_Name__c', record.New_Trading_Name__c);
                    tempRecord.put('New_Tenant_Address__c', record.New_Tenant_Address__c);
                    tempRecord.put('New_Auth_Rep_Name__c', record.New_Auth_Rep_Name__c);
                    tempRecord.put('New_Auth_Rep_Address__c', record.New_Auth_Rep_Address__c);
                    tempRecord.put('New_Auth_Rep_Phone1__c', record.New_Auth_Rep_Phone1__c);
                    tempRecord.put('New_Auth_Rep_Phone2__c', record.New_Auth_Rep_Phone2__c);
                    tempRecord.put('New_Auth_Rep_Email__c', record.New_Auth_Rep_Email__c);
                    tempRecord.put('New_Auth_Rep_Added__c', record.New_Auth_Rep_Added__c);
                    tempRecord.put('New_Leg_Rep_Added__c', record.New_Leg_Rep_Added__c);
                    tempRecord.put('New_Leg_Rep_Name__c', record.New_Leg_Rep_Name__c);
                    tempRecord.put('New_Leg_Rep_Address__c', record.New_Leg_Rep_Address__c);
                    tempRecord.put('New_Leg_Rep_Phone_1__c', record.New_Leg_Rep_Phone_1__c);
                    tempRecord.put('New_Leg_Rep_Phone_2__c', record.New_Leg_Rep_Phone_2__c);
                    tempRecord.put('New_Leg_Rep_Email__c', record.New_Leg_Rep_Email__c);
                    tempRecord.put('Existing_Retailer__c', record.Existing_Retailer__c);
                    tempRecord.put('Permitted_Use_Profile__c', record.Permitted_Use_Profile__c);
                    tempRecord.put('Deal_Closure_Reason__c', record.Deal_Closure_Reason__c);
                    tempRecord.put('Surrender_other_premises_Legal_Cost__c', record.Surrender_other_premises_Legal_Cost__c);
                    tempRecord.put('Surrender_these_premises_Legal_Cost__c', record.Surrender_these_premises_Legal_Cost__c);
                    tempRecord.put('Deal_Cancelled__c', record.Deal_Cancelled__c);
                    tempRecord.put('Authorised_Reps__c', record.Authorised_Reps__c);
                    tempRecord.put('Billing_Reps__c', record.Billing_Reps__c);
                    tempRecord.put('Guarantor_Reps__c', record.Guarantor_Reps__c);
                    tempRecord.put('Legal_Reps__c', record.Legal_Reps__c);
                    tempRecord.put('Notice_Reps__c', record.Notice_Reps__c);
                    tempRecord.put('Registration_Reps__c', record.Registration_Reps__c);
                    //tempRecord.put('Add_New_Tenants__c', record.Add_New_Tenants__c);
                    //tempRecord.put('New_Gar_1_Rep_ACN__c', record.New_Gar_1_Rep_ACN__c);
                    //tempRecord.put('New_Gar_2_Rep_ACN__c', record.New_Gar_2_Rep_ACN__c);
                    //tempRecord.put('New_Gar_3_Rep_ACN__c', record.New_Gar_3_Rep_ACN__c);
                    //tempRecord.put('Future_Tenant_Strategy_ID__c', record.Future_Tenant_Strategy_ID__c);
                    tempRecord.put('Year_1_Sales_Estimate__c', record.Year_1_Sales_Estimate__c);
                    tempRecord.put('Deal_Key__c', record.Deal_Key__c);
                    tempRecord.put('Process_Status__c', record.Process_Status__c);
                    tempRecord.put('Process_Status_Identifier__c', record.Process_Status_Identifier__c);
                    tempRecord.put('Record_Number', record.Record_Number_Cast__c);
                    tempRecord.put('Is_Taking_Existing_Fitout__c', record.Is_Taking_Existing_Fitout__c);
                    tempRecord.put('Floor', record.Unit__r.Floor_Level__c);

                    tempRecords.add(tempRecord);
                }

                returnMessage.put('total_records', totalRecords);
                returnMessage.put('records_count', tempRecords.size());
                returnMessage.put('last_record_number', lastRecordO.Record_Number_Cast__c);
                returnMessage.put('records', tempRecords);
                returnMessage.put('status', true);
                RestContext.response.statusCode = 200;

            }else if(content == 'unit'){

                totalRecords = [SELECT COUNT () FROM Unit__c];

                Unit__c lastRecordU = [SELECT Id,
                                            //Record_Number__c,
                                            Record_Number_Cast__c
                                            FROM Unit__c ORDER BY Record_Number_Cast__c DESC LIMIT 1];

                for(Unit__c record : [SELECT  Name, Id,
                                            Unit_Code__c,
                                            Unit_Key__c,
                                            Forecast_Base_Rent__c,
                                            Forecast_Gross_Rent__c,
                                            Estimated_Rent_Start__c,
                                            Estimated_Rent_End__c,
                                            Business_Unit__r.Business_Unit_Code__c,
                                            Building__c,
                                            Building__r.Building_Key__c,
                                            Building__r.Building_Code__c,
                                            LastModifiedDate,
                                            Is_Reconfig__c,
                                            Target_Base_Rent__c,
                                            //Record_Number__c,
                                            Preferred_Tenant__c,
                                            Current_Tenant_Lease_Status__c,
                                            Current_Tenant_Planned_End__c,
                                            Fitout_Contribution_Budget__c,
                                            Preferred_Tenant__r.Deal_Key__c,
                                            Future_Tenant_Landlord_Works_Budget__c,
                                            Landlord_Works_Forecast__c,
                                            System_Unit_Category__c,
                                            Fitout_Contribution_Forecast__c,
                                            Current_Tenant_Strategy_on_Expiry__c,
                                            Reconfig_Stage__c,
                                            Record_Number_Cast__c,
                                            CreatedDate,
                                            Estimated_Instruction_Date__c,
                                            VSI_Value_Flag__c
                                          FROM Unit__c
                                          WHERE LastModifiedDate <= :modifiedTo AND LastModifiedDate > :modifiedFrom
                                          AND Record_Number_Cast__c >= :recordNumberStart AND Record_Number_Cast__c < :recordNumberEnd
                                          ORDER BY CreatedDate
                                          LIMIT 50000
                                         ])
                {

                    tempRecord = new Map<String, Object>();

                    tempRecord.put('Unit_Name', record.Name);
                    tempRecord.put('Unit_Id', record.Id);
                    tempRecord.put('Unit_Code__c', record.Unit_Code__c);
                    tempRecord.put('Unit_Key__c', record.Unit_Key__c);
                    tempRecord.put('Record_Number', record.Record_Number_Cast__c);
                    tempRecord.put('Business_Unit', record.Business_Unit__r.Business_Unit_Code__c);
                    tempRecord.put('Building__Id', record.Building__c);
                    tempRecord.put('Preferred_Tenant_Id', record.Preferred_Tenant__c);
                    tempRecord.put('Preferred_Tenant_Key', record.Preferred_Tenant__r.Deal_Key__c);
                    tempRecord.put('Building_Key__c', record.Building__r.Building_Key__c);
                    tempRecord.put('Building_Code__c', record.Building__r.Building_Code__c);
                    tempRecord.put('Forecast_Base_Rent__c', record.Forecast_Base_Rent__c);
                    tempRecord.put('Forecast_Gross_Rent__c', record.Forecast_Gross_Rent__c);
                    tempRecord.put('Estimated_Rent_Start__c', record.Estimated_Rent_Start__c);
                    tempRecord.put('Estimated_Rent_End__c', record.Estimated_Rent_End__c);
                    tempRecord.put('LastModifiedDate', record.LastModifiedDate);
                    tempRecord.put('CreatedDate', record.CreatedDate);
                    tempRecord.put('Is_Reconfig__c', record.Is_Reconfig__c);
                    tempRecord.put('System_Unit_Category__c', record.System_Unit_Category__c);
                    tempRecord.put('Target_Base_Rent__c', record.Target_Base_Rent__c);
                    tempRecord.put('Reconfig_Stage__c', record.Reconfig_Stage__c);
                    tempRecord.put('Current_Tenant_Planned_End__c', record.Current_Tenant_Planned_End__c);
                    tempRecord.put('Fitout_Contribution_Budget__c', record.Fitout_Contribution_Budget__c);
                    tempRecord.put('Future_Tenant_Landlord_Works_Budget__c', record.Future_Tenant_Landlord_Works_Budget__c);
                    tempRecord.put('Landlord_Works_Forecast__c', record.Landlord_Works_Forecast__c);
                    tempRecord.put('Fitout_Contribution_Forecast__c ', record.Fitout_Contribution_Forecast__c);
                    tempRecord.put('Current_Tenant_Strategy_on_Expiry__c ', record.Current_Tenant_Strategy_on_Expiry__c);
                    tempRecord.put('Current_Tenant_Lease_Status__c ', record.Current_Tenant_Lease_Status__c);
                    tempRecord.put('Estimated_Instruction_Date__c ', record.Estimated_Instruction_Date__c);
                    tempRecord.put('VSI_Value_Flag__c ', record.VSI_Value_Flag__c);


                    tempRecords.add(tempRecord);
                }

                returnMessage.put('total_records', totalRecords);
                returnMessage.put('records_count', tempRecords.size());
                returnMessage.put('last_record_number', lastRecordU.Record_Number_Cast__c);
                returnMessage.put('records', tempRecords);
                returnMessage.put('status', true);
                RestContext.response.statusCode = 200;

            }else{
                throw new RestResourceException('Invalid content request');
            }
        }
        catch(exception ex){
            ErrorLogHandler.log('RestService.V1.Exception #1',ex);
            returnMessage.put('status', false);
            returnMessage.put('message', ex.getMessage());
            RestContext.response.statusCode = 400;
        }

        RestContext.response.addHeader('Content-Type', 'application/json');
        RestContext.response.responseBody = Blob.valueOf(JSON.serialize(returnMessage));
    }

    public class RestResourceException extends Exception {

    }

    global class Deal {
        String deal_Key;
        String process_status;
        String process_status_identifier;
        String process_status_date;
        String open_for_trade_date;
        String milestone;
        String milestone_date;
    }

    global class Unit {
        String unit_key;
        String forecast_base_rent;
        String current_tenant_planned_end;
        String fitout_contribution_forecast;
        //String fitout_contribution_budget;
        //String future_tenant_landlord_works_budget;
        String landlord_works_forecast;
        String estimated_rent_start;
        String estimated_rent_end;
    }
}