global Without Sharing class updateSelfAssessmentCtrl{
   
   @AuraEnabled
    public static List<Self_Assesment_Response__c> updateSelfAssessmentOfCandidate(List<Self_Assesment_Response__c> UpdatedResponse,String appid,Boolean isSave){
        try {
            System.debug(UpdatedResponse);
            System.debug(appid);
            System.debug(isSave);
            application__c man = [select Mandate__c from application__c where id =:appid];
            String Man_id = man.Mandate__c;
            List<Self_Assesment__c> selfAssList = [SELECT French__c,Id,Name,English__c FROM Self_Assesment__c WHERE Assignment_Research__c =:Man_id];
            
            
            Date SelfAssesment_date = system.today();
            
            system.debug('date'+SelfAssesment_date);
            
            if(isSave == true)
            {
                update new application__c(id = appid,Self_Assessment_Date__c = SelfAssesment_date);
            }
            else{
                update new application__c(id = appid,Self_Assesment_Status__c = 'Submitted',Self_Assessment_Date__c = SelfAssesment_date);    
            }
            
            
            List<Self_Assesment_Response__c> ListToBeUpdated = new List<Self_Assesment_Response__c>();
            List<Self_Assesment_Response__c> ListToBeInserted = new List<Self_Assesment_Response__c>();
            
            for(Integer i=0;i<UpdatedResponse.size();i++)
            {
                
                UpdatedResponse[i].Self_Assesment__c = selfAssList[i].Id;
                UpdatedResponse[i].Template_Question__c = UpdatedResponse[i].Question_name__c;
                if(UpdatedResponse[i].Id != null){
                    ListToBeUpdated.add(UpdatedResponse[i]);
                }
                else{
                    ListToBeInserted.add(UpdatedResponse[i]);
                }
            }
            if(ListToBeUpdated.size() > 0)
            {
                update ListToBeUpdated;
                return ListToBeUpdated;
            }
            if(ListToBeInserted.size() > 0)
            {
                system.debug('ListToBeInserted'+ListToBeInserted);
                insert ListToBeInserted;
                return ListToBeInserted;
            }
            return null;
            //return 'success';
        } 
        catch (Exception e) {
            System.debug('Error:::'+e.getMessage()+' AT '+e.getLineNumber());
            return null;
        }
    }
    @AuraEnabled
    public static String Generate_Self_Ass(String appid)
    {
        try{
            system.debug('appid'+appid);
            Application__c app = [select Self_Assesment_Link__c,Self_Assesment_Fr_Link__c,Language__c from application__c where id =:appid];
            system.debug('Language'+app.Language__c);
            if(app.Language__c.toLowerCase() == 'english')
            {
                string attachmentId = CongaHelperToolLightning.generateReport(app.Self_Assesment_Link__c,null,null,null,null);       
                system.debug('attachmentId '+attachmentId);
                return attachmentId;
                
            }   
            // else
            {
                string attachmentId = CongaHelperToolLightning.generateReport(app.Self_Assesment_Fr_Link__c,null,null,null,null);
                system.debug('attachmentId '+attachmentId);
                return attachmentId; 
            } 
            //return 'Success';//
        }catch(Exception e){
            System.debug('@@@@@'+e.getLineNumber()+'@@@'+e.getMessage());
            return null;
        }
        
    }
    @AuraEnabled
    public static String viewAttachment(String parentId,String type)
    {
        try{
            System.debug('parentId::: ' + parentId);
            System.debug('type::: ' + type);
            List<Attachment> attRecList;
            if(parentId != null && type != null){
                if(type == 'View Self Assessment'){
                    attRecList = [SELECT Id,Name,Body,ParentId FROM Attachment WHERE ParentID =: parentId AND Name LIKE '%Self Assesment%' ORDER BY LastModifiedDate DESC LIMIT 1];
                }
            }
            System.debug('attRec::: ' + attRecList.size());
            return attRecList[0].Id;
        }catch(Exception e){
            System.debug('@@@@@'+e.getLineNumber()+'@@@'+e.getMessage());
            return null;
        }
        
    }
    
    @AuraEnabled
    public static string changeLanguage(String AppId){
        try{
            System.debug('conId==>'+AppId);
            
            Application__c app =[select id,Mandate__r.Language__c from Application__c where id=:AppId];
            String language = app.Mandate__r.Language__c;
            System.debug('con==>'+app);
            if(app!=null){
                return language;
            }
        }catch(Exception e){
            System.debug('Error==>'+e.getMessage()+'Line Number==>'+e.getLineNumber());
        }
        return null;
    }
    @AuraEnabled
    public static List<Self_Assesment_Response__c> genSelfAssResp(String appId){
        try{
            System.debug('conId==>'+appId);
            
            String language = updateSelfAssessmentCtrl.changeLanguage(appId);
            
            application__c man = [select Mandate__c from application__c where id =:appId];
            String Man_id = man.Mandate__c;
            system.debug('man.id'+Man_id);
            
            List<Self_Assesment_Response__c> selfAssResList = new List<Self_Assesment_Response__c>();
            List<Self_Assesment_Response__c> selfAssResNewList = new List<Self_Assesment_Response__c>();
            List<Self_Assesment__c> selfAssList = [SELECT French__c,Id,Name,English__c FROM Self_Assesment__c WHERE Assignment_Research__c =:Man_id];
            
            selfAssResList = [SELECT Response__c,Id,Name,Question_name__c FROM Self_Assesment_Response__c WHERE Related_Assignment__c =:appId];
            
            System.debug('con==>'+selfAssList);
            
            
            if(selfAssResList.size() > 0){
                system.debug('We are here in greater Response');
                return selfAssResList;
            }
            else{
                for(Self_Assesment__c sa : selfAssList)
                {
                    system.debug('We are here in smaller Response');
                    Self_Assesment_Response__c sar = new Self_Assesment_Response__c();
                    if(language == 'French')
                    {
                        sar.Question_name__c = sa.French__c;    
                    }
                    else
                    {
                        sar.Question_name__c = sa.English__c;
                    }
                    sar.Related_Assignment__c = appId;
                    sar.Response__c = '';
                    sar.Self_Assesment__c  = sa.Id;
                    selfAssResNewList.add(sar);
                }
                system.debug('selfAssResNewList'+selfAssResNewList);
                
                return selfAssResNewList;
            }
            
        }catch(Exception e)
        {
            System.debug('Error==>'+e.getMessage()+'Line Number==>'+e.getLineNumber());
            return null;
        }
        
    }
    @AuraEnabled
    public static List<String> Getmainpagecontent(String appId){
        
        String Content = '';
        String Language = [SELECT Mandate__r.Language__c FROM Application__c where id =:appId].Mandate__r.Language__c;
        system.debug('Language'+Language);
        List<String> DataList = new List<String>();
        
        List<Self_Assesment_mainpage_content__mdt> contentData = [SELECT Content__c,Label FROM Self_Assesment_mainpage_content__mdt];
        
        for(Self_Assesment_mainpage_content__mdt td :contentData ){
            if(td.Label == Language)
            {
                Content = td.Content__c;   
            }
            
        }
        DataList.add(Content);
        DataList.add(Language);
        return DataList; 
    }
    @AuraEnabled
    public static SelfAppRecords GetAssignDetails(String appId){
        system.debug('assnvalues'+appId);
        
        Decimal Length_Of_Self_Ass = [SELECT Length_Of_Self_Ass__c FROM Length_self_Ass__c].Length_Of_Self_Ass__c;
        
        List<Application__c> assnvalues = [SELECT Mandate__r.Name ,Mandate__r.Language__c,Current_Company_French__c FROM Application__c where id =:appId];
        system.debug('assnvalues'+assnvalues);
        
        SelfAppRecords sar = new SelfAppRecords(assnvalues,Length_Of_Self_Ass);
        
        return sar; 
    }
    public class SelfAppRecords {
        @AuraEnabled public decimal lenght_Of_self_Ass;
        @AuraEnabled public List<Application__c> rec;
        public SelfAppRecords(List<Application__c> rec,decimal lenght_Of_self_Ass){
            
            this.rec = rec;
            this.lenght_Of_self_Ass = lenght_Of_self_Ass;
        }
        
    }
    
}