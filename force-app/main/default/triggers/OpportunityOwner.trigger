trigger OpportunityOwner on Opportunity (before insert, before update) {
	
	for(Opportunity opp : trigger.New){
		
		if(opp.Owner__c != null){
			
			if (trigger.isInsert || (trigger.isUpdate && trigger.oldMap.get(opp.Id).Owner__c != opp.Owner__c)){
				opp.OwnerId = opp.Owner__c;
			}
			
		}
		
	}

}