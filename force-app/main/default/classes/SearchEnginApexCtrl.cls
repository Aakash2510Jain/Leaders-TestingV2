public  without sharing class SearchEnginApexCtrl  {
    
    public static String OBJ_NAME = '';
    public static String CLASS_NAME 					= 'SearchEnginApexCtrl';
    public static String METHOD_NAME 					= '';
    public static Boolean Profiletobeexcluded = false;
    public class keyValueWrap{
        @AuraEnabled
        public string apiName{get;set;}
        @AuraEnabled
        public String labelName{get;set;}
        
        public keyValueWrap(string apiName,String labelName){
            this.apiName=apiName;
            this.labelName=labelName;
            
        }
    }
    
    @AuraEnabled
    public static Boolean getProfilename()
    {
        List<Profile> PROFILE = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
        String MyProfileName = PROFILE[0].Name;
        System.debug('pr name'+MyProfileName);
        
        List<Profile_excluded__c> profList=[select Profile_Name__c,To_Be_Excluded__c from Profile_excluded__c];
        System.debug('pr name'+profList);
        
        for( Profile_excluded__c prof:profList)
        { 
            if(prof.Profile_Name__c == MyProfileName && prof.To_Be_Excluded__c == true)
            {
                Profiletobeexcluded = true;
            }
            System.debug('pr value'+Profiletobeexcluded);
        }
        return Profiletobeexcluded;
    }
    
    @AuraEnabled
    public static String getmandatename(String manId)
    {
        List<Mandate__c> manlist  = [SELECT Name FROM Mandate__c WHERE Id = :manId];
        
        if(manlist.size() > 0)
        {
        return manlist[0].Name;
        }
        else
        {
            return '';
        }
        
    }
    @AuraEnabled
    public static List<String> getCustomSetting(Boolean ProfValue){
        Map<String, Schema.SObjectType> sObjectMap = Schema.getGlobalDescribe(); 
        List<String> objNmList=new List<String>();
        List<String> objLabelNameList=new List<String>();
        List<ObjectListForSearch__c> objList=SearchEnginModel.getObjectToBeSearch();
        
        system.debug('Value of profile :'+ProfValue);
        
        for(ObjectListForSearch__c obj:objList)
        {
            if(ProfValue == false)
            {
                if(obj.Objects_To_be_included_for_profile__c == true)
                {
                    objNmList.add(obj.Name);
                }
                System.debug('Object list for excluded profile :'+objNmList);
            }
            else
            {
                objNmList.add(obj.Name);    
                System.debug('Object list for Normal profile :'+objNmList);
            }
        }
        
        for(String str:objNmList)
        {
            string objLabel = sObjectMap.get(str).getDescribe().getLabel();
            objLabelNameList.add(objLabel);
            System.debug('Object list for Normal profile :'+objLabelNameList);
        }
        
        return objLabelNameList;
    }
    public static List<String> getFieldsName(String objName){
        List<String> fieldsName=objName.split(',');
        return fieldsName;
    }
    @AuraEnabled
    public static List<SearchResultWrapper> getRecordList(String searchValue,Boolean ProfValue)
    {
        try{
            
            List<ObjectListForSearch__c> objList=SearchEnginModel.getObjectToBeSearch();
            
            List<ObjectListForSearch__c> obList=  new List<ObjectListForSearch__c>();
            
            system.debug('@@@'+objList);
            
            Map<String,Boolean> mergeDuplicateByObject = new Map<String,Boolean>();
            
            System.debug('@@@@'+searchValue);
            
            searchValue=String.escapeSingleQuotes(searchValue);
            
            
            for(ObjectListForSearch__c obj:objList)
            {
                if(ProfValue == false)
                {
                    if(obj.Objects_To_be_included_for_profile__c == true)
                    {
                        mergeDuplicateByObject.put(obj.Name,obj.MergeDuplicate__c);
                        obList.add(obj);
                    }
                    System.debug('map  for excluded profile :'+mergeDuplicateByObject);
                }
                else
                {
                    mergeDuplicateByObject.put(obj.Name,obj.MergeDuplicate__c);  
                    obList.add(obj);
                    System.debug('map  for Normal profile :'+mergeDuplicateByObject);
                }
                
                
                //mergeDuplicateByObject.put(obj.Name,obj.MergeDuplicate__c);
            }
            String searchQuery = 'FIND \'' + searchValue + '\' IN ALL FIELDS RETURNING ';
            
            for(integer i=0; i<obList.size(); i++)
            {
                if(i==obList.size()-1)
                {
                    searchQuery+=obList[i].Name+'('+obList[i].FieldName__c+')';
                } 
                else
                {
                    searchQuery+=obList[i].Name+'('+obList[i].FieldName__c+')'+',';    
                }
            }
            List<SearchResultWrapper> searchResultWrap = new List<SearchResultWrapper>();
            //System.debug('@@@@@'+searchQuery);
            
            List<List<sobject>> objL=search.query(searchQuery);
            //  System.debug('@@@@@'+objL);
            for(Integer i=0; i<objL.size(); i++){
                id objId; 
                List<sObject> alist=objL[i];
                if(!alist.isEmpty()) objId=alist[0].id;
                if(objId != null){
                    // System.debug('@@@@@');
                    String objName=objId.getSObjectType().getDescribe().getName();
                    ObjectListForSearch__c objfield = ObjectListForSearch__c.getValues(objName);
                    
                    Map<String,String> fieldsName= getFieldMap(objfield.FieldName__c,objName);
                    searchResultWrap.add(new SearchResultWrapper(objName,alist.size(),alist,fieldsName,mergeDuplicateByObject.get(objName)));
                }
                else{
                    
                }
            }
            Search_History__c searchHistory=new Search_History__c(SearchValue__c=searchValue,User__c=UserInfo.getUserId());
            insert searchHistory;
            
            //System.debug(searchResultWrap);
            return searchResultWrap;
        }catch(Exception e){
            System.debug('@@@@'+e.getMessage()+' AT '+e.getLineNumber()+' STACKTRACE '+e.getStackTraceString());
            return null;
        }
        
    }
    public static Map<String,String> getFieldMap(String fieldList,String objName){
        try{
            
            List<String> fieldsNameList=getFieldsName(fieldList);
            Map<String,String> fieldsName = new Map<String,String>();
            String[] types = new String[]{objName};
                Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
            
            Schema.SObjectType ObjectSchema = schemaMap.get(objName);   
            Map<String, Schema.SObjectField> fieldMap = ObjectSchema.getDescribe().fields.getMap();
            
            // System.debug('@@@@'+fieldsNameList);
            for (String fieldName: fieldMap.keySet()) 
            {  
                //String fName = fieldMap.get(fieldName).getDescribe().getLabel();
                if(fieldsNameList.contains(fieldMap.get(fieldName).getDescribe().getName()))
                    fieldsName.put(fieldMap.get(fieldName).getDescribe().getLabel(), fieldMap.get(fieldName).getDescribe().getName());
            }
            return fieldsName;
        }catch(Exception e){
            System.debug('@@@@'+e.getMessage()+' AT '+e.getLineNumber()+' STACKTRACE '+e.getStackTraceString());
            return null;
        }
    } 
    @AuraEnabled
    public static String deleteRecord(List<Id> idList){
        String res='';
        String objName=idList[0].getSObjectType().getDescribe().getName();
        Database.DeleteResult[] drList= Database.delete(idList,true);
        for(Database.DeleteResult dr : drList) {
            if (dr.isSuccess()) {
                // Operation was successful, so get the ID of the record that was processed
                System.debug('Successfully deleted account with ID: ' + dr.getId());
                res='Success';
            }
            else {
                // Operation failed, so get all errors                
                for(Database.Error err : dr.getErrors()) {
                    System.debug('The following error has occurred.');                    
                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                    System.debug('Account fields that affected this error: ' + err.getFields());
                    res='unSucess';
                }
            }
        }
        return objName;
    }
    public static String getFieldList(List<Id> objIdList){
        
        // FieldToQuery
        //Map<String,String> fieldsName= getFieldMap(objfield.FieldName__c,objName);
        Set<String> fieldToBeMerged = new Set<String>();
        String objName=objIdList[0].getSObjectType().getDescribe().getName();
        
        ObjectListForSearch__c objfield = ObjectListForSearch__c.getValues(objName);
        //System.debug('objField'+objfield.FieldToQuery__c);
        if(objfield.FieldToQuery__c != null)
            fieldToBeMerged = new Set<String>((objfield.FieldToQuery__c).split(','));
        // System.debug(fieldToBeMerged);
        
        List<SObjectField> fieldlist=new List<SObjectField>();
        map<string,SObjectField> fList = schema.getGlobalDescribe().get(objName).getDescribe().fields.getMap();
        //System.debug('fList=='+fList);
        for(string str: fList.keySet()){
            //System.debug('str=='+str);
            /*if(!fieldToBeMerged.isEmpty() && fieldToBeMerged.contains(fList.get(str).getDescribe().getName())){
System.debug(fList.get(str).getDescribe().getName());

}*/
            fieldlist.add(fList.get(str));
            
        }
        //  System.debug('fList.keyset==='+fieldlist.size());      
        //System.debug('@@@@'+fieldlist.size());
        String fields='';
        for(integer i=0; i<fieldlist.size(); i++){
            if(i==fieldlist.size()-1){
                fields=fields+fieldlist[i];
            }
            else{
                fields=fields+fieldlist[i]+',';
            }
        }
        return fields;
    }
    public static String getUpdatableFieldList(Id objIdList){
        
        Set<String> fieldToBeMerged = new Set<String>();
        String objName=objIdList.getSObjectType().getDescribe().getName();
        
        ObjectListForSearch__c objfield = ObjectListForSearch__c.getValues(objName);
        if(objfield.FieldToQuery__c != null)
            fieldToBeMerged = new Set<String>((objfield.FieldToQuery__c).split(','));
        
        List<SObjectField> fieldlist=new List<SObjectField>();
        map<string,SObjectField> fList = schema.getGlobalDescribe().get(objName).getDescribe().fields.getMap();
        for(string str: fList.keySet()){
            if(fList.get(str).getDescribe().isUpdateable()){
                fieldlist.add(fList.get(str));
            }
        }
        //  System.debug('fList.keyset==='+fieldlist.size());      
        //  System.debug('@@@@'+fieldlist.size());
        String fields='';
        for(integer i=0; i<fieldlist.size(); i++){
            if(i==fieldlist.size()-1){
                fields=fields+fieldlist[i];
            }
            else{
                fields=fields+fieldlist[i]+',';
            }
        }
        return fields;
    }
    
    //This method take object ID and return object Name
    public static String getObjectName(Id objId){
        String objName=objId.getSObjectType().getDescribe().getName();
        return objName;
    }
    //This method return records of objects
    @AuraEnabled
    public static List<sobject> getRecord(List<Id> objIdList){
        //  System.debug('@@@@@'+objIdList);
        String objName=SearchEnginApexCtrl.getObjectName(objIdList[0]);
        String fields=SearchEnginApexCtrl.getFieldList(objIdList);
        //  System.debug('fields===>'+fields);
        String searchQuery='SELECT '+fields+' FROM '+objName+' WHERE Id IN:objIdList';
        //System.debug('@@@'+searchQuery);
        List<sobject> recList=Database.query(searchQuery);
        return recList;
    }
    //This method return field's label name of objects
    @AuraEnabled
    public static List<keyValueWrap> getFieldLabelName(List<Id> objIdList){
        String objName=SearchEnginApexCtrl.getObjectName(objIdList[0]);
        
        Set<String> fieldToBeMerged = new Set<String>();
        
        ObjectListForSearch__c objfield = ObjectListForSearch__c.getValues(objName);
        if(objfield.FieldToQuery__c != null)
            fieldToBeMerged = new Set<String>((objfield.FieldToQuery__c).split(','));
        List<keyValueWrap> labelName=new List<keyValueWrap>();
        
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType ObjectSchema = schemaMap.get(objName);   
        Map<String, Schema.SObjectField> fieldMap = ObjectSchema.getDescribe().fields.getMap();
        /*  for (String fieldName: fieldMap.keySet()) 
{
if(fieldToBeMerged.contains(fieldMap.get(fieldName).getDescribe().getName()))
labelName.add(new keyValueWrap(fieldMap.get(fieldName).getDescribe().getName(),fieldMap.get(fieldName).getDescribe().getLabel()));
}*/
        for(String fieldName:fieldToBeMerged)
        {
            if(fieldMap.containsKey(fieldName)){
                labelName.add(new keyValueWrap(fieldMap.get(fieldName).getDescribe().getName(),fieldMap.get(fieldName).getDescribe().getLabel())); 
            }
        }    
        
        
        
        return labelName;
    }
    //This Method will copy all the values from TobeDeletedRecord to WinnerRecord
    //Added by Mohini 
    public static sobject getWinnerAccountFieldValues(sObject winnerRec,List<String> toBeDeletedRecId){
        try{
            
            System.debug('Hi i am get Winner Method');
            String objName=SearchEnginApexCtrl.getObjectName(winnerRec.Id);
            SearchEnginApexCtrlHelper.MASTER_OBJ_NAME = objName;
            String fields=SearchEnginApexCtrl.getUpdatableFieldList(winnerRec.Id);
            
            List<String> fieldsList=fields.split(',');
            List<String> winnerRecId=new List<String>{winnerRec.Id};
                String searchQuery='SELECT '+fields+' FROM '+objName+' WHERE Id IN:winnerRecId';
            
            List<sobject> winnerRecList=Database.query(searchQuery);        
            
            String objName1=SearchEnginApexCtrl.getObjectName(toBeDeletedRecId[0]);
            String searchQuery1='SELECT '+fields+' FROM '+objName1+' WHERE Id IN:toBeDeletedRecId';
            List<sobject> deleteRecList=Database.query(searchQuery1);
            
            List<String> winnerRecNullFields=new List<String>();
            for(sobject wRec:winnerRecList){
                for(String field:fieldsList){
                    if(wRec.get(field)==null){
                        winnerRecNullFields.add(field);
                    }
                }
            }
            //Copy field's value from deleted Record
            Schema.SObjectType accountType = Schema.getGlobalDescribe().get(objName);
            SObject obj = accountType.newSObject();
            obj.Id=winnerRec.id;
            for(sobject dRec:deleteRecList){
                for(String field:winnerRecNullFields){
                    if(dRec.get(field)!=null){
                        winnerRec.put(field,dRec.get(field));
                    }
                }
            }  
            
            return winnerRec;   
        }catch(Exception e){
            System.debug( e.getMessage() +'at '+ e.getLineNumber());
            e.getStackTraceString();
            e.getLineNumber();            
        }
        return null;
    }
    @AuraEnabled
    public static String mergeDuplicate(List<String> recordIdDeletion,sObject recAcc,boolean checkAssigment,boolean checkAttachment,boolean checkFile,boolean checkActivity){
        try
        {
            System.debug('merge Duplice Delted Id==>'+recordIdDeletion);
            System.debug('merge duplicate winer account record==>'+recAcc.Id);
            METHOD_NAME									= 'mergeDuplicate';
            System.debug('recordIdDeletion==>'+recordIdDeletion);
            
            SearchEnginApexCtrlHelper.RECORD_ID_TO_BE_DELETED = recordIdDeletion;
            System.debug('RECORD_ID_TO_BE_DELETED==>'+SearchEnginApexCtrlHelper.RECORD_ID_TO_BE_DELETED);
            SearchEnginApexCtrlHelper.WINNER_RECORD_ID = recAcc.Id;
            System.debug('WINNER_RECORD_ID'+SearchEnginApexCtrlHelper.WINNER_RECORD_ID);
            
            
            if(recordIdDeletion.size()==1){
                SearchEnginApexCtrl.getWinnerAccountFieldValues(recAcc,recordIdDeletion);
                 System.debug('recordIdDeletion');
            }
            // Update/Merge Related records
              system.debug('deleteOrMergeDuplicate');
            SearchEnginApexCtrlHelper.deleteOrMergeDuplicate();
            
            if(recAcc!=null){
                update recAcc;
            }
            if(!recordIdDeletion.isEmpty()){
                database.delete(recordIdDeletion);  
            }
            return 'Record Merged Successfully !!!';
        }     
        catch(Exception e){
            System.debug( e.getMessage() +'at '+ e.getLineNumber());
            ErrorLog.logError(e,CLASS_NAME,METHOD_NAME);
            throw new AuraHandledException('Error :'+e.getMessage() +'at '+ e.getLineNumber());
            
        }
        
    }
    @AuraEnabled
    public static List<Search_History__c> recentSearch(){
        
        List<Search_History__c> recentSearchList=new List<Search_History__c>();
        List<Id> recentSearchDuplicateList=new List<Id>();
        Set<String> setList=new Set<String>();
        
        List<Search_History__c> serHis = [select Name,SearchValue__c,User__c from Search_History__c where User__c=:userInfo.getUserId() AND SearchValue__c != null Order By CreatedDate DESC];
        Integer i = 0;
        for(Search_History__c search:serHis){
            
            if(setList.add(search.SearchValue__c) && i < 10){
                recentSearchList.add(search);
                i++;
            }  
            else{
                recentSearchDuplicateList.add(search.Id);    
            }
            
        }
        Database.delete(recentSearchDuplicateList); 
        return recentSearchList;
    }
    public static Map<String,string> getChildObject(String objName){
        String parentObjectName = objName;  
        Map<string,string> childObjList = new Map<string,string>();
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        for(String ss1: schemaMap.keyset()){
            Schema.SObjectType objToken=schemaMap.get(ss1);
            if(ss1.equalsignorecase(parentObjectName)){
                
                Schema.DescribeSObjectResult objDescribe=objToken.getdescribe();
                List<Schema.ChildRelationship> childRelationshipList = objDescribe.getChildRelationships();
                for(Schema.ChildRelationship ss:childRelationshipList){
                    string RelationshipName=ss.getRelationshipName();
                    string childObjectName = string.valueof(ss.getChildSObject());
                    string childFieldToken = string.valueof(ss.getField());
                    childObjList.put(childObjectName,childFieldToken);
                }
                
            }
        }
        return childObjList;
    }
}