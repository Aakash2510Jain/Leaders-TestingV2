public class DynamicTableComponentController {
    
    @AuraEnabled
    public static DynamicBindingWrapper getRecords(List<String> fieldAPIs, String sObjectType, String filter,String replaceHeaders,String whereClause){
        
        DynamicBindingWrapper dynamicData = new DynamicBindingWrapper();
        List<FieldDataWrapper> wrapperList =  new List<FieldDataWrapper>();
        
        boolean profileMatched = SearchEnginApexCtrl.getProfilename();
        
        SObjectType sObjectName = Schema.getGlobalDescribe().get(sObjectType);
        Map<String,Schema.SObjectField> mfields = sObjectName.getDescribe().fields.getMap();
        
        Map<String,String> headerTokens = new Map<String,String>();
        for(String token : replaceHeaders.split(',')){
            String[] keyValues = token.split(':');
            if(keyValues.size() > 1)
                //wrapperList.add(new FieldDataWrapper(keyValues[1],keyValues[0],'TEXT'));
                headerTokens.put(keyValues[0],keyValues[1]);
        }
        for(String field : fieldAPIs){
            if(headerTokens.containsKey(field))
                wrapperList.add(new FieldDataWrapper(headerTokens.get(field),field,'TEXT'));
            else if(mfields.containsKey(field))
                wrapperList.add(new FieldDataWrapper(mfields.get(field).getDescribe().getLabel(),field,String.valueOf(mfields.get(field).getDescribe().getType())));
        }
        
        String fields = String.join(fieldAPIs,',');
        filter=String.escapeSingleQuotes(filter);
        
        if(profileMatched == true)
        {
            Id recordId=userinfo.getUserId();
            
            if(filter==''){
                dynamicData.sObjectData = Database.query('SELECT '+fields+' FROM '+sObjectType+' WHERE (OwnerId = :recordId '+' OR Consultant__c =:recordId '+' OR Researcher__c=:recordId '+' OR Researcher_3__c =:recordId'+' OR Researcher_4__c =:recordId '+' OR Researcher_5__c =:recordId)'+' ORDER BY LastViewedDate DESC');
            }else{
                if(whereClause =='')
                    dynamicData.sObjectData = Database.query('SELECT '+fields+' FROM '+sObjectType+' WHERE Name LIKE \'%'+filter+'%\' '+' AND (OwnerId = :recordId '+' OR Consultant__c =:recordId '+' OR Researcher__c=:recordId '+' OR Researcher_3__c =:recordId'+' OR Researcher_4__c =:recordId '+' OR Researcher_5__c =:recordId)'+' ORDER BY LastViewedDate DESC');
                else{
                    dynamicData.sObjectData = Database.query('SELECT '+fields+' FROM '+sObjectType+' WHERE Name LIKE \'%'+filter+'%\' '+' AND '+whereClause+' AND (OwnerId = :recordId '+' OR Consultant__c =:recordId '+' OR Researcher__c=:recordId '+' OR Researcher_3__c =:recordId'+' OR Researcher_4__c =:recordId '+' OR  Researcher_5__c =:recordId)'+' ORDER BY LastViewedDate DESC');
                }
            }
        }
        else
        {
            if(filter==''){
                dynamicData.sObjectData = Database.query('SELECT '+fields+' FROM '+sObjectType+' WHERE LastViewedDate != NULL '+'ORDER BY LastViewedDate DESC');
            }else{
                if(whereClause =='')
                    dynamicData.sObjectData = Database.query('SELECT '+fields+' FROM '+sObjectType+' WHERE Name LIKE \'%'+filter+'%\' ORDER BY LastViewedDate DESC');
                else{
                    dynamicData.sObjectData = Database.query('SELECT '+fields+' FROM '+sObjectType+' WHERE Name LIKE \'%'+filter+'%\''+' AND '+whereClause+' ORDER BY LastViewedDate DESC');
                }
            }
        }
        dynamicData.fieldList = wrapperList;
        
        return dynamicData;
    }
    
    
    /* Class to store the dynamic data 
* and list of related fields
*/ 
    public class DynamicBindingWrapper{
        @AuraEnabled
        public List<SObject> sObjectData    { get; set; }
        @AuraEnabled
        public List<FieldDataWrapper> fieldList { get; set; }
    }
    /*
* Class to store the field information
*/ 
    public class FieldDataWrapper{
        @AuraEnabled
        public String label { get; set; }
        @AuraEnabled
        public String apiName { get; set; }
        @AuraEnabled
        public String dataType {get;set;}
        public FieldDataWrapper(String label, String apiName, String dataType){
            this.label = label;
            this.apiName = apiName;
            this.dataType = dataType;
        }
    }
}