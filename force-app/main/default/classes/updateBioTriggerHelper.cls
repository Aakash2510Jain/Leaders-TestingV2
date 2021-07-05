public class updateBioTriggerHelper {
    
    public static Boolean isFirstRun = true;
    
    public void afterUpdate(List<Contact> conList,Map<Id,Contact> oldMap){
        
        List<Id> conIdToUpdated 							= new List<Id>();
        map<Id,List<Id>> conIdsByAccount 					= new map<Id,List<Id>>();
        List<Contact> conToUpdated 							= new List<Contact>();
        
        if(!conList.isEmpty()){
            for(Contact conRec:conList){
                if(conRec.AccountId != null && oldMap.get(conRec.Id).AccountId != conRec.AccountId){
                    //Accepted Offer
                    if(conIdsByAccount.containsKey(conRec.AccountId)){
                        conIdsByAccount.get(conRec.AccountId).add(conRec.Id);
                    }else{
                        conIdsByAccount.put(conRec.AccountId,new List<Id>{conRec.Id});
                    }
                }
            }
        }
        System.debug('@@@@'+conIdsByAccount);
        if(!conIdsByAccount.isEmpty()){
            for(Account accRec:[Select id,Off_Limit__c from Account where Id IN:conIdsByAccount.keySet()]){
                for(Id conIdRec:conIdsByAccount.get(accRec.Id)){
                    conToUpdated.add(new Contact(Id=conIdRec,Off_Limit__c = accRec.Off_Limit__c));
                }
            }
        }
        if(!conToUpdated.isEmpty()){
            System.debug('@@@@'+conToUpdated);
            update conToUpdated;
        }
    }
    public void beforeUpdate(List<Contact> conList,Map<Id,Contact> oldMap){
        
        Map<String, Id> biographyRecordTypeIdByName = 
            BiographyHelper.getBiographyRecordTypeIdByName();
        
        Id recordTypeId = biographyRecordTypeIdByName.get('Experience');
        
        List<Work_Experience__c> toInsert = new List<Work_Experience__c>();
        
        Map<String, Work_Experience__c> lastestWorkExperienceMapByContactId = new Map<String, Work_Experience__c>([SELECT Id, Company__c, Title__c, Contact__c , Title_FR__c FROM Work_Experience__c WHERE Contact__c IN: oldMap.keySet() ORDER BY LastModifiedDate ASC]);
        
        for (Contact c : conList){
            
            
            Boolean updateBio = false;
            Contact oldContact = oldMap.get(c.Id);
            if(c.Update_the_biography__c ) {
                if(!lastestWorkExperienceMapByContactId.containsKey(c.Id))
                    updateBio = true;
                else {
                    if ( (lastestWorkExperienceMapByContactId.get(c.Id).Company__c  != c.AccountId && oldContact.AccountId != c.AccountId) ||
                        (lastestWorkExperienceMapByContactId.get(c.Id).Title__c  != c.Title && oldContact.Title != c.Title) ||
                        (lastestWorkExperienceMapByContactId.get(c.Id).Title_FR__c  != c.Title_FR__c && oldContact.Title_FR__c != c.Title_FR__c) ){
                            
                            updateBio = true;
                            
                        }
                }
            }
            
            
            if(updateBio) {
                Work_Experience__c newRecord = new Work_Experience__c();
                newRecord.RecordTypeId = recordTypeId;
                newRecord.Contact__c = c.Id;
                newRecord.Company__c = c.AccountId;
                newRecord.Title__c = c.Title;
                newRecord.Title_FR__c = c.Title;
                newRecord.Start_Year__c = string.valueof(Date.today().year()); 
                newRecord.Current_del__c = true;
                toInsert.add(newRecord);
                
                c.Update_the_biography__c = false;
            }
            
        }
        
        if(!toInsert.isEmpty()){
            
            List<Work_Experience__c> allWorkExperiences = 
                [Select Id, End_Year__c, Current_del__c
                 From Work_Experience__c
                 Where Contact__c in :oldMap.keySet()
                 and RecordTypeId = :recordTypeId];
            
            Set<Id> bioInserted = new Set<Id>();
            
            Database.SaveResult[] results = Database.insert(toInsert);
            
            for(Database.SaveResult r : results){
                if(r.isSuccess()){              
                    bioInserted.add(r.getId());
                }
            }
            
            if(!bioInserted.isEmpty()){
                
                List<Work_Experience__c> toUpdate = new List<Work_Experience__c>();
                for (Work_Experience__c we : allWorkExperiences){               
                    if(!bioInserted.contains(we.Id)){                   
                        we.Current_del__c = false;
                        if (String.isEmpty(we.End_Year__c)){
                            we.End_Year__c = string.valueof(Date.today().year()); 
                        }                   
                        toUpdate.add(we);
                    }               
                }
                
                if(toUpdate.size()>0){
                    update toUpdate;
                }
                
            }       
            
        }   
    }
    public void afterInsert(List<Contact> conList){
        try{
            System.debug('@@@@'+'afterInsert');
            Map<String, Id> biographyRecordTypeIdByName = BiographyHelper.getBiographyRecordTypeIdByName();
            
            Id recordTypeId = biographyRecordTypeIdByName.get('Experience');
            System.debug('@@@@'+'recordTypeId'+recordTypeId);
            List<Work_Experience__c> workExpList =  new List<Work_Experience__c>();
            
            for(Contact conRecord:conList){
                workExpList.add(new Work_Experience__c(Contact__c=conRecord.Id,Company__c=conRecord.AccountId,Title__c=conRecord.Title,Title_FR__c=conRecord.Title_FR__c,RecordTypeId=recordTypeId));
            }
            System.debug('@@@@'+'workExpList'+workExpList);
            if(!workExpList.isEmpty()){
                insert workExpList;
            }
        }catch(DmlException ex){
            System.debug('Error'+ex.getMessage() +' AT '+ex.getLineNumber());
        }catch(Exception ex){
            System.debug('Error'+ex.getMessage() +' AT '+ex.getLineNumber());
        }
        
    }
    public void contactPhoneSwitchBoardRefactor(List<Contact> conList,Map<Id,Contact> oldMap)
    {
        Set<Id> accountId = new Set<Id>();
        List<Contact> contactList = new List<Contact>();
        for(Contact contact: conList) {
            // flag to check if contact id is not changing
            
            if(contact.AccountId!=null && (contact.Switchboard__c == null || (contact.AccountId != oldMap.get(contact.Id).AccountId))){
                accountId.add(contact.AccountId);
                contactList.add(contact);
            }
            
        }
        
        if(!accountId.isEmpty()) {
            Map<String, String> phoneMapByAccId = new Map<String, String>();
            
            for(Account account: [SELECT Id, Phone FROM Account WHERE Id IN:accountId AND Phone != null]) {
                phoneMapByAccId.put(account.Id, account.Phone);
            }
            
            for(Contact contact: contactList) {
                if(phoneMapByAccId.containsKey(contact.AccountId)) {
                    contact.Switchboard__c = phoneMapByAccId.get(contact.AccountId);
                } else {
                    contact.Switchboard__c = null;
                }
            }
        }
    }
    
    public void UpdatePhoneOnAccount(List<Contact> conList,Map<Id,Contact> oldMap,Map<Id,Contact> newMap)
    {
        List<Account> updateAccountLst 	= new List<Account>();
        
        set<String> conId 	= new set<String>();
        
        Map<Id,String> accphonebyaccid = new Map<Id,String>(); 
        
        if(!conList.isEmpty())
        {
            for(Contact conRec:conList)
            {
                if(oldMap.get(conRec.Id).Switchboard__c != conRec.Switchboard__c )
                {
                    conId.add(conRec.AccountId);
                    accphonebyaccid.put(conRec.AccountId,conRec.Switchboard__c);
                }
            }
        }
        for(String accId:accphonebyaccid.keySet() )
        {
            updateAccountLst.add(new Account(Id=accId,phone = accphonebyaccid.get(accId)));
        }
        
        if(!updateAccountLst.isEmpty())
        {
            update updateAccountLst;
        }
        
    }
    public void Updatecomments(List<Contact> conList,Map<Id,Contact> oldMap)
    {
        
        List<Contact> ConTobeUpdated = new List<Contact>();
        
        set<String> conId 	= new set<String>();
        
        for(Contact c: conList)
        {
            if(c.Additional_Comments__c != null && c.Additional_Comments__c != ''){
                if(c.Additional_Comments__c.length() > 0 && oldMap.get(c.id).Additional_Comments__c != c.Additional_Comments__c)
                {
                    c.comments_Available__c = true;
                    
                }    
            }
            
        }
        
    }
  
}