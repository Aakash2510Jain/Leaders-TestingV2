public class peopleToastCompLightning {
    @AuraEnabled public boolean rid{get;set;}
    
        
    @AuraEnabled
    public static contactListWrapper getCompanyOffLimit(String recordId)
    {
     //  List<Contact> companyol;
      //  rid = recordId;
      contactListWrapper returnContactDetail = new contactListWrapper();
        //returnContactDetail.ol = [select Off_Limit_Auto__c,Contact_Off_Limit__c from Contact where Id=:'0030B000028jMBrQAM' limit 1];
        String query = ' select Off_Limit_Auto__c,Contact_Off_Limit__c from Contact where Id=:'+recordId;
        returnContactDetail.ol = Database.query(query);
        
        return returnContactDetail;
    }
    
    @AuraEnabled
    public static List<Contact> getContactOffLimit(String recordId)
    {
        List<Contact> contactol;
        contactol =[select Contact_Off_Limit__c from Contact where Id=: '0030B000028jMBrQAM' limit 1];
        
        return contactol;
    }
    
    public class contactListWrapper{
        @AuraEnabled public List<contact> ol{get;set;}
    }

}