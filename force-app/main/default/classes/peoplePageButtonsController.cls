public class peoplePageButtonsController {
    
    @AuraEnabled 
    public static void deleteContact(String recId)
    {
        system.debug('In controller deleteContact method');
        List<Contact> delcon = [select Id from Contact where id=: recId];
        delete delcon;
        
    }
     @AuraEnabled 
    public static List<String> getAppDetails(String recId)
    {
        system.debug('In controller deleteContact method');
        List<Application__c> AppDet = [SELECT Id FROM Application__c WHERE Contact__c =: recId];
        List<String> appId = new List<String>();
        for(Application__c app :AppDet )
        {
            appId.add(app.Id);
        }
        system.debug('appId'+appId);
        return appId;
    }
    @AuraEnabled 
    public static Contact getContactDetails(String recId){
        try{
            Contact conRecord = [select Id from Contact where id=: recId Limit 1];
            return conRecord;
        }catch(Exception e){
            System.debug('@@@@@'+e.getLineNumber()+'@@@'+e.getMessage());
            return null;
        }
    }
    @AuraEnabled 
    public static List<ConDetailsWrapper> getApplicationDetails(String recId)
    {
        
        List<ConDetailsWrapper> ConData = new List<ConDetailsWrapper>();
        
        try
        {
            List<Application__C> getdata = [select Mandate__r.Assignment_Status__c from Application__c where Contact__c =: recId order by CreatedDate desc];
            
            if( getdata.size() > 0 )
            {
                for(List<Application__C> aap : [select Id, Name, Mandate__c,Mandate_Id__c ,Contact__r.Email, Mandate__r.Name,Mandate__r.Assignment_Status__c, Client_Company__c,Status_Summary_Line__c from Application__c where Contact__c =: recId order by CreatedDate desc] ) 
                {
                    
                    for (Integer i = 0; i < aap.size(); i++) 
                    {
                        
                        system.debug('con-id'+aap[i].Contact__c);
                        system.debug('con-id'+aap[i].Mandate__c);
                        
                        ConDetailsWrapper conwrap = new ConDetailsWrapper(aap[i].id,aap[i].Mandate__c,aap[i].Contact__c,aap[i].Name,aap[i].Contact__r.Email,aap[i].Status_Summary_Line__c); 
                        
                        ConData.add(conwrap);
                    }
                }
                system.debug('The list is '+ConData);
                return ConData;
                
            }
            else
            {
                for(Contact con  : [select Id,AccountId , Name,Email,Status_Summary_Line__c from Contact where id =: recId order by CreatedDate desc])
                {
                    ConDetailsWrapper conwrap = new ConDetailsWrapper(con.AccountId,null,con.Id,con.Name,con.Email,con.Status_Summary_Line__c);
                    
                    ConData.add(conwrap);
                }
                system.debug('The list is '+ConData);
                return ConData;
            }
            
        }
        catch(Exception e)
        {
            System.debug('@@@@@'+e.getLineNumber()+'@@@'+e.getMessage());
            return null;
        }
    }
    @AuraEnabled 
    public static String createOnePagerOrBioDocs(String conId,string docType,String language){
        try{
            if(conId != null && conId != ''){
                
                Contact conRecord 			= [select Id,Language__c,Additional_Comments_Link__c,One_Pager_Template_Lightning_FR__c,One_Pager_Template_Lightning_EN__c,candidate_bio_wo_comment_En__c,candidate_bio_wo_comment_Fr__c,Additional_Comments__c,New_Long_Form_FrenchTemplate__c,New_Long_Form_English_Template__c,Candidate_Long_Form_English_Lightning__c,Candidate_Biography_Template_Lightning__c,Candidate_Biography_Template_Light_EN__c,Candidate_Biography_Template_Light_FR__c,One_Pager_Conga_Light_Link__c,One_Pager_Template_FR__c,One_Pager_Template_EN__c,Candidate_Biography_Conga_Light_Link__c,Candidate_Biography_Template_FR__c,Candidate_Biography_Template_EN__c from Contact where id=: conId Limit 1];
                
                string attachmentId 		= '';
                /*if(docType =='ONE_PAGER')
                {
                    
                    //attachmentId 				= CongaHelperToolLightning.generateReport(IdentificationReportURLManagerLightning.getOnePagerURL(conRecord, conRecord.Language__c ),null,null,null,null);
                    //return attachmentId;
                }else */
                
                if(docType =='BIO')
                {
                    attachmentId 				= CongaHelperToolLightning.generateReport(IdentificationReportURLManagerLightning.getCandidateBiographyURL(conRecord, conRecord.Language__c),null,null,null,null);
                    return attachmentId;
                }else if(docType =='LONGFORM')
                {
                    attachmentId 				= CongaHelperToolLightning.generateReport(IdentificationReportURLManagerLightning.getCandidateLongForm(conRecord, conRecord.Language__c),null,null,null,null);
                    return attachmentId;
                }
                else if(docType =='DisplayTemplates')
                {
                    //attachmentId 				= CongaHelperToolLightning.generateReport(IdentificationReportURLManagerLightning.getTemplate(conRecord, conRecord.Language__c),null,null,null,null);
                    //return attachmentId;
                }
            }
            return '';
            
        }catch(Exception e){
            System.debug('@@@@@'+e.getLineNumber()+'@@@'+e.getMessage());
            return '';
        }
    }
    //Newly Added
    @AuraEnabled
    public static String viewAttachment(String parentId,String type)
    {
        try{
            System.debug('parentId::: ' + parentId);
            System.debug('type::: ' + type);
            List<Attachment> attRecList;
            if(parentId != null && type != null){
                if(type == 'View Bio'){
                    attRecList = [SELECT Id,Name,Body,ParentId FROM Attachment WHERE ParentID =: parentId AND Name LIKE '%Candidate Biography%' ORDER BY LastModifiedDate DESC LIMIT 1];
                }
                else if(type == 'View One Pager'){
                    attRecList = [SELECT Id,Name,Body,ParentId FROM Attachment WHERE ParentID =: parentId AND Name LIKE '%One Pa%' ORDER BY LastModifiedDate DESC LIMIT 1];
                }
                
                else if(type == 'View Self Assessment'){
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
    public static String updateDocType(String mandateId,String docType){
        try{
            Mandate__c mandateRec = new Mandate__c(Id=mandateId,Document_Type__c=docType);
            update mandateRec;
            return 'Record Updated Sucessfully';
        }catch(Exception e){
            System.debug('@@@@@'+e.getLineNumber()+'@@@'+e.getMessage());
            return e.getMessage();
        }
        
    }
    @AuraEnabled
    public static String sendSelfAssessmentLink(String recordId){
        
        Site mySite = [select Id from Site where Name = 'SelfAssessment'];
        SiteDetail selfAssessmentSite = [select SecureURL from SiteDetail where DurableId = :mySite.Id];
        System.debug(selfAssessmentSite.SecureURL);
        
        Contact conRecord 			= [select Id,Email,FirstName,LastName from Contact where id=: recordId Limit 1];
        
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        string[] to = new string[] {conRecord.Email};
            
            email.setToAddresses(to);
        email.setSubject('Self Assessment Link');
        
        email.setHtmlBody('Hi '+conRecord.FirstName+' '+conRecord.LastName+',<br/><br/>Please Click Below link to fill your self assessment. '+'<br/><br/><a href="'+selfAssessmentSite.SecureURL+'?Id='+recordId+'" target="_blank">Click here</a>');
        
        try
        {
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
            return 'sucess';
        }
        catch(exception e)
        {
            System.debug('@@@@@'+e.getLineNumber()+'@@@'+e.getMessage());
            return e.getMessage();
        }
    }    
    public class ConDetailsWrapper{
        @AuraEnabled
        public Id manId {get;set;}
        @AuraEnabled
        public String Name {get;set;}
        @AuraEnabled
        public String Email {get;set;}
        @AuraEnabled
        public String StatusSummaryLine {get;set;}
        @AuraEnabled
        public Id canId {get;set;}
        @AuraEnabled
        public Id aapId {get;set;} 
        
        public  ConDetailsWrapper(Id aapId,Id manId,Id canId, String Name,String Email,String StatusSummaryLine)
        {   
            this.aapId = aapId;
            this.manId =  manId;
            this.canId =  canId;
            this.Name =  Name;
            this.Email =  Email;
            this.StatusSummaryLine =  StatusSummaryLine;
           
        }
        
    }
    @AuraEnabled
    public static List<CanidateDetailsWrapper> getCandidateAttWrapper(String recordId){
        
        try{
            List<CanidateDetailsWrapper> canWrapList = new List<CanidateDetailsWrapper>();
            
            if(recordId != null){
                
                List<Application__c> canList = [Select Id,name , Self_Assessment_Date__c ,Mandate__c  ,Client_Company__c,Mandate__r.Name, contact__r.Name,contact__c,(Select id,Name from Attachments where name LIKE '%Self Assesment%' order by createdDate desc) from Application__c where Contact__c=:recordId];
                
                if(!canList.isEmpty()){
                    for(Application__c canRec:canList){
                        //System.debug('@@@@'+canRec.Attachments[0].Id);
                        if(!canRec.Attachments.isEmpty()){
                            canWrapList.add(new CanidateDetailsWrapper(canRec.contact__r.Name,canRec.Mandate__r.Name,canRec.Client_Company__c,canRec.Attachments[0].Id,canRec.Self_Assessment_Date__c,canRec));
                        }else{
                            canWrapList.add(new CanidateDetailsWrapper(canRec.contact__r.Name,canRec.Mandate__r.Name,canRec.Client_Company__c,'',canRec.Self_Assessment_Date__c,canRec));
                        }
                    }
                }
            }
            System.debug('canWrapList'+canWrapList);
            return canWrapList;
        }catch(Exception e){
            throw new AuraException(e.getMessage()+' AT '+e.getLineNumber());
        }
        
    }
    public class CanidateDetailsWrapper{
        @AuraEnabled
        public String contactName {get;set;}
        @AuraEnabled
        public String mandateName {get;set;}
        @AuraEnabled
        public String companyName {get;set;}        
        @AuraEnabled
        public String attId {get;set;}       
         @AuraEnabled
        public Date selfAssDAte {get;set;}
        @AuraEnabled
        public Application__c candidateRec {get;set;}       
     
      
        public  CanidateDetailsWrapper(String contactName,String mandateName, String companyName,String attId,Date selfAssDAte,Application__c candidateRec){            
            this.contactName 		=  contactName;
            this.mandateName 		=  mandateName;
            this.companyName 		=  companyName;
            this.candidateRec 		=  candidateRec;
            this.selfAssDAte        = selfAssDAte;
            this.selfAssDAte        = selfAssDAte;
        }
    }
   
}