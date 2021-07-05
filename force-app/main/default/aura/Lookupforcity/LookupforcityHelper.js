({
    searchHelper : function(component,event,getInputkeyWord) 
    {
        debugger;
        
        var action = component.get("c.getPickListValuesIntoList");
        
        var InputkeyWord = component.get("v.SearchKeyWord");
        
        action.setCallback(this, function(response) 
                           {
                               $A.util.removeClass(component.find("mySpinner"), "slds-show");
                               var state = response.getState();
                               if (state === "SUCCESS") {
                                   var storeResponse = response.getReturnValue();
                                   component.set("v.listOfSearchRecords", storeResponse);
                               }
                           });
        $A.enqueueAction(action);
    },
    
})