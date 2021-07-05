({
    doInitHelper : function(component, event, helper) {
        debugger;
        var obj=component.get("v.obj");
        var fieldName=component.get("v.fieldName");
        var fieldV=obj[fieldName];
        
        component.set("v.fieldValue",fieldV);
        
    }
})