({
    fetchCanWrap : function(component, event, helper) {
        helper.fetchCanWrapHelper(component, event, helper);
    },
    closeModel: function(component, event, helper) {
        component.set("v.displayCandidateSelfAssessment",false);
    },
    openViewAssessment: function(component, event, helper) {
        var attId = event.getSource().get("v.value");
        component.set("v.attachmentId",attId);
        component.set("v.displayCV",true);
        console.log(attId);
    }
})