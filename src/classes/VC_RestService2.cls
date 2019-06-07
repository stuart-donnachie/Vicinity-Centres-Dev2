/*
Date        : 09-12-2016
Project     : VC
Description : Rest Web Service API

Change History
--------------

*/
@RestResource(urlMapping='/api/v2/*')
global without sharing class VC_RestService2 {
    @HttpPost
    global static void doPost() {
    	//Temp Records
        Map<String, Object> tempRecord;
        List<Map<String, Object>> tempRecords = new List<Map<String, Object>>();

		//Request
		String requestBody = RestContext.request.requestBody.toString().trim();

        //Retrevie URL parameters
        String content = RestContext.request.params.containsKey('content') ? RestContext.request.params.get('content') : '';

        //Variable parameters
        Map<String, Object> returnMessage = new Map<String, Object>();

        //JSON parser
        JSONParser parser = JSON.createParser(requestBody);

        //Common methods
        VC_DealsCommon dealsCommon = new VC_DealsCommon();

        try{
            if(content=='ecm_response'){
				System.debug('ecm_response'+requestBody);
            	EcmResponse ecmRes = (EcmResponse) System.JSON.deserialize(requestBody, EcmResponse.class);

				if(Boolean.valueOf(ecmRes.status)){
	            	Opportunity opp = dealsCommon.getDeal([SELECT Name, Id, Deal_Key__c,EOI_Documents__c
	            						FROM Opportunity WHERE Deal_Key__c = :ecmRes.deal_key LIMIT 1].Id);

	            	opp.EOI_Documents__c = JSON.serialize(ecmRes.links);
	            	update opp;

					VC_Deal_DetailsController.generateEOI(opp.Id);
				}
				ErrorLogHandler.log('RestService.V2.ECM.Response',requestBody, ecmRes.deal_key);
            	returnMessage.put('status', true);
            	returnMessage.put('message', 'EOI Generated Sucessfully');
            }else if(content=='tdp_response'){
            	System.debug('tdp_response'+requestBody);
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
            	returnMessage.put('status', true);
            }else if(content=='lon_response'){
            	System.debug('lon_response'+requestBody);
            	LonResponse lonRes = (LonResponse) System.JSON.deserialize(requestBody, LonResponse.class);

            	Opportunity opp = [SELECT Name, Id FROM Opportunity WHERE Deal_Key__c = :lonRes.deal_key];
            	opp.LON_Generated__c = false;

            	update opp;

            	ErrorLogHandler.log('RestService.V2.LON.Response',requestBody, lonRes.deal_key);
            	returnMessage.put('message', 'LON re-opened');
            	returnMessage.put('status', true);
            }else{
                throw new RestResourceException('Invalid content request');
            }
        }
        catch(exception ex){
            ErrorLogHandler.log('RestService.V2.Exception #1 :' + content ,ex);
            ErrorLogHandler.log('RestService.V2.Exception #2 :' + content,requestBody);
            returnMessage.put('status', false);
            returnMessage.put('message', ex.getMessage());
            RestContext.response.statusCode = 400;
        }

        RestContext.response.addHeader('Content-Type', 'application/json');
        RestContext.response.responseBody = Blob.valueOf(JSON.serialize(returnMessage));
    }

    public static void sendEmail(String subject, String message, String email){

		Messaging.reserveSingleEmailCapacity(2);
		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		String[] toAddresses = new String[] {email};
		mail.setToAddresses(toAddresses);
		mail.setSenderDisplayName('Salesforce Administrator');
		mail.setSubject(subject);
		mail.setBccSender(false);
		mail.setUseSignature(false);
		mail.setHtmlBody(message);
		Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }

    public class RestResourceException extends Exception {

    }

 	public class TdpResponse {
	    public String status;
	    public String reason;
	    public List<String> message;
	    public String deal_key;

	    public TdpResponse(){
	    	message = new List<String>();
	    }
	}

     public class LonResponse {
	    public String status;
	    public String reason;
	    public List<String> message;
	    public String deal_key;

	    public LonResponse(){
	    	message = new List<String>();
	    }
	}

    public class EcmResponse {
	    public String status;
	    public String reason;
	    public List<String> message;
	    public String deal_key;
	    public List<EcmLink> links;

	    public EcmResponse(){
	    	links = new List<EcmLink>();
	    	message = new List<String>();
	    }
	}

	public class EcmLink {
    	public String title;
    	public String link;
    }
}