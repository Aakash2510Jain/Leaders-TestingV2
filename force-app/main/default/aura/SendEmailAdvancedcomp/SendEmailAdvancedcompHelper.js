({
    showLoader: function(component, event, helper) {
        component.set("v.loader", true);
    },
    hideLoader : function(component,event,helper){
        component.set("v.loader", false);
    },  
})