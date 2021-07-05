/**
* Created by on 07-03-2019.
*/

public with sharing class AddApplicationToAssignmentLightning {
    
    public static String emailContent = '';
    public static String emailSubject = '';
    @AuraEnabled 
    public static map<string,String> get_Attach_ids(String condid,String mandateId)
    {
        String recordId = [SELECT ID FROM Application__c WHERE Contact__c  =:condid AND Mandate__c =:mandateId].ID;
        String ConName = [SELECT Name,Language__c FROM contact WHERE ID =:condid ].Name;
        String ConLanguage = [SELECT Language__c FROM contact WHERE ID =:condid ].Language__c;
        map<string,String> AttIdsWithName = new map<string,String>(); 
        List<String> AttIds = new List<String>();
        try{
            
            String OpId;
            String AttId;
            String SelfAssId;
            String LetterId;
            String RefId;
            String PsyId;
            String BioId;
            String CVId;
            String BoardCVId;
            String OnboardingId;
            
            Attachment[] attfromCon = [SELECT Id,Name FROM Attachment WHERE ParentId = :condid];
            Attachment[] attfromApp = [SELECT Id,Name FROM Attachment WHERE ParentId = :recordId];
            if(attfromCon.size() > 0){
                for(Attachment str :attfromCon){
                    if(str.Name.contains('One Pa')){
                        AttIdsWithName.put('OnePagerId',str.ID);
                    }
                    else if(str.Name.contains('Candidate Intro')){
                        AttIdsWithName.put('LetterId',str.ID);
                    }
                    else if(str.Name.contains('Self Ass')){
                        AttIdsWithName.put('SelfAssId',str.ID);
                    }
                    else if(str.Name.contains('Refe')){
                        AttIdsWithName.put('RefId',str.ID);
                    }
                    else if(str.Name.contains('Psy Te')){
                        AttIdsWithName.put('PsyId',str.ID);
                    }
                    else if(str.Name.contains('CV')){
                        AttIdsWithName.put('CVId',str.ID);
                    }
                    else if(str.Name.contains('Board C')){
                        AttIdsWithName.put('BoardCVId',str.ID);
                    }
                    else if(str.Name.contains('Bio')){
                        AttIdsWithName.put('BioId',str.ID);
                    }
                    else if(str.Name.contains('OnBoar')){
                        AttIdsWithName.put('OnboardingId',str.ID);
                    } 
                }
            }
            system.debug('AttIdsWithName before the applications'+AttIdsWithName);
            if(attfromApp.size() > 0){
                for(Attachment str :attfromApp){
                    if(!AttIdsWithName.containsKey('OnePagerId')){
                        if(str.Name.contains('One Pa')){
                            AttIdsWithName.put('OnePagerId',str.ID);
                        }
                    }
                    if(!AttIdsWithName.containsKey('SelfAssId')){
                        if(str.Name.contains('Self Ass')){
                            AttIdsWithName.put('SelfAssId',str.ID);
                        }
                    }
                    if(!AttIdsWithName.containsKey('BioId')){
                        if(str.Name.contains('Bio')){
                            AttIdsWithName.put('BioId',str.ID);
                        }
                    }
                }
            }
            system.debug('AttIdsWithName after the applications'+AttIdsWithName);
            
            
            
            EmailTemplate et =  [select Name, Subject, Body from EmailTemplate where name = 'Candidate File'];
            
            String TemplateBody = et.Body;
            String TemplateSubject = et.Subject;
            
            if(ConLanguage == 'English'){
                TemplateBody =  TemplateBody.replace('{!Contact.Name}',ConName);
                TemplateBody =  TemplateBody.replace('Hello ,','Hello ,<br/>' );
            }else{
                //TemplateBody =  TemplateBody.replace('{!Contact.Name}',ConName);
                TemplateBody =  'Bonjour <br/>SVP, veuillez prendre recevoir le(s)document(s) '+ConName+', tel que nous avons discuté. ';
            }
            
            //TemplateBody =  TemplateBody.replace('{!Contact.Name}',ConName);
            //TemplateBody =  TemplateBody.replace('Hello ,','Hello ,<br/>' );
            TemplateSubject = TemplateSubject.replace('{!Contact.Name}',ConName);
            AttIdsWithName.put('TemplateSubject',TemplateSubject);
            AttIdsWithName.put('TemplateData',TemplateBody);
            system.debug('AttIdsWithName'+AttIdsWithName);
            return AttIdsWithName;
        }
        catch(QueryException e){
            return null;
        }
    }
    @AuraEnabled 
    Public Static void AddingAttachementsToEmail(String MailId,String SUbject,String Body,List<ID> attachmentIds){
        system.debug('attachmentIds'+attachmentIds);
        system.debug('attachmentIds'+MailId);
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.setToAddresses(new String[] { MailId });
        List<Attachment> files = [SELECT Name, Body, ContentType FROM Attachment WHERE Id IN :attachmentIds];
        List<Messaging.EmailFileAttachment> attachments = new List<Messaging.EmailFileAttachment>();
        for (Attachment file: files) {
            Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
            if(file.Name.contains('.pdf')){
                efa.setFileName(file.Name);    
            }
            else{
                efa.setFileName(file.Name+'.pdf'); 
            }
            efa.setBody(file.Body);
            efa.setContentType(file.ContentType);
            attachments.add(efa);
        }
        message.setFileAttachments(attachments);
        message.setSubject(SUbject);
        message.setHtmlBody(Body);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { message });
    }
    @AuraEnabled
    public static List<CommonWrapperClass.DisplayAppRecords> getCandidateDummyData(List<String> canIds)
    {
        List<CommonWrapperClass.DisplayAppRecords> appList = new List<CommonWrapperClass.DisplayAppRecords>();
        
        for(Application__c appRec:[Select Id,Name,Contact__c  from Application__c limit 10]){
            appList.add(new CommonWrapperClass.DisplayAppRecords(false,appRec));
        }
        return appList;
    }
    @AuraEnabled
    public static String getEmailData(List<String> canIds)
    {
        String canWithoutEmail = '';
        for(Application__c appRec:[Select Id,Contact__r.Name,Contact__r.Email  from Application__c where Id IN:canIds] )
        { 
            if(appRec.Contact__r.Email == null)
            {
                canWithoutEmail += appRec.Contact__r.Name+',';
            }
        }
        system.debug('canWithoutEmail'+canWithoutEmail);
        return canWithoutEmail;
    }
    @AuraEnabled
    public static Boolean getValueofLocationCheckbox(String Mandateid)
    {
        return [Select Report_With_Location__c from Mandate__c where Id =:Mandateid Limit 1].Report_With_Location__c;
    }
    @AuraEnabled
    public static List<String> getSelfAssStatus(List<String> canIds)
    {
        List<String> alreadySentCandidates = new List<String>(); 
        for(Application__c canRec:[Select Id,Self_Assesment_Status__c,Contact__r.Name from Application__c where Id IN:canIds]){
            if(canRec.Self_Assesment_Status__c != null ){
                alreadySentCandidates.add(canRec.Contact__r.Name);
            }
        }
        return alreadySentCandidates;
    }
    @AuraEnabled
    public static user getTeamOfUser()
    {
        id userid = UserInfo.getUserId();
        system.debug('The userid of the individual is'+userid);
        return [Select id,name ,Team__c from user where id =:userid	];
    }
    @AuraEnabled
    public static String createCandidateRec(Application__c appRecord, String contactID,String location){
        try {
            System.debug('appRec'+appRecord);
            appRecord.Contact__c = contactID;
            insert appRecord;
            insert new Meeting_Note__c(Contact__c=contactID, Candidate_Assigned__c =appRecord.Id, Status_Summary_Line__c =appRecord.Status_Summary_Line__c,Description__c=appRecord.Description__c,Most_Recent__c=true );
            return 'success';
        } catch (Exception e) {
            System.debug('Error:::'+e.getMessage()+' AT '+e.getLineNumber());
            return e.getMessage();
        }
    }
    @AuraEnabled
    public static String createCandidateRecForContact(String assignmentId, List<String> contactID,String ssl,String description,String origin){
        try {
            List<Application__c> appRecordList = new List<Application__c>();
            for(String conId:contactID){
                Application__c appRecord = new Application__c();
                System.debug('appRec'+appRecord);
                appRecord.Contact__c = conId;
                appRecord.Mandate__c = assignmentId;
                appRecord.Status_Summary_Line__c = ssl;
                appRecord.Description__c = description;
                appRecord.Origin__c = origin;
                appRecordList.add(appRecord);
            }
            if(!appRecordList.isEmpty()){
                insert appRecordList;
            }
            if(!appRecordList.isEmpty()){
                List<Meeting_Note__c> meetingNoteList = new List<Meeting_Note__c>();
                for(Application__c appRec:appRecordList){
                    meetingNoteList.add(new Meeting_Note__c(Contact__c=appRec.Contact__c, Candidate_Assigned__c =appRec.Id,Description__c=appRec.Description__c, Status_Summary_Line__c =appRec.Status_Summary_Line__c,Most_Recent__c=true ));
                }
                if(!meetingNoteList.isEmpty()){
                    insert meetingNoteList;
                }
            }
            return appRecordList[0].id;
        } catch (Exception e) {
            System.debug('Error:::'+e.getMessage()+' AT '+e.getLineNumber());
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled
    public static List<String> getPicklistValues(String objectType, String selectedField){
        List<String> pickListValuesList = new List<String>();
        Schema.SObjectType convertToObj = Schema.getGlobalDescribe().get(objectType);
        Schema.DescribeSObjectResult res = convertToObj.getDescribe();
        Schema.DescribeFieldResult fieldResult = res.fields.getMap().get(selectedField).getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            pickListValuesList.add(pickListVal.getLabel());
        }
        return pickListValuesList;
    }
    
    @AuraEnabled
    public static Map<String,Integer> saveAppData(String appListString,String mandateId,String status,Boolean copyNotes,List<Application__c> AppIds){
        System.debug('--->copyNotes '+copyNotes);
        System.debug('---> AppIds'+AppIds);
        List<Object> appList = (List<Object>) JSON.deserializeUntyped(appListString);
        Set<String> existingContacts = new Set<String>();
        System.debug('---> '+appList[0]);
        List<Application__c> existingApplicationsForGivenMandate = [Select Id,Name,Contact__c from Application__c where Mandate__c=:mandateId];
        
        List<Application__c> notesFromApp  = [SELECT Id,Contact__c,(select Id,Description__c from Meeting_Notes__r) FROM Application__c where id in:AppIds];
        Map<id,List<Meeting_Note__c>> meetingNotesfromApp = new Map<id,List<Meeting_Note__c>>();
        
        for(Application__c app :notesFromApp ){
            meetingNotesfromApp.put(app.Contact__c,app.Meeting_Notes__r);
        }
        system.debug('meetingNotesfromApp'+meetingNotesfromApp);
        
        for(Application__c appRec:existingApplicationsForGivenMandate){
            existingContacts.add(appRec.Contact__c);
        }
        
        Integer success = 0;
        Integer fail    = 0;
        Map<String,Integer> mapToReturn = new Map<String, Integer>();
        List<Application__c> appsToBeInserted =     new List<Application__c>();
        System.debug('---> '+existingContacts);
        Savepoint sp = Database.setSavepoint();
        
        try {
            Map<String,Object> appObj;
            for(Object appRec:appList){
                appObj = (Map<String,Object>)appRec;
                if(appObj.containsKey('isSelected') && ((Boolean)appObj.get('isSelected')) == true){
                    if(!existingContacts.contains((String)appObj.get('Contact__c'))){
                        
                        Application__c App = new Application__c();
                        App.Contact__c = (Id)appObj.get('Contact__c');
                        App.Mandate__c = mandateId;
                        App.Source_Status__c = 'New';
                        system.debug('App'+App);
                        appsToBeInserted.add(App);
                    }else{
                        system.debug('App has same contact ');
                        fail++;
                    }
                }
            }
            for(Application__c app : appsToBeInserted){
                system.debug(meetingNotesfromApp.get(app.Contact__c));
            }
            System.debug('---> '+appsToBeInserted);
            if(!appsToBeInserted.isEmpty()) {
                system.debug('App'+appsToBeInserted);
                insert appsToBeInserted;
                success = appsToBeInserted.size();
            }
            List<Meeting_Note__c> leadersNotes = new List<Meeting_Note__c>();
            if(copyNotes == false){
                for(Application__c app : appsToBeInserted){
                    system.debug(meetingNotesfromApp.get(app.Contact__c));
                    leadersNotes.add(new Meeting_Note__c(Contact__c=app.Contact__c, Candidate_Assigned__c =app.Id, Status_Summary_Line__c =status ));
                }    
            }else{
                for(Application__c app : appsToBeInserted){
                    system.debug(meetingNotesfromApp.get(app.Contact__c));
                    for(Meeting_Note__c mn :meetingNotesfromApp.get(app.Contact__c)){
                        leadersNotes.add(new Meeting_Note__c(Contact__c=app.Contact__c, Candidate_Assigned__c =app.Id, Status_Summary_Line__c =status,Description__C = mn.Description__c ));
                    }
                }
            }
            
            if(!leadersNotes.isEmpty())
                Database.insert(leadersNotes, false);
            mapToReturn.put('SUCCESS',success);
            mapToReturn.put('EXISTING',fail);
            System.debug(appList);
            return mapToReturn;
        } 
        catch (Exception e) {
            Database.rollback(sp);    
            System.debug('Error :'+e.getMessage() +' AT '+e.getLineNumber());
            return new Map<String,Integer>{'Error :'+e.getMessage() +' AT '+e.getLineNumber()=>0};
                }
    }
    @AuraEnabled
    public static List<EmailTemplate> fetchEmailTemplate() {
        
        return SendEmailHelper.fetchEmailTemplate();
    }
    @AuraEnabled
    public static EmailConstants.TemplateForm renderTemplate(string templateId, string whoId) {
        
        Messaging.SingleEmailMessage em = Messaging.renderStoredEmailTemplate(templateId,whoId, null);
        EmailConstants.TemplateForm fm = new EmailConstants.TemplateForm(em.getSubject(), em.getHtmlBody(), em.getFileAttachments());
        
        return fm;
    }
    @AuraEnabled
    public static String sendEmail(String Language, String emailSubject, String emailContent,List<String> attIds,String mandateId,List<String> candidatesIds, Mandate__c mandate,String templateId){
        
        try{
            List<Id> candidateIds                       = new List<Id>();
            List<Attachment> attachDocs                 = new List<Attachment>();
            List<Contact> ConList                       = new List<Contact>();
            List<Application__c> candidatesList         = new List<Application__c>();
            Set<String> candidateEmails                 = new Set<String>();
            List<Application__c> appToBeUpdate = new List<Application__c>();
            system.debug('candidatesIds'+candidatesIds);
            
            candidatesList                              = [Select Id,Name,Contact__r.Email,Contact__r.FirstName,Contact__r.Lastname ,Current_Title__c,Current_Company_EN__c,First_Name__c,Last_Name__c,(Select Id,Name from Self_Assesment_Responses__r) from Application__c where ID IN:candidatesIds];
            
            List<Self_Assesment_Response__c> selfAssList=new List<Self_Assesment_Response__c>();
            for(Application__c app:candidatesList){
                for(Self_Assesment_Response__c ass:app.Self_Assesment_Responses__r){
                    selfAssList.add(ass);
                }
            }
            if(selfAssList.size()>0){
                delete selfAssList;
                
            }
            
            if(candidatesList.size() > 0)
            {
                for(Application__c apprec:candidatesList){
                    candidateIds.add(apprec.Contact__c);
                    candidateEmails.add(apprec.Contact__r.Email);
                }
            }
            else
            {
                ConList = [select Id, Name,Email,FirstName,LastName,Status_Summary_Line__c,(Select Id from Applications__r) from Contact where id IN: candidatesIds order by CreatedDate desc];
                for(Contact conrec:ConList)
                {
                    candidateIds.add(conrec.Id);
                    candidateEmails.add(conrec.Email);
                }
                
            }
            System.debug('candidateEmails'+candidateEmails);
            system.debug('templateId'+templateId);
            if(templateId != null)
            {
                attachDocs                                  = [ SELECT Id,Name,ParentId,Body,BodyLength from Attachment where Id IN : attIds OR ParentId = :templateId]; //Added or by DeaGle 30/11/2019
            }
            system.debug('manid'+mandateId);
            if(mandateId != null)
            {
                mandate                                     = [Select Id,Name,Company__c,Company__r.Name,Send_job_description__c,Language__c  from Mandate__c where Id=:mandateId Limit 1];
            }
            setEmailBody(mandate,Language);
            system.debug(mandate);
            
            
            List<Messaging.EmailFileAttachment> attachList = new List<Messaging.EmailFileAttachment>();
            
            for(Attachment att : attachDocs){
                attachList.add(emailAttach(att));
            }
            
            List<Messaging.SingleEmailMessage> notificationEmail = new List<Messaging.SingleEmailMessage>();
            
            List<OrgWideEmailAddress> fromEmail = [Select Id from OrgWideEmailAddress where DisplayName = 'Leaders & Cie et Leaders & Co.'];
            Id fromEmailId = fromEmail.size()>0 ? fromEmail[0].Id : null;
            
            
            List<Messaging.SingleEmailMessage> mails =  new List<Messaging.SingleEmailMessage>();
            List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();
            Set<Id> contactIds = new Set<Id>();
            Map<Id, String> bodyMessageMapByContactId = new Map<Id, String>();
            Map<Id, String> subjectMessageMapByContactId = new Map<Id, String>();
            //String body = [select Id, Name, DeveloperName, Subject, Body from EmailTemplate where id=:templateId].Body;
            //Messaging.SingleEmailMessage em = Messaging.renderStoredEmailTemplate(templateId,null, null);
            //String body = em.getPlainTextBody();
            
            if(candidatesList.size() > 0)
            {
                
                for(Application__c can : candidatesList){
                    
                    String FirstName =can.Contact__r.FirstName;
                    String LastName =can.Contact__r.LastName;
                    System.debug('FirstName==>'+FirstName);
                    System.debug('LastName==>'+LastName);
                    
                    String Emaill =can.Contact__r.Email;
                    String appid = can.Contact__c;
                    String appnid = can.Id;
                    String AssnName = can.Current_Company_EN__c ;
                    String title = can.Current_Title__c;
                    
                    
                    appToBeUpdate.add(new Application__C(id = appnid,Self_Assesment_Status__c = 'Sent'));
                    
                    system.debug(':::::: CANDIDATE :::::: '+can);
                    contactIds.add(appid);
                    
                    String body = emailContent;
                    String subject = emailSubject.replace('{!Mandate__c.Name}', mandate.Name);
                    system.debug('body'+body);
                    
                    body = body.replace('{!Mandate__c.Name}', mandate.Name);
                    if(body.contains('Bonjour')){
                        body = body.replace('Bonjour', 'Bonjour '+FirstName+' '+LastName);
                    }
                    if(body.contains('Dear')){
                        body = body.replace('Dear', 'Dear  '+FirstName+' '+LastName);
                    }
                    
                    if(body.contains('SelfAssessment?Id=')){
                        body = body.replace('SelfAssessment?Id=', 'CandidateSelfAssessment?Id='+appnid+'&Language='+mandate.Language__c);
                    }
                    if(mandate.Company__c!=null){
                        body = body.replace('{!Mandate__c.Company__c}', mandate.Company__r.Name);
                    }
                    if(!String.isEmpty(FirstName)){
                        System.debug('FirstName==>'+FirstName);
                        body = body.replace('{!Application__c.First_Name__c}', FirstName);
                        body = body.replace('{!Contact.FirstName}', FirstName);
                    }else{
                        body = body.replace('{!Application__c.First_Name__c}', '');
                        body = body.replace('{!Contact.FirstName}', '');
                    }
                    
                    if(!String.isEmpty(LastName)){
                        System.debug('LastName==>'+LastName);
                        body = body.replace('{!Application__c.Last_Name__c}', LastName);
                        body = body.replace('{!Contact.LastName}', LastName);
                    }else{
                        body = body.replace('{!Application__c.Last_Name__c}', '');
                        body = body.replace('{!Contact.LastName}', '');
                    }
                    
                    
                    bodyMessageMapByContactId.put(appid,body);
                    subjectMessageMapByContactId.put(appid,subject);
                    
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    //Messaging.SingleEmailMessage mail = Messaging.renderStoredEmailTemplate('00X1k000000hfdLEAQ', '0030B000028jX7vQAE', null);
                    
                    mail.setUseSignature(false);
                    List<String> recipient = new List<String>();
                    if(Emaill != null)
                    {
                        recipient.add(Emaill);
                        
                        system.debug('recipient is'+recipient);
                        mail.setToAddresses(recipient);
                        mail.setSubject(subject);
                        System.debug('@@@@@'+body);
                        User currUser = [Select Id,Signature from User where Id=:userinfo.getuserId()];
                        string userSignature = currUser.Signature;
                        if (String.isNotBlank(userSignature))
                        {
                            userSignature = userSignature.replace('\n','<br>');
                            System.debug('@@@@'+userSignature);
                            
                        }
                        
                        if(templateId != null)
                        {
                            mail.setTemplateId(templateId);
                            //body = EncodingUtil.urlEncode(body,'UTF-8');
                            mail.setHtmlBody(body);
                            mail.setPlainTextBody(body);
                            mail.setFileAttachments(attachList);
                            system.debug('templateId'+templateId);
                            if(templateId == '00X1k0000014MygEAE' || templateId == '00X1k000001J3alEAC' )
                            {
                                mail.setUseSignature(false);  
                            }
                            else
                            {
                                mail.setUseSignature(true);
                            }
                        } 
                        else
                        {
                            mail.setHtmlBody(body);
                            mail.setPlainTextBody(body);
                            mail.setUseSignature(true);
                        }
                        
                        if(fromEmailId != null){
                            mail.setOrgWideEmailAddressId(fromEmailId);
                        }
                        
                        
                        notificationEmail.add(mail);
                    }
                }
                
            }
            else
            {
                
                for(Contact can : ConList){
                    
                    String FirstName =can.FirstName;
                    String LastName =can.LastName;
                    String Emaill =can.Email;
                    String appid = can.id;
                    
                    system.debug(':::::: CANDIDATE :::::: '+can);
                    contactIds.add(appid);
                    
                    String body = emailContent;
                    String subject = emailSubject;
                    
                    if(body.contains('Bonjour')){
                        body = body.replace('Bonjour', 'Bonjour '+FirstName+' '+LastName);
                    }
                    if(body.contains('Hello')){
                        body = body.replace('Hello', 'Hello  '+FirstName+' '+LastName);
                    }
                    
                    if(body.contains('SelfAssessment?Id=')){
                        body = body.replace('SelfAssessment?Id=', 'CandidateSelfAssessment?Id='+appid);
                    }
                    //if(mandate.Company__c!=null){
                    //  body = body.replace('{!Mandate__c.Company__c}', mandate.Company__r.Name);
                    //}
                    if(!String.isEmpty(FirstName)){
                        body = body.replace('{!Application__c.First_Name__c}', FirstName);
                        body = body.replace('{!Contact.FirstName}', FirstName);
                    }else{
                        body = body.replace('{!Application__c.First_Name__c}', '');
                        body = body.replace('{!Contact.FirstName}', '');
                    }
                    
                    if(!String.isEmpty(LastName)){
                        body = body.replace('{!Application__c.Last_Name__c}', LastName);
                        body = body.replace('{!Contact.LastName}', LastName);
                    }else{
                        body = body.replace('{!Application__c.Last_Name__c}', '');
                        body = body.replace('{!Contact.LastName}', '');
                    }
                    
                    
                    bodyMessageMapByContactId.put(appid,body);
                    subjectMessageMapByContactId.put(appid,subject);
                    
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    //Messaging.SingleEmailMessage mail = Messaging.renderStoredEmailTemplate('00X1k000000hfdLEAQ', '0030B000028jX7vQAE', null);
                    
                    mail.setUseSignature(false);
                    List<String> recipient = new List<String>();
                    if(Emaill != null)
                    {
                        recipient.add(Emaill);
                        system.debug('recipient is'+recipient);
                        mail.setToAddresses(recipient);
                        mail.setSubject(subject);
                        System.debug('@@@@@'+body);
                        User currUser = [Select Id,Signature from User where Id=:userinfo.getuserId()];
                        string userSignature = currUser.Signature;
                        if (String.isNotBlank(userSignature)) {
                            userSignature = userSignature.replace('\n','<br>');
                            System.debug('@@@@'+userSignature);
                            // body += userSignature;
                        }
                        
                        if(templateId != null)
                        {
                            mail.setTemplateId(templateId);
                            //body = EncodingUtil.urlEncode(body,'UTF-8');
                            mail.setHtmlBody(body);
                            mail.setPlainTextBody(body);
                            mail.setFileAttachments(attachList);
                            mail.setUseSignature(true);
                        }
                        else
                        {
                            mail.setHtmlBody(body);
                            mail.setPlainTextBody(body);
                            mail.setUseSignature(true);
                        }
                        
                        if(fromEmailId != null){
                            mail.setOrgWideEmailAddressId(fromEmailId);
                        }
                        
                        
                        notificationEmail.add(mail);
                    }
                }
            }
            
            
            
            if(notificationEmail.size() > 0){
                system.debug('Send Email notificationEmail size '+notificationEmail.size());
                Messaging.sendEmail(notificationEmail);
                
                //Create a task for the related contact
                List<Task> toInsert = new List<Task>();
                for(Id id : contactIds){
                    Task nTask = new Task();
                    nTask.ActivityDate = Date.today();
                    nTask.Status = 'Completed';
                    if(bodyMessageMapByContactId.containsKey(id))
                        nTask.Subject = 'Email: '+subjectMessageMapByContactId.get(id);
                    else
                        nTask.Subject = 'Email: ';
                    
                    if(bodyMessageMapByContactId.containsKey(id))
                        nTask.Description = bodyMessageMapByContactId.get(id);
                    
                    nTask.WhoId = id;
                    toInsert.add(nTask);
                }
                
                if(toInsert.size()>0){
                    insert toInsert;
                }
            }
            System.debug(Limits.getEmailInvocations());
            System.debug(Limits.getLimitEmailInvocations());
            
            update appToBeUpdate;
            return 'Email Sent Successfully';
        }
        catch(Exception e){
            System.debug(Limits.getEmailInvocations());
            System.debug(Limits.getLimitEmailInvocations());
            
            System.debug('Error Message::: ' + e.getMessage() +' At::: '+e.getLineNumber());
            return 'Some Error Occurred';
        }
    }
    
    @AuraEnabled
    public static Map<String,Object> showAttachment(String mandateId, String language){
        try{
            system.debug('---emailContent'+emailContent);
            System.debug('mandateId:::: '+mandateId);
            Mandate__c mandate                                     = [Select Id,Name,Company__c,Company__r.Name,Send_job_description__c from Mandate__c where Id=:mandateId];
            List<AttachmentWrapper> attachmntWrapList = new List<AttachmentWrapper>();
            List<Attachment> attchmntList = new List<Attachment>();
            if(mandate != null){
                attchmntList = [SELECT Id,Name,ParentId, CreatedDate FROM Attachment WHERE ParentId =: mandate.Id ORDER BY CreatedDate];
            }
            System.debug('attchmntListSize:::: '+attchmntList.size());
            if(! attchmntList.isEmpty()){
                for(Attachment att : attchmntList){
                    
                    if (att.Name.tolowercase().contains('job description')){
                        AttachmentWrapper wrapObj = new AttachmentWrapper();
                        wrapObj.isSelected = false;
                        wrapObj.attchmentInstance = att;
                        attachmntWrapList.add(wrapObj);
                    }
                    
                    if (att.Name.tolowercase().contains('advertisement')){
                        
                        AttachmentWrapper wrapObj = new AttachmentWrapper();
                        wrapObj.isSelected = false;
                        wrapObj.attchmentInstance = att;
                        attachmntWrapList.add(wrapObj);
                    }
                    
                    if (att.Name.tolowercase().contains('self assessment')){
                        
                        AttachmentWrapper wrapObj = new AttachmentWrapper();
                        wrapObj.isSelected = false;
                        wrapObj.attchmentInstance = att;
                        attachmntWrapList.add(wrapObj);
                    }
                    
                    if (att.Name.tolowercase().contains('skills matrix')){
                        
                        AttachmentWrapper wrapObj = new AttachmentWrapper();
                        wrapObj.isSelected = false;
                        wrapObj.attchmentInstance = att;
                        attachmntWrapList.add(wrapObj);
                    }
                }
            }
            
            //Added by Deagle
            Map<String,Object> returnObj = new Map<String,Object>();
            //setEmailBody(mandate,language);
            returnObj.put('records',attachmntWrapList);
            returnObj.put('subject',emailSubject);
            returnObj.put('body',emailContent);
            returnObj.put('mandate',mandate);
            return returnObj;
        }
        catch(Exception e){
            System.debug('Error Message::: ' + e.getMessage() +' At::: '+e.getLineNumber());
            return null;
        }
    }
    public static Messaging.EmailFileAttachment emailAttach (Attachment att){
        
        if(att != null){
            Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
            attach.setContentType('application/pdf');
            attach.setFileName(att.Name);
            attach.setInline(false);
            attach.Body = att.Body;
            
            return attach;
        }else{
            return null;
        }
        
        
    }
    public static void setEmailBody(Mandate__c mandate, String language) {
        String body = '';
        
        
        Map<String, EmailTemplate> templatesMap = new Map<String, EmailTemplate>();
        
        for(EmailTemplate t : [select id, name, developername, HtmlValue, body, subject
                               from EmailTemplate
                               where (developername = 'Job_Description_Email'
                                      or developername = 'Job_Description_Email_EN'
                                      or developername = 'Job_Description_Email_Coleman'
                                      or developername = 'Job_Description_Team_2'
                                      or developername = 'Job_Description_Team_3'
                                      or developername = 'Job_Description_Team_4'
                                      
                                      or developername = 'Job_Description_Email_EN_Team_7')]){
                                          
                                          if(t.developername == 'Job_Description_Email_EN'){
                                              templatesMap.put('English', t);
                                          }else if(t.developername == 'Job_Description_Email'){
                                              templatesMap.put('French', t);
                                          }else if(t.developername == 'Job_Description_Email_EN_Team_7'){
                                              templatesMap.put('Team7', t);
                                          }
                                          else if(t.developername == 'Job_Description_Team_2'){
                                              templatesMap.put('Team2', t);
                                          }
                                          else if(t.developername == 'Job_Description_Team_3'){
                                              templatesMap.put('Team3', t);
                                          }
                                          else if(t.developername == 'Job_Description_Team_4'){
                                              templatesMap.put('Team4', t);
                                          }
                                          
                                          else{
                                              templatesMap.put('Coleman', t);
                                          }
                                      }
        String tmp = language;
        //Check Profile Name of the user
        Id profileId = userinfo.getProfileId();
        String profileName = [select Name from profile where id = :profileId].Name;
        
        if(profileName.startsWith('Force.com Leaders Coleman'))
            tmp = 'Coleman';
        else if(profileName.contains('Team 7'))
            tmp = 'Team7';
        else if(profileName.contains('Team 2'))
            tmp = 'Team2';
        else if(profileName.contains('Team 3'))
            tmp = 'Team3';
        
        else if(profileName.contains('Team 4'))
            tmp = 'Team4';
        EmailTemplate temp = templatesMap.get(tmp);
        
        if(mandate.Send_job_description__c!=null && mandate.Send_job_description__c!='') {
            body = mandate.Send_job_description__c;
        } else {
            body = temp.HtmlValue;
        }
        
        emailContent = body;
        if(temp!=null)
            emailSubject = temp.subject;
    }
    public class AttachmentWrapper{
        @AuraEnabled
        public Boolean isSelected;
        @AuraEnabled
        public Attachment attchmentInstance;
    }
}