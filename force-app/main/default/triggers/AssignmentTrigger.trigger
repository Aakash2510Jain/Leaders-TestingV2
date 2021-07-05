trigger AssignmentTrigger on Mandate__c (after update,after insert) {
    if(Trigger.IsAfter && Trigger.IsUpdate)
    {
        AssignmentTriggerHelper.updateCompanyOffLimitstartDate(Trigger.New,trigger.oldMap);
    }
    if(Trigger.IsAfter && Trigger.IsInsert)
    {
        AssignmentTriggerHelper.createAssignmentNote(Trigger.New);
        AssignmentTriggerHelper.createOnePager(Trigger.New);
    }
}