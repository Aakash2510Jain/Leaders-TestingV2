global class Merginglocationfield implements 
Database.Batchable<sObject>, Database.Stateful {
    
    global Integer recordsProcessed = 0;
    global Database.QueryLocator start(Database.BatchableContext bc) 
    {
        return Database.getQueryLocator(
            'SELECT Id, MailingCity,MailingCountry,MailingState FROM Contact where (MailingCity != null OR MailingState != null OR MailingCountry != null) AND (Has_been_updated__c = false) limit 161066'
        );
    }
    global void execute(Database.BatchableContext bc, List<Contact> scope){
        
        List<Contact> contobeupdated = new List<Contact>();
        for (Contact con : scope) 
        {
            Contact upcon = new Contact(Id = con.Id,Residence_City__c = con.MailingCity,Residence_State__c = con.MailingState,Residance_Country__c = con.MailingCountry,Has_been_updated__c = true);
            contobeupdated.add(upcon)  ;     
            recordsProcessed = recordsProcessed + 1;
        }
        
        update contobeupdated;
    }    
    global void finish(Database.BatchableContext bc){
        
    }
}