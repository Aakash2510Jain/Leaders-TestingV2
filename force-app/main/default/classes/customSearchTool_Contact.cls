/*  Class Name: customSearchTool_Contact
*	Date:
*	Case No. C113860
*	Dev: Jesus Gaviria
*	Updates: Cristina Sananez - Added the method "addToAssignment" 3/10/2016	
*/
public with sharing class customSearchTool_Contact {
    public Contact con {get;set;}
    
     private integer counter=0;  //keeps track of the offset
    private integer list_size=100; //sets the page size or number of rows
    public integer total_size = 0; //used to show user the total size of the list
     

    public customSearchTool_Contact(){
        
		con=new Contact();
    }
    
    public string fCriteria {get;set;}
    public List<SelectOption> getFilterCriteria(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('AND', 'Meet all Criteria'));
        options.add(new SelectOption('OR', 'Meet at least one Criteria'));
        return options;
    }
    //Functional Area 1
    public list<string> functionalAreaFilter{get;set;}    
    public List<SelectOption> getFunctionalArea(){
        List<SelectOption> options = new List<SelectOption>();        
        Schema.DescribeFieldResult fieldResult = Contact.Functional_Area_1__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();        
        for( Schema.PicklistEntry f : ple){
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }       
        options.sort();
        return options;
    }
     //Functional Area 2
    public list<string> functionalAreaFilter2{get;set;}    
    public List<SelectOption> getFunctionalArea2(){
        List<SelectOption> options = new List<SelectOption>();        
        Schema.DescribeFieldResult fieldResult = Contact.Functional_Area_2__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();        
        for( Schema.PicklistEntry f : ple){
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }       
        options.sort();
        return options;
    }
     //Functional Area 3
    public list<string> functionalAreaFilter3{get;set;}    
    public List<SelectOption> getFunctionalArea3(){
        List<SelectOption> options = new List<SelectOption>();        
        Schema.DescribeFieldResult fieldResult = Contact.Functional_Area_3__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();        
        for( Schema.PicklistEntry f : ple){
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }       
        options.sort();
        return options;
    }
     //Functional Area 4
    public list<string> functionalAreaFilter4{get;set;}    
    public List<SelectOption> getFunctionalArea4(){
        List<SelectOption> options = new List<SelectOption>();        
        Schema.DescribeFieldResult fieldResult = Contact.Functional_Area_4__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();        
        for( Schema.PicklistEntry f : ple){
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }       
        options.sort();
        return options;
    }
    //Competencies 1
    public list<string> competenciesFilter{get;set;}
    public List<SelectOption> getCompetencies(){
        List<SelectOption> options = new List<SelectOption>();        
        Schema.DescribeFieldResult fieldResult = Contact.Competencies_1__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();        
        for( Schema.PicklistEntry f : ple){
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }    
        options.sort();   
        return options;
    }
    
    //Competencies 2
    public list<string> competenciesFilter2{get;set;}
    public List<SelectOption> getCompetencies2(){
        List<SelectOption> options = new List<SelectOption>();        
        Schema.DescribeFieldResult fieldResult = Contact.Competencies_2__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();        
        for( Schema.PicklistEntry f : ple){
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }    
        options.sort();   
        return options;
    }
    //Competencies 3
    public list<string> competenciesFilter3{get;set;}
    public List<SelectOption> getCompetencies3(){
        List<SelectOption> options = new List<SelectOption>();        
        Schema.DescribeFieldResult fieldResult = Contact.Competencies_3__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();        
        for( Schema.PicklistEntry f : ple){
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }    
        options.sort();   
        return options;
    }
    //Competencies 4
    public list<string> competenciesFilter4{get;set;}
    public List<SelectOption> getCompetencies4(){
        List<SelectOption> options = new List<SelectOption>();        
        Schema.DescribeFieldResult fieldResult = Contact.Competencies_4__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();        
        for( Schema.PicklistEntry f : ple){
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }    
        options.sort();   
        return options;
    }
    
    //Industry
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
    //Job Level
    public list<string> jobLevelFilter{get;set;}
    public List<SelectOption> getJobLevels(){
        List<SelectOption> options = new List<SelectOption>();        
        Schema.DescribeFieldResult fieldResult = Contact.Job_Level__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();        
        for( Schema.PicklistEntry f : ple){
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }       
        options.sort();
        return options;
    }        
    //Prof Designation
    public list<string> profDesignationFilter{get;set;}
    public List<SelectOption> getProfDesignations(){
        List<SelectOption> options = new List<SelectOption>();        
        Schema.DescribeFieldResult fieldResult = Contact.Prof_Title__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();        
        for( Schema.PicklistEntry f : ple){
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }       
        options.sort();
        return options;
    }      
    
 /*   // Titre Professionnel
    
    public list<string> profDesignationFilter{get;set;}
    public List<SelectOption> getProfDesignations(){
        List<SelectOption> options = new List<SelectOption>();        
        Schema.DescribeFieldResult fieldResult = Contact.Prof_Title__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();        
        for( Schema.PicklistEntry f : ple){
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }       
        options.sort();
        return options;
    }   */   
    
    
    //Education
    public list<string> educationFilter{get;set;}
    public List<SelectOption> getEducations(){
        List<SelectOption> options = new List<SelectOption>();        
        Schema.DescribeFieldResult fieldResult = Contact.Education__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();        
        for( Schema.PicklistEntry f : ple){
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }    
        options.sort();   
        return options;
    }       
    //Title
    public String TitleFilter{get;set;}
    
    //Language Spoken
    public list<string> languageFilter{get;set;}
    public List<SelectOption> getLanguages(){
        List<SelectOption> options = new List<SelectOption>();        
        Schema.DescribeFieldResult fieldResult = Contact.Language_s_Sopken__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();        
        for( Schema.PicklistEntry f : ple){
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }       
        options.sort();
        return options;
    }  
    
    // Client Domicile
    
    public list<string> cdFilter{get;set;}
    public List<SelectOption> getClientDomicile(){
        List<SelectOption> options = new List<SelectOption>();        
        Schema.DescribeFieldResult fieldResult = Contact.Client_Domiciles__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();        
        for( Schema.PicklistEntry f : ple){
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }       
      //  options.sort();
        return options;
    }  
    
    
    //Region
    public list<string> regionFilter{get;set;}
    public List<SelectOption> getRegions(){
        List<SelectOption> options = new List<SelectOption>();        
        Schema.DescribeFieldResult fieldResult = Contact.Region__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();        
        for( Schema.PicklistEntry f : ple){
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }     
        options.sort();  
        return options;
    }        
    //Gender
    public list<string> genderFilter{get;set;}
    public List<SelectOption> getGenders(){
        List<SelectOption> options = new List<SelectOption>();        
        Schema.DescribeFieldResult fieldResult = Contact.Gender__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();        
        for( Schema.PicklistEntry f : ple){
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }     
        options.sort();  
        return options;
    }         
    //BirthDate
    public Date sDate{get;set;}
    public Date eDate{get;set;}
    
     public void searchContactsBegining(){
         counter = 0;
         searchContacts();
     }
    
    public PageReference searchContacts(){
        String Query = '';
        String fAFilter = '';
        String fAFilter2 = '';
        String fAFilter3 = '';
        String fAFilter4 = '';
       /* if(functionalAreaFilter.size()>0){
            fAFilter = '(Functional_Area_1__c IN : functionalAreaFilter) ';
        }
        system.debug(functionalAreaFilter);
        if(functionalAreaFilter2.size()>0){
            fAFilter2 = '(Functional_Area_2__c IN : functionalAreaFilter2) ';
        }
        system.debug(functionalAreaFilter2);
        if(functionalAreaFilter3.size()>0){
            fAFilter3 = '(Functional_Area_3__c IN : functionalAreaFilter3) ';
        }
        system.debug(functionalAreaFilter3);
        if(functionalAreaFilter4.size()>0){
            fAFilter4 = '(Functional_Area_4__c IN : functionalAreaFilter4) ';
        }
        system.debug(functionalAreaFilter4);
        
        String compFilter = '';
        if(competenciesFilter.size()>0){
            compFilter = '(Competencies_1__c Includes '+'(\''+string.join(competenciesFilter,'\',\'')+'\')'+')';
        }
        String compFilter2 = '';
        if(competenciesFilter2.size()>0){
            compFilter2 = '(Competencies_2__c Includes '+'(\''+string.join(competenciesFilter2,'\',\'')+'\')'+')';
        }
        String compFilter3 = '';
        if(competenciesFilter3.size()>0){
            compFilter3 = '(Competencies_3__c Includes '+'(\''+string.join(competenciesFilter3,'\',\'')+'\')'+')';
        }
        String compFilter4 = '';
        if(competenciesFilter4.size()>0){
            compFilter4 = '(Competencies_4__c Includes '+'(\''+string.join(competenciesFilter4,'\',\'')+'\')'+')';
        }
        
        system.debug(competenciesFilter);
        */
        if(con.Functional_Area_1__c!=null && con.Functional_Area_1__c!=''){
        	functionalAreaFilter=con.Functional_Area_1__c.split(';',0);
        	if(functionalAreaFilter.size()>0){
        //	fAFilter = '(Functional_Area_1__c IN : functionalAreaFilter)';
          	fAFilter = '(Functional_Area_1__c IN : functionalAreaFilter OR Functional_Area_2__c IN : functionalAreaFilter OR Functional_Area_3__c IN : functionalAreaFilter OR Functional_Area_4__c IN : functionalAreaFilter)  ';
            }
        }
        system.debug(functionalAreaFilter);
        if(con.Functional_Area_2__c!=null && con.Functional_Area_2__c!=''){
        	functionalAreaFilter2=con.Functional_Area_2__c.split(';',0);
	        if(functionalAreaFilter2.size()>0){
	     //       fAFilter2 = '(Functional_Area_2__c IN : functionalAreaFilter2) ';
	           fAFilter2 = '(Functional_Area_1__c IN : functionalAreaFilter2 OR Functional_Area_2__c IN : functionalAreaFilter2 OR Functional_Area_3__c IN : functionalAreaFilter2 OR Functional_Area_4__c IN : functionalAreaFilter2)  ';
	        }
        }
        system.debug(functionalAreaFilter2);
        if(con.Functional_Area_3__c!=null && con.Functional_Area_3__c!=''){
        	functionalAreaFilter3=con.Functional_Area_3__c.split(';',0);
	        if(functionalAreaFilter3.size()>0){
	        //    fAFilter3 = '(Functional_Area_3__c IN : functionalAreaFilter3) ';
	          fAFilter3 = '(Functional_Area_1__c IN : functionalAreaFilter3 OR Functional_Area_2__c IN : functionalAreaFilter3 OR Functional_Area_3__c IN : functionalAreaFilter3 OR Functional_Area_4__c IN : functionalAreaFilter3)  ';
	        }
        }
        system.debug(functionalAreaFilter3);
        if(con.Functional_Area_4__c!=null && con.Functional_Area_4__c!=''){
        	functionalAreaFilter4=con.Functional_Area_4__c.split(';',0);
	        if(functionalAreaFilter4.size()>0){
	       //     fAFilter4 = '(Functional_Area_4__c IN : functionalAreaFilter4) ';
	        fAFilter4 = '(Functional_Area_1__c IN : functionalAreaFilter4 OR Functional_Area_2__c IN : functionalAreaFilter4 OR Functional_Area_3__c IN : functionalAreaFilter4 OR Functional_Area_4__c IN : functionalAreaFilter4)  ';
	        }
        }
        system.debug(functionalAreaFilter4);
        
        String compFilter = '';
        
        if(con.Competencies_1__c!=null && con.Competencies_1__c!=''){
        	competenciesFilter=con.Competencies_1__c.split(';',0);
	        if(competenciesFilter.size()>0){
	            compFilter = '(Competencies_1__c Includes '+'(\''+string.join(competenciesFilter,'\',\'')+'\')'+')';
	        }
        }
        String compFilter2 = '';
        if(con.Competencies_2__c!=null && con.Competencies_2__c!=''){
        	competenciesFilter2=con.Competencies_2__c.split(';',0);
	        if(competenciesFilter2.size()>0){
	            compFilter2 = '(Competencies_2__c Includes '+'(\''+string.join(competenciesFilter2,'\',\'')+'\')'+')';
	        }
        }
        String compFilter3 = '';
        if(con.Competencies_3__c!=null && con.Competencies_3__c!=''){
        	competenciesFilter3=con.Competencies_3__c.split(';',0);
	        if(competenciesFilter3.size()>0){
	            compFilter3 = '(Competencies_3__c Includes '+'(\''+string.join(competenciesFilter3,'\',\'')+'\')'+')';
	        }
        }
        String compFilter4 = '';
        
        if(con.Competencies_4__c!=null && con.Competencies_4__c!=''){
        	competenciesFilter4=con.Competencies_4__c.split(';',0);
	        if(competenciesFilter4.size()>0){
	            compFilter4 = '(Competencies_4__c Includes '+'(\''+string.join(competenciesFilter4,'\',\'')+'\')'+')';
	        }
        }
        String compFilter5 = '';
        
        if(con.Comp_tences_5__c !=null && con.Comp_tences_5__c !=''){
        	compFilter5 = ' (Comp_tences_5__c   = \''+con.Comp_tences_5__c+'\') '; 
        }
      
        String compFilter6 = '';
        
        if(con.Domaine_d_expertise_6__c  !=null && con.Domaine_d_expertise_6__c  !=''){
        	compFilter6 = ' (Domaine_d_expertise_6__c   = \''+con.Domaine_d_expertise_6__c+'\') ';
	        
        }
        
        String jLevel = '';
        
        if(con.Job_Level_team5__c   !=null && con.Job_Level_team5__c   !=''){
            jLevel = ' (Job_Level_team5__c   = \''+con.Job_Level_team5__c+'\') '; 

        }
        
        String profTitle = '';
        
        if(con.Prof_Title__c    !=null && con.Prof_Title__c    !=''){
        	List<String> profTitleValues=con.Prof_Title__c   .split(';',0);
	        if(profTitleValues.size()>0){
	            profTitle = '(Prof_Title__c     Includes '+'(\''+string.join(profTitleValues,'\',\'')+'\')'+')';
	        }
        }
      
        String expGvn = '';
        
        if(con.Exp_rience_en_gouvernance__c    !=null && con.Exp_rience_en_gouvernance__c    !=''){
        	List<String> expGvnValues=con.Exp_rience_en_gouvernance__c   .split(';',0);
	        if(expGvnValues.size()>0){
	            expGvn = '(Exp_rience_en_gouvernance__c     Includes '+'(\''+string.join(expGvnValues,'\',\'')+'\')'+')';
	        }
        }
        
        String regAdm = '';
        
        if(con.R_gion_administrative__c     !=null && con.R_gion_administrative__c     !=''){
        	List<String> regAdmValues=con.R_gion_administrative__c    .split(';',0);
	        if(regAdmValues.size()>0){
	            regAdm = '(R_gion_administrative__c      Includes '+'(\''+string.join(regAdmValues,'\',\'')+'\')'+')';
	        }
        }
        
        String mailingCountry = '';
        
        if(con.MailingCountryCode     !=null && con.MailingCountryCode     !=''){
        	mailingCountry = '(MailingCountryCode = \''+con.MailingCountryCode+'\' OR OtherCountryCode = \''+con.MailingCountryCode+'\')';
	        
        }
        
        String mailingState = '';
        
        if(con.MailingStateCode     !=null && con.MailingStateCode     !=''){
        	mailingState = '(MailingStateCode = \''+con.MailingStateCode+'\' OR OtherStateCode = \''+con.MailingStateCode+'\')';
	        
        }
        
        
        
        /*String ind2 = '';
        System.debug(IndustryFilter); 
        if(IndustryFilter    !=null && IndustryFilter     !=''){
        	List<String> ind2Values=IndustryFilter.split(';',0);
             System.debug(string.join(ind2Values,'\',\''));
	        if(ind2Values.size()>0){
	            ind2 = '(Industries_2__c Includes '+'(\''+string.join(ind2Values,'\',\'')+'\')'+')';
	        }
        }*/
        
       
     
        String stdEnterprise = '';
        
        if(con.Stade_de_d_veloppement_de_l_entreprise__c      !=null && con.Stade_de_d_veloppement_de_l_entreprise__c      !=''){
        	List<String> stdEnterpriseValues=con.Stade_de_d_veloppement_de_l_entreprise__c     .split(';',0);
	        if(stdEnterpriseValues.size()>0){
	            stdEnterprise = '(Stade_de_d_veloppement_de_l_entreprise__c       Includes '+'(\''+string.join(stdEnterpriseValues,'\',\'')+'\')'+')';
	        }
        }
        
        String vEnterprise = '';
        
        if(con.Ventes_de_l_entreprise__c      !=null && con.Ventes_de_l_entreprise__c      !=''){
        	vEnterprise = ' (Ventes_de_l_entreprise__c   = \''+con.Ventes_de_l_entreprise__c+'\') '; 
            

        }
        
        // ajout cédric
         String genre = '';
        
        if(con.Gender__c      !=null && con.Gender__c      !=''){
        	genre = ' (Gender__c   = \''+con.Gender__c+'\') '; 
            

        }
        //
         
        
        String indFilter = '';
        Set<Id> contactIdWithPastIndustry = new Set<Id>();
        if(industryFilter!=null) {
            if(industryFilter.size()>0){
                indFilter = '(Account.Industry_Types__c  IN : industryFilter OR Id IN:contactIdWithPastIndustry) ';
			
                try {
                    for(Work_Experience__c wExp:[SELECT Contact__c FROM Work_Experience__c WHERE Company__r.Industry_Types__c  IN : industryFilter LIMIT 1000]) {
                        contactIdWithPastIndustry.add(wExp.Contact__c);
                    }
                } catch(Exception e){}
            }
        }
        
        String jlFilter = '';
        if(jobLevelFilter!=null) {
            if(jobLevelFilter.size()>0){
                jlFilter = ' (Job_Level__c IN : jobLevelFilter) ';
            }
        }
        String pfFilter = '';
        if(profDesignationFilter!=null) {
            if(profDesignationFilter.size()>0){
                pfFilter = ' (Prof_Title__c Includes '+'(\''+string.join(profDesignationFilter,'\',\'')+'\')'+ ') ';
            }  
        }
        String eduFilter = '';
        if(educationFilter!=null) {
            if(educationFilter.size()>0){
                eduFilter = ' (Education__c Includes '+'(\''+string.join(educationFilter,'\',\'')+'\')'+ ') ';
      //          eduFilter = '(Education__c IN : educationFilter) ';
            } 
        }
        String langFilter = '';
        if(languageFilter!=null) {
            if(languageFilter.size()>0){
                langFilter = ' (Language_s_Sopken__c Includes '+'(\''+string.join(languageFilter,'\',\'')+'\')'+ ') ';
    //            langFilter = '(Language_s_Sopken__c IN : languageFilter) ';
            } 
        }
        
        
        String clientdomicileFilter ='';
        if(cdFilter!=null) {
            if(cdFilter.size()>0){
                clientdomicileFilter = ' (Client_Domiciles__c	 Includes '+'(\''+string.join(cdFilter,'\',\'')+'\')'+ ') ';
    //            langFilter = '(Language_s_Sopken__c IN : languageFilter) ';
            } 
        }
        
        
        
        String regFilter = '';
        if(regionFilter!=null) {
            if(regionFilter.size()>0){
                regFilter = '(Region__c IN : regionFilter) ';
            }  
        }
        
        String genFilter = '';
        /*if(genderFilter.size()>0){
            genFilter = '(Gender__c IN : genderFilter) ';
        }*/       
        String titFilter = '';
        String pastTitFilter = '';
        Set<Id> contactIdWithPastTitle = new Set<Id>();
        if(!String.isBlank(titleFilter)){
            titleFilter = '%'+titleFilter+'%';
            titFilter = '(Title LIKE :titleFilter OR Id IN:contactIdWithPastTitle) ';
			
            try {
                for(Work_Experience__c wExp:[SELECT Contact__c FROM Work_Experience__c WHERE Title__c LIKE :titleFilter LIMIT 1000]) {
                    contactIdWithPastTitle.add(wExp.Contact__c);
                }
            } catch(Exception e){}
        }        
       String bdFilter = '';
       system.debug(sDate);
       system.debug(eDate);
       if(sDate!= null && eDate != null && sDate < eDate){         
            bdFilter = '(Birthdate > :sDate AND Birthdate < : eDate)';
        }        
        
                        
        cWrapperList = new list<contactWrapper>();
        String fields = 'SELECT Id, Name, Title, Account.Name, Phone, Email From Contact ';
        Query = fAFilter != '' ?Query + 'WHERE '+ fAFilter : Query;
        Query = fAFilter2 != '' ? Query + (Query.Contains('WHERE') ? fCriteria+' ':'WHERE ')+ fAFilter2 : Query;
        Query = fAFilter3 != '' ? Query + (Query.Contains('WHERE') ? fCriteria+' ':'WHERE ')+ fAFilter3 : Query;
        Query = fAFilter4 != '' ? Query + (Query.Contains('WHERE') ? fCriteria+' ':'WHERE ')+ fAFilter4 : Query;
        
        Query = compFilter != '' ? Query + (Query.Contains('WHERE') ? fCriteria+' ':'WHERE ')+ compFilter : Query;
        Query = compFilter2 != '' ? Query + (Query.Contains('WHERE') ? fCriteria+' ':'WHERE ')+ compFilter2 : Query;
        Query = compFilter3 != '' ? Query + (Query.Contains('WHERE') ? fCriteria+' ':'WHERE ')+ compFilter3 : Query;
        Query = compFilter4 != '' ? Query + (Query.Contains('WHERE') ? fCriteria+' ':'WHERE ')+ compFilter4 : Query;
        Query = compFilter5 != '' ? Query + (Query.Contains('WHERE') ? fCriteria+' ':'WHERE ')+ compFilter5 : Query;
        Query = compFilter6 != '' ? Query + (Query.Contains('WHERE') ? fCriteria+' ':'WHERE ')+ compFilter6 : Query;
        Query = jLevel != '' ? Query + (Query.Contains('WHERE') ? fCriteria+' ':'WHERE ')+ jLevel : Query;
       	Query = profTitle != '' ? Query + (Query.Contains('WHERE') ? fCriteria+' ':'WHERE ')+ profTitle : Query;
        Query = expGvn != '' ? Query + (Query.Contains('WHERE') ? fCriteria+' ':'WHERE ')+ expGvn : Query;
        Query = regAdm != '' ? Query + (Query.Contains('WHERE') ? fCriteria+' ':'WHERE ')+ regAdm : Query;
        Query = mailingCountry != '' ? Query + (Query.Contains('WHERE') ? fCriteria+' ':'WHERE ')+ mailingCountry : Query;
        Query = mailingState != '' ? Query + (Query.Contains('WHERE') ? fCriteria+' ':'WHERE ')+ mailingState : Query;
        Query = indFilter != '' ? Query + (Query.Contains('WHERE') ? fCriteria+' ':'WHERE ')+ indFilter : Query;
        Query = stdEnterprise != '' ? Query + (Query.Contains('WHERE') ? fCriteria+' ':'WHERE ')+ stdEnterprise : Query;
        Query = vEnterprise != '' ? Query + (Query.Contains('WHERE') ? fCriteria+' ':'WHERE ')+ vEnterprise : Query;
        Query = genre != '' ? Query + (Query.Contains('WHERE') ? fCriteria+' ':'WHERE ')+ genre : Query;
       
              
        
        Query = jlFilter != '' ? Query + (Query.Contains('WHERE') ? fCriteria+' ':'WHERE ')+ jlFilter : Query;
        Query = pfFilter != '' ? Query + (Query.Contains('WHERE') ? fCriteria+' ':'WHERE ')+ pfFilter : Query;
        Query = eduFilter != '' ? Query + (Query.Contains('WHERE') ? fCriteria+' ':'WHERE ')+ eduFilter : Query;
        Query = langFilter != '' ? Query + (Query.Contains('WHERE') ? fCriteria+' ':'WHERE ')+ langFilter : Query;
        Query = regFilter != '' ? Query + (Query.Contains('WHERE') ? fCriteria+' ':'WHERE ')+ regFilter : Query;
        Query = genFilter != '' ? Query + (Query.Contains('WHERE') ? fCriteria+' ':'WHERE ')+ genFilter : Query;
        Query = titFilter != '' ? Query + (Query.Contains('WHERE') ? fCriteria+' ':'WHERE ')+ titFilter : Query;
        Query = bdFilter != '' ? Query + (Query.Contains('WHERE') ? fCriteria+' ':'WHERE ')+ bdFilter : Query;
        Query = clientdomicileFilter != '' ? Query + (Query.Contains('WHERE') ? fCriteria+' ':'WHERE ')+ clientdomicileFilter : Query;
          
        total_size = Database.countQuery('Select count() From Contact '+Query);
        
        Query = fields+' '+Query +' order by Name limit :list_size offset :counter' ;
         
        
        
        system.debug('query --> '+Query);	    
        List<Contact> sobjList = Database.query(Query);
        
        Set<String> contactIds = new Set<String>();
        Map<String, Integer> nbCVByContactId = new Map<String, Integer>();
         Map<String, Integer> nbOnePagerByContactId = new Map<String, Integer>();
		 Map<String, String> lastCVByContactId = new Map<String, String>();
        
        if(sobjList.size()>0){
            for(Contact aC :sobjList ){
                contactIds.add(aC.Id);
            }
        }
             
       if(!contactIds.isEmpty()) {
          for(AggregateResult result: [SELECT ParentId, COUNT(Id) FROM Attachment WHERE ParentId IN :contactIds AND Name LIKE 'CV%' GROUP BY ParentId]) {
              if(Integer.valueOf(result.get('expr0'))>0) {
                  nbCVByContactId.put(String.valueOf(result.get('ParentId')),Integer.valueOf(result.get('expr0')));
              }
          }
           
          for(AggregateResult result: [SELECT ParentId, COUNT(Id) FROM Attachment WHERE ParentId IN :contactIds AND Name LIKE 'One Page%' GROUP BY ParentId]) {
              if(Integer.valueOf(result.get('expr0'))>0) {
                  nbOnePagerByContactId.put(String.valueOf(result.get('ParentId')),Integer.valueOf(result.get('expr0')));
              }
          }
           
            for(Attachment result: [SELECT Id, ParentId FROM Attachment WHERE ParentId IN :contactIds AND Name LIKE 'CV%' ORDER BY LastModifiedDate ASC]) {
              lastCVByContactId.put(String.valueOf(result.ParentId),String.valueOf(result.Id));
              
          }
       }
        
       if(sobjList.size()>0){
	        for(Contact aC :sobjList ){
	            contactWrapper aCW = new contactWrapper(aC);
                if(nbCVByContactId.containsKey(aC.Id)) {
                    aCW.hasCV = true;
                 	if(lastCVByContactId.containsKey(String.valueOf(aC.Id)))
                		aCW.cvId = lastCVByContactId.get(String.valueOf(aC.Id));   
                }
                if(nbOnePagerByContactId.containsKey(aC.Id))
                    aCW.hasOnePager = true;
	            cWrapperList.add(aCW);
                contactIds.add(aC.Id);
	        }
        }else{
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING,'No Contacts found'));
        }
        
        return null;      
          
    }
    
