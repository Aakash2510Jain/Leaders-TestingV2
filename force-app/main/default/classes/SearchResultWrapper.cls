public class SearchResultWrapper
{
    @AuraEnabled
    public String objName{get;set;}
    @AuraEnabled
    public Integer recordCount{get;set;}
    @AuraEnabled
    public List<Sobject> recordList{get;set;}
    @AuraEnabled
    public Map<String,String> objFields{get;set;}
    @AuraEnabled
    public Boolean isMergeRequired{get;set;}
        
    
    public SearchResultWrapper(String objName,Integer recordCount,List<Sobject> recordList,Map<String,String> objFields,Boolean isMergeRequired)
    {
        this.objName = objName;
        this.recordCount = recordCount;
        this.recordList=recordList;
        this.objFields=objFields;
        this.isMergeRequired = isMergeRequired;
    }
    
    
}