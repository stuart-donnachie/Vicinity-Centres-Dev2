@isTest
global class ScheduleLeaseUnitV3_UT {

    public static testMethod void  createSchedule() {

        // Create Account
        Account objAccount = VC_UnitTestFactory.buildTestAccount();
        objAccount.Tenant_Key__c = '1';
        insert objAccount;

        // Create Tenant Rep
        Contact objContact1 = VC_UnitTestFactory.buildTenantRep();
        objContact1.Contact_Key__c = '1';
        insert objContact1;

        Contact objContact2 = VC_UnitTestFactory.buildTenantRep();
        objContact2.Contact_Key__c = '2';
        insert objContact2;

        Contact objContact3 = VC_UnitTestFactory.buildTenantRep();
        objContact3.Contact_Key__c = '5';
        insert objContact3;

        Map<String,Id> mapAccount = new Map<String,Id>();
        mapAccount.put('1', objAccount.Id);

        Test.startTest();

        Test.setMock(HttpCalloutMock.class, new AuthResponseMockHttpResponseGenerator());

        ScheduleLeaseUnitV3 sc1 = new ScheduleLeaseUnitV3();
        ScheduleLeaseUnitV3 sc2 = new ScheduleLeaseUnitV3(1);
        ScheduleLeaseUnitV3 sc3 = new ScheduleLeaseUnitV3(sc1.getToken(),1,2);

        List<Unit__c> objs = new List<Unit__c>();

        Test.setMock(HttpCalloutMock.class, new ContactMockHttpResponseGenerator());

        HttpResponse response = new HttpResponse();
        Database.BatchableContext  bc;

        sc3.start(bc);
        sc3.execute(bc,objs);
        sc3.finish(bc);
        //sc3.hasRedirect(response);

        String jsonResponse = '{ "pagination": { "total_pages": 34, "page": 1 }, "data": [ { "current_debt": "0.0", "lease_id": "651663", "last_updated": "2017-03-02", "century": "20", "building_key": "121", "cost_centre": "82310", "fiscal_year": "17", "precinct_avg_gross_rent": "82221.74", "lease_status_id": "", "precinct_avg_base_rent_sqm": "795.77", "current_tenant_recovery_deal_type_code": "NL", "precinct_code": "FCT", "current_tenant_lease_start_date": "2009-11-01", "target_base_rent": "0.0", "current_tenant_group_code": "", "portfolio_debt_for_tenant": "0.0", "unit_code": "G015C", "sales_category_code": "TAK", "budgeted_recovery_type_code": "03", "budget_base_rent_on_expiry_sqm": "2288.57", "system_unit_category_name": "Expiries - 2014/2015", "precinct_avg_base_rent": "68760.06", "precinct_avg_gross_rent_sqm": "951.56", "current_tenant_cab_code": "151151", "last_statement_date": "2011-06-10", "current_tenant_vacate_date": "2015-04-30", "sales_category_mat_sqm": "9128.37", "current_tenant_mat_sqm": "6237.41", "site_grade_code": "A", "unit_key": "7459", "building_code": "82310", "no_of_tenants_in_precinct": "10", "original_expiry_date": "2015-04-30", "planned_strategy_on_expiry_code": "REN", "is_active": "YES", "current_tenant_group_name": ".", "precinct_name": "Foodcourt", "gross_rent_amount_sqm": "2099.52", "current_tenant_classification_code": "null", "current_tenant_percentage_rent_threshold": "666666.67", "current_tenant_lease_term": "66", "sales_category_name": "Takeaway Food - Non Food Court", "current_tenant_occupancy_cost": "33.67", "unit_type_code": "10RTL", "budgeted_recovery_type_name": "Net", "outs_deal_type_name": "Net", "current_retailer_category": "null", "no_of_tenants_in_sales_category": "11", "current_tenant_recovery_deal_type_name": "Net (Deal Type NL)", "target_base_rent_sqm": "0.0", "outs_deal_type_code": "03", "tenant_trading_name": "WOK GOURMET THE", "system_unit_category_code": "I2014", "base_rent_amount": "105000.0", "precinct_mat_sqm": "7014.74", "budget_base_rent_on_expiry": "131135.0", "current_tenant_prior_year_mat": "30836032", "unit_type_name": "Retail Specialty", "current_tenant_lease_expiry_date": "2015-04-30", "national_retailer": "N", "current_base_rent_amount_sqm": "1832.46", "site_grade_name": "Prime", "current_tenant_annual_mat": "357403.42" } ] }';
        sc3.save(jsonResponse);

        Test.stopTest();

    }

    global class AuthResponseMockHttpResponseGenerator implements HttpCalloutMock {
        global HTTPResponse respond(HTTPRequest req) {

            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{ "refresh_token_expires_in": "0", "api_product_list": "[Vicinity Data Lake API]", "organization_name": "vicinitycentres", "developer.email": "vicinitycentres@vicinity.com.au", "token_type": "BearerToken", "issued_at": "1488412657099", "client_id": "v4bFh1TY90I6Nfr2vI4SGiDRozS0af6G", "access_token": "wR8yUE9PUFsN9TN830G8xfVvrU4i", "application_name": "9f9caa6e-3c6e-460d-a7d3-5ab0e043b0e9", "scope": "", "expires_in": "1799", "refresh_count": "0", "status": "approved" }');
            res.setStatusCode(200);
            return res;
        }
    }

    global class ContactMockHttpResponseGenerator implements HttpCalloutMock {
        global HTTPResponse respond(HTTPRequest req) {

            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{ "pagination": { "total_pages": 34, "page": 1 }, "data": [ { "current_debt": "0.0", "lease_id": "651663", "last_updated": "2017-03-02", "century": "20", "building_key": "121", "cost_centre": "82310", "fiscal_year": "10", "precinct_avg_gross_rent": "82221.74", "lease_status_id": "", "precinct_avg_base_rent_sqm": "795.77", "current_tenant_recovery_deal_type_code": "NL", "precinct_code": "FCT", "current_tenant_lease_start_date": "2009-11-01", "target_base_rent": "0.0", "current_tenant_group_code": "", "portfolio_debt_for_tenant": "0.0", "unit_code": "G015C", "sales_category_code": "TAK", "budgeted_recovery_type_code": "03", "budget_base_rent_on_expiry_sqm": "2288.57", "system_unit_category_name": "Expiries - 2014/2015", "precinct_avg_base_rent": "68760.06", "precinct_avg_gross_rent_sqm": "951.56", "current_tenant_cab_code": "151151", "last_statement_date": "2011-06-10", "current_tenant_vacate_date": "2015-04-30", "sales_category_mat_sqm": "9128.37", "current_tenant_mat_sqm": "6237.41", "site_grade_code": "A", "unit_key": "7459", "building_code": "82310", "no_of_tenants_in_precinct": "10", "original_expiry_date": "2015-04-30", "planned_strategy_on_expiry_code": "REN", "is_active": "YES", "current_tenant_group_name": ".", "precinct_name": "Foodcourt", "gross_rent_amount_sqm": "2099.52", "current_tenant_classification_code": "null", "current_tenant_percentage_rent_threshold": "666666.67", "current_tenant_lease_term": "66", "sales_category_name": "Takeaway Food - Non Food Court", "current_tenant_occupancy_cost": "33.67", "unit_type_code": "10RTL", "budgeted_recovery_type_name": "Net", "outs_deal_type_name": "Net", "current_retailer_category": "null", "no_of_tenants_in_sales_category": "11", "current_tenant_recovery_deal_type_name": "Net (Deal Type NL)", "target_base_rent_sqm": "0.0", "outs_deal_type_code": "03", "tenant_trading_name": "WOK GOURMET THE", "system_unit_category_code": "I2014", "base_rent_amount": "105000.0", "precinct_mat_sqm": "7014.74", "budget_base_rent_on_expiry": "131135.0", "current_tenant_prior_year_mat": "30836032", "unit_type_name": "Retail Specialty", "current_tenant_lease_expiry_date": "2015-04-30", "national_retailer": "N", "current_base_rent_amount_sqm": "1832.46", "site_grade_name": "Prime", "current_tenant_annual_mat": "357403.42" } ] }');
            res.setStatusCode(302);
            res.setHeader('Location','https://cs31.salesforce.com');
            return res;
        }
    }
}