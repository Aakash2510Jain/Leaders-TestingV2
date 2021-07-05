({
	helperMethod : function() {
		
	},
    
    searchPeopleRec :function(component,event,handler){
        
        //Show Spinner
        component.find("Id_Spinner").set("v.class",'slds-show');
        
        var action = component.get("c.fetchPeopleRec");
        action.setParams({
            'searchKeyWord':component.get("v.searchPeople")
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
              
       
    },
    createPeople : function(component,event,helper){
        debugger;
        var cname = component.get("v.searchPeople");
        var createCompanyRecordEvent =$A.get("e.force:createRecord");
        var firstName='';
        var lastName='';
        if(cname.includes(' ')){
            firstName = cname.split(' ')[0];
            lastName = cname.split(' ')[1];
        }else{
            firstName =cname;
        }
        createCompanyRecordEvent.setParams({
            "entityApiName":"Contact",
            "defaultFieldValues":{
                'FirstName' : firstName,
                'LastName' : lastName
            }
        });
        createCompanyRecordEvent.fire();
   },
    hideSearchCompanyComp : function(component,event,helper){
        var modal = component.find("Modalbox");
        $A.util.removeClass(modal,'hideModal');
    },
    hideSearchPeopleComp : function(component,event,helper){
       // var modal = component.find("Modalbox");
      //  $A.util.removeClass(modal,'hideModal');
        
        var cmpTarget = component.find('Modalbox');
		var cmpBack = component.find('Modalbackdrop');
		$A.util.removeClass(cmpBack,'slds-backdrop--open');
		$A.util.removeClass(cmpTarget, 'slds-fade-in-open'); 
       
    }

})