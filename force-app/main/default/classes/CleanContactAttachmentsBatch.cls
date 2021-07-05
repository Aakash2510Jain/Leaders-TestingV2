global class CleanContactAttachmentsBatch  implements Schedulable {
   global void execute(SchedulableContext SC) {
      
       //Get all mandates
       Set<Id> contactIds = new Set<Id>();
       for(Contact contact:[SELECT Id FROM Contact])
           contactIds.add(contact.Id);
       
       List<Attachment> attToDelete = new List<Attachment>();
       //Get all attachments for all mandates where name contains "CHART"
       List<Attachment> bioAttachments = [SELECT Id, ParentId FROM Attachment WHERE ParentId IN :contactIds AND Name LIKE 'Candidate Biography%' ORDER BY LastModifiedDate] ;
       
       Map<String, Boolean> contactHasDoc = new Map<String, Boolean>();
       for(Attachment att:bioAttachments) {
           if(!contactHasDoc.containsKey(att.ParentId)) {
               contactHasDoc.put(att.ParentId, true);
           } else {
               attToDelete.add(att);
           }
       }
       
       List<Attachment> onePageAttachments = [SELECT Id, ParentId FROM Attachment WHERE ParentId IN :contactIds AND Name LIKE 'One Page%' ORDER BY LastModifiedDate] ;
       
       Map<String, Boolean> contactHasOnePage = new Map<String, Boolean>();
       for(Attachment att:onePageAttachments) {
           if(!contactHasOnePage.containsKey(att.ParentId)) {
               contactHasOnePage.put(att.ParentId, true);
           } else {
               attToDelete.add(att);
           }
       }
       
       //Delete "Charts" attachments
       delete attToDelete;
       
   }

}