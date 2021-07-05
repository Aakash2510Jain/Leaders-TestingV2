/**
 * Created by ET-MARLABS on 11-02-2019.
 */

global class CommonWrapperClass {

    @AuraEnabled public Boolean allCompitencies {get;set;}
    @AuraEnabled public String allCompitenciesTitle {get;set;}
    @AuraEnabled public String allCompitenciesNotes {get;set;}
    @AuraEnabled public List<String> selectedComp {get;set;}
    @AuraEnabled public List<String> selectedSubComp {get;set;}
    
    @AuraEnabled public Boolean candidateByStatus {get;set;}
    @AuraEnabled public Boolean selectToDiscuss {get;set;}
    @AuraEnabled public String candidateByStatusTitle {get;set;}
    @AuraEnabled public String candidateByStatusNotes {get;set;}
    @AuraEnabled public String sortByHCS {get;set;}

    @AuraEnabled public Boolean Candidatetodiscuss {get;set;}
    @AuraEnabled public String CandidatetodiscussTitle {get;set;}
    @AuraEnabled public String CandidatetodiscussNotes {get;set;}

    @AuraEnabled public String hcsSortBy {get;set;}
    @AuraEnabled public String reportType {get;set;}

    @AuraEnabled public Boolean selectCoverPage {get;set;}
    @AuraEnabled public Boolean selectPartnerPage {get;set;}
    @AuraEnabled public Boolean selectCanCoverPage {get;set;}

    @AuraEnabled public String module {get;set;}
    @AuraEnabled public Date nextfollowupdate {get;set;}

    @AuraEnabled public Boolean selectJobDescription {get;set;}
    @AuraEnabled public Boolean selectCandidatestoDiscussByTeam {get;set;}
    @AuraEnabled public Boolean researchStrategy {get;set;}
    @AuraEnabled public Boolean executiveSummary {get;set;}
    @AuraEnabled public Boolean executiveSummary_1 {get;set;}
    @AuraEnabled public Boolean Agenda {get;set;}
    
    @AuraEnabled public Boolean selectCandidatestoDiscuss {get;set;}
    @AuraEnabled public Boolean selectCandidatestoDiscussByStatus {get;set;}
    @AuraEnabled public Boolean selectBiography {get;set;}

    @AuraEnabled public Boolean selectCV {get;set;}
    @AuraEnabled public Boolean selectBoardCV {get;set;}
    @AuraEnabled public Boolean selectOnboarding {get;set;}
    @AuraEnabled public Boolean selectOnePager {get;set;}
    @AuraEnabled public Boolean selectCandidateIntro {get;set;}
    @AuraEnabled public Boolean selectSelfAss {get;set;}
    @AuraEnabled public Boolean selectReferences {get;set;}
    
    @AuraEnabled public Boolean selectPsyTest {get;set;}
    @AuraEnabled public Boolean selectInterviewQuestionnaire {get;set;}
    @AuraEnabled public Boolean selectRadarGraph {get;set;}


    @AuraEnabled public Boolean selectHumanCapitalStudy {get;set;}
    @AuraEnabled public String companyName {get;set;}

    @AuraEnabled public Date hcsStartDate {get;set;}
    @AuraEnabled public Date hcsEndDate {get;set;}
    @AuraEnabled public String masterId {get;set;}
    @AuraEnabled public List<String> selectedcandidateIds{get;set;}
    @AuraEnabled public List<String> partners{get;set;}

    public class DisplayAppRecords {

        @AuraEnabled public boolean isSelected;
        @AuraEnabled public Application__c rec;


        public DisplayAppRecords(Boolean isSelected,Application__c rec){
            this.isSelected = isSelected;
            this.rec = rec;
        }
        public DisplayAppRecords(){

        }
    }

}