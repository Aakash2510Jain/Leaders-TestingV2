/**
 * Created by ET-MARLABS on 10-06-2019.
 */

public with sharing class TestUtility {

    public static Attachment creAttachment(String attName,String parentId){

        Attachment attach=new Attachment();
        attach.Name=attName;
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId= parentId;
        insert attach;
        // return is optional, use it when you need
        return attach;
    }
    public static Mandate__c createMandate(String mandateName){
        Mandate__c assignment = new Mandate__c();
        assignment.Name = mandateName;
        insert assignment;

        // return is optional, use it when you need
        return assignment;
    }
    public static Account createAccount(String accName){
        Account acc = new Account();
        acc.name = accName;
        insert acc;
        return acc;
    }
    public static Contact createContact(String contactLastName,String accId){
        Contact c = new Contact();
        c.LastName = contactLastName;
        c.AccountId = accId;
        insert c;
        return c;
    }
    public static Application__c createCandidate(String conId,String mandateId){
        Application__c candidate = new Application__c();
        candidate.Contact__c = conId;
        candidate.Mandate__c = mandateId;
        insert candidate;
        return candidate;
    }

    public static Meeting_Note__c createMeetingNote(String conId,String candidateId,String mandateId){
        Meeting_Note__c note = new Meeting_Note__c();
        note.Candidate_Assigned__c = candidateId;
        note.Contact__c = conId;
        note.Description__c = 'test 01';
        insert note;
        return note;
    }

    public static Business_Development__c createBDRec(String accId){
        Business_Development__c bdRec = new Business_Development__c(Account_Name__c=accId);
        insert bdRec;
        return bdRec;
    }



}