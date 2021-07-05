({
	myAction : function(component, event, helper) {
		
	},
    
    doInit : function(component,event,helper){
      helper.searchRec(component,event,helper);  
    },
    
    addBD : function(component,event,helper){
        helper.createBD(component,event,helper);
      //  helper.hideSearchBDComp(component,event,helper);
    },
    
    closeModel: function(component,event,helper){
        
        var cmpTarget = component.find('Modalbox');
		var cmpBack = component.find('Modalbackdrop');
		$A.util.removeClass(cmpBack,'slds-backdrop--open');
		$A.util.removeClass(cmpTarget, 'slds-fade-in-open'); 
        component.set("v.openSearchBDModal",false);
        component.set("v.searchBD",null);
    },
    
})