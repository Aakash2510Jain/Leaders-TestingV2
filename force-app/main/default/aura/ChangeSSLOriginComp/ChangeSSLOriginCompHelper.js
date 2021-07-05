({
	fetchSSL : function(component, event, object, fieldApi, itemToSet) {
		debugger;
		var action = component.get("c.getPicklistValues");
        action.setParams({
            objectType : object,
            selectedField : fieldApi
        });
        
        action.setCallback(this,function(response){
            var list = response.getReturnValue();
            debugger;
            component.set(itemToSet,list);
            
        })
    	$A.enqueueAction(action);
	},
    saveStatus : function(component, event, saveType) {
        debugger;
        var action = component.get("c.updateStatus");
        action.setParams({
            ssl : component.get("v.selectedSSLValue"),
            origin : component.get("v.selectedOriginValue"),
            recListString : JSON.stringify(component.get("v.recordList")),
            saveType : saveType
        });
        
        action.setCallback(this,function(response){
            var toastEvent = $A.get("e.force:showToast");
            if(response.getReturnValue() == true){
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "Records updated successfully.",
                     "type": 'success'
                });
                toastEvent.fire();
                $A.get('e.force:refreshView').fire();
            }else{
                toastEvent.setParams({
                    "title": "Something went wrong!",
                    "message": "contact admin",
                     "type": 'error'
                });
                toastEvent.fire();
            }
        })
        $A.enqueueAction(action);
    }

})