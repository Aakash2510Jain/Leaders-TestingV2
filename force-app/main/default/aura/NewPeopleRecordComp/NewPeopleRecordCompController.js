({
	hideModal : function(component, event, helper) {
		component.set('v.isActive',false);
	},
    
    doInit : function(component,event,helper){
      //  component.set('v.openSearchModal',false);
     //   
        
        debugger;
        component.set('v.displayNewPeople',true);
        var SearchName = component.get("v.searchPeople");
        if(SearchName != null && SearchName !='' && SearchName!= undefined){
            var seperatenames= SearchName.split(/ (.*)/);
            console.log(seperatenames);
            component.set("v.fname",seperatenames[0]);
            component.set("v.lname",seperatenames[1]);
        }
        
        
        
      //  component.set('v.openSearchModal',false);
        
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
        },
  //  }
    handleLoad: function(component, event, helper) {
        console.log("handle  handleLoad");
        component.set('v.showSpinner', false);
        
        $A.util.removeClass(component.find("FirstName"), "none");
        $A.util.removeClass(component.find("AccountId"), "none");
        $A.util.removeClass(component.find("FunctionalArea1"), "none");
      
            
    },

    handleSubmit: function(component, event, helper) {
        
         var FirstName = component.find("FirstName");
        var fNameValue= FirstName.get("v.value");
        
        if(fNameValue =='')
        {
            FirstName.set("v.errors",[{message:"Complete this field"}]); 
            Alert("complete all required fields");
        }
        
        
        event.preventDefault(); // prevent default submit
        var fields=event.getParam("fields");
        
        component.find('createContactForm').submit(fields);
        console.log('handle handleSubmit');
        
        
        component.set('v.disabled', true);
        component.set('v.showSpinner', true);
        
       
          
        
    },

    handleError: function(component, event, helper) {
        // errors are handled by lightning:inputField and lightning:nessages
        // so this just hides the spinnet
        component.set('v.showSpinner', false);
    },

    handleSuccess: function(component, event, helper) {  
         
        console.log('record updated successfully');
        component.set('v.showSpinner', false);
        component.set('v.saved', true);
        var payload = event.getParams().response;
		console.log(payload.id);
       // alert(payload.id);
        component.set("v.newRecId",payload.id);
        
        helper.navigateToContactRecord(component,event,helper);
        helper.showSuccessToast(component,event,helper);
    }
})