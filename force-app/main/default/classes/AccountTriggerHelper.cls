public class AccountTriggerHelper {
    
    public static void updateCompanyOffLimitUntill(List<Account> accList,Map<Id,Account> oldMap){
        
        set<String> assignmentIdToUpdated 	= new set<String>();
        List<Account> accToUpdated 			= new List<Account>();
        
        if(!accList.isEmpty()){
            for(Account accRecord:accList){
                if(oldMap.get(accRecord.Id).Off_Limit_Period__c != accRecord.Off_Limit_Period__c){
                    
                    if(accRecord.Off_Limit_Period__c != null && accRecord.Candidate_Offer_Date__c != null){
                        Date dateOffLimit 	= (accRecord.Candidate_Offer_Date__c).addMonths(Integer.valueOf(accRecord.Off_Limit_Period__c.substring(0,2)));
                        accToUpdated.add(new Account(Id=accRecord.Id,OffLimit_Until__c=dateOffLimit));
                    }
                    
                }
            }
        }
        
        if(!accToUpdated.isEmpty()){
            update accToUpdated;
        }
    }
    public static void updateContactLocation(List<Account> accList,Map<Id,Account> oldMap,Map<Id,Account> newMap){
        
        List<Contact> updateContactList 	= new List<Contact>(); 
        set<String> accIds 	= new set<String>();
        
        if(!accList.isEmpty()){
            for(Account accRecord:accList){
                if(oldMap.get(accRecord.Id).Country__c != accRecord.Country__c || oldMap.get(accRecord.Id).State__c != accRecord.State__c || oldMap.get(accRecord.Id).City__c != accRecord.City__c){
                    accIds.add(accRecord.Id);
                }
            }
        }
        for(Contact con:[Select Id,AccountId from Contact where AccountId IN:accIds]){
            updateContactList.add(new Contact(Id=con.Id,Office_City__c=newMap.get(con.AccountId).City__c,Office_State__c=newMap.get(con.AccountId).State__c,Office_Country__c=newMap.get(con.AccountId).Country__c));
        }
        
        if(!updateContactList.isEmpty()){
            update updateContactList;
        }
    }
    public static void updateContactOffLimitUntill(List<Account> accList,Map<Id,Account> oldMap){
        
        List<Id> requiredAccIds 			= new List<Id>();
        List<Contact> updateContactList 	= new List<Contact>();
        
        for(Account acc : accList){
            if(acc.Off_Limit__c != oldMap.get(acc.Id).Off_Limit__c)
                requiredAccIds.add(acc.Id);
        }
        
        if(!requiredAccIds.isEmpty()){
            
            for(Contact conRec:[Select Id,Account.Off_Limit__c,Accepted_Offer__c from Contact where AccountId IN:requiredAccIds]){
                if(conRec.Accepted_Offer__c != true)
                    updateContactList.add(new Contact(Id=conRec.Id,Off_Limit__c=conRec.Account.Off_Limit__c,Contact_Off_Limit__c=conRec.Account.Off_Limit__c));
            }
        }
        
        if(!updateContactList.isEmpty()){
            update updateContactList;
        }
    }
    
    public static void updateOffLimitByUser(List<Account> accList,Map<Id,Account> oldMap)
    {
        List<Account> accLists = new List<Account>();
        
        for(Account acc: accList )
        {
            if(acc.Off_Limit__c != oldMap.get(acc.Id).Off_Limit__c)
            {
                //acc.Off_Limit__c == true &&
                accLists.add(new Account(Id=acc.Id,Off_Limit_by_User__c=userInfo.getUserId()));
                //acc.Off_Limit_by_User__c = userInfo.getUserId();
            }
        }
        if(!accLists.isEmpty()){
            update accLists;
        }
    }
    public static void updateSwitchBoardOnContact(List<Account> accList,Map<Id,Account> oldMap,Map<Id,Account> newMap)
    {
        
        List<Contact> updateContactLst 	= new List<Contact>();
        
        List<Account> accLst = new List<Account>();
        
        set<String> accId 	= new set<String>();
        
        if(!accList.isEmpty())
        {
            for(Account accRecord:accList){
                if(oldMap.get(accRecord.Id).Phone != accRecord.Phone )
                {
                    accId.add(accRecord.Id);
                }
            }
        }
        for(Contact con:[Select Id,AccountId from Contact where AccountId IN:accId])
        {
            updateContactLst.add(new Contact(Id=con.Id,Switchboard__c = newMap.get(con.AccountId).Phone));
        }
        
        if(!updateContactLst.isEmpty())
        {
            update updateContactLst;
        }
        
    }
}