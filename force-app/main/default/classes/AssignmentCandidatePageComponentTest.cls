/**
 * Created by ET-MARLABS on 11-06-2019.
 */

@IsTest(SeeAllData=false)
private class AssignmentCandidatePageComponentTest {

    //If the test class or a test method has access to organization data by using the @isTest(SeeAllData=true) annotation, test setup methods aren’t supported in this class.
    //You can have only one test setup method per test class.
    //If a fatal error occurs during the execution of a test setup method, such as an exception that’s caused by a DML operation or an assertion failure, the entire test class fails, and no further tests in the class are executed.
    //If a test setup method calls a non-test method of another class, no code coverage is calculated for the non-test method.

    @testSetup static void setup() {

        Account accRecord = TestUtility.createAccount('JP Morgan');

        /*Contact conRecord = TestUtility.createContact('ConLastName',accRecord.Id);
        Mandate__c mandateRec = TestUtility.createMandate('MandateName');
        Application__c appRec = TestUtility.createCandidate(conRecord.Id,mandateRec.Id);
        Meeting_Note__c meetingNote = TestUtility.createMeetingNote(conRecord.Id,appRec.Id,mandateRec.Id);*/
    }

    @IsTest static void ViewCVCMPControllerTest(){

        Account accRecord = [Select Id from Account limit 1];
        Attachment attRec = TestUtility.creAttachment('CV JP Morgan',accRecord.Id);
        test.startTest();
            ViewCVCMPController.getCVId(attRec.Id);
        test.stopTest();

    }
    @IsTest static void newLRNCompControllerTest(){

        Account accRecord = [Select Id from Account limit 1];

        Contact conRecord = TestUtility.createContact('ConLastName',accRecord.Id);
        Mandate__c mandateRec = TestUtility.createMandate('MandateName');
        Application__c appRec = TestUtility.createCandidate(conRecord.Id,mandateRec.Id);
        Meeting_Note__c meetingNote = TestUtility.createMeetingNote(conRecord.Id,appRec.Id,mandateRec.Id);
        meetingNote.Most_Recent__c = true;

        update meetingNote;

        test.startTest();
            newLRNCompController.getLeaderNote(appRec.Id);
            newLRNCompController.getPicklistValues('Application__c','Source_Status__c');
            newLRNCompController.saveLeadersNote(meetingNote,'Client.');
        test.stopTest();
    }

    @IsTest static void DynamicTableComponentControllerTest(){
        test.startTest();
            DynamicTableComponentController.getRecords(new List<String>{'Id,Name'},'Account','JP','','');
        test.stopTest();
    }

    @IsTest static void ChangeSSLOriginCompCtrlTest(){
        test.startTest();

            ChangeSSLOriginCompCtrl.getPicklistValues('Application__c','Source_Status__c');
            // recListString -> Applications record
            ChangeSSLOriginCompCtrl.updateStatus('Client.','Referral','recListString','STATUS_SUMMARY_LINE');
            ChangeSSLOriginCompCtrl.updateStatus('Client.','Referral','recListString','ORIGIN');
            ChangeSSLOriginCompCtrl.updateStatus('Client.','Referral','recListString','ssl');
            //ssl->'Client.'
            //origin ->'Referral'
        test.stopTest();
    }

    @IsTest static void searchPeopleCompControllerTest(){

        Account accRecord = [Select Id from Account limit 1];

        Contact conRecord = TestUtility.createContact('ConLastName',accRecord.Id);

        Mandate__c mandateRec = TestUtility.createMandate('MandateName');
        mandateRec.Company__c = accRecord.Id;
        update mandateRec;

        Business_Development__c bdRec = TestUtility.createBDRec(accRecord.Id);
        test.startTest();
            searchPeopleCompController.fetchPeopleRec('ConLastName');
            searchPeopleCompController.fetchCompanyRec('JP Morgan');
            searchPeopleCompController.fetchAssignmentRec('JP Morgan');
            searchPeopleCompController.fetchBDRec('JP Morgan');
        test.stopTest();
    }

    static testMethod void AddApplicationToAssignmentLightningTest(){
        //System.assertEquals(0,celsius);
        // System.assertEquals(100,celsius,'Boiling point temperature is not expected.');
    }
}