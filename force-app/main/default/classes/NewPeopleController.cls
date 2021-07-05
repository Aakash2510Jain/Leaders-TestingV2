public class NewPeopleController {
    
    public Contact contact {get;set;}
    public Account account {get;set;}
    
    public String searchQueryAccount {get;set;} 
    public List<Account> accountResults {get;set;}
    public List<Contact> contactResults {get;set;} 
    public String accountSelected {get;set;}
  //  public string CurrentUserTeam;
    public String state {get;set;}
    
    public Boolean contactAlreadyExist {get;set;}
    
    public NewPeopleController(ApexPages.StandardController controller) {
        
        contact = new Contact();
        account = new Account();
        
        String recordType = null;
        if(Apexpages.currentPage().getParameters().containsKey('RecordType'))
        	recordType = Apexpages.currentPage().getParameters().get('RecordType');
        
        if(recordType!=null)
        	contact = new Contact(RecordTypeId=recordType);        
        
        contactAlreadyExist = false;
        
      //   CurrentUserTeam = [Select Team__c From User Where Id = :UserInfo.getUserId()][0].Team__c;

        
    }

    public PageReference cancelContact() {

		PageReference pageRef = new PageReference('/003/o');
                
        pageRef.setRedirect(true);
        return pageRef; 
    } 
    
     public PageReference saveContact() {
         
        //Check if contact already exist.
        
        Contact currentContact = null;
         String CurrentUserTeam = [Select Team__c From User Where Id = :UserInfo.getUserId()][0].Team__c;
         system.debug('Team ='+CurrentUserTeam);
         
         try {
             
            If(CurrentUserTeam == 'Team 1'|| CurrentUserTeam == 'Team 2' || CurrentUserTeam == 'Team 7' || CurrentUserTeam == 'Team 4' )
            {
               currentContact = [SELECT Id FROM Contact WHERE FirstName Like :contact.FirstName AND LastName Like :contact.LastName AND (Owner.Team__c =: 'Team 1' OR Owner.Team__c =: 'Team 2' OR Owner.Team__c =: 'Team 7' OR Owner.Team__c =: 'Team 4') LIMIT 1]; 
               contactResults = [select Id,Name,Contact.AccountId,Contact.Account.Name,Title from Contact where FirstName Like :contact.FirstName AND LastName Like :contact.LastName AND (Owner.Team__c =: 'Team 1' OR Owner.Team__c =: 'Team 2' OR Owner.Team__c =: 'Team 7' OR Owner.Team__c =:'Team 4') ] ;  
               system.debug('Inside If');
            }
            else 
            {
               currentContact = [SELECT Id FROM Contact WHERE FirstName Like :contact.FirstName AND LastName Like :contact.LastName AND Owner.Team__c =: CurrentUserTeam  LIMIT 1];  
               contactResults = [select Id,Name,Contact.AccountId,Contact.Account.Name,Title from Contact where FirstName Like :contact.FirstName AND LastName Like :contact.LastName AND Owner.Team__c =: CurrentUserTeam ] ;  
            }
         	
            
         } catch(Exception e){}
         
         if(currentContact==null) {
			insert contact;
 		
            PageReference pageRef = new PageReference('/003/o');
                    
            pageRef.setRedirect(true);
            return pageRef; 
         } else {
             contactAlreadyExist = true;
             return null;
         }
         
         
         
         
         
	}
    
    public PageReference saveDuplicateContact() {
        
        insert contact;
 		
        PageReference pageRef = new PageReference('/003/o');
        
        pageRef.setRedirect(true);
        return pageRef; 
        
    }
    
    public void cancelDuplicateContact() {
        contactAlreadyExist = false;
    }
    
     public void saveAccount() {
		
         if(account.Name!='' && account.Industry_Types__c!=null) {
             insert account;
             contact.AccountId = account.Id;
             account = new Account();
         }
	}
    
     public void searchAccount() {
         String searchQueryEncode = '%'+searchQueryAccount+'%';
		 state = 'searchAccount';
         accountResults = [SELECT Id, Name FROM Account WHERE Name Like :searchQueryEncode ORDER BY Name LIMIT 100];

    }
    
     public void newAccount() {
         state = 'newAccount';
         if(searchQueryAccount!='') {
             account.Name = searchQueryAccount;
         }
        
    }
    
    public void selectAccount() {
       contact.AccountId = accountSelected;
    }
    
     public void setSearchQueryAccount() {
        searchAccount();
    }
    
    public void cancelAccount() {
        
    }
    
    public class ResultWrapper {
        
        public string conName{get;set;}
        public string comName{get;set;}
        
        public ResultWrapper(){}
        
     /*   public ResultWrapper(Contact contact)
        {
            this.contact = contact ;
        }*/
         
         
        
    }
}