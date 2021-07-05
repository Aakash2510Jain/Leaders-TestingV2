global with sharing class AssignmentCandidatesCtrl {
    
    public Mandate__c mandate {set;get;}
    public Application__c app {get;set;}
    public Application__c thisapp {get
    {
      if (thisapp == null)
         thisapp = new Application__c();
         return thisapp;
    }
   set;
}
    public Application__c thisapp1 {get
    {
      if (thisapp == null)
         thisapp = new Application__c();
         return thisapp;
    }
   set;
}
    
    
    
    
    public List<Application__c> applicationList {get; set;}
    private String sortDirection = 'ASC';
    private String sortExp = 'Contact__r.LastName';
    private boolean saveSort;
    public boolean checkAll {get; set;}
    public string SSL;
    public string ORG;
    
    //CandidatesList or SourceList
    public String pageType {get;set;}
    
    public String emailContent {get;set;}
    public String emailSubject {get;set;}

    private integer counter=0;  //keeps track of the offset
        private integer list_size=300; //sets the page size or number of rows
        public integer total_size = 0; //used to show user the total size of the list
    
    public Boolean isColemanProfile {get;set;}
    public Boolean isDPProfile {get;set;}
    
    public boolean missingDoc {get; set;}
    
    public String mId {set;get;}
    
    public List<ResultWrapper> resultWrapperList {get; set;}
    
    public Set<Id> contactIdSelected  = new Set<Id>();
    
    public String candidateIdSelected {get;set;}
    public Boolean candidateIsSelected {get;set;}
    
    public AssignmentCandidatesCtrl()
    {
        
    }
    
    public AssignmentCandidatesCtrl(ApexPages.StandardController stdController){        
        //this.mandate = (Mandate__c)stdController.getRecord();   
      
        pageType = 'CandidatesList';
        candidateIsSelected = false;
        candidateIdSelected = '';
        if(ApexPages.currentPage().getParameters().get('pageType')!=null)
            pageType = ApexPages.currentPage().getParameters().get('pageType');
            SYSTEM.debug('CURRENT PAGE TYPE'+pageType);
       
        mId = stdController.getId();
        loadSort(stdController.getId());
        sortExp ='Contact__r.LastName';
        sortDirection = 'ASC';
         if( ApexPages.currentPage().getParameters().get('sortBy')!=null) {
            sortExp=  ApexPages.currentPage().getParameters().get('sortBy');
        }
        
        if( ApexPages.currentPage().getParameters().get('sortDirection')!=null) {
            sortDirection=  ApexPages.currentPage().getParameters().get('sortDirection');
            
        }
        
        saveSort = false;
        checkAll = false;
        SSL= thisapp.Status_Summary_Line__c;
        ORG = thisapp.Contact__r.Origin__c ;
        ViewData();
        saveSort = true;
        missingDoc = false;
        
        isColemanProfile = false;
        
       
        
        
        Id profileId = userinfo.getProfileId();
        String profileName = [select Name from profile where id = :profileId].Name;
            
        if(profileName.startsWith('Force.com Leaders Coleman'))
            isColemanProfile=true;
        
        if(profileName.contains('Team 4'))
            isDPProfile = true;
   
       
    }
        
    public void loadSort(Id mandateId){
        this.mandate  = [Select Id, Name, Company__r.Name, sortDirection__c, 
                                sortExpression__c, candidateSeleted__c,
                                Potential_Candidates_Conga_Link__c,
                                Potential_Candidates_Conga_Link_2__c,
                                Assignment_ID__c, 
                                Send_job_description__c
                          from Mandate__c
                         where Id = :mandateId
                         limit 1];
                         
        if (mandate.sortDirection__c != null){
             sortDirection = mandate.sortDirection__c;
        }
        
        if (mandate.sortExpression__c != null){
             sortExp = mandate.sortExpression__c;
        }
        
    }
    
   public String candidateId{
        get;
        set {
            candidateId = value;
            system.debug('value: '+value);
        }
   }

   public String sortExpression
   {
     get
     {
        return sortExp;
     }
     set
     {
       //if the column is clicked on then switch between Ascending and Descending modes
       if (value == sortExp)
         sortDirection = (sortDirection == 'ASC')? 'DESC' : 'ASC';
       else
         sortDirection = 'ASC';
       sortExp = value;
     }
   }

     public String getSortDirection()
     {
        //if not column is selected 
        if (sortExpression == null || sortExpression == '')
          return 'ASC';
        else
         return sortDirection;
     }
    
     public void setSortDirection(String value)
     {  
       sortDirection = value;
     }
    
    
    public PageReference selectedORG()
    {
       system.debug('origin Value :'+thisapp1.Origin__c);
        
        
    /*    if(thisapp1.Origin__c != null)
        {*/
            ORG =thisapp1.Origin__c;
     //   }
        system.debug('ORG'+ORG);
        return null;
    }
     
    
    public PageReference selectedSSL()
    {
       
        if(thisapp.Status_Summary_Line__c != null)
        {
            SSL=thisapp.Status_Summary_Line__c;
        }
        
        system.debug('SSL'+SSL);
        return null;
    }
    
    
    
    
    public PageReference ViewData() {
       //build the full sort expression
       string sortFullExp = sortExpression  + ' ' + sortDirection;
       String SSL=Apexpages.currentpage().getParameters().get('SSL');
       string ORG = Apexpages.currentpage().getParameters().get('ORG');
       SYSTEM.debug('SSL'+SSL); 
       if(sortExpression=='LastModifiedDate')
           sortFullExp = 'Name';
        
        sortFullExp = ' InternalTopStatus__c DESC , '+sortFullExp;
       
        String filter = '';
        if(pageType=='SourceList')
            filter = ' AND (Status_Summary_Line__c =\'Identified as a source.\' OR Status_Summary_Line__c =\'Source [Not included in the report].\'  )';
        else if(pageType=='ClientList')
            filter = ' AND Status_Summary_Line__c =\'Client.\' ';
        else if(pageType=='CandidatesList') {
            filter = ' AND Status_Summary_Line__c !=\'Identified as a source.\' AND Status_Summary_Line__c !=\'Source [Not included in the report].\'  AND Status_Summary_Line__c !=\'Client.\' AND Status_Summary_Line__c !=\'Private\' AND Status_Summary_Line__C != null  ';
            
                
            }  
        
        else if(pageType=='RawList')
            filter = ' AND ( Status_Summary_Line__c =\'Private\' OR Status_Summary_Line__c = Null )';
     //   else filter = 'AND (Status_Summary_Line__c = {!app.Status_Summary_Line__c} OR Origin__c = {!app.Contact__r.Origin__c} )';
     
        else if(pageType == 'view')
                 {
                   //  filter= 'AND ( Status_Summary_Line__c = {!app.Status_Summary_Line__c} Origin__c = {!app.Contact__r.Origin__c} )' ;
                     system.debug('Status Summary line on View Page Type'+SSL);
                     if(ORG == '')
                     {
                         filter = 'AND Status_Summary_Line__c = \''+ SSL +'\' ';
                     }
                     
                   
                     else{
                          filter= 'AND ( Status_Summary_Line__c = \''+ SSL +'\' OR Contact__r.Origin__c = \''+ ORG +'\'   )';  
                     }
                    
                 }
        
        
      ///* Mandate__c = \''+ mandate.Id +'\'*/  
        
        
        system.debug('filter statement '+filter);
        
       //query the database based on the sort expression
       applicationList = Database.query('Select Id,Origin__c, CreatedDate, Name, Contact__r.hasCV__c,Contact__r.Off_Limit__c,Contact__r.Off_Limit_Auto__c,Contact__r.Contact_Off_Limit__c,Contact__r.Origin__c, Contact__c, CompanyId__c, Contact__r.Name, Contact__r.FirstName, Contact__r.LastName, Current_Title__c, Potential_Candidate__c, Status_Summary_Line__c, Current_Company_EN__c, Contact__r.Phone, Contact__r.MobilePhone, Contact__r.Email, Contact__r.Account.Phone, InternalTopStatus__c, First_Name__c, Last_Name__c, LastModifiedDate , Location__c from Application__c where Mandate__c = \''+ mandate.Id +'\'  ' +filter+' order by ' + sortFullExp+' NULLS LAST '+' limit :list_size offset :counter' );
       
        total_size = Database.countQuery('Select count() from Application__c where Mandate__c = \''+ mandate.Id +'\' '+filter);
       
       
            
       List<Application__c> potentialList = new List<Application__c>();
       List<Application__c> statusList = new List<Application__c>();
       Set<Id> contactIds = new Set<Id>();
       Map<String, DateTime> lastActivityDateMapByContactId = new Map<String, DateTime>();
       
        for (Application__c app : applicationList){
            if (app.InternalTopStatus__c){
                potentialList.add(app);
            }else{
                statusList.add(app);
            }
            
            if(app.Contact__c!=null)
                contactIds.add(app.Contact__c);
            
            
                
        }
        
        if(!contactIds.isEmpty()) {
             for(AggregateResult result: [SELECT WhoId, MAX(LastModifiedDate) FROM Task WHERE Status ='Completed' AND WhoId IN :contactIds GROUP BY WhoId]) {
                lastActivityDateMapByContactId.put(String.valueOf(result.get('WhoId')), DateTime.valueOf(result.get('expr0')));
             }
        }
        
        applicationList = new List<Application__c>();
        applicationList.addAll(potentialList);
        applicationList.addAll(statusList);
              
       Map<String, String> lastCVByContactId = new Map<String, String>();
        Map<String, Integer> nbOnePagerByContactId = new Map<String, Integer>();
        Map<String, Integer> nbJobDescriptionByContactId = new Map<String, Integer>();

       if(!contactIds.isEmpty()) {

           
          for(AggregateResult result: [SELECT ParentId, COUNT(Id) FROM Attachment WHERE ParentId IN :contactIds AND Name LIKE 'One Page%' GROUP BY ParentId]) {
              if(Integer.valueOf(result.get('expr0'))>0) {
                  nbOnePagerByContactId.put(String.valueOf(result.get('ParentId')),Integer.valueOf(result.get('expr0')));
              }
          }
           
           for(AggregateResult result: [SELECT ParentId, COUNT(Id) FROM Attachment WHERE ParentId IN :contactIds AND Name LIKE 'Job Description%' GROUP BY ParentId]) {
              if(Integer.valueOf(result.get('expr0'))>0) {
                  nbJobDescriptionByContactId.put(String.valueOf(result.get('ParentId')),Integer.valueOf(result.get('expr0')));
              }
          }
           
          for(Attachment result: [SELECT Id, ParentId FROM Attachment WHERE ParentId IN :contactIds AND Name LIKE 'CV%' ORDER BY LastModifiedDate DESC]) {
              if(!lastCVByContactId.containsKey(String.valueOf(result.ParentId)))
                 lastCVByContactId.put(String.valueOf(result.ParentId),String.valueOf(result.Id));              
          }
       }
        
        //Get note by contactIds
        Map<String, String> lastestNoteTitleByContactId = new Map<String, String>();
       
        try {
            for(Note note:[SELECT Title , ParentId  FROM Note WHERE ParentId IN :contactIds ORDER BY LastModifiedDate ASC]) {
                lastestNoteTitleByContactId.put(note.ParentId,note.Title );
            }
        } catch(Exception e) {}
        System.debug('contactIdSelected');
        System.debug(contactIdSelected);
       resultWrapperList = new List<ResultWrapper>();
       for (Application__c app : applicationList){
            ResultWrapper rw = new ResultWrapper(app);
            if(sortExpression=='LastModifiedDate') {
                rw.sortBy = 'LastModifiedDate';
                rw.sortDirection = sortDirection;   
            }
            
            if(app.Contact__c!=null) {
                if(app.Contact__r.hasCV__c) {
                    rw.hasCV = true;
                    if(lastCVByContactId.containsKey(String.valueOf(app.Contact__c)))
                        rw.cvId = lastCVByContactId.get(String.valueOf(app.Contact__c));
                }
                
                if(app.Contact__r.Off_Limit_Auto__c)
                {
                    rw.Off_Limit_Auto= true;
                }
                
                if(app.Contact__r.Contact_Off_Limit__c)
                {
                    rw.Contact_Off_Limit = true;
                }
                
                
                
                if(lastestNoteTitleByContactId.containsKey(String.valueOf(app.Contact__c)))
                    rw.noteTitle = lastestNoteTitleByContactId.get(String.valueOf(app.Contact__c));
                
                if(nbOnePagerByContactId.containsKey(String.valueOf(app.Contact__c)))
                    rw.hasOnePager = true;
                if(nbJobDescriptionByContactId.containsKey(String.valueOf(app.Contact__c)))
                    rw.hasJobDescription = true;
                
                if(lastActivityDateMapByContactId.containsKey(app.Contact__c)) {
                    if(lastActivityDateMapByContactId.get(app.Contact__c)>app.LastModifiedDate)
                        rw.lastModifiedDate = lastActivityDateMapByContactId.get(app.Contact__c);
                    else
                        rw.lastModifiedDate = app.LastModifiedDate;
                    
                } else {
                    rw.lastModifiedDate = app.LastModifiedDate;
                }
                
                if(contactIdSelected.contains(app.Id))
                    rw.selected = true;
            }
            resultWrapperList.add(rw);
       }
       
       applicationList.clear(); 
        
       if(sortExpression=='LastModifiedDate') {
           resultWrapperList.sort();
       }
        
       
       
       if(saveSort){
            saveSortVariables();
       }       
       return null;
   }
    
    public void saveSortVariables(){
        
        mandate.sortDirection__c = sortDirection;
        mandate.sortExpression__c = sortExpression;
        update mandate;
        
    }
    public PageReference goBack(){
       system.debug('Assignment ID :'+mandate.Id);
        PageReference newPage = new PageReference('/'+mandate.Id);  
        system.debug(newPage);
       
            return newPage; 
        
      //  return new PageReference('/'+mandate.Id);
    }
    
    
   
    
    
    public PageReference newCandidate(){
        String param = '';
        if(pageType=='SourceList')
            param = '&00NU00000043Oqj=Source [Not included in the report].';
        else if(pageType=='ClientList')
            param = '&00NU00000043Oqj=Client.';
        
        
        PageReference newPage = new PageReference('/a02/e?CF00NU00000042Zrm='+mandate.Name+'&CF00NU00000042Zrm_lkid='+mandate.Id+param+'&retURL=/apex/AssignmentCandidates?id='+mandate.Id+'&pageType='+pageType+'&saveURL='+EncodingUtil.urlEncode('/apex/AssignmentCandidates?id='+mandate.Id+'&pageType='+pageType,'UTF-8'));
        return newPage;        
    }
    
    public PageReference leadersReportPage(){
        
        String Candidates = '';
        List<Id> candidateIds = new List<Id>();
        Boolean ifselected=false;
        for(ResultWrapper r : resultWrapperList){
            if (r.selected && r.candidate.Status_Summary_Line__c != 'Private' && r.candidate.Status_Summary_Line__c != 'Privé'){
                Candidates += r.candidate.Id+',';
                candidateIds.add(r.candidate.Id);
            }
            if (r.selected){
                ifselected=true;
            }
        }
        //C115461 - Cristina Sananez f no candidate are selected and the user click 
        //Leader Reports, we should automatically use all candidate that:
        //- have the field InternalTopStatus__c to True 
        //(candidate with red status summary line from the assignment page)
        if (ifselected==false){
            for(ResultWrapper r : resultWrapperList){
            if (r.candidate.InternalTopStatus__c){
                Candidates += r.candidate.Id+',';
                candidateIds.add(r.candidate.Id);
            }
        }
        }
       
       system.debug('[AssignmentCandidatesCtrl] Candidates '+Candidates);
        PageReference newPage = null;
        if(Candidates == ''){
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select at least one candidate.'));
            
            newPage = new PageReference('/apex/Nubik_IdentificationReport?id='+mandate.Id+'&candidates=');   
            //String candidateSelected = getStringFromIdList(candidateIds).replace(',','|');                                    
            //mandate.candidateSeleted__c = candidateSelected;
            //String pv1 = '~pv1='+candidateSelected;
            //mandate.Potential_Candidates_Conga_Link_2__c =  mandate.Potential_Candidates_Conga_Link__c.replace('~pv1=', pv1);
            //update mandate;
            
        }else{
            newPage = new PageReference('/apex/Nubik_IdentificationReport?id='+mandate.Id+'&candidates='+Candidates.substring(0, Candidates.length()-1));   
            String candidateSelected = getStringFromIdList(candidateIds).replace(',','|');                                    
            mandate.candidateSeleted__c = candidateSelected;
            String pv1 = '~pv1='+candidateSelected;
            mandate.Potential_Candidates_Conga_Link_2__c =  mandate.Potential_Candidates_Conga_Link__c.replace('~pv1=', pv1);
            update mandate;
        }
        
        return newPage;  
    }
    
    public String selectedTLanguage {get;set;}
    
    public List<SelectOption> templateLanguage {get {
        if (templateLanguage == null) {
            
            templateLanguage = new List<SelectOption>();
            templateLanguage.add(new SelectOption('English','English'));
                        templateLanguage.add(new SelectOption('French','French'));

        }
        return templateLanguage;
    } set;}
    
    
    public List<AttachWrapper> jobDescriptionList {get
        {
            if(jobDescriptionList == null){
                
                jobDescriptionList =  new List<AttachWrapper>();
                                
                for(Attachment att : [Select id, ParentId, Name, body
                                       from Attachment 
                                      where ParentId = :mandate.Id
                                        /*and contenttype='application/pdf'*/]){
                    
                    if (att.Name.tolowercase().contains('job description')){
                        AttachWrapper aW = new AttachWrapper(att);                      
                        jobDescriptionList.add(aW);   
                    } 
                    
                    if (att.Name.tolowercase().contains('advertisement')){
                    
                        AttachWrapper aw1= new AttachWrapper(att);
                        jobDescriptionList.add(aw1);
                        }                   
                           
                    if (att.Name.tolowercase().contains('self assessment')){
                    
                        AttachWrapper aw2= new AttachWrapper(att);
                        jobDescriptionList.add(aw2);
                        } 
                    
                    if (att.Name.tolowercase().contains('skills matrix')){
                    
                        AttachWrapper aw3= new AttachWrapper(att);
                        jobDescriptionList.add(aw3);
                        } 
                                            
                                            
  /*  Ankita Ends   */                                           
             /*    AttachWrapper aW = new AttachWrapper(att);                      
                        jobDescriptionList.add(aW);      */                     
                                            
                                            
                }
            }       
            return jobDescriptionList;
        }

    set;}
    
    public boolean displayJobDescriptionList {get; set;}   
    
    public void showJobDescriptionList() {
        
        missingDoc = false;
        
        //if (jobDescriptionList.size()>0){
            List<Id> candidateIds = new List<Id>();
            
            for(ResultWrapper r : resultWrapperList){
                if (r.selected && !String.isEmpty(r.candidate.Contact__r.Email)){
                    candidateIds.add(r.candidate.Id);
                }
            }
            
            if(selectedTLanguage==null)
                selectedTLanguage = 'English';
            
            setBodyEmail();
                        
            if(!candidateIds.isEmpty()){
                displayJobDescriptionList = true;    
            }
            
            else{
               ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'No candidate selected. Please select at least one candidate to send emails.'));
               displayJobDescriptionList = false; 
            }
       // }
        
        /*else{
           ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'There are no job description attached to this assignment.'));
            displayJobDescriptionList = false; 
        } */  
    }
    
    public void closeJobDescriptionList() {        
        displayJobDescriptionList = false;    
    }    
    
    public void setBodyEmail() { 
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
        
        String tmp = selectedTLanguage;
        
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
    
 /*  public void sendEmailFromExecute(List<Application__c> canList)
    {
        List<Application__c> candidatesList;
         List<Attachment> attachDocs = new List<Attachment>();
        
        candidatesList = canList;
        for(AttachWrapper r : jobDescriptionList){          
            if (r.selected){
                attachDocs.add(r.file);
            }
        }
        
        //if(attachDocs.size() > 0){
            
            List<Messaging.SingleEmailMessage> notificationEmail = 
                                new List<Messaging.SingleEmailMessage>();
                                
               
            
            List<OrgWideEmailAddress> fromEmail = [Select Id from OrgWideEmailAddress where DisplayName = 'Leaders & Cie et Leaders & Co.'];
            Id fromEmailId = fromEmail.size()>0 ? fromEmail[0].Id : null;
                                    
            
            List<Messaging.EmailFileAttachment> attachList = 
                                    new List<Messaging.EmailFileAttachment>();
                                    
            for(Attachment att : attachDocs){
                attachList.add(emailAttach(att));
            }  
            
            Set<Id> contactIds = new Set<Id>();
            Map<Id, String> bodyMessageMapByContactId = new Map<Id, String>();
            Map<Id, String> subjectMessageMapByContactId = new Map<Id, String>();
            for(Application__c can : candidatesList){
                
                system.debug(':::::: CANDIDATE :::::: '+can);
                contactIds.add(can.Contact__c);
                
                String body = emailContent;
                String subject = emailSubject.replace('{!Mandate__c.Name}', mandate.Name);
                
        
                body = body.replace('{!Mandate__c.Name}', mandate.Name);
                
                if(mandate.Company__c!=null)
                    body = body.replace('{!Mandate__c.Company__c}', mandate.Company__r.Name);
                
                
                if(!String.isEmpty(can.First_Name__c)){
                    body = body.replace('{!Application__c.First_Name__c}', can.First_Name__c);
                }else{
                    body = body.replace('{!Application__c.First_Name__c}', '');
                }
                
                if(!String.isEmpty(can.Last_Name__c)){
                    body = body.replace('{!Application__c.Last_Name__c}', can.Last_Name__c);
                }else{
                    body = body.replace('{!Application__c.Last_Name__c}', '');
                }
                
                bodyMessageMapByContactId.put(can.Contact__c,body);
                subjectMessageMapByContactId.put(can.Contact__c,subject);
                                
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setUseSignature(false);
                List<String> recipient = new List<String>();
                recipient.add(can.Contact__r.Email);
                mail.setToAddresses(recipient);
                mail.setSubject(subject);
                mail.setHtmlBody(body);
                mail.setPlainTextBody(body);
                mail.setFileAttachments(attachList);   
                mail.setUseSignature(true);
 
                
                if(fromEmailId != null){
                    mail.setOrgWideEmailAddressId(fromEmailId);
                }
                
                
                notificationEmail.add(mail);                                
            }                                    
                        
            /*String bodyHtml = temp.HtmlValue;
            String body = temp.body;
            String subject = temp.subject;
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setUseSignature(false);
            mail.setToAddresses(new List<String>(candidateEmails));
            mail.setSubject(subject);
            mail.setHtmlBody(bodyHtml);
            mail.setPlainTextBody(body);
            mail.setFileAttachments(attachList);        
            
            notificationEmail.add(mail);*/
            
     /*      if(notificationEmail.size() > 0){
                system.debug('Send Email notificationEmail size '+notificationEmail.size());
            //    Messaging.sendEmail(notificationEmail); 
                
             //   database.executeBatch(new sendMassEmailToCandidatesBatch(candidateIds,candidateEmails,CandidatesList,attachDocs), 20);
                
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
                
                displayJobDescriptionList = false; 
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Email sent successfully.'));               
            }               
        /*}else{
            missingDoc = true;
        } 
        
     //   return null;
    }
    
    
    public PageReference sendJobDescriptionBatch()
    {
        
      //  sendMassEmailToCandidatesBatch batchex = new sendMassEmailToCandidatesBatch(candidateIds);
	//	database.executeBatch(batchex,5);
        
        
        List<Id> candidateIds = new List<Id>();
        Set<String> candidateEmails = new Set<String>();
        List<Application__c> candidatesList = new List<Application__c>();
        
        for(ResultWrapper r : resultWrapperList){
            if (r.selected && !String.isEmpty(r.candidate.Contact__r.Email)){
                candidateIds.add(r.candidate.Id);
                candidateEmails.add(r.candidate.Contact__r.Email);
                candidatesList.add(r.candidate);
            }
        }
        
         sendMassEmailToCandidatesBatch batchex = new sendMassEmailToCandidatesBatch(candidatesList);
		 database.executeBatch(batchex,5);
        
    /*    List<Attachment> attachDocs = new List<Attachment>();
        
        for(AttachWrapper r : jobDescriptionList){          
            if (r.selected){
                attachDocs.add(r.file);
            }
        }
        
        //if(attachDocs.size() > 0){
            
            List<Messaging.SingleEmailMessage> notificationEmail = 
                                new List<Messaging.SingleEmailMessage>();
                                
               
            
            List<OrgWideEmailAddress> fromEmail = [Select Id from OrgWideEmailAddress where DisplayName = 'Leaders & Cie et Leaders & Co.'];
            Id fromEmailId = fromEmail.size()>0 ? fromEmail[0].Id : null;
                                    
            
            List<Messaging.EmailFileAttachment> attachList = 
                                    new List<Messaging.EmailFileAttachment>();
                                    
            for(Attachment att : attachDocs){
                attachList.add(emailAttach(att));
            }  
            
            Set<Id> contactIds = new Set<Id>();
            Map<Id, String> bodyMessageMapByContactId = new Map<Id, String>();
            Map<Id, String> subjectMessageMapByContactId = new Map<Id, String>();
            for(Application__c can : candidatesList){
                
                system.debug(':::::: CANDIDATE :::::: '+can);
                contactIds.add(can.Contact__c);
                
                String body = emailContent;
                String subject = emailSubject.replace('{!Mandate__c.Name}', mandate.Name);
                
        
                body = body.replace('{!Mandate__c.Name}', mandate.Name);
                
                if(mandate.Company__c!=null)
                    body = body.replace('{!Mandate__c.Company__c}', mandate.Company__r.Name);
                
                
                if(!String.isEmpty(can.First_Name__c)){
                    body = body.replace('{!Application__c.First_Name__c}', can.First_Name__c);
                }else{
                    body = body.replace('{!Application__c.First_Name__c}', '');
                }
                
                if(!String.isEmpty(can.Last_Name__c)){
                    body = body.replace('{!Application__c.Last_Name__c}', can.Last_Name__c);
                }else{
                    body = body.replace('{!Application__c.Last_Name__c}', '');
                }
                
                bodyMessageMapByContactId.put(can.Contact__c,body);
                subjectMessageMapByContactId.put(can.Contact__c,subject);
                                
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setUseSignature(false);
                List<String> recipient = new List<String>();
                recipient.add(can.Contact__r.Email);
                mail.setToAddresses(recipient);
                mail.setSubject(subject);
                mail.setHtmlBody(body);
                mail.setPlainTextBody(body);
                mail.setFileAttachments(attachList);   
                mail.setUseSignature(true);
 
                
                if(fromEmailId != null){
                    mail.setOrgWideEmailAddressId(fromEmailId);
                }
                
                
                notificationEmail.add(mail);                                
            }                                    
                        
            /*String bodyHtml = temp.HtmlValue;
            String body = temp.body;
            String subject = temp.subject;
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setUseSignature(false);
            mail.setToAddresses(new List<String>(candidateEmails));
            mail.setSubject(subject);
            mail.setHtmlBody(bodyHtml);
            mail.setPlainTextBody(body);
            mail.setFileAttachments(attachList);        
            
            notificationEmail.add(mail);*/
            
      /*     if(notificationEmail.size() > 0){
                system.debug('Send Email notificationEmail size '+notificationEmail.size());
            //    Messaging.sendEmail(notificationEmail); 
                
             //   database.executeBatch(new sendMassEmailToCandidatesBatch(candidateIds,candidateEmails,CandidatesList,attachDocs), 20);
                
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
                
                displayJobDescriptionList = false; 
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Email sent successfully.'));               
            }               
        /*}else{
            missingDoc = true;
        }  
        
        return null; 
    }*/
    
    
    
    
    
    
 /* Original Method Starts   */
    public PageReference sendJobDescription(){
        
        List<Id> candidateIds = new List<Id>();
        Set<String> candidateEmails = new Set<String>();
        List<Application__c> candidatesList = new List<Application__c>();
        
        for(ResultWrapper r : resultWrapperList){
            if (r.selected && !String.isEmpty(r.candidate.Contact__r.Email)){
                candidateIds.add(r.candidate.Id);
                candidateEmails.add(r.candidate.Contact__r.Email);
                candidatesList.add(r.candidate);
            }
        }
        
        List<Attachment> attachDocs = new List<Attachment>();
        
        for(AttachWrapper r : jobDescriptionList){          
            if (r.selected){
                attachDocs.add(r.file);
            }
        }
        
        //if(attachDocs.size() > 0){
            
            List<Messaging.SingleEmailMessage> notificationEmail = 
                                new List<Messaging.SingleEmailMessage>();
                                
               
            
            List<OrgWideEmailAddress> fromEmail = [Select Id from OrgWideEmailAddress where DisplayName = 'Leaders & Cie et Leaders & Co.'];
            Id fromEmailId = fromEmail.size()>0 ? fromEmail[0].Id : null;
                                    
            
            List<Messaging.EmailFileAttachment> attachList = 
                                    new List<Messaging.EmailFileAttachment>();
                                    
            for(Attachment att : attachDocs){
                attachList.add(emailAttach(att));
            }  
            
            Set<Id> contactIds = new Set<Id>();
            Map<Id, String> bodyMessageMapByContactId = new Map<Id, String>();
            Map<Id, String> subjectMessageMapByContactId = new Map<Id, String>();
            for(Application__c can : candidatesList){
                
                system.debug(':::::: CANDIDATE :::::: '+can);
                contactIds.add(can.Contact__c);
                
                String body = emailContent;
                String subject = emailSubject.replace('{!Mandate__c.Name}', mandate.Name);
                
        
                body = body.replace('{!Mandate__c.Name}', mandate.Name);
                
                if(mandate.Company__c!=null)
                    body = body.replace('{!Mandate__c.Company__c}', mandate.Company__r.Name);
                
                
                if(!String.isEmpty(can.First_Name__c)){
                    body = body.replace('{!Application__c.First_Name__c}', can.First_Name__c);
                }else{
                    body = body.replace('{!Application__c.First_Name__c}', '');
                }
                
                if(!String.isEmpty(can.Last_Name__c)){
                    body = body.replace('{!Application__c.Last_Name__c}', can.Last_Name__c);
                }else{
                    body = body.replace('{!Application__c.Last_Name__c}', '');
                }
                
                bodyMessageMapByContactId.put(can.Contact__c,body);
                subjectMessageMapByContactId.put(can.Contact__c,subject);
                                
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setUseSignature(false);
                List<String> recipient = new List<String>();
                recipient.add(can.Contact__r.Email);
                mail.setToAddresses(recipient);
                mail.setSubject(subject);
                mail.setHtmlBody(body);
                mail.setPlainTextBody(body);
                mail.setFileAttachments(attachList);   
                mail.setUseSignature(true);
 
                
                if(fromEmailId != null){
                    mail.setOrgWideEmailAddressId(fromEmailId);
                }
                
                
                notificationEmail.add(mail);                                
            }                                    
                        
            /*String bodyHtml = temp.HtmlValue;
            String body = temp.body;
            String subject = temp.subject;
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setUseSignature(false);
            mail.setToAddresses(new List<String>(candidateEmails));
            mail.setSubject(subject);
            mail.setHtmlBody(bodyHtml);
            mail.setPlainTextBody(body);
            mail.setFileAttachments(attachList);        
            
            notificationEmail.add(mail);*/
            
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
                
                displayJobDescriptionList = false; 
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Email sent successfully.'));               
            }               
        /*}else{
            missingDoc = true;
        } */  
        
        return null;
    } 
   /* Original Method Ends */ 
      
    public PageReference addCandidateToMandate(){
        String idsToPass = '';        
        for(ResultWrapper aResult : resultWrapperList){
            if(aResult.selected){
                idsToPass = idsToPass + aResult.candidate.Id+',';                
            }
        }
        //Cookie canIdsCookie = new Cookie('canIds', idsToPass,null,-1,false);
        //ApexPages.currentPage().setCookies(new Cookie[]{canIdsCookie});        
        
        Cache.Session.put('local.recruiting.canIds', idsToPass);
        
        PageReference newPage = new PageReference('/apex/Nubik_MandateAddAppToMandate?scontrolCaching=1&id='+mandate.Id);
        return newPage;  
    }
    
    public PageReference updateSSL(){
        String idsToPass = '';        
        for(ResultWrapper aResult : resultWrapperList){
            if(aResult.selected){
                idsToPass = idsToPass + aResult.candidate.Id+',';                
            }
        }
        //Cookie canIdsCookie = new Cookie('canIds', idsToPass,null,-1,false);
        //ApexPages.currentPage().setCookies(new Cookie[]{canIdsCookie});        
        
        Cache.Session.put('local.recruiting.canIds', idsToPass);
        
        PageReference newPage = new PageReference('/apex/updateRelatedAssignment?scontrolCaching=1&id='+mandate.Id);
        return newPage;  
    }
    
    public PageReference deleteCandidates() {
        
        List<Application__c> selectedCandidates = new List<Application__c>();
        for (ResultWrapper rw : resultWrapperList) {
            if (rw.selected == true) {
                selectedCandidates.add(rw.candidate);
            }
        }
        
        if (selectedCandidates.size()>0){
            delete selectedCandidates;
            return ViewData();
        }else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select at least one candidate.'));
        } 
        
        return null;
    }
    
    public List<Application__c> getApplications() {
       return applicationList;
   }
   
   private List<Meeting_Note__c> recentMeetingNotes(Id candId){
    
        List<Meeting_Note__c> notes = [Select Id, Contact__c, Contact__r.Name,
                                              Status_Summary_Line__c, 
                                              Description__c ,
                                              Candidate_Assigned__c,
                                              Candidate_Assigned__r.Name
                                         from Meeting_Note__c 
                                        where Candidate_Assigned__c = :candId 
                                          and Most_Recent__c = true];
                                              
        return notes;
   }
   
   public PageReference editReportNote(){
    
        if (!String.isEmpty(candidateId)){
            
            List<Meeting_Note__c> notes = recentMeetingNotes(candidateId);
                                              
            if (notes.size()>0){
                Meeting_Note__c note = notes[0];  
                Pagereference pr = new Pagereference('/' + note.Id + '/e?retURL=%2F'+mandate.Id+'&saveURL='+EncodingUtil.urlEncode('/apex/AssignmentCandidates?id='+mandate.Id+'&pageType='+pageType+'&sortBy='+sortExp+'&sortDirection='+sortDirection,'UTF-8'));             
                return pr;
            }
            
        }
    
        return null;
   }
   
   public PageReference addNewContact(){
        //Schema.DescribeSObjectResult r = Contact.sObjectType.getDescribe();
        //return new Pagereference('/' + r.getKeyPrefix() + '/e?00Nq0000000nsM4='+mandate.Id+'&00Nq0000000nsLz=1&retURL=%2F'+mandate.Id);    
        return new Pagereference('/apex/ContactCandidate?mandateId='+mandate.Id);
   }
   
   public PageReference createReportNote(){
    
    system.debug(':: candidateId :: '+ candidateId);
    
        if (!String.isEmpty(candidateId)){
            
            List<Meeting_Note__c> notes = recentMeetingNotes(candidateId);
                        
            Schema.DescribeSObjectResult r = Meeting_Note__c.sObjectType.getDescribe();
            String keyPrefix = r.getKeyPrefix();
            String urlParams = '';
            Map<String, String> fieldsId = NubikHelper.getFieldsForObject('Meeting_Note__c'); 
                                              
            if (notes.size()>0){
                Meeting_Note__c note = notes[0];                            
                
                if(fieldsId.get('contact__c') != null){
                    urlParams += fieldsId.get('contact__c') + '=' + note.Contact__r.Name + '&'+ fieldsId.get('contact__c') + '_lkid=' + note.Contact__c + '&';
                }
                        
                
                if(fieldsId.get('candidate_assigned__c') != null){
                    urlParams += fieldsId.get('candidate_assigned__c') + '=' + note.Candidate_Assigned__r.Name + '&'+ fieldsId.get('candidate_assigned__c') + '_lkid=' + note.Candidate_Assigned__c + '&';
                }
                        
                
                if (fieldsId.get('status_summary_line__c') != null && note.Status_Summary_Line__c!=null){
                    
                    String encodedString = EncodingUtil.urlEncode(note.Status_Summary_Line__c, 'UTF-8');
                    
                    urlParams += fieldsId.get('status_summary_line__c') + '=' + encodedString + '&';
                }
                
                
                String description = '';
                
                if (note.Description__c!=null){
                    description = EncodingUtil.urlEncode(note.Description__c, 'UTF-8');
                }
                                
                if (fieldsId.get('description__c') != null){
                    urlParams += fieldsId.get('description__c') + '=' + description + '&';
                }                 
                
            }else{
                
                List<Application__c> app = [Select Id, Name, Contact__c, 
                                                   Contact__r.Name
                                              from Application__c
                                             where Id = :candidateId];
                
                if(fieldsId.get('contact__c') != null){
                    urlParams += fieldsId.get('contact__c') + '=' + app[0].Contact__r.Name + '&'+ fieldsId.get('contact__c') + '_lkid=' + app[0].Contact__c + '&';
                }
                
                if(fieldsId.get('candidate_assigned__c') != null){
                    urlParams += fieldsId.get('candidate_assigned__c') + '=' + app[0].Name + '&'+ fieldsId.get('candidate_assigned__c') + '_lkid=' + app[0].Id + '&';
                }
                
            }
            
            if (fieldsId.get('most_recent__c') != null){
                urlParams += fieldsId.get('most_recent__c') + '=1&';
            }   
            
            urlParams += 'retURL=%2F' + keyPrefix+'&saveURL='+EncodingUtil.urlEncode('/apex/AssignmentCandidates?id='+mandate.Id+'&pageType='+pageType+'&sortBy='+sortExp+'&sortDirection='+sortDirection,'UTF-8');              
            system.debug(':: urlParams :: '+ urlParams);            
            Pagereference pr = new Pagereference('/' + keyPrefix + '/e?' + urlParams );             
            return pr;
            
        }
        return null;
   }
   
   
   public PageReference selectPotencialCandidates(){

       for(ResultWrapper r : resultWrapperList){
            
            if (r.candidate.InternalTopStatus__c){
                r.selected = true;
            }else{
                r.selected = false;
            }
        } 
    
        return null;         
    }
    
    
    public static String getStringFromIdList(List<id> ids) {
        string idString;
        for(Id i : ids){
            idString = (!String.isBlank(idString)) ? (idString + ',\'' + i + '\'') : ('\'' + i + '\'');
        }
        //If idString contains some ids we want to ensure we strip out the last comma
        return idString; 
     }
    
    public PageReference Beginning() { //user clicked beginning
      counter = 0;
        updateSelectedContact();
      viewData();
      return null;
   }

   public PageReference Previous() { //user clicked previous button
      counter -= list_size;
       updateSelectedContact();
      viewData();
      return null;
   }

   public PageReference Next() { //user clicked next button
      counter += list_size;
      
      updateSelectedContact(); 
       System.debug(contactIdSelected);
      viewData();
      return null;
   }

   public PageReference End() { //user clicked end
      counter = total_size - math.mod(total_size, list_size);
      updateSelectedContact();
      viewData();
      return null;
   }
    
    public void updateSelectedContact() {
        
       for(ResultWrapper rw:resultWrapperList) {
           if(rw.selected) {
               contactIdSelected.add(rw.candidate.Id);
           } else {
               contactIdSelected.remove(rw.candidate.Id);
           }
       }
    }

   public Boolean getDisablePrevious() { 
      //this will disable the previous and beginning buttons
      if (counter>0) return false; else return true;
   }

   public Boolean getDisableNext() { //this will disable the next and end buttons
      if (counter + list_size < total_size) return false; else return true;
   }

   public Integer getTotal_size() {
      return total_size;
   }

   public Integer getPageNumber() {
      return counter/list_size + 1;
   }
   public Integer getTotalPages() {
      if (math.mod(total_size, list_size) > 0) {
         return total_size/list_size + 1;
      } else {
         return (total_size/list_size);
      }
   }
            
    global class ResultWrapper implements Comparable
    {
        public boolean selected {get;set;}
        public Application__c candidate {get; set;}
        public boolean hasCV {get;set;}
        public boolean Off_Limit_Auto {get; set;}
        public boolean Contact_Off_Limit {get; set;}
        public boolean hasOnePager {get;set;}
        public boolean hasJobDescription {get;set;}
        public DateTime lastModifiedDate {get;set;}
        public String sortBy = 'CV';
        public String sortDirection = 'ASC';
        public String cvId {get;set;}
        public String noteTitle {get;set;}
        
  
        public ResultWrapper()
        {
           
        }
        
        
        public ResultWrapper(Application__c candidate)
        {
            this.candidate = candidate;
            selected = false;
            hasCV = false;
            hasOnePager = false;
            hasJobDescription = false;
            
            system.debug('Present Candidate :'+this.candidate);
            
            
        }

        public Integer compareTo(Object compareTo) {
            // Cast argument to OpportunityWrapper
            ResultWrapper compareToResult = (ResultWrapper)compareTo;
            if(sortBy=='CV') {
                if(hasCV) {
                    if(sortDirection=='ASC')
                        return 1;
                    else
                        return -1;
                } else {
                    if(sortDirection!='ASC')
                        return 1;
                    else
                        return -1;
                }
            } else if(sortBy=='OnePager') {
                if(hasOnePager) {
                    if(sortDirection=='ASC')
                        return 1;
                    else
                        return -1;
                } else {
                    if(sortDirection!='ASC')
                        return 1;
                    else
                        return -1;
                }
            } else if(sortBy=='JobDescription') {
                if(hasJobDescription) {
                    if(sortDirection=='ASC')
                        return 1;
                    else
                        return -1;
                } else {
                    if(sortDirection!='ASC')
                        return 1;
                    else
                        return -1;
                }
            } else {
                if(lastModifiedDate>compareToResult.lastModifiedDate) {
                    if(sortDirection=='ASC')
                        return 1;
                    else
                        return -1;
                } else {
                    if(sortDirection!='ASC')
                        return 1;
                    else
                        return -1;
                }
            }
        }
    }  
    
    public class AttachWrapper
    {
        public boolean selected {get; set;}        
        public Attachment file {get; set;}
                
        
        public AttachWrapper(Attachment file)
        {
            this.file = file;
            this.selected = false;
        }
    }
    
    
  public PageReference SplitVF()
    {
    
       String getcvid = ApexPages.currentPage().getParameters().get('cvid');
       Id getcontactid = ApexPages.currentPage().getParameters().get('contactid'); 
       Id getcandidateId =ApexPages.currentPage().getParameters().get('candidateId'); 
     //  id getmandateId = ApexPages.currentPage().getParameters().get('mandateId') ;
        PageReference Newpage = new PageReference('/apex/AssignmentCVSplit');
          NewPage.getParameters().put('cvId', getcvid);
          NewPage.getParameters().put('contactId', getcontactid );
          NewPage.getParameters().put('candidateId',getcandidateId);
     //     NewPage.getParameters().put('mandateId',getmandateId);
        system.debug('Fetched CV ID' +getcvid);
        system.debug('Fetched Contact ID' +getcontactid);
        NewPage.setRedirect(false);  
        return NewPage;
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
    
}