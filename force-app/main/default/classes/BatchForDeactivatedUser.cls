global class BatchForDeactivatedUser implements Database.Batchable<sObject>, Database.Stateful {
    
    
    OwnerId__c mhc = OwnerId__c.getInstance('owner_id');
   
    global  String UserId ;
    
    //public  String oldOwnerId = UserId;
    public  String NewOwnerId = mhc.New_Owner_Id__c;    
    global Integer recordsProcessed = 0;
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        system.debug('old :'+UserId+ 'new :'+NewOwnerId);
        return Database.getQueryLocator(
            'SELECT ID, OwnerId from Contact where OwnerId=:UserId' );
    }
    global void execute(Database.BatchableContext bc, List<Contact> scope)
    {
        List<Contact> listtobeupdated = new List<Contact>();
        
        for (Contact val : scope) 
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
    global BatchForDeactivatedUser(String UserId) {
    this.UserId = UserId;
    }
}