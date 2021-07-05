/* **************************************************************************
* Test Class: AssignmentCandidatesCtrlTest
* Created by Alexis Vargas, 04/21/2015
*
* 
* Modifications:
* - {DevName}, {MM/DD/YYYY} – {Description of changes made post deployment to client}
*
************************************************************************** */
@isTest
public class AssignmentCandidatesCtrlTest {

    static testMethod void myUnitTest() 
    {
    	Mandate__c m = new Mandate__c();
        m.Name='Mandate test';
        
        insert m;
        
        Application__c a = new Application__c();
        a.Mandate__c = m.Id;        
        
        insert a;
        
        System.debug('Mandate: '+m.Id);
        System.debug('Application: '+a.Id);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(m);
        AssignmentCandidatesCtrl aPage = new AssignmentCandidatesCtrl(sc);
        
        System.debug('page mandate: ' + aPage.mandate);
        System.debug('page applicationList: ' + aPage.applicationList);
        
        system.assertEquals(m.Id, aPage.mandate.Id);
        
        
        List<Application__c> la = aPage.getApplications();
        System.debug('page getApplications: ' + la);
 		
           aPage.Next();
        aPage.Previous();
        aPage.Beginning();
        aPage.End();
        aPage.getDisablePrevious();
        aPage.getDisableNext();
        aPage.getPageNumber();
        aPage.getTotal_size();
        aPage.getTotalPages();
        
        aPage.editReportNote();
        aPage.addCandidateToMandate();
        aPage.deleteCandidates();
        
        aPage.sendJobDescription();
        
        aPage.leadersReportPage();
        aPage.goBack();
        aPage.SplitVF();
        aPage.newCandidate();
        aPage.showJobDescriptionList();
        aPage.addNewContact();
        aPage.selectPotencialCandidates();
        
        
        String s = aPage.getSortDirection();
        System.debug('page getSortDirection: ' + s);
        system.assertEquals(s, 'ASC');
        aPage.sortExpression = null;
        s = aPage.getSortDirection();
        System.debug('page getSortDirection: ' + s);
        system.assertEquals(s, 'ASC');      
        
     
        
        
    }
    
    static testMethod void createReportNoteTest() 
    {
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
        
        ApexPages.StandardController sc = new ApexPages.StandardController(m);
        AssignmentCandidatesCtrl aPage = new AssignmentCandidatesCtrl(sc);
        
        aPage.candidateId = a.Id;
        system.assert(aPage.createReportNote()!=null);
        
        
        
        Meeting_Note__c note = new Meeting_Note__c();
        note.Candidate_Assigned__c = a.Id;
        note.Contact__c = contact.Id;
        note.Description__c = 'test';
        insert note;  
        system.assert(aPage.createReportNote()!=null);
    	
    }
    
}