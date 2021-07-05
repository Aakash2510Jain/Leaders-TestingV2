public class newRelatedAssignmentLightningCont {

    @AuraEnabled
    
     public static List<String> getPicklistValues(String objectType, String selectedField){
        List<String> pickListValuesList = new List<String>();
        Schema.SObjectType convertToObj = Schema.getGlobalDescribe().get(objectType);
        Schema.DescribeSObjectResult res = convertToObj.getDescribe();
        Schema.DescribeFieldResult fieldResult = res.fields.getMap().get(selectedField).getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            pickListValuesList.add(pickListVal.getLabel());
        }     
        return pickListValuesList;
    }
    
    @AuraEnabled
    public static List<Contact> fetchPeopleRec(String searchKeyWord){
        String searchKey = '%'+searchKeyWord+'%';
        system.debug(searchKey);
        List<Contact> returnList = new List<Contact>();
        List<Contact> lstofPeople = [select id,Name,Title,Account.Id,Account.Name,Email from Contact where Name Like:searchKey LIMIT 500];
        
        
        for(Contact con : lstofPeople) {
            returnList.add(con);
        }
        return returnList;
    }

   @AuraEnabled  
    public static List<mandate__c> getAssignmentName(String mandateId){
        string mId = mandateId;
        system.debug(mId);
        
      //  List<String> aName = new List<String>;
        List<mandate__c> aName = [select Name from mandate__c where Id =: mId];
        system.debug(aName);    
        return aName;    
    }
    
    @AuraEnabled 
    public static Application__c save(Id pId, Id mId, String Origin, String SSL, String Description){
       
        Application__c app = new Application__c();
        
        app.Contact__c = pId ;
        app.Mandate__c = mId ;
        app.Origin__c = Origin;
        app.Status_Summary_Line__c = SSL;
        app.Description__c = Description;
        
        
        upsert app;
        
        Meeting_Note__c lrn = new Meeting_Note__c();
        
        lrn.Candidate_Assigned__c = app.Id;
        lrn.Status_Summary_Line__c = app.Status_Summary_Line__c;
        lrn.Description__c = app.Description__c;
        
        insert lrn;
        
        return app;
    }
    
     @AuraEnabled 
     public static List<String> getPickListValuesFA1(String objectType, String selectedField){
        List<String> pickListValuesList = new List<String>();
        Schema.SObjectType convertToObj = Schema.getGlobalDescribe().get(objectType);
        Schema.DescribeSObjectResult res = convertToObj.getDescribe();
        Schema.DescribeFieldResult fieldResult = res.fields.getMap().get(selectedField).getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            pickListValuesList.add(pickListVal.getLabel());
        }     
        return pickListValuesList;
    }
    
}