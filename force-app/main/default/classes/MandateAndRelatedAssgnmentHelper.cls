public class MandateAndRelatedAssgnmentHelper {
    @auraEnabled
    public static List<Application__c> getMandatesRelatedAssignment(string mandateId){
        system.debug('mandateId'+mandateId);
        List<Application__c> applicationList = [SELECT Contact_Email__c,First_Name__c,Last_Name__c,Email__c,Phone__c,Status_Summary_Line__c,Language__c,mandate_company_name__c FROM Application__c WHERE Mandate__c =:mandateId AND Contact_Full_Name__c != null];
        System.debug('applicationList'+applicationList);
        return applicationList;
    }
}