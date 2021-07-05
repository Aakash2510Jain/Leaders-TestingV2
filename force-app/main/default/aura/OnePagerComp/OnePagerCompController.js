({
	myAction : function(component, event, helper) {
		
	},
    
     saveRecord: function(component,event,helper){
        helper.saveContact(component,event,helper);
       //  helper.closeModel(component,event,helper); 
        // helper.navigateToRecord(component,event,helper);
        
    },
    
    recordUpdated: function(component,event,helper){
        helper.recordUpdated(component,event,helper);
       
        
       
    }
})