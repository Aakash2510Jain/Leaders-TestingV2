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
    
    }
})