//Nubik jgaviria 08-07-2014 C048025
trigger AccountTrigger on Account (before update,before delete,after update) {
    
    if(Trigger.isBefore && Trigger.isUpdate){
       
    } 
    
    
    if(Trigger.IsBefore && Trigger.IsDelete){
        for(Account acc : Trigger.Old){
            if(acc.Name == LeadersBoardConstants.DO_NOT_DELETE_ACCOUNT_NAME){
                acc.addError('Deletion of this Account is not permitted!');
            }
        }
    }
    if(Trigger.IsAfter && Trigger.IsUpdate)
    {
        AccountTriggerHelper.updateCompanyOffLimitUntill(Trigger.new,Trigger.oldMap);
       	AccountTriggerHelper.updateContactOffLimitUntill(Trigger.new,Trigger.oldMap);
        AccountTriggerHelper.updateOffLimitByUser(Trigger.new,Trigger.oldMap);
        // Update Contact Location
        AccountTriggerHelper.updateContactLocation(Trigger.new,Trigger.oldMap,Trigger.newMap);
        // Update Switch Board
        AccountTriggerHelper.updateSwitchBoardOnContact(Trigger.new,Trigger.oldMap,Trigger.newMap);
        
    }
}