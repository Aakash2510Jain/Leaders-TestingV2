public class UpdateCandidateStatus implements Database.Batchable<sObject>{


	public void execute(SchedulableContext sc)  {
        Database.executeBatch(new UpdateCandidateStatus());
    }
    
    public static void execute() {
        Database.executeBatch(new UpdateCandidateStatus());
    }
    
	
	public Database.QueryLocator start(Database.BatchableContext BC){
		
		String query =	 'select Id, Status_Summary_Line__c, Contact__c '+ 
		                 'from Application__c';

		System.debug(query);
		
		return Database.getQueryLocator(query);
	}
	
	public void execute(Database.BatchableContext BC, List<Application__c> scope){
		
		set<Id> noteIds = new set<Id>();
		for(Application__c candidate : scope){			
			noteIds.add(candidate.Id);			
		}
		
		Map<Id, Meeting_Note__c> notesMap = new Map<Id, Meeting_Note__c>();
	
		for(Meeting_Note__c notes : [Select Id, Candidate_Assigned__c,
											Status_Summary_Line__c,
											Contact__c
											from Meeting_Note__c 
											where Candidate_Assigned__c in :noteIds 
											order by CreatedDate DESC]){
			
			if(!notesMap.containsKey(notes.Candidate_Assigned__c)){
				notesMap.put(notes.Candidate_Assigned__c, notes);
			}
			
		}
				
		List<Application__c> toUpdate = new List<Application__c>();
		Map<Id,Contact> Contacts2Update = new Map<Id,Contact>(); 
		
		for(Application__c candidate : scope){
			Contact aContact = new Contact();
			if(notesMap.containsKey(candidate.Id)){
				candidate.Status_Summary_Line__c = notesMap.get(candidate.Id).Status_Summary_Line__c;	
				aContact.Id = notesMap.get(candidate.Id).Contact__c;	
				aContact.Status_Summary_Line__c = notesMap.get(candidate.Id).Status_Summary_Line__c;				
			}else{				
				candidate.Status_Summary_Line__c = null;
				aContact.Id = candidate.Contact__c;
				aContact.Status_Summary_Line__c = null;				
			}
			
			toUpdate.add(candidate);
			
			if(!Contacts2Update.containsKey(aContact.Id)){
				Contacts2Update.put(aContact.Id, aContact);
			}
		}
		
		if(toUpdate.size()>0){
			update toUpdate;
		}
		
		if(!Contacts2Update.isEmpty()){
			update Contacts2Update.values();
		}
		
	}
	
	public void finish(Database.BatchableContext bc){
		
	}
	

}