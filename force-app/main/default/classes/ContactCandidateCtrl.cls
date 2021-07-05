public class ContactCandidateCtrl {
	
	public Contact contact {get;set;}
	public String userName {get;set;}
	public String mandateId;
	
	public ContactCandidateCtrl(){ 
		
		mandateId = ApexPages.currentPage().getParameters().get('mandateId');
		contact = new Contact();
		userName = userInfo.getName();
	}
	
	public PageReference save(){
		
		try{		
			//insert new contact
			insert contact;
			
			//create candidate
			Application__c candidate = new Application__c();
			candidate.Mandate__c = mandateId;
			candidate.Contact__c = contact.Id;
			insert candidate;
			
			return new PageReference('/apex/AssignmentCandidates?id='+mandateId);
		
		}catch(Exception e){
			system.debug('[ContactCandidateCtrl]save) error '+e.getMessage());
			return null;
		}
		
	}
	
	public PageReference cancel(){ 
		return new PageReference('/apex/AssignmentCandidates?id='+mandateId);
	}

}