public class AttachmentTriggerHelper 
{   
    public static Map<Id, String> attachMap = new Map<Id, String>();
    
    public static Set<Id> parentIds = new Set<Id>();
    
    public static List<Attachment> attachments;
    
    public static void updateHasCVStatusAfterInsertAndUpdate(List<Attachment> attchList)
    {
        List<Id> parentId = new List<Id>();
        List<Contact> contacts = new List<Contact>();
        Map<String, Integer> nbCVByContactId = new Map<String, Integer>();
        
        for(Attachment att: attchList)
        {
            parentId.add(att.ParentId);
        }
        
        for(AggregateResult result: [SELECT ParentId, COUNT(Id) FROM Attachment WHERE ParentId IN :parentId AND Name LIKE 'CV%' GROUP BY ParentId]) 
        {
            if(Integer.valueOf(result.get('expr0'))>0) 
            {
                nbCVByContactId.put(String.valueOf(result.get('ParentId')),Integer.valueOf(result.get('expr0')));
            }
        }
        
        contacts = [SELECT Id FROM Contact WHERE Id IN:parentId];
        
        if(contacts.size()>0) 
        {
            for(Contact contact:contacts) 
            {
                if(nbCVByContactId.containsKey(contact.Id))
                {
                    if(nbCVByContactId.get(contact.Id)>0)
                        contact.hasCV__c = true;
                    else 
                        contact.hasCV__c = false;
                } else {
                    contact.hasCV__c = false;
                }
            }
            
            update contacts;
        }
    }
    public static void beforeDelete(List<Attachment> attchList)
    {
        
        List<Account> doNotDeleteAcc = [SELECT Id FROM Account WHERE Name = :LeadersBoardConstants.DO_NOT_DELETE_ACCOUNT_NAME LIMIT 1];
        if(!doNotDeleteAcc.isEmpty()){
            List<Attachment> doNotDeleteAtt = new List<Attachment>();
            Id accId = doNotDeleteAcc.get(0).Id;
            for(Attachment aRec : attchList){
                if(accId == aRec.ParentId){
                    aRec.addError('Deletion of this Attachment is not permitted!');
                }
            }
            
        }
    }
    public static void sendEmailAfterLeadersReportGenerationAfterInsert(List<Attachment> attachments)
    {
        
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        
        { for(Attachment att : attachments)
        {  
            if(att.Name.contains(GenerateIdentificationReportBatch.IDENTIFICATION_NAME))
            {       string userId = '';
             if(att.Name.lastIndexOf('_') > 0 && att.Name.lastIndexOf('.pdf') > 0)
             {
                 userId = att.Name.substring(att.Name.lastIndexOf('_')+1,att.Name.lastIndexOf('.pdf'));
                 system.debug('[AttachmentTrigger] userId '+userId);
                 if (NubikHelper.validateId(userId))
                 {                       
                     Messaging.SingleEmailMessage singleMail = new Messaging.SingleEmailMessage();
                     singleMail.setSaveAsActivity(false);
                     singleMail.setOrgWideEmailAddressId('0D21k000000Cagq');
                     singleMail.setTargetObjectId(userId);
                     //singleMail.setToAddresses(new List<String>{'richard@leadersinternational.com'});
                     singleMail.setSubject(Label.Leaders_notification_email_subject);
                     singleMail.setHtmlBody(Label.Leaders_notification_email.replace('{!url}',URL.getSalesforceBaseUrl().toExternalForm()+'/'+att.Id));
                     emails.add(singleMail);
                     
                     //(C102294) assign the user that generated the report as the owner of the report
                     attachMap.put(att.Id, userId);
                 }
             }
            }
            
        }
        }
    }
    public static void updatePSYAndHasCV(List<Attachment> attachments){
        List<Id> parentId = new List<Id>();
        List<Contact> contacts = new List<Contact>();
        List<Contact> contactswithPSY = new List<Contact>();
        List<Contact> contactswithCV = new List<Contact>();
        
        Map<String, Integer> nbCVByContactId = new Map<String, Integer>();
        Map<String, Integer> nbPSYByContactId = new Map<String, Integer>();
        
        for(Attachment att: attachments) {
            parentId.add(att.ParentId);
        }
        
        for(AggregateResult result: [SELECT ParentId, COUNT(Id) FROM Attachment WHERE ParentId IN :parentId AND Name LIKE 'CV%' GROUP BY ParentId]) {
            if(Integer.valueOf(result.get('expr0'))>0) {
                nbCVByContactId.put(String.valueOf(result.get('ParentId')),Integer.valueOf(result.get('expr0')));
            }
        }
        
        for(AggregateResult result: [SELECT ParentId, COUNT(Id) FROM Attachment WHERE ParentId IN :parentId AND Name LIKE 'PSY%' GROUP BY ParentId]) {
            if(Integer.valueOf(result.get('expr0'))>0) {
                nbPSYByContactId.put(String.valueOf(result.get('ParentId')),Integer.valueOf(result.get('expr0')));
            }
        }
        contactswithCV = [SELECT Id FROM Contact WHERE Id IN:parentId];
        
        contactswithPSY = [SELECT Id FROM Contact WHERE Id IN:parentId];
        
        
        if(contactswithCV.size()>0) {
            for(Contact contact:contactswithCV) {
                if(nbCVByContactId.containsKey(contact.Id) ) {
                    if(nbCVByContactId.get(contact.Id)>0)
                        contact.hasCV__c = true;
                    else 
                        contact.hasCV__c = false;
                } else {
                    contact.hasCV__c = false;
                }
            }
            update contactswithCV;
        }
        
        if(contactswithPSY.size()>0) {
            for(Contact contact:contactswithPSY) {
                if(nbPSYByContactId.containsKey(contact.Id) ) {
                    if(nbPSYByContactId.get(contact.Id)>0)
                        contact.Has_Psy__c  = true;
                    else 
                        contact.Has_Psy__c  = false;
                } else {
                    contact.Has_Psy__c  = false;
                }
            }
            update contactswithPSY;
        }
    }
}