({
	helperMethod : function() {
		
	},
    getRelatedAssignments: function(component,event,helper)
    {
        debugger;
        var action = component.get("c.getRelatedAssignments");
        action.setParams({
            'recordId' : component.get("v.recordId")
        });
        action.setCallback(this,$A.getCallback(function(response){
            var state = response.getState();
            var Response =[];
            Response = response.getReturnValue();
            if(state=="SUCCESS"){
                if(Response.length > 0)
                {
                    if(Response.length == 1){
                        component.set("v.showOnePagerFromContact",false);
                        component.set("v.showOnePager",true);
                    }
                    else{
                        component.set("v.mydata",response.getReturnValue());
                        component.set("v.showOnePagerFromContact",true);   
                    }
                }
                else{
                   component.set("v.showOnePagerFromContact",false);    
                }
                
            }
            else if(state=="ERROR"){
                var error = response.getError();
                console.error(errors);
            }
            
        }));
     $A.enqueueAction(action);
    }
})