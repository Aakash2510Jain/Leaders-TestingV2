public class RelatedFilesCompController {

	@AuraEnabled
    public static List <Attachment> getAttachments(String mandateId) {
        return [SELECT Id,Name, LastModifiedDate,OwnerId,Owner.Name FROM Attachment WHERE ParentId =:mandateId ORDER BY CreatedDate DESC ];
    }
    @AuraEnabled
    public static List <Attachment> getAttachmentsForContact(String mandateId,List<String> candateList) {
        system.debug('candateList'+candateList);
        system.debug('mandateId'+mandateId);
        
        List<String> ParentIds = new List<String>();
       
        ParentIds.add(mandateId);
        //ParentIds.add(candateList);
        //return [SELECT Id,Name, LastModifiedDate,OwnerId,Owner.Name FROM Attachment WHERE ParentId IN:candateList ORDER BY CreatedDate DESC ];
        return [SELECT Id,Name, LastModifiedDate,OwnerId,Owner.Name FROM Attachment WHERE ParentId =:mandateId ORDER BY CreatedDate DESC ];
    }

    @AuraEnabled
    public static Boolean deleteAttachment(Id recId){
    	try{
    		delete new Attachment(Id = recId);
    		return true;
    	}catch(DmlException e){
    		return false;
    	}
    }

}