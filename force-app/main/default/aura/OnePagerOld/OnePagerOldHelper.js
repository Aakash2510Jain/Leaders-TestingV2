({
	helperMethod : function() {
		
	},
    
    
     closeModel: function(component,event,helper){
        var cmpTarget = component.find('Modalbox');
		var cmpBack = component.find('Modalbackdrop');
		$A.util.removeClass(cmpBack,'slds-backdrop--open');
		$A.util.removeClass(cmpTarget, 'slds-fade-in-open'); 
        component.set("v.displayOPComp",false);
    },
    
    saveContact: function(component,event,helper){
        
        component.find("conRec").saveRecord($A.getCallback(function(saveResult){
        if (saveResult.state === "SUCCESS" || saveResult.state === "DRAFT") {
                console.log("Save completed successfully.");
            component.set("v.checkSpinner",false);
            } else if (saveResult.state === "INCOMPLETE") {
                component.set("v.recordSaveError","User is offline, device doesn't support drafts.");
                 component.set("v.checkSpinner",false);
            } else if (saveResult.state === "ERROR") { 
                var errMsg = "";
                // saveResult.error is an array of errors, 
                // so collect all errors into one message
                for (var i = 0; i < saveResult.error.length; i++) {
                    errMsg += saveResult.error[i].message + "\n";
                }
                component.set("v.checkSpinner",false);
                component.set("v.recordSaveError", errMsg); 
                
            } else {
                component.set("v.recordSaveError",'Unknown problem, state: ' + saveResult.state + ', error: ' + 
			      JSON.stringify(saveResult.error));
            }
        }));
	},
    
    recordUpdated : function(component, event, helper){
        var changeType = event.getParams().changeType;
		if (changeType === "CHANGED") {
            component.find("conRec").reloadRecord();
        }
    },
    navigateToRecord : function(component,event,helper){
        
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId" : recordId
        });
        
        navEvt.fire();
    },
    createBioDoc: function(component){
         //component.set("v.checkSpinner",true);
        var action = component.get("c.createOnePagerOrBioDocs");
        action.setParams({
            conId:component.get("v.recordId"),
            docType:'ONE_PAGER',
            language:'english'
        })
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
              component.set("v.checkSpinner",false);  
            }
        });
        $A.enqueueAction(action);
    }
        
})