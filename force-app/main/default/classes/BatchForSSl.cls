public class BatchForSSl implements Database.Batchable<sObject>, Database.Stateful {
    
    public Integer recordsProcessed = 0;
    public Database.QueryLocator start(Database.BatchableContext bc) {
        
        string completed = 'completed';
        string Cancelled = 'Cancelled';
        return Database.getQueryLocator(
            'SELECT Status_Summary_Line_For_Conga__c,Status_Summary_Line_French__c,Status_Summary_Line__c FROM Application__c WHERE Mandate__r.Assignment_Status__c != :completed And Mandate__r.Assignment_Status__c != :Cancelled And Application_French_SSL_Updated__c = false' );
    }
    public void execute(Database.BatchableContext bc, List<Application__c> scope){
        List<Application__c> Applications = new List<Application__c>();
        
        List<SSL_Values_Conversion__c> customSettingData = [select SSL_English__c,SSL_French__c	 from SSL_Values_Conversion__c];
        Map<String,String> SslValuesMap = new Map<String,String>() ;    
        
        for( SSL_Values_Conversion__c Ssl: customSettingData){
            SslValuesMap.put(Ssl.SSL_English__c,Ssl.SSL_French__c);
        }
        system.debug('SslValuesMap'+SslValuesMap);
        
        for (Application__c app : scope) {
            app.Status_Summary_Line_French__c = SslValuesMap.get(app.Status_Summary_Line__c);
            app.Application_French_SSL_Updated__c = true;
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