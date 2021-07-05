public with sharing class Nubik_AccountAddContactsToMandateCtrl {

	list<Contact> ContactsRelatedToAccount {get;set;}
	list<Application__c> AppsToInsert {get;set;}
	public Application__c AppToSelectMandate {get;set;}
	public Mandate__c MandateSelected {get;set;}

	public Nubik_AccountAddContactsToMandateCtrl(ApexPages.StandardController stdController){
		
		ContactsRelatedToAccount = [Select Id, Name From Contact Where AccountId =: ApexPages.currentPage().getParameters().get('id')];
		AppToSelectMandate = new Application__c();		
	}
	
	
  	public PageReference CreateApps(){  		
  		if(AppToSelectMandate.Mandate__c != null){
  		MandateSelected = new Mandate__c();	
		AppsToInsert = new list<Application__c>();  			
  		MandateSelected = [Select Id, Status__c from Mandate__c where Id = : AppToSelectMandate.Mandate__c];
  		system.debug('[Nubik_AccountAddContactsToMandateCtrl] AppToSelectMandate.Mandate__c: '+AppToSelectMandate.Mandate__c );
  			if(MandateSelected.Status__c != 'Completed' && MandateSelected.Status__c != 'Cancelled'){
		  		for(Contact TempContact : ContactsRelatedToAccount){
		  			Application__c App = new Application__c();
		  			App.Contact__c = TempContact.Id;
		  			App.Mandate__c = AppToSelectMandate.Mandate__c;
		  			App.Source_Status__c = 'New';
		  			AppsToInsert.add(App); 
		  		}
		  		if(!AppsToInsert.isEmpty())
		  			insert AppsToInsert;
  			}else{
  				ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'The Selected Mandate Can\'t be Calleded or Completed'); 
  				ApexPages.addMessage(myMsg);
  				return null;
  			}
  		}  		  		
  		return new PageReference('/' + ApexPages.currentPage().getParameters().get('id'));  		
  	}	
	
	
	
  	public PageReference back(){  		
  		return new PageReference('/' + ApexPages.currentPage().getParameters().get('id'));  		
  	}


}