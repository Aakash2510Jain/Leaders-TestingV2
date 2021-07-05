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
trigger AssignmentCandidates on Application__c (before insert, before update,after update) 
{
    
    if(Trigger.isUpdate && Trigger.isAfter){
        AssignmentCandidatesHelper.updateCompanyOffLimit(Trigger.new,Trigger.oldMap);
        AssignmentCandidatesHelper.updatesslFrenchValues(Trigger.new);
    }
    if(Trigger.isInsert && Trigger.isAfter){
        AssignmentCandidatesHelper.updatesslFrenchValues(Trigger.new);
    }
    if(Trigger.isInsert && Trigger.isBefore){
        AssignmentCandidatesHelper.checkDuplicateContactsOnAssignment(Trigger.new,true,null);
    }
    if(Trigger.isUpdate && Trigger.isBefore){
        AssignmentCandidatesHelper.checkDuplicateContactsOnAssignment(Trigger.new,false,trigger.oldMap);
        AssignmentCandidatesHelper.checkRemovalOfContactsFromAssignment(Trigger.new,trigger.oldMap);
    }
    
}