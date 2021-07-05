public class SearchEnginModel {
    public static List<ObjectListForSearch__c> getObjectToBeSearch(){
        List<ObjectListForSearch__c> objList=[select Name,FieldName__c,MergeDuplicate__c,Order__c,FieldToQuery__c,Objects_To_be_included_for_profile__c from ObjectListForSearch__c order by Order__c];
	return objList;
    }

}