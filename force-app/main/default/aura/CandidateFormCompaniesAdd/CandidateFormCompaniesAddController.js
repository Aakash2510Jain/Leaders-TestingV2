({
	showModal: function(component, event, helper) {
        
        var params = event.getParam('arguments');
        if (params) {
        	component.set('v.company',params.company);
        }

		
		helper.showModal(component);
    
	},

	hideModal: function(component, event, helper) {
		
		helper.hideModal(component);

	},
     
    validate: function(component, event, helper) {
        var cie = component.get('v.company');
        console.log(cie);
        if(cie.name!='' &&
           cie.cieType!='' &&
           cie.secteur!='' &&
           cie.revenue!='' &&
           cie.fonction!='' &&
           cie.startYear!='' &&
           cie.hasOwnProperty('name') &&
           cie.hasOwnProperty('cieType') &&
           cie.hasOwnProperty('secteur') &&
           cie.hasOwnProperty('revenue') &&
           cie.hasOwnProperty('fonction') &&
           cie.hasOwnProperty('startYear') ) {
            component.set('v.isComplete',true);
        } else {
            component.set('v.isComplete',false);
        }
    },
    
    save: function(component, event, helper) {
        
        
    	component.getEvent("candidateFormCompaniesSaveEvent")
    			 .setParams({"company": component.get('v.company')})
    			 .fire();
    	helper.hideModal(component);
	}
})