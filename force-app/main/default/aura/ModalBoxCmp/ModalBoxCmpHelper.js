({
	showModal: function(component) {


    	//Fixed header issue with Lightning App Page
        component.set("v.cssStyle", ".forceStyle .viewport .oneHeader.slds-global-header_container {z-index:0}");

         //Toggle CSS styles for opening Modal
         component.set('v.backdrop','slds-backdrop--open');
         component.set('v.modaldialog','slds-fade-in-open');
    },

    hideModal : function(component) {
        
         component.set('v.backdrop','slds-backdrop--hide');
         component.set('v.modaldialog','slds-fade-in-hide');
        
        //Fixed header issue with Lightning App Page
    	component.set("v.cssStyle", "");
    }
})