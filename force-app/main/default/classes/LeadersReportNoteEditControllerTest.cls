@isTest
private class LeadersReportNoteEditControllerTest {
        
     static testMethod void myUnitTest() {
        PageReference pageRef = Page.LeadersReportNoteEdit;
        Test.setCurrentPageReference(pageRef);
         
         Mandate__c mandate = new Mandate__c ();
         insert mandate;
         
        Mandate_competencies__c mandateCpt = new Mandate_competencies__c(Mandate__c=mandate.Id);
        insert mandateCpt; 
        
        Application__c app = new Application__c(Mandate__c=mandate.Id);
        insert app;
         
        Meeting_Note__c meetingNote = new Meeting_Note__c(Candidate_Assigned__c=app.Id);
        insert meetingNote;
         
      
	    ApexPages.currentPage().getParameters().put('CF00NU00000042znA_lkid',app.Id);            
        ApexPages.currentPage().getParameters().put('retURL',app.Id);            
         
        ApexPages.StandardController sc = new ApexPages.standardController(meetingNote); 
        ApexPages.StandardController scNew = new ApexPages.standardController(new Meeting_Note__c());
        
        LeadersReportNoteEditController controller = new LeadersReportNoteEditController(scNew);

        controller.cancel();
          
         LeadersReportNoteEditController controllerEdit = new LeadersReportNoteEditController(sc);
        controllerEdit.save();
        controllerEdit.cancel();
     }

}