public class BatchForGettingJobDesciptionId implements Database.Batchable<sObject>, Database.Stateful {
    
    public Integer recordsProcessed = 0;
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
            'SELECT Id FROM Mandate__c WHERE Has_Job_Description__c = true' );
    }
    public void execute(Database.BatchableContext bc, List<Mandate__c> scope){
        List<Mandate__c> manListToBeUpdated = new List<Mandate__c>();
        map<Id,String> jobdesc = new map<Id,String>();
        for (Mandate__C man : scope)
        {
            Attachment[] att = [Select Id from Attachment where ParentId =:man.Id AND Name LIKE '%Job desc%' ORDER BY LastModifiedDate Limit 1];
            if(att.size() > 0){
                jobdesc.put(man.Id,att[0].Id);     
            }
        }
        
        for(Id mandateID:jobdesc.keyset() ){
            manListToBeUpdated.add(new Mandate__c(Id = mandateID,Job_description_Id__c  = jobdesc.get(mandateID)));
        }
 
        update manListToBeUpdated;
    }
    public void finish(Database.BatchableContext bc){
        System.debug(recordsProcessed + ' records processed!');
        AsyncApexJob job = [SELECT Id, Status, NumberOfErrors,
                            JobItemsProcessed,
                            TotalJobItems, CreatedBy.Email
                            FROM AsyncApexJob
                            WHERE Id = :bc.getJobId()];
    }
}