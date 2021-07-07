public class MandateAndRelatedAssgnmentHelper {
    @auraEnabled
    public static List<Application__c> getMandatesRelatedAssignment(string mandateId){
        system.debug('mandateId'+mandateId);
        List<Application__c> applicationList = [SELECT Id,Contact_Email__c,First_Name__c,Last_Name__c,Email__c,Contact_ID__c,Phone__c,Status_Summary_Line__c,CV__c,Language__c,mandate_company_name__c,Has_CV__c,Contact__r.hasCV__c FROM Application__c WHERE Mandate__c =:mandateId AND Contact_Full_Name__c != null];
        System.debug('applicationList'+applicationList);
        return applicationList;
    }
    @auraEnabled
    public static String getAttahment(String conId){
        String attachmentId = [SELECT Id FROM Attachment WHERE Name = 'CV.pdf' AND ParentId =: conId].Id;
        return attachmentId;
    }
}