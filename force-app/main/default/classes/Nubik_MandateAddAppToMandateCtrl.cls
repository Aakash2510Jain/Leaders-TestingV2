public class Nubik_MandateAddAppToMandateCtrl {
	
	list<Contact> ContactsRelatedToAccount {get;set;}
	list<Application__c> AppsToInsert {get;set;}
	public Application__c AppToSelectMandate {get;set;}
	public Mandate__c MandateSelected {get;set;}
	public List<cApplication> applicationList {get; set;}
	public string selectedRecords {get;set;}
    public Meeting_Note__c leadersNote {get;set;}
    public  set<id> finalCandidatesToTransfer = new set<id>();
    
    public boolean tMessage {get;set;}
    public boolean hbuttons {get;set;}
    public set<id> successTransferId = New set<id>();
    public set<Id> failTransferId = new set<id>();
    public Integer success = 0 ;
    public Integer fail = 0 ;
    public List<Application__c> successTransferResults {get;set;} 
    
    
    public List<Application__c> failTransferResults {get;set;}

	public Nubik_MandateAddAppToMandateCtrl(ApexPages.StandardController stdController){		
		
        /*Cookie sRecordsCookie = ApexPages.currentPage().getCookies().get('canIds');
		if(sRecordsCookie != null){
		  selectedRecords = sRecordsCookie.getValue();    
		}
		sRecordsCookie = new Cookie('canIds', null,null,0,false);
        
		ApexPages.currentPage().setCookies(new Cookie[]{sRecordsCookie});
		*/
        
        selectedRecords = String.valueOf(Cache.Session.get('local.recruiting.canIds'));        
        Cache.Session.put('local.recruiting.canIds', '');
        
		ContactsRelatedToAccount = [Select Id, Name From Contact Where AccountId =: ApexPages.currentPage().getParameters().get('id')];
		
		AppToSelectMandate = new Application__c();		
        
        leadersNote = new Meeting_Note__c();
        tMessage = false;
        hbuttons = true;
	}
	
	
  	public void CreateApps(){  		
  		if(AppToSelectMandate.Mandate__c != null){
  		MandateSelected = new Mandate__c();
  		Boolean OneSelected = false;	
		AppsToInsert = new list<Application__c>();  			
  		MandateSelected = [Select Id, Status__c from Mandate__c where Id = : AppToSelectMandate.Mandate__c];
  		for(cApplication TempcApplication : applicationList){
  			if(TempcApplication.selected == true){
  				OneSelected = true;
  			}
  		}
  		system.debug('[Nubik_AccountAddContactsToMandateCtrl] AppToSelectMandate.Mandate__c: '+AppToSelectMandate.Mandate__c );
  			if(MandateSelected.Status__c != 'Completed' && MandateSelected.Status__c != 'Cancelled' && OneSelected){
		  		for(cApplication TempcApplication : applicationList){
		  			if(TempcApplication.selected == true){
			  			Application__c App = new Application__c();
			  			App.Contact__c = TempcApplication.app.Contact__c;
			  			App.Mandate__c = AppToSelectMandate.Mandate__c;
			  			App.Source_Status__c = 'New';
                        finalCandidatesToTransfer.add(TempcApplication.app.Id);
			  			AppsToInsert.add(App); 
		  			}
		  		}
		  		if(!AppsToInsert.isEmpty())
		  			try {
		  				//database.insert(AppsToInsert,false);
                      // insert AppsToInsert;
/*Added By Ankita */  Database.SaveResult[] srlist =  Database.insert(AppsToInsert, false);
                        
                        for(Database.SaveResult sr : srlist)
                        {
                            if(sr.isSuccess())
                            {
                               successTransferId.add(sr.getId());
                               success++; 
                            }
                            else{
                                fail++;
                            }
                        }
                        
                       for(Id i : finalCandidatesToTransfer)
                       {
                           if(!successTransferId.contains(i))
                           {
                               failTransferId.add(i);
                           }
                       }
                        
               /*        system.debug('successTransferId:'+successTransferId);
                       system.debug('failTranssferId :'+failTransferId); 
                        
                        
                       successTransferResults = [select Id, Name , Mandate__c, Contact__c , Contact__r.Name from Application__c where id IN: successTransferId];
                        
                       failTransferResults = [select Id, Name , Mandate__c, Contact__c, Contact__r.Name from Application__c where id IN: failTransferId]; 
                        
                       system.debug('successTransferResults :'+successTransferResults);
                       system.debug('Size of success Transfer Results :'+successTransferResults.size());
                       system.debug('failTransferResults :'+failTransferResults); */
                        
                        
                        
                        
                        
                        /* Create Leaders note with Status summary line */
                        List<Meeting_Note__c> leadersNotes = new List<Meeting_Note__c>();
                       //
                       for(Application__c app : AppsToInsert){
		  			   		leadersNotes.add(new Meeting_Note__c(Contact__c=app.Contact__c, Candidate_Assigned__c =app.Id, Status_Summary_Line__c =leadersNote.Status_Summary_Line__c ));
                       }
                        
                        
                      //  insert leadersNotes;
/*Added By Ankita */      Database.insert(leadersNotes, false);
                        
		  			} catch(Exception e){}
                
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO, 'Total number of candidates transferred :'+success);
  					ApexPages.addMessage(myMsg);
                    ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.INFO, 'Total number of existing candidates :'+fail);
  					ApexPages.addMessage(myMsg1);
                    tMessage = true ;
                    hbuttons = false;
		  		//	return new PageReference('/' + ApexPages.currentPage().getParameters().get('id')); 
		  		//   return null;
  			}else{
  				if(OneSelected){
  					ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'The Selected Mandate Can\'t be Cancelled or Completed');
  					ApexPages.addMessage(myMsg);
  				}else{
  					ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'You need to select at least one Application');
  					ApexPages.addMessage(myMsg);
  				} 
  				
  				//return null;
  			}
  		}else{
  		  		ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'You need to select a Mandate'); 
  				ApexPages.addMessage(myMsg);
  				//return null; 		  		
  		}
  	}	
	
	
	
  	public PageReference back(){  		
  		return new PageReference('/' + ApexPages.currentPage().getParameters().get('id'));  		
  	}
    
    public PageReference OK()
    {
       return new PageReference('/apex/AssignmentCandidates?id='+ApexPages.currentPage().getParameters().get('id')); 
    }
    
    
    
  	
   public class cApplication {
        public Application__c app {get; set;}
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
			                              Contact__c 
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