public class LeadersReportCompController {
    
    @AuraEnabled
    public static List<date> getDates(String manId){
        
        date todaydate = System.today();
        date startdate = system.today().addYears(-1);
        List<date> datevalue = new List<Date>();
        datevalue.add(todaydate);
        datevalue.add(startdate);
        
        String mandateID = manId.substring(0,15); 
        
        CompetencyBatch.createCompetencyForrReport(mandateID);
        return datevalue;
        
        
    }
    @AuraEnabled
    public static List<String> getAllCandidatesData(List<String> canIds){
        List<String> allCandidateData = new List<String>();
        system.debug('canIds'+canIds)  ;  
        
        for(Application__c  application:[SELECT Status_Summary_Line__c  FROM Application__c  WHERE Id IN: canIds]) {
            allCandidateData.add(application.Status_Summary_Line__c);
        }
        
        date todaydate = System.today();
        date startdate = system.today().addYears(-1);
        List<date> datevalue = new List<Date>();
        datevalue.add(todaydate);
        datevalue.add(startdate);
        
        system.debug('Fetched all candidates data'+allCandidateData);
        return allCandidateData;
        
        
    }
    
    @AuraEnabled
    public static List<UserWrapper> getPartnerNameandId(String manId){
        List<Mandate__C> manlist = [SELECT Consultant__r.name,Researcher_3__r.name,Researcher_4__r.name,Researcher_5__r.name,
                                    Researcher__r.name,Partner_2__r.name,Partner_3__r.name,Partner__r.name,
                                    Partner_1_required__c,Partner_2_Required__c,Partner_3_Required__c  
                                    FROM Mandate__c where id =:manId];
        
        List<String> PartnerIds = new List<String>();
        List<String> ResearcherIds = new List<String>();
        List<UserWrapper> userWrap = new List<UserWrapper>();
        List<User> PartnerList = new List<User>();
        List<User> ResearcherList = new List<User>();
        List<List<User>> TotalValues = new List<List<User>>(); 
        system.debug('manlist'+manlist);    
        
        for(Mandate__C man : manlist){
            if(man.Partner__r.Id != null)
                PartnerIds.add(man.Partner__r.Id);
            if(man.Partner_2__r.Id != null)
                PartnerIds.add(man.Partner_2__r.Id);
            if(man.Partner_3__r.Id != null)
                PartnerIds.add(man.Partner_3__r.Id);
            
            if(man.Consultant__r.Id != null)
                ResearcherIds.add(man.Consultant__r.Id);
            if(man.Researcher_3__r.Id != null)
                ResearcherIds.add(man.Researcher_3__r.Id);
            if(man.Researcher_4__r.Id != null)
                ResearcherIds.add(man.Researcher_4__r.Id);
            if(man.Researcher_5__r.Id != null)
                ResearcherIds.add(man.Researcher_5__r.Id);
            if(man.Researcher__r.Id != null)
                ResearcherIds.add(man.Researcher__r.Id);  
        }
        PartnerList = [Select Id,Name,Title,Phone from user where ID IN :PartnerIds];
        ResearcherList = [Select Id,Name,Title,Phone from user where ID IN :ResearcherIds];
        
        String Lang = [SELECT Language__c FROM Mandate__c where id=:manId].Language__c;
        
        List<Radar_Rating__c> CompetencyList = [SELECT Radar_Rating_Ques__c,Radar_Rating_Fr_Ques__c FROM Radar_Rating__c WHERE Assignment__c  =:manId];
        List<string> StringList = new List<String>();
        
        for(Radar_Rating__c comp:CompetencyList){
            if(Lang == ''){
                StringList.add(comp.Radar_Rating_Ques__c);    
            }else{
                StringList.add(comp.Radar_Rating_Fr_Ques__c);   
            }
        }
        
        List<Mandate_competencies__c> CompetencyListfromLrn = [SELECT Other__c FROM Mandate_competencies__c WHERE Mandate__c =:manId];
        List<string> StringListofCompFromLrn = new List<String>();
        
        for(Mandate_competencies__c comp:CompetencyListfromLrn){
            
            StringListofCompFromLrn.add(comp.Other__c);
            
        }
        
        userWrap.add(new UserWrapper(PartnerList,ResearcherList,StringList,StringListofCompFromLrn));
        
        return userWrap;
        
    }
    
