({
    fetchDataHelper: function(component,event,helper){
         component.set("v.showLoadingSpinner",true);
        debugger;
        var action = component.get("c.RadarValues");
        
        action.setParams({
            "mandateRecId" : component.get("v.recordId")
        });
        action.setCallback(this,function(response){
            var result = response.getReturnValue();
            debugger;
            if(response.getState() === "SUCCESS"){
                {
                    component.set("v.radar_Values",result);
                    component.set("v.showLoadingSpinner",false);
                    component.set("v.Is_English",false);
                }
            }
        });
        $A.enqueueAction(action);
    },

    handleChange: function(component, event, helper) {
        
        var abc = component.get("v.Is_English");
        if(abc == true){
             component.set("v.tabId",'1'); 
        }else{
            component.set("v.tabId",'2'); 
        }
      
    },
    removeValues : function(component, index) {
        debugger;
        var values = component.get("v.radar_Values");
        values.splice(index, 1);
        component.set("v.radar_Values", values);
    },
    addValues : function(component) {
        
        var allRecs = component.get("v.radar_Values");
        allRecs.push({'Radar_Rating_Ques__c':'','Radar_Rating_Fr_Ques__c':'','Assignment__c':component.get("v.recordId")});
        component.set("v.radar_Values",allRecs);
        
    }
})