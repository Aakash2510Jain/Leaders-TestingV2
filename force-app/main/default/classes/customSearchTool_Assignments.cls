public with sharing class customSearchTool_Assignments {
    
     public Mandate__c mandat {get;set;}
    public boolean openSearch{get;set;}
    
    private String sortDirection = 'ASC';
    private String sortExp = 'Name';
    
    private integer counter=0;  //keeps track of the offset
    private integer list_size=100; //sets the page size or number of rows
    public integer total_size = 0; //used to show user the total size of the list
    
    public boolean isTeam1Profile {get;set;}
   	public boolean isTeam2Profile {get;set;}
   	public boolean isTeam3Profile {get;set;}
    public boolean isTeam4Profile {get;set;}
    public boolean isTeam7Profile {get;set;}
    public boolean isAdmin {get;set;}
    public boolean isDesjardins {get;set;}
        
    
    
    public customSearchTool_Assignments(){
        mandat = new Mandate__c();
        
        isTeam1Profile = false ;     
        isTeam2Profile = false ;
        isTeam3Profile = false ;
        isTeam4Profile = false ;
        isTeam7Profile = false ;
        isAdmin = false ;
        isDesjardins = false ;
       
        Id profileId = userinfo.getProfileId();
        String profileName = [select Name from profile where id = :profileId].Name;
         
        
        if (profileName.startsWith('System Administrator'))
        {
            isAdmin = true ;
        }
        
        else if(profileName.startsWith('Force.com Leaders team 1'))
        { 
            isTeam1Profile=true;
           
            system.debug('It makes Team1 profile ON');
        }
        
       else if (profileName == 'Force.com Leaders + FR Assignment')
        {
            isDesjardins = true ;
        }
        
      else  if (profileName.startsWith('Force.com Leaders team 2'))
        {
            isTeam2Profile = true ;
        }
        
      else  if (profileName.startsWith('Force.com Leaders team 3'))
        {
            isTeam3Profile = true ;
        }
        
      else  if (profileName.startsWith('Force.com Leaders'))
        {
            isTeam4Profile = true ;
        }
        
     else   if (profileName.startsWith('Force.com Leaders Team 7 + BusDev'))
        {
            isTeam7Profile = true ;
        }
        
        if (profileName.startsWith('System Administrator'))
        {
            isAdmin = true ;
        }
        
        
   
        
    }
    public string fCriteria {get;set;}
    public List<SelectOption> getFilterCriteria(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('AND', 'Meet all Criteria'));
        options.add(new SelectOption('OR', 'Meet at least one Criteria'));
        return options;
    }    
    //Title Name
    public string titleFilter{get;set;}
    
    //Status
    public list<string> statusFilter{get;set;}
    public List<SelectOption> getStatus(){
        List<SelectOption> options = new List<SelectOption>();        
        Schema.DescribeFieldResult fieldResult = Mandate__c.Assignment_Status__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();        
        for( Schema.PicklistEntry f : ple){
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }      
        options.sort(); 
        return options;
    }   
    //Company Name
    public string companyFilter{get;set;}    
    //Company Industry
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
    
    
    
    
    //Job Function
    public list<string> jobFunctionFilter{get;set;}
    public List<SelectOption> getJobFunctions(){
        List<SelectOption> options = new List<SelectOption>();        
        Schema.DescribeFieldResult fieldResult = Mandate__c.Job_Function__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();        
        for( Schema.PicklistEntry f : ple){
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }      
        options.sort(); 
        return options;
    }       
    //Job Level
    public list<string> jobLevelFilter{get;set;}
    public List<SelectOption> getJobLevels(){
        List<SelectOption> options = new List<SelectOption>();        
        Schema.DescribeFieldResult fieldResult = Mandate__c.Level__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();        
        for( Schema.PicklistEntry f : ple){
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }      
        options.sort(); 
        return options;
    }         
    //Parnters
    public list<string> Partner1Filter{get;set;}
    public list<string> Partner2Filter{get;set;}
    //Research
    public list<string> Research1Filter{get;set;}
    public list<string> Research2Filter{get;set;}
    
    
    public List<SelectOption> getUsers(){
        List<SelectOption> options = new List<SelectOption>();  
        
        if(isTeam1Profile == true)
        {
            for(User aUser : [Select Id, Name from User WHERE IsActive = TRUE AND (Profile.Name LIKE 'Force.com Leaders team 1%' OR Profile.Name LIKE 'Force.com Leaders team 2%' OR Profile.Name LIKE 'Force.com Leaders team 4%')  ORDER BY Name]){
            options.add(new SelectOption(aUser.Id,aUser.Name));
        	}
        }    
        else if(isTeam2Profile == true)
        {
            for(User aUser : [Select Id, Name from User WHERE IsActive = TRUE AND (Profile.Name LIKE 'Force.com Leaders team 1%' OR Profile.Name LIKE 'Force.com Leaders team 2%' OR Profile.Name LIKE 'Force.com Leaders team 4%') ORDER BY Name]){
            options.add(new SelectOption(aUser.Id,aUser.Name));
        	}
        }
            
        else if(isTeam3Profile == true)
        {
            for(User aUser : [Select Id, Name from User WHERE IsActive = TRUE AND Profile.Name LIKE 'Force.com Leaders team 3%' ORDER BY Name]){
            options.add(new SelectOption(aUser.Id,aUser.Name));
        }
        }
           
            
        else if(isTeam4Profile == true)
        {
            for(User aUser : [Select Id, Name from User WHERE IsActive = TRUE AND (Profile.Name LIKE 'Force.com Leaders team 1%' OR Profile.Name LIKE 'Force.com Leaders team 2%' OR Profile.Name LIKE 'Force.com Leaders team 4%') ORDER BY Name]){
            options.add(new SelectOption(aUser.Id,aUser.Name));
        }
        }
             
        else if(isTeam7Profile == true)
        {
        
            for(User aUser : [Select Id, Name from User WHERE IsActive = TRUE AND Profile.Name LIKE 'Force.com Leaders team 7%' ORDER BY Name]){
            options.add(new SelectOption(aUser.Id,aUser.Name));
        } 
        } 
        else if(isDesjardins == true)
        {
            for(User aUser : [Select Id, Name from User WHERE IsActive = TRUE AND Profile.Name LIKE 'Force.com Leaders + FR Assignment' ORDER BY Name]){
            options.add(new SelectOption(aUser.Id,aUser.Name));
        }
        }
        
            
        else if(isAdmin == true) 
        {    
           system.debug('Its System Admin Profile');
           for(User aUser : [Select Id, Name from User WHERE IsActive = TRUE  ORDER BY Name]){
            options.add(new SelectOption(aUser.Id,aUser.Name));
        	}  
        		
            }
             
    			//options.sort(); 
                return options;  
    }  

	 public String sortExpression
   {
     get
     {
        return sortExp;
     }
     set
     {
       //if the column is clicked on then switch between Ascending and Descending modes
       if (value == sortExp)
         sortDirection = (sortDirection == 'ASC')? 'DESC' : 'ASC';
       else
         sortDirection = 'ASC';
       sortExp = value;
     }
   }

     public String getSortDirection()
     {
        //if not column is selected 
        if (sortExpression == null || sortExpression == '')
          return 'ASC';
        else
         return sortDirection;
     }
    
     public void setSortDirection(String value)
     {  
       sortDirection = value;
     }
    
    public void searchAssBegining() {
         counter = 0;
        searchAss();
    }
    
    public PageReference searchAss(){
        String Query = '';
        
        String openSearchFilter='';
        System.debug(openSearchFilter);
        If(openSearch == True){
            openSearchFilter= '(Mandate_End_Date__c = null AND Mandate_Start_Date__c != null)';
        }
        
        String statFilter = '';
        System.debug(statusFilter);
        if(statusFilter.size()>0){
            statFilter = ' (Assignment_Status__c IN : statusFilter) ';
        }
        String indFilter = '';
        if(isdesjardins == false){
        	if(industryFilter.size()>0){
            indFilter = '(Company__r.Industry_Types__c IN : industryFilter) ';    
        } }  
        
        if(isdesjardins == true){
        if(industryFilterFR.size()>0){
            indFilter = '(Company__r.Industries__c IN : industryFilterFR)' ;   
        } } 
        
        String jobfFilter = '';
        if(jobFunctionFilter.size()>0){
            jobfFilter = '(Job_Function__c IN : jobFunctionFilter) ';
        }                
        String joblFilter = '';
        if(jobLevelFilter.size()>0){
            joblFilter = ' (Level__c IN : jobLevelFilter) ';
        }
        String titFilter = '';
        /*if(!String.isBlank(titleFilter)){
            titleFilter = '%'+titleFilter+'%'; 
            titFilter = '(Name LIKE :titleFilter) ';
        }*/
        if(!String.isBlank(mandat.Name)){
            titleFilter = '%'+mandat.Name+'%'; 
            titFilter = '(Name LIKE :titleFilter) ';
        }
        String compFilter = '';
        if(!String.isBlank(companyFilter)){
             companyFilter = '%'+companyFilter+'%'; 
            compFilter = '(Company__r.Name LIKE :companyFilter) ';
        }    
        String part1Filter = '';
        if(Partner1Filter.size()>0){
            part1Filter = ' (Partner__c IN : Partner1Filter) ';
        }  
        String part2Filter = '';
        if(Partner2Filter.size()>0){
            part2Filter = ' (Partner_2__c IN : Partner2Filter) ';
        }  
        String res1Filter = '';
        if(Research1Filter.size()>0){
            res1Filter = ' (Consultant__c IN : Research1Filter) ';
        }   
        String res2Filter = '';
        if(Research2Filter.size()>0){
            res2Filter = ' (Researcher__c IN : Research2Filter) ';
        }          
        
        Date mandatStartDate = mandat.Mandate_Start_Date__c;
        Date mandatEndDate = mandat.Mandate_End_Date__c;
        string sortFullExp = sortExpression  + ' ' + sortDirection+'  NULLS LAST ';
        
        aWrapperList = new list<assignmentWrapper>();
        String fields = 'SELECT Id, Company__r.Name, Name, Company__r.Industry_Types__c, Status__c, Assignment_Status__c, Mandate_Start_Date__c,Job_Function__c,Partner__r.name,Partner_2__r.name, Level__c,Number_of_candidates__c,number_of_days__c From Mandate__c ';
        
        Query = statFilter != '' ?Query + 'WHERE '+ statFilter : Query;
        Query = indFilter != '' ? Query + (Query.Contains('WHERE') ? fCriteria+' ':'WHERE ')+ indFilter : Query;
        Query = jobfFilter != '' ? Query + (Query.Contains('WHERE') ? fCriteria+' ':'WHERE ')+ jobfFilter : Query;
        Query = joblFilter != '' ? Query + (Query.Contains('WHERE') ? fCriteria+' ':'WHERE ')+ joblFilter : Query;
        Query = titFilter != '' ? Query + (Query.Contains('WHERE') ? fCriteria+' ':'WHERE ')+ titFilter : Query;
        Query = compFilter != '' ? Query + (Query.Contains('WHERE') ? fCriteria+' ':'WHERE ')+ compFilter : Query;
        Query = part1Filter != '' ? Query + (Query.Contains('WHERE') ? fCriteria+' ':'WHERE ')+ part1Filter : Query;
        Query = part2Filter != '' ? Query + (Query.Contains('WHERE') ? fCriteria+' ':'WHERE ')+ part2Filter : Query;
        Query = res1Filter != '' ? Query + (Query.Contains('WHERE') ? fCriteria+' ':'WHERE ')+ res1Filter : Query;
        Query = res2Filter != '' ? Query + (Query.Contains('WHERE') ? fCriteria+' ':'WHERE ')+ res2Filter : Query;
        Query = mandat.Mandate_Start_Date__c != null ? Query + (Query.Contains('WHERE') ? fCriteria+' ':'WHERE ')+ ' Mandate_Start_Date__c >= :mandatStartDate ' : Query;
        
        Query = mandat.Mandate_End_Date__c != null ? Query + (Query.Contains('WHERE') ? fCriteria+' ':'WHERE ')+ ' Mandate_Start_Date__c <= :mandatEndDate ' : Query;
        
        Query = openSearchFilter != '' ? Query +(Query.contains('WHERE') ? fCriteria+' ':'WHERE ')+openSearchFilter :Query;
        
      /*  if(openSearch == true){
           Query = ' WHERE Mandate_End_Date__c = null AND Mandate_Start_Date__c != null';
        } */
        
        
        
        total_size = Database.countQuery('Select count() From Mandate__c '+Query);
       
        
        Query = fields+' '+Query +' order by ' + sortFullExp +' limit :list_size offset :counter' ;
         
        
       
        
        List<Mandate__c> sobjList = Database.query(Query);
        if(sobjList.size()>0){
            for(Mandate__c aC :sobjList ){
                assignmentWrapper aCW = new assignmentWrapper(aC);
                aWrapperList.add(aCW);
            }
        }else{
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING,'No Assignments found'));
        }
        
    //    awrapperList.sort();
        return null;      
          
    }
    
    public PageReference resetFilters(){
        statusFilter = new list<string>();
        industryFilter = new list<string>();
        jobFunctionFilter = new list<string>();
        jobLevelFilter = new list<string>();
        Partner1Filter = new list<string>();
        Partner2Filter = new list<string>();
        Research1Filter = new list<string>();
        Research2Filter = new list<string>();
        titleFilter = null;
        companyFilter = null;
        mandat.Mandate_Start_Date__c = null;
        mandat.Mandate_End_Date__c = null;
        openSearch = false;
        total_size = 0;
        
        mandat = new Mandate__c();
        if(aWrapperList!=null){
        	aWrapperList.clear();
        }

        return null; 
    }
    
    public list<assignmentWrapper> aWrapperList {get;set;}
    public class assignmentWrapper{
        public boolean selected {get;set;}
        public Mandate__c theAssignment {get;set;}
        
        public assignmentWrapper(Mandate__c anAssignment){
            selected = false;
            theAssignment = anAssignment;
        }
    } 
    
    public PageReference Beginning() { //user clicked beginning
      counter = 0;
      searchAss();
      return null;
   }

   public PageReference Previous() { //user clicked previous button
      counter -= list_size;
      if(counter>=0)
      	searchAss();
      return null;
   }

   public PageReference Next() { //user clicked next button
      counter += list_size;
      searchAss();
      return null;
   }

   public PageReference End() { //user clicked end
      counter = total_size - math.mod(total_size, list_size);
      searchAss();
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