    @AuraEnabled
    public static String UpdatePartnerField(String manId,Boolean par_1,Boolean par_2,Boolean par_3){
        system.debug('PARTNERS');
        system.debug('par_3'+par_3);
        List<Mandate__C> manlist = [SELECT Partner_1_required__c,Partner_2_Required__c,Partner_3_Required__c  FROM Mandate__c where id =:manId];
        List<Mandate__C> ManToBeUpdated = new List<Mandate__c>();
        
        
        for(Mandate__C man : manlist){
            man.Partner_1_required__c = par_1;
            man.Partner_2_Required__c = par_2;
            man.Partner_3_Required__c = par_3;
            ManToBeUpdated.add(man);
        }
        
        system.debug('manlist'+ManToBeUpdated);  
        update ManToBeUpdated;
        
        return 'Success';
        
    }
    @AuraEnabled
    public static string generateReport(CommonWrapperClass wrapData,List<User> userList){
        try {
            System.debug('###############'+wrapData);
            system.debug('wrapData.nextFollowupDate'+wrapData.nextFollowupDate);
            system.debug('wrapData.selectComp'+wrapData.selectedComp);
            
            List<String> CompetencyList = new List<String>();
            if(userList != null){
                Map<String,User> userMap = new Map<String,User>();
                for(User userRec:userList){
                    userMap.put(userRec.Id,userRec);
                }
                try{
                    update userMap.values();
                }catch(Exception e){
                    
                }
            }
            // These Are some hard-coded values which i have put intentionally
            Boolean isColemanProfile = false;
            Mandate__c theAssignment;
            String language ='EN';
            List<Mandate_competencies__c> competencies;
            Map<String ,Boolean> competencyChart = new Map<String, Boolean>();
            Map<String, String> competencyTitle = new Map<String, String>();
            Map<String, String> competencyNote = new Map<String, String>();
            Id profileId = userinfo.getProfileId();
            
            // Nubik ControllerCode
            if(wrapData.masterId!=null) {
                theAssignment = [
                    Select Id,Next_Follow_up_meeting__c,
                    Report_Cover__c, Language__c,
                    Candidate_gender_title__c,
                    Candidate_gender_notes__c,
                    Candidate_education_notes__c,
                    Candidate_education_title__c,
                    Candidate_experience_notes__c,
                    Candidate_experience_title__c,
                    Candidate_region_notes__c,
                    Candidate_region_title__c,
                    Candidate_revenue_notes__c,
                    Candidate_revenue_title__c,
                    Candidate_status_notes__c,
                    Candidate_status_title__c,
                    Candidate_all_competencies_all_candidate__c,
                    Candidate_to_discuss__c
                    from Mandate__c
                    where Id = :wrapData.masterId
                ];
            }
            String profileName = [select Name from profile where id = :profileId].Name;
            
            if(profileName.startsWith('Force.com Leaders Coleman'))
                isColemanProfile=true;
            
            
            if(wrapData.selectHumanCapitalStudy==true && isColemanProfile) {
                wrapData.hcsStartDate = Date.newInstance(1960, 2, 17);
                wrapData.hcsEndDate = Date.newInstance(2100, 12, 31);
                
            }
            
            if(theAssignment!=null){
                try{
                    //we don't want to replace the original value, will be use
                    //other one specially for the conga report
                    theAssignment.Conga_Report_Cover__c = wrapData.module;
                    theAssignment.Next_Follow_up_meeting__c = wrapData.nextFollowupDate;
                    //update
                    update  theAssignment;
                }
                catch(Exception e){
                    system.debug('Error'+e.getMessage());
                    
                }
            }
            if(theAssignment!=null) {
                if (theAssignment.Next_Follow_up_meeting__c != null) {
                    //wrapData.nextfollowupdate = theAssignment.Next_Follow_up_meeting__c.format();
                }
                //reportCover = theAssignment.Report_Cover__c;
                language = theAssignment.Language__c != null ? theAssignment.Language__c:'english';
                theAssignment.Candidate_gender_title__c = '';
                theAssignment.Candidate_gender_notes__c = '';
                theAssignment.Candidate_education_title__c = '';
                theAssignment.Candidate_education_notes__c = '';
                theAssignment.Candidate_experience_title__c = '';
                theAssignment.Candidate_experience_notes__c = '';
                theAssignment.Candidate_region_title__c = '';
                theAssignment.Candidate_region_notes__c = '';
                theAssignment.Candidate_revenue_title__c = '';
                theAssignment.Candidate_revenue_notes__c = '';
                theAssignment.Candidate_status_title__c = '';
                theAssignment.Candidate_status_notes__c = '';
                theAssignment.Candidate_all_competencies_all_candidate__c = false;
                theAssignment.Candidate_to_discuss__c = false;
                
                competencies = [SELECT Id, Competencies__c, Type__c, Other__c, Picklist_values_2__c FROM Mandate_competencies__c WHERE Mandate__c = :wrapData.masterId ORDER BY Competencies__c];
            }
            List<String> reportsNames = new List<String> ();
            if(wrapData.selectCanCoverPage != null && wrapData.selectCanCoverPage) {
                reportsNames.add(GenerateIdentificationReportBatch.CANDIDATE_COVERPAGE);
            }
            if(wrapData.selectBiography != null && wrapData.selectBiography) {
                reportsNames.add(GenerateIdentificationReportBatch.CANDIDATE_BIOGRAPHY_ON_CONTACT);
            }
            if(wrapData.selectBoardCV != null && wrapData.selectBoardCV) {
                reportsNames.add(GenerateIdentificationReportBatch.Board_CV);
            }
            if(wrapData.selectOnboarding != null && wrapData.selectOnboarding) {
                reportsNames.add(GenerateIdentificationReportBatch.Onboarding);
            }
            if(wrapData.selectOnePager != null && wrapData.selectOnePager) {
                reportsNames.add(GenerateIdentificationReportBatch.ONE_PAGER);
            }
            if(wrapData.selectCandidateIntro != null && wrapData.selectCandidateIntro) {
                reportsNames.add(GenerateIdentificationReportBatch.CANDIDATE_INTRO);
            }
            if(wrapData.Agenda != null && wrapData.Agenda) {
                reportsNames.add(GenerateIdentificationReportBatch.AGENDA);
            }
            if(wrapData.selectSelfAss != null && wrapData.selectSelfAss) {
                reportsNames.add('Self Assessment');
            }
            if(wrapData.selectReferences != null && wrapData.selectReferences) {
                reportsNames.add('References');
            }
            if (wrapData.selectPsyTest != null && wrapData.selectPsyTest){
                reportsNames.add(GenerateIdentificationReportBatch.PSY_TEST);
            }
            
            if(wrapData.selectCandidatestoDiscuss != null && wrapData.selectCandidatestoDiscuss) {
                reportsNames.add(GenerateIdentificationReportBatch.POTENTIAL_CANDIDATES);
            }
            if(wrapData.selectCandidatestoDiscussByTeam != null && wrapData.selectCandidatestoDiscussByTeam) {
                reportsNames.add(GenerateIdentificationReportBatch.POTENTIAL_CANDIDATES_BY_TEAM);
            }
            if(wrapData.selectCandidatestoDiscussByStatus != null && wrapData.selectCandidatestoDiscussByStatus) {
                reportsNames.add(GenerateIdentificationReportBatch.POTENTIAL_CANDIDATES_BYSTATUS);
            }
            if(wrapData.selectHumanCapitalStudy!= null)
            {
                
                if(wrapData.selectHumanCapitalStudy && wrapData.hcsSortBy == 'Company Name')
                {
                    reportsNames.add(GenerateIdentificationReportBatch.HUMAN_CAPITAL_STUDY_ON_MANDATE);
                }
                else if (wrapData.selectHumanCapitalStudy && wrapData.hcsSortBy == 'Status Summary Line')
                {
                    reportsNames.add(GenerateIdentificationReportBatch.HUMAN_CAPITAL_STUDY_ON_MANDATE_SSL);
                }
                else if(wrapData.selectHumanCapitalStudy)
                {
                    reportsNames.add(GenerateIdentificationReportBatch.HUMAN_CAPITAL_STUDY_ON_MANDATE);
                }
                else
                {
                    wrapData.hcsStartDate = date.today().addDays(-30);
                    wrapData.hcsEndDate = date.today();
                }
            }
            
            /*if(hoganReport != null && hoganReport) {
reportsNames.add(GenerateIdentificationReportBatch.HOGAN_REPORT);
}*/
            if(wrapData.selectCV != null && wrapData.selectCV) {
                reportsNames.add(GenerateIdentificationReportBatch.CV);
            }
            
            if(wrapData.selectedComp.size() > 0 && wrapData.selectedComp != null  ) {
                reportsNames.add(GenerateIdentificationReportBatch.COMPETENCY);
            }
            
            if(wrapData.selectRadarGraph != null && wrapData.selectRadarGraph ) {
                reportsNames.add(GenerateIdentificationReportBatch.RadarGraph);
            }
            if(wrapData.selectJobDescription != null && wrapData.selectJobDescription){
                reportsNames.add(GenerateIdentificationReportBatch.JOB_DESCRIPTION);
            }
            if (wrapData.selectInterviewQuestionnaire != null && wrapData.selectInterviewQuestionnaire){
                reportsNames.add(GenerateIdentificationReportBatch.INTERVIEW_QUESTIONNAIRE);
            }
            if (wrapData.researchStrategy != null && wrapData.researchStrategy){
                reportsNames.add(GenerateIdentificationReportBatch.RESEARCH_STRATEGY);
            }
            if (wrapData.executiveSummary != null && wrapData.executiveSummary){
                reportsNames.add(GenerateIdentificationReportBatch.Executive_Summary);
            }
            if (wrapData.executiveSummary_1 != null && wrapData.executiveSummary_1){
                reportsNames.add(GenerateIdentificationReportBatch.Executive_Summary_1);
            }
            
            if (wrapData.selectCoverPage != null && wrapData.selectCoverPage){
                reportsNames.add(GenerateIdentificationReportBatch.COVER_PAGE);
            }
            if (wrapData.selectPartnerPage != null && wrapData.selectPartnerPage){
                reportsNames.add(GenerateIdentificationReportBatch.PARTNER_PAGE);
                //global static final string PARTNER_PAGE = 'Partner Page';
            }
            
            /*** Chart Reports ***/
            if(wrapData.candidateByStatus != null && wrapData.candidateByStatus){
                reportsNames.add(GenerateIdentificationReportBatch.CANDIDATE_STATUS);
            }
            if(wrapData.selectToDiscuss != null && wrapData.selectToDiscuss){
                reportsNames.add(GenerateIdentificationReportBatch.CANDIDATE_TO_DISCUSS_DEF);
            }
            if(wrapData.allCompitencies != null && wrapData.allCompitencies) {
                reportsNames.add(GenerateIdentificationReportBatch.ALL_COMPETENCIES);
            }
            
            if(wrapData.Candidatetodiscuss != null && wrapData.Candidatetodiscuss) {
                reportsNames.add(GenerateIdentificationReportBatch.CANDIDATE_TO_DISCUSS);
            }
            
            /*** Competency Charts ***/
            Integer i=1;
            
            for(Mandate_competencies__c competency:competencies) {
                
                if(competencyChart.containsKey(competency.Competencies__c)) {
                    if(competencyChart.get(competency.Competencies__c)) {
                        reportsNames.add('COMPETENCY__'+i);
                        
                        theAssignment.put('CC_name_'+i+'__c',competency.Competencies__c);
                        // theAssignment.put('CC_title_'+i+'__c', competencyTitle.get(competency.Competencies__c) );
                        // theAssignment.put('CC_text_'+i+'__c',competencyNote.get(competency.Competencies__c) );
                    }
                }
                i++;
                
            }
            
            system.debug('Hey i am at line 335'+wrapData);
            update theAssignment;
            
            System.debug(reportsNames);
            if(wrapData.masterId != null && reportsNames.size() > 0) {
                system.debug('Hey i am at line 340'+wrapData.masterId);
                //String Candidates='0030B000028jMBrQAM,0031h00000J1I2WAAV,003U0000018yoohIAA';
                String Candidates = String.join(wrapData.selectedcandidateIds, ',');
                System.debug('Candidates =>'+Candidates);
                GenerateIdentificationReportBatchLight.selectedSubComp =getQuotedString(wrapData.selectedSubComp);
                inserallRadarQuery(Candidates,GenerateIdentificationReportBatchLight.selectedSubComp);
                Database.executeBatch(new GenerateIdentificationReportBatchLight(wrapData.partners,reportsNames,wrapData.selectedComp,wrapData.selectedSubComp,
                                                                                 wrapData.masterId,wrapData.sortByHCS,wrapData.hcsStartDate,wrapData.hcsEndDate, language, UserInfo.getUserId(),String.valueOf(wrapData.nextfollowupdate),wrapData.module,Candidates, 'Overnight',isColemanProfile),1);
                
            }
            /*String masterId ='a010B00001ffnsGQAQ';
date startDate = date.today().addDays(-30);
date endDate = date.today();
String language='English';
String nextfollowUp=String.valueOf(date.today());
String reportCover = 'Selection';
String Candidates='a020B00000i15CaQAI';
String reportType = 'Overnight Report';
Boolean isColemanProfile = false;
system.debug('Fetched all candidates data');*/
            /*Database.executeBatch(new GenerateIdentificationReportBatch(reportsNames,
masterId,startDate,endDate, language, UserInfo.getUserId(),nextfollowUp,reportCover,Candidates, reportType,isColemanProfile),1);
*/
            system.debug('Fetched all candidates data');
            return 'Success'; 
        } catch (Exception e) {
            return e.getMessage() +' AT '+e.getLineNumber();
        }
    }
    
