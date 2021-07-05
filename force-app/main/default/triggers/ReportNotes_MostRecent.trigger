/* **************************************************************************
* Trigger: ReportNotes_MostRecent
* Created by Joel Ojeda, 12/15/2014
*
* Purpose:
* - This trigger will mark the most recent created note for a Candidate in an
*	Assignment. This field will be used to filter the record to generate the
*	conga report for Human Capital Study.
*
* Unit Test: {name of the Class with UnitTest(s) that cover this trigge} 
* 
* Modifications:
* - {DevName}, {MM/DD/YYYY} – {Description of changes made post deployment to client}
*
************************************************************************** */

trigger ReportNotes_MostRecent on Meeting_Note__c (after delete, 
													after undelete, 
													after insert,
													after update) {
	
	if(CongaHelperTool.STOP_MOST_RECENT_NOTE)
		return;
	
	Set<String> candidates = new Set<String>();
	Set<String> assignments = new Set<String>();
	Set<String> toValidate = new Set<String>();
	
	Map<Id,Application__c> Candidate2Update = new Map<Id,Application__c>();
    Map<Id,Contact> Contacts2Update = new Map<Id,Contact>(); 
    
    Set<String> candidatesNoteDeleted = new Set<String>();
    Map<Id,Id> contactMap = new Map<Id,Id>(); 
	
	if(Trigger.isInsert || Trigger.isUpdate || Trigger.isUnDelete){
		for(Meeting_Note__c note : trigger.new){
			candidates.add(note.Candidate_Assigned__c);
			assignments.add(note.Madate_Id__c);
			toValidate.add(note.Id);
			
			if(Trigger.isInsert || Trigger.isUpdate){
				if(note.Candidate_Assigned__c != null){
		            if(!Candidate2Update.containsKey(note.Candidate_Assigned__c)){
		                Application__c Candidate = new Application__c();
		                Candidate.Id = note.Candidate_Assigned__c;
		                Candidate.Status_Summary_Line__c = note.Status_Summary_Line__c;
                        
                        if(Trigger.isUpdate) {
                            if(note.Status_Summary_Line__c!=Trigger.oldMap.get(note.Id).Status_Summary_Line__c)
                                 Candidate2Update.put(note.Candidate_Assigned__c,Candidate);
                        } else {
                            Candidate2Update.put(note.Candidate_Assigned__c,Candidate);
                        }
                        
                        
		               
		            }
		        }
		        if(note.Contact__c != null){
		            if(!Contacts2Update.containsKey(note.Contact__c)){
		                Contact aContact = new Contact();
		                aContact.Id = note.Contact__c;
		                aContact.Status_Summary_Line__c = note.Status_Summary_Line__c;
                        
                        
		                Contacts2Update.put(note.Contact__c,aContact);
		            }
		        } 
			}
			
		}
	}
	
	if(Trigger.isDelete){
		for(Meeting_Note__c note : trigger.old){
			candidatesNoteDeleted.add(note.Candidate_Assigned__c);
			contactMap.put(note.Candidate_Assigned__c, note.Contact__c);
			if(note.Most_Recent__c){
				candidates.add(note.Candidate_Assigned__c);
				assignments.add(note.Madate_Id__c);
				toValidate.add(note.Id);
			}
		}
	}
	
	System.debug('[ReportNotes_MostRecent] candidates: '+candidates);
	System.debug('[ReportNotes_MostRecent] assignments: '+assignments);
	System.debug('[ReportNotes_MostRecent] toValidate: '+toValidate);
	
	if(!candidates.isEmpty() && !assignments.isEmpty()){
		//get notes sorted by creation date to filter by candidate
		List<Meeting_Note__c> savedNotes = [Select Id, Most_Recent__c,
											 Candidate_Assigned__c,
											 Madate_Id__c
											from Meeting_Note__c 
											where 
											Candidate_Assigned__c IN : candidates 
											and Madate_Id__c IN :assignments 
											and Private__c=false
											order by CreatedDate DESC];
											
		System.debug('[ReportNotes_MostRecent] savedNotes: '+savedNotes.size());
				
		Map<String,Meeting_Note__c>	toActive = new Map<String,Meeting_Note__c>();
		Map<String,Meeting_Note__c>	toDeactive = new Map<String,Meeting_Note__c>();	
		Set<String> added = new Set<String>();
								
		for(Meeting_Note__c note : savedNotes){
			if(toActive.get(note.Madate_Id__c+'-'+note.Candidate_Assigned__c)==null){
				note.Most_Recent__c = true;
				toActive.put(note.Madate_Id__c+'-'+note.Candidate_Assigned__c,note);
				added.add(note.Id);
			}
			if(toDeactive.get(note.Madate_Id__c+'-'+note.Candidate_Assigned__c)==null &&
				!added.contains(note.id)){
				if(note.Most_Recent__c){
					note.Most_Recent__c = false;
					toDeactive.put(note.Madate_Id__c+'-'+note.Candidate_Assigned__c,note);
					added.add(note.Id);
				}
			}
		}
		
		System.debug('[ReportNotes_MostRecent] toActive: '+toActive);
		System.debug('[ReportNotes_MostRecent] toDeactive: '+toDeactive);
		
		if(!toActive.isEmpty()){
			CongaHelperTool.STOP_MOST_RECENT_NOTE = true;
			update toActive.values();
			CongaHelperTool.STOP_MOST_RECENT_NOTE = false;
		}
		
		if(!toDeactive.isEmpty()){
			CongaHelperTool.STOP_MOST_RECENT_NOTE = true;
			update toDeactive.values();
			CongaHelperTool.STOP_MOST_RECENT_NOTE = false;
		}
		
		
		
	}
	
	if(!candidatesNoteDeleted.isEmpty()){
		
		set<string> updated = new set<string>();
		
		for(Meeting_Note__c note : [Select Id, Most_Recent__c,
								 	   Candidate_Assigned__c,
								       Madate_Id__c,
								       Contact__c,
								       Status_Summary_Line__c
								  from Meeting_Note__c 
								 where Candidate_Assigned__c IN : candidatesNoteDeleted 
							  order by CreatedDate DESC]){
		
				if(!Candidate2Update.containsKey(note.Candidate_Assigned__c)){
	                Application__c candidate = new Application__c();
	                candidate.Id = note.Candidate_Assigned__c;
	                candidate.Status_Summary_Line__c = note.Status_Summary_Line__c;
	                Candidate2Update.put(note.Candidate_Assigned__c,candidate);
		        }	
		        
		        if(note.Contact__c != null){
		            if(!Contacts2Update.containsKey(note.Contact__c)){
		                Contact aContact = new Contact();
		                aContact.Id = note.Contact__c;
		                aContact.Status_Summary_Line__c = note.Status_Summary_Line__c;
		                Contacts2Update.put(note.Contact__c,aContact);
		            }
		        }

				updated.add(note.Candidate_Assigned__c);			  	
							  	
		}
		
		for(String c : candidatesNoteDeleted){
			
			if(!updated.contains(c)){
				
				if(!Candidate2Update.containsKey(c)){
	                Application__c candidate = new Application__c();
	                candidate.Id = c;
	                candidate.Status_Summary_Line__c = null;
	                Candidate2Update.put(c,candidate);
	                
	                Contact aContact = new Contact();
	                aContact.Id = contactMap.get(c);
	                aContact.Status_Summary_Line__c = null;
	                Contacts2Update.put(aContact.Id,aContact);
	                
		        }	
				
			}
		}
		
	}
	
	
	if(!Candidate2Update.isEmpty()){
			CongaHelperTool.STOP_MOST_RECENT_NOTE = true;
			update Candidate2Update.values();
			CongaHelperTool.STOP_MOST_RECENT_NOTE = false;
		}
		
		if(!Contacts2Update.isEmpty()){
	        update Contacts2Update.values();
	    }
	
}