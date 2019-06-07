public with sharing class ECMConnector {
	private Opportunity deal; 
	public List<String> errors {get; set;}
	
	public ECMConnector(Opportunity deal){
		this.deal = deal;
		errors = new List<String>();
	}
	
	//Get auth token
    public String getToken() {
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
	
	public String booleanFormatter(Boolean value){
		return (value ? 'Y' : 'N');
	}
	
	public Integer binaryFormatter(String value, String text){
		return (value == text ? 1 : 0);
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
	
	public HttpResponse handleRedirect(HttpRequest req, HttpResponse res) {
      	req.setEndpoint(res.getHeader('Location'));
      	
      	System.debug('request 2 -- '+req.getBody()); 
		System.debug('request 2 -- '+req.toString()); 
      
		Http http = new Http();
		HttpResponse response = http.send(req);
		
		return response; 
	}
	
	public Boolean sendRequest(String token){
		Boolean returnStatus = false;
		
		try{ 
			HttpRequest request = new HttpRequest();
			request.setMethod('PUT');
			request.setHeader('Authorization', 'Bearer ' + token);
			request.setEndpoint(Global_Settings__c.getInstance().API_URL_1__c+'/eoidocument');
	
			request.setTimeout(100000);
			request.setBody(generateDocRequestJSON());
			request.setHeader('Content-Type', 'application/json');  
			
			Http http = new Http();
			HttpResponse response = http.send(request);
			
			if (hasRedirect(response)) {
				response = handleRedirect(request,response);
			}

			ApiResonse apiResponse = (ApiResonse) System.JSON.deserialize(String.valueOf(response.getBody()), ApiResonse.class);
	
			if(!Boolean.valueOf(apiResponse.status)){
				if(apiResponse.message !=null){
					for(String error : apiResponse.message){
						errors.add(error);
					}
				}else{
					errors.add(apiResponse.reason);
				}
			}
			
			ErrorLogHandler.log('ECM.Connector.Request',String.valueOf(request.getBody().left(131000)), apiResponse.deal_key);
			ErrorLogHandler.log('ECM.Connector.Response',String.valueOf(response.getBody().left(131000)), apiResponse.deal_key);
			System.debug('ECMCONNECTOR REQUEST -'+String.valueOf(request.getBody()));
			System.debug('ECMCONNECTOR RESPONSE -'+String.valueOf(response.getBody()));
			
			returnStatus = Boolean.valueOf(apiResponse.status);
		}catch(exception ex){
            ErrorLogHandler.log('ECM.Connector.Exception' ,ex);
        }
		
		return returnStatus;
	}
	
    public String generateDocRequestJSON(){
    	Map<String, Object> tempRecord = new Map<String, Object>();
    	Map<String, Object> tempTDPData = new Map<String, Object>();
    	Map<String, Object> tempCurrentData = new Map<String, Object>();
    	Map<String, Object> tempCABLegalOwnership = new Map<String, Object>();
    	
    	//- ROOT
    	tempRecord.put('TransactionName', 'EOI_PREPARE_REQUEST');
    	tempRecord.put('ProcessUID', this.deal.Deal_Key__c);
    	tempRecord.put('ECMFileRef', null);
    	tempRecord.put('ContractNumber', this.deal.Contract_Number__c);
    	tempRecord.put('Requestor', UserInfo.getName());
    	tempRecord.put('RequestorEmail', UserInfo.getUserEmail());
    	
    	//--- TDPData
    	//tempTDPData.put('PropertyCountry',this.deal.Unit__r.Building__r.Country__c);
    	//tempTDPData.put('PropertyState',this.deal.Unit__r.Building__r.State__c);
    	//tempTDPData.put('Centre',this.deal.Unit__r.Building__r.Centre__r.Name);
    	//tempTDPData.put('CentreID',this.deal.Unit__r.Building__r.Centre__r.Centre_Code__c);
    	//tempTDPData.put('Building',this.deal.Unit__r.Building__r.Name);
    	tempTDPData.put('BuildingID',this.deal.Unit__r.Building__r.Building_Code__c);
    	tempTDPData.put('Unit',this.deal.Unit__r.Name);
    	tempTDPData.put('UnitType',this.deal.Unit__r.Unit_Code__c);
		tempTDPData.put('Floor',this.deal.Unit__r.Floor_Level__c);
		tempTDPData.put('UnitTypeDescription',this.deal.Unit__r.Unit_Code__c);
    	tempTDPData.put('Development',booleanFormatter(this.deal.Development_Unit__c)); // Y | N
    	tempTDPData.put('Reconfiguration',booleanFormatter(this.deal.Reconfig__c)); // Y | N
    	//tempTDPData.put('LandlordUID',this.deal.Selected_Landlord__r.Lessor_Text_Number__c);
    	tempRecord.put('TDPData', tempTDPData);

		//---- CurrentData
    	tempCurrentData.put('CABAddressNo',this.deal.Account.Tenant_CABID__c);
    	/*
    	//------ CABLegalOwnership
    	tempCABLegalOwnership.put('Code',null);
    	tempCABLegalOwnership.put('Description',null);
    	tempTDPData.put('CABLegalOwnership',tempCABLegalOwnership);
    	*/
    	tempCurrentData.put('RetailAct',this.deal.Retail_Act_Applies__c);
    	tempCurrentData.put('DealType',this.deal.JDE_Deal_Type__c);
    	tempCurrentData.put('DealTypeDescription',this.deal.Deal_Type__c);
    	tempCurrentData.put('LandlordWorksType',this.deal.ECM_Works_Type__c);
    	tempCurrentData.put('LandlordWorksDescription',this.deal.Works_Type__c);
    	tempCurrentData.put('NationalAgreedLease',this.deal.Agreed_National_Lease_Exists__c);
    	tempCurrentData.put('RenewalLease',binaryFormatter(this.deal.Deal_Type__c,'RN')); // 0 | 1
    	tempCurrentData.put('Refit',booleanFormatter(this.deal.Refit__c)); // Y | N
    	tempRecord.put('CurrentData', tempCurrentData);
    	
    	System.debug(JSON.serialize(tempRecord));
    	return JSON.serialize(tempRecord);
    }
    
    public class ApiResonse{
		String status;
		String reason;
		List<String> message;
		String deal_key;
		
		public ApiResonse(){
			message = new List<String>();
		}
	}
}