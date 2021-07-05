/* Test Class: AssignmentCandidatesCtrlTest*/

@isTest
public class AssignmentCVSplitTest {
    
    static testMethod void myUnitTest()
    {
        Mandate__c m = new Mandate__c();
        m.Name='Mandate test';
        
        insert m;
        
        
        Application__c a = new Application__c();
        a.Mandate__c = m.Id;   
        
        insert a;
        
        
        Account acc = new Account(Name = 'Test Account');
    	insert acc;
    	
    	Contact contact = new Contact(LastName = 'Test', AccountId = acc.Id);
    	insert contact;
        
        Note n = new Note();
        n.ParentId = contact.Id ;
        n.Title = 'Test Note';
        insert n; 
        
        system.debug('AnkitaNote'+n.Title);
        
        Meeting_Note__c lrn = new Meeting_Note__c();
        lrn.Candidate_Assigned__c = a.Id ;
        lrn.Contact__c = contact.Id;
        insert lrn ;
       
        System.debug('Mandate: '+m.Id);
        System.debug('Application: '+a.Id);
      
        PageReference pageRef = Page.AssignmentCVSplit;
        Test.setCurrentPageReference(pageRef);
        System.currentPageReference().getParameters().put('candidateid', a.Id);
        system.currentPageReference().getParameters().put('contactid', contact.Id);
       
        ApexPages.StandardController  sc = new ApexPages.StandardController(n);
        AssignmentCVSplitCtrl cvSplit = new AssignmentCVSplitCtrl(sc);
   
        cvSplit.saveLeaderNote();
        cvSplit.cancelLeaderNote();
        
       AssignmentCVSplitCtrl cvSplit1 = new AssignmentCVSplitCtrl(sc);
        
    
        
        
        cvSplit1.stdNote.Title='test';
 
        cvSplit1.saveNote();
        cvSplit.cancelNote();
        
        AssignmentCVSplitCtrl cvSplit2 = new AssignmentCVSplitCtrl(sc);
        
        cvSplit2.saveOrigin();      
 
    }
 
}