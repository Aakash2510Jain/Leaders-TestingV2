public with sharing class NewRelatedAssignmentController {
    
    
    public Application__c app {get;set;}
    public Contact contact {get;set;}
    public Account account {get;set;}
    
    private String retUrl = '';
    private String saveUrl = '';
    public String pageType {get;set;}
    public String state {get;set;}
    public String searchQuery {get;set;}
    public String copyOfsearchQuery;
    public String searchQueryAccount {get;set;}
    public String contactSelected {get;set;}
    public String accountSelected {get;set;}
    
    public boolean contactOffLimit {get;set;}
    public boolean offlimit ;
    public boolean conofflimit ;
    public contact conoff;
    
    public List<Contact> contactResults {get;set;}
    public List<Account> accountResults {get;set;}
    
    public NewRelatedAssignmentController(Apexpages.Standardcontroller con) {
        
        app = new Application__c();
        contact = new Contact();
        account = new Account();
        
        contactResults = new List<Contact>();
        accountResults = new List<Account>();
        
        state = 'search';
        searchQuery = '';
        searchQueryAccount = '';
        pageType = 'Candidate';
        if(ApexPages.currentPage().getParameters().get('CF00NU00000042Zrm_lkid')!=null && ApexPages.currentPage().getParameters().get('CF00NU00000042Zrm_lkid')!='') 
            app.Mandate__c = ApexPages.currentPage().getParameters().get('CF00NU00000042Zrm_lkid');
        
        saveUrl = ApexPages.currentPage().getParameters().get('saveURL');
        
        if(ApexPages.currentPage().getParameters().get('CF00NU00000042Zpg_lkid')!=null) 
        	app.Contact__c = ApexPages.currentPage().getParameters().get('CF00NU00000042Zpg_lkid');
        
          system.debug('app.Contact__c'+app.Contact__c);
          system.debug('app.Contact__c.Off-Limit'+app.Contact__r.Off_Limit__c);
         	
        
        
         retUrl = ApexPages.currentPage().getParameters().get('retURL');
         
        pageType = ApexPages.currentPage().getParameters().get('pageType');
        
		Boolean isColemanProfile = false;
        
        Id profileId = userinfo.getProfileId();
        String profileName = [select Name from profile where id = :profileId].Name;
          
        if(profileName.startsWith('Force.com Leaders Coleman'))
            isColemanProfile=true;
        
        if(isColemanProfile) {
            contact.MailingCountryCode = 'US';
            account.BillingCountryCode = 'US';
        }
        
        if(pageType=='ClientList')
            app.Status_Summary_Line__c = 'Client.';
        else if(pageType=='SourceList')
            app.Status_Summary_Line__c = 'Identified as a source.';
        
        contactOffLimit = false;
        
    }
    
    
    public PageReference save() {

        saveApp();
        
		PageReference pageRef = new PageReference(saveUrl);
    	pageRef.setRedirect(true);
    	return pageRef; 
	} 
    
    public PageReference saveNew() {
		
     /*   system.debug(' Contact Off-Limit value :'+app.Contact__r.Off_Limit__c);
        
        if( offlimit == true || conofflimit == true ) 
        {
            contactOffLimit = true;
            return null;
        }
        
        else{ 
           upsert app;
        
        if(saveUrl==null || saveUrl =='')
            saveUrl =   '/'+app.Contact__c; 
        
        Meeting_Note__c note = new Meeting_Note__c(Candidate_Assigned__c =app.Id,Status_Summary_Line__c =app.Status_Summary_Line__c,Description__c =app.Description__c);
        insert note; 
            
        PageReference pageRef = new PageReference(ApexPages.currentPage().getUrl());
    	pageRef.setRedirect(true);
    	return pageRef;     
            
            
        } */
        
        
        saveApp();
        
        PageReference pageRef = new PageReference(ApexPages.currentPage().getUrl());
    	pageRef.setRedirect(true);
    	return pageRef; 
	} 
    
    private void saveApp() {
        
      /*  system.debug(' Contact Off-Limit value :'+app.Contact__r.Off_Limit__c);
        
        if( offlimit == true || conofflimit == true ) 
        {
            contactOffLimit = true;
            return null;
        }
        
        else{ */
           upsert app;
        
        if(saveUrl==null || saveUrl =='')
            saveUrl =   '/'+app.Contact__c; 
        
        Meeting_Note__c note = new Meeting_Note__c(Candidate_Assigned__c =app.Id,Status_Summary_Line__c =app.Status_Summary_Line__c,Description__c =app.Description__c);
        insert note; 
         
     /*   PageReference pageRef = new PageReference(saveUrl);
    	pageRef.setRedirect(true);
    	return pageRef; */    
            
            
        }
        
        
        
       
        
        
        
     /*   upsert app;
        
        if(saveUrl==null || saveUrl =='')
            saveUrl =   '/'+app.Contact__c; 
        
        Meeting_Note__c note = new Meeting_Note__c(Candidate_Assigned__c =app.Id,Status_Summary_Line__c =app.Status_Summary_Line__c,Description__c =app.Description__c);
        insert note;*/
        
        
    
    
 /*   public PageReference viewContact()
    {
        return new Pagereference('/'+contactSelected);
    }*/
    
   /* public PageReference saveAppWithOffLimit()
    {
       upsert app;
        
        if(saveUrl==null || saveUrl =='')
            saveUrl =   '/'+app.Contact__c; 
        
        Meeting_Note__c note = new Meeting_Note__c(Candidate_Assigned__c =app.Id,Status_Summary_Line__c =app.Status_Summary_Line__c,Description__c =app.Description__c);
        insert note;
        
        PageReference pageRef = new PageReference(saveUrl);
    	pageRef.setRedirect(true);
    	return pageRef; 
 
    }*/


  /* public void cancelAppWithOffLimit()
   {
       contactOffLimit = false;
       app.Contact__c = null;
       app.Status_Summary_Line__c = null;
   }*/
    
    public void cancelContact() {
        state = 'search';
        searchQuery = '';
    } 
    
     public void saveContact() {
		
         if(contact.AccountId!=null && contact.FirstName!=null && contact.LastName!=null && contact.Functional_Area_1__c!=null) {
            insert contact;
         	app.Contact__c = contact.Id;   
         	contact = new Contact();
         } else {
             state = 'newContact';
             app.Contact__c = null;
         }  
	}
    
     public void cancelAccount() {
        state = 'newContact';
        searchQuery = '';
    } 
    
     public void saveAccount() {
		
         if(account.Name!='' && account.Industry_Types__c!=null) {
             insert account;
             contact.AccountId = account.Id;
             account = new Account();
             
             state = 'newContact'; 
         }
	}
	
	public PageReference cancel() {

    	PageReference pageRef = new PageReference(saveUrl);
    	pageRef.setRedirect(true);
    	return pageRef; 
	}
    
    public void searchContact() {
         Integer word= 1;
         state = 'search';
         copyOfsearchQuery = searchQuery;
         searchQuery = searchQuery.replaceAll('  ',' ');
         searchQuery = searchQuery.trim();
         String searchQueryEncode = '%'+searchQuery+'%';
        
        system.debug('searchQuery :'+searchQuery);
        
       /* for (Integer i=0; i<copyOfsearchQuery.length() ; i++)
        {
            if(copyOfsearchQuery.charAt(i) == 32)
            {
                word++;
            }
        }
        
        system.debug('Number of words :'+word);
        
        system.debug('Number of Spaces:'+(word-1)); */
        
        
        
         system.debug(searchQueryEncode);
       //  String q = 'Find '/'searchQueryEncode'/' IN All FIELDS Returning Contact(Id,Name)';
      //   contactResults = [SELECT Id, Name, Title, AccountId, Account.Name, Industry__c , Functional_Area_1__c  FROM Contact WHERE Name Like :searchQueryEncode ORDER BY Name LIMIT 100];
      
        contactResults = [SELECT Id, Name,Contact_Full_Name__c,Contact_Full_Name_with_Mid__c, Title, AccountId, Account.Name, Industry__c , Functional_Area_1__c , Off_Limit__c , Contact_Off_Limit__c  FROM Contact WHERE Contact_Full_Name_with_Mid__c Like :searchQueryEncode OR Contact_Full_Name__c like : searchQueryEncode ORDER BY Name LIMIT 100];

        
    /*    if (word>2)
        {
          contactResults = [SELECT Id, Name,Contact_Full_Name__c,Contact_Full_Name_with_Mid__c, Title, AccountId, Account.Name, Industry__c , Functional_Area_1__c  FROM Contact WHERE Contact_Full_Name_with_Mid__c Like :searchQueryEncode ORDER BY Name LIMIT 100];
  
        }
        else
        {  
		  contactResults = [SELECT Id, Name,Contact_Full_Name__c, Title, AccountId, Account.Name, Industry__c , Functional_Area_1__c  FROM Contact WHERE Contact_Full_Name__c Like :searchQueryEncode ORDER BY Name LIMIT 100];
        } */
     //   contactResults =[Find 'searchQueryEncode' IN All FIELDS Returning Contact(Id,Name),Account];
        
    }
    
    public void searchAccount() {
         state = 'searchAccount';
         String searchQueryEncode = '%'+searchQueryAccount+'%';

         accountResults = [SELECT Id, Name FROM Account WHERE Name Like :searchQueryEncode ORDER BY Name LIMIT 100];

    }
    
    public void newAccount() {
         state = 'newAccount';
         if(searchQueryAccount!='') {
             account.Name = searchQueryAccount;
         }
        
    }
     public void newContact() {
         state = 'newContact';
         if(searchQuery!='') {
             contact.FirstName = searchQuery.split(' ')[0];
             if(searchQuery.contains(' ')) {
                 contact.LastName = searchQuery.substringAfter(' ');
             }
         }
    }
    
    public void selectContact() {
        app.Contact__c = contactSelected;
     /*   conoff = [select Id,Off_Limit__c,Contact_Off_Limit__c from contact where Id =: contactSelected] ;
        offlimit = conoff.Off_Limit__c;
        conofflimit = conoff.Contact_Off_Limit__c;
        
        system.debug('Contact Selected'+app.Contact__c);
        system.debug('Contact-Company Off Limit '+offlimit);
        system.debug('Contact-Contact Off Limit'+conofflimit);*/
    }
	
    public void selectAccount() {
       contact.AccountId = accountSelected;
        state = 'newContact';
    }

    
    public void setSearchQuery() {
        searchContact();
    }
    
    public void setSearchQueryAccount() {
        searchAccount();
    }
    

}