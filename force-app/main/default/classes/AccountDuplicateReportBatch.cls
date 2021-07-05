global with sharing class AccountDuplicateReportBatch implements Database.Batchable<sObject>{   

    global void Execute(SchedulableContext SC){
        
        Database.ExecuteBatch(new AccountDuplicateReportBatch());
    }
    
	
	public Database.QueryLocator start(Database.BatchableContext BC){
		
		String query =	 'Select Id, Name ' 
						+'From Account';

		System.debug(query);
		
		return Database.getQueryLocator(query);
	}

	public void execute(Database.BatchableContext BC, List<Account> scope){
		
		update scope;
		
	}
	
	public void finish(Database.BatchableContext bc){
		
	}
}