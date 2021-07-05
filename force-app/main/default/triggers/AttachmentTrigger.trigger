/* **************************************************************************
* Trigger: AttachmentTriggerBefore
* Created by Jesus Varela, 11/06/2014
*
* Purpose/Methods:
* - send email after leaders report generation
*
* Unit Test: GenerateIdentificationReportBatchTest
* 
* Modifications:
* - 08/06/2015 - kc@nubik.ca - assign the user that generated the report as the 
*                owner of the report (C102294)
* - 10/01/2015 - kc@nubik.ca - if the assignment has a document that is called 
*                Job Description or Research Strategy put related check in true
*
************************************************************************** */
trigger AttachmentTrigger on Attachment (after delete, after insert, after undelete, 
                                         after update, before delete, before insert, before update) {
                                             
                                             
                                             List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
                                             
                                             Map<Id, String> attachMap = new Map<Id, String>();
                                             
                                             Set<Id> parentIds = new Set<Id>();
                                             List<Attachment> attachments;
                                             String orgEmail = [select Id, DisplayName,Address from OrgWideEmailAddress where DisplayName='Leaders Report App' Limit 1].Id;
                                             if(trigger.isAfter && trigger.isInsert){
                                                 
                                                 attachments = trigger.new;
                                                 
                                                 for(Attachment att : trigger.new){
                                                     if(att.Name.contains(GenerateIdentificationReportBatch.IDENTIFICATION_NAME)){
                                                         string userId = '';
                                                         if(att.Name.lastIndexOf('_') > 0 && att.Name.lastIndexOf('.pdf') > 0){
                                                             userId = att.Name.substring(att.Name.lastIndexOf('_')+1,att.Name.lastIndexOf('.pdf'));
                                                             system.debug('[AttachmentTrigger] userId '+userId);
                                                             if (NubikHelper.validateId(userId)){                       
                                                                 Messaging.SingleEmailMessage singleMail = new Messaging.SingleEmailMessage();
                                                                 singleMail.setSaveAsActivity(false);
                                                                 singleMail.setOrgWideEmailAddressId(orgEmail);
                                                                 singleMail.setTargetObjectId(userId);
                                                                 //singleMail.setToAddresses(new List<String>{'ajeet.kumar@utilitarianlab.com'});
                                                                 singleMail.setSubject(Label.Leaders_notification_email_subject);
                                                                 singleMail.setHtmlBody(Label.Leaders_notification_email.replace('{!url}',URL.getSalesforceBaseUrl().toExternalForm()+'/servlet/servlet.FileDownload?file='+att.Id));
                                                                 emails.add(singleMail);
                                                                 
                                                                 //(C102294) assign the user that generated the report as the owner of the report
                                                                 attachMap.put(att.Id, userId);
                                                             }
                                                         }
                                                     }
                                                     
                                                 }
                                             }
                                             
                                             //(C109851)  if the assignment has a document that is called Job Description 
                                             //           or Research Strategy put related check in true
                                             if (trigger.isAfter && trigger.isDelete){
                                                 attachments = trigger.old;
                                             }
                                             
                                             if (attachments!= null && attachments.size()>0){
                                                 
                                                 for(Attachment att : attachments){
                                                     
                                                     if(att.ParentId.getSObjectType() == Mandate__c.SObjectType){
                                                         
                                                         if(att.Name.tolowercase().contains((GenerateIdentificationReportBatch.JOB_DESCRIPTION).tolowercase())){
                                                             parentIds.add(att.ParentId);
                                                         }else if (att.Name.tolowercase().contains((GenerateIdentificationReportBatch.RESEARCH_STRATEGY).tolowercase())){
                                                             parentIds.add(att.ParentId);
                                                         }
                                                     }
                                                 }
                                                 if(!parentIds.isEmpty()){
                                                     
                                                     Set<Id> hasJob = new Set<Id>();
                                                     map<Id,String> jobdesc = new map<Id,String>();
                                                     Set<Id> hasResearch = new Set<Id>();
                                                     
                                                     for (Attachment att : [Select Id,ParentId, Name
                                                                            from Attachment
                                                                            where ParentId in :parentIds]){
                                                                                if(att.Name.tolowercase().contains((GenerateIdentificationReportBatch.JOB_DESCRIPTION).tolowercase())){                   	
                                                                                    hasJob.add(att.ParentId);
                                                                                    jobdesc.put(att.ParentId,att.Id);
                                                                                }
                                                                                if (att.Name.tolowercase().contains((GenerateIdentificationReportBatch.RESEARCH_STRATEGY).tolowercase())){
                                                                                    hasResearch.add(att.ParentId);
                                                                                }
                                                                                if (att.Name.tolowercase().contains((GenerateIdentificationReportBatch.RESEARCH_STRATEGY).tolowercase())){
                                                                                    hasResearch.add(att.ParentId);
                                                                                }
                                                                            }
                                                     
                                                     List<Mandate__c> toUpdate = new List<Mandate__c>();
                                                     
                                                     for(Mandate__c man : [Select Id, Has_Research_Strategy__c,Has_Job_Description__c,Job_description_Id__c from Mandate__c where Id in :parentIds]){
                                                                               
                                                                               if(jobdesc!=null && jobdesc.containsKey(man.Id)){
                                                                                   man.Has_Job_Description__c = true;
                                                                                   man.Job_description_Id__c = jobdesc.get(man.Id);
                                                                               }else{
                                                                                   man.Has_Job_Description__c = false;
                                                                               }	  
                                                                               
                                                                               if(hasResearch!=null && hasResearch.contains(man.Id)){
                                                                                   man.Has_Research_Strategy__c = true;
                                                                               }else{
                                                                                   man.Has_Research_Strategy__c = false;
                                                                               } 		
                                                                               toUpdate.add(man);	
                                                                           }
                                                     
                                                     if(toUpdate.size()>0){
                                                         update toUpdate;
                                                     }
                                                 }
                                             }
                                             if(emails.size() > 0){
                                                 system.debug('[AttachmentTrigger] sending emails');
                                                 if(!Test.isRunningTest())
                                                 Messaging.sendEmail(emails);
                                             }
                                             
                                             //(C102294) assign the user that generated the report as the owner of the report
                                             if(!attachMap.isEmpty()){
                                                 List<Attachment> attachToUpdate = new List<Attachment>();
                                                 for (Attachment attach : [Select Id, OwnerId 
                                                                           from Attachment 
                                                                           where id in :attachMap.keySet()]){
                                                                               
                                                                               if (attachMap.containsKey(attach.Id)){
                                                                                   attach.OwnerId = attachMap.get(attach.Id);
                                                                                   attachToUpdate.add(attach);
                                                                               }
                                                                           }
                                                 if (attachToUpdate.size()>0){
                                                     update attachToUpdate;
                                                 }
                                             }
                                         }