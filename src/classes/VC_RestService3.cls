/**
 * Created by stuartdonnachie on 2/10/18.
 */

/*
Date        : 02-10-2018
Project     : VC
Description : Rest Web Service API - 3rd Version

Change History
--------------

*/
@RestResource(urlMapping='/api/v3/*')
global without sharing class VC_RestService3 {


    @HttpPost
    global static void updateUnit() {
    Map<String,Id> mapCentre = new Map<String,Id>();
    Map<String,Id> mapBuilding = new Map<String,Id>();
    Map<String,Id> mapTenant = new Map<String,Id>();
    Map<String,Id> mapBU = new Map<String,Id>();

    //Request
    String requestBody = RestContext.request.requestBody.toString().trim();

    //Retrieve URL parameters
    String content = RestContext.request.params.containsKey('content') ? RestContext.request.params.get('content') : '';

    //Variable parameters
    Map<String, Object> returnMessage = new Map<String, Object>();

        //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

        try{
            if (content == 'Unit') {


                System.debug('xxxx 1');
                Map<String,Unit__c> mapjsonData = new Map<String,Unit__c>();
                System.debug('xxxx 2');
                // Centres
                if (mapCentre.size() == 0) {
                    for(Centre__c c : [SELECT Id,Centre_Key__c FROM Centre__c]){
                        mapCentre.put(c.Centre_Key__c,c.Id);
                    }
                }
                System.debug('xxxx 3');
                // Buildings
                if (mapBuilding.size() == 0) {
                    for(Building__c b : [SELECT Id,Building_Key__c FROM Building__c]){
                        mapBuilding.put(b.Building_Key__c,b.Id);
                    }
                }
                System.debug('xxxx 4');
                // Tenants
                if (mapTenant.size() == 0) {
                    for(Account a : [SELECT Id,Tenant_Key__c FROM Account]){
                        mapTenant.put(a.Tenant_Key__c,a.Id);
                    }
                }
                System.debug('xxxx 5');
                // BUs
                if (mapBU.size() == 0) {
                    for(Business_Unit__c bu : [SELECT Id,Business_Unit_Key__c FROM Business_Unit__c]){
                        mapBU.put(bu.Business_Unit_Key__c,bu.Id);
                    }
                }

                System.debug('xxxx 6');
                System.debug('unit_response'+requestBody);

                JSONParser parser = JSON.createParser(requestBody);
                System.debug('PARSER xxx '+parser);

                while(parser.nextToken() != null) {
                    if(parser.getCurrentToken() == JSONToken.START_ARRAY) {
                        while(parser.nextToken() != null) {
                            if(parser.getCurrentToken() == JSONToken.START_OBJECT) {

                                unitWrapper ut = (unitWrapper)parser.readValueAs(unitWrapper.class);

                                if (!mapjsonData.containsKey(ut.unit_key)){
                                    Unit__c objUnit = new Unit__c();

                                    objUnit.Name = ut.unit;
                                    objUnit.Unit_Code__c = ut.unit_type_deal_name;
                                    objUnit.Unit_Type__c = ut.unit_type_deal_code;
                                    objUnit.Area_of_Premises__c = Decimal.valueOf(ut.area);
                                    objUnit.Floor_Level__c = ut.floor;
                                    objUnit.Centre_Key__c = ut.centre_key;
                                    objUnit.Centre__c = mapCentre.containsKey(ut.centre_key) ?Id.valueOf(mapCentre.get(ut.centre_key)) : null;
                                    objUnit.Business_Unit__c = mapBU.containsKey(ut.business_unit_key) ?Id.valueOf(mapBU.get(ut.business_unit_key)) : null;
                                    objUnit.Building_Key__c = ut.building_key;
                                    objUnit.Building__c = mapBuilding.containsKey(ut.building_key) ? Id.valueOf(mapBuilding.get(ut.building_key)) : null;
                                    objUnit.Current_Tenant__c = (!String.isEmpty(ut.tenant_key) && ut.tenant_key != 'None' && mapTenant.containsKey(ut.tenant_key))
                                            ? Id.valueOf(mapTenant.get(ut.tenant_key)) : null;
                                    objUnit.Unit_Key__c = ut.unit_key;
                                    objUnit.Current_Tenant_Key__c = (!String.isEmpty(ut.tenant_key) && ut.tenant_key != 'None') ? ut.tenant_key : null;
                                    objUnit.System_Unit_Category__c = ut.system_defined_unit_code;
                                    objUnit.Current_Tenant_Trading_Name__c = ut.current_tenant_name;
                                    objUnit.Last_Updated_By_Job__c = system.now();

                                    mapjsonData.put(objUnit.Unit_Key__c,objUnit);
                                }

                            }
                        }
                    }
                }

                for(Unit__c u :[SELECT Id, Name, Unit_Code__c, Unit_Type__c, Area_of_Premises__c, Floor_Level__c, System_Unit_Category__c,
                        Centre_Key__c, Building_Key__c, Unit_Key__c , Last_Updated_By_Job__c,
                        Current_Tenant__c, Current_Tenant_Trading_Name__c, Current_Tenant_Key__c
                FROM Unit__c
                WHERE Unit_Key__c in :mapjsonData.keyset()]){

                    if(mapjsonData.containsKey(u.Unit_Key__c)){
                        mapjsonData.get(u.Unit_Key__c).Id = u.Id;
                    }
                }

                try{
                    upsert mapjsonData.values();
                    ErrorLogHandler.log('RestService.V3.Unit.Response',requestBody, 'Number of Units sent ' + String.valueOf(mapjsonData.values().size()));
                    returnMessage.put('status', true);
                    returnMessage.put('message', 'Unit Updated Sucessfully');
                }catch(exception e) {
                    ErrorLogHandler.log('RestService.V3.Unit.Response #1 - Exception', e);
                    ErrorLogHandler.log('RestService.V3.Unit.Response #2 - Exception', requestBody);
                }

            } else if(content=='tenant'){
               /* System.debug('tdp_response'+requestBody);
                TdpResponse tdpRes = (TdpResponse) System.JSON.deserialize(requestBody, TdpResponse.class);
                if(Boolean.valueOf(tdpRes.status)){
                    Opportunity opp = [SELECT Name, Id FROM Opportunity WHERE Deal_Key__c = :TdpRes.deal_key];
                    opp.TDP_Created__c = true;
                    opp.TDP_Creation_Error__c = false;

                    update opp;
                }else{
                    Opportunity opp = [SELECT Name, Id, Owner.Email FROM Opportunity WHERE Deal_Key__c = :TdpRes.deal_key];
                    opp.TDP_Creation_Error__c = true;
                    opp.TDP_Created__c = false;

                    update opp;

                    //sendEmail('TDP Creation Error', requestBody, opp.Owner.Email);
                }

                ErrorLogHandler.log('RestService.V2.TDP.Response',requestBody, tdpRes.deal_key);
                returnMessage.put('message', 'TDP Response Recieved');
                returnMessage.put('status', true);*/
            }else if(content=='contact'){
                System.debug('lon_response'+requestBody);
                ContactWrapper contactResponse = (ContactWrapper) System.JSON.deserialize(requestBody, ContactWrapper.class);

                Contact contact = [SELECT Name, Id FROM Contact WHERE Id = :contactResponse.contact_key];
                contact.FirstName = 'xxx';

                update contact;

                ErrorLogHandler.log('RestService.V3.Contact.Response',requestBody, contactResponse.contact_key);
                returnMessage.put('message', 'Contact Updated');
                returnMessage.put('status', true);
            }else{
                throw new RestResourceException('Invalid content request');
            }
        }
        catch(exception ex){
            ErrorLogHandler.log('RestService.V3.Exception #1 :' + content ,ex);
            ErrorLogHandler.log('RestService.V3.Exception #2 :' + content,requestBody);
            returnMessage.put('status', false);
            returnMessage.put('message', ex.getMessage());
            RestContext.response.statusCode = 400;
        }

        RestContext.response.addHeader('Content-Type', 'application/json');
        RestContext.response.responseBody = Blob.valueOf(JSON.serialize(returnMessage));
    }


    public class UnitWrapper {
        public String status;
        public String reason;
        public List<String> message;

        public String unit;
        public String unit_type_deal_name;
        public String unit_type_deal_code;
        public String area;
        public String floor;
        public String centre_key;
        public String building_key;
        public String business_unit_key;
        public String unit_key;
        public String tenant_key;
        public String current_tenant_name;
        public String system_defined_unit_code;


        public UnitWrapper() {
            message = new List<String>();
        }
    }

    public class ContactWrapper {
        public String status;
        public String reason;
        public List<String> message;
        public String contact_key;

        public ContactWrapper() {
            message = new List<String>();
        }
    }

    public class RestResourceException extends Exception {

    }


}