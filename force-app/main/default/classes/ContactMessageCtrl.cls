public class ContactMessageCtrl {
	
	private Id contactId;
	public boolean showMessage {get; set;} 
    public boolean showMessageContact {get;set;}
	
	public ContactMessageCtrl(ApexPages.StandardController stdController) {
        contactId = stdController.getId();
    }
    
    public void init()
    {
       showMessage = false;
       list<Contact> c = [SELECT Off_Limit_Auto__c ,Off_Limit__c ,Contact_Off_Limit__c 
                            FROM Contact 
                           WHERE Id =: contactId
                           limit 1];
                           
       if(c != null && c.size() > 0)
       {
           if(c[0].Off_Limit__c){
           		showMessage = true;
           }  
           
           if(c[0].Contact_Off_Limit__c)
           {
               showMessageContact = true;
           }
       }      
    }

}