public class SearchCompanyModel {
	
    public static List<SearchCompanyColumnList__c> getSearchCompanyColumns(){
    List<SearchCompanyColumnList__c> objList=[select Name,FieldAPIName__c,FieldLabelName__c from SearchCompanyColumnList__c];
        return objList;
    }
}