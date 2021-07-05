@isTest
private class NewRelatedAssignmentControllerTest {
    
    
    static testMethod void myUnitTest() {
        
        PageReference pageRef = Page.NewRelatedAssignment;
        Test.setCurrentPageReference(pageRef);
        
        Application__c app = new Application__c();
        Mandate__c mandate = new Mandate__c();
        insert mandate;
		
  		ApexPages.currentPage().getParameters().put('CF00NU00000042Zrm_lkid', mandate.Id);        
        ApexPages.currentPage().getParameters().put('saveURL', '/');        
        ApexPages.currentPage().getParameters().put('retURL', '/');        
        ApexPages.StandardController sc = new ApexPages.standardController(app);
        NewRelatedAssignmentController controller = new NewRelatedAssignmentController(sc);
        
      
        controller.contact.LastName = 'Test';
        controller.save();
        controller.saveContact();
        controller.cancel();
        controller.cancelContact();
        controller.newContact();
        controller.searchContact();
        controller.selectContact();
        controller.setSearchQuery();
       
        
    }

}