    public static string getQuotedString(List<String> allIds){
        String subCompetencyString = '';
        Integer l=0;
        if(!allIds.isEmpty()){
            for(String  subComp: allIds) {
                if(l>0)
                    subCompetencyString += ' , ';
                subCompetencyString += '\''+subComp+'\'';
                l++;
            }
        }
        return subCompetencyString;
    }
    public static void inserallRadarQuery(String Candidates,String selectedSubComp){
        
        List<String> canIds = new List<String>();
        if (Candidates!='' && Candidates!=null){
            canIds = Candidates.split(',', 0);
        }
        
        system.debug('selectedSubComp'+selectedSubComp);
        system.debug('selectedSubComp'+selectedSubComp);
        list<APXTConga4__Conga_Merge_Query__c> allCongaQuery = new List<APXTConga4__Conga_Merge_Query__c>();
        for(String canId:canIds){
            String soqlQueryforRadar = 'SELECT Radar_Ques__c ,Radar_Rating__c  FROM Radar_Rating_Response__c  WHERE Related_Assignment__c  ='+ '\''+canId+'\''+' AND Radar_Rating__c != null ';
            allCongaQuery.add(new APXTConga4__Conga_Merge_Query__c(APXTConga4__Query__c =soqlQueryforRadar,RefrenceId__c = canId));
            system.debug('allCongaQuery'+allCongaQuery);
        }
        insert allCongaQuery;
        //  GenerateIdentificationReportBatchLight.QueryforRadar_1 = allCongaQuery[0].Id;
        System.debug('@@@@@'+allCongaQuery);
    }
    public static APXTConga4__Conga_Merge_Query__c getCongaQuery(String refId){
        return [Select Id,RefrenceId__c from APXTConga4__Conga_Merge_Query__c where RefrenceId__c=:refId order by createddate desc limit 1];
    }
    
