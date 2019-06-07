global with sharing class LiveSchedule implements Schedulable  {


	public static HttpResponse handleRedirect(HttpResponse res) {
      	HttpRequest req = new HttpRequest();
      	req.setMethod('GET');
      	req.setEndpoint(res.getHeader('Location'));

		Http http = new Http();
		HttpResponse response = http.send(req);

		return response;
	}

	//Get auth token
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

	//Get records
	global static String getRecords(String token, String endpoint){

		HttpRequest request = new HttpRequest();
		request.setMethod('GET');
		request.setHeader('Authorization', 'Bearer ' + token);
		request.setHeader('Cache-Control', 'No-Cache');
		request.setEndpoint(Global_Settings__c.getInstance().API_URL_2__c+endpoint); // Stuart Donnachie - changed from API_URL_3__c to API_URL_2__c 18/01/2018
		request.setTimeout(100000);

		Http http = new Http();
		HttpResponse response = http.send(request);

		if (hasRedirect(response)) {
			response = handleRedirect(response);
		}

		return String.valueOf(response.getBody());
	}

	//Save tenants
	global static void saveTenants(String tenantsJSON){
		if(!String.isEmpty(tenantsJSON) && tenantsJSON != '[]'){
	    	Map<String, tenantWrapper> tenantsFromAPI = new Map<String, tenantWrapper>();
	    	Map<String, Account> exsistingTenants = new Map<String, Account>();
	    	List<Account> tenantsToUpsert = new List<Account>();

	    	for(tenantWrapper tenant: parseTenant(tenantsJSON)){
	    		tenantsFromAPI.put(tenant.tenant_key, tenant);
	    	}
			System.debug('tenantsFromAPI - '+tenantsFromAPI.size());
	    	for(Account tenant : [SELECT Name, Id,Tenant_Key__c FROM Account WHERE Tenant_Key__c IN :tenantsFromAPI.keySet()]){
	    		exsistingTenants.put(tenant.Tenant_Key__c, tenant);
	    	}
	    	System.debug('exsistingTenants - '+exsistingTenants.size());
	    	for(String tenantKey : tenantsFromAPI.keySet()){
	    		Account tempTenant = new Account();

	    		tenantWrapper tenant = tenantsFromAPI.get(tenantKey);

	    		if(exsistingTenants.containsKey(tenantKey)){
	    			tempTenant.Id = exsistingTenants.get(tenantKey).Id;
	    		}

	    		tempTenant.Tenant_CABID__c = tenant.jde_business_key;
				tempTenant.Legal_Group__c = tenant.legal_group;
				tempTenant.Tenant_Entity__c = tenant.trading_name;
				tempTenant.Trading_Group__c = tenant.trading_group;
				tempTenant.Tenant_ACN__c = tenant.acn;
				tempTenant.ABN__c = tenant.abn;
				tempTenant.Tenant_Key__c = tenant.tenant_key;
				tempTenant.Name = tenant.tenant_name;
				tempTenant.Last_Updated_By_Job__c = system.now();

				tenantsToUpsert.add(tempTenant);
	    	}
	    	//----------

	    	upsert tenantsToUpsert;
	    	System.debug('tenantsToUpsert - '+tenantsToUpsert.size());
			ErrorLogHandler.log('LiveSchedule.NumberTenantsUpdated - ' + tenantsToUpsert.size());
		}
	}

	//Save units
	global static void saveUnits(String unitsJSON){

		Set<String> buildingKeys = new 	Set<String>();
		Set<String> centreKeys = new Set<String>();
		Set<String> tenantKeys = new Set<String>();

		if(!String.isEmpty(unitsJSON) && unitsJSON != '[]'){
	    	Map<String, unitWrapper> unitsFromAPI = new Map<String, unitWrapper>();
	    	Map<String, Unit__c> exsistingUnits = new Map<String, Unit__c>();
	    	List<Unit__c> unitsToUpsert = new List<Unit__c>();

	    	for(unitWrapper unit: parseUnit(unitsJSON)){
	    		unitsFromAPI.put(unit.unit_key, unit);
	    	}
			System.debug('unitsFromAPI - '+unitsFromAPI.size());

	    	for(Unit__c unit : [SELECT Name, Id,Unit_Key__c FROM Unit__c WHERE Unit_Key__c IN :unitsFromAPI.keySet()]){
	    		exsistingUnits.put(unit.Unit_Key__c, unit);
	    	}
	    	System.debug('exsistingUnits - '+exsistingUnits.size());

	    	for(String unitKey : unitsFromAPI.keySet()){
	    		unitWrapper unitTemp = unitsFromAPI.get(unitKey);

	    		buildingKeys.add(unitTemp.building_key);
	    		centreKeys.add(unitTemp.centre_key);
	    		tenantKeys.add(unitTemp.current_tenant_key);
	    	}

	    	Map<String,Centre__c> centresMap = getCentresMap(centreKeys);
	    	Map<String,Building__c> buildingsMap = getBuildingsMap(buildingKeys);
	    	Map<String,Account> tenantsMap = getTenantsMap(tenantKeys);

	    	for(String unitKey : unitsFromAPI.keySet()){
	    		Unit__c tempUnit = new Unit__c();

	    		unitWrapper unit = unitsFromAPI.get(unitKey);

	    		if(exsistingUnits.containsKey(unitKey)){
	    			tempUnit.Id = exsistingUnits.get(unitKey).Id;
	    		}

	    		tempUnit.Name = unit.unit_name;
				tempUnit.Unit_Code__c = unit.unit_type_deal_name;
				tempUnit.Unit_Type__c = unit.unit_type_deal_code;
				tempUnit.Area_of_Premises__c = (unit.area != null) ? Decimal.valueOf(unit.area) : null;
				tempUnit.Floor_Level__c = unit.floor;
				tempUnit.Centre_Key__c = unit.centre_key;
				tempUnit.Unit_Key__c = unit.unit_key;
				tempUnit.Centre__c = centresMap.get(unit.centre_key).Id;
				tempUnit.Building_Key__c = unit.building_key;
				tempUnit.Building__c = buildingsMap.get(unit.building_key).Id;
				tempUnit.Current_Tenant__c = (!String.isEmpty(unit.current_tenant_key) && unit.current_tenant_key != 'None') ? tenantsMap.get(unit.current_tenant_key).Id : null;
				tempUnit.Current_Tenant_Key__c = (!String.isEmpty(unit.current_tenant_key) && unit.current_tenant_key != 'None') ? unit.current_tenant_key : null;
				tempUnit.System_Unit_Category__c = unit.system_defined_unit_category;
				tempUnit.Current_Tenant_Trading_Name__c = unit.current_tenant_name;
				tempUnit.Last_Updated_By_Job__c = system.now();

				unitsToUpsert.add(tempUnit);
	    	}

	    	upsert unitsToUpsert;
	    	System.debug('unitsToUpsert - '+unitsToUpsert.size());
			ErrorLogHandler.log('LiveSchedule.NumberUnitsUpdated - ' + unitsToUpsert.size());
		}
	}

	//Save contacts
	global static void saveContacts(String contactsJSON){
		Set<String> tenantKeys = new Set<String>();

		if(!String.isEmpty(contactsJSON) && contactsJSON != '[]'){
	    	Map<String, contactWrapper> contactsFromAPI = new Map<String, contactWrapper>();
	    	Map<String, Contact> exsistingContacts = new Map<String, Contact>();
	    	List<Contact> contactsToUpsert = new List<Contact>();

	    	for(contactWrapper contact: parseContact(contactsJSON)){
	    		contactsFromAPI.put(contact.contact_key, contact);
	    	}
			System.debug('contactsFromAPI - '+contactsFromAPI.size());

	    	for(Contact contact : [SELECT Name, Id,Contact_Key__c FROM Contact WHERE Contact_Key__c IN :contactsFromAPI.keySet()]){
	    		exsistingContacts.put(contact.Contact_Key__c, contact);
	    	}
	    	System.debug('exsistingContacts - '+exsistingContacts.size());

	    	for(String contactKey : contactsFromAPI.keySet()){
	    		contactWrapper contactTemp = contactsFromAPI.get(contactKey);

	    		tenantKeys.add(contactTemp.tenant_key);
	    	}

	    	Map<String,Account> tenantsMap = getTenantsMap(tenantKeys);

	    	for(String contactKey : contactsFromAPI.keySet()){
	    		Contact tempContact = new Contact();

	    		contactWrapper contact = contactsFromAPI.get(contactKey);

	    		if(exsistingContacts.containsKey(contactKey)){
	    			tempContact.Id = exsistingContacts.get(contactKey).Id;
	    		}

                tempContact.Tenant_Description__c = contact.description;
                tempContact.Tenant_Key__c = contact.tenant_key;
                tempContact.AccountId = tenantsMap.containsKey(contact.tenant_key) ? tenantsMap.get(contact.tenant_key).Id : null;
                tempContact.Contact_Code__c = contact.code;
                tempContact.Contact_Key__c = contact.contact_key;
                tempContact.Tenant_Additional_Information__c = '';
                tempContact.Last_Updated_By_Job__c = system.now();
                tempContact.JDE_Contact_Type_Code__c = contact.contact_type;
                tempContact.Whos_Who_Line_Number__c = contact.detail_line_identifier;
				tempContact.LastName = (String.isNotEmpty(contact.contact)) ? contact.contact : 'NA';
                tempContact.Tenant_Rep_Type__c = contactTypeMap.get(contact.contact_type);
				if(contact.contact_details != null && contact.contact_details.size() > 0) {
					//System.debug('contact_details - ' + String.valueOf(ct.contact_details));

					for(contactDetails detail : contact.contact_details){
						if(detail.phone_number_type == 'MOB' && String.isNotEmpty(detail.phone)){
							tempContact.MobilePhone = detail.phone;
						}else if(detail.phone_number_type == 'BUS' && String.isNotEmpty(detail.phone)){
							tempContact.Phone = detail.phone;
						}else if(detail.phone_number_type == 'FAX' && String.isNotEmpty(detail.phone)){
							tempContact.Fax = detail.phone;
						}else if(detail.phone_number_type == 'HOM' && String.isNotEmpty(detail.phone)){
							tempContact.HomePhone = detail.phone;
						}else if(String.isNotEmpty(detail.phone)){
							tempContact.OtherPhone = detail.phone;
						}

						if(String.isNotEmpty(detail.phone) && detail.phone_number_type != 'FAX'){
							tempContact.Phone_Number__c = detail.phone;
							tempContact.Phone_Number_Type__c = detail.phone_number_type;
							tempContact.Phone_Number_Prefix__c = detail.phone_number_prefix;
						}
					}

					if(String.isNotEmpty(tempContact.MobilePhone)){ // Fallback to MobilePhone number
						tempContact.Phone_Number__c = tempContact.MobilePhone;
                        tempContact.Phone_Number_Type__c = 'MOB';
                        tempContact.Phone_Number_Prefix__c = null;
					}else if(String.isEmpty(tempContact.MobilePhone) && String.isNotEmpty(tempContact.Phone)){
						tempContact.Phone_Number__c = tempContact.Phone;
                        tempContact.Phone_Number_Type__c = 'BUS';
                        tempContact.Phone_Number_Prefix__c = null;
					}

					tempContact.Tenant_Email__c = contact.contact_details[0].email;
					tempContact.mailingStreet = contact.contact_details[0].address_line_1 + contact.contact_details[0].address_line_2 + contact.contact_details[0].address_line_3 + contact.contact_details[0].address_line_4;
					tempContact.mailingCity = contact.contact_details[0].city;
					tempContact.mailingState = contact.contact_details[0].state;
					tempContact.mailingCountry = contact.contact_details[0].country;
					tempContact.Tenant_Rep_ACN__c = contact.contact_details[0].acn;
				}

				contactsToUpsert.add(tempContact);
	    	}

	    	upsert contactsToUpsert;
	    	System.debug('contactsToUpsert - '+contactsToUpsert.size());
			ErrorLogHandler.log('LiveSchedule.NumberContactsUpdated - ' + contactsToUpsert.size());
		}
	}

	@Future(Callout=true)
	global static void run(){

		// Tenants Callout
		try{
			//Callouts
			String token = getToken();

			String tenants = getRecords(token,'/tenants-daily-changes');
			String contacts = getRecords(token,'/contacts-daily-changes');
			String units = getRecords(token,'/units-daily-changes');


			//Save Response
			saveTenants(tenants);
			saveContacts(contacts);
			saveUnits(units);


		} catch(Exception ex) {
			ErrorLogHandler.log('LiveSchedule.Exception', ex);
		}
	}

	global void execute(SchedulableContext SC)
    {
		try{
			run();
		} catch(Exception ex) {
			ErrorLogHandler.log('LiveSchedule.Exception', ex);
		}

    }

	global static Map<String, String> contactTypeMap{
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

	static Map<String,Centre__c> getCentresMap  (Set<String> centreKeys){
		Map<String,Centre__c> tempMap = new Map<String,Centre__c>();
		for(Centre__c c : [SELECT Id,Centre_Key__c FROM Centre__c WHERE Centre_Key__c IN :centreKeys]){
			tempMap.put(c.Centre_Key__c,c);
		}

		return tempMap;
	}

	static Map<String,Building__c> getBuildingsMap (Set<String> buildingKeys){
			Map<String,Building__c> tempMap = new Map<String,Building__c>();

			for(Building__c b : [SELECT Id,Building_Key__c FROM Building__c WHERE Building_Key__c IN :buildingKeys]){
				tempMap.put(b.Building_Key__c,b);
			}

			return tempMap;
	}

	static Map<String,Account> getTenantsMap  (Set<String> tenantKeys){
			Map<String,Account> tempMap = new Map<String,Account>();

			for(Account a : [SELECT Id,Tenant_Key__c FROM Account WHERE Tenant_Key__c IN :tenantKeys]){
				tempMap.put(a.Tenant_Key__c,a);
			}

			return tempMap;
	}

	public static Boolean  hasRedirect(HttpResponse res) {
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

	// Parsers
    global static List<unitWrapper> parseUnit(String json) {
        return (List<unitWrapper>) System.JSON.deserialize(json, List<unitWrapper>.class);
    }

    global static List<tenantWrapper> parseTenant(String json) {
        return (List<tenantWrapper>) System.JSON.deserialize(json, List<tenantWrapper>.class);
    }

    global static List<contactWrapper> parseContact(String json) {
        return (List<contactWrapper>) System.JSON.deserialize(json, List<contactWrapper>.class);
    }

	//Wrappers
    global class tenantWrapper {
		public String jde_business_key;
		public String legal_group;
		public String tenant_name;
		public String acn;
		public String abn;
		public String trading_group;
		public String tenant_key;
		public String trading_name;
		public String auditdate;
	}

    global class unitWrapper {
		public String unit_name;
		public String unit_type_deal_name;
		public String unit_type_deal_code;
		public String area;
		public String floor;
		public String centre_key;
		public String building_key;
		public String unit_key;
		public String current_tenant_key;
		public String current_tenant_name;
		public String system_defined_unit_category;
		public String start_date;
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