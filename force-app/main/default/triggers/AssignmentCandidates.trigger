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
        system.debug('After update fired');
        AssignmentCandidatesHelper.updateCompanyOffLimit(Trigger.new,Trigger.oldMap);
        AssignmentCandidatesHelper.updatesslFrenchValues(Trigger.new);
        // to create application test association on Application status = On Boarded 
        //AssignmentCandidatesHelper.createApplicationTestAssociation(Trigger.newMap, Trigger.oldMap);
        //// to send notification and test to applicant, on Application status = Under Assessment 
        AssignmentCandidatesHelper.sendTestsToApplicant(Trigger.newMap, Trigger.oldMap);
    }
    if(Trigger.isInsert && Trigger.isAfter){
        AssignmentCandidatesHelper.updatesslFrenchValues(Trigger.new);
        // to create application test association on Application status = On Boarded 
        AssignmentCandidatesHelper.createApplicationTestAssociation(Trigger.newMap, Trigger.oldMap);
       
    }
    if(Trigger.isInsert && Trigger.isBefore){
        system.debug('Before insert fired');
        AssignmentCandidatesHelper.checkDuplicateContactsOnAssignment(Trigger.new,true,null);
        AssignmentCandidatesHelper.AssigningDepartment(Trigger.new,true);
    }
    if(Trigger.isUpdate && Trigger.isBefore){
        if(AssignmentCandidatesHelper.RunOncebeforeupdate == false){
            system.debug('Before update fired');
            AssignmentCandidatesHelper.AssigningDepartment(Trigger.new,false);
            AssignmentCandidatesHelper.checkDuplicateContactsOnAssignment(Trigger.new,false,trigger.oldMap);
            AssignmentCandidatesHelper.checkRemovalOfContactsFromAssignment(Trigger.new,trigger.oldMap);
        }
    }
}