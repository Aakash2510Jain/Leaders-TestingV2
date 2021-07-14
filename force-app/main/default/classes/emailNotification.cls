public class emailNotification {
    public static void sendEmail(string applicantId, map<String, string> mapOfApplicatioTestAssociationById) {
        try{
            system.debug('applicantId'+applicantId);
            system.debug('mapOfApplicatioTestAssociationById'+mapOfApplicatioTestAssociationById);
            Application__c app = [SELECT Contact_Email__c,Contact_Full_Name__c FROM Application__c WHERE Id =: applicantId];
            system.debug('app:::::'+app);
            EmailTemplate et=[Select id, Name, DeveloperName, Subject, Body, HtmlValue from EmailTemplate where name = 'Question Module'];
            List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
            for (string studentTestAssociation : mapOfApplicatioTestAssociationById.keySet()) {
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                List<String> recipients = new List<String>();
                recipients.add(app.Contact_Email__c);
                system.debug('recipients------'+recipients);
                mail.setToAddresses(recipients);
                mail.setReplyTo('test@email.com');
                mail.setSenderDisplayName('Test Organization');
                String subject = et.Subject;
                system.debug('subject'+subject);
                String htmlBody = et.HtmlValue;
                system.debug('htmlBody'+htmlBody);
                system.debug('Application'+app);
                system.debug('app.Contact_Full_Name__c'+app.Contact_Full_Name__c);
                htmlBody = htmlBody.replace('{!Contact.FullName}', app.Contact_Full_Name__c);
                htmlBody = htmlBody.replace('{!TestMasterName}', mapOfApplicatioTestAssociationById.get(studentTestAssociation));
                htmlBody = htmlBody.replace('{!StudentTestAssocition.Id}', studentTestAssociation);
               	system.debug(' mapOfApplicatioTestAssociationById.get(studentTestAssociation)::'+ mapOfApplicatioTestAssociationById.get(studentTestAssociation));
                mail.setSubject(subject);
                mail.setHtmlBody(htmlBody);
                mails.add(mail);
            }
            Messaging.sendEmail(mails);
        }catch(Exception e){
            System.debug('Error Line======>'+e.getLineNumber()+'Error Message==>'+e.getMessage());
        }
        
    }
}