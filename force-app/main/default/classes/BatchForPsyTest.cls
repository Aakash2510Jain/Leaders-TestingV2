public class BatchForPsyTest implements Database.Batchable<sObject>, Database.Stateful {
    
    public Integer recordsProcessed = 0;
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
            'select id from contact where Has_Psy__c = false And Record_Updated__c = false ' );
    }
    public void execute(Database.BatchableContext bc, List<Contact> scope){
        // process each batch of records
        List<Contact> contacts = new List<Contact>();
        for (Contact con : scope) {
            con.Record_Updated__c = true;
            contacts.add(con);
        }
        update contacts;
        
        List<Contact> ContactToBeUpdatedwithPSy = new List<Contact>();
        List<Attachment> attList = [SELECT Id, ParentId FROM Attachment WHERE ParentId IN :scope AND Name LIKE '%PSy%' ORDER BY LastModifiedDate DESC];
        set<ID> ConWithPsy= new set<ID>();
        
        for(Attachment att: attList){
            ConWithPsy.add(att.ParentId) ;
        }
        List<Contact> ContactToBeUpdated = [Select id,Has_Psy__c,name from Contact where id in: ConWithPsy];
        
        for(Contact con : ContactToBeUpdated){
            ContactToBeUpdatedwithPSy.add(new Contact(id=con.Id,Has_Psy__c = true));
        }
        update ContactToBeUpdatedwithPSy;
        
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