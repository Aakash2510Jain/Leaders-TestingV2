/*	Class:   Nubik_MandateAddContToMandate
*	
			 Controller for Nubik_MandateAddContToMandate.page
			 Adds contacts to a selected mandate/assignment in the page.
			
*	Dev:	 Cristina Sananez
*	Case: 	 C113860
*	Date: 	 3/10/2016
*	Updates:
*/
public class Nubik_MandateAddContToMandate {
	
	List<Contact> ContactsRelatedToAccount {get;set;}
	List<String> ContactIds {get;set;}
	List<Application__c> AppsToInsert {get;set;}
	public Application__c AppToSelectMandate {get;set;}
	public Mandate__c MandateSelected {get;set;}
	public List<cContact> contactList {get; set;}
	public string selectedRecords {get;set;}
    public Meeting_Note__c leadersNote {get;set;}
    
    
	public Nubik_MandateAddContToMandate(ApexPages.StandardController stdController){		
		Cookie sRecordsCookie = ApexPages.currentPage().getCookies().get('conIds');
		system.debug('[Nubik_MandateAddContToMandate] sRecordsCookie '+sRecordsCookie);
		if(sRecordsCookie != null){
		  selectedRecords = sRecordsCookie.getValue();    
		}
		ContactIds=new List<String> ();
		for (String s : selectedRecords.split(',')){
			ContactIds.add(s);
		}
		system.debug('[Nubik_MandateAddContToMandate] sRecordsCookie '+sRecordsCookie);
		system.debug('[Nubik_MandateAddContToMandate] selectedRecords '+selectedRecords);
		sRecordsCookie = new Cookie('conIds', null,null,0,false);
		ApexPages.currentPage().setCookies(new Cookie[]{sRecordsCookie});
		
		leadersNote = new Meeting_Note__c();
		AppToSelectMandate = new Application__c();		
	}
	
	
  	public PageReference CreateApps(){  		
  		if(AppToSelectMandate.Mandate__c != null){
  		MandateSelected = new Mandate__c();
  		Boolean OneSelected = false;	
		AppsToInsert = new list<Application__c>();  			
  		MandateSelected = [Select Id, Status__c from Mandate__c where Id = : AppToSelectMandate.Mandate__c];
  		for(cContact TempcApplication : contactList){
  			if(TempcApplication.selected == true){
  				OneSelected = true;
  			}
  		}
  		system.debug('[Nubik_AccountAddContactsToMandateCtrl] AppToSelectMandate.Mandate__c: '+AppToSelectMandate.Mandate__c );
  			if(MandateSelected.Status__c != 'Completed' && MandateSelected.Status__c != 'Cancelled' && OneSelected){
		  		for(cContact TempcApplication : contactList){
		  			if(TempcApplication.selected == true){
			  			Application__c App = new Application__c();
			  			App.Contact__c = TempcApplication.con.Id;
			  			App.Mandate__c = AppToSelectMandate.Mandate__c;
			  			App.Source_Status__c = 'New';
			  			AppsToInsert.add(App); 
		  			}
		  		}
		  		try{
		  			if(!AppsToInsert.isEmpty()){
			  		//	insert AppsToInsert;
			  		    Database.insert(AppsToInsert, false);
			  			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Your selection has been saved successfully');
	  					ApexPages.addMessage(myMsg);
                        
                         List<Meeting_Note__c> leadersNotes = new List<Meeting_Note__c>();
                       for(Application__c app : AppsToInsert){
		  			   		leadersNotes.add(new Meeting_Note__c(Contact__c=app.Contact__c, Candidate_Assigned__c =app.Id, Status_Summary_Line__c =leadersNote.Status_Summary_Line__c ));
                       }
                    //   insert leadersNotes ; 
                        Database.insert(leadersNotes, false);
                        
	  					return null;
		  			}
		  		}catch(Exception e){
		  			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
  					ApexPages.addMessage(myMsg);
		  		}
		  		
		  		
		  return null;
		  			//return new PageReference('/' + ApexPages.currentPage().getParameters().get('id')); 
  			}else{
  				if(OneSelected){
  					ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'The Selected Mandate Can\'t be Called or Completed');
  					ApexPages.addMessage(myMsg);
  				}else{
  					ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'You need to select at least one Application');
  					ApexPages.addMessage(myMsg);
  				} 
  				
  				return null;
  			}
  		}else{
  		  		ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'You need to select a Mandate'); 
  				ApexPages.addMessage(myMsg);
  				return null; 		  		
  		}
  	}	
	
	
	
  	public PageReference back(){  		
  		return new PageReference('/apex/customSearchTool_Contact');  		
  	}
  	
   public class cContact {
        public Contact con {get; set;}
        public Boolean selected {get; set;}

        public cContact(Contact c) {
            con = c;
            selected = false;
        }
    }
    
	public List<cContact> getContacts() {
		if(contactList == null) {
			contactList = new List<cContact>();
			for(Contact c: [select Id, Name, 
								   Title, Account.Name, Phone, Email  
			                from Contact 
			                where Id IN :ContactIds 
			                limit 999]) {		
                cContact cConToAdd = new cContact(c);
                cConToAdd.selected = true;
                contactList.add(cConToAdd);
                		
			}
		}		
		return contactList;
	}    
    
  	public void  SelectAll(){  		
  		for(cContact TempCA : contactList){
  			TempCA.selected = true;
  			
  		} 		
  	}    
  	public void  DeselectAll(){  		
  		for(cContact TempCA : contactList){
  			TempCA.selected = false;
  			
  		} 		
  	}     
    
}