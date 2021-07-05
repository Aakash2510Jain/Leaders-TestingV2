({
	helperMethod : function() {
		
	},
    
    searchCompanyRec : function(component,event,helper){
    
        component.find("Id_Spinner").set("v.class",'slds-show');
        var action1 = component.get("c.fetchCompanyRec");
        action1.setParams({
            'searchKeyWord': component.get("v.searchCompany")
        });
        
        action1.setCallback(this,$A.getCallback(function(response){
            component.find("Id_Spinner").set("v.class",'slds-hide');
            var state=response.getState();
            
            if(state=="SUCCESS"){
                var storeResponse = response.getReturnValue();
                if(storeResponse.length == 0)
                {
                    component.set("v.Message",true);
                }else{
                    component.set("v.Message",false);
                }
                
                component.set("v.TotalNumberOfRecord",storeResponse.length);
                
                component.set("v.searchCompanyData",response.getReturnValue());
            }else if(state=="ERROR"){
                var errors  = response.getError();
                console.error(errors);
            }
            
        }));
       $A.enqueueAction(action1); 
    },
    
    hideSearchCompanyComp : function(component,event,helper){
        var modal = component.find("Modalbox");
        $A.util.removeClass(modal,'hideModal');
    },
    
    createCompany : function(component,event,helper){
        var cname = component.get("v.searchCompany");
        var createCompanyRecordEvent =$A.get("e.force:createRecord");
        createCompanyRecordEvent.setParams({
            "entityApiName":"Account",
            "defaultFieldValues":{
                'Name' : cname
            }
        });
        createCompanyRecordEvent.fire();
   },
})