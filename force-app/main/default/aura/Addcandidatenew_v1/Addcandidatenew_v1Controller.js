({
    GetValues : function(component, event, helper)
    {
        debugger;
        var Fname = component.get("v.FirstName");
        var Lname = component.get("v.LastName");
        
        var action = component.get("c.createCon");
        
        action.setParams({
            Fname : Fname,
            Lname : Lname
        });
        
        action.setCallback(this,function(response){
            var list = response.getReturnValue();
            alert(list);
        })
        $A.enqueueAction(action);
        
    },
    
})