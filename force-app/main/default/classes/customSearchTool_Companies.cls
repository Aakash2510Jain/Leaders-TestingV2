public with sharing class customSearchTool_Companies {
    
     public Account acc {get;set;}
     public boolean isDesjardins {get;set;}
    
    
     private integer counter=0;  //keeps track of the offset
    private integer list_size=100; //sets the page size or number of rows
    public integer total_size = 0; //used to show user the total size of the list
    
	
	public customSearchTool_Companies(){
        
		acc=new Account();
        isDesjardins = false ;
        Id profileId = userinfo.getProfileId();
        String profileName = [select Name from profile where id = :profileId].Name;
         if (profileName.startsWith('Force.com Leaders + FR Assignment'))
        {
            isDesjardins = true ;
        }
        
    }
    

    public string fCriteria {get;set;}
    public List<SelectOption> getFilterCriteria(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('AND', 'Meet all Criteria'));
        options.add(new SelectOption('OR', 'Meet at least one Criteria'));
        return options;
    }    
    public list<string> industryFilter{get;set;}
    public List<SelectOption> getIndustries(){
        List<SelectOption> options = new List<SelectOption>();        
        Schema.DescribeFieldResult fieldResult = Account.Industry_Types__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();        
        for( Schema.PicklistEntry f : ple){
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }      
        options.sort(); 
        return options;
    }   
    
