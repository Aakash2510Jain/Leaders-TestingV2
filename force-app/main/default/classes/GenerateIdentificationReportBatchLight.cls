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
global class GenerateIdentificationReportBatchLight implements Database.Batchable<sObject>, 
Database.Stateful, Database.AllowsCallouts{
    global static final string HOGAN_REPORT = 'Hogan report';
    //C113325 
    //global static final string IDENTIFICATION_NAME = 'Identification Report';
    global static final string IDENTIFICATION_NAME = 'Leaders Report';
    global static final string POTENTIAL_CANDIDATES = 'Potential Candidates';
    global static final string POTENTIAL_CANDIDATES_BYSTATUS = 'Potential Candidates By Status';
    global static final string HUMAN_CAPITAL_STUDY_ON_MANDATE = 'Human Capital Study on Mandate';
    global static final string HUMAN_CAPITAL_STUDY_ON_MANDATE_SSL = 'Human Capital Study on Mandate SSL';
    global static final string ONE_PAGER = 'One Pager';
    global static final string Board_CV = 'Board_CV';
    global static final string Onboarding = 'Onboarding';
    global static final string CANDIDATE_TO_DISCUSS_DEF = 'CandidateToDiscussDef';
    global static final string CANDIDATE_BIOGRAPHY_ON_CONTACT = 'Candidate Biography on Contact';
    global static final string CV = 'CV'; 
    global static final string JOB_DESCRIPTION = 'Job Description'; 
    global static final string INTERVIEW_QUESTIONNAIRE = 'Interview Questionnaire documents'; 
    global static final string RESEARCH_STRATEGY = 'Research Strategy';
    global static final string Executive_Summary = 'Executive Summary';
    global static final string Executive_Summary_1 = 'Executive Summary 1';
    global static final string COVER_PAGE = 'Cover Page';
    global static final string PARTNER_PAGE = 'Partner Page';
    global static final string PSY_TEST = 'Psy Test';
    global static final string REFERENCES = 'References';
    global static final string AGENDA = 'Agenda';
    global static final string CANDIDATE_STATUS = 'CandidateByStatus';
    global static final string ALL_COMPETENCIES = 'AllCompetencies';
    global static final string CANDIDATE_COVERPAGE = 'CandidateCoverPage';
    global static final string SELF_ASS = 'Self Assessment';
    global static final string COMPETENCY = 'Competency'; 
    global static final string POTENTIAL_CANDIDATES_BY_TEAM = 'Potential Candidates By Team';
    global static final string RadarGraph = 'RadarGraph';
    global static final string CANDIDATE_GENDER = 'CandidateByGender';
    global static final string CANDIDATE_REGION = 'CandidateByRegion';
    global static final string CANDIDATE_EXPERIENCE = 'CandidateByYearsExperience';
    global static final string CANDIDATE_EDUCATION = 'CandidateByEducationLevel';
    global static final string CANDIDATE_REVENUE = 'CandidateByRevenue';
    global static final string CANDIDATE_TO_DISCUSS = 'CandidateToDiscuss';
    //global static final List<string> compList = 'CandidateToDiscuss';
    
    global id mandateId;
    global date startDate;
    global date endDate;
    global string nextFollowUp;
    global string reportCover;
    global List<String> reportsNames;
    global static  String selectedSubComp = '';
    global List<String> compList;
    global Set<String> reportsNamesSet;
    global Set<String> allContactsNotesToDelete;
    global integer orderNumber = 1;
    global Mandate__c mandate;
    global string language;
    global id userId;
    global list<ReportWrapper> generatedReports = new list<ReportWrapper>();
    global List<Id> candidatesIds;
    global String prefixReportName;
    global Boolean isColeman;
    global boolean hcsDates;    
    global String candidatesString;
    
    global  APXTConga4__Conga_Merge_Query__c   queryConga;
    global  APXTConga4__Conga_Merge_Query__c   queryCongaPotentialByTeam;
    global  APXTConga4__Conga_Merge_Query__c   queryCongaSSL;
    global  APXTConga4__Conga_Merge_Query__c   queryCongaPotential;
    global  APXTConga4__Conga_Merge_Query__c   queryCongaPotentialWithoutStatus;
    global  APXTConga4__Conga_Merge_Query__c   queryCongaPartner;
    global  APXTConga4__Conga_Merge_Query__c   queryCongaInterview;
    global  APXTConga4__Conga_Merge_Query__c   queryCongaOnePager;
    global  APXTConga4__Conga_Merge_Query__c   QueryforRadar;
    global  APXTConga4__Conga_Merge_Query__c   QueryforRadar_1;
    
    global GenerateIdentificationReportBatchLight(List<string> partners,List<string> repNames,List<string> CompetencyList,List<string> SubCompetencyList,id mId,String HCSSortBy,
                                                  date sDate, date eDate, string lang, id uId, string nextFUp, string repCov, String Candidates, String pReportName, Boolean isColemanProfile )
    {
        
        String HCSSortingOrder = 'Current_Company__c';
        if(HCSSortBy == 'Candidate Name'){
            HCSSortingOrder = 'ContactLastName__c';
        }
        else if( HCSSortBy== 'Status Summary Line'){
            HCSSortingOrder = 'Status_Summary_Line_For_Conga__c ';
        }
        else {
            HCSSortingOrder = 'Current_Company__c';
        }
        System.debug('--- > HCSSortingOrder'+HCSSortingOrder);
        compList = CompetencyList;
        System.debug('--- > repNames'+repNames);
        
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
        Integer j=0;
        String potCandidatesString = '';
        for(Id  canId: candidatesIds) {
            if(j>0)
                potCandidatesString += ' , ';
            potCandidatesString += '\''+canId+'\'';
            j++;
        }
        
        
        prefixReportName = pReportName;
        isColeman = isColemanProfile;
        //    hcsDates = humanCapitalStudyDates;
        mandateId = mId;
        reportsNames = repNames;
        reportsNamesSet = new Set<String>();
        allContactsNotesToDelete = new Set<String>();
        reportsNamesSet.addAll(repNames);
        startDate = sDate;
        if(eDate <> null)
            eDate = eDate.addDays(1);
        
        system.debug('start date '+startDate);
        system.debug('end date '+endDate);
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
                                        User_By_Partner_Link__c,
                                        User_By_Partner_Link_Fr__c,
                                        CandidateBySSL_Link__c,
                                        Candidate_To_Discuss_Fr__c,
                                        Candidate_To_Discuss_En__c,
                                        Mandate_from_Candidate_Team_Fr__c,
                                        Mandate_from_Candidate__c,
                                        Mandate_from_Candidate_Fr__c,
                                        Company__r.Name, Language__c,
                                        candidate_gender_conga_link__c,
                                        Candidate_education_conga_link__c,
                                        Candidate_experience_conga_link__c,
                                        Candidate_region_conga_link__c,
                                        Candidate_revenue_conga_link__c,
                                        Candidate_status_conga_link__c,
                                        candidate_ssl_word__c,
                                        SecondPage_URL__c,
                                        Schedule_Interview_Link__c,
                                        Schedule_Interview_Link_Fr__c,
                                        Chart_CandidatesByStatus_conga_link__c,
                                        Chart_AllCompetencies_conga_link__c,
                                        Chart_Candidate_to_discute_conga_link__c,
                                        candidate_ssl_word_French__c,
                                        Chart_Competencies_1_conga_link__c,                            
                                        Chart_Competencies_2_conga_link__c,                            
                                        Chart_Competencies_3_conga_link__c,
                                        Chart_Competencies_4_conga_link__c,
                                        Chart_Competencies_5_conga_link__c,
                                        Chart_Competencies_6_conga_link__c,
                                        Chart_Competencies_7_conga_link__c,
                                        Chart_Competencies_8_conga_link__c,
                                        
                                        Cover_Conga_Link_Lightning__c,
                                        Human_Capital_Coleman_Conga_LinkLightnig__c,
                                        Human_Capital_Conga_Link_Lightning__c,
                                        Human_Capital_SSL_Conga_Link_Lightning__c,
                                        Potential_Candidates_Conga_LinkLightning__c,
                                        Potential_Candidate_Conga_Lightning__c,
                                        Mandate_from_Candidate_Team__c,
                                        Human_Capital_Template_Lightning_EN__c,
                                        Human_Capital_Template_Lightning_FR__c
                                        
                                        From Mandate__c where Id =:mandateId];
        if(mandateList.size() > 0){
            mandate = mandateList[0];           
        }
        
        if(repNames.contains(HUMAN_CAPITAL_STUDY_ON_MANDATE_SSL) && sDate != null && eDate != null && language== 'English'){
            
            String soqlCongaQuery = 'SELECT Candidate_Assigned__c,Candidate_Assigned__r.LastModifiedDate, City__c,Company__c, Contact__c, Contact_ID__c, ContactLastName__c, ContactName__c, Created_by_team__c, CreatedById, CreatedDate, Current_Company__c, Current_Company_French__c, Current_Title__c, Current_Title_French__c, Description__c, Id, IsDeleted, LastActivityDate, LastModifiedById, LastModifiedDate, LastReferencedDate, LastViewedDate, Location__c, Madate_Id__c, Most_Recent__c, Name, Potential_Candidates_For_Conga__c, Private__c, RecordTypeId, Related_Mandate__c, Salary__c, ' +
                'Status_Summary_Line__c,Status_Summary_Line_French__c , Status_Summary_Line_For_Conga__c, Status_Summary_Line_Type__c, SystemModstamp, Title_del__c, Total_salary__c FROM Meeting_Note__c WHERE  Most_Recent__c=true AND  (Status_Summary_Line__c!= \''+'Client.'+'\') AND (Status_Summary_Line__c!= \''+'Private'+'\') AND (Status_Summary_Line__c!= \''+'Source [Not included in the report].'+'\') AND (Status_Summary_Line__c!= \''+''+'\') AND Madate_Id__c = \''+(String.valueOf(mandateId)).left(15)+'\' and LastModifiedDate>='+String.valueOf(sDate)+'T00:00:00Z'+' and LastModifiedDate<='+String.valueOf(eDate)+'T00:00:00Z'+' ORDER BY '+ HCSSortingOrder+' ASC ' ;
            queryCongaSSL = new APXTConga4__Conga_Merge_Query__c(APXTConga4__Query__c =soqlCongaQuery);
            insert queryCongaSSL;
            system.debug('!st one');
        }
        else if(repNames.contains(HUMAN_CAPITAL_STUDY_ON_MANDATE_SSL) && sDate != null && eDate != null && language== 'French'){
            
            String soqlCongaQuery = 'SELECT Candidate_Assigned__c,Candidate_Assigned__r.LastModifiedDate, City__c, Company__c, Contact__c, Contact_ID__c, ContactLastName__c, ContactName__c, Created_by_team__c, CreatedById, CreatedDate, Current_Company__c, Current_Company_French__c, Current_Title__c, Current_Title_French__c, Description__c, Id, IsDeleted, LastActivityDate, LastModifiedById, LastModifiedDate, LastReferencedDate, LastViewedDate, Location__c, Madate_Id__c, Most_Recent__c, Name, Potential_Candidates_For_Conga__c, Private__c, RecordTypeId, Related_Mandate__c, Salary__c, ' +
                'Status_Summary_Line__c, Status_Summary_Line_French__c ,Status_Summary_Line_For_Conga__c,Status_Summary_Line_Type__c, SystemModstamp, Title_del__c, Total_salary__c FROM Meeting_Note__c WHERE Most_Recent__c=true AND (Status_Summary_Line__c!= \''+'Client.'+'\') AND (Status_Summary_Line__c!= \''+'Private'+'\') AND (Status_Summary_Line__c!= \''+'Source [Not included in the report].'+'\') AND (Status_Summary_Line__c!= \''+''+'\') AND Madate_Id__c = \''+(String.valueOf(mandateId)).left(15)+'\' and LastModifiedDate>='+String.valueOf(sDate)+'T00:00:00Z'+' and LastModifiedDate<='+String.valueOf(eDate)+'T00:00:00Z'+' ORDER BY '+ HCSSortingOrder+'ASC ' ;
            queryCongaSSL = new APXTConga4__Conga_Merge_Query__c(APXTConga4__Query__c =soqlCongaQuery);
            insert queryCongaSSL;
            system.debug('2nd one');
        }
        
        else if(repNames.contains(HUMAN_CAPITAL_STUDY_ON_MANDATE) && sDate != null && eDate != null && language== 'English'){
            String soqlCongaQuery = ' SELECT Id, Status_Summary_Line_French__c ,Potential_Candidates_For_Conga__c ,Candidate_Assigned__c, Contact__c,Location__c, ContactName__c ,Contact__r.LastName, Contact__r.Name, Current_Company__c ,Current_Company_French__c, Current_Title__c,Current_Title_French__c, Contact__r.MailingCity, Total_salary__c, Status_Summary_Line__c,Status_Summary_Line_For_Conga__c, City__c , Description__c   FROM Meeting_Note__c  WHERE Most_Recent__c=true AND (Status_Summary_Line__c!= \''+'Client.'+'\') AND (Status_Summary_Line__c!= \''+'Private'+'\') AND (Status_Summary_Line__c!= \''+'Source [Not included in the report].'+'\') AND (Status_Summary_Line__c!= \''+''+'\') AND Candidate_Assigned__r.Mandate__c  = \''+mandateId+'\' and LastModifiedDate>='+String.valueOf(sDate)+'T00:00:00Z'+' and LastModifiedDate<='+String.valueOf(eDate)+'T00:00:00Z'+' ORDER BY '+ HCSSortingOrder+ ' ASC ' ;
            queryConga = new APXTConga4__Conga_Merge_Query__c(APXTConga4__Query__c =soqlCongaQuery);
            insert queryConga;
            system.debug('3rd one');
        }
        
        else if(repNames.contains(HUMAN_CAPITAL_STUDY_ON_MANDATE) && sDate != null && eDate != null && language== 'French'){
            String soqlCongaQuery = ' SELECT Id, Potential_Candidates_For_Conga__c ,Status_Summary_Line_French__c,Candidate_Assigned__c, Contact__c,Location__c, ContactName__c , Contact__r.Name, Current_Company__c ,Current_Company_French__c, Current_Title__c,Current_Title_French__c, Contact__r.MailingCity, Total_salary__c, Status_Summary_Line__c,Status_Summary_Line_For_Conga__c, City__c , Description__c   FROM Meeting_Note__c   WHERE Most_Recent__c=true AND  (Status_Summary_Line__c!= \''+'Client.'+'\') AND (Status_Summary_Line__c!= \''+'Private'+'\') AND (Status_Summary_Line__c!= \''+'Source [Not included in the report].'+'\') AND (Status_Summary_Line__c!= \''+''+'\') AND Candidate_Assigned__r.Mandate__c  = \''+mandateId+'\' and LastModifiedDate>='+String.valueOf(sDate)+'T00:00:00Z'+' and LastModifiedDate<='+String.valueOf(eDate)+'T00:00:00Z'+' ORDER BY '+ HCSSortingOrder+ ' ASC ' ;
            queryConga = new APXTConga4__Conga_Merge_Query__c(APXTConga4__Query__c =soqlCongaQuery);
            insert queryConga;
            system.debug('4th one');
        }
        
        String soqlCongaQueryPotential = 'Select Contact_Email__c,Contact_Full_Name__c,mandate_company_name__c ,Client_Company__c,Interview_Date__c,Interview_Date_formula__c,Interview_Time__c, Phone__c, Last_Name__c,Status_Summary_Line__c,Status_Summary_Line_For_Conga__c,Status_Summary_Line_French__c, First_Name__c, Current_Company_EN__c, Current_Title__c, Current_Title_French__c, Current_Company_French__c, Mandate__r.Name, Mandate_Language__c,Mandate__r.Company_Name_French__c from Application__c where Id IN ('+potCandidatesString+') and Mandate__r.Id = \''+(String.valueOf(mandateId)).left(15)+'\' ORDER BY is_Potential__c DESC,Status_Summary_Line__c DESC,Last_Name__c ASC';
        queryCongaPotential = new APXTConga4__Conga_Merge_Query__c(APXTConga4__Query__c =soqlCongaQueryPotential);
        insert queryCongaPotential;
        
        String soqlCongaQueryPotentialwithoutStatus = 'Select Contact_Email__c,Client_Company__c,mandate_company_name__c ,Contact_Full_Name__c,Interview_Date__c,Interview_Date_formula__c,Interview_Time__c, Phone__c, Last_Name__c,Status_Summary_Line__c,Status_Summary_Line_For_Conga__c,Status_Summary_Line_French__c, First_Name__c, Current_Company_EN__c, Current_Title__c, Current_Title_French__c, Current_Company_French__c, Mandate__r.Name, Mandate_Language__c,Mandate__r.Company_Name_French__c from Application__c where Id IN ('+potCandidatesString+') and Mandate__r.Id = \''+(String.valueOf(mandateId)).left(15)+'\' ORDER BY Last_Name__c ASC';
        queryCongaPotentialWithoutStatus = new APXTConga4__Conga_Merge_Query__c(APXTConga4__Query__c =soqlCongaQueryPotentialwithoutStatus);
        insert queryCongaPotentialWithoutStatus;
        
        String soqlCongaQueryPotentialByTeam = 'Select Contact_Email__c,Contact_Full_Name__c,mandate_company_name__c ,Interview_Date__c,Interview_Date_formula__c,Interview_Time__c, Phone__c, Last_Name__c,Status_Summary_Line__c,Status_Summary_Line_French__c,Status_Summary_Line_For_Conga__c,First_Name__c, Current_Company_EN__c, Current_Title__c, Current_Title_French__c, Current_Company_French__c, Mandate__r.Name, Mandate_Language__c,Mandate__r.Company_Name_French__c from Application__c where Id IN ('+potCandidatesString+') and Mandate__r.Id = \''+(String.valueOf(mandateId)).left(15)+'\' ORDER BY Current_Company_French__c ASC';
        queryCongaPotentialByTeam = new APXTConga4__Conga_Merge_Query__c(APXTConga4__Query__c = soqlCongaQueryPotentialByTeam);
        insert queryCongaPotentialByTeam;
        
        String soqlCongaScheduledcandidate = 'Select Contact_Email__c,Contact_Full_Name__c,Current_Company_EN__c,Current_Title__c,Interview_Date__c,Interview_Date_formula__c,Interview_Date_formula_fr__c,Interview_Time__c, Phone__c from Application__c where  Mandate__c = \''+(String.valueOf(mandateId)).left(15)+'\' AND Interview_Date__c != null ORDER BY Interview_Date_formula__c ASC';
        queryCongaInterview = new APXTConga4__Conga_Merge_Query__c(APXTConga4__Query__c =soqlCongaScheduledcandidate);
        insert queryCongaInterview;
        
        String PartnerIds  =  'SELECT Researcher__c,Researcher_3__c,Researcher_4__c,Researcher_5__c,Consultant__c,Partner_2__c,Partner_3__c,Partner__c FROM Mandate__c where id =:mandateId';    
        List<Mandate__C> manlist = database.query(PartnerIds);
        
        Integer k=0;
        String partnerIdString = '';
        if(!partners.isEmpty()){
            for(String  partner: partners) {
                if(k>0)
                    partnerIdString += ' , ';
                partnerIdString += '\''+partner+'\'';
                k++;
            }
        }
        system.debug('partnerIdString'+partnerIdString);
        
        String soqlCongaQueryforuser = 'SELECT Email,Name,Phone,Title FROM User where Id IN ('+partnerIdString+')';
        queryCongaPartner = new APXTConga4__Conga_Merge_Query__c(APXTConga4__Query__c =soqlCongaQueryforuser);
        insert queryCongaPartner;
        
        Integer m=0;
        
        string cand = '';
        if(!candidatesIds.isEmpty()){
            for(String  can: candidatesIds) {
                if(m>0)
                    cand += ' , ';
                cand += '\''+can+'\'';
                m++;
            }
        }
        Integer l=0;
        String subCompetencyString = '';
        if(!SubCompetencyList.isEmpty()){
            for(String  subComp: SubCompetencyList) {
                if(l>0)
                    subCompetencyString += ' , ';
                subCompetencyString += '\''+subComp+'\'';
                l++;
            }
        }
        system.debug('candidatesIds'+Candidates);
        system.debug('SubCompetencyList'+subCompetencyString);
    }   
    global Database.QueryLocator start(Database.BatchableContext BC){
        
        system.debug('[GenerateIdentificationReportBatchLight] start '+reportsNames);
        String companyName = CongaHelperTool.getCompanyName(mandate,language);
        
        Id currentUserProfile = UserInfo.getProfileId();
        String profileName = [Select Name from Profile where Id = :currentUserProfile].Name;
        
        if (reportsNamesSet.contains(COVER_PAGE) && mandate!= null){
            if(profileName == 'Force.com Leaders team 3 + BusDev'){
                String coverName = CongaHelperToolLightning.getReportName('Cover',mandate.name,language);            
                String titleName = CongaHelperToolLightning.getTitleName(mandate,language);
                string attachId = CongaHelperToolLightning.generateReport(IdentificationReportURLManagerLightning.getCoverURL(mandate, language),coverName,companyName,titleName,nextFollowUp);
                ReportWrapper cover = new ReportWrapper();
                cover.attachmentId = attachId;
                cover.order = orderNumber;
                //rep.reportName = POTENTIAL_CANDIDATES;
                generatedReports.add(cover);
                orderNumber++;
            }else{
                string attId = CongaHelperToolLightning.generateReport(IdentificationReportURLManagerLightning.getUserDetailsOfPArtnerLightningURL(mandate,queryCongaPartner.Id,language),'Cover Page - 1',companyName,null,null);
                system.debug('attachmentIds'+attId);
                ReportWrapper cover = new ReportWrapper();
                cover.attachmentId = attId;
                cover.order = orderNumber;
                generatedReports.add(cover);
                orderNumber++;  
            }
        }  
        
        if (reportsNamesSet.contains(PARTNER_PAGE) && mandate!= null && profileName != 'Force.com Leaders team 3 + BusDev'){
            string attIdSecondPage = CongaHelperToolLightning.generateReport(IdentificationReportURLManagerLightning.getSecondPageLightningURL(mandate,queryCongaPartner.Id,language),'Cover Page - 2',companyName,null,null);
            system.debug('attachmentIds'+attIdSecondPage);
            ReportWrapper coverSecond = new ReportWrapper();
            coverSecond.attachmentId = attIdSecondPage;
            coverSecond.order = orderNumber;
            generatedReports.add(coverSecond);
            orderNumber++;  
        }
        
        System.debug('---> aft cover page generatedReports'+generatedReports);
        string langabb;
        if(language.toLowerCase() =='english' || language.toLowerCase() == null)
        {  
            langabb = 'EN';
        }
        if(language.toLowerCase() =='french'){  
            langabb = 'FR';
        }
        
        /*** Chart Reports ***/
        if(reportsNamesSet.contains(CANDIDATE_STATUS) && mandate!= null){          
            /*String name = CongaHelperToolLightning.getReportName(CANDIDATE_STATUS, mandate.name, language);          
string attachmentId = CongaHelperToolLightning.generateReport(mandate.Chart_CandidatesByStatus_conga_link__c , name, null, null, null);

ReportWrapper rep = new ReportWrapper();
rep.attachmentId = attachmentId;
rep.order = orderNumber;
generatedReports.add(rep);    
orderNumber++;*/
            string attachmentId = CongaHelperToolLightning.generateReport(IdentificationReportURLManagerLightning.getCandidateCountByStatusURL(mandate,language),null,null,null,null);
            // string attachmentId = CongaHelperToolLightning.generateReport(mandate.candidate_ssl_word__c,null,null,null,null);      
            system.debug('attachmentId '+attachmentId);
            ReportWrapper rep = new ReportWrapper();
            rep.attachmentId = attachmentId;
            rep.order = orderNumber;
            generatedReports.add(rep);    
            orderNumber++;
        }
        
        
        if(reportsNamesSet.contains(COMPETENCY) && mandate!= null){
            for(String compval:compList){
                string attachmentId = CongaHelperToolLightning.generateReport(IdentificationReportURLManagerLightning.getCompetencyLightningURL(mandate,language,compval),'Competency',null,null,null);
                system.debug('attachmentId '+attachmentId);
                ReportWrapper rep = new ReportWrapper();
                rep.attachmentId = attachmentId;
                rep.order = orderNumber;
                generatedReports.add(rep);    
                orderNumber++;
            }
        }
        
        /*  if(reportsNamesSet.contains(ALL_COMPETENCIES) && mandate!= null){          
String name = CongaHelperToolLightning.getReportName(ALL_COMPETENCIES, mandate.name, language);          
string attachmentId = CongaHelperToolLightning.generateReport(mandate.Chart_AllCompetencies_conga_link__c , name, null, null, null);

ReportWrapper rep = new ReportWrapper();
rep.attachmentId = attachmentId;
rep.order = orderNumber;
generatedReports.add(rep);
orderNumber++;
} */
        if(reportsNamesSet.contains(CANDIDATE_TO_DISCUSS) && mandate!= null){      
            String name = CongaHelperToolLightning.getReportName(CANDIDATE_TO_DISCUSS, mandate.name, language);          
            string attachmentId = CongaHelperToolLightning.generateReport(mandate.Chart_Candidate_to_discute_conga_link__c  , name, null, null, null);
            
            ReportWrapper rep = new ReportWrapper();
            rep.attachmentId = attachmentId;
            rep.order = orderNumber;
            generatedReports.add(rep); 
            orderNumber++;
        }
       
        /*  for(String reportName: reportsNames) { 
if(reportName.startsWith('COMPETENCY__')) {
Integer chartNumber = Integer.ValueOf(reportName.replaceAll('COMPETENCY__', ''));
String name = CongaHelperToolLightning.getReportName('CustomCompetency_'+reportName.replaceAll('COMPETENCY__', ''), mandate.name, language);   
string attachmentId = null;
if(chartNumber==1)
attachmentId = CongaHelperToolLightning.generateReport(mandate.Chart_Competencies_1_conga_link__c   , name, null, null, null);
else if(chartNumber==2)
attachmentId = CongaHelperToolLightning.generateReport(mandate.Chart_Competencies_2_conga_link__c   , name, null, null, null);
else if(chartNumber==3)
attachmentId = CongaHelperToolLightning.generateReport(mandate.Chart_Competencies_3_conga_link__c   , name, null, null, null);
else if(chartNumber==4)
attachmentId = CongaHelperToolLightning.generateReport(mandate.Chart_Competencies_4_conga_link__c   , name, null, null, null);
else if(chartNumber==5)
attachmentId = CongaHelperToolLightning.generateReport(mandate.Chart_Competencies_5_conga_link__c   , name, null, null, null);
else if(chartNumber==6)
attachmentId = CongaHelperToolLightning.generateReport(mandate.Chart_Competencies_6_conga_link__c   , name, null, null, null);
else if(chartNumber==7)
attachmentId = CongaHelperToolLightning.generateReport(mandate.Chart_Competencies_7_conga_link__c   , name, null, null, null);
else if(chartNumber==8)
attachmentId = CongaHelperToolLightning.generateReport(mandate.Chart_Competencies_8_conga_link__c   , name, null, null, null);

ReportWrapper rep = new ReportWrapper();
rep.attachmentId = attachmentId;
rep.order = orderNumber;
generatedReports.add(rep); 
orderNumber++;
}
} */
        if(reportsNamesSet.contains(CANDIDATE_GENDER) && mandate!= null){          
            String name = CongaHelperToolLightning.getReportName(CANDIDATE_GENDER, mandate.name, language);          
            string attachmentId = CongaHelperToolLightning.generateReport(mandate.candidate_gender_conga_link__c, name, null, null, null);
            ReportWrapper rep = new ReportWrapper();
            rep.attachmentId = attachmentId;
            rep.order = orderNumber;
            generatedReports.add(rep);
            orderNumber++;
        }
        if(reportsNamesSet.contains(CANDIDATE_REGION) && mandate!= null){          
            String name = CongaHelperToolLightning.getReportName(CANDIDATE_REGION, mandate.name, language);          
            string attachmentId = CongaHelperToolLightning.generateReport(mandate.Candidate_region_conga_link__c, name, null, null, null);
            ReportWrapper rep = new ReportWrapper();
            rep.attachmentId = attachmentId;
            rep.order = orderNumber;
            generatedReports.add(rep);
            orderNumber++;
        }
        if(reportsNamesSet.contains(CANDIDATE_EXPERIENCE) && mandate!= null){          
            String name = CongaHelperToolLightning.getReportName(CANDIDATE_EXPERIENCE, mandate.name, language);          
            string attachmentId = CongaHelperToolLightning.generateReport(mandate.Candidate_experience_conga_link__c, name, null, null, null);
            ReportWrapper rep = new ReportWrapper();
            rep.attachmentId = attachmentId;
            rep.order = orderNumber;
            generatedReports.add(rep);
            orderNumber++;
        }
        if(reportsNamesSet.contains(CANDIDATE_EDUCATION) && mandate!= null){          
            String name = CongaHelperToolLightning.getReportName(CANDIDATE_EDUCATION, mandate.name, language);          
            string attachmentId = CongaHelperToolLightning.generateReport(mandate.Candidate_education_conga_link__c, name, null, null, null);
            ReportWrapper rep = new ReportWrapper();
            rep.attachmentId = attachmentId;
            rep.order = orderNumber;
            generatedReports.add(rep);
            orderNumber++;
        }
        if(reportsNamesSet.contains(CANDIDATE_REVENUE) && mandate!= null){          
            String name = CongaHelperToolLightning.getReportName(CANDIDATE_REVENUE, mandate.name, language);          
            string attachmentId = CongaHelperToolLightning.generateReport(mandate.Candidate_revenue_conga_link__c, name, null, null, null);
            ReportWrapper rep = new ReportWrapper();
            rep.attachmentId = attachmentId;
            rep.order = orderNumber;
            generatedReports.add(rep);
            orderNumber++;
        }
        
        /*** End Chart Reports ***/
        
        if(reportsNamesSet.contains(AGENDA) && mandate!= null){          
            
            String name = CongaHelperToolLightning.getReportName(AGENDA, mandate.name, language);      
            string attachmentId = CongaHelperToolLightning.generateReport(IdentificationReportURLManagerLightning.getScheduledInterviewForCandidateLink(mandate,queryCongaInterview.ID,language),AGENDA,companyName,null,null);
            ReportWrapper rep = new ReportWrapper();
            rep.attachmentId = attachmentId;
            System.debug('Agenda_Att_Id'+attachmentId);
            rep.order = orderNumber;
            generatedReports.add(rep);
            orderNumber++; 
            
            /* String name = CongaHelperToolLightning.getReportName(AGENDA, mandate.name, language);      
string attachmentId = CongaHelperToolLightning.generateReport(IdentificationReportURLManagerLightning.getAgendaURL(mandate,language),AGENDA,companyName,null,null);
ReportWrapper rep = new ReportWrapper();
rep.attachmentId = attachmentId;
System.debug('Agenda_Att_Id'+attachmentId);
rep.order = orderNumber;
generatedReports.add(rep);
orderNumber++; */
        }
        /* if(reportsNamesSet.contains('Interview') && mandate!= null){          

String name = CongaHelperToolLightning.getReportName('SInterview Schedule', mandate.name, language);      
string attachmentId = CongaHelperToolLightning.generateReport(IdentificationReportURLManagerLightning.getScheduledInterviewForCandidateLink(mandate,language),'Interview Schedule',companyName,null,null);
ReportWrapper rep = new ReportWrapper();
rep.attachmentId = attachmentId;
System.debug('Agenda_Att_Id'+attachmentId);
rep.order = orderNumber;
generatedReports.add(rep);
orderNumber++; 
}*/
        /* if(reportsNamesSet.contains(Executive_Summary_1) && mandate!= null){          
String name = CongaHelperToolLightning.getReportName(Executive_Summary_1, mandate.name, language);      
string attachmentId = CongaHelperToolLightning.generateReport(IdentificationReportURLManagerLightning.Exec_Summary_Url(mandate,language),Executive_Summary_1,companyName,null,null);
ReportWrapper rep = new ReportWrapper();
rep.attachmentId = attachmentId;
System.debug('EXECUTIVE_ID'+attachmentId);
rep.order = orderNumber;
generatedReports.add(rep);
orderNumber++;
} */
        if(reportsNamesSet.contains(JOB_DESCRIPTION) && mandate!= null){           
            system.debug('JOB_DESCRIPTION');
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
            system.debug('RESEARCH_STRATEGY');
            string name = '%'+Label.Research_Strategy+'%';
            ReportWrapper rep = getReportAttachment(name, orderNumber, langabb, mandate.Id);
            if (rep != null){
                orderNumber++;
                generatedReports.add(rep);
            }            
        }
        
        if(reportsNamesSet.contains(Executive_Summary) && mandate!= null){
            system.debug('Executive_Summary');
            string name = '%'+Label.Executive_Summary+'%';
            ReportWrapper rep = getReportAttachment(name, orderNumber, langabb, mandate.Id);
            if (rep != null){
                orderNumber++;
                generatedReports.add(rep);
            }            
        }
        if(reportsNamesSet.contains(CANDIDATE_TO_DISCUSS_DEF) && mandate!= null){      
            String potentialName = CongaHelperToolLightning.getReportName('Candidate To Discuss Default',mandate.name,language);
            system.debug('[GenerateIdentificationReportBatchLight] generating potential Report '); 
            string attachmentId = CongaHelperToolLightning.generateReport(IdentificationReportURLManagerLightning.getCandidateToDiscussURL(mandate,queryCongaPotentialWithoutStatus.Id,language),potentialName,companyName,null,null);
            ReportWrapper rep = new ReportWrapper();
            rep.attachmentId = attachmentId;
            rep.order = orderNumber;
            generatedReports.add(rep);
            orderNumber++;
        }
        
        if(reportsNamesSet.contains(POTENTIAL_CANDIDATES) && mandate!= null){
            String potentialName = CongaHelperToolLightning.getReportName('Potential Candidates',mandate.name,language);
            system.debug('[GenerateIdentificationReportBatchLight] generating potential Report '); 
            string attachmentId = CongaHelperToolLightning.generateReport(IdentificationReportURLManagerLightning.getPotentialCandidateLightningURL(mandate,queryCongaPotentialWithoutStatus.Id),potentialName,companyName,null,null);
            ReportWrapper rep = new ReportWrapper();
            rep.attachmentId = attachmentId;
            rep.order = orderNumber;
            generatedReports.add(rep);
            orderNumber++;
        }
        
        if(reportsNamesSet.contains(POTENTIAL_CANDIDATES_BY_TEAM) && mandate!= null){
            String potentialName = CongaHelperToolLightning.getReportName('Potential Candidates',mandate.name,language);
            string attachmentId_12 = CongaHelperToolLightning.generateReport(IdentificationReportURLManagerLightning.getPotentialCandidateForCandidateToDiscussByTeam(mandate,queryCongaPotentialByTeam.Id,language),potentialName+'-SSL',null,null,null);
            system.debug('attachmentId_12 '+attachmentId_12);
            ReportWrapper reps1 = new ReportWrapper();
            reps1.attachmentId = attachmentId_12;
            reps1.order = orderNumber;
            generatedReports.add(reps1); 
            orderNumber++;
        }
       
        if(reportsNamesSet.contains(POTENTIAL_CANDIDATES_BYSTATUS) && mandate!= null){
            String potentialName = CongaHelperToolLightning.getReportName('Potential Candidates',mandate.name,language);
            string attachmentId_11 = CongaHelperToolLightning.generateReport(IdentificationReportURLManagerLightning.getPotentialCandidateForCandidateToDiscuss(mandate,queryCongaPotential.Id,language),potentialName+'-SSL',null,null,null);
            //system.debug('attachmentId_1 '+attachmentId_11);
            ReportWrapper reps1 = new ReportWrapper();
            reps1.attachmentId = attachmentId_11;
            reps1.order = orderNumber;
            generatedReports.add(reps1); 
            orderNumber++;
        }
        
        if(reportsNames != null && reportsNames.size() > 0 && mandate!= null) {
            
            return Database.getQueryLocator([Select Id, Contact__c, Contact__r.FirstName,  
                                             Contact__r.LastName, Contact__r.One_Pager_Conga_Link__c,Self_Assesment_Status__c,Competency_Radar_Link__c,
                                             Contact__r.One_Pager_Template_FR__c, Contact__r.One_Pager_Template_EN__c,
                                             Contact__r.One_Pager_Template_Lightning_FR__c, Contact__r.One_Pager_Template_Lightning_EN__c,
                                             Contact__r.Candidate_Biography_Template_EN__c, Contact__r.Candidate_Biography_Template_FR__c,
                                             One_Pager_Link__c,
                                             One_Pager_Link_Fr__c,
                                             Self_Assesment_Link__c,
                                             Self_Assesment_Fr_Link__c,
                                             Contact__r.Human_Capital_Conga_Link__c,
                                             Contact__r.Additional_Comments__c,
                                             Contact__r.Human_Capital_Template_FR__c,
                                             Contact__r.Human_Capital_Template_EN__c ,
                                             Contact__r.Human_Capital_Template_DE__c ,
                                             Contact__r.Human_Capital_Template__c  ,
                                             Contact__r.candidate_bio_wo_comment_En__c,
                                             Contact__r.Human_Capital_Report__c  ,
                                             Contact__r.Human_Capital_Report_EN__c  ,
                                             Contact__r.candidate_bio_wo_comment_Fr__c  ,
                                             Contact__r.Human_Capital_Report_FR__c   ,  
                                             Contact__r.Candidate_Biography_Conga_Link__c,
                                             Contact__r.One_Pager_Conga_Light_Link__c,
                                             Contact__r.Candidate_Biography_Conga_Light_Link__c,
                                             Contact__r.Candidate_Biography_Template_Lightning__c,
                                             Contact__r.Candidate_Biography_Template_Light_EN__c,
                                             Contact__r.Candidate_Biography_Template_Light_FR__c,
                                             Candidate_Cover_Conga_Link__c From Application__c 
                                             where Contact__c != null and Mandate__c = :mandateId and Id IN: candidatesIds                
                                             order by Contact__r.LastName asc]);  
            
        }else{
            System.debug('Returning null');
            return null;
        }
        
    }
    global void execute(Database.BatchableContext BC,List<sObject> scope){
        
        for(sObject so: scope){
            
            Application__c app = (Application__c)so;
            
            if(reportsNamesSet.contains(CANDIDATE_COVERPAGE)) {
                string attId = CongaHelperToolLightning.generateReport(app.Candidate_Cover_Conga_Link__c,null,null,null,null);
                
                system.debug('the coverpage id is'+attId);
                
                ReportWrapper repCover = new ReportWrapper();
                repCover.attachmentId = attId;
                repCover.order = orderNumber;
                orderNumber++;
                generatedReports.add(repCover);  
            }
            if(reportsNamesSet.contains(RadarGraph) ){  
                
                APXTConga4__Conga_Merge_Query__c QueryforRadar = LeadersReportCompController.getCongaQuery(app.Id);
                System.debug('@@@@@'+QueryforRadar);
                
                string attachmentId = CongaHelperToolLightning.generateReport(IdentificationReportURLManagerLightning.getCompetencyRadarURL(app,QueryforRadar.Id),'Competency_Radar',null,null,null);
                system.debug('attachmentId '+attachmentId);
                ReportWrapper rep = new ReportWrapper();
                rep.attachmentId = attachmentId;
                rep.order = orderNumber;
                orderNumber++;
                generatedReports.add(rep); 
                
                
            }
            if(reportsNamesSet.contains(ONE_PAGER)){
                //generate One Pager report
                /*string attachmentId = CongaHelperToolLightning.generateReport(IdentificationReportURLManagerLightning.getOnePagerURL(app, language),'One Pager',null,null,null);
ReportWrapper rep = new ReportWrapper();
rep.attachmentId = attachmentId;
rep.order = orderNumber;
orderNumber++;
generatedReports.add(rep);  
allContactsNotesToDelete.add(app.Contact__r.Id);*/
                string name = 'One Pag%';
                Id langCV = null;
                List<Attachment> attachmentsOnApp = new List<Attachment>();
                attachmentsOnApp = [Select id, ParentId, Name 
                                    From Attachment where ParentId = :app.Id 
                                    and Name like :name and contenttype='application/pdf' order by LastModifiedDate desc];
                if(attachmentsOnApp.size()>0){
                    langCV = attachmentsOnApp[0].Id;
                }else{
                    attachmentsOnApp =  [Select id, ParentId, Name 
                                         From Attachment where ParentId = :app.Contact__c 
                                         and Name like :name and contenttype='application/pdf' order by LastModifiedDate desc];
                    if(attachmentsOnApp.size() >0){
                        langCV = attachmentsOnApp[0].Id;
                    }
                }
                if(langCV != null){
                    ReportWrapper rep = new ReportWrapper();
                    rep.attachmentId = langCV;
                    rep.order = orderNumber;
                    orderNumber++;
                    generatedReports.add(rep);
                }
            }
            
            
            if(reportsNamesSet.contains(CANDIDATE_BIOGRAPHY_ON_CONTACT)){
                
                
                string langabb = 'EN';
                if(language.toLowerCase() =='french') 
                    langabb = 'FR';
                string name = 'Candidate Biography%';              
                ReportWrapper rep = getReportAttachment(name, orderNumber, langabb, app.Contact__c);
                
                if (rep != null){
                    orderNumber++;
                    generatedReports.add(rep);
                }
                /*string attachmentId = CongaHelperToolLightning.generateReport(IdentificationReportURLManagerLightning.getCandidateBiographyURL(app.Contact__r, language),null,null,null,null);
ReportWrapper rep = new ReportWrapper();
rep.attachmentId = attachmentId;
rep.order = orderNumber;
orderNumber++;
generatedReports.add(rep);  
allContactsNotesToDelete.add(app.Contact__r.Id); */
            }
            
            
            
            if(reportsNamesSet.contains(GenerateIdentificationReportBatch.CANDIDATE_INTRO)){      
                string langabb = 'EN';
                if(language.toLowerCase() =='french')   
                    langabb = 'FR';
                string name = GenerateIdentificationReportBatch.CANDIDATE_INTRO;
                List<Attachment> attachments = [Select id, ParentId, Name 
                                                From Attachment where ParentId = :app.Contact__c 
                                                and Name like :name and contenttype='application/pdf' order by LastModifiedDate desc];
                Id langCV = null;
                Id otherLangCV = null;
                if(attachments.size() >0){
                    langCV = attachments[0].Id;
                    ReportWrapper rep = new ReportWrapper();
                    rep.attachmentId = langCV;
                    rep.order = orderNumber;
                    orderNumber++;
                    generatedReports.add(rep);
                }   
            }
            //getting CV
            if(reportsNamesSet.contains(CV)){      
                string langabb = 'EN';
                if(language.toLowerCase() =='french')   
                    langabb = 'FR';
                string name = 'CV%';
                List<Attachment> attachments = [Select id, ParentId, Name 
                                                From Attachment where ParentId = :app.Contact__c 
                                                and Name like :name and contenttype='application/pdf' order by LastModifiedDate desc];
                Id langCV = null;
                Id otherLangCV = null;
                if(attachments.size() >0){
                    langCV = attachments[0].Id;
                    ReportWrapper rep = new ReportWrapper();
                    rep.attachmentId = langCV;
                    rep.order = orderNumber;
                    orderNumber++;
                    generatedReports.add(rep);
                }   
            }
            
            //BoardCV
            if(reportsNamesSet.contains(Board_CV)){      
                string langabb = 'EN';
                if(language.toLowerCase() =='french')   
                    langabb = 'FR';
                string name = 'Board CV%';
                List<Attachment> attachments = [Select id, ParentId, Name 
                                                From Attachment where ParentId = :app.Contact__c 
                                                and Name like :name and contenttype='application/pdf' order by LastModifiedDate desc];
                Id langCV = null;
                Id otherLangCV = null;
                if(attachments.size() >0){
                    langCV = attachments[0].Id;
                    ReportWrapper rep = new ReportWrapper();
                    rep.attachmentId = langCV;
                    rep.order = orderNumber;
                    orderNumber++;
                    generatedReports.add(rep);
                }   
            }
            
            //one-pager
            
            
            //getting Self Assessment document
            if(app.Self_Assesment_Status__c == 'Template Generated')
            {
                if(reportsNamesSet.contains(SELF_ASS)){  
                    string attachmentId = CongaHelperToolLightning.generateReport(IdentificationReportURLManagerLightning.getSelfAssURL(app, language),null,null,null,null);
                    
                    ReportWrapper rep = new ReportWrapper();
                    rep.attachmentId = attachmentId;
                    rep.order = orderNumber;
                    orderNumber++;
                    generatedReports.add(rep);  
                    allContactsNotesToDelete.add(app.Contact__r.Id);
                    
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
                            break;
                        }else if(otherLangHo == null){
                            otherLangHo = att.Id;
                        }
                    }
                    ReportWrapper rep = new ReportWrapper();
                    rep.attachmentId = (langHo != null)?langHo:otherLangHo;
                    rep.order = orderNumber;
                    orderNumber++;
                    generatedReports.add(rep);
                }   
            }
            if(reportsNamesSet.contains(REFERENCES)){
                string langabb = 'EN';
                if(language.toLowerCase() =='french')   
                    langabb = 'FR';
                string name = 'References%';              
                ReportWrapper rep = getReportAttachment(name, orderNumber, langabb, app.Contact__c);
                
                system.debug('in the References'+rep);
                
                system.debug('[GenerateIdentificationReportBatchLight] References rep '+rep);
                if (rep != null){
                    orderNumber++;
                    generatedReports.add(rep);
                }
            }
            //Onboarding
            if(reportsNamesSet.contains(Onboarding)){
                string langabb = 'EN';
                if(language.toLowerCase() =='french')   
                    langabb = 'FR';
                string name = 'Onboarding%';              
                ReportWrapper rep = getReportAttachment(name, orderNumber, langabb, app.Contact__c);
                
                system.debug('in the References'+rep);
                
                system.debug('[GenerateIdentificationReportBatchLight] References rep '+rep);
                if (rep != null){
                    orderNumber++;
                    generatedReports.add(rep);
                }
            }
            
            
            if(reportsNamesSet.contains(PSY_TEST)){
                string langabb = 'EN';
                if(language.toLowerCase() =='french')   
                    langabb = 'FR';
                string name = 'Psy%';              
                ReportWrapper rep = getReportAttachment(name, orderNumber, langabb, app.Contact__c);
                
                system.debug('in the pesy test '+rep);
                
                system.debug('[GenerateIdentificationReportBatchLight] PSY_TEST rep '+rep);
                if (rep != null){
                    orderNumber++;
                    generatedReports.add(rep);
                }
            }
            
        }           
        system.debug('[GenerateIdentificationReportBatchLight] PgeneratedReports '+generatedReports);
        
    }
    
    global void finish(Database.BatchableContext BC){
        
        if(reportsNamesSet.contains(HUMAN_CAPITAL_STUDY_ON_MANDATE) && mandate!= null && !isColeman){
            String hCapitalName = CongaHelperToolLightning.getReportName('Human Capital Study',mandate.name,language);
            String companyName = CongaHelperToolLightning.getCompanyName(mandate, language);
            Nubik_HumanCapitalStudyController cntrl = new Nubik_HumanCapitalStudyController();  
            string attachmentId = CongaHelperToolLightning.generateReport(
                IdentificationReportURLManagerLightning.getHumanCapitalStudyQueryURL1(mandate, queryConga.Id, language)
                ,null,null,null,null);
            ReportWrapper rep = new ReportWrapper();
            rep.attachmentId = attachmentId;
            rep.order = orderNumber;
            orderNumber++;
            generatedReports.add(rep);  
        } 
        
        if(reportsNamesSet.contains(HUMAN_CAPITAL_STUDY_ON_MANDATE) && mandate!= null && isColeman){
            
            System.debug(IdentificationReportURLManagerLightning.getHumanCapitalStudyQueryURL1(mandate, queryConga.Id, language));
            
            string attachmentId = CongaHelperToolLightning.generateReport(
                IdentificationReportURLManagerLightning.getHumanCapitalStudyQueryURL1(mandate, queryConga.Id, language)
                ,null,null,null,null);
            
            ReportWrapper rep = new ReportWrapper();
            rep.attachmentId = attachmentId;
            rep.order = orderNumber;
            orderNumber++;
            generatedReports.add(rep);  
        }
        
        if(reportsNamesSet.contains (HUMAN_CAPITAL_STUDY_ON_MANDATE_SSL) && mandate != null && !isColeman){
            String hCapitalName = CongaHelperToolLightning.getReportName('Human Capital Study SSL',mandate.name,language);
            String companyName = CongaHelperToolLightning.getCompanyName(mandate, language);
            string attachmentId = CongaHelperToolLightning.generateReport(
                IdentificationReportURLManagerLightning.getHumanCapitalStudySSLURL(mandate,language,queryCongaSSL.Id),null,null,null,null);
            ReportWrapper rep = new ReportWrapper();
            rep.attachmentId = attachmentId;
            rep.order = orderNumber;
            
            orderNumber++;
            generatedReports.add(rep);
        }
        
        if(generatedReports.size() > 0){
            
            system.debug('generatedReports'+generatedReports);
            if (generatedReports.size() == 1){
                List<Attachment> repAttach = new List<Attachment>();
                
                String reportName = prefixReportName+'_'+IDENTIFICATION_NAME+'_'+string.valueOf(datetime.now())+'_'+userId+'.pdf';
                repAttach = [Select body from Attachment where Id = :generatedReports[0].attachmentId];
                if(!repAttach.isEmpty() && repAttach[0].Id != null){
                    Attachment reportAttach = new Attachment();
                    reportAttach.Name = reportName;
                    reportAttach.Body = repAttach[0].body;
                    reportAttach.ParentId = mandate.Id;
                    insert reportAttach;
                    system.debug('leaders report for size 1'+reportAttach.Id);
                }
            }else{         
                String str = JSON.serialize(generatedReports);
                Http h = new Http();
                HttpRequest req = new HttpRequest();
                req.setEndpoint(Label.PDF_join_Service);
                req.setMethod('POST');
                //  List<Attachment> attRecs = [select id,Name from Attachment where ParentId=:mandate.Id];
                
                String reportName = prefixReportName+'_'+IDENTIFICATION_NAME+'_'+string.valueOf(datetime.now())+'_'+userId+'.pdf';
                req.setBody('&name='+reportName+'&files='+str+'&parentId='+mandate.Id);
                req.setTimeout(60000);
                if (!Test.isRunningTest()) {
                    HttpResponse res = h.send(req);
                }
                // system.debug('leaders report for size greater than 1'+attRecs);
            }
            //Batch Added By Ajeet
            //Database.executeBatch(new CleanIdentificationReportsBatch(mandate.Id));
        }
        
        /*if(queryCongaSSL <> null && queryCongaSSL.Id <> null)
delete queryCongaSSL;
if(QueryforRadar <> null && QueryforRadar.Id <> null)
delete queryCongaSSL;*/
        
    }
    
    public class ReportWrapper{
        public string attachmentId {get; set;}
        public integer order {get; set;}
    }
    
    public ReportWrapper getReportAttachment(String name, Integer orderNum, String lang, String parentId){
        system.debug('getReportAttachment');
        ReportWrapper rep;
        List<Attachment> attachments = [Select id, ParentId, Name From Attachment where ParentId = :parentId and Name like :name and contenttype='application/pdf' 
                                        order by LastModifiedDate desc];
        //system.debug('attachments'+attachments[0].Id);
        Id langHo = null;
        Id otherLangHo = null;
        
        if(attachments.size() >0){  
            langHo =attachments[0].Id;
            rep = new ReportWrapper();
            rep.attachmentId = (langHo != null)?langHo:otherLangHo;
            rep.order = orderNum;   
        }
        return rep; 
    }
}