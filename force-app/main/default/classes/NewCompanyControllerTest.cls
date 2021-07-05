@isTest
private class NewCompanyControllerTest {
    
    
    static testMethod void myUnitTest() {
		
        Account acc = new Account(Name='Test');
    
        
         ApexPages.StandardController sc = new ApexPages.standardController(acc); 
        
        NewCompanyController ctrl = new NewCompanyController(sc);
        ctrl.account.name='Test';
        ctrl.save();
        ctrl.cancel();
         
    }

}