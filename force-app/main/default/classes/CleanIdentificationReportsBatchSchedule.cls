global class CleanIdentificationReportsBatchSchedule implements Database.Batchable<sObject>, Schedulable  {

    global set<Id> assignmentsId = new  set<Id>();

    global CleanIdentificationReportsBatchSchedule(){
        for(Mandate__c assi : [Select Id from Mandate__c]){
            assignmentsId.add(assi.Id);
        }
    }

    global static void Schedule(){
        CleanIdentificationReportsBatchSchedule p = new CleanIdentificationReportsBatchSchedule();
        String sch = '0 0 01 * * ?'; 
        system.schedule('Clean Identifaction Reports All Mandates', sch, p); 
    }
    
    global void execute(SchedulableContext SC){
       CleanIdentificationReportsBatchSchedule n = new CleanIdentificationReportsBatchSchedule();
       Database.executeBatch(n,1);
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){        
        return Database.getQueryLocator([Select Id from Mandate__c]);
        
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){     
    }
    
    global void finish(Database.BatchableContext BC){
        system.debug('Finish'+BC);
        system.debug('Finish'+assignmentsId);
       /* if(assignmentsId != null){
	        for(Id assignId : assignmentsId){       
	            system.debug('Execute for : '+assignId);     
	            Database.executeBatch(new CleanIdentificationReportsBatch(assignId));
	        }    
        }*/
        
        if(assignmentsId!=null)
        {
            system.debug('Execute for : '+assignmentsId);  
            Database.executeBatch(new CleanIdentificationReportsBatch(assignmentsId));
        }
    }
    
}