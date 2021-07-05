trigger EC_AttachmentCV on Attachment (after insert, after update, after delete) {

    if(trigger.isInsert && trigger.isAfter){
        AttachmentTriggerHelper.updatePSYAndHasCV(trigger.new);
    }
    
}