({
    fetchCanWrapHelper : function(component, event, helper) {
        
        var action = component.get("c.getCandidateAttWrapper");
        
        action.setParams({
            recordId : component.get("v.recordId")
        });
        
        action.setCallback(this,function(response){
            var result = response.getReturnValue();
            debugger;
            if(response.getState() === "SUCCESS"){
                component.set("v.canWrapList",result);
            }
            else{
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error !",
                    "message": "Some Problem while fetching records.",
                    "type":'error'
                });
                toastEvent.fire();
            }
            
        }) ;
        $A.enqueueAction(action);
    }
})