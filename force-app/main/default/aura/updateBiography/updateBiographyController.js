({
	myAction : function(component, event, helper) {
		
	},
    
    closeModel: function(component,event,helper){
        var cmpTarget = component.find('Modalbox');
		var cmpBack = component.find('Modalbackdrop');
		$A.util.removeClass(cmpBack,'slds-backdrop--open');
		$A.util.removeClass(cmpTarget, 'slds-fade-in-open'); 
        component.set("v.displayUpdateBio",false);
    },
})