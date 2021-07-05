({
	helperMethod : function() {
		
	},
    getTeamOfUser : function(component,event,helper) 
    {
        debugger;
        var action = component.get("c.getTeamOfUser");
        
         action.setCallback(this,function(response){
            var userinfo = response.getReturnValue();
             if (userinfo != null)
             {
            console.log(userinfo.Team__c);
            
            if(userinfo.Team__c != 'Team 3'  )
            {
               component.set("v.CountryValue",'Canada');
            }
         }
        })
        $A.enqueueAction(action);
        
    },
   
})