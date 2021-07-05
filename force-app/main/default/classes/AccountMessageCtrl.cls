public class AccountMessageCtrl {
    
    private Id accountId;
    public boolean showMessage {get; set;} 
  //  public boolean showMessageAccount {get;set;}
    
    public AccountMessageCtrl(ApexPages.StandardController stdController) {
        accountId= stdController.getId();
    }
    
    public void init()
    {
        System.debug('@@@@'+accountId);
       showMessage = false;
       list<Account> a = [SELECT Off_Limit__c
                            FROM Account
                           WHERE Id =: accountId
                           limit 1];
           System.debug('@@@@'+a);                
       if(a != null && a.size() > 0)
       {
           if(a[0].Off_Limit__c){
                showMessage = true;
           }  
       }      
    }

}