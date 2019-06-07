global with sharing class ScheduleLeasingAdministratorV3 {

    global static String getToken() {
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


    public static String getLeasingAdministrators(String token){

        HttpRequest request = new HttpRequest();
        request.setMethod('GET');
        request.setHeader('Authorization', 'Bearer ' + token);
        request.setHeader('Cache-Control', 'No-Cache');
        request.setEndpoint(Global_Settings__c.getInstance().API_URL_4__c+'/leasing/leasing-administrators');
        request.setTimeout(100000);

        Http http = new Http();
        HttpResponse response = http.send(request);
        if (hasRedirect(response)) {
            response = handleRedirect(response);
        }

        return String.valueOf(response.getBody());
    }

    public static Boolean hasRedirect(HttpResponse res) {
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

    public static HttpResponse handleRedirect(HttpResponse res) {
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        req.setEndpoint(res.getHeader('Location'));

        Http http = new Http();
        HttpResponse response = http.send(req);

        return response;
    }

    @future(callout=true)
    global static void run(){

        //Callouts
        String token = getToken();
        String las = getLeasingAdministrators(token);

        //Save Response
        updateContacts(las);
    }

    global void execute(SchedulableContext SC)
    {
        try{
            run();
        } catch(Exception ex) {
            ErrorLogHandler.log('Leasing Admin Schedule V3 Exception ', ex);
        }
    }

    public static Boolean updateContacts(String leJSON){

        Map<String,Contact> contactsToUpdate = new Map<String,Contact>();
        Boolean returnValue = false;

        try {

            if(!String.isEmpty(leJSON) && leJSON != '[]'){
                JSONParser parser = JSON.createParser(leJSON);

                while(parser.nextToken() != null) {
                    if(parser.getCurrentToken() == JSONToken.START_ARRAY) {

                        while(parser.nextToken() != null) {
                            if(parser.getCurrentToken() == JSONToken.START_OBJECT) {
                                leWrapper la = (leWrapper)parser.readValueAs(leWrapper.class);

                                Contact tempContact = new Contact();

                                tempContact.Address_Number__c = stringNullChecker(la.code);
                                //tempUser.Name = stringNullChecker(la.name);
                                tempContact.FirstName = getFirstName(la.name);
                                tempContact.LastName = getLastName(la.name);
                                tempContact.Title = stringNullChecker(la.title);
                                tempContact.Email = stringNullChecker(la.email);
                                tempContact.Tenant_Rep_Type__c = 'Leasing Administrator';

                                contactsToUpdate.put(la.email, tempContact);
                            }
                        }

                    }

                }
            }


            for(Contact c :[SELECT Name, Id, Email
            FROM Contact
            WHERE Tenant_Rep_Type__c = 'Leasing Administrator'
            AND Email IN :contactsToUpdate.keyset()]){
                if(contactsToUpdate.containsKey(c.Email)){
                    contactsToUpdate.get(c.Email).Id = c.Id;
                }
            }

            returnValue = true;
            upsert contactsToUpdate.values();
            //Database.upsert(contactsToUpdate.values(), false);
        } catch (exception e) {
            ErrorLogHandler.log('Leasing Admin Schedule V3 exception #1 - Exception', e);
            ErrorLogHandler.log('Leasing Admin Schedule V3 exception #2 - JSON', leJSON);
        }

        if(!returnValue){
            ErrorLogHandler.log('Leasing Admin Schedule V3 failure #1 - JSON', leJSON);
        }

        return returnValue;
    }


    public static String getFirstName(String value){
        return (String.isNotEmpty(value) ? value.split(' ')[0] : null);
    }

    public static String getLastName(String value){
        return (String.isNotEmpty(value) ? value.split(' ')[1] : null);
    }

    public static String stringNullChecker(String value){
        return (String.isNotEmpty(value) ? value : null);
    }

    global class leWrapper {
        public String code;
        public String name;
        public String title;
        public String mobile;
        public String phone;
        public String mailing_name;
        public String email;
    }
}