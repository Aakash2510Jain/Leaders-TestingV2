public class AssignmentAttachmentCtrl {
	
	public String mId {get;set;}		
	
	public AssignmentAttachmentCtrl(){		
		mId = ApexPages.currentPage().getParameters().get('mandateId');				
	}

}