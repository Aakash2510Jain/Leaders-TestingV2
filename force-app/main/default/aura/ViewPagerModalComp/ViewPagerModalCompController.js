({
    openModel: function(component, event, helper) {
        component.set("v.isOpen", true);
        component.set("v.isView", true);
    },
    closeModel: function(component, event, helper) {
        component.set("v.isOpen", false);
        component.set("v.isView", false);
    },
    closeModal: function(component, event, helper) {
        component.set("v.isOpen", false);
        //component.set("v.isView", false);
    },
    
    likenClose: function(component, event, helper) {
        component.set("v.isOpen", false);
    },
})