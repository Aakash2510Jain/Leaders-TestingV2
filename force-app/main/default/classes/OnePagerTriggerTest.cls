@isTest
private class OnePagerTriggerTest {
    
    static testMethod void TEST_OnePager() {
        
        One_Pager__c op = new One_Pager__c();
        op.English__c = 'TesterEnglishName';
        op.French__c    = 'TesterFrnchName';
        insert op;
        
        One_Pager_Response__c opr = new One_Pager_Response__c();
        opr.Question_Eng__c = op.English__c;
        opr.Question_Fr__c = op.French__c;
        opr.One_Pager__c = op.Id;
        insert opr;
        
        delete op;
      
    }
}