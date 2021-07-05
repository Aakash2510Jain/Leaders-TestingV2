({  
     myAction : function(component, event, helper) {
        debugger;
       var action = component.get("c.getUserTeamByTeam");
        action.setCallback(this, $A.getCallback(function(response){
            var state= response.getState();
            var result = response.getReturnValue();    
            if(state=="SUCCESS"){
                if(result == 'The Montreal Team')
                { 
                    debugger;
                    component.set("v.TeamName",'Montreal');
                    //component.set("v.MontrealView",true);
                    component.set("v.OttawaView",false);
                    component.set("v.TorontoView",false);
                    component.set("v.defaultPickVal","Montreal Weekly Review");
                    component.set("v.selectedValue","Montreal Weekly Review");
                    
                }
                else if(result == 'Ottawa Team')
                {
                     debugger;
                    component.set("v.TeamName",'Ottawa');
                    //component.set("v.OttawaView",true);
                    component.set("v.MontrealView",false);
                    component.set("v.TorontoView",false);
                    component.set("v.defaultPickVal","Ottawa Weekly Review");
                    component.set("v.selectedValue","Ottawa Weekly Review");
                }
                else if(result == 'Toronto Team')
                {
                     debugger;
                    component.set("v.TeamName",'Toronto');
                    //component.set("v.TorontoView",true);
                    component.set("v.MontrealView",false);
                    component.set("v.OttawaView",false);
                    component.set("v.defaultPickVal","Toronto Weekly Review");
                    component.set("v.selectedValue","Toronto Weekly Review");
                }
                 else if(result == 'Indigenous Team')
                { 
                    debugger;
                    component.set("v.TeamName",'Indigenous');
                    //component.set("v.MontrealView",true);
                    component.set("v.OttawaView",false);
                    component.set("v.TorontoView",false);
                    component.set("v.defaultPickVal","Indegenous Weekly Review");
                    component.set("v.selectedValue","Indegenous Weekly Review");
                    
                }
                else if(result == 'Leaders')
                {
                     component.set("v.TeamName",'Leaders');
                    //component.set("v.TorontoView",true);
                    //component.set("v.MontrealView",true);
                    //component.set("v.OttawaView",true);
                    component.set("v.defaultPickVal","Montreal Weekly Review");
                    component.set("v.selectedValue","Montreal Weekly Review");
                }
               
                else{
                    component.set("v.TorontoView",false);
                    component.set("v.MontrealView",false);
                    component.set("v.OttawaView",false);
                }
                component.set("v.isViewVisible",true);
                // Default Event Fire
                if(component.get("v.teamNameFromEvent") == 'activeAssignment'){
                    component.set("v.defaultPickVal","My Active Assignments");
                    component.set("v.selectedValue","My Active Assignments");
                }
                
                var AssignE = $A.get("e.c:AssignmentListEvent");
                AssignE.setParams({"selectedlist": component.get("v.defaultPickVal")});
                AssignE.fire();  
                
                
                
            }else if (state=="ERROR"){
                var errors = response.getError();
                console.error(errors);
                component.set("v.isViewVisible",true);
            }
            
            
            
        } ));
        $A.enqueueAction(action);
    	
    
    
},
})