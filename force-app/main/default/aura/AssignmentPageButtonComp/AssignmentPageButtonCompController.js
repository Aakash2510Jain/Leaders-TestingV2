({
    showNotesAndAttachment: function(component, event, helper) {
        debugger;
        var abc = component.get("v.recordId");
        component.set("v.showNotesAndAttachment",true);
    },
    uploadFile: function(component, event, helper) {
        component.set("v.showFileUpload",true);
    },
    BackToAssCan  : function(component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
       var abc = component.get("v.recordId");
        urlEvent.setParams({
            'url': 'https://leadersinternational.lightning.force.com/lightning/cmp/c__AssignmentCandidatesPageComp?c__mandateId='+abc
        });
        urlEvent.fire();
    },
})