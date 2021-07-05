({
	saveStatus : function(component, event, saveType) {
        debugger;
        var action = component.get("c.updateStatus");
        action.setParams({
            recListString : JSON.stringify(component.get("v.recordList"))
        });
        
        action.setCallback(this,function(response){
            var toastEvent = $A.get("e.force:showToast");
            if(response.getReturnValue() == true){
                
             swal.fire({
                        title: "Success!",
                        text: "Records updated successfully.",
                        type: "Error",
                        timer: 3000
                    });
               
                $A.get('e.force:refreshView').fire();
            }else{
              
                  swal.fire({
                        title: "Something went wrong!",
                        text: "contact admin",
                        type: "Error",
                        timer: 3000
                    });
            }
        })
        $A.enqueueAction(action);
    },
   

})