    @AuraEnabled
    public static List<candidateWrapper> getCandidateNameById(List<String> canIds){
        Map<String,String> candidateNameMapById = new Map<String, String>();
        List<candidateWrapper> AllCandidates = new List<candidateWrapper>();
        // @AuraEnabled Map<String,String> candidateNameMapById {get;set;}
        system.debug('canIds'+canIds)  ;
        if(!canIds.isEmpty()) {
            for(Application__c  application:[SELECT Stage__c, Contact__c, Contact__r.Name  FROM Application__c  WHERE Id IN: canIds]) {
                if(application.Contact__c!=null)
                    
                    AllCandidates.add(new candidateWrapper(application.Stage__c,application.Contact__c,application.Contact__r.Name));
                
                
                candidateNameMapById.put(application.Contact__c,application.Contact__r.Name);
            }
        }            
        system.debug('Fetched all candidates data Map by ID and Name'+candidateNameMapById);
        system.debug('Fetched all candidates data Map by ID and Name'+AllCandidates); 
        // return JSON.serialize(candidateNameMapById);
        return AllCandidates;
        
    }
    
    public class candidateWrapper{
        @AuraEnabled public String Stage {get;set;}
        @AuraEnabled public Id con {get;set;}
        @AuraEnabled public String conName {get;set;}
        @AuraEnabled public Map<String,String> candidateNameMapByIdWrapper {get;set;}
        public candidateWrapper(String stage, Id cont, String name)
        {
            this.Stage = stage;
            this.con= cont;
            this.conName = name;
        }
    }
    public class userWrapper{
        @AuraEnabled public List<User> PartnerList {get;set;}
        @AuraEnabled public List<User> ResearcherList {get;set;}
        @AuraEnabled public List<String> CompetencyName {get;set;}
        @AuraEnabled public List<String> CompetencyNameFromLrn {get;set;}
        public userWrapper(List<User> PartnerList,List<User> ResearcherList, List<String> CompetencyName,List<String> CompetencyNameFromLrn)
        {
            this.PartnerList = PartnerList;
            this.ResearcherList = ResearcherList;
            this.CompetencyName = CompetencyName;
            this.CompetencyNameFromLrn = CompetencyNameFromLrn;
        }
        
    }
}