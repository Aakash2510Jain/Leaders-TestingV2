({
    doInit : function(component, event, helper) {
        helper.doInitHelper(component, event, helper);
    },
    openAttDetail : function(component, event, helper){
        debugger;
        var pageReference = {
            type: 'standard__recordPage',
            attributes: {
                recordId: event.target.name,
                actionName: 'view'
            }
        };

        var navService = component.find("navService");
        event.preventDefault();
        navService.navigate(pageReference);
    
    },
    select : function(component, event){
        debugger;
        
        
       component.set("v.selectedRecord",component.get("v.obj"));
               
        var compEvent = component.getEvent("doneEvent");
        compEvent.setParams({"type":"Mandate__c"});  
        compEvent.fire();
    },
})