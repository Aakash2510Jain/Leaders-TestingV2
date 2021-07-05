public class BiographyDataEntryLightning {
    
    
    @AuraEnabled
    public static String getProfileInfo()
    {
        User userDetails =[SELECT Id, Name, Email, Profile.Name, UserRole.Name FROM User where Id=:userinfo.getUserId()];
        return userDetails.Profile.Name;
    }
    @AuraEnabled
    public static recordtypeWrap getRecordTypeInfo(String conId)
    {   String attId='';
     try{
         attId=[SELECT Id FROM Attachment WHERE ParentId = : conId AND Name LIKE 'CV%' ORDER BY CreatedDate DESC limit 1].Id;
     }catch(Exception e){
         attId = null;
     }
     return new recordtypeWrap(attId!=null?attId:'',BiographyHelper.getBiographyRecordTypeIdByName());
    }
    @AuraEnabled 
    public static List<Work_Experience__c> getBiograpgyRecords(String peopleId)
    {
        return  [Select Title__c, Title_FR__c, Start_Year__c, 
                 Name, Id, Company__c,End_Year__c, Current_del__c, 
                 Contact__c, Company_Name__c ,
                 Company_Name_French__c, Add_company_description__c, Location__c , RecordTypeId,RecordType.DeveloperName,Verified__c, 
                 Reporting_Structure__c,Comments__c,Reason_for_Leaving__c,Hide_Reason_In_Template__c From Work_Experience__c
                 Where Contact__c = :peopleId AND Company__c != null
                 order by recordtypeId, Start_Year__c desc];
    }
    @AuraEnabled
    public static string updateContactRecord(Contact conRecord)
    {
        System.debug('@@@@@'+conRecord);
        try{
            update conRecord;
            return 'Contact record has been saved successfully';
        }catch(Exception e){
            System.debug('Error: '+e.getMessage()+' AT '+e.getLineNumber());
            return 'Some error occured while saving biography data';
        }
    }
    @AuraEnabled
    public static String Generate_Self_Ass(String conid)
    {
        system.debug('conid'+conid);
        Contact con = [select Self_Assesment_Link__c,Self_Assesment_Fr_Link__c,Language__c from contact where id =:conid];
        system.debug('Language'+con.Language__c);
        if(con.Language__c.toLowerCase() == 'english')
        {
            string attachmentId = CongaHelperToolLightning.generateReport(con.Self_Assesment_Link__c,null,null,null,null);       
            return attachmentId; 
        }   
        else
        {
            string attachmentId = CongaHelperToolLightning.generateReport(con.Self_Assesment_Fr_Link__c,null,null,null,null);
            return attachmentId; 
        }
    }
     @AuraEnabled
    public static String Generate_One_Pager(String conid)
    {
        system.debug('conid'+conid);
        Contact con = [select Self_Assesment_Link__c,Self_Assesment_Fr_Link__c,Language__c from contact where id =:conid];
        system.debug('Language'+con.Language__c);
        if(con.Language__c.toLowerCase() == 'english')
        {
            string attachmentId = CongaHelperToolLightning.generateReport(con.Self_Assesment_Link__c,null,null,null,null);       
            return attachmentId; 
        }   
        else
        {
            string attachmentId = CongaHelperToolLightning.generateReport(con.Self_Assesment_Fr_Link__c,null,null,null,null);
            return attachmentId; 
        }
    }
    @AuraEnabled
    public static Contact getContactData(String recordId)
    {
        try{
            return [Select Id,Key_Accomplishments__c,Additional_Comments__c ,Areas_for_Development__c,Experience_Gaps__c,Unique_Characteristics__c,Personality_and_Image__c,Candidate_Motivation__c,Relevant_Experience__c,Compensation__c,Availability__c,relocation__c,Job_Search__c,Leadership_Qualities__c,Technical_Skills__c,Fit__c,Summary_and_Recommendations__c from Contact where Id=:recordid];
        }catch(Exception e){
            System.debug('Error: '+e.getMessage()+' AT '+e.getLineNumber());
            return null;
        }
    }
    @AuraEnabled
    public static void upsertBiography(List<Work_Experience__c> bioList,List<String> toBeDeletedList)
    {
        try{
            System.debug('@@@@@'+bioList);
            System.debug('@@@@@'+toBeDeletedList);
            if(!bioList.isEmpty()){
                upsert bioList;
                createOnePagerOrBioDocs(bioList[0].Contact__c,'BIO','english');
                createOnePagerOrBioDocs(bioList[0].Contact__c,'LONGFORM','english');
                update(new Contact(id=bioList[0].Contact__c,Has_Bio__c = true));
            }
            if(!toBeDeletedList.isEmpty()) Database.delete(toBeDeletedList,false);
        }Catch(Exception e){
            System.debug('@@@@@'+e.getMessage());
        }
        
         
            
        
    }
    @AuraEnabled
    @future(callout=true)
    public static void createOnePagerOrBioDocs(String conId,string docType,String language)
    {
        peoplePageButtonsController.createOnePagerOrBioDocs(conId,docType,language);
        update(new Contact(id=conId,Has_Bio__c = true));
    }
    public class recordtypeWrap
    {
        @AuraEnabled
        public String attId;
        @AuraEnabled
        public Map<String,Id> recordTypeInfo;
        
        public recordtypeWrap(String attId,Map<String,Id> recordTypeInfo){
            this.attId = attId;
            this.recordTypeInfo = recordTypeInfo;
        }
    }
}