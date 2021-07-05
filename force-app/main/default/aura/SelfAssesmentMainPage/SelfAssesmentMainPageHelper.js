({
    fetchDataHelper: function(component,event,helper){
        debugger;
        var action = component.get("c.Getmainpagecontent");
        action.setParams({
            "appId" : component.get("v.recordId")
        });
        action.setCallback(this,function(response){
            var result = response.getReturnValue();
            debugger;
            
            if(response.getState() === "SUCCESS"){
                {debugger;
                 component.set("v.self_Ass_Content",result[0]);
                 component.set("v.Language",result[1]);
                 
                 // component.set("v.self_Ass_Fr_Content",result["Data for candidate Fr"]);
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    
})