/* **************************************************************************
* Controller Class: Nubik_IdentificationReportController
* Created by Jesus Varela, 11/06/2014
*
* Purpose/Methods:
* - Generate the identification report

*
* Unit Test: GenerateIdentificationReportBatchTest
* 
* Modifications:
* - Jesus Varela - 11-12-2014 - Adding Hogan Report C076814 
* - Karyn Cuenca - 02-04-2015 - Adding Job Description and Interview Questionnaire Reports C097250
*
************************************************************************** */
public with sharing class Nubik_IdentificationReportController {
    
    public Mandate__c theAssignment {get;set;}
    public List<Mandate_competencies__c> competencies {get;set;} 
    public boolean potentialCandidates {get; set;}
    public boolean biographyReport {get; set;}
    public boolean candidateCoverPageReport {get;set;}
    public boolean onePager {get; set;}
    public boolean hoganReport {get; set;}
    public boolean CV {get; set;}
    public boolean humanCapitalStudy {get; set;}
    public boolean humanCapitalStudySSL {get;set;}
    public boolean hcs {get;set;}
    public boolean jobDescription {get; set;}
    public boolean interviewQuestionnaire {get; set;}
    public boolean researchStrategy {get; set;}
    public boolean coverPage  {get; set;}
    public boolean psyTest  {get; set;}
    private date startDate;
    public String Candidates {get;set;}
    public String reportType {get;set;}
    public string hcsSortBy {get;set;}
    
    public boolean candidateByStatus{get; set;}
    public boolean candidateByGender{get; set;}
    public boolean candidateByRegion{get; set;}
    public boolean candidateByExperience{get; set;}
    public boolean candidateByEducation{get; set;}
    public boolean candidateByRevenue{get; set;}
    
    public boolean allCompetenciesChart {get;set;}
    public boolean allCompetenciesAllCandidates {get;set;}
    public boolean candidateToDiscuss {get;set;}
    
    public void setStartDate(date sDate){
        startDate = sDate;
    }
    public string getStartDate(){
        return (startDate==null)?'':startDate.format();
    }
    private date endDate;
    public void setEndDate(date eDate){
        endDate = eDate;
    }
    public string getEndDate(){
        return (endDate==null)?'':endDate.format();
    }
    public id masterId {get; set;}
    public String language {get; set;}
    public String nextfollowUp {get;set;}
    public string reportCover {get;set;}
    public Boolean isColemanProfile {get;set;}  
    public boolean isTeam3Profile {get;set;}
    
    private Set<String> candidateIds = new Set<String>();
    
    /*
     * Charts data 
     */
    public String allCompetencies  {get;set;} 
    public String allCompetenciesId {get;set;} 
    public String allCompetenciesData  {get;set;} 
    public String allCandidateStatus {get;set;}
    public String allCandidateStatusData {get;set;}
    public String allCandiateIds {get;set;}
    public String competenciesAverageByCandidate {get;set;}
    
    public Map<String, Boolean> competencyChart {get;set;}
    public Map<String, String> competencyTitle {get;set;}
    public Map<String, String> competencyNote {get;set;}
    
    private Map<String, List<String>> picklistValuesMapByCompetencyName = new Map<String, List<String>>();
    private Map<String, Map<String, Decimal>> dataValuesMapByCompetencyName = new Map<String, Map<String, Decimal>>();
    
    
    
    
    public Nubik_IdentificationReportController(ApexPages.StandardController controller) {
        masterId = ApexPages.currentPage().getParameters().get('id');       
        Candidates = ApexPages.currentPage().getParameters().get('candidates');
        System.debug('[Nubik_IdentificationReportController] Candidates: '+Candidates);
        nextfollowUp = '';
        allCandiateIds = '';
        reportType = 'Overnight Report';
        competencies = new List<Mandate_competencies__c>();
        competencyChart = new Map<String, Boolean>();
        competencyTitle = new Map<String, String>();
        competencyNote = new Map<String, String>();
         if(Candidates!=null) {
            
             for(String candidateId: Candidates.split(',')) {
                candidateIds.add(candidateId);
                if(allCandiateIds!='')
                    allCandiateIds = allCandiateIds +' , ';
                 allCandiateIds = allCandiateIds + '"'+candidateId+'"';
             }
         }
        
        isColemanProfile = false;
        isTeam3Profile= false;
      
    
        
        Id profileId = userinfo.getProfileId();
        String profileName = [select Name from profile where id = :profileId].Name;
            
        if(profileName.startsWith('Force.com Leaders Coleman'))
            isColemanProfile=true;
        
        if(profileName.startsWith('Force.com Leaders team 3'))
            isTeam3Profile=true;
        
        if(humanCapitalStudy==true)
        {
           hcs = true; 
        }
            
        //Next_Follow_up_meeting__c,
        if(masterId!=null){
            theAssignment = [Select Id,
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
                                from Mandate__c where Id=:masterId];                           
             
            
            if(theAssignment!=null){
               /* if(theAssignment.Next_Follow_up_meeting__c!=null){
                    nextfollowUp = theAssignment.Next_Follow_up_meeting__c.format();
                } */
                reportCover = theAssignment.Report_Cover__c;
                language = theAssignment.Language__c;
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
                
                competencies = [SELECT Id, Competencies__c , Type__c, Other__c, Picklist_values_2__c   FROM Mandate_competencies__c  WHERE Mandate__c =:masterId ORDER BY Competencies__c];
                for(Mandate_competencies__c competency:competencies) {
                    if(competency.Competencies__c=='Custom Competency')
                        competency.Competencies__c=competency.Other__c;
                    
                    if(competency.Picklist_values_2__c!=null) {
                        picklistValuesMapByCompetencyName.put(competency.Competencies__c, competency.Picklist_values_2__c.split('\n'));
                        
                        Map<String, Decimal> dataValue = new  Map<String, Decimal>();
                        for(String picklistValue: competency.Picklist_values_2__c.split('\r\n'))
                            dataValue.put(picklistValue, 0.0);
                        
                        dataValuesMapByCompetencyName.put(competency.Competencies__c, dataValue);  
                       
                    }
                    competencyChart.put(competency.Competencies__c,false);
                    competencyTitle.put(competency.Competencies__c,'');
                    competencyNote.put(competency.Competencies__c,'');
                }
                
                //Chart data
                calculateAllCompetenciesCandidates();       
                calculateCandiateByStatus();
            }
        }
        
        
    }
    
    private void calculateAllCompetenciesCandidates() {
        
        allCompetencies = '';
        allCompetenciesId = '';
        Map<String, Decimal> averageCandidateEvaluationByCompetencies = new Map<String, Decimal>();
        Map<String, Decimal> nbCandidateEvaluationByCompetencies = new Map<String, Decimal>();
        
        Map<String, Map<String, Decimal>> candidateEvaluationMapByCandidateIdCompetency = new Map<String, Map<String, Decimal>>();
        
        Set<Id> contactCandidateIds = new Set<Id>();
        
        if(!candidateIds.isEmpty()) {
            for(Application__c  application:[SELECT Stage__c, Contact__c  FROM Application__c  WHERE Id IN: candidateIds]) {
                contactCandidateIds.add(application.Contact__c);
            }
        } 
        
        for(String candidateId:contactCandidateIds) {
            if(!candidateEvaluationMapByCandidateIdCompetency.containskey(candidateId)) {
                candidateEvaluationMapByCandidateIdCompetency.put(candidateId, new Map<String, Decimal>());
            }
        }
        
          
        
        for(Mandate_competencies__c competency:competencies) {
            if(allCompetencies!='')
                allCompetencies = allCompetencies+', ';
            allCompetencies = allCompetencies+'"'+competency.Competencies__c+'"';
            
            if(allCompetenciesId!='')
                allCompetenciesId = allCompetenciesId+', ';
            allCompetenciesId = allCompetenciesId+'"'+competency.Id+'"';
            
            averageCandidateEvaluationByCompetencies.put(competency.Id,0);
            nbCandidateEvaluationByCompetencies.put(competency.Id,0);
            
            
            for(String candidateId:contactCandidateIds) {
                candidateEvaluationMapByCandidateIdCompetency.get(candidateId).put(competency.Id,0);
            }
            
          
        }
        
        Map<String, Boolean> leaderNoteContact = new Map<String, Boolean>();
        
        for(Leader_Report_Note_Competency__c noteCompetencies: [SELECT Id, Evaluation__c, Competency__c, Competency_name__c , Leader_Report_Notes__c, Leader_Report_Notes__r.Contact__c, Picklist_values_2__c, Multi_select_values__c  FROM Leader_Report_Note_Competency__c WHERE Competency__r.Mandate__c =:masterId AND  Leader_Report_Notes__r.Most_Recent__c=True AND Leader_Report_Notes__r.Status_Summary_Line__c !='Private' AND Leader_Report_Notes__r.Status_Summary_Line__c !='Client.' ORDER BY Leader_Report_Notes__r.LastModifiedDate DESC] ) {
            
            if(!leaderNoteContact.containsKey(noteCompetencies.Competency_name__c+'-'+noteCompetencies.Leader_Report_Notes__r.Contact__c)) {
                System.debug(noteCompetencies.Competency_name__c+'-'+noteCompetencies.Leader_Report_Notes__r.Contact__c);
                leaderNoteContact.put(noteCompetencies.Competency_name__c+'-'+noteCompetencies.Leader_Report_Notes__r.Contact__c,true);
                if(noteCompetencies.Evaluation__c!=null) {
                    averageCandidateEvaluationByCompetencies.put(noteCompetencies.Competency__c, averageCandidateEvaluationByCompetencies.get(noteCompetencies.Competency__c)+Decimal.valueOf(noteCompetencies.Evaluation__c));
                
                    nbCandidateEvaluationByCompetencies.put(noteCompetencies.Competency__c,nbCandidateEvaluationByCompetencies.get(noteCompetencies.Competency__c)+1);
                    
                    if(noteCompetencies.Leader_Report_Notes__r.Contact__c!=null && candidateEvaluationMapByCandidateIdCompetency.containsKey(noteCompetencies.Leader_Report_Notes__r.Contact__c))
                        candidateEvaluationMapByCandidateIdCompetency.get(noteCompetencies.Leader_Report_Notes__r.Contact__c).put(noteCompetencies.Competency__c,Decimal.valueOf(noteCompetencies.Evaluation__c));
                }
                
                if(noteCompetencies.Picklist_values_2__c !=null || noteCompetencies.Multi_select_values__c !=null) {
                  
                    if(dataValuesMapByCompetencyName.containsKey(noteCompetencies.Competency_name__c) && picklistValuesMapByCompetencyName.containsKey(noteCompetencies.Competency_name__c)) {
                        
                        
    
                        if(noteCompetencies.Multi_select_values__c!=null) {
    
                            for(String selectValue: noteCompetencies.Multi_select_values__c.split(',')) {
                                Map<String, Decimal> dataValue = dataValuesMapByCompetencyName.get(noteCompetencies.Competency_name__c);
                                if(dataValue.containsKey(selectValue)) {
                                    dataValue.put(selectValue,dataValue.get(selectValue)+1);
                                    
                                }
                                dataValuesMapByCompetencyName.put(noteCompetencies.Competency_name__c,dataValue);
                            }
    
                        } else {
                            Map<String, Decimal> dataValue = dataValuesMapByCompetencyName.get(noteCompetencies.Competency_name__c);
                            if(dataValue.containsKey(noteCompetencies.Picklist_values_2__c)) {
                                dataValue.put(noteCompetencies.Picklist_values_2__c,dataValue.get(noteCompetencies.Picklist_values_2__c)+1);
                                
                            }
                            dataValuesMapByCompetencyName.put(noteCompetencies.Competency_name__c,dataValue);
                        }
                      
                    }
                    
                }
            }
        }
        
        competenciesAverageByCandidate = JSON.serialize(candidateEvaluationMapByCandidateIdCompetency);
        
       allCompetenciesData = '';
        for(Mandate_competencies__c competency:competencies) {
          
            if(averageCandidateEvaluationByCompetencies.containsKey(competency.Id) && nbCandidateEvaluationByCompetencies.get(competency.Id)>0) {
                if(allCompetenciesData!='')
                    allCompetenciesData = allCompetenciesData+' , ';
                allCompetenciesData = allCompetenciesData+' '+String.valueOf(averageCandidateEvaluationByCompetencies.get(competency.Id)/nbCandidateEvaluationByCompetencies.get(competency.Id));
            }
           
        }
        
       
    }
    
    public void calculateCandiateByStatus() {
        allCandidateStatus = '';
        allCandidateStatusData = '';
        if(!candidateIds.isEmpty()) {
            for(AggregateResult ar:[SELECT Status_Summary_Line__c , COUNT(Contact__c)  FROM Application__c  WHERE Status_Summary_Line__c != 'Private' AND Status_Summary_Line__c != 'Privé' AND Status_Summary_Line__c != 'Client.' AND Mandate__c =:masterId GROUP BY Status_Summary_Line__c ]) {
                if(allCandidateStatus!='')
                    allCandidateStatus = allCandidateStatus+' , ';
                allCandidateStatus = allCandidateStatus+'"'+String.valueOf(ar.get('Status_Summary_Line__c'))+'"';
                
                if(allCandidateStatusData!='')
                    allCandidateStatusData = allCandidateStatusData+' , ';
                allCandidateStatusData = allCandidateStatusData+''+String.valueOf(ar.get('expr0'))+'';
                
                
            }
        }            
        
        
        
    }
    
    public String getAllCandidatesData() {
        String allCandidateData = '';

        if(!candidateIds.isEmpty()) {
            for(Application__c  application:[SELECT Stage__c  FROM Application__c  WHERE Id IN: candidateIds]) {
                if(allCandidateData!='')
                    allCandidateData = allCandidateData+' , ';
                allCandidateData = allCandidateData+'"'+application.Stage__c+'"';
            }
        }            
        
        
        return allCandidateData;
    }
    
    public String getCandidateNameById() {
        Map<String,String> candidateNameMapById = new Map<String, String>();

        if(!candidateIds.isEmpty()) {
            for(Application__c  application:[SELECT Stage__c, Contact__c, Contact__r.Name  FROM Application__c  WHERE Id IN: candidateIds]) {
                if(application.Contact__c!=null)
                    candidateNameMapById.put(application.Contact__c,application.Contact__r.Name);
            }
        }            

        return JSON.serialize(candidateNameMapById);
    }

    public String getCandidateContactIds() {
        Set<String> candidateContactIds = new Set<String>();

        if(!candidateIds.isEmpty()) {
            for(Application__c  application:[SELECT Stage__c, Contact__c, Contact__r.Name  FROM Application__c  WHERE Id IN: candidateIds]) {
                if(application.Contact__c!=null)
                    candidateContactIds.add(application.Contact__c);
            }
        }            
        return JSON.serialize(candidateContactIds);
    }
    
    public String getPicklistValuesMapByCompetencyName() {
        return JSON.serialize(picklistValuesMapByCompetencyName);
    }
    
    public String getDataValuesMapByCompetencyName() {
        Map<String, List<Decimal>> dataValuesMapByCompetencyNameList = new Map<String, List<Decimal>>();
        System.debug(dataValuesMapByCompetencyName);
        for(String cptName: dataValuesMapByCompetencyName.keySet()) {
            dataValuesMapByCompetencyNameList.put(cptName, dataValuesMapByCompetencyName.get(cptName).values());
            
        }
        
        return JSON.serialize(dataValuesMapByCompetencyNameList);
    }
    
    
    public List<SelectOption> getLanguages() {
        List<SelectOption> options = new List<SelectOption>();
        
        Schema.DescribeFieldResult fieldResult =
            Mandate__c.Language__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        for( Schema.PicklistEntry f : ple){
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }       
        return options;
    }
    
    public List<SelectOption> getReportCovers() {
        List<SelectOption> options = new List<SelectOption>();
        
        Schema.DescribeFieldResult fieldResult =
            Mandate__c.Report_Cover__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        for( Schema.PicklistEntry f : ple){
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }       
        return options;
    }
    
    public List<SelectOption> getReportTypes() {
        List<SelectOption> options = new List<SelectOption>();
     	options.add(new SelectOption('Report sent to client', 'Report sent to client'));
        options.add(new SelectOption('Work in Progress', 'Work in Progress'));
        options.add(new SelectOption('Overnight Report', 'Overnight Report'));
        
        return options;
    }
   
    public List<SelectOption> getHCSSortByOptions() {
        List<SelectOption> options = new List<SelectOption>();
     	options.add(new SelectOption('Company Name', 'Company Name'));
        options.add(new SelectOption('Status Summary Line', 'Status Summary Line'));
      //  options.add(new SelectOption('Overnight Report', 'Overnight Report'));
        
        return options;
    }
    
    
    public PageReference generate() 
    {
        Pagereference pref = null;
        if(potentialCandidates == false && biographyReport == false 
            && onePager == false && CV == false && humanCapitalStudy == false
            && hoganReport == false && 
            jobDescription == false && interviewQuestionnaire == false &&
            coverPage == false && psyTest == false){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Validation));    
        }else{          
            system.debug('[Nubik_IdentificationReportController] startDate : '+startDate );
            system.debug('[Nubik_IdentificationReportController] endDate : '+endDate );
            system.debug('[Nubik_IdentificationReportController] humanCapitalStudy '+humanCapitalStudy );
            
           
            if(humanCapitalStudy==true && isColemanProfile) {
                startDate = Date.newInstance(1960, 2, 17);
                endDate = Date.newInstance(2100, 12, 31);
                
            }
            
            if(humanCapitalStudy != null && humanCapitalStudy == true 
                && (startDate == null || endDate == null)){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Dates_Validation));
            }else{
                if(humanCapitalStudy == true && startDate > endDate){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Dates_Compare_Validation));
                }else {
                    if(nextfollowUp==null || nextfollowUp==''){
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Date_Next_Follow_up));
                    }
                    else{
                        //Joel Ojeda - 12/12/2014 - C087338
                        //Since we only have DV0, DV1 and DV2 to pass values to the conga
                        //template, we have to save the Assignment(Mandate) first
                        //with the value selected by the user to be used in the template
                        if(theAssignment!=null){
                            try{
                                //we don't want to replace the original value, will be use 
                                //other one specially for the conga report
                                theAssignment.Conga_Report_Cover__c = reportCover;
                                //update
                                update  theAssignment;          
                            }
                            catch(Exception e){
                                system.debug('[Nubik_IdentificationReportController] Error to save report cover selected.\n\r');
                                system.debug('[Nubik_IdentificationReportController] '+e.getMessage());
                                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
                                return null;
                            }
                        }
                        
                        List<String> reportsNames = new List<String> ();
if(candidateCoverPageReport != null && candidateCoverPageReport) {
                            reportsNames.add(GenerateIdentificationReportBatch.CANDIDATE_COVERPAGE);
                        }
                        if(biographyReport != null && biographyReport) {
                            reportsNames.add(GenerateIdentificationReportBatch.CANDIDATE_BIOGRAPHY_ON_CONTACT);
                        }
                        if(onePager != null && onePager) {
                            reportsNames.add(GenerateIdentificationReportBatch.ONE_PAGER);
                        }
                        if (psyTest != null && psyTest){
                            reportsNames.add(GenerateIdentificationReportBatch.PSY_TEST);
                        }
                        
                        if(potentialCandidates != null && potentialCandidates)
                        {
                            reportsNames.add(GenerateIdentificationReportBatch.POTENTIAL_CANDIDATES);
                        }
                        
                  /*      if(humanCapitalStudy != null && humanCapitalStudy && humanCapitalStudySSL==false && humanCapitalStudySSL != null) {
                            reportsNames.add(GenerateIdentificationReportBatch.HUMAN_CAPITAL_STUDY_ON_MANDATE);
                        }else{
                            startDate = date.today().addDays(-30);
                            endDate = date.today();
                        }
                        
                        if(humanCapitalStudy != null && humanCapitalStudy && humanCapitalStudySSL==true && humanCapitalStudySSL != null)
                        {
                         //  reportsNames.add(GenerateIdentificationReportBatch.HUMAN_CAPITAL_STUDY_ON_MANDATE); 
                        }
                        /*else{
                            startDate = date.today().addDays(-30);
                            endDate = date.today();
                        } */
                        
                  /*      if(humanCapitalStudy!= null)
                        {
                            if(humanCapitalStudy && humanCapitalStudySSL == false)
                            {
                                reportsNames.add(GenerateIdentificationReportBatch.HUMAN_CAPITAL_STUDY_ON_MANDATE);
                            }
                            else if (humanCapitalStudy && humanCapitalStudySSL)
                            {
                               reportsNames.add(GenerateIdentificationReportBatch.HUMAN_CAPITAL_STUDY_ON_MANDATE_SSL);
                            }
                            else
                            {
                                startDate = date.today().addDays(-30);
                                endDate = date.today();
                            }
                        }*/
                        
                        if(humanCapitalStudy!= null)
                        {
                            
                            if(humanCapitalStudy && hcsSortBy == 'Company Name')
                            {
                                reportsNames.add(GenerateIdentificationReportBatch.HUMAN_CAPITAL_STUDY_ON_MANDATE);
                            }
                            else if (humanCapitalStudy && hcsSortBy == 'Status Summary Line')
                            {
                               reportsNames.add(GenerateIdentificationReportBatch.HUMAN_CAPITAL_STUDY_ON_MANDATE_SSL);
                            }
                            else if(humanCapitalStudy)
                            {
                                reportsNames.add(GenerateIdentificationReportBatch.HUMAN_CAPITAL_STUDY_ON_MANDATE);
                            }
                            else
                            {
                                startDate = date.today().addDays(-30);
                                endDate = date.today();
                            }
                        }
                         
                       
                        if(hoganReport != null && hoganReport) {
                            reportsNames.add(GenerateIdentificationReportBatch.HOGAN_REPORT);
                        }
                        if(CV != null && CV) {
                            reportsNames.add(GenerateIdentificationReportBatch.CV);
                        }
                        
                        if(jobDescription != null && jobDescription){
                            reportsNames.add(GenerateIdentificationReportBatch.JOB_DESCRIPTION);
                        }
                        
                        if (interviewQuestionnaire != null && interviewQuestionnaire){
                            reportsNames.add(GenerateIdentificationReportBatch.INTERVIEW_QUESTIONNAIRE);
                        }
                        
                        if (researchStrategy != null && researchStrategy){
                            reportsNames.add(GenerateIdentificationReportBatch.RESEARCH_STRATEGY);
                        }
                        
                        if (coverPage != null && coverPage){
                            reportsNames.add(GenerateIdentificationReportBatch.COVER_PAGE);
                        }
                         
                        
                        
                        /*** Chart Reports ***/
                        if(candidateByStatus != null && candidateByStatus){
                            reportsNames.add(GenerateIdentificationReportBatch.CANDIDATE_STATUS);
                        }
                        
                        if(allCompetenciesAllCandidates != null && allCompetenciesAllCandidates) {
                            reportsNames.add(GenerateIdentificationReportBatch.ALL_COMPETENCIES);                            
                        }
                        
                        if(candidateToDiscuss != null && candidateToDiscuss) {
                            reportsNames.add(GenerateIdentificationReportBatch.CANDIDATE_TO_DISCUSS);                           
                        } 
                        
                        /*** Competency Charts ***/
                        Integer i=1;
                        
                        for(Mandate_competencies__c competency:competencies) {
             
                            if(competencyChart.containsKey(competency.Competencies__c)) {
                                if(competencyChart.get(competency.Competencies__c)) {
                                    reportsNames.add('COMPETENCY__'+i);  
                                    
                                        theAssignment.put('CC_name_'+i+'__c',competency.Competencies__c);
                                        theAssignment.put('CC_title_'+i+'__c', competencyTitle.get(competency.Competencies__c) );
                                        theAssignment.put('CC_text_'+i+'__c',competencyNote.get(competency.Competencies__c) );
                                } 
                            } 
                            i++;
         
                        }
                        update theAssignment;
                        
                        System.debug(reportsNames);
                        /*if(candidateByGender != null && candidateByGender){
                            reportsNames.add(GenerateIdentificationReportBatch.CANDIDATE_GENDER);
                        }
                        if(candidateByRegion != null && candidateByRegion){
                            reportsNames.add(GenerateIdentificationReportBatch.CANDIDATE_REGION);
                        }
                        if(candidateByExperience != null && candidateByExperience){
                            reportsNames.add(GenerateIdentificationReportBatch.CANDIDATE_EXPERIENCE);
                        }
                        if(candidateByEducation != null && candidateByEducation){
                            reportsNames.add(GenerateIdentificationReportBatch.CANDIDATE_EDUCATION);
                        }
                        if(candidateByRevenue != null && candidateByRevenue){
                            reportsNames.add(GenerateIdentificationReportBatch.CANDIDATE_REVENUE);
                        }*/
                         
                        /*** End Chart Reports ***/
                        
                        if(masterId != null && reportsNames.size() > 0) {
                            
                            Database.executeBatch(new GenerateIdentificationReportBatch(reportsNames, 
                                masterId,startDate,endDate, language, UserInfo.getUserId(),nextfollowUp,reportCover,Candidates, reportType,isColemanProfile),1);
                        }
                        pref = new Pagereference('/' + masterId);
                    }
                }
            }
        }
        
        return pref;      
    }
    
    @RemoteAction
    public static void uploadAttachment(String attachmentName, String parentId, String base64) {
         
       String attName  = attachmentName+'.png';
        try {
            List<Attachment> attToDelete = [SELECT Id FROM Attachment WHERE Name = :attName and ParentId =:parentId];
            delete attToDelete;
        } catch(Exception e){}
        
        Attachment att = new Attachment();
        att.Name = attachmentName+'.png';
        att.Body = EncodingUtil.base64Decode(base64.replaceAll('data:image/png;base64,', ''));
        att.parentId = parentId;

        upsert att;
        
    }
}