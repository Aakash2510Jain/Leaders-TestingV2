({
	hideModal : function(component, event, helper) {
		component.set('v.isActive',false);
	},
    
    doInit : function(component,event,helper){
      //  component.set('v.openSearchModal',false);
     //   
        helper.fetchFA1(component,event,helper);
        helper.fetchMC(component,event,helper);
        helper.fetchJobLevel(component,event,helper);
        helper.fetchMS(component,event,helper);
        
        component.set('v.displayNewPeople',true);
        
        component.find("newConRec").getNewRecord(
            "Contact", // objectApiName
            null, // recordTypeId
            false, // skip cache?
            $A.getCallback(function() {
                var rec = component.get("v.newContact");
                var error = component.get("v.recordSaveError");
                if(error || (rec === null)) {
                    console.log("Error initializing record template: " + error);
                }
                else {
                    console.log("Record template initialized: " + rec.sobjectType);
                }
            })
        );
    },
    
    closeModel: function(component,event,helper){
        helper.closeModal(component,event,helper);
        var cmpTarget = component.find('Modalbox');
		var cmpBack = component.find('Modalbackdrop');
		$A.util.removeClass(cmpBack,'slds-backdrop--open');
		$A.util.removeClass(cmpTarget, 'slds-fade-in-open'); 
        component.set("v.displayNewPeople",false);
      
    },
    
    
    
    onSuccess : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "message": "The record has been Saved successfully."
        });
        toastEvent.fire();
    },
    onSubmit : function(component, event, helper) {
    },
    onLoad : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Loaded!",
            "message": "The record has been Loaded successfully ."
        });
        toastEvent.fire();
    },
    onError : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Error!",
            "message": "Error."
        });
        toastEvent.fire();
    },
    
    selectFA1 : function(component,event,helper){
        var selectedFA = component.find("FA1").get("v.value")
        component.set('v.newContactRecord.Functional_Area1__c', selectedFA);
    },
    
     handleSaveContact: function(component, event, helper) {
       // if(helper.validateContactForm(component)) {
            component.set("v.newContactRecord.AccountId", component.get("v.recordId"));
            component.find("newConRec").saveRecord(function(saveResult) {
                if (saveResult.state === "SUCCESS" || saveResult.state === "DRAFT") {
                    // record is saved successfully
                    var resultsToast = $A.get("e.force:showToast");
                    resultsToast.setParams({
                        "title": "Saved",
                        "message": "The record was saved."
                    });
                    resultsToast.fire();

                } else if (saveResult.state === "INCOMPLETE") {
                    // handle the incomplete state
                    console.log("User is offline, device doesn't support drafts.");
                } else if (saveResult.state === "ERROR") {
                    // handle the error state
                    console.log('Problem saving contact, error: ' + JSON.stringify(saveResult.error));
                } else {
                    console.log('Unknown problem, state: ' + saveResult.state + ', error: ' + JSON.stringify(saveResult.error));
                }
                
                helper.closeModal(component,event,helper);
                 component.set('v.openSearchModal',false);
            });
        }
  //  }
    
})