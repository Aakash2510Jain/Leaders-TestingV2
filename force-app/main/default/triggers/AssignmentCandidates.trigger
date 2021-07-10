/* **************************************************************************
* Trigger: AssignmentCandidates
* Created by Karyn Cuenca, 05/05/2015
*
* Purpose:
* - This trigger will prevent assign a contact to an Assignment more than once
*
* Unit Test:  AssignmentCandidatesTest
* 
* Modifications:
* - {DevName}, {MM/DD/YYYY} – {Description of changes made}
*
************************************************************************** */
trigger AssignmentCandidates on Application__c (before insert, before update,after update,after insert) 
{
    
    if(Trigger.isUpdate && Trigger.isAfter){
        AssignmentCandidatesHelper.updateCompanyOffLimit(Trigger.new,Trigger.oldMap);
        AssignmentCandidatesHelper.updatesslFrenchValues(Trigger.new);
    }
    if(Trigger.isInsert && Trigger.isAfter){
        AssignmentCandidatesHelper.updatesslFrenchValues(Trigger.new);
       
    }
    if(Trigger.isInsert && Trigger.isBefore){
        system.debug('Before insert fired');
        AssignmentCandidatesHelper.checkDuplicateContactsOnAssignment(Trigger.new,true,null);
        AssignmentCandidatesHelper.AssigningDepartment(Trigger.new);
    }
    if(Trigger.isUpdate && Trigger.isBefore){
        if(AssignmentCandidatesHelper.RunOncebeforeupdate == false){
            system.debug('Before update fired');
            AssignmentCandidatesHelper.AssigningDepartment(Trigger.new);
            AssignmentCandidatesHelper.checkDuplicateContactsOnAssignment(Trigger.new,false,trigger.oldMap);
            AssignmentCandidatesHelper.checkRemovalOfContactsFromAssignment(Trigger.new,trigger.oldMap);
        }
    }
    
}