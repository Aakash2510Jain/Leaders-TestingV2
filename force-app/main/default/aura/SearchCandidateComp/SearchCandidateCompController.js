({
	myAction : function(component, event, helper) {
		
	},
    
    doInit : function(component,event,helper){
     helper.searchCandidateRec(component,event,helper);   
    },
    
    closeModel : function(component,event,helper){
        var cmpTarget = component.find('Modalbox');
		var cmpBack = component.find('Modalbackdrop');
		$A.util.removeClass(cmpBack,'slds-backdrop--open');
		$A.util.removeClass(cmpTarget, 'slds-fade-in-open');
        component.set("v.openSearchPopup",false);
    },
    
    GoButton : function(component,event,helper){
        
    },
    
    AddPeople : function(component,event,helper){
        
    },
    
    handleSelectPeople : function(component,event,helper){
        var selectedItem = event.currentTarget
        var recId = selectedItem.dataset.recordid;
        var recName = selectedItem.dataset.recordname;
        
        console.log(recId);
        console.log(recName);
        
        var appEvent = $A.get("e.c:newCandidateEvent");
        appEvent.setParams({
            "peopleId" : recId,
            "peopleName" : recName
        })
        
        appEvent.fire();
        
        var cmpTarget = component.find('Modalbox');
		var cmpBack = component.find('Modalbackdrop');
		$A.util.removeClass(cmpBack,'slds-backdrop--open');
		$A.util.removeClass(cmpTarget, 'slds-fade-in-open');
        component.set("v.openSearchPopup",false);
        
    }
})