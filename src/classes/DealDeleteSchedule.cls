global with sharing class DealDeleteSchedule implements Schedulable  {
	global void execute(SchedulableContext sc){
		DeleteDeals();
	}
	
	public static void DeleteDeals(){
		DateTime dt = System.Now().addHours(-1); 
		
		List<Opportunity> opps = [SELECT Name, Id FROM Opportunity WHERE (API_Error__c = true OR Is_Incomplete__c = true) AND LastModifiedDate < :dt];
		
		delete opps;
	}
}