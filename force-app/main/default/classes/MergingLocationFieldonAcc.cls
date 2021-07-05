global class MergingLocationFieldonAcc implements 
Database.Batchable<sObject>, Database.Stateful {
    
    global Integer recordsProcessed = 0;
    global Database.QueryLocator start(Database.BatchableContext bc) 
    {
        return Database.getQueryLocator(
            'SELECT Id, BillingCity ,BillingState,BillingCountry  FROM Account where (BillingCity != null OR BillingState != null OR BillingCountry != null) AND (Acc_Has_been_updated__c != true) limit 100000'
        );
    }
    global void execute(Database.BatchableContext bc, List<Account> scope){
        
        List<Account> Acctobeupdated = new List<Account>();
        for (Account acc : scope) 
        {
            System.debug('@@@@'+acc);
            Account upcon = new Account(Id = acc.Id,City__c = acc.BillingCity,State__c = acc.BillingState,Acc_Has_been_updated__c = true,Country__c=acc.BillingCountry);
            Acctobeupdated.add(upcon)  ;     
            recordsProcessed = recordsProcessed + 1;
        }
        
        update Acctobeupdated;
    }    
    global void finish(Database.BatchableContext bc)
    {
        
    }
}