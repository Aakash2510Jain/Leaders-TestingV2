({
	myAction : function(component, event, helper) {
		
	},
    handleChangeLanguage : function(component,event,helper){
         var selectedOptionValue = event.getParam("value");
         component.set("v.selectedLanguage",selectedOptionValue);
        
        if(selectedOptionValue = 'English'){
            component.set("v.selectedEnglish",true);
            component.set("v.selected2ndLang",false);
        }
        
        if(selectedOptionValue ='2nd Language'){
            component.set("v.selectedEnglish",false);
            component.set("v.selected2ndLang",true);
        }
    },
    
    handleLoad: function(component, event, helper) {
        console.log("handle  handleLoad");
        component.set('v.showSpinner', false);
            
    },

    handleSubmit: function(component, event, helper) {
        event.preventDefault(); // prevent default submit
        var fields=event.getParam("fields");
        
        component.find('editnotesform').submit(fields);
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
        helper.showSuccessToast(component,event,helper);
    }
})