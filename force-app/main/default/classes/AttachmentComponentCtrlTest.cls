@isTest
public with sharing class AttachmentComponentCtrlTest {

	@isTest
	public static void test(){
		
		Mandate__c m = new Mandate__c();
        m.Name='Mandate test';
        insert m;
        
        Attachment att = new Attachment();
		att.Name = 'Profile.PDF';
		Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body'); 
		att.Body = bodyBlob;
	    att.ParentId = m.Id;
	    insert att;
	    
	    AttachmentComponentCtrl ctrl = new AttachmentComponentCtrl();
	    ctrl.mandateId = m.id;
	    system.assert(ctrl.attachmentList.size() == 1);
	    
	    ctrl.rowToRemove = 0;
	    ctrl.removeRowToAttachmentList();
	    system.assert(ctrl.attachmentList.size() == 0);
		
	}

}