global class BatchForDeactivatedUserAss implements Database.Batchable<sObject>, Database.Stateful {
    
    OwnerId__c mhc = OwnerId__c.getInstance('owner_id');
   
    global  String UserId ;
    
    //public  String oldOwnerId = UserId;
    public  String NewOwnerId = mhc.New_Owner_Id__c;    
    global Integer recordsProcessed = 0;
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        system.debug( 'old :'+UserId+ 'new :'+NewOwnerId);
        return Database.getQueryLocator(
            'SELECT ID, OwnerId from mandate__c where OwnerId=:UserId' );
    }
    global void execute(Database.BatchableContext bc, List<Mandate__c> scope)
    {
        List<Mandate__c> listtobeupdated = new List<Mandate__c>();
        
        for (Mandate__c val : scope) 
        {
            val.OwnerId  = NewOwnerId;
            listtobeupdated.add(val);
            recordsProcessed = recordsProcessed + 1;
        }
        system.debug('Number oif record processed :'+recordsProcessed);
        update listtobeupdated;
    }    
    global void finish(Database.BatchableContext bc){
    }    
    global BatchForDeactivatedUserAss(String UserId) {
        this.UserId = UserId;
    }
    
}