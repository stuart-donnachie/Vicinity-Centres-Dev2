/*
    Date        : 12-09-2016
    Project     : Lease Management System
    Description : Contacts batch downloader

    Change History
    --------------
*/
global class ScheduleContact implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful {
    global String token;
    global Integer page;
    global Integer totalPages;
    global Map<String,Id> mapAccount;

    global ScheduleContact(String token, Integer page, Integer totalPages, Map<String,Id> mapAccount) {
        this.token = token;
        this.page = page;
        this.totalPages = totalPages;
        this.mapAccount = mapAccount;
		// Comment Here
    }

    global ScheduleContact(Integer page) {
        this.page = page;
        this.mapAccount = new Map<String,Id>();
    }

    global ScheduleContact() {
        this.page = 1;
        this.mapAccount = new Map<String,Id>();
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

        if (this.mapAccount.size() == 0) {
            for(Account a : [SELECT Id,Tenant_Key__c FROM Account]) {
                this.mapAccount.put(a.Tenant_Key__c, a.Id);
            }
        }

		if (String.isEmpty(this.token)) {
			this.token = this.getToken();
		}

        return new List<Contact>{new Contact()};
    }

    global void execute(Database.BatchableContext bc, List<Contact> obj) {
        System.debug('Executing Contact Schedule - Page#'+this.page);
        try {
            this.download(this.page);
        } catch(Exception ex) {
            ErrorLogHandler.log('Contact Schedule Exception - Page#'+ this.page,ex);
        }
    }

    global void finish(Database.BatchableContext bc) {
        if (this.page < this.totalPages) {
            //Database.executeBatch(new ScheduleContact(), 1000);
            Database.executeBatch(new ScheduleContact(this.token, this.page + 1, this.totalPages, this.mapAccount), 1000);
        }else  {
			System.scheduleBatch(new ScheduleCentreOutgoings(), 'Centre Outgoings Schedule', 0);
		}
    }

    global void download(Integer page) {
        HttpRequest request = new HttpRequest();
        request.setMethod('GET');
        request.setHeader('Authorization', 'Bearer ' + this.token);
        request.setHeader('Cache-Control', 'No-Cache');
        request.setEndpoint(Global_Settings__c.getInstance().API_URL_2__c+'/contacts?page='+ page);
        request.setTimeout(100000);

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

	public String keyFix(String key){
		return (String.valueOf(Decimal.valueOf(key).setscale(0)));
	}

	public Map<String, String> contactTypeMap{
		get{
			Map<String, String> tempMap = new Map<String, String> ();
			tempMap.put('A', 'Authorised Representative');
			tempMap.put('B', 'Billing Representative');
			tempMap.put('G', 'Gaurantor Representative');
			tempMap.put('L', 'Legal Representative');
			tempMap.put('R', 'Registered Representative');
			tempMap.put('Z', 'Notice Representative');

			return tempMap;
		}
	}

    global void save(String jsonResponse) {

		try{
			if(String.isEmpty(jsonResponse) || jsonResponse.substring(0,1) != '{'){
				ErrorLogHandler.log('Contact Schedule Error - Page : '+page, String.valueOf(jsonResponse));
			}

	        Map<String,Contact> mapjsonData = new Map<String,Contact>();
	        Set<String> contactKeySet = new Set<String>();

	        JSONParser parser = JSON.createParser(jsonResponse);
	        while(parser.nextToken() != null) {
	            if (this.totalPages == null && parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'total_pages') {
	                parser.nextToken();
	                this.totalPages = Integer.valueOf(parser.getText());
	            }
	            if(parser.getCurrentToken() == JSONToken.START_ARRAY) {
	                while(parser.nextToken() != null) {
	                    if(parser.getCurrentToken() == JSONToken.START_OBJECT) {

	                        contactWrapper ct = (contactWrapper)parser.readValueAs(contactWrapper.class);

	                        Contact objContact = new Contact();

	                        objContact.Tenant_Description__c = ct.description;
	                        objContact.Tenant_Key__c = ct.tenant_key;
	                        objContact.AccountId = String.isNotEmpty(ct.tenant_key) && mapAccount.containsKey(ct.tenant_key) ? Id.valueOf(this.mapAccount.get(ct.tenant_key)) : null;
	                        objContact.Contact_Code__c = ct.code;
	                        objContact.Contact_Key__c = ct.contact_key;
	                        //objContact.Contact_Key__c = keyFix(objContact.Contact_Key__c);
	                        objContact.Tenant_Additional_Information__c = '';
	                        objContact.Last_Updated_By_Job__c = system.now();
	                        objContact.JDE_Contact_Type_Code__c = ct.contact_type;
	                        objContact.Whos_Who_Line_Number__c = ct.detail_line_identifier;
							objContact.LastName = (String.isNotEmpty(ct.contact)) ? ct.contact : 'NA';
	                        objContact.Tenant_Rep_Type__c = contactTypeMap.get(ct.contact_type);
	                        if(ct.contact_details != null && ct.contact_details.size() > 0) {
	                        	//System.debug('contact_details - ' + String.valueOf(ct.contact_details));

	                        	for(contactDetails detail : ct.contact_details){
	                        		if(detail.phone_number_type == 'MOB' && String.isNotEmpty(detail.phone)){
	                        			objContact.MobilePhone = detail.phone;
	                        		}else if(detail.phone_number_type == 'BUS' && String.isNotEmpty(detail.phone)){
	                        			objContact.Phone = detail.phone;
	                        		}else if(detail.phone_number_type == 'FAX' && String.isNotEmpty(detail.phone)){
	                        			objContact.Fax = detail.phone;
	                        		}else if(detail.phone_number_type == 'HOM' && String.isNotEmpty(detail.phone)){
	                        			objContact.HomePhone = detail.phone;
	                        		}else if(String.isNotEmpty(detail.phone)){
	                        			objContact.OtherPhone = detail.phone;
	                        		}

									if(String.isNotEmpty(detail.phone) && detail.phone_number_type != 'FAX'){
			                            objContact.Phone_Number__c = detail.phone;
			                            objContact.Phone_Number_Type__c = detail.phone_number_type;
			                            objContact.Phone_Number_Prefix__c = detail.phone_number_prefix;
									}
	                        	}

	                            objContact.Tenant_Email__c = ct.contact_details[0].email;
	                            objContact.mailingStreet = ct.contact_details[0].address_line_1 + ct.contact_details[0].address_line_2 + ct.contact_details[0].address_line_3 + ct.contact_details[0].address_line_4;
	                            objContact.mailingCity = ct.contact_details[0].city;
	                            objContact.mailingState = ct.contact_details[0].state;
	                            objContact.mailingCountry = ct.contact_details[0].country;
	                            objContact.Tenant_Rep_ACN__c = ct.contact_details[0].acn;
	                        }

							if(String.isNotEmpty(objContact.MobilePhone)){ // Fallback to MobilePhone number
								objContact.Phone_Number__c = objContact.MobilePhone;
		                        objContact.Phone_Number_Type__c = 'MOB';
		                        objContact.Phone_Number_Prefix__c = null;
							}else if(String.isEmpty(objContact.MobilePhone) && String.isNotEmpty(objContact.Phone)){
								objContact.Phone_Number__c = objContact.Phone;
		                        objContact.Phone_Number_Type__c = 'BUS';
		                        objContact.Phone_Number_Prefix__c = null;
							}
							//if(mapjsonData.containsKey(objContact.Contact_Key__c)){
								//ErrorLogHandler.log('Error : Contact Schedule Duplicate Key',objContact.Contact_Key__c, String.valueOf(mapjsonData.values().size()), String.valueOf(totalPages), String.valueOf(page), 'Schedule');
							//}
	                        mapjsonData.put(objContact.Contact_Key__c,objContact);
	                    }
	                }
	            }
	        }

			for(Contact c :[SELECT Id, Tenant_Description__c, Tenant_Key__c, Contact_Code__c, LastName, Tenant_Rep_Type__c,
	                                                        Tenant_Email__c, Phone_Number__c, Phone_Number_Type__c, Phone_Number_Prefix__c,
	                                                        mailingStreet, mailingCity, mailingState, mailingCountry, Contact_Key__c, AccountId,
	                                                        Tenant_Additional_Information__c, Last_Updated_By_Job__c, Tenant_Rep_ACN__c
	                                                        FROM Contact
	                                                        WHERE Contact_Key__c in :mapjsonData.keyset()]){

				if(mapjsonData.containsKey(c.Contact_Key__c)){
					mapjsonData.get(c.Contact_Key__c).Id = c.Id;
				}
			}

			upsert mapjsonData.values();
			ErrorLogHandler.log('Contact Schedule',String.valueOf(mapjsonData.values().size()), String.valueOf(totalPages), String.valueOf(page), 'Schedule');
			if(mapjsonData.values().size() == 0 && !Test.isRunningTest()){
				ErrorLogHandler.log('Error in Contact Schedule #'+page, jsonResponse.left(131000));
				token = null;
				page -= 1;
			}
			//Database.upsert(mapjsonData.values(), false);
		}catch(exception e) {
			ErrorLogHandler.log('Contact Schedule exception #1 - Exception', e);
			ErrorLogHandler.log('Contact Schedule exception #2 - Exception', jsonResponse);
		}
    }

    global class contactWrapper {
        public String code;
        public String description;
        public String contact_type;
        public String contact;
        public String contact_key;
        public String detail_line_identifier;
        public String tenant_key;
        public List<contactDetails> contact_details;
    }

    global class contactDetails {
        public String email;
        public String phone;
        public String phone_number_type;
        public String phone_number_prefix;
        public String city;
        public String state;
        public String country;
        public String address_line_1;
        public String address_line_2;
        public String address_line_3;
        public String address_line_4;
        public String acn;
    }
}