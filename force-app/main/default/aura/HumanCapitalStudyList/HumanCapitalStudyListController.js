({
	myAction : function(component, event, helper) {
		
	},
    
    doInit : function(component,event,helper){
     /*   var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef :"c:AssignmentCandidatesPageComp",
            componentAttributes:{
                c__mandateId : component.get("v.recordId")
            }
        });
        evt.fire();*/
    
    
    
    var pageReference={
             type: 'standard__component',
             attributes: {
                 componentName:'c__AssignmentCandidatesPageComp'
             },
             state:{
               //  "c__mandateId": "a010B00001cUIfJQAW"
                  "c__mandateId": component.get("v.recordId")
                   }    
         };        
         component.set("v.pageReference",pageReference);
        
         helper.navigateAssignment(component,event,helper);

    }  
})