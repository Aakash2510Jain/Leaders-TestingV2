global class BatchForDeactivatedUserAccount implements Database.Batchable<sObject>, Database.Stateful{
 
   OwnerId__c mhc = OwnerId__c.getInstance('owner_id');
   
    global  String UserId ;
    
    //public  String oldOwnerId = UserId;
    public  String NewOwnerId = mhc.New_Owner_Id__c;    
    global Integer recordsProcessed = 0;
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        system.debug('old :'+UserId+ 'new :'+NewOwnerId);
        system.debug('SELECT ID, OwnerId from Account where OwnerId =:UserId');
        
        return Database.getQueryLocator(
            'SELECT ID, OwnerId from Account where OwnerId =:UserId' );
    }
    global void execute(Database.BatchableContext bc, List<Account> scope)
    {
        List<Account> listtobeupdated = new List<Account>();
        
        for (Account val : scope) 
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
    
    global BatchForDeactivatedUserAccount(String UserId) {
    system.debug('The userid from aura is'+UserId);    
    this.UserId = UserId;
    }
    
}