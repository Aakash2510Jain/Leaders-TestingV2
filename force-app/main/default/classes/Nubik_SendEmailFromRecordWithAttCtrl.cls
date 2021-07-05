public with sharing class Nubik_SendEmailFromRecordWithAttCtrl {
    public list<AttWrapper> attList {get;set;}
    public EmailWrapper theEmail {get;set;}    
    public Id relatedID {get;set;}    
    public Nubik_SendEmailFromRecordWithAttCtrl(){
        attList = new list<AttWrapper>();
        relatedID = ApexPages.currentPage().getParameters().get('rId');
        if(relatedID != null){
            for(Attachment anAtt :[select Id, Name, LastModifiedDate, CreatedBy.FirstName, CreatedBy.LastName from Attachment where ParentId = : relatedID]){
                AttWrapper attToAdd = new AttWrapper(anAtt);
                attList.add(attToAdd);                
            }
        }        
        theEmail = new EmailWrapper();       
        if(relatedID.getSobjectType() == Schema.Contact.SObjectType){
            theEmail.toContact.WhoId = relatedID;
        } 
    }
    
    public class AttWrapper{
        public Boolean selected {get;set;}
        public Attachment att {get;set;} 
        
        public AttWrapper(Attachment a){
            att = a;
            selected = false;
        }
    }
    
    public class EmailWrapper{
        //public User fromUser {get;set;}
        public Task toContact {get;set;}        
        public String aditionalTo {get;set;}
        public String cc {get;set;}
        public String bcc {get;set;}
        public String subject {get;set;}
        public String body {get;set;}
        
        public EmailWrapper(){
            toContact = new Task();
        }
    }
    
    public PageReference send(){
        PageReference pREF = null;
        // Define the email
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage(); 

        // Create the email attachments
        list<Messaging.EmailFileAttachment> allAtts = new list<Messaging.EmailFileAttachment>();
        set<Id> attIds = new set<Id>();
        for(AttWrapper anAttW : attList){
            if(anAttW.selected){
                attIds.add(anAttW.att.Id);                
            }
        }
        for(Attachment anTT : [Select Id, Name, Body from Attachment where ID IN: attIds]){
            Messaging.EmailFileAttachment efaToAdd = new Messaging.EmailFileAttachment();
                efaToAdd.setFileName(anTT.Name);
                efaToAdd.setBody(anTT.body);
                allAtts.add(efaToAdd);
        }

        /*String addresses;
        if (account.Contacts[0].Email != null) {
            addresses = account.Contacts[0].Email;
            // Loop through the whole list of contacts and their emails
            for (Integer i = 1; i < account.Contacts.size(); i++) {
                if (account.Contacts[i].Email != null) {
                    addresses += ':' + account.Contacts[i].Email;
                }
            }
        }*/

        String[] toAddresses = theEmail.aditionalTo.split(';');
        String[] toAddressesCC = theEmail.cc.split(';');
        String[] toAddressesBCC = theEmail.bcc.split(';');

        // Sets the paramaters of the email
        system.debug(theEmail.toContact.WhoId);
        email.setTargetObjectId(theEmail.toContact.WhoId);
        email.targetObjectId = theEmail.toContact.WhoId;         
        email.setSubject( theEmail.subject );
        if(toAddresses.size()>0 && !String.isBlank(toAddresses[0])){
            email.setToAddresses( toAddresses );
        }
        if(toAddressesCC.size()>0 && !String.isBlank(toAddressesCC[0])){
            email.setCcAddresses(toAddressesCC);
        }
        if(toAddressesBCC.size()>0 && !String.isBlank(toAddressesBCC[0])){
            email.setBccAddresses(toAddressesBCC);
        }        
        email.setHtmlBody( theEmail.body );
        
        //Sets the attachments
        if(allAtts.size()>0){
            email.setFileAttachments(allAtts);
        }

        // Sends the email
       try{ Messaging.SendEmailResult [] r = 
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});   
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Email Sent'));
            
            pREF = new PageReference('/'+relatedID);
       }catch(exception e){
           ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
       }
        
        return pREF;           
                
    }
    
    
   /* public PageReference cancelButton(){
        system.debug('Entered');
        String ret = ApexPages.currentPage().getParameters().get('retURL');
        system.debug(ret);
        PageReference pRef = new PageReference(ret);
        system.debug(pRef);
        //pRef.setRedirect(true);
        return pRef;        
    }*/
}