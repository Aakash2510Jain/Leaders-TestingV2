public class ProspectClients {
    
    public List<Mandate__c> getAssignment() {
        return [select Name, Company__r.Name, Status__c 
                  from Mandate__c
                 where Status__c = 'Prospect - Proposal sent'
                    or Status__c = 'Suspect - Under development'];
    }

}