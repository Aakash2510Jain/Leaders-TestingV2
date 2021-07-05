global class DeleteMandateAttachment  implements Schedulable {
   global void execute(SchedulableContext SC) {
      
       //Get all mandates
       Set<Id> mandateIds = new Set<Id>();
       for(Mandate__c mandate:[SELECT Id FROM Mandate__c])
           mandateIds.add(mandate.Id);
       
       //Get all attachments for all mandates where name contains "CHART"
       List<Attachment> chartAttachments = [SELECT Id FROM Attachment WHERE ParentId IN :mandateIds AND (Name LIKE 'CHART__%' OR Name LIKE 'CustomCompetency%' OR Name LIKE 'Human Capital Study%' OR Name LIKE 'Potential Candidates%' OR Name LIKE 'Cover%' OR Name LIKE 'CandidateToDiscuss%' OR Name LIKE 'AllCompetencies%' OR Name LIKE 'CandidateByStatus%')] ;
       
       List<Attachment> tempAttachments = [SELECT Id FROM Attachment WHERE ParentId IN :mandateIds AND Name LIKE 'Overnight Report%' ORDER BY LastModifiedDate DESC] ;
       Integer i=0;
       for(Attachment att: tempAttachments) {
           if(i>0)
               chartAttachments.add(att);
           i++;
       }
       
       //Delete "Charts" attachments
       delete chartAttachments;
       
   }

}