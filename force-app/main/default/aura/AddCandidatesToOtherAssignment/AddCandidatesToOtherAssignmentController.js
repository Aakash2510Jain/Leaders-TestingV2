/**
 * Created by ET-MARLABS on 06-03-2019.
 */
({
    // get All records which needs to be shown in table
    
    handleSelectAllContact: function(component, event, helper) {
        if(component.get("v.isAssignmentResearch")){
             component.set("v.showSpinner", true);
            helper.handleSelectAllContactHelper(component,event,helper);
        }
        else{
            component.set("v.showSpinner", true);
            helper.saveCandidate(component,event,helper);
        }
    },
    selectAll: function(component, event, helper) {
         helper.selectAllHelper(component,event,helper);
    },
    handleComponentEvent : function(component, event, helper) {
        helper.handleComponentEventHelper(component, event, helper);
    },
    doInit: function(component, event, helper) {
        helper.fetchPickValHelper(component, event, helper,'Meeting_Note__c','Status_Summary_Line__c','v.SSLValues');
        helper.fetchPickValHelper(component, event, helper,'Application__c','Origin__c','v.OriginValues');
       
        helper.searchAssignment(component, event);
        
    },
    closeModal : function(component, event, helper){
		component.set("v.displayAddCandidateToOtherAssignment",false);
    },
    searchAssignment : function(component, event, helper){
        //component.set("v.showAssignmentForm",true);
      helper.searchAssignment(component, event);
    },
    copyNotes : function(component,event,helper){
        debugger;
        var valIQ= event.getSource().get("v.value");
        component.set("v.copyNotes", valIQ);
    },
    doneEventHandler : function(component, event, helper){
      helper.doneEventHandler(component,event);
    },
    changeSelectedRecord : function(component, event, helper){
      helper.changeSelectedRecordHandler(component,event);
    },
})