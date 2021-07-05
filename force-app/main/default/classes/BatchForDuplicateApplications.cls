public class BatchForDuplicateApplications implements Database.Batchable<sObject>, Database.Stateful  {
    public Integer recordsProcessed = 0;
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
            'Select Id,Duplicates_Deleted__c from mandate__c where Duplicates_Deleted__c = false '  );
    }
    public void execute(Database.BatchableContext bc, List<mandate__c> scope){
        List<Id> DuplicateIds = new List<Id>();
        List<Id> TotalDuplicateApps = new List<Id>();
        List<Id> MandateIds = new List<Id>();
        List<Mandate__c> manToBeUpdated = new List<Mandate__c>();
        Map<Id,List<Application__C>> appByMan = new Map<Id,List<Application__C>>();
        List<Application__c> AppData = new List<Application__c>();
        for(Mandate__c man:[Select Id,Duplicates_Deleted__c,(Select id,Contact__c From Applications__r) from mandate__c where Duplicates_Deleted__c = false]){
            DuplicateIds = new List<Id>();
            appByMan.put(man.Id,man.Applications__r);
            DuplicateIds = BatchForDuplicateApplications.GetDuplicates(man.Applications__r);
            system.debug('DuplicateIds'+DuplicateIds);
            TotalDuplicateApps.addall(DuplicateIds);
            MandateIds.add(man.Id);
        }
        system.debug('TotalDuplicateApps'+TotalDuplicateApps);
        for(String str:MandateIds){
            manToBeUpdated.add(new mandate__C(id = str,Duplicates_Deleted__c = true));
        }
        update manToBeUpdated;
        Database.delete(TotalDuplicateApps, true);
    }
    
    public static List<Id> GetDuplicates(List<Application__c> Applist){
        List<Id> OriginalIds = new List<Id>();
        Map<Id,Application__c> duplicatemap = new Map<Id,Application__c>();
        
        for(Application__c app : Applist) {
            if(duplicatemap.containsKey(app.Contact__c)){
                OriginalIds.add(app.Id);
            }
            else{
                duplicatemap.put(app.contact__c,app);
            }
        }
        return OriginalIds;
    }
    public void finish(Database.BatchableContext bc){
        system.debug('recordsProcessed'+recordsProcessed);    
    }
}