/*
    Date        : 12-09-2016
	Project     : Lease Management System
    Description : Centre batch downloader

    Change History
    --------------
*/
global class ScheduleCentreV3 implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful {
    global String token;
    global Integer page;
    global Integer totalPages;

    global ScheduleCentreV3(String token, Integer page, Integer totalPages) {
        this.token = token;
        this.page = page;
        this.totalPages = totalPages;
    }

    global ScheduleCentreV3(Integer page) {
        this.page = page;
    }

    global ScheduleCentreV3() {
        this.page = 1;
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

    global Iterable<sObject> start(Database.BatchableContext bc) {
        if (String.isEmpty(this.token)) {
            this.token = this.getToken();
        }

        return new List<Centre__c>{new Centre__c()};
    }

    global void execute(Database.BatchableContext bc, List<Centre__c> obj) {
        System.debug('Executing Centre Schedule V3 - Page#'+this.page);
        try {
            this.download(this.page);
        } catch(Exception ex) {
            ErrorLogHandler.log('Centre Schedule V3 Exception - Page#'+ this.page,ex);
        }
    }

    global void finish(Database.BatchableContext bc) {
        if (this.page < this.totalPages) {
            Database.executeBatch(new ScheduleCentreV3(this.token, this.page + 1, this.totalPages), 1000);
        } else  {
            System.scheduleBatch(new ScheduleRatesV3(), 'Centre Rates Schedule V3', 0);
        }
    }

    global void download(Integer page) {
        String filter = 'last_updated>="' + Datetime.now().addDays(-2).format('YYYY-MM-dd') + '"';

        HttpRequest request = new HttpRequest();
        request.setMethod('GET');
        request.setHeader('Authorization', 'Bearer ' + this.token);
        request.setHeader('Cache-Control', 'No-Cache');
        request.setEndpoint(Global_Settings__c.getInstance().API_URL_4__c+'/centres?filter='+filter+'&page='+ page);
        request.setTimeout(30000);

        Http http = new Http();
        HttpResponse response = http.send(request);
        if (hasRedirect(response)) {
            response = handleRedirect(response);
        }

        // Process the response
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
        Map<String,Centre__c> mapjsonData = new Map<String,Centre__c>();
        Set<String> centreKeySet = new Set<String>();

        JSONParser parser = JSON.createParser(jsonResponse);
        while(parser.nextToken() != null) {
            if (this.totalPages == null && parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'total_pages') {
                parser.nextToken();
                this.totalPages = Integer.valueOf(parser.getText());
            }
            if(this.totalPages > 0){
                if(parser.getCurrentToken() == JSONToken.START_ARRAY) {

                    while(parser.nextToken() != null) {
                        if(parser.getCurrentToken() == JSONToken.START_OBJECT) {

                            centreWrapper ct = (centreWrapper)parser.readValueAs(centreWrapper.class);

                            Centre__c objCentre = new Centre__c();

                            objCentre.Name = ct.name;
                            objCentre.Address__c = ct.address;
                            objCentre.State__c = ct.state;
                            objCentre.Postcode__c = ct.postcode;
                            objCentre.Contract_Number__c = ct.contract_number;
                            objCentre.Centre_Code__c = ct.centre_code;
                            objCentre.Centre_Key__c = ct.centre_key;
                            objCentre.Last_Updated_By_Job__c = system.now();
                            objCentre.Last_Updated_By_JDE__c = (ct.last_updated != null) ? Date.valueOf(ct.last_updated) : null;

                            if(ct.Name == 'Chadstone' || ct.Name == 'Emporium' || ct.Name == 'Queens Plaza' || ct.Name == 'Chatswood Chase' || ct.Name == 'The Strand' || ct.Name == 'Queen Victoria Building' || ct.Name == 'The Galeries')
                            {
                                objCentre.Conditional_Cap__c = 15000;
                            }else{
                                objCentre.Conditional_Cap__c = 8000;
                            }

                            mapjsonData.put(objCentre.Centre_Key__c,objCentre);
                        }
                    }
                }
            }

        }

        if (mapjsonData.size() > 0) {
            for(Centre__c c :[SELECT Id, Name, Address__c, State__c, Postcode__c, Contract_Number__c, Centre_Code__c,
                    Conditional_Cap__c, Centre_Key__c,Last_Updated_By_Job__c
            FROM Centre__c
            WHERE Centre_Key__c in :mapjsonData.keyset()]){

                if(mapjsonData.containsKey(c.Centre_Key__c)){
                    mapjsonData.get(c.Centre_Key__c).Id = c.Id;
                }
            }

            try{
                upsert mapjsonData.values();
                ErrorLogHandler.log('Centre Schedule',String.valueOf(mapjsonData.values().size()), String.valueOf(totalPages), String.valueOf(page), 'Schedule');
                if(mapjsonData.values().size() == 0 && !Test.isRunningTest()){
                    ErrorLogHandler.log('Error in Centre Schedule V3 #'+page, jsonResponse.left(131000));
                    token = null;
                    page -= 1;
                }
                //Database.upsert(mapjsonData.values(), false);
            }catch(exception e) {
                ErrorLogHandler.log('Centre Schedule V3 exception #1 - Exception', e);
                ErrorLogHandler.log('Centre Schedule V3 exception #2 - Exception', jsonResponse);
            }
        }else {
            ErrorLogHandler.log('Centre V3 Information', 'No Values Returned');
        }

    }

    // Centre Wrapper
    global class centreWrapper {
        public String centre_code;
        public String centre_key;
        public String name;
        public String address;
        public String state;
        public String postcode;
        public String contract_number;
        public String city;
        public String last_updated;
        public String country;
        public String longitude;
        public String latitude;
    }
}