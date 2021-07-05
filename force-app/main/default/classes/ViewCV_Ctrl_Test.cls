@isTest
public class ViewCV_Ctrl_Test {
    static testMethod void myUnitTest(){ 
    Account a = new Account();
    a.Name= 'Test Account';
    insert a;
    
    
    Contact c= new Contact();
    c.FirstName = 'test';
    c.LastName = 'test';
    c.Functional_Area_1__c ='Finance';
    c.AccountId = a.Id ;
    
    insert c ;
        
    attachment att = new attachment();
        att.Name = 'Test Attachment ';
            att.ParentId = c.id;
        
    ApexPages.StandardController sc = new ApexPages.StandardController(c); 
        ViewCV_Ctrl  vcv = new ViewCV_Ctrl(sc);
        vcv.pdf = 'test';
        vcv.contactid = 'test';
        vcv.att = att ;
       
        
    }  
    
    
    
    

}