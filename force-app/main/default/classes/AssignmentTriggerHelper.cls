public class AssignmentTriggerHelper {
    //Only This Method is used
    public static void updateCompanyOffLimitstartDate(List<Mandate__c> mandateList,Map<Id,Mandate__c> oldMap){
        
        List<Account> accToUpdatedForCandidateStartDate 	= new List<Account>();
        List<Account> accToUpdated 			= new List<Account>();
        List<String> accId 					= new List<String>();
        Map<String,String> monthsByAccountId 	= new Map<String,String>();
        
       
        
        if(!mandateList.isEmpty()){
            
            for(Mandate__c mandateRec:mandateList){
                accId.add(mandateRec.Company__c); 
            }
            for(Account accRec:[Select Id,name,Off_Limit_Period__c from Account where ID IN: accId]){
                monthsByAccountId.put(accRec.Id,accRec.Off_Limit_Period__c!=null?accRec.Off_Limit_Period__c:'');
            }

            for(Mandate__c mandateRec:mandateList){
                if(oldMap.get(mandateRec.Id).Mandate_Start_Date__c != mandateRec.Mandate_Start_Date__c && mandateRec.Mandate_Start_Date__c!=null){
                    system.debug('offLimit +i am above');
                    accToUpdated.add(new Account(Id=mandateRec.Company__c,Off_Limit_Start_Date__c=mandateRec.Mandate_Start_Date__c,Off_Limit_Period__c='12 Months'));
                }
                if(oldMap.get(mandateRec.Id).Candidate_start_date__c != mandateRec.Candidate_start_date__c && mandateRec.Candidate_start_date__c!=null){
                    String offLimit = monthsByAccountId.get(mandateRec.Company__c);
                    system.debug('offLimit +i am below');
                    if(offLimit == ''){
                        Date myDate = mandateRec.Candidate_start_date__c;
                        date newDate = myDate.addMonths(12);
                        accToUpdatedForCandidateStartDate.add(new Account(Id=mandateRec.Company__c,OffLimit_Until__c = newDate,Candidate_Offer_Date__c=mandateRec.Candidate_start_date__c,Off_Limit__c=true));
                    }else{
                        Date myDate = mandateRec.Candidate_start_date__c;
                        offLimit = offLimit.Substring(0,offLimit.length()-7);
                        integer months = Integer.valueOf(offLimit);
                        date newDate = myDate.addMonths(months);
                       	accToUpdatedForCandidateStartDate.add(new Account(Id=mandateRec.Company__c,OffLimit_Until__c = newDate,Candidate_Offer_Date__c=mandateRec.Candidate_start_date__c,Off_Limit__c=true));   
                    }
                    
                  
                }
            }
        }
        if(!accToUpdated.isEmpty()){
            update accToUpdated;
        }
        if(!accToUpdatedForCandidateStartDate.isEmpty()){
            update accToUpdatedForCandidateStartDate;
        }
    }
    
    public static void createOnePager(List<Mandate__c> mandateList){
        List<One_Pager__c > ListToBeInserted = new List<One_Pager__c>();
        List<Mandate__c> ManListToBeUpdated  = new List<Mandate__c>();
        List<One_Pager_Values__c> customSettingData = [select name,French__c from One_Pager_Values__c];
        for(Mandate__c man :mandateList )
        {   
            for(One_Pager_Values__c sa :customSettingData){
                ListToBeInserted.add(new One_Pager__c(English__c = sa.Name,French__c = sa.French__c,Mandate__c = man.Id));
             }
             ManListToBeUpdated.add(new mandate__C(id = man.ID,Is_One_Pager_Available__c = True));
        }
        system.debug('ListToBeInserted'+ListToBeInserted.size());
        update ManListToBeUpdated;
        insert ListToBeInserted;
    }
    
        /*public static void updateFinalCandidate(List<Mandate__c> mandateList,Map<Id,Mandate__c> oldMap){
    //Mandate_Start_Date__c
    ////Off_Limit_Start_Date__c
    List<Account> accToUpdated 			= new List<Account>();
    if(!mandateList.isEmpty()){
    for(Mandate__c mandateRec:mandateList){
    if(oldMap.get(mandateRec.Id).Mandate_Start_Date__c != mandateRec.Mandate_Start_Date__c && mandateRec.Mandate_Start_Date__c!=null){
    
    accToUpdated.add(new Account(Id=mandateRec.Company__c,Off_Limit_Start_Date__c=mandateRec.Mandate_Start_Date__c,Off_Limit__c=true));
    
    }
    }
    }
    if(!accToUpdated.isEmpty()){
    update accToUpdated;
    }
    }
    public static void updateAssignmentEndDate(List<Mandate__c> mandateList,Map<Id,Mandate__c> oldMap){
    //Mandate_Start_Date__c
    ////Off_Limit_Start_Date__c
    List<Account> accToUpdated 			= new List<Account>();
    if(!mandateList.isEmpty()){
    for(Mandate__c mandateRec:mandateList){
    if(oldMap.get(mandateRec.Id).Mandate_Start_Date__c != mandateRec.Mandate_Start_Date__c && mandateRec.Mandate_Start_Date__c!=null){
    
    accToUpdated.add(new Account(Id=mandateRec.Company__c,Off_Limit_Start_Date__c=mandateRec.Mandate_Start_Date__c,Off_Limit__c=true));
    
    }
    }
    }
    if(!accToUpdated.isEmpty()){
    update accToUpdated;
    }
    }*/
        
    public static void createAssignmentNote(List<Mandate__c> mandateList){
        
        List<Assignment_Notes__c> noteList = new List<Assignment_Notes__c>();
        
        for(Mandate__c man :mandateList )
        {
            Assignment_Notes__c processNotes = new Assignment_Notes__c();
            
            processNotes.Assignment_Research__c = man.id;
            
            processNotes.Name = 'Test Process Task';
            
            noteList.add(processNotes);
        }
        insert noteList;
    }
}