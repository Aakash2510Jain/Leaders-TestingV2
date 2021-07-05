({
	helperMethod : function() {
		
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
                
                var res = component.get("v.contact");
                console.log(res);
                
                var fName = component.get("v.contact").FirstName;
                console.log(fName);
                component.set("v.FirstName",fName);
                
                var lName = component.get("v.contact").LastName;
                console.log(lName);
                component.set("v.LastName",lName);
                
                
            }
        });
        $A.enqueueAction(action);  
    }
})