({
    doInit : function(component, event, helper) {
        debugger;
        helper.doInitHelper(component, event, helper);
     },
    showJobDesc : function(component,event,helper)
    {
        debugger;
        var jobId = component.get('v.JobDescId');
        component.set("v.JDid",jobId);
        component.set("v.displayJD",true);
    }
})