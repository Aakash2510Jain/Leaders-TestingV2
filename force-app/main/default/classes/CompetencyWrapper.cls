public class CompetencyWrapper {
    
    @AuraEnabled
    public String question {get;set;}
    @AuraEnabled
    public String questionType {get;set;}
    @AuraEnabled
    public String richTextValue {get;set;}
    @AuraEnabled
    public List<String> pickVal {get;set;}
    //Response
    @AuraEnabled
    public String singleAnswer {get;set;}
    @AuraEnabled
    public List<String> multiAnswer {get;set;}
    @AuraEnabled
    public String compId {get;set;}
    @AuraEnabled
    public Decimal Rating {get;set;}
    @AuraEnabled
    public String questionRecId {get;set;}
    @AuraEnabled
    public List<One_Pager_Response__c> OnePagerRatingValues {get;set;}
    public CompetencyWrapper(String question,String questionType,List<String> pickVal,String singleAnswer,List<String> multiAnswer,String richTextValue,String compId,String questionRecId,Decimal Rating,List<One_Pager_Response__c> OnePagerRatingValues){
        this.question 			= question;
        this.questionType 		= questionType;
        this.pickVal 			= pickVal;
        this.singleAnswer 		= singleAnswer;
        this.multiAnswer 		= multiAnswer;
        this.richTextValue 		= richTextValue;
        this.Rating             = Rating;
        this.compId             = compId;
        this.questionRecId 		= questionRecId;
        this.OnePagerRatingValues 		= OnePagerRatingValues;
    }
}