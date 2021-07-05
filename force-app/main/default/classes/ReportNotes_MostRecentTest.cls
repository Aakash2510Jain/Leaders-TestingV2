/* **************************************************************************
* Test Class: ReportNotes_MostRecentTest
* Created by Joel Ojeda, 12/15/2014
*
* Purpose/Methods:
*	This is the test class for the trigger ReportNotes_MostRecent
*
* 
* Modifications:
* - {DevName}, {MM/DD/YYYY} – {Description of changes made post deployment to client}
*
************************************************************************** */

@isTest
private class ReportNotes_MostRecentTest {

    static testMethod void testCreation() {
        //create some test data
        Mandate__c assignment = new Mandate__c();
        assignment.Name = 'Test assignment Apex';
        insert assignment;
        
        Account acc = new Account();
        acc.name = 'Test Account Apex';
        insert acc;
        
        Contact c = new Contact();
        c.LastName = 'Test Contact Apex';
        c.AccountId = acc.Id;
        insert c;
        
        Application__c candidate = new Application__c();
        candidate.Contact__c = c.Id;
        candidate.Mandate__c = assignment.Id;
        insert candidate;
        
        // insert one note, will be the most recent 
		Meeting_Note__c note = new Meeting_Note__c();
		note.Candidate_Assigned__c = candidate.Id;
		note.Contact__c = c.Id;
		note.Description__c = 'test 01';
		insert note;
		
		note = [Select Id, Most_Recent__c,CreatedDate,Description__c 
				from Meeting_Note__c 
				where Id=:note.Id];
		
										
		System.assert(note.Most_Recent__c);
		
		// insert a second note, will be the most recent
		Meeting_Note__c otherNote = new Meeting_Note__c();
		otherNote.Candidate_Assigned__c = candidate.Id;
		otherNote.Contact__c = c.Id;
		otherNote.Description__c = 'test 02';
		insert otherNote;

		otherNote = [Select Id, Most_Recent__c,CreatedDate,Description__c 
						from Meeting_Note__c 
						where Id=:otherNote.Id];

		if(note.CreatedDate==otherNote.CreatedDate){
			System.assert(note.Most_Recent__c || otherNote.Most_Recent__c);
		}
		else{
			System.assert(otherNote.Most_Recent__c);	
		}
		
		//delete most recent to go back to the first one
		delete otherNote;
		
		List<Meeting_Note__c> notesSaved = [Select Id, Most_Recent__c 
											from Meeting_Note__c 
											where Id=:note.Id];
										
		if(!notesSaved.isEmpty()){
			System.assert(notesSaved[0].Most_Recent__c);
		}
    }
}