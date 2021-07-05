({
	helperMethod : function() {
		
	},
    
    updateNameOfDocument : function(component,event,docId,fName)
    {
         var action = component.get("c.UpdateFiles");  
    	// var fName = component.find("fileName").get("v.value");
        console.log(fName);
     	//alert('File Name'+fName);  
     	action.setParams({"documentId":docId,  
              "title": fName,  
              "recordId": component.get("v.recordId")  
              });  
     action.setCallback(this,function(response){  
       var state = response.getState();  
       if(state=='SUCCESS'){  
         var result = response.getReturnValue();  
         console.log('Result Returned: ' +result);  
      //   component.find("fileName").set("v.value", " ");  
         component.set("v.files",result);  
       }  
     });  
     $A.enqueueAction(action); 
        
        
    },
    
    getRecordDetails : function(component,event,helper)
    {
        var action = component.get("c.ContactDeatils");
        action.setParams({
            "recordId" : component.get("v.recordId")
        });
        
        action.setCallback(this,function(response){
         var state = response.getState();
            if(state=='SUCCESS'){
                var result = response.getReturnValue();
                 console.log('Result Returned: ' +result);  
      //   component.find("fileName").set("v.value", " ");  
         component.set("v.contact",result);  
            }
        });
        $A.enqueueAction(action);  
    },
    
    navigateToParentRecord : function(component,event,helper)
    {
        var navEvt = $A.get("e.force:navigateToSObject");
    navEvt.setParams({
      "recordId": component.get("v.recordId")
    //  "slideDevName": "related"
    });
    navEvt.fire();
    }
})