/*
    Date        : 19-08-2016
    Project     : Lease Management System
    Description : Defining opportunity trigger
*/

trigger OpportunitiesTrigger on Opportunity (after insert, after update, before update, before insert) {
	
	// Update LE
	if(Trigger.isBefore && (Trigger.isUpdate || Trigger.isInsert)) {
		for(Opportunity opp :Trigger.new)
    	{
    		opp.Leasing_Executive__c = opp.OwnerId;
    	}
	}
	
	//Map Deal Status
	if(Trigger.isBefore && (Trigger.isUpdate || Trigger.isInsert)) {
		
		Set<Id> proceedNowUnitsToUpdate = new Set<Id>();

    	for(Opportunity opp :Trigger.new)
    	{
    		Boolean IsProceeded = false;
    		
    		if(opp.Deal_Cancelled__c != true){
	    		if(opp.Process_Status_Identifier__c == 'LON001' ||
	    		   opp.Process_Status_Identifier__c == 'LON002' ||
	    		   opp.Process_Status_Identifier__c == 'LON003' ||
	    		   opp.Process_Status_Identifier__c == 'LON004' ||
	    		   opp.Process_Status_Identifier__c == 'LONM01' ||
	    		   opp.Process_Status_Identifier__c == 'LONM02' ||
	    		   opp.Process_Status_Identifier__c == 'LON005' ||
	    		   opp.Process_Status_Identifier__c == 'LONM03' 
	    		){
	    			IsProceeded = false;
	    			opp.StageName = 'Lease Offer';
	    		}else if((opp.Process_Status_Identifier__c=='' || opp.Process_Status_Identifier__c == null) && opp.TDP_Milestone__c == 'TDPM01'){
	    			IsProceeded = false;
	    			opp.StageName = 'Lease Offer';
	    		}else if((opp.Process_Status_Identifier__c=='' || opp.Process_Status_Identifier__c == null) && opp.TDP_Milestone__c == 'TDPM02'){
	    			IsProceeded = false;
	    			opp.StageName = 'Lease Offer';
	    		}else if(opp.Process_Status_Identifier__c == 'LOA001' ||
	    				 opp.Process_Status_Identifier__c == 'LOA002' ||
	    				 opp.Process_Status_Identifier__c == 'LOA003' ||
	    				 opp.Process_Status_Identifier__c == 'LOA004' ||
	    				 opp.Process_Status_Identifier__c == 'LOA005' ||
	    				 opp.Process_Status_Identifier__c == 'LOA006' ||
	    				 opp.Process_Status_Identifier__c == 'LOA007' ||
	    				 opp.Process_Status_Identifier__c == 'LOAM01'
	    				 
	    				){	
					IsProceeded = false;
	    			opp.StageName = 'Lease Offer Approval';
	    		}else if((opp.Process_Status_Identifier__c=='' || opp.Process_Status_Identifier__c == null) && opp.TDP_Milestone__c == 'TDPM03'){
	    			IsProceeded = true;
	    			opp.StageName = 'Leased But Not Trading';
	    		}else if(opp.Process_Status_Identifier__c=='LCRM01' ||
	    				 opp.Process_Status_Identifier__c=='LCRM02' ||	
	    				 opp.Process_Status_Identifier__c=='LCRM03' ||
	    				 opp.Process_Status_Identifier__c=='LCRM04' ||	
	    				 opp.Process_Status_Identifier__c=='LCRM05' ||	
	    				 opp.Process_Status_Identifier__c=='LCRM06' ||	
	    				 opp.Process_Status_Identifier__c=='LCRM07' ||	
	    				 opp.Process_Status_Identifier__c=='LCRM08'	
	    				){
	    			IsProceeded = true;	
	    			opp.StageName = 'Leased But Not Trading';
				}else if((opp.Process_Status_Identifier__c=='' || opp.Process_Status_Identifier__c == null) && opp.TDP_Milestone__c == 'TDPM05'){
	    			IsProceeded = true;
	    			opp.StageName = 'Leased But Not Trading';
	    		}else if((opp.Process_Status_Identifier__c=='' || opp.Process_Status_Identifier__c == null) && opp.TDP_Milestone__c == 'TDPM07'){
	    			IsProceeded = true;
	    			opp.StageName = 'Leased But Not Trading';
	    		}else if(opp.Process_Status_Identifier__c=='LCRM09' && 
	    				 opp.Open_for_Trade_Date__c ==null){
	    			IsProceeded = true;		
	    			opp.StageName = 'Leased But Not Trading';
	    		}else if(opp.Process_Status_Identifier__c=='LCRM09' && 
	    				 opp.Open_for_Trade_Date__c !=null){
	    			IsProceeded = true;	
	    			opp.StageName = 'Shop Opened';
	    		}else{
	    			IsProceeded = false;
	    		}
	    		
    			if(opp.Process_Status__c == 'Generate LO'){
    				opp.LON_Generated__c = false;
    				opp.LON_Regenerated__c = false;
    			}
    		}
    		
    		if(!opp.Is_Proceeded__c && IsProceeded){
    			opp.Is_Proceeded__c = true;
    			opp.Proceeded_Date__c = Date.today();
    			
    			proceedNowUnitsToUpdate.add(opp.Unit__c);
    		}

    		//opp.Name = opp.Account + '/' + opp.Unit__c + '/' + opp.Building__c + '/' + Date.today().format().replaceAll('/', '-');
    	}
    	
    	List<Unit__c> unitsToUpdate = [SELECT Name, Id,
    									Forecast_Base_Rent__c,
    									Current_Tenant_Planned_End__c,
    									Estimated_Rent_Start__c,
    									Estimated_Rent_End__c,
    									Fitout_Contribution_Budget__c,
    									Future_Tenant_Landlord_Works_Budget__c,
    									Preferred_Tenant__c,
										Estimated_Instruction_Date__c,
										Current_Tenant_Strategy_on_Expiry__c
    									FROM Unit__c WHERE Id IN :proceedNowUnitsToUpdate 
    												 AND Preferred_Tenant__c != NULL
    												 ];
    												 
    	System.debug('unitsToUpdate -- '+ unitsToUpdate.size() );
    									
    	for(Unit__c units : unitsToUpdate){
    		units.Forecast_Base_Rent__c = 0;
    		units.Current_Tenant_Planned_End__c = null;
    		units.Estimated_Rent_Start__c = null;
    		units.Estimated_Rent_End__c = null;
    		units.Fitout_Contribution_Forecast__c = 0;
    		units.Landlord_Works_Forecast__c = 0;
    		units.Preferred_Tenant__c = null;
			units.Estimated_Instruction_Date__c = null;
			units.Current_Tenant_Strategy_on_Expiry__c = null;

		}
    	
    	update unitsToUpdate; 
	}
	
	// Generate Deal Key
	if(Trigger.isBefore && Trigger.isUpdate) {
		VC_DealsCommon.updateDealKey(Trigger.new);
	}
	
	if(Trigger.isAfter && Trigger.isInsert) {
		
		Set<ID> oppIds = new Set<ID>();
		
		for(Opportunity o : Trigger.new){
			if(String.isEmpty(o.Deal_Key__c)){
				oppIds.add(o.Id);
			}
		}

		if(oppIds.size() > 0){

			List <Opportunity> opps = [SELECT Name, Id, Record_Number__c FROM Opportunity WHERE Deal_Key__c = NULL 
																								AND Record_Number__c != NULL 
																								AND Id IN :oppIds LIMIT 200];
																								
			System.debug('oppsA -- '+ opps.size() );																					
			
			VC_DealsCommon.updateDealKey(opps);
		    	
	    	update opps;
    	
		}
		
	}
	
	if(Trigger.isAfter && Trigger.isUpdate) {
		if(Trigger.newMap.keySet().size()==1){//FIX 
			OpportunitiesTriggerHandler.createContactRoles(Trigger.newMap);
		}
	}

	// Set prefered tenant
	if(Trigger.isAfter && (Trigger.isUpdate || Trigger.isInsert)) {
		
		Set<ID> opIds = Trigger.newMap.keySet();
		Map<Id, Id> opUnitMap = new Map<Id, Id>();
		

		for(Opportunity op:  [SELECT Name, Id, Unit__c, Unit__r.Preferred_Tenant__c, StageName 
									    FROM Opportunity 
										WHERE Id IN :opIds 
										AND Unit__r.Preferred_Tenant__c = NULL 
										AND API_Error__c = false 
										AND Is_Incomplete__c	= false
										AND Is_Proceeded__c = false
										AND StageName != 'Shop Opened'
										AND StageName != 'Deal Not Proceeding'
										ORDER BY CreatedDate LIMIT 200]){
			if(!opUnitMap.containsKey(op.Unit__c)){
				opUnitMap.put(op.Unit__c, op.Id);
			}
		}
		
		List<Unit__c> units = [SELECT Name, Id FROM Unit__c WHERE Id IN :opUnitMap.keySet()];
		
		System.debug('units -- '+ units.size() );	
		
		for(Unit__c unit : units){
			unit.Preferred_Tenant__c = opUnitMap.get(unit.Id);
		}
		
		update units;
		
	}
	
}