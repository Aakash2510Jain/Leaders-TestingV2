@isTest
 public class ProspectClientsTest{
 
     @isTest
    static void getAssignmentTest() {
        
        Account acc = new Account (Name = 'Test Account');
        insert acc;
        
        Mandate__c m = new Mandate__c(Name = 'Test Mandate', 
            Status__c = 'Prospect - Proposal sent',
            Company__c = acc.Id);
            
        insert m;
        
        test.startTest();
        
        ProspectClients ctrl = new ProspectClients();
        
        system.assert(ctrl.getAssignment().size()>0);
        
        test.stopTest();
        
    }
}