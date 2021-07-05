@isTest
public class EmailFileToAttachmentTest{

    @isTest
    public static void attachmentTest(){

        Account acc = new Account(Name = 'Test Account');
        insert acc;
        
        Contact contact = new Contact(LastName = 'Test', AccountId = acc.Id);
        insert contact;
        
        Task tsk = new Task();
        tsk.Subject = 'Email CV - EN';
        tsk.whoId = contact.Id;
        insert tsk;
        
        ContentVersion cv = new ContentVersion();
        cv.title='Test title.pdf';       
        cv.VersionData=blob.valueof('New Bitmap Image.bmp');
        cv.PathOnClient = 'Test title.pdf';
        insert cv;
        
        FeedItem post = new FeedItem();
        post.parentid = tsk.Id;       
        post.RelatedRecordId = cv.Id;
        post.Type = 'ContentPost';
        
        Test.startTest();
        insert post;               
        Test.stopTest();
        
        system.assert([Select id from Attachment where parentId = :contact.Id].size() > 0);
        
     }

}