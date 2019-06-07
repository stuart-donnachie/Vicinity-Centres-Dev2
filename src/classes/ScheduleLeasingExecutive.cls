global with sharing class ScheduleLeasingExecutive {

    public static Map<String, User> getUserMap(){
		Map<String, User> tempMap = new Map<String, User>();
		
		for(User u: [SELECT Name, Id, Email FROM User]){
			tempMap.put(u.Email, u);
		}
		
		return tempMap;
    }
    
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
	
		
	public static String getLeasingExecutives(String token){
		
		HttpRequest request = new HttpRequest();
		request.setMethod('GET');
		request.setHeader('Authorization', 'Bearer ' + token);
		request.setHeader('Cache-Control', 'No-Cache');
		request.setEndpoint(Global_Settings__c.getInstance().API_URL_2__c+'/leasing-executives');
		request.setTimeout(100000);
		
		Http http = new Http();
		HttpResponse response = http.send(request);
		if (hasRedirect(response)) {
			response = handleRedirect(response);
		}
		
		System.debug(String.valueOf(response.getBody()));
		
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
		String les = getLeasingExecutives(token);
		
		//Save Response
		updateUsers(les);
	}
	
	global void execute(SchedulableContext SC)
    {	
		try{
			run();
		} catch(Exception ex) {
			ErrorLogHandler.log('Live schedule failure', ex);
		}
    	
    }
	
	
	public static Boolean updateUsers(String leJSON){
		
		List<User> usersToUpdate = new List<User>();
		Boolean returnValue = false;
		
		try {
			if(!String.isEmpty(leJSON) && leJSON != '[]'){
				JSONParser parser = JSON.createParser(leJSON);
				
				while(parser.nextToken() != null) { 
		            if(parser.getCurrentToken() == JSONToken.START_ARRAY) {
		            	       
		            	while(parser.nextToken() != null) {
		                	if(parser.getCurrentToken() == JSONToken.START_OBJECT) {
		                        leWrapper tp = (leWrapper)parser.readValueAs(leWrapper.class);
	
		                        if(getUserMap().containsKey(tp.email)){
		                        	User tempUser = getUserMap().get(tp.email);
		                        	
		                        	tempUser.Address_Number__c = stringNullChecker(tp.code);
		                        	//tempUser.Name = stringNullChecker(tp.name);
		                        	tempUser.FirstName = getFirstName(tp.name);
		                        	tempUser.LastName = getLastName(tp.name);
		                        	tempUser.Title = stringNullChecker(tp.title);
		                        	tempUser.MobilePhone = stringNullChecker(tp.mobile);
		                        	tempUser.Phone = stringNullChecker(tp.phone);
		                        	tempUser.SenderName = stringNullChecker(tp.mailing_name);
		                        	tempUser.SenderEmail = stringNullChecker(tp.email);
		                        	
		                        	usersToUpdate.add(tempUser);
		                        }
		                	}
		            	}
		        	}
		        }	
			}
			
        	returnValue = true;
        	update usersToUpdate;
        	//Database.update(usersToUpdate, false);
        } catch (exception e) {
        	ErrorLogHandler.log('Tenant profile update exception #1 - Exception', e);
        	ErrorLogHandler.log('Tenant profile update exception #2 - JSON', leJSON);
        }
		
		if(!returnValue){
			ErrorLogHandler.log('Tenant profile update failure #1 - JSON', leJSON);
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