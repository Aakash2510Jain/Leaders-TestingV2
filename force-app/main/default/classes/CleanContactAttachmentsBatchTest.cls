@isTest
class CleanContactAttachmentsBatchTest {

    
    static testmethod void test() {
       Test.startTest();

      Contact contact = new Contact(LastName='Test');
      insert contact;

      // Schedule the test job
String sch = '01 00 00 * * ?';
      String jobId = System.schedule('testDeleteMandateAttachment',
      sch, 
         new CleanContactAttachmentsBatch());

      // Get the information from the CronTrigger API object
      CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, 
         NextFireTime
         FROM CronTrigger WHERE id = :jobId];

   Test.stopTest();

   }
}