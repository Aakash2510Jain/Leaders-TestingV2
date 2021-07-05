public class SearchEnginSortingWrapper {
    public String objName{get;set;}
    public String fieldName{get;set;}
    public String apiName{get;set;}
    
    public SearchEnginSortingWrapper(String objName, String fieldName,String apiName){
        this.objName=objName;
        this.fieldName=fieldName;
        this.apiName=apiName;
    }

}