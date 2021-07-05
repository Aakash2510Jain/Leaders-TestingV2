@isTest
public class AssignmentCandidatesTest {

    static testMethod void myUnitTest() {
    	
    	Account acc = new Account(Name = 'Test Account');
    	insert acc;
    	
    	Contact contact = new Contact(LastName = 'Test', AccountId = acc.Id);
    	insert contact;
    	
    	Mandate__c m = new Mandate__c();
        m.Name='Mandate test';        
        insert m;
        
        Application__c a = new Application__c();
        a.Mandate__c = m.Id;  
        a.Contact__c = contact.Id;
        insert a;  
        
        test.startTest();
        
        try{        
	        Application__c a2 = new Application__c();
	        a2.Mandate__c = m.Id;  
	        a2.Contact__c = contact.Id;
	        insert a2;        
        }catch(Exception e){
        	system.assert(e.getMessage().contains('A contact cannot be attached to the assignment more than once'));
        }
        
        
    }
}