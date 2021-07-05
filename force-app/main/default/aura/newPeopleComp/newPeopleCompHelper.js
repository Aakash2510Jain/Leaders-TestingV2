({
	helperMethod : function() {
		
	},
    
    validateContactForm: function(component) {
        var validContact = true;

         // Show error messages if required fields are blank
        var allValid = component.find('contactField').reduce(function (validFields, inputCmp) {
            inputCmp.showHelpMessageIfInvalid();
            return validFields && inputCmp.get('v.validity').valid;
        }, true);

        if (allValid) {
            // Verify we have an account to attach it to
            var account = component.get("v.account");
            if($A.util.isEmpty(account)) {
                validContact = false;
                console.log("Quick action context doesn't have a valid account.");
            }
        	return(validContact);
            
        }  
	},
    
    fetchFA1 : function(component,event,helper){
        var action= component.get("c.getPickListValuesFA1");
        action.setParams({
            objectType: 'Contact',
            selectedField: 'Functional_Area_1__c'
        });
        
        action.setCallback(this,function(response){
            var list=response.getReturnValue();
            
            component.set("v.FA1PicklistValues", list);
        })
        
        $A.enqueueAction(action);
    },
    
    fetchMC : function (component,event,helper){
        var action= component.get("c.getPickListValuesFA1");
        action.setParams({
            objectType: 'Contact',
            selectedField: 'MailingCountryCode'
        });
        
        action.setCallback(this,function(response){
            var list=response.getReturnValue();
            
            component.set("v.MCPicklistValues", list);
        })
        
        $A.enqueueAction(action);
    },
    
    fetchJobLevel : function(component,event,helper){
        var action= component.get("c.getPickListValuesFA1");
        action.setParams({
            objectType: 'Contact',
            selectedField: 'Job_Level__c'
        });
        
        action.setCallback(this,function(response){
            var list=response.getReturnValue();
            
            component.set("v.LevelPicklistValues", list);
        })
        
        $A.enqueueAction(action);
        
        
    },
    
    fetchMS : function (component,event,helper){
        var action= component.get("c.getPickListValuesFA1");
        action.setParams({
            objectType: 'Contact',
            selectedField: 'MailingStateCode'
        });
        
        action.setCallback(this,function(response){
            var list=response.getReturnValue();
            
            component.set("v.MSPicklistValues", list);
        })
        
        $A.enqueueAction(action);
    },
    
    closeModal :function(component,event,helper)
    {
        var cmpTarget = component.find('Modalbox');
		var cmpBack = component.find('Modalbackdrop');
		$A.util.removeClass(cmpBack,'slds-backdrop--open');
		$A.util.removeClass(cmpTarget, 'slds-fade-in-open'); 
        component.set("v.displayNewPeople",false);
    }
    
    
})