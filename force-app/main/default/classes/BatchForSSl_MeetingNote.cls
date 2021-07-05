public class BatchForSSl_MeetingNote implements Database.Batchable<sObject>, Database.Stateful {
    
    public Integer recordsProcessed = 0;
    public Database.QueryLocator start(Database.BatchableContext bc) {
        
        string completed = 'completed';
        string Cancelled = 'Cancelled';
        return Database.getQueryLocator(
            'SELECT Status_Summary_Line_For_Conga__c,Status_Summary_Line_French__c,Status_Summary_Line__c FROM Meeting_Note__c WHERE Candidate_Assigned__r.Status_Of_Ass__c != :completed And Candidate_Assigned__r.Status_Of_Ass__c != :Cancelled And Meeting_French_SSL_Updated__c = false' );
    }
    public void execute(Database.BatchableContext bc, List<Meeting_Note__c> scope){
        List<Meeting_Note__c> Applications = new List<Meeting_Note__c>();
        List<SSL_Values_Conversion__c> customSettingData = [select SSL_English__c,SSL_French__c	 from SSL_Values_Conversion__c];
        Map<String,String> SslValuesMap = new Map<String,String>() ;    
        
        for( SSL_Values_Conversion__c Ssl: customSettingData){
            SslValuesMap.put(Ssl.SSL_English__c,Ssl.SSL_French__c);
        }
        system.debug('SslValuesMap'+SslValuesMap);
        
        for (Meeting_Note__c app : scope) {
            app.Status_Summary_Line_French__c = SslValuesMap.get(app.Status_Summary_Line__c);
            app.Meeting_French_SSL_Updated__c = true;
            Applications.add(app);
        }
        try{
            update Applications;
        }catch(Exception e){
            System.debug('@@@'+e.getMessage());
        }
    }
    public void finish(Database.BatchableContext bc){
        system.debug('recordsProcessed'+recordsProcessed);    
    }
}