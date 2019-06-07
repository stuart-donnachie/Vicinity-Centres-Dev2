global class ScheduleLeaseUnit implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful {
    global String token;
    global Integer page;
    global Integer totalPages;
    global VC_DealsCommon dealsCommon = new VC_DealsCommon();

    global ScheduleLeaseUnit(String token, Integer page, Integer totalPages) {
        this.token = token;
        this.page = page;
        this.totalPages = totalPages;
    }

    global ScheduleLeaseUnit(Integer page) {
        this.page = page;
    }

    global ScheduleLeaseUnit() {
        this.page = 1;
    }

    public Decimal decimalNullChecker(String value){
        return (String.isNotEmpty(value) ? Decimal.valueOf(value) : null);
    }

    global String getToken() {
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

    // Get the authentication token
    global Iterable<sObject> start(Database.BatchableContext bc) {
        if (String.isEmpty(this.token)) {
            this.token = this.getToken();
        }

        return new List<Unit__c>{new Unit__c()};
    }

    global void execute(Database.BatchableContext bc, List<Unit__c> obj) {
        try {
            this.download(this.page);
        } catch(Exception ex) {
            ErrorLogHandler.log('Lease Unit Schedule Exception - Page#'+ this.page,ex);
        }
    }

    global void finish(Database.BatchableContext bc) {
        if (this.page < this.totalPages) {
            Database.executeBatch(new ScheduleLeaseUnit(this.token, this.page + 1, this.totalPages), 1000);
        } else  {
            System.scheduleBatch(new ScheduleTenant(), 'Unit Schedule', 0);
        }
    }

    global void download(Integer page) {
        HttpRequest request = new HttpRequest();
        request.setMethod('GET');
        request.setHeader('Authorization', 'Bearer ' + this.token);
        request.setHeader('Cache-Control', 'No-Cache');
        request.setEndpoint(Global_Settings__c.getInstance().API_URL_2__c+'/lease-units?page='+ page);
        request.setTimeout(30000);
        Http http = new Http();
        HttpResponse response = http.send(request);
        if (hasRedirect(response)) {
            response = handleRedirect(response);
        }
        save(response.getBody());
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
        req.setTimeout(100000);

        Http http = new Http();
        HttpResponse response = http.send(req);

        return response;
    }

    global void save(String jsonResponse) {

        Map<String,Unit__c> mapjsonData = new Map<String,Unit__c>();
        //List<Unit__c> unitsToUpdate = new List<Unit__c>();

        // This is used to ensure we are getting the most recent entry for the Unit
        String currentFiscalYear = String.valueOf(dealsCommon.getFiscalYear(Date.today()).year()).Right(2);

        JSONParser parser = JSON.createParser(jsonResponse);
        while(parser.nextToken() != null) {
            if (this.totalPages == null && parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'total_pages') {
                parser.nextToken();
                this.totalPages = Integer.valueOf(parser.getText());
            }
            if(parser.getCurrentToken() == JSONToken.START_ARRAY) {
                while(parser.nextToken() != null) {
                    if(parser.getCurrentToken() == JSONToken.START_OBJECT) {

                        unitWrapper ut = (unitWrapper)parser.readValueAs(unitWrapper.class);

                        if(ut.fiscal_year == currentFiscalYear){
                            Unit__c objUnit = new Unit__c();
                            objUnit.Fitout_Contribution_Budget__c = decimalNullChecker(ut.fitout_contribution_budget);
                            objUnit.Future_Tenant_Landlord_Works_Budget__c = decimalNullChecker(ut.landlord_works_budget);
                            objUnit.Budget_Base_Rent_on_Expiry__c = decimalNullChecker(ut.budget_base_rent_on_expiry);
                            objUnit.Current_Tenant_Lease_Expiry_Date__c = (ut.current_tenant_lease_expiry_date != null) ? Date.valueOf(ut.current_tenant_lease_expiry_date) : null;
                            objUnit.Current_Base_Rent_Amount__c = decimalNullChecker(ut.base_rent_amount);
                            objUnit.System_Unit_Category__c = ut.system_unit_category_name;
                            objUnit.Unit_Key__c = ut.unit_key;

                            mapjsonData.put(objUnit.Unit_Key__c,objUnit);
                        }
                    }
                }
            }
        }

        for(Unit__c u :[SELECT Id, Name, Unit_Code__c, Unit_Type__c, Area_of_Premises__c, Floor_Level__c, System_Unit_Category__c,
                                                            Current_Tenant_Lease_Expiry_Date__c, Current_Base_Rent_Amount__c,
                                                            Centre_Key__c, Building_Key__c, Unit_Key__c , Last_Updated_By_Job__c,
                                                            Current_Tenant__c, Current_Tenant_Trading_Name__c, Current_Tenant_Key__c
                                                            FROM Unit__c
                                                            WHERE Unit_Key__c in :mapjsonData.keyset()]){

            if(mapjsonData.containsKey(u.Unit_Key__c)){
                mapjsonData.get(u.Unit_Key__c).Id = u.Id;
                //unitsToUpdate.add(u);
            }
        }

        try{
            //update unitsToUpdate;
            upsert mapjsonData.values();
            ErrorLogHandler.log('Lease Unit Schedule',String.valueOf(mapjsonData.values().size()), String.valueOf(totalPages), String.valueOf(page), 'Schedule');
            //Database.update(unitsToUpdate, false);
        }catch(exception e) {
            ErrorLogHandler.log('Unit Schedule exception #1 - Exception', e);
            ErrorLogHandler.log('Unit Schedule exception #2 - Exception', jsonResponse);
        }

    }

    // Units Wrapper
    global class unitWrapper {
        String current_debt;
        String lease_id;
        String last_updated;
        String unit_code;
        String building_key;
        String precinct_avg_base_rent_sqm;
        String cost_centre;
        String landlord_works_budget;
        String lease_status_code;
        String precinct_avg_gross_rent;
        String year;
        String current_tenant_recovery_deal_type_code;
        String precinct_code;
        String current_tenant_lease_start_date;
        String current_tenant_group_code;
        String portfolio_debt_for_tenant;
        String current_tenant_prior_year_mat;
        String sales_category_code;
        String budget_base_rent_on_expiry_sqm;
        String system_unit_category_name;
        String budget_base_rent_this_fy;
        String precinct_avg_gross_rent_sqm;
        String current_tenant_cab_code;
        String last_statement_date;
        String current_tenant_vacate_date;
        String sales_category_mat_sqm;
        String current_tenant_mat_sqm;
        String site_grade_code;
        String unit_key;
        String building_code;
        String budget_base_rent_this_fy_sqm;
        String original_expiry_date;
        String is_active;
        String current_tenant_group_name;
        String precinct_name;
        String gross_rent_amount_sqm;
        String current_tenant_classification_code;
        String current_tenant_percentage_rent_threshold;
        String budget_base_rent_on_expiry;
        String current_tenant_lease_term;
        String sales_category_name;
        String current_tenant_occupancy_cost;
        String unit_type_code;
        String outs_deal_type_name;
        String current_retailer_category;
        String no_of_tenants_in_sales_category;
        String current_tenant_recovery_deal_type_name;
        String outs_deal_type_code;
        String current_tenant_lease_expiry_date;
        String system_unit_category_code;
        String base_rent_amount;
        String tenant_trading_name;
        String precinct_mat_sqm;
        String current_tenant_recoveries;
        String fitout_contribution_budget;
        String unit_type_name;
        String precinct_avg_base_rent;
        String national_retailer;
        String no_of_tenants_in_precinct;
        String current_base_rent_amount_sqm;
        String site_grade_name;
        String current_tenant_annual_mat;
        String fiscal_year;
    }
}