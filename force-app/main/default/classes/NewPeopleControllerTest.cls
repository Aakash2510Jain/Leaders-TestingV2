@isTest
private class NewPeopleControllerTest {
    
    public static NewPeopleController newPeopleCtrl;
    
    static testMethod void initData() {
        Contact contact = new Contact(); 
        
        ApexPages.StandardController sc = new ApexPages.standardController(contact);
        newPeopleCtrl = new NewPeopleController(sc);
        
        newPeopleCtrl.contact.FirstName = 'Test';
        newPeopleCtrl.contact.LastName = 'Test';
    }
    
    static testMethod void cancelContact() {
        
        initData();
        
        newPeopleCtrl.cancelContact();
        
    }
    
    static testMethod void saveDuplicateContact() {
        
        initData();
        
        newPeopleCtrl.saveDuplicateContact();
    }
    
    static testMethod void saveContact() {
        
        initData();
        
        newPeopleCtrl.saveContact();
    }
    
    static testMethod void saveAccount() {
        initData();
        
        newPeopleCtrl.account.Name = 'Test';
        newPeopleCtrl.account.Industry_Types__c = 'Test';
        
        newPeopleCtrl.saveAccount();
        
    }
    
    static testMethod void searchAccount() {
        initData();
        
        newPeopleCtrl.searchAccount();
        
    }
    
    static testMethod void newAccount() {
        initData();
        
        newPeopleCtrl.newAccount();
        
    }
    
    static testMethod void selectAccount() {
        initData();
        
        newPeopleCtrl.selectAccount();
        
    }
    
    static testMethod void setSearchQueryAccount() {
        initData();
        
        newPeopleCtrl.setSearchQueryAccount();
        
    }
    
    static testMethod void cancelDuplicateContact() {
        initData();
        
        newPeopleCtrl.cancelDuplicateContact();
        
    }

}