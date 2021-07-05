trigger UpdateBiography on Contact (before update,after insert,before insert,after update) {
    
    updateBioTriggerHelper handlerInstance =  new updateBioTriggerHelper();
    
       if(Trigger.isAfter && Trigger.isInsert)
       {
           handlerInstance.afterInsert(trigger.new);
           updateBioTriggerHelper.isFirstRun = false;
        }
        
        if(Trigger.isBefore && Trigger.isUpdate)
        {
            handlerInstance.beforeUpdate(trigger.new,trigger.oldMap);
            updateBioTriggerHelper.isFirstRun = false;
        }
        if(Trigger.isAfter && Trigger.isUpdate)
        {
            System.debug('After Update');
            handlerInstance.afterUpdate(trigger.new,trigger.oldMap);
            updateBioTriggerHelper.isFirstRun = false;
            
            handlerInstance.UpdatePhoneOnAccount(Trigger.new,Trigger.oldMap,Trigger.newMap);
            
            
            
        }
        if(Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)){
            handlerInstance.contactPhoneSwitchBoardRefactor(trigger.new,Trigger.oldMap);
            updateBioTriggerHelper.isFirstRun = false;
        }
    //}
    
}