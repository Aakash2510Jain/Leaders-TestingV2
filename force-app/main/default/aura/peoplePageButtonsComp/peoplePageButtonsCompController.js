({
    
    doInit : function(component,event,helper){
        helper.getContactInfo(component,event,helper);
        helper.getAppInfo(component,event,helper);
    },
    sendEmail:function(component,event,helper){
        component.set("v.displaySendEmail",true);
    },
     sendEmailAdvanced : function(component, event, helper) {
        debugger;
        component.set("v.displaySendEmailAdvanced", true);
       },
    goBack : function(component,event,helper){
        var pageReference={
            type: 'standard__component',
            attributes: {
                componentName:'c__AssignmentCandidatesPageComp'
            },
            state:{
                "c__mandateId": component.get("v.mandateId")
            }    
        };        
        component.set("v.pageReference",pageReference);
        var navService = component.find("navService");
        var pageReference = component.get("v.pageReference");
        event.preventDefault();
        navService.navigate(pageReference);
    },
    createOnePagerOrBio : function(component,event,helper){
        helper.createOnePagerOrBioHelper(component,event,helper);
    },
    createLongForm: function(component,event,helper){
        helper.createOnePagerOrBioHelper(component,event,helper);
    },
    editPeople: function(component, event, helper) {
        var editPeopleEvent = $A.get("e.force:editRecord");
        editPeopleEvent.setParams({
            "recordId" : component.get("v.recordId")
        });
        
        editPeopleEvent.fire();
        
    },
    deletePeople : function(component,event,helper){
        if(confirm("Are you sure you want to delete this People?"));
        helper.handleDeleteRecord(component,event,helper);
        
    },
    handleDeleteRecord: function(component, event, helper) {
        if(confirm("Are you sure you want to delete this People?"));
        component.find("recordHandler").deleteRecord($A.getCallback(function(deleteResult) {
            if (deleteResult.state === "SUCCESS" || deleteResult.state === "DRAFT") {
                console.log("Record is deleted.");
            } else if (deleteResult.state === "INCOMPLETE") {
                console.log("User is offline, device doesn't support drafts.");
            } else if (deleteResult.state === "ERROR") {
                console.log('Problem deleting record, error: ' + JSON.stringify(deleteResult.error));
            } else {
                console.log('Unknown problem, state: ' + deleteResult.state + ', error: ' + JSON.stringify(deleteResult.error));
            }
        }));
    },
    
    handleRecordUpdated: function(component, event, helper) {
        var eventParams = event.getParams();
        if(eventParams.changeType === "CHANGED") {
        } else if(eventParams.changeType === "LOADED") {
        } else if(eventParams.changeType === "REMOVED") {
            var resultsToast = $A.get("e.force:showToast");
            resultsToast.setParams({
                "title": "Deleted",
                "message": "The record was deleted."
            });
            resultsToast.fire();
        } else if(eventParams.changeType === "ERROR") {
        }
    },
    
    openOP: function(component,event,helper){
        helper.showLoaderHelper(component, event, helper);
        component.set("v.displayOPComp", true);
        helper.hideLoaderHelper(component, event, helper);
    },
    
    openAdd2Assign: function(component,event,helper){
        var conIdList = [];
        conIdList.push(component.get("v.recordId"));
        component.set("v.conIdList",conIdList);
        component.set("v.displayAddCandidateToOtherAssignment",true);
    },
    
    openUpdateBio: function(component,event,helper){
        component.set("v.displayUpdateBio",true);
    },
    openUpdateBioNew: function(component,event,helper){
        component.set("v.displayUpdateBioNew",true);
    },
    
    openCvPsyModal: function(component,event,helper){
        debugger;
        component.set("v.showFileUpload",true);
    },
    sendAssessmentLink: function(component,event,helper){
        helper.sendAssessmentLinkHelper(component,event);
    },
    openAttachment : function(component,event,helper){
        debugger;
        var buttonLabel = event.getSource().get("v.label");
        if(buttonLabel === "View Bio"){
            component.set("v.modalHeader","Candidate Bio");
        }else if(buttonLabel === "View Self Assessment"){
            component.set("v.modalHeader","Candidate Long Form");
        }else if(buttonLabel === "Check Templates"){
            component.set("v.modalHeader","The Templates");
        }else{
            component.set("v.modalHeader","Candidate One Pager");
        }
        if(buttonLabel != undefined){
            helper.openAttachmentHelper(component,event,buttonLabel);
        }
    },
    closeModal : function(component, event, helper) {
        component.set("v.displayAttachment",false);
    },
    devMode: function(component, event, helper) {
        alert('In Development Mode');
    },
    openSelfAss: function(component, event, helper) {
        component.set("v.displayCandidateSelfAssessment",true);
    },
     showNotesAndAttachment: function(component, event, helper) {
        component.set("v.showNotesAndAttachment",true);
    },
    OpenPagerModal:function(component,event,helper){
       debugger;
        var action =component.get("c.viewAttachment");
        action.setParams({
            parentId: component.get("v.recordId"),
            type : 'View One Pager'
        });
        action.setCallback(this,function(response){
            var result = response.getReturnValue();
            debugger;
            if(response.getState() === "SUCCESS"){
                component.set("v.OnePagerId",result);
            }
        });
        $A.enqueueAction(action);
        
        component.set("v.isOpen",true);
    }
    
})