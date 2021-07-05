public with sharing class AssSelectionLwcHelper {
    
    @AuraEnabled(cacheable=true)
    public static List<Mandate__c> getAssignmentListinitial(String conId) {
        
        // conId = '0031100001oPmnbAAC';
        String Job_Area =  [SELECT job_Area__c FROM Contact WHERE id = :conId].job_Area__c;
        List<String> job_area_Interest = new List<String>();
        if (Job_Area!='' && Job_Area!=null){
            job_area_Interest = Job_Area.split(';', 0);
        }else{
            job_area_Interest=new List<id>();
        }
        List<Mandate__c> AssToBereturned = [SELECT Id,Name,Assignment_Status__c,Candidate_start_date__c,Industry_Types__c,Mandate_Start_Date__c,Language__c,Mandate_Company_Name__c,Mandate_End_Date__c FROM Mandate__c where Mandate_End_Date__c != null and Industry_Types__c != null and Assignment_Status__c = 'Active'And Job_Function__c in:job_area_Interest limit 25];
        system.debug(AssToBereturned.size());
        return AssToBereturned;
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Application__c> getApplicationList(string conID) {
        return [SELECT Id,Name,mandate_company_name__c,Mandate_Start_Date__c,Status_Summary_Line__c FROM Application__c WHERE Contact__c =:conID  LIMIT 25];
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Mandate__c> getAssignmentList(string compId) {
        return [SELECT Id,Name,Company_Name_French__c,Company__c,Job_Function__c,Start_Date__c,End_Date__c,Total_Candidates_Required__c,MandateStartDate__c,Mandate_End_Date__c,State__c,Status__c FROM Mandate__c where company__c =:compId  limit 25];
    }
    
    /*@AuraEnabled(cacheable=true)
public static List<Mandate__c> getNewAssignmentList(string newAssId) {
return [SELECT Id,Name,Start_Date__c,End_Date__c,Total_Candidates_Required__c FROM Mandate__c where id =:newAssId  limit 25];
}*/
    
    @AuraEnabled(cacheable=true)
    public static map<String,String> getSelfAssIdandOPId(string appID) {
        map<string,String> DocsbyAppid = new map<string,String>();
        Attachment[] attOPfromApp = [SELECT Id FROM Attachment WHERE ParentId = :appID AND Name LIKE '%One Pa%' ORDER BY LastModifiedDate ASC LIMIT 1];
        Attachment[] attSelfAssfromApp = [SELECT Id FROM Attachment WHERE ParentId = :appID AND Name LIKE '%Self Ass%' ORDER BY LastModifiedDate DESC LIMIT 1];        
        if(attSelfAssfromApp.size() > 0){
            DocsbyAppid.put('SelfAssId',attSelfAssfromApp[0].Id);
        }
        if(attOPfromApp.size() > 0)
        { 
            DocsbyAppid.put('OnePagerId',attOPfromApp[0].Id);
        }
        system.debug(DocsbyAppid);
        return DocsbyAppid;
    }
    
    @AuraEnabled(cacheable=true)
    public static map<String,String> getDocsForAss(string assID) {
        map<string,String> DocsbyAppid = new map<string,String>();
        Attachment[] attJobDescfromApp = [SELECT Id FROM Attachment WHERE ParentId = :assID AND Name LIKE '%Job Desc%' ORDER BY LastModifiedDate ASC LIMIT 1];
        Attachment[] attResearchStrfromApp = [SELECT Id FROM Attachment WHERE ParentId = :assID AND Name LIKE '%Research St%' ORDER BY LastModifiedDate DESC LIMIT 1];
        Attachment[] attInterviewfromApp = [SELECT Id FROM Attachment WHERE ParentId = :assID AND Name LIKE '%Employee%' ORDER BY LastModifiedDate DESC LIMIT 1];
        Attachment[] attExecSumStrfromApp = [SELECT Id FROM Attachment WHERE ParentId = :assID AND Name LIKE '%Executive Su%' ORDER BY LastModifiedDate DESC LIMIT 1];        
        
        if(attResearchStrfromApp.size() > 0){
            DocsbyAppid.put('ResstrtgyId',attResearchStrfromApp[0].Id);
        }
        if(attJobDescfromApp.size() > 0)
        { 
            DocsbyAppid.put('jobDescId',attJobDescfromApp[0].Id);
        }
        if(attInterviewfromApp.size() > 0){
            DocsbyAppid.put('intQueId',attInterviewfromApp[0].Id);
        }
        if(attExecSumStrfromApp.size() > 0)
        { 
            DocsbyAppid.put('execSumId',attExecSumStrfromApp[0].Id);
        }
        system.debug(DocsbyAppid);
        return DocsbyAppid;
    }
    @AuraEnabled(cacheable=true)
    public static List<Contact> getCandidateList() {
        return [SELECT Id,Status_Summary_Line__c,Phone,Email,Name,Language__c  FROM Contact WHERE Status_Summary_Line__c = 'Potential candidate.' limit 25 ];
    }
    @AuraEnabled
    public static String addCandidateToAss(List<string> canIds,String assId) {
        system.debug('canIds'+canIds+'Ass-Id'+assId);
        List<Application__c> applist = new List<Application__c>();
        if(canIds.size()>0){
            for(string str:canIds){
                applist.add(new Application__c(Mandate__c =assId,Contact__c=str));
            }    
        }
        if(applist.size() > 0){
            system.debug(applist);
            insert applist;
        }
        return 'Success';   
    }
    @AuraEnabled
    public static String insertSelfAssQues(List<string> Questions,String assId) {
        system.debug('Questions'+Questions+'Ass-Id'+assId);
        List<Self_Assesment__c> selfAssList = new List<Self_Assesment__c>();
        if(Questions.size()>0){
            for(string str:Questions){
                selfAssList.add(new Self_Assesment__c(Assignment_Research__c =assId,English__c=str));
            }    
        }
        if(selfAssList.size() > 0){
            system.debug(selfAssList);
            insert selfAssList;
        }
        return 'Success';   
    }
    @AuraEnabled
    public static String insertOnePagerQues(List<string> Questions,String assId) {
        system.debug('Questions'+Questions+'Ass-Id'+assId);
        List<One_Pager__c> onePagerList = new List<One_Pager__c>();
        if(Questions.size()>0){
            for(string str:Questions){
                onePagerList.add(new One_Pager__c(Mandate__c  =assId,English__c=str));
            }    
        }
        if(onePagerList.size() > 0){
            system.debug(onePagerList);
            insert onePagerList;
        }
        return 'Success';   
    }
}