({
	 getStatus: function(cmp, event, helper) {
        debugger;
        var getStatusData = cmp.get("c.getAllAssignmentStatus");
        getStatusData.setParams({
        });
        getStatusData.setCallback(this, function(response){
            var state = response.getState();
            if(state == 'SUCCESS'){
                cmp.set("v.statusListofAssignment", response.getReturnValue());
            }
        });
        $A.enqueueAction(getStatusData);
    },

})