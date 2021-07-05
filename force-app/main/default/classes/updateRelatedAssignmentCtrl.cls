public class updateRelatedAssignmentCtrl {
    list<contact> ContactsRelatedToAccount {get;set;}
    list<Application__c> AppsToInsert{get;set;}
    public Application__c AppToSelectMandate {get;set;}
	public Mandate__c MandateSelected {get;set;}
    public Meeting_Note__c leadersNote {get;set;}
    public Mandate__c CurrentMandate ;
	public List<cApplication> applicationList {get; set;}
	public string selectedRecords {get;set;}
    public string selectedOption {get;set;}
    public boolean showSSL {get;set;}
    
    public updateRelatedAssignmentCtrl(ApexPages.StandardController stdController)
    {
        selectedRecords = String.valueOf(Cache.Session.get('local.recruiting.canIds'));        
        Cache.Session.put('local.recruiting.canIds', '');
        
		ContactsRelatedToAccount = [Select Id, Name From Contact Where AccountId =: ApexPages.currentPage().getParameters().get('id')];
		AppToSelectMandate = new Application__c();	        
        CurrentMandate = [Select Id from Mandate__c Where Id =: ApexPages.currentPage().getParameters().get('id')];        
        leadersNote = new Meeting_Note__c();
    /*    showSSL = true;
        if(selectedOption == 'Status Summary Line')
        {
            showSSL = true;
        } */
        
    }
    
  /*  public void displaySSL()
    {
        showSSL = true;
    } 
    
    public List<SelectOption> getselectOption() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('None','None'));
     	options.add(new SelectOption('Status Summary Line', 'Status Summary Line'));
        options.add(new SelectOption('Origin','Origin'));
        Options.add(new SelectOption('Both','Both'));
      //  options.add(new SelectOption('Overnight Report', 'Overnight Report'));
        
        return options;
    } */
    
    public PageReference changeSSL()
    {
       boolean OneSelected = false;
        AppsToInsert = new list<Application__c>();
        
        for(cApplication TempcApplication : applicationList)
        {
          if(TempcApplication.selected == true) 
          {
              OneSelected = true ;
          }
        }
        
        if(OneSelected){
        for(cApplication TempcApplication : applicationList)
        {
            if(TempcApplication.selected == true)
            {
                Application__c app = new Application__c();
                app.id = TempcApplication.app.Id;
                app.Status_Summary_Line__c = leadersNote.Status_Summary_Line__c;
              /*  if(AppToSelectMandate.Origin__c != null)
                app.Origin__c= AppToSelectMandate.Origin__c; */
               
                AppsToInsert.add(app);
            }
            }
        
            List<Meeting_Note__c> LRN = [Select Id, Contact__c, Contact__r.Name,
                                              Status_Summary_Line__c, 
                                              Description__c ,
                                              Candidate_Assigned__c,
                                              Candidate_Assigned__r.Origin__c,
                                              Candidate_Assigned__r.Name,
                                              Candidate_Assigned__r.Mandate__c
                                          from Meeting_Note__c 
                                          where Candidate_Assigned__c IN: AppsToInsert
                                          and Most_Recent__c = true ORDER BY LastModifiedDate ];
            system.debug(LRN);    
            if(!AppsToInsert.isEmpty())
            {
               database.update(AppsToInsert,false);
            }
        
            List<Meeting_Note__c> leadersNotes = new List<Meeting_Note__c>();
      /*  for(Application__c app : AppsToInsert)
        {
            Meeting_Note__c LRN = [Select Id, Contact__c, Contact__r.Name,
                                              Status_Summary_Line__c, 
                                              Description__c ,
                                              Candidate_Assigned__c,
                                              Candidate_Assigned__r.Origin__c,
                                              Candidate_Assigned__r.Name,
                                              Candidate_Assigned__r.Mandate__c
                                         from Meeting_Note__c 
                                        where Candidate_Assigned__c =: app.Id
                                          and Most_Recent__c = true ORDER BY LastModifiedDate limit 1];

            leadersNotes.add(new Meeting_Note__c(Contact__c = app.Contact__c , Candidate_Assigned__c = app.Id , Status_Summary_Line__c= leadersNote.Status_Summary_Line__c, Description__c= LRN.Description__c));
        } */
        
        for(Application__c app : AppsToInsert)
        {
            for(Meeting_Note__C note : LRN)
            {
                if(app.Id == note.Candidate_Assigned__r.Id)
                 leadersNotes.add(new Meeting_Note__c(Contact__c = app.contact__c , Candidate_Assigned__c= app.Id , Status_Summary_Line__c = leadersNote.Status_Summary_Line__c, Description__c = note.Description__C));
            }
        }
        
        database.insert(leadersNotes,false);
            return new PageReference('/Apex/AssignmentCandidates?id='+CurrentMandate.id);
      //  return null;
        }else{
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'You need to select at least one Application');
  		    ApexPages.addMessage(myMsg);
            return null;
        }
    }
    
    public PageReference changeOrigin()
    {
      boolean OneSelected = false;
        AppsToInsert = new list<Application__c>();
        
        for(cApplication TempcApplication : applicationList)
        {
          if(TempcApplication.selected == true) 
          {
              OneSelected = true ;
          }
        }
        
        if(OneSelected){
        for(cApplication TempcApplication : applicationList)
        {
            if(TempcApplication.selected == true)
            {
                Application__c app = new Application__c();
                app.id = TempcApplication.app.Id;
              //  app.Status_Summary_Line__c = leadersNote.Status_Summary_Line__c;
                if(AppToSelectMandate.Origin__c != null)
                app.Origin__c= AppToSelectMandate.Origin__c;
               
                AppsToInsert.add(app);
            }
            }
        
            List<Meeting_Note__c> LRN = [Select Id, Contact__c, Contact__r.Name,
                                              Status_Summary_Line__c, 
                                              Description__c ,
                                              Candidate_Assigned__c,
                                              Candidate_Assigned__r.Origin__c,
                                              Candidate_Assigned__r.Name,
                                              Candidate_Assigned__r.Mandate__c
                                          from Meeting_Note__c 
                                          where Candidate_Assigned__c IN: AppsToInsert
                                          and Most_Recent__c = true ORDER BY LastModifiedDate ];
            system.debug(LRN);    
            if(!AppsToInsert.isEmpty())
            {
               database.update(AppsToInsert,false);
            }
        
            List<Meeting_Note__c> leadersNotes = new List<Meeting_Note__c>();
      /*  for(Application__c app : AppsToInsert)
        {
            Meeting_Note__c LRN = [Select Id, Contact__c, Contact__r.Name,
                                              Status_Summary_Line__c, 
                                              Description__c ,
                                              Candidate_Assigned__c,
                                              Candidate_Assigned__r.Origin__c,
                                              Candidate_Assigned__r.Name,
                                              Candidate_Assigned__r.Mandate__c
                                         from Meeting_Note__c 
                                        where Candidate_Assigned__c =: app.Id
                                          and Most_Recent__c = true ORDER BY LastModifiedDate limit 1];

            leadersNotes.add(new Meeting_Note__c(Contact__c = app.Contact__c , Candidate_Assigned__c = app.Id , Status_Summary_Line__c= leadersNote.Status_Summary_Line__c, Description__c= LRN.Description__c));
        } */
        
      /*  for(Application__c app : AppsToInsert)
        {
            for(Meeting_Note__C note : LRN)
            {
                if(app.Id == note.Candidate_Assigned__r.Id)
                 leadersNotes.add(new Meeting_Note__c(Contact__c = app.contact__c , Candidate_Assigned__c= app.Id , Status_Summary_Line__c = leadersNote.Status_Summary_Line__c, Description__c = note.Description__C));
            }
        }
        
        database.insert(leadersNotes,false); */
            return new PageReference('/Apex/AssignmentCandidates?id='+CurrentMandate.id);
      //  return null;
        }else{
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'You need to select at least one Application');
  		    ApexPages.addMessage(myMsg);
            return null;
        }       
    }
    
        
    public PageReference UpdateApps()
    {
        boolean OneSelected = false;
        AppsToInsert = new list<Application__c>();
        
        for(cApplication TempcApplication : applicationList)
        {
          if(TempcApplication.selected == true) 
          {
              OneSelected = true ;
          }
        }
        
        if(OneSelected){
        for(cApplication TempcApplication : applicationList)
        {
            if(TempcApplication.selected == true)
            {
                Application__c app = new Application__c();
                app.id = TempcApplication.app.Id;
                app.Status_Summary_Line__c = leadersNote.Status_Summary_Line__c;
                if(AppToSelectMandate.Origin__c != null)
                app.Origin__c= AppToSelectMandate.Origin__c;
               
                AppsToInsert.add(app);
            }
            }
        
            List<Meeting_Note__c> LRN = [Select Id, Contact__c, Contact__r.Name,
                                              Status_Summary_Line__c, 
                                              Description__c ,
                                              Candidate_Assigned__c,
                                              Candidate_Assigned__r.Origin__c,
                                              Candidate_Assigned__r.Name,
                                              Candidate_Assigned__r.Mandate__c
                                          from Meeting_Note__c 
                                          where Candidate_Assigned__c IN: AppsToInsert
                                          and Most_Recent__c = true ORDER BY LastModifiedDate ];
            system.debug(LRN);    
            if(!AppsToInsert.isEmpty())
            {
               database.update(AppsToInsert,false);
            }
        
            List<Meeting_Note__c> leadersNotes = new List<Meeting_Note__c>();
      /*  for(Application__c app : AppsToInsert)
        {
            Meeting_Note__c LRN = [Select Id, Contact__c, Contact__r.Name,
                                              Status_Summary_Line__c, 
                                              Description__c ,
                                              Candidate_Assigned__c,
                                              Candidate_Assigned__r.Origin__c,
                                              Candidate_Assigned__r.Name,
                                              Candidate_Assigned__r.Mandate__c
                                         from Meeting_Note__c 
                                        where Candidate_Assigned__c =: app.Id
                                          and Most_Recent__c = true ORDER BY LastModifiedDate limit 1];

            leadersNotes.add(new Meeting_Note__c(Contact__c = app.Contact__c , Candidate_Assigned__c = app.Id , Status_Summary_Line__c= leadersNote.Status_Summary_Line__c, Description__c= LRN.Description__c));
        } */
        
        for(Application__c app : AppsToInsert)
        {
            for(Meeting_Note__C note : LRN)
            {
                if(app.Id == note.Candidate_Assigned__r.Id)
                 leadersNotes.add(new Meeting_Note__c(Contact__c = app.contact__c , Candidate_Assigned__c= app.Id , Status_Summary_Line__c = leadersNote.Status_Summary_Line__c, Description__c = note.Description__C));
            }
        }
        
        database.insert(leadersNotes,false);
            return new PageReference('/Apex/AssignmentCandidates?id='+CurrentMandate.id);
      //  return null;
        }else{
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'You need to select at least one Application');
  		    ApexPages.addMessage(myMsg);
            return null;
        }
    }    
    
    public PageReference back()
    {
           return new PageReference('/Apex/AssignmentCandidates?id='+CurrentMandate.id);
    }
   
    
    public class cApplication {
        public Application__c app {get; set;}
        public Meeting_Note__c note {get;set;}
        public Boolean selected {get; set;}

        public cApplication(Application__c c) {
            app = c;
            selected = false;
        }
    }
        
    public List<cApplication> getApplications() {
		if(applicationList == null) {
			applicationList = new List<cApplication>();
    
			for(Application__c c: [select Id, Name, Stage__c, Contact__r.Name, 
			                              Contact__c ,Status_Summary_Line__c
			                        from Application__c 
			                       where Mandate__c = :ApexPages.currentPage().getParameters().get('id') 
			                       limit 999]) {		
                cApplication cAppToAdd = new cApplication(c);
                system.debug(selectedRecords);
                system.debug(c.Id);
                if(selectedRecords != null && selectedRecords.contains(c.Id)){
                    cAppToAdd.selected = true;
                    applicationList.add(cAppToAdd);
                }				
			}
		}		
		return applicationList;
	}    
    
    
   
    public void  SelectAll(){  		
  		for(cApplication TempCA : applicationList){
  			TempCA.selected = true;
  			
  		} 		
  	}    
  	public void  DeselectAll(){  		
  		for(cApplication TempCA : applicationList){
  			TempCA.selected = false;
  			
  		} 		
  	}     
}