/*
 *  Method: addToAssignment
 * 		   Sends a list of contact Id's to be added to an assignment in the
 *	       Nubik_MandateAppToMandate page.
 *  Dev:    Cristina Sananez
 *  Date:   03/10/2016
 */   
    public PageReference addToAssignment(){
        String idsToPass = ''; 
        
        if (cWrapperList!=null){
        	for(contactWrapper aResult : cWrapperList){
	            if(aResult.selected){
	                idsToPass = idsToPass + aResult.theContact.Id+',';                
	            }
		    }
		  if (idsToPass!=''){
		  	   
			    Cookie conIdsCookie = new Cookie('conIds', idsToPass,null,-1,false);
			    ApexPages.currentPage().setCookies(new Cookie[]{conIdsCookie});
			    
			    PageReference newPage = new PageReference('/apex/Nubik_AddContToMandate?scontrolCaching=1');
			    return newPage;
		  } else{
		  	 ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING,'Please select a contact to add to Assignment'));
		 	 return null;
		  } 
			   
		 }else{
		 	 ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING,'Please select a contact to add to Assignment'));
		 	 return null;
		 }       
         
    }
    
    public PageReference resetFilters(){
        functionalAreaFilter = new list<string>();
        competenciesFilter = new list<string>();
        industryFilter = new list<string>();
        jobLevelFilter = new list<string>();
        profDesignationFilter = new list<string>();
        educationFilter = new list<string>();
        languageFilter = new list<string>();
        regionFilter = new list<string>();
        genderFilter = new list<string>();
        cdFilter = new list<string>();
        
        titleFilter = '';
        sDate = null;
        eDate = null;
        total_size = 0;
        //Cristina Sananez 3/10/2016 BEGIN
        con=new Contact();
        if(cWrapperList!=null){
        	cWrapperList.clear();
        }
        
        //Cristina Sananez 3/10/2016 END
        return null;
    }
    
    public PageReference Beginning() { //user clicked beginning
      counter = 0;
      searchContacts();
      return null;
   }

   public PageReference Previous() { //user clicked previous button
      counter -= list_size;
       
      if(counter>=0)
      	searchContacts();
      return null;
   }

   public PageReference Next() { //user clicked next button
      counter += list_size;
      searchContacts();
      return null;
   }

   public PageReference End() { //user clicked end
      counter = total_size - math.mod(total_size, list_size);
      searchContacts();
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
    
    public list<contactWrapper> cWrapperList {get;set;}
   @TestVisible  public class contactWrapper{
        public boolean selected {get;set;}
        public Contact theContact {get;set;}
        public boolean hasCV {get;set;}
       public boolean hasOnePager {get;set;}
		public String cvId {get;set;}
        
        public contactWrapper(Contact aContact){
            selected = false;
            hasCV = false;
            hasOnePager = false;
            theContact = aContact;
        }
    }    
    
}