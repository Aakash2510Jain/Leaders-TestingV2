({
	myAction : function(component, event, helper) {
		
	},
    
    doInit : function(component,event,helper){
      
        var rid = component.get("v.recordId");
        console.log(rid);
        var params = event.getParam('arguments');
        if (params) {
            var param1 = params.recId;
           // return "##### Hello "+param1+" From Child Component #####";
            
            console.log(param1);
        }
        
        helper.getRecordDetails(component,event,helper);
        
        var test = component.get("v.contact")
        console.log(test)
        
        var selectedtype = component.find("selectUploadType").get("v.value");
        console.log(selectedtype);
        component.set("v.selectedUploadType",selectedtype);
        
        if(selectedtype == "Notes and Attachments")
        {
            component.set("v.displayAttachments",true);
        }
        else{
            component.set("v.displayAttachments",false);
        }
        
        
    },
    
    closeModel: function(component,event,helper){
        var cmpTarget = component.find('Modalbox');
		var cmpBack = component.find('Modalbackdrop');
		$A.util.removeClass(cmpBack,'slds-backdrop--open');
		$A.util.removeClass(cmpTarget, 'slds-fade-in-open'); 
        component.set("v.displayCvPsyModal",false);
    },
    
    handleSelectUploadType : function(component,event,helper){
         var selectedtype = component.find("selectUploadType").get("v.value");
        console.log(selectedtype);
        component.set("v.selectedUploadType",selectedtype);
        
        if(selectedtype == "Notes and Attachments")
        {
            component.set("v.displayAttachments",true);
        }
        else{
            component.set("v.displayAttachments",false);
        }
        
    }
    
})