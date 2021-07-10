trigger ApplicationTestResultTrigger on Application_Test_Result__c (after insert, after update) {
    if(trigger.isAfter &&  (Trigger.isInsert ||Trigger.isUpdate)){
        system.debug('inside update Trigger');
        ApplicationTestResultTriggerHlpr.updateResultCategoriesWise(Trigger.newMap);
    }
}