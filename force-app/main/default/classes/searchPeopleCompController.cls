public class searchPeopleCompController {
    
    @Auraenabled
    public static List<Contact> fetchPeopleRec(String searchKeyWord){
        String searchKey = '%'+searchKeyWord.escapeUnicode()+'%';
        system.debug(searchKey);
        List<Contact> returnList = new List<Contact>();
        List<Contact> lstofPeople = [select id,Name,Title,Account.Id,Account.Name,Email,MobilePhone,Phone,Off_Limit__c,hasCV__c,Contact_Off_Limit__c from Contact where Name Like:searchKey Or Title Like:searchKey LIMIT 500];
             
        for(Contact con : lstofPeople) {
            returnList.add(con);
        }
        return returnList;
    }
    
    @Auraenabled
    public static List<Account> fetchCompanyRec(String searchKeyWord){
        String searchKey = '%'+searchKeyWord.escapeUnicode()+'%';
        system.debug(searchKey);
        List<Account> returnList = new List<Account>();
        List<Account> lstofCompanies = [select Id,Name,Industry_Types__c from Account where Name Like: searchKey Limit 500];
        
        for(Account acc : lstofCompanies ){
            returnList.add(acc);
        }
        
        return returnList;
    }
    
    @Auraenabled
    public static List<Mandate__c> fetchAssignmentRec(String searchKeyWord){
        String searchKey ='%'+searchKeyWord+'%';
        system.debug(searchKey);
        List<Mandate__c> returnList = new List<Mandate__c>();
        List<Mandate__c> lstofAssignments = [ select Id, Name ,Company__c,Company__r.Name,Assignment_Status__c from Mandate__c where Company__r.Name like: searchKey limit 500];
        
        for(Mandate__c man : lstofAssignments ){
            returnList.add(man);
        }
        
        return returnList;
        
        
    }
    
    @Auraenabled
    public static List<Business_Development__c> fetchBDRec(String searchKeyWord){
        String searchKey ='%'+searchKeyWord+'%';
        system.debug(searchKey);
        List<Business_Development__c> returnList = new List<Business_Development__c>();
        List<Business_Development__c> lstofBDs = [ select Id, Name , Account_Name__c, Account_Name__r.Name,Stage__c from Business_Development__c where Account_Name__r.Name like: searchKey limit 500];
        
        for(Business_Development__c man : lstofBDs ){
            returnList.add(man);
        }
        
        return returnList;
        
    }
    
   /* public class fetchPeopleWrapper{
        @Auraenabled public List<Contact> lstFetchPeople{get;set;}
    }*/

}