//Ankita code Starts   
    // Indusried Filter for Desjardins
    public list<string> industryFilterFR {get;set;}
    public List<SelectOption> getIndustriesFR(){
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = Account.Industries__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry f :ple){
            options.add(new SelectOption(f.getLabel(),f.getValue()));
        }
        options.sort();
        return options;
    }
    
    // Ankita code Ends    
    

    public list<string> countryFilter{get;set;}
    public List<SelectOption> getCountries(){
        List<SelectOption> options = new List<SelectOption>();      
        for(AggregateResult acc : [select billingcountry, count(id) from account group by billingcountry]){
        	// C113860 - Cristina Sananez 4/4/2016 - Fixed - If acc has no billing country
        	if (String.ValueOf(acc.get('billingcountry'))!=null && String.ValueOf(acc.get('billingcountry'))!=''){
            	options.add(new SelectOption(String.ValueOf(acc.get('billingcountry')), String.ValueOf(acc.get('billingcountry'))));
        	}
        }   
        options.sort(); 
        return options;
    }
    
    public list<string> stateFilter{get;set;}
    public List<SelectOption> getStates(){
        List<SelectOption> options = new List<SelectOption>();      
        for(AggregateResult acc : [select billingstate, count(id) from account group by billingstate]){
        	// C113860 - Cristina Sananez 4/4/2016 - Fixed - If acc has no billing country
        	if (String.ValueOf(acc.get('billingstate'))!=null && String.ValueOf(acc.get('billingstate'))!=''){
            options.add(new SelectOption(String.ValueOf(acc.get('billingstate')), String.ValueOf(acc.get('billingstate'))));
        	}
        }   
        options.sort(); 
        return options;
    }        
    //Status
    public list<string> statusFilter{get;set;}    
    public List<SelectOption> getStatus(){
        List<SelectOption> options = new List<SelectOption>();        
        Schema.DescribeFieldResult fieldResult = Account.Status__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();        
        for( Schema.PicklistEntry f : ple){
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }       
        options.sort();
        return options;
    }      
    //No of Employees
    public Integer employeesStartFilter{get;set;}
    public Integer employeesEndFilter{get;set;}
    //Revenues
    public Decimal revenueStartFilter{get;set;}    
    public Decimal revenueEndFilter{get;set;}
    
    public PageReference resetFilters(){
        industryFilter = new list<string>();
        statusFilter = new list<string>();
        employeesStartFilter = null;
        employeesEndFilter = null;
        revenueStartFilter = null;
        revenueEndFilter = null;
        
        acc.BillingCountryCode = null;
        acc.BillingStateCode = null;
        
        return null;
    }
    
     public void searchCompaniesBegining(){
         counter = 0;
         searchCompanies();
     }
    
    public PageReference searchCompanies(){
        String Query = '';
        
/*        String indFilter = '';
        if(industryFilter.size()>0){
            indFilter = ' (Industry_Types__c IN : industryFilter) ';
        } */
        
         String indFilter = '';
        if(isdesjardins == false){
        	if(industryFilter.size()>0){
            indFilter = '(Industry_Types__c IN : industryFilter) ';    
        } }  
        
        if(isdesjardins == true){
        if(industryFilterFR.size()>0){
            indFilter = '(Industries__c IN : industryFilterFR)' ;   
        } } 
        
        
        
        
        String couFilter = '';
        
        if(acc.BillingCountryCode     !=null && acc.BillingCountryCode     !=''){
        	couFilter = '(BillingCountryCode = \''+acc.BillingCountryCode+'\' )';
	        
        }
        
        String staFilter = '';
        
        if(acc.BillingStateCode     !=null && acc.BillingStateCode     !=''){
        	staFilter = '(BillingStateCode = \''+acc.BillingStateCode+'\' )';
	        
        }
        
        String statuFilter = '';
        if(statusFilter.size()>0){
            statuFilter = ' (Status__c IN : statusFilter) ';
        }
        String empFilter = '';
        if(employeesStartFilter!= null && employeesEndFilter != null && employeesStartFilter < employeesEndFilter){         
            empFilter = '(NumberOfEmployees   >= :employeesStartFilter AND NumberOfEmployees  <= : employeesEndFilter)';
        }else if ( ( (employeesStartFilter== null && employeesEndFilter != null ) || (employeesStartFilter != null && employeesEndFilter == null) ) || employeesStartFilter== null && employeesEndFilter == 0){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING,'Must enter both Employee filters'));
            return null;
        }      
        String revFilter = '';
        system.debug(revenueStartFilter);
        system.debug(revenueEndFilter);
        if(revenueStartFilter!= null && revenueEndFilter != null && revenueStartFilter < revenueEndFilter){         
            revFilter = '(AnnualRevenue   >= :revenueStartFilter AND AnnualRevenue  <= : revenueEndFilter)';
        }else if ( ( (revenueStartFilter== null && revenueEndFilter != null ) || (revenueStartFilter != null && revenueEndFilter == null) ) || revenueStartFilter== null && revenueEndFilter == 0){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING,'Must enter both Revenue filters'));
            return null;            
        }                 
        cWrapperList = new list<companyWrapper>();
        String fields = 'SELECT Id, Name, Industry_Types__c, Status__c, Phone, Website, billingcountry, billingstate From Account ';
        
        Query = indFilter != '' ?Query + 'WHERE '+ indFilter : Query;
        Query = couFilter != '' ? Query + (Query.Contains('WHERE') ? fCriteria+' ':'WHERE ')+ couFilter : Query;
        Query = staFilter != '' ? Query + (Query.Contains('WHERE') ? fCriteria+' ':'WHERE ')+ staFilter : Query;
        Query = statuFilter != '' ? Query + (Query.Contains('WHERE') ? fCriteria+' ':'WHERE ')+ statuFilter : Query;
        Query = empFilter != '' ? Query + (Query.Contains('WHERE') ? fCriteria+' ':'WHERE ')+ empFilter : Query;
        Query = revFilter != '' ? Query + (Query.Contains('WHERE') ? fCriteria+' ':'WHERE ')+ revFilter : Query;
        
        
        
        total_size = Database.countQuery('Select count() From Account '+Query);
        
        Query = fields+' '+Query +' order by Name limit :list_size offset :counter' ;
         
        
        
        
        List<Account> sobjList = Database.query(Query);
        if(sobjList.size()>0){
            for(Account aC :sobjList ){
                companyWrapper aCW = new companyWrapper(aC);
                cWrapperList.add(aCW);
            }
        }else{
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING,'No Companies found'));
        }
        
        return null;      
          
    }
    
    public Pagereference addToRS(){
        return null;
    }      
    
    public list<companyWrapper> cWrapperList {get;set;}
    public class companyWrapper{
        public boolean selected {get;set;}
        public Account theCompany {get;set;}
        
        public companyWrapper(Account aCompany){
            selected = false;
            theCompany = aCompany;
        }
    } 
    
    public PageReference Beginning() { //user clicked beginning
      counter = 0;
      searchCompanies();
      return null;
   }

   public PageReference Previous() { //user clicked previous button
      counter -= list_size;
      
      if(counter>=0)
      	searchCompanies();
      return null;
   }

   public PageReference Next() { //user clicked next button
      counter += list_size;
      searchCompanies();
      return null;
   }

   public PageReference End() { //user clicked end
      counter = total_size - math.mod(total_size, list_size);
      searchCompanies();
      return null;
   }

   public Boolean getDisablePrevious() { 
      //this will disable the previous and beginning buttons
      if (counter>0) return false; else return true;
   }

   public Boolean getDisableNext() { //this will disable the next and end buttons
      if (counter + list_size < total_size) return false; else return true;
   }

   public Integer getTotal_size() {
      return total_size;
   }

   public Integer getPageNumber() {
      return counter/list_size + 1;
   }
   public Integer getTotalPages() {
      if (math.mod(total_size, list_size) > 0) {
         return total_size/list_size + 1;
      } else {
         return (total_size/list_size);
      }
   }
      
          
}