({
	helperMethod : function() {
		
	},
    
    searchCandidateRec : function(component,event,helper){
         //Show Spinner
        component.find("Id_Spinner").set("v.class",'slds-show');
        
        var action = component.get("c.fetchPeopleRec");
        action.setParams({
            'searchKeyWord':component.get("v.inputName")
        });
        action.setCallback(this,$A.getCallback(function(response){
            component.find("Id_Spinner").set("v.class",'slds-hide');
            var state =response.getState();
            
            if(state=="SUCCESS"){
                
                var storeResponse = response.getReturnValue();
                if(storeResponse.length == 0)
                {
                    component.set("v.Message",true);
                }else{
                    component.set("v.Message",false);
                }
                
                component.set("v.TotalNumberOfRecord",storeResponse.length);
                
                component.set("v.searchData",response.getReturnValue());
            }else if(state=="ERROR") {
                var errors = response.getError();
                console.error(errors);
            }   
                    
            
        }));
         $A.enqueueAction(action);
              
    }
})