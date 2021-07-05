// Call another method from constructoe and fetch records 50000 and then 50000 and then...
// create set and add contacts to the list.
// call another method from constructor and add remaining contacts to the set and keep doing this until set size reaches zero.





global class DeleteContactAttachmentBatchSchedule implements Database.Batchable<sObject> , Schedulable {
    global set<Id> contactIds = new set<Id>();
    
   global DeleteContactAttachmentBatchSchedule()
    {
       /* for ( Contact conli : [Select Id from Contact])
        {
            contactIds.add(conli.Id);
        }*/
        
        for ( Contact conli : [Select Id from Contact ORDER BY LastModifiedDate desc limit 50000])
        {
            contactIds.add(conli.Id);
           
        }
        
        system.debug('size of final contactIds set :'+contactIds.size());
    //    contactIds = fetchContacts(contactIds);
      //  system.debug('size of final contactIds set :'+contactIds.size());
    }
    
  /*  global set<Id> fetchContacts(set<id> contactIds)
    {
      /*  while()
        
        for(Contact conli2 : [Select Id from Contact where Id Not IN: contactIds limit 50000])
            {
                system.debug('size of set inside FOR loop :'+contactIds.size());
                contactIds.add(conli2.id);
            } 
            
        system.debug('size of set outside FOR loop :'+contactIds.size());
        return contactIds ;    
    }*/
        
    
    
    
    
    global static void Schedule(){
        
        DeleteContactAttachmentBatchSchedule p = new DeleteContactAttachmentBatchSchedule();
        String sch = '0 0 01 * * ?'; 
        system.schedule('Clean Identifaction Reports All Mandates', sch, p); 
        
    }
    
    global void execute(SchedulableContext SC)
    {
        DeleteContactAttachmentBatchSchedule n = new DeleteContactAttachmentBatchSchedule();
        Database.executeBatch(n);
    }
    
    global Database.QueryLocator start(Database.BatchableContext  BC)
    {
        system.debug('START'+BC);
        return Database.getQueryLocator([Select Id from Contact]);
    }
    
    global void execute(Database.BatchableContext BC , List<sObject> scope)
    {
        system.debug('EXECUTE'+BC);
        system.debug('scope of execute method'+scope);
        
    /*    for(Contact conli : scope)
        {
            contactIds.add(conli.Id);
        }*/
    }
    
    global void finish(Database.BatchableContext BC)
    {
       system.debug('FINISH'+BC); 
       system.debug('FINISH'+contactIds);
        
      /*  for(Contact conli : scope)
        {
            contactIds.add(conli.Id);
        }*/
               
        if(contactIds != null)
        {
           /* for(Id conId : contactIds)
            {
                system.debug('Execute for :'+conId);
                Database.executeBatch(new DeleteContactAttachmentBatch(conId));
            }*/
            
             system.debug('Execute for :'+contactIds);
            Database.executeBatch(new DeleteContactAttachmentBatch(contactIds));
        }
    }
    
}