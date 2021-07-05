public class ContactController {

    Public Contact conRec {get;set;}

    public ContactController(){
        String conrecId=ApexPages.currentPage().getParameters().get('id');
        System.debug('conrecId==>'+conrecId);
        conRec=[select id,Experience_Gaps__c, Areas_for_Development__c,Personality_and_Image__c,Relevant_Experience__c,Unique_Characteristics__c,Candidate_Motivation__c,Key_Accomplishments__c from contact where id=:conrecId];
    }
}