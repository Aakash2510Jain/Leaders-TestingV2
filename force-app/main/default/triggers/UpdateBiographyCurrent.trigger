trigger UpdateBiographyCurrent on Work_Experience__c (before insert,before update,after insert,after update) {


	UpdateBiographyCurrentHelper handlerInstance =  new UpdateBiographyCurrentHelper();
    
    if(UpdateBiographyCurrentHelper.isFirstRun){
        
       // 
        
        if(Trigger.isBefore && Trigger.isInsert){
           // handlerInstance.beforeInsert(trigger.new);
        }
        if(Trigger.isAfter && Trigger.isInsert){
            handlerInstance.afterUpdate(trigger.new);
            UpdateBiographyCurrentHelper.isFirstRun = false;
        }
        if(Trigger.isAfter && Trigger.isUpdate){
            System.debug('@@@@ after update ');
            handlerInstance.afterUpdate(trigger.new);
            UpdateBiographyCurrentHelper.isFirstRun = false;
        }
        
    }
    
  
}