@isTest
public class InvTestClass {

    
    public static  testMethod void test1(){
        Invoice__c invRec = new Invoice__c(Name='USSG Inv',Invoice_Amount__c=10);
        insert invRec;
        test.startTest();
        InvClass invInstance = new InvClass();
        test.stopTest();
    }
}