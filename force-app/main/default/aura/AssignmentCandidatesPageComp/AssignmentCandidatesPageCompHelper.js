({
	toggleHelper : function(component,event) {
    var toggleText = component.find("tooltip");
    $A.util.toggleClass(toggleText, "toggle");
   },
    fetchLangHelper: function(component,event,helper){
        debugger;
        var action = component.get("c.Get_Lang");
        
        action.setParams({
            "manId" : component.get("v.mandateRecId")
        });
        action.setCallback(this,function(response){
            var result = response.getReturnValue();
            debugger;
            if(response.getState() === "SUCCESS"){
                {
                    component.set("v.Is_English",result[2]);
                    if(result[0] == true)
                    {
                        component.set("v.ButtonClassForOP",'forestGreen');
                        component.set("v.OP_Created",true);
                        
                    }
                    if(result[1] == true){
                        component.set("v.ButtonClassForSelf",'forestGreen');
                        component.set("v.Self_Ass_Created",true);
                    }
                    if(result[3] == true){
                        component.set("v.ButtonClassForRR",'forestGreen');
                        component.set("v.Radar_Rat_Created",true);
                    }
                }
            }
        });
        $A.enqueueAction(action);
    },
})