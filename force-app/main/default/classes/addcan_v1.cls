public with sharing class addcan_v1 
{
    @AuraEnabled
    Public static String createCon(String Fname,String Lname)
    {
        Contact c = new Contact();
        c.FirstName = Fname;
        c.LastName = Lname;
        
        insert c;
        
        return 'Success';
        
    }
    
}