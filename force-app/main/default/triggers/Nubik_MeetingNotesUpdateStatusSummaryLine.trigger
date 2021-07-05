trigger Nubik_MeetingNotesUpdateStatusSummaryLine on Meeting_Note__c (after insert, after update) {
    
    static final String PROCESS_NAME = 'Nubik_MeetingNotesUpdateStatusSummaryLine';
    Nubik_Trigger_Helper nubikHelper = Nubik_Trigger_Helper.getInstance();
    
    if(Trigger.isUpdate && Trigger.isAfter){
        MeetingNotsHelper.updatesslFrenchValues(Trigger.new);
    }
    if(Trigger.isInsert && Trigger.isAfter){
        MeetingNotsHelper.updatesslFrenchValues(Trigger.new);
    }
    system.debug('Nubik_MeetingNotesUpdateStatusSummaryLine start');
    
    Map<Id,Application__c> Candidate2Update = new Map<Id,Application__c>();
    Map<Id,Contact> Contacts2Update = new Map<Id,Contact>(); 
    
    for(Meeting_Note__c MN : trigger.new){
        
        if(nubikHelper.DidProcessRan(PROCESS_NAME, MN.Id)){        
            continue;		        
        }
        nubikHelper.AddProcessRun(PROCESS_NAME, MN.Id);
        system.debug('MN-Status = ' + MN.Status_Summary_Line__c);
        system.debug('MN-Description = ' + MN.Description__c);
        if(MN.Candidate_Assigned__c != null && MN.Most_Recent__c){
            if(!Candidate2Update.containsKey(MN.Candidate_Assigned__c)){
                Application__c Candidate = new Application__c();
                Candidate.Id = MN.Candidate_Assigned__c;
                Candidate.Status_Summary_Line__c = MN.Status_Summary_Line__c;
                if(Trigger.isUpdate) {
                    if(MN.Status_Summary_Line__c!=Trigger.oldMap.get(MN.Id).Status_Summary_Line__c)
                        Candidate2Update.put(MN.Candidate_Assigned__c,Candidate);
                } else {
                    Candidate2Update.put(MN.Candidate_Assigned__c,Candidate);
                }
            }
        }
        if(MN.Contact__c != null && MN.Most_Recent__c){
            if(!Contacts2Update.containsKey(MN.Contact__c)){
                Contact aContact = new Contact();
                aContact.Id = MN.Contact__c;
                aContact.Status_Summary_Line__c = MN.Status_Summary_Line__c;
                Contacts2Update.put(MN.Contact__c,aContact);
            }
        }
    }
    if(!Candidate2Update.isEmpty()){
        system.debug('update candidates');
        //update Candidate2Update.values();
    }
    if(!Contacts2Update.isEmpty()){
        system.debug('update contacts');
        update Contacts2Update.values();
    }
    system.debug('Nubik_MeetingNotesUpdateStatusSummaryLine end');
    
}