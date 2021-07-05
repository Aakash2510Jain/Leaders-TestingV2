@isTest
public class DeleteMandateAttachmentBatchTest {
	
    @testSetup
    public static void init(){
        Mandate__c m = new Mandate__c();
        m.Name='Mandate test1';
        m.Assignment_Status__c = 'Active';
        insert m;
        
		Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body'); 	
        List<Attachment> deleteAttachments = new List<Attachment>();
        deleteAttachments.add(new Attachment(ParentId = m.Id,Name = 'Overnight_Leaders Report test.PDF',body=bodyBlob));
		deleteAttachments.add(new Attachment(ParentId = m.Id,Name = 'Overnight_Leaders Report test.PDF',body=bodyBlob));
		deleteAttachments.add(new Attachment(ParentId = m.Id,Name = 'Overnight_Leaders Report test.PDF',body=bodyBlob));
        insert deleteAttachments;
    }
    
    @isTest
    public static void testBatch(){
        Test.startTest();
        DeleteMandateAttachmentBatch p = new DeleteMandateAttachmentBatch();
        String sch = '0 0 01 * * ?'; 
        system.schedule('Clean attachments from Mandates', sch, p); 
        Test.stopTest();
    }
}