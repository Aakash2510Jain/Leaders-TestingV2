({
    init: function (cmp, event, helper)
    {
        debugger;
        var getData = cmp.get("c.getAllAssignment");
        getData.setParams({
        });
        getData.setCallback(this, function(response){
            var state = response.getState();
            if(state == 'SUCCESS'){
                cmp.set("v.allAssignment", response.getReturnValue());
                cmp.set("v.assignmentAsPerStatusList", response.getReturnValue());
                helper.getStatus(cmp, event, helper);
            }
        });
        $A.enqueueAction(getData);
    },
    
    onStatusChange : function(component, event, helper)
    {
        debugger;
       // var assignmentListFromCmp = component.get("v.assignmentAsPerStatusList");
        var allAssignmentList = component.get("v.allAssignment");
        var statusOfAssignment = component.get("v.selectedStatus");
        var listSize = allAssignmentList.length;
        var modifiedlist = []; 
        for(var i=0; i<listSize; i++)
        {
            if(allAssignmentList[i].Assignment_Status__c ==  statusOfAssignment)
            {
                modifiedlist.push(allAssignmentList[i]);
            }
        }
        component.set("v.assignmentAsPerStatusList", modifiedlist);
        
    },
})