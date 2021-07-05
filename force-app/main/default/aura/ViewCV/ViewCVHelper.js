({
    MainPageDataFetcher: function(component, event, helper) {
        debugger;
        var abc = component.get("v.contactId"); 
        var action = component.get("c.Self_Ass_Data");
        action.setParams({
            "conRecId": abc,
        });
        action.setCallback(this, $A.getCallback(function(response) {
            var state = response.getState();
            var storeResponse = response.getReturnValue();
            if (state == "SUCCESS") {
                { 
                    component.set("v.MainPageapplicationData",storeResponse);
                }
            }else{}
        }
                                               ));
        $A.enqueueAction(action);
    },
})