({
	helperMethod : function() {
		
	},
    
    searchRec : function(component,event,helper){
        
        component.find("Id_Spinner").set("v.class",'slds-show');
        var action1 = component.get("c.fetchAssignmentRec");
        action1.setParams({
            'searchKeyWord': component.get("v.searchBD")
        });
        
        var action2 = component.get("c.fetchBDRec");
        action2.setParams({
            'searchKeyWord': component.get("v.searchBD")
        })
        
        action1.setCallback(this,$A.getCallback(function(response){
         
            component.find("Id_Spinner").set("v.class",'slds-hide');
            var state1=response.getState();
            
            if(state1=="SUCCESS"){
                var storeResponse1 = response.getReturnValue();
                if(storeResponse1.length == 0)
                {
                    component.set("v.Message",true);
                }else{
                    component.set("v.Message",false);
                }
                
                component.set("v.TotalNumberOfRecord",storeResponse1.length);
                
                component.set("v.searchAssignmentData",response.getReturnValue());
            }else if(state1=="ERROR"){
                var errors  = response.getError();
                console.error(errors);
            }
            
        }));
        
        action2.setCallback(this,$A.getCallback(function(response){
            component.find("Id_Spinner").set("v.class",'slds-hide');
            var state2=response.getState();
            
            if(state2=="SUCCESS"){
                var storeResponse2 = response.getReturnValue();
                if(storeResponse2.length == 0)
                {
                    component.set("v.Message",true);
                }else{
                    component.set("v.Message",false);
                }
                
                component.set("v.TotalNumberOfRecord",storeResponse2.length);
                
                component.set("v.searchBDData",response.getReturnValue());
            }else if(state2=="ERROR"){
                var errors  = response.getError();
                console.error(errors);
            }
            
        }));
        
       $A.enqueueAction(action1); 
       $A.enqueueAction(action2); 
        
        
        
    },
    
    createBD : function(component,event,helper){
        var createBDRecordEvent = $A.get("e.force:createRecord");
        createBDRecordEvent.setParams({
            "entityApiName" : "Business_Development__c"
        });
        
        createBDRecordEvent.fire();
        
    },
})