trigger DeleteOnePagerResponse on One_Pager__c (before delete) {
    
    if(Trigger.IsBefore && Trigger.IsDelete )
    {
        system.debug('Trigger is running');
        DeleteOnePagerResponseHelper.Del_One_Pager_Response(Trigger.Old);
        
    }
}