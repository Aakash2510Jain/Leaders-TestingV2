@isTest
class DeleteMandateAttachmentTest {

    
    static testmethod void test() {
       Test.startTest();

      Mandate__c mandate = new Mandate__c(Name='Mandate 1');
      insert mandate;

      // Schedule the test job
String sch = '01 00 00 * * ?';
      String jobId = System.schedule('testDeleteMandateAttachment',
      sch, 
         new DeleteMandateAttachment());

      // Get the information from the CronTrigger API object
      CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, 
         NextFireTime
         FROM CronTrigger WHERE id = :jobId];

   Test.stopTest();

   }
}