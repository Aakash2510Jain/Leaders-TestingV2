trigger Nubik_MeetingNotesFillContact on Meeting_Note__c (before insert, before update) {
    
    
    set<Id> CandidateAssignedIds = new set<Id>();
    map<Id,Id> MNoteIdWithCAId = new map<Id,Id>();
    map<Id,Id> CAIdwithContactId = new map<Id,Id>();
     
    for (Meeting_Note__c Mt : trigger.new){
        if(Mt.Candidate_Assigned__c != null){
            MNoteIdWithCAId.put(Mt.Id, Mt.Candidate_Assigned__c);
        }
    }
    
    list<Application__c> ContactsRelatedList = [select Id, Contact__c from Application__c where Id IN : MNoteIdWithCAId.Values()];
    
    for(Application__c anApp : ContactsRelatedList){
        CAIdwithContactId.put(anApp.Id, anApp.Contact__c);
    }
    
    for (Meeting_Note__c Mt : trigger.new){
        if(CAIdwithContactId.get(MNoteIdWithCAId.get(Mt.Id)) != null){
            Mt.Contact__c = CAIdwithContactId.get(MNoteIdWithCAId.get(Mt.Id));
        }
    }
    

}