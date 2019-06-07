/*
    Date        : 12-09-2016
	Project     : Lease Management System
    Description : Building batch downloader

    Change History
    --------------
*/
global class ScheduleBuildingV3 implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful {
    global String token;
    global Integer page;
    global Integer totalPages;
    global Map<String,Id> mapCentre;
    global Map<String,Id> mapBU;
    static boolean recursive = false;

    global ScheduleBuildingV3(String token, Integer page, Integer totalPages, Map<String,Id> mapCentre, Map<String,Id> mapBU) {
        this.token = token;
        this.page = page;
        this.totalPages = totalPages;
        this.mapCentre = mapCentre;
        this.mapBU = mapBU;
    }

    global ScheduleBuildingV3(Integer page) {
        this.page = page;
        this.mapCentre = new Map<String,Id>();
        this.mapBU = new Map<String,Id>();
    }

    global ScheduleBuildingV3() {
        this.page = 1;
        this.mapCentre = new Map<String,Id>();
        this.mapBU = new Map<String,Id>();
    }

    global String getToken() {
        System.debug('Getting API Token');
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
        System.debug('Start Executing Building Schedule V3');
        if (this.mapCentre.size() == 0) {
            for(Centre__c c : [SELECT Id,Centre_Key__c FROM Centre__c]){
                this.mapCentre.put(c.Centre_Key__c,c.Id);
            }
        }

        if (this.mapBU.size() == 0) {
            for(Business_Unit__c bu : [SELECT Id,Business_Unit_Code__c FROM Business_Unit__c]){
                this.mapBU.put(bu.Business_Unit_Code__c,bu.Id);
            }
        }

        if (String.isEmpty(this.token)) {
            this.token = this.getToken();
        }

        return new List<Building__c>{new Building__c()};
    }

    global void execute(Database.BatchableContext bc, List<Building__c> obj) {
        System.debug('Executing Building Schedule V3 - Page#'+this.page);
        try {
            this.download(this.page);
        } catch(Exception ex) {
            ErrorLogHandler.log('Building Schedule V3 Exception - Page#'+ this.page,ex);
        }
    }

    global void finish(Database.BatchableContext bc) {
        if(!recursive) {
            recursive = true;
            System.debug('Finish Executing Building Schedule V3 - Page#'+this.page);
            if (this.page < this.totalPages) {
                Database.executeBatch(new ScheduleBuildingV3(this.token, this.page + 1, this.totalPages, this.mapCentre, this.mapBU), 1000);
            } else  {
                System.scheduleBatch(new ScheduleUnitV3(), 'Unit Schedule V3', 0);
            }
        }

    }

    global void download(Integer page) {
        HttpRequest request = new HttpRequest();
        request.setMethod('GET');
        request.setHeader('Authorization', 'Bearer ' + this.token);
        request.setHeader('Cache-Control', 'No-Cache');
        request.setEndpoint(Global_Settings__c.getInstance().API_URL_4__c+'/buildings?page='+ page);
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

        Map<String,Building__c> mapjsonData = new Map<String,Building__c>();
        Set<String> buildingKeySet = new Set<String>();

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

                            buildingWrapper bd = (buildingWrapper)parser.readValueAs(buildingWrapper.class);

                            Building__c objBuilding = new Building__c();

                            objBuilding.Name = bd.Name;
                            objBuilding.Address_Line_1__c = bd.address;
                            objBuilding.City__c	= bd.city;
                            objBuilding.State__c = bd.state;
                            objBuilding.Country__c = bd.country;
                            objBuilding.Postal_Code__c = bd.postcode;
                            objBuilding.Centre_Key__c = bd.centre_key;
                            objBuilding.Centre__c = mapCentre.containsKey(bd.centre_key) ? mapCentre.get(bd.centre_key): null;
                            objBuilding.Business_Unit__c = mapBU.containsKey(bd.building_code) ? mapBU.get(bd.building_code) : null;
                            objBuilding.Building_Key__c = bd.building_key;
                            objBuilding.Building_Code__c = bd.building_code;
                            objBuilding.Building_Type__c = bd.building_type;
                            objBuilding.Last_Updated_By_Job__c = system.now();

                            if(objBuilding.Centre__c !=null){
                                mapjsonData.put(objBuilding.Building_Key__c,objBuilding);
                            }

                        }
                    }
                }
            }

        }



        if (mapjsonData.size() > 0) {
            for(Building__c c :[SELECT Id, Name, Address_Line_1__c, City__c, State__c, Country__c, Postal_Code__c,
                    Centre_Key__c, Building_Key__c, Building_Code__c , Last_Updated_By_Job__c
            FROM Building__c
            WHERE Building_Key__c in :mapjsonData.keyset()]){

                if(mapjsonData.containsKey(c.Building_Key__c)){
                    mapjsonData.get(c.Building_Key__c).Id = c.Id;
                }
            }

            try{
                upsert mapjsonData.values();
                ErrorLogHandler.log('Building Schedule V3',String.valueOf(mapjsonData.values().size()), String.valueOf(totalPages), String.valueOf(page), 'Schedule');
                if(mapjsonData.values().size() == 0 ){
                    ErrorLogHandler.log('Error in Building Schedule V3 #'+page, jsonResponse.left(131000));
                    token = null;
                    page -= 1;
                }
                //Database.upsert(mapjsonData.values(), false);
            }catch(exception e) {
                ErrorLogHandler.log('Building Schedule V3 exception #1 - Exception', e);
            }
        }else {
            ErrorLogHandler.log('Building Schedule V3 Information', 'No Values Returned');
        }

    }

    // Buildings Wrapper
    global class buildingWrapper {
        public String name;
        public String address;
        public String city;
        public String state;
        public String country;
        public String postcode;
        public String centre_key;
        public String building_key;
        public String building_code;
        public String building_type;
    }
}