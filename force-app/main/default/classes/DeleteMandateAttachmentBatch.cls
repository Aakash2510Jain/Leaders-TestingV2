/*
	Author: DeaGle~
*/
public class DeleteMandateAttachmentBatch implements Database.Batchable<sObject>,Schedulable{
	public Database.QueryLocator start(Database.BatchableContext bc) {
        // collect the batches of records or objects to be passed to execute
        return Database.getQueryLocator('SELECT Id,ParentId FROM attachment WHERE Name Like \'Overnight_Leaders Report%\' AND Parent.Type = \'Mandate__c\'');
    }
    
    public void execute(SchedulableContext sc){
    	Database.executeBatch(new DeleteMandateAttachmentBatch());    
    }
    
    public void execute(Database.BatchableContext bc, List<Attachment> attachments){
        // process each batch of records
        List<Attachment> attachmentsToDelete = new List<Attachment>();
        Map<String,Integer> attachmentCountPerMandate = new Map<String,Integer>();
        Integer currentCount;
        for(attachment att : attachments){
            currentCount = 0;
            if(attachmentCountPerMandate.containsKey(att.ParentId))
                attachmentCountPerMandate.put(att.ParentId,currentCount = attachmentCountPerMandate.get(att.ParentId)+1);
            else
                attachmentCountPerMandate.put(att.ParentId,currentCount = 1);
            if(currentCount > 2)
                attachmentsToDelete.add(att);
        }
        //System.debug('--->attachmentsToDelete'+attachmentsToDelete);
        if(!attachmentsToDelete.isEmpty())
            delete attachmentsToDelete;
    }    
    public void finish(Database.BatchableContext bc){
        // execute any post-processing operations
    }  
}