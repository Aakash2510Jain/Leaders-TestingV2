({
    createBioDoc : function(component, event, helper) {
        helper.createBioDoc(component);
    },
    
    closeModel: function(component,event,helper){
        var cmpTarget = component.find('Modalbox');
        var cmpBack = component.find('Modalbackdrop');
        $A.util.removeClass(cmpBack,'slds-backdrop--open');
        $A.util.removeClass(cmpTarget, 'slds-fade-in-open'); 
        component.set("v.displayOPComp",false);
    },
    
    saveRecord: function(component,event,helper){
        helper.saveContact(component,event,helper);
        helper.createBioDoc(component);
        helper.closeModel(component,event,helper); 
    },
    
    recordUpdated: function(component,event,helper){
        helper.recordUpdated(component,event,helper);
    }
    
})