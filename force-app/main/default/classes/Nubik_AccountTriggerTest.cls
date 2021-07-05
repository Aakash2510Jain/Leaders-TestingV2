@isTest
private class Nubik_AccountTriggerTest {

    static testMethod void TEST_Nubik_AccountUpdateOffLimitInContact() {
    	
    	Account TheAccount = new Account();
    	TheAccount.Name = 'TesterAccountName';
    	insert TheAccount;
    	
    	Contact TheContact = new Contact();
    	TheContact.LastName = 'TesterLastname';
       	TheContact.AccountId = TheAccount.Id;
       	insert TheContact;
       	
       	update TheAccount;
    }
}