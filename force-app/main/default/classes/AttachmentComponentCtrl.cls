public class AttachmentComponentCtrl {
	
	public String mandateId {get;set;}
	
	public List<Attachment> attachmentList {get

		{
			if(attachmentList == null){
				attachmentList = [Select Id, Name, LastModifiedDate, 
										 CreatedBy.Name
				                    from Attachment 
				                   where parentid = :mandateId];
			}		
			return attachmentList;
		}

	set;}
	
	public Integer rowToRemove {get;set;}		
	
	public void removeRowToAttachmentList(){        
        Attachment attach = attachmentList.get(rowToRemove);
        delete attach;        
        attachmentList.remove(rowToRemove);        
    }
    
    public PageReference attachFile(){
    	
    	string retUrl = '/apex/AssignmentAttachment?mandateId='+mandateId;
    	return new PageReference('/p/attach/NoteAttach?pid='+mandateId+'&retURL='+retUrl);
    	
    }

}