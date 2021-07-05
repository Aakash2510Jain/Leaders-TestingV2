({
	helperMethod : function() {
		
	},
    
    navigateAssignment : function(component,event,helper){
         var navService = component.find("navService");
         var pageReference = component.get("v.pageReference");
       //  event.preventDefault();
         navService.navigate(pageReference);
     }
})