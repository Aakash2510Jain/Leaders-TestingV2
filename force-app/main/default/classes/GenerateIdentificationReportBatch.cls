/* **************************************************************************
* Batch Class: GenerateIdentificationReportBatch
* Created by Jesus Varela - C071847, 10/30/2014
*
* Purpose/Methods:
* - Generate 4 reports (Potential Candidates, Human Capital Study on 
* Mandate, and One Pager, Candidate Biography on Contact) 
*
* Unit Test: GenerateIdentificationReportBatchTest
* 
* Modifications:
* - Jesus Varela - 11-12-2014 - Adding Hogan Report C076814 
* - Karyn Cuenca - 02-04-2015 - Adding Job Description and Interview Questionnaire Reports C097250
*
************************************************************************** */
global class GenerateIdentificationReportBatch implements Database.Batchable<sObject>, 
Database.Stateful, Database.AllowsCallouts{
    global static final string HOGAN_REPORT = 'Hogan report';
    //C113325 
    //global static final string IDENTIFICATION_NAME = 'Identification Report';
    global static final string IDENTIFICATION_NAME = 'Leaders Report';
    global static final string POTENTIAL_CANDIDATES = 'Potential Candidates';
    global static final string POTENTIAL_CANDIDATES_BY_TEAM = 'Potential Candidates By Team';
    global static final string POTENTIAL_CANDIDATES_BYSTATUS = 'Potential Candidates By Status';
    global static final string CANDIDATE_TO_DISCUSS = 'CandidateToDiscuss';
    global static final string CANDIDATE_TO_DISCUSS_DEF = 'CandidateToDiscussDef';
    global static final string HUMAN_CAPITAL_STUDY_ON_MANDATE = 'Human Capital Study on Mandate';
    global static final string HUMAN_CAPITAL_STUDY_ON_MANDATE_SSL = 'Human Capital Study on Mandate SSL';
    global static final string ONE_PAGER = 'One Pager';
    global static final string CANDIDATE_BIOGRAPHY_ON_CONTACT = 'Candidate Biography on Contact';
    global static final string CV = 'CV';
    global static final string Board_CV = 'Board_CV';
    global static final string Onboarding = 'Onboarding';
    global static final string JOB_DESCRIPTION = 'Job Description'; 
    global static final string INTERVIEW_QUESTIONNAIRE = 'Interview Questionnaire documents'; 
    global static final string RESEARCH_STRATEGY = 'Research Strategy';
    global static final string Executive_Summary = 'Executive Summary';
    global static final string Executive_Summary_1 = 'Executive Summary 1';
    global static final string COVER_PAGE = 'Cover Page';
    global static final string PARTNER_PAGE = 'Partner Page';
    global static final string PSY_TEST = 'Psy Test';    
    global static final string CANDIDATE_INTRO = 'Candidate Introduction Letter';
    global static final string SELF_ASS = 'Self Assessment';
    global static final string REFERENCES = 'References';
    global static final string AGENDA = 'Agenda';
    global static final string COMPETENCY = 'Competency';
    global static final string CANDIDATE_STATUS = 'CandidateByStatus';
    global static final string ALL_COMPETENCIES = 'AllCompetencies';
    global static final string CANDIDATE_COVERPAGE = 'CandidateCoverPage';
    global static final string RadarGraph = 'RadarGraph';
    global static final string CANDIDATE_GENDER = 'CandidateByGender';
    global static final string CANDIDATE_REGION = 'CandidateByRegion';
    global static final string CANDIDATE_EXPERIENCE = 'CandidateByYearsExperience';
    global static final string CANDIDATE_EDUCATION = 'CandidateByEducationLevel';
    global static final string CANDIDATE_REVENUE = 'CandidateByRevenue';
   
    
    global id mandateId;
    global date startDate;
    global date endDate;
    global string nextFollowUp;
    global string reportCover;
    global List<String> reportsNames;
    global Set<String> reportsNamesSet;
    global integer orderNumber = 1;
    global Mandate__c mandate;
    global string language;
    global id userId;
    global list<ReportWrapper> generatedReports = new list<ReportWrapper>();
    global List<Id> candidatesIds;
    global String prefixReportName;
    global Boolean isColeman;
    global String candidatesString;
    
    global  APXTConga4__Conga_Merge_Query__c   queryConga;
    
    global GenerateIdentificationReportBatch(List<string> repNames, id mId,
                                             date sDate, date eDate, string lang, id uId, string nextFUp, string repCov, String Candidates, String pReportName, Boolean isColemanProfile)
    {
        system.debug('start date '+sDate);
        system.debug('end date '+eDate);
        //C115461 Cristina Sananez 
        //If no candidate match InternalTopStatus, it should still be possible 
        //to access and generate the Report Generation page.
        if (Candidates!='' && Candidates!=null){
            candidatesIds = Candidates.split(',', 0);
        }else{
            candidatesIds=new List<id>();
        }
        
        
        
        
        
        candidatesString = '';
        
        Integer i=0;
        for(Application__c  app: [SELECT Contact__c FROM Application__c WHERE Id IN: candidatesIds]) {
            if(i>0)
                candidatesString += ' , ';
            candidatesString += '\''+app.Contact__c+'\''; 
            i++;
        }
        
        prefixReportName = pReportName;
        isColeman = isColemanProfile;
        mandateId = mId;
        reportsNames = repNames;
        reportsNamesSet = new Set<String>();
        reportsNamesSet.addAll(repNames);
        startDate = sDate;
        endDate = eDate.addDays(1);
        nextFollowUp = nextFUp;
        reportCover = repCov;
        language = lang;
        userId = uId;
        List<Mandate__c> mandateList = [Select name, Human_Capital_Conga_Link__c, 
                                        Potential_Candidates_Conga_Link__c, Potential_Candidates_Conga_Link_2__c,
                                        Human_Capital_Template_EN__c,
                                        Human_Capital_Template_FR__c, Potential_Candidates_Template_EN__c,
                                        Potential_Candidates_Template_FR__c, Cover_Template_EN__c,
                                        Cover_Template_FR__c, Cover_Conga_Link__c, Human_Capital_Report_FR__c,
                                        Human_Capital_Report_EN__c, Confidential__c, Company_Name_French__c,
                                        Human_Capital_Coleman_Conga_Link__c, Human_Capital_SSL_Conga_Link__c,
                                        Human_Capital_SSL_Report__c,Human_Capital_SSL_Report_EN__c,Human_Capital_SSL_Report_FR__c,                          
                                        
                                        Company__r.Name, Language__c,
                                        candidate_gender_conga_link__c,
                                        Candidate_education_conga_link__c,
                                        Candidate_experience_conga_link__c,
                                        Candidate_region_conga_link__c,
                                        Candidate_revenue_conga_link__c,
                                        Candidate_status_conga_link__c,
                                        
                                        Chart_CandidatesByStatus_conga_link__c,
                                        Chart_AllCompetencies_conga_link__c,
                                        Chart_Candidate_to_discute_conga_link__c,
                                        
                                        Chart_Competencies_1_conga_link__c,                            
                                        Chart_Competencies_2_conga_link__c,                            
                                        Chart_Competencies_3_conga_link__c,
                                        Chart_Competencies_4_conga_link__c,
                                        Chart_Competencies_5_conga_link__c,
                                        Chart_Competencies_6_conga_link__c,
                                        Chart_Competencies_7_conga_link__c,
                                        Chart_Competencies_8_conga_link__c                            
                                        From Mandate__c where Id =:mandateId];
        if(mandateList.size() > 0){
            mandate = mandateList[0];           
        }
        
        
        
        String soqlCongaQuery = ' SELECT Id, Potential_Candidates_For_Conga__c ,Candidate_Assigned__c, Contact__c, ContactName__c , Contact__r.Name, Current_Company__c , Current_Title__c, Contact__r.MailingCity, Total_salary__c, Status_Summary_Line__c, City__c , Description__c   FROM Meeting_Note__c  WHERE Most_Recent__c = TRUE AND Contact__c  IN ('+candidatesString+') AND Candidate_Assigned__r.Mandate__c  = \''+mandateId+'\' ORDER BY ContactLastName__c ' ;
        queryConga = new APXTConga4__Conga_Merge_Query__c(APXTConga4__Query__c =soqlCongaQuery);
        insert queryConga; 
        
        
        
        
    }   
    global Database.QueryLocator start(Database.BatchableContext BC){
        system.debug('[GenerateIdentificationReportBatch] start '+reportsNames);  
        String companyName = CongaHelperTool.getCompanyName(mandate,language);
        
        if (reportsNamesSet.contains(COVER_PAGE) && mandate!= null){
            String coverName = CongaHelperTool.getReportName('Cover',mandate.name,language);            
            String titleName = CongaHelperTool.getTitleName(mandate,language);
            string attachId = CongaHelperTool.generateReport(IdentificationReportURLManager.getCoverURL(mandate, language),coverName,companyName,titleName,nextFollowUp);
            ReportWrapper cover = new ReportWrapper();
            cover.attachmentId = attachId;
            cover.order = orderNumber;
            //rep.reportName = POTENTIAL_CANDIDATES;
            generatedReports.add(cover);
            orderNumber++;
        }       
        
        string langabb = 'EN';
        if(language.toLowerCase() =='french'){  
            langabb = 'FR';
        }
        
        /*** Chart Reports ***/
        if(reportsNamesSet.contains(CANDIDATE_STATUS) && mandate!= null){        	
            String name = CongaHelperTool.getReportName(CANDIDATE_STATUS, mandate.name, language);          
            string attachmentId = CongaHelperTool.generateReport(mandate.Chart_CandidatesByStatus_conga_link__c , name, null, null, null);
            
            ReportWrapper rep = new ReportWrapper();
            rep.attachmentId = attachmentId;
            rep.order = orderNumber;
            generatedReports.add(rep);    
            orderNumber++;
        }
        
        if(reportsNamesSet.contains(ALL_COMPETENCIES) && mandate!= null){        	
            String name = CongaHelperTool.getReportName(ALL_COMPETENCIES, mandate.name, language);          
            string attachmentId = CongaHelperTool.generateReport(mandate.Chart_AllCompetencies_conga_link__c , name, null, null, null);
            
            ReportWrapper rep = new ReportWrapper();
            rep.attachmentId = attachmentId;
            rep.order = orderNumber;
            generatedReports.add(rep);
            orderNumber++;
        }
        
        if(reportsNamesSet.contains(CANDIDATE_TO_DISCUSS) && mandate!= null){        	
            String name = CongaHelperTool.getReportName(CANDIDATE_TO_DISCUSS, mandate.name, language); 
            System.debug('mandate.Chart_Candidate_to_discute_conga_link__c'+mandate.Chart_Candidate_to_discute_conga_link__c);
            string attachmentId = CongaHelperTool.generateReport(mandate.Chart_Candidate_to_discute_conga_link__c  , name, null, null, null);
            
            ReportWrapper rep = new ReportWrapper();
            rep.attachmentId = attachmentId;
            rep.order = orderNumber;
            generatedReports.add(rep); 
            orderNumber++;
        }
        
        for(String reportName: reportsNames) { 
            if(reportName.startsWith('COMPETENCY__')) {
                Integer chartNumber = Integer.ValueOf(reportName.replaceAll('COMPETENCY__', ''));
                String name = CongaHelperTool.getReportName('CustomCompetency_'+reportName.replaceAll('COMPETENCY__', ''), mandate.name, language);   
                string attachmentId = null;
                if(chartNumber==1)
                    attachmentId = CongaHelperTool.generateReport(mandate.Chart_Competencies_1_conga_link__c   , name, null, null, null);
                else if(chartNumber==2)
                    attachmentId = CongaHelperTool.generateReport(mandate.Chart_Competencies_2_conga_link__c   , name, null, null, null);
                else if(chartNumber==3)
                    attachmentId = CongaHelperTool.generateReport(mandate.Chart_Competencies_3_conga_link__c   , name, null, null, null);
                else if(chartNumber==4)
                    attachmentId = CongaHelperTool.generateReport(mandate.Chart_Competencies_4_conga_link__c   , name, null, null, null);
                else if(chartNumber==5)
                    attachmentId = CongaHelperTool.generateReport(mandate.Chart_Competencies_5_conga_link__c   , name, null, null, null);
                else if(chartNumber==6)
                    attachmentId = CongaHelperTool.generateReport(mandate.Chart_Competencies_6_conga_link__c   , name, null, null, null);
                else if(chartNumber==7)
                    attachmentId = CongaHelperTool.generateReport(mandate.Chart_Competencies_7_conga_link__c   , name, null, null, null);
                else if(chartNumber==8)
                    attachmentId = CongaHelperTool.generateReport(mandate.Chart_Competencies_8_conga_link__c   , name, null, null, null);
                
                ReportWrapper rep = new ReportWrapper();
                rep.attachmentId = attachmentId;
                rep.order = orderNumber;
                generatedReports.add(rep); 
                orderNumber++;
            }
        }
        
        if(reportsNamesSet.contains(CANDIDATE_GENDER) && mandate!= null){        	
            String name = CongaHelperTool.getReportName(CANDIDATE_GENDER, mandate.name, language);          
            string attachmentId = CongaHelperTool.generateReport(mandate.candidate_gender_conga_link__c, name, null, null, null);
            ReportWrapper rep = new ReportWrapper();
            rep.attachmentId = attachmentId;
            rep.order = orderNumber;
            generatedReports.add(rep);
            orderNumber++;
        }
        
        if(reportsNamesSet.contains(CANDIDATE_REGION) && mandate!= null){        	
            String name = CongaHelperTool.getReportName(CANDIDATE_REGION, mandate.name, language);          
            string attachmentId = CongaHelperTool.generateReport(mandate.Candidate_region_conga_link__c, name, null, null, null);
            ReportWrapper rep = new ReportWrapper();
            rep.attachmentId = attachmentId;
            rep.order = orderNumber;
            generatedReports.add(rep);
            orderNumber++;
        }
        
        if(reportsNamesSet.contains(CANDIDATE_EXPERIENCE) && mandate!= null){        	
            String name = CongaHelperTool.getReportName(CANDIDATE_EXPERIENCE, mandate.name, language);          
            string attachmentId = CongaHelperTool.generateReport(mandate.Candidate_experience_conga_link__c, name, null, null, null);
            ReportWrapper rep = new ReportWrapper();
            rep.attachmentId = attachmentId;
            rep.order = orderNumber;
            generatedReports.add(rep);
            orderNumber++;
        }
        
        if(reportsNamesSet.contains(CANDIDATE_EDUCATION) && mandate!= null){        	
            String name = CongaHelperTool.getReportName(CANDIDATE_EDUCATION, mandate.name, language);          
            string attachmentId = CongaHelperTool.generateReport(mandate.Candidate_education_conga_link__c, name, null, null, null);
            ReportWrapper rep = new ReportWrapper();
            rep.attachmentId = attachmentId;
            rep.order = orderNumber;
            generatedReports.add(rep);
            orderNumber++;
        }
        
        if(reportsNamesSet.contains(CANDIDATE_REVENUE) && mandate!= null){        	
            String name = CongaHelperTool.getReportName(CANDIDATE_REVENUE, mandate.name, language);          
            string attachmentId = CongaHelperTool.generateReport(mandate.Candidate_revenue_conga_link__c, name, null, null, null);
            ReportWrapper rep = new ReportWrapper();
            rep.attachmentId = attachmentId;
            rep.order = orderNumber;
            generatedReports.add(rep);
            orderNumber++;
        }
        /*** End Chart Reports ***/
        
        if(reportsNamesSet.contains(JOB_DESCRIPTION) && mandate!= null){           
            
            string name = '%'+Label.Job_Description_Report+'%';
            ReportWrapper rep = getReportAttachment(name, orderNumber, langabb, mandate.Id);
            if (rep != null){
                orderNumber++;
                generatedReports.add(rep);
            }           
        }
        
        if(reportsNamesSet.contains(INTERVIEW_QUESTIONNAIRE) && mandate!= null){
            
            string name = '%'+Label.Interview_Questionnaire+'%';
            ReportWrapper rep = getReportAttachment(name, orderNumber, langabb, mandate.Id);
            if (rep != null){
                orderNumber++;
                generatedReports.add(rep);
            }
            
        }
        
        if(reportsNamesSet.contains(RESEARCH_STRATEGY) && mandate!= null){
            
            string name = '%'+Label.Research_Strategy+'%';
            ReportWrapper rep = getReportAttachment(name, orderNumber, langabb, mandate.Id);
            if (rep != null){
                orderNumber++;
                generatedReports.add(rep);
            }
            
        }
        
        if(reportsNamesSet.contains(POTENTIAL_CANDIDATES) && mandate!= null){
            String potentialName = CongaHelperTool.getReportName('Potential Candidates',mandate.name,language);
            system.debug('[GenerateIdentificationReportBatch] generating potential Report ');                   
            //generate Potential Candidates report
            string attachmentId = CongaHelperTool.generateReport(IdentificationReportURLManager.getPotentialCandidateURL(mandate, language),potentialName,companyName,null,null);
            ReportWrapper rep = new ReportWrapper();
            rep.attachmentId = attachmentId;
            rep.order = orderNumber;
            //rep.reportName = POTENTIAL_CANDIDATES;
            generatedReports.add(rep);
            orderNumber++;
        }
        system.debug('[GenerateIdentificationReportBatch] reportsNames '+reportsNames);
        if(reportsNames != null && reportsNames.size() > 0 && mandate!= null) {
            system.debug('[GenerateIdentificationReportBatch] mandateId '+mandateId);
            //C103248 Commented this to change the query. 
            /*return Database.getQueryLocator([Select Contact__c, Contact__r.FirstName,  
Contact__r.LastName, Contact__r.One_Pager_Conga_Link__c,
Contact__r.One_Pager_Template_FR__c, Contact__r.One_Pager_Template_EN__c,
Contact__r.Candidate_Biography_Template_EN__c, Contact__r.Candidate_Biography_Template_FR__c,
Contact__r.Candidate_Biography_Conga_Link__c From Application__c 
where Contact__c != null and Mandate__c = :mandateId 
//AND Potential_Candidate__c = true
and (Status_Summary_Line__c = 'Potential candidate.' 
or Status_Summary_Line__c = 'Candidat(e) potentiel(le).'
or Status_Summary_Line__c = 'Potential candidate interviewed by Leaders & Co. and recommended for interview with the client.' 
or Status_Summary_Line__c = 'Candidat(e) potentiel(le) rencontré(e) en entrevue par Leaders & Cie et recommandé(e) pour entrevue avec le client.'
or Status_Summary_Line__c = 'Candidature potentielle.'
or Status_Summary_Line__c = 'Entrevue avec Leaders & Cie; recommandation pour entrevue avec le client.'
or Status_Summary_Line__c = 'Potential candidate interviewed by the client.'
or Status_Summary_Line__c = 'Potential candidate interviewed by Leaders & Co.'
or Status_Summary_Line__c = 'Potential candidate selected by the client; has accepted the offer of employment.'
or Status_Summary_Line__c = 'Entrevue avec le client effectuée.'
or Status_Summary_Line__c = 'A accepté l\'offre d\'emploi du client.')
order by Contact__r.LastName asc]);*/
            
            system.debug('Select Id, Contact__c, Contact__r.FirstName, '+ 
                         'Contact__r.LastName, Contact__r.One_Pager_Conga_Link__c,'+
                         'Contact__r.One_Pager_Template_FR__c, Contact__r.One_Pager_Template_EN__c,'+
                         'Contact__r.Candidate_Biography_Template_EN__c, Contact__r.Candidate_Biography_Template_FR__c,'+
                         'Contact__r.Candidate_Biography_Conga_Link__c From Application__c '+
                         'where Contact__c != null and Mandate__c = :mandateId and Id IN: candidatesIds'+                
                         'order by Contact__r.LastName asc '+mandateId+' '+candidatesIds);
            //C103248 Alexis Vargas
            system.debug('[Database.getQueryLocator');
            return Database.getQueryLocator([Select Id, Contact__c, Contact__r.FirstName,
                                             Contact__r.LastName, Contact__r.One_Pager_Conga_Link__c,
                                             Contact__r.One_Pager_Template_FR__c, Contact__r.One_Pager_Template_EN__c,
                                             Contact__r.Candidate_Biography_Template_EN__c, Contact__r.Candidate_Biography_Template_FR__c,
                                             Contact__r.Human_Capital_Conga_Link__c,                   
                                             Contact__r.Human_Capital_Template_FR__c,
                                             Contact__r.Human_Capital_Template_EN__c ,
                                             Contact__r.Human_Capital_Template_DE__c ,
                                             Contact__r.Human_Capital_Template__c  ,
                                             Contact__r.Human_Capital_Report__c  ,
                                             Contact__r.Human_Capital_Report_EN__c  ,
                                             Contact__r.Human_Capital_Report_FR__c   ,  
                                             Contact__r.Candidate_Biography_Conga_Link__c,
                                             
                                             Candidate_Cover_Conga_Link__c From Application__c 
                                             where Contact__c != null and Mandate__c = :mandateId and Id IN: candidatesIds                
                                             order by Contact__r.LastName asc]);  
            
            
            
            
        }else{
            system.debug('null');
            return null;
        }
        
    }
    global void execute(Database.BatchableContext BC, 
                        List<sObject> scope){
                            system.debug('[GenerateIdentificationReportBatch] starting batch'); 
                            for(sObject so: scope){
                                Application__c app = (Application__c)so;
                                
                                system.debug('[GenerateIdentificationReportBatch] app '+ app);  
                                
                                
                                //Cover Page per Candidate 
                                if(reportsNamesSet.contains(CANDIDATE_COVERPAGE)) {
                                    
                                    string attId = CongaHelperTool.generateReport(app.Candidate_Cover_Conga_Link__c,null,null,null,null);
                                    system.debug('the coverpage id is'+attId);
                                    ReportWrapper repCover = new ReportWrapper();
                                    repCover.attachmentId = attId;
                                    repCover.order = orderNumber;
                                    orderNumber++;
                                    generatedReports.add(repCover);  
                                }
                                
                                if(reportsNamesSet.contains(CANDIDATE_BIOGRAPHY_ON_CONTACT)){
                                    //generate Candidate Biography on Contact report
                                    string attachmentId = CongaHelperTool.generateReport(IdentificationReportURLManager.getCandidateBiographyURL(app.Contact__r, language),null,null,null,null);
                                    system.debug('the biography id is'+attachmentId);
                                    ReportWrapper rep = new ReportWrapper();
                                    rep.attachmentId = attachmentId;
                                    rep.order = orderNumber;
                                    //rep.reportName = CANDIDATE_BIOGRAPHY_ON_CONTACT;
                                    orderNumber++;
                                    generatedReports.add(rep);  
                                }
                                
                                if(reportsNamesSet.contains(ONE_PAGER)){
                                    //generate One Pager report
                                    string attachmentId = CongaHelperTool.generateReport(IdentificationReportURLManager.getOnePagerURL(app.Contact__r, language),null,null,null,null);
                                    system.debug('the onepager id is'+attachmentId);
                                    ReportWrapper rep = new ReportWrapper();
                                    rep.attachmentId = attachmentId;
                                    rep.order = orderNumber;
                                    //rep.reportName = ONE_PAGER;
                                    orderNumber++;
                                    generatedReports.add(rep);  
                                }
                                
                                //getting CV
                                if(reportsNamesSet.contains(CV)){      
                                    string langabb = 'EN';
                                    if(language.toLowerCase() =='french')   
                                        langabb = 'FR';
                                    string name = '%CV_'+app.Contact__r.FirstName+' '+app.Contact__r.LastName+'_%';
                                    List<Attachment> attachments = [Select id, ParentId, Name 
                                                                    From Attachment where ParentId = :app.Contact__c 
                                                                    and Name like :name and contenttype='application/pdf' order by LastModifiedDate desc];
                                    Id langCV = null;
                                    Id otherLangCV = null;
                                    if(attachments.size() >0){  
                                        for(Attachment att : attachments){
                                            if(att.Name.contains(langabb)){
                                                langCV = att.Id;
                                                break;
                                            }else if(otherLangCV == null){
                                                otherLangCV = att.Id;
                                            }
                                        }
                                        ReportWrapper rep = new ReportWrapper();
                                        rep.attachmentId = (langCV != null)?langCV:otherLangCV;
                                        rep.order = orderNumber;
                                        //rep.reportName = CV;
                                        orderNumber++;
                                        generatedReports.add(rep);
                                    }   
                                }
                                //getting Hogan Report
                                if(reportsNamesSet.contains(HOGAN_REPORT)){        
                                    string langabb = 'EN';
                                    if(language.toLowerCase() =='french')   
                                        langabb = 'FR';
                                    string name = '%'+Label.Hogan_Repor_Name+'%';
                                    List<Attachment> attachments = [Select id, ParentId, Name 
                                                                    From Attachment where ParentId = :app.Contact__c 
                                                                    and Name like :name and contenttype='application/pdf' order by LastModifiedDate desc];
                                    Id langHo = null;
                                    Id otherLangHo = null;
                                    if(attachments.size() >0){  
                                        for(Attachment att : attachments){
                                            if(att.Name.contains(langabb)){
                                                langHo = att.Id;
                                                system.debug('the id of hoganreport is'+langHo);
                                                break;
                                            }else if(otherLangHo == null){
                                                otherLangHo = att.Id;
                                            }
                                        }
                                        ReportWrapper rep = new ReportWrapper();
                                        rep.attachmentId = (langHo != null)?langHo:otherLangHo;
                                        rep.order = orderNumber;
                                        //rep.reportName = CV;
                                        orderNumber++;
                                        generatedReports.add(rep);
                                    }   
                                }
                                
                                
                                //getting Psy Test document
                                if(reportsNamesSet.contains(PSY_TEST)){
                                    system.debug('[GenerateIdentificationReportBatch] PSY_TEST ');
                                    string langabb = 'EN';
                                    if(language.toLowerCase() =='french')   
                                        langabb = 'FR';
                                    string name = '%'+Label.Psy_Test+'%';               
                                    ReportWrapper rep = getReportAttachment(name, orderNumber, langabb, app.Contact__c);
                                    system.debug('[GenerateIdentificationReportBatch] PSY_TEST rep '+rep);
                                    if (rep != null){
                                        orderNumber++;
                                        generatedReports.add(rep);
                                    }
                                    
                                } 
                                
                            }
                            
                            system.debug('[GenerateIdentificationReportBatch] PgeneratedReports '+generatedReports);
                            
                        }
    global void finish(Database.BatchableContext BC){
        System.debug('isColeman =>'+isColeman);
        if(reportsNamesSet.contains(HUMAN_CAPITAL_STUDY_ON_MANDATE) && mandate!= null && !isColeman){
            System.debug('isColeman =>'+isColeman);
            String hCapitalName = CongaHelperTool.getReportName('Human Capital Study',mandate.name,language);
            String companyName = CongaHelperTool.getCompanyName(mandate, language);
            
            Nubik_HumanCapitalStudyController cntrl = new Nubik_HumanCapitalStudyController();  
            //generate Human Capital Study on Mandate report
            string attachmentId = cntrl.generateReport(IdentificationReportURLManager.getHumanCapitalStudyURL(mandate, language), 
                                                       startDate, endDate, hCapitalName, companyName, true);
            ReportWrapper rep = new ReportWrapper();
            rep.attachmentId = attachmentId;
            rep.order = orderNumber;
            //rep.reportName = HUMAN_CAPITAL_STUDY_ON_MANDATE;
            orderNumber++;
            generatedReports.add(rep);  
        }
        
        if(reportsNamesSet.contains(HUMAN_CAPITAL_STUDY_ON_MANDATE) && mandate!= null && isColeman){
            System.debug('isColeman =>'+isColeman);
            //generate HUMAN CAPITAL STUDY on Contact report
            System.debug(IdentificationReportURLManager.getHumanCapitalStudyQueryURL(mandate, queryConga.Id, language));
            
            string attachmentId = CongaHelperTool.generateReport(
                IdentificationReportURLManager.getHumanCapitalStudyQueryURL(mandate, queryConga.Id, language)
                ,null,null,null,null);
            
            //delete queryConga;
            
            ReportWrapper rep = new ReportWrapper();
            rep.attachmentId = attachmentId;
            rep.order = orderNumber;
            orderNumber++;
            generatedReports.add(rep);  
        }
        
        if(reportsNamesSet.contains (HUMAN_CAPITAL_STUDY_ON_MANDATE_SSL) && mandate != null && !isColeman)
        {
            System.debug('isColeman =>'+isColeman);
            String hCapitalName = CongaHelperTool.getReportName('Human Capital Study',mandate.name,language);
            String companyName = CongaHelperTool.getCompanyName(mandate, language);
            
            Nubik_HumanCapitalStudyController cntrl = new Nubik_HumanCapitalStudyController();  
            //generate Human Capital Study on Mandate report
            string attachmentId = cntrl.generateReportSSL(IdentificationReportURLManager.getHumanCapitalStudySSLURL(mandate, language), 
                                                          startDate, endDate, hCapitalName, companyName, true);
            ReportWrapper rep = new ReportWrapper();
            rep.attachmentId = attachmentId;
            rep.order = orderNumber;
            //rep.reportName = HUMAN_CAPITAL_STUDY_ON_MANDATE;
            orderNumber++;
            generatedReports.add(rep);  
        }
        
        
        
        
        system.debug('[GenerateIdentificationReportBatch] generatedReports '+generatedReports);
        if(generatedReports.size() > 0){
            
            if (generatedReports.size() == 1){
                
                String reportName = prefixReportName+'_'+IDENTIFICATION_NAME+'_'+string.valueOf(datetime.now())+'_'+userId+'.pdf';
                Attachment repAttach = [Select body from Attachment where Id = :generatedReports[0].attachmentId];
                Attachment reportAttach = new Attachment();
                reportAttach.Name = reportName;
                reportAttach.Body = repAttach.body;
                reportAttach.ParentId = mandate.Id;
                insert reportAttach;
                
            }else
            {          
                
                String str = JSON.serialize(generatedReports); 
                system.debug('str '+str);
                Http h = new Http();
                HttpRequest req = new HttpRequest();
                req.setEndpoint(Label.PDF_join_Service);
                req.setMethod('POST');
                System.debug('Label.PDF_join_Service '+Label.PDF_join_Service);
                String reportName = prefixReportName+'_'+IDENTIFICATION_NAME+'_'+string.valueOf(datetime.now())+'_'+userId+'.pdf';
                System.debug('reportName: '+reportName);
                System.debug('mandate.Id: '+mandate.Id);
                req.setBody('&name='+reportName+'&files='+str+'&parentId='+mandate.Id);
                req.setTimeout(60000);
                if (!Test.isRunningTest()) {
                    HttpResponse res = h.send(req);
                    System.debug('[GenerateIdentificationReportBatch] response: '+res.getBody());
                }
                
            }
            
            //C098476 Alexis Vargas
            //Database.executeBatch(new CleanIdentificationReportsBatch(mandate.Id));
            
            
        }
    }
    
    public class ReportWrapper{
        public string attachmentId {get; set;}
        public integer order {get; set;}
        //public string reportName {get; set;}
    }
    
    public ReportWrapper getReportAttachment(String name, Integer orderNum, String lang, String parentId){
        
        ReportWrapper rep;
        
        List<Attachment> attachments = [Select id, ParentId, Name 
                                        From Attachment where ParentId = :parentId
                                        and Name like :name and contenttype='application/pdf' 
                                        order by LastModifiedDate desc];
        
        Id langHo = null;
        Id otherLangHo = null;
        if(attachments.size() >0){  
            for(Attachment att : attachments){
                if(att.Name.contains(lang)){
                    langHo = att.Id;
                    break;
                }else if(otherLangHo == null){
                    otherLangHo = att.Id;
                }
            }
            rep = new ReportWrapper();
            rep.attachmentId = (langHo != null)?langHo:otherLangHo;
            rep.order = orderNum;   
            
        }
        
        return rep;
        
    }
}