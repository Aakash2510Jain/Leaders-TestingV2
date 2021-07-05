({
    doInit: function(component, event, helper) {
        helper.getRelatedAssignments(component,event,helper);
    },
    
    openNewLRN : function(component,event,helper){
        component.set("v.openEditLRNComp",false);
        component.set("v.openLRNComp",true);
        debugger;
        var canId = event.getSource().get("v.value");
        console.log(canId);
        component.set("v.canId",canId);
        var LRNEvent = $A.get("e.c:NewLRNCompEvent");
        LRNEvent.setParams({
            "contactCandidateId" : canId
        });
        LRNEvent.fire();
        
        var childComponent = component.find("newLRN");
        childComponent.callChildInit(component.get("v.canId"));
        
    },
    
    openEditNewLRN : function(component,event,helper){
        debugger;
        component.set("v.openLRNComp",false);
        component.set("v.openEditLRNComp",true);
        var canId = event.getSource().get("v.value");
        console.log(canId);
        component.set("v.canId",canId);
        
        var LRNEvent = $A.get("e.c:NewLRNCompEvent");
        LRNEvent.setParams({
            "contactCandidateId" : canId
        });
        LRNEvent.fire();
        
        var childComponent = component.find("editLRN");
        childComponent.callChildInit(component.get("v.canId"));
        
        
        console.log(" In the openEditNewLRN")
    },
    handleClick: function(component,event,helper){
        var selectedItem = event.currentTarget
        var recId = selectedItem.dataset.record;
        console.log(recId);
        
        var pageReference={
            type: 'standard__component',
            attributes: {
                componentName:'c__AssignmentCandidatesPageComp'
            },
            state:{
                //  "c__mandateId": "a010B00001cUIfJQAW"
                "c__mandateId": recId
            }    
        };        
        component.set("v.pageReference",pageReference);
        
        //helper.navigateAssignment(component,event,helper);
        
        var navService = component.find("navService");
        var pageReference = component.get("v.pageReference");
        event.preventDefault();
        navService.navigate(pageReference);
    },
    DisplayCV:function(component,event,helper){
        debugger;
        var canId = event.getSource().get("v.value");
        
        var action = component.get("c.getAttId");
        action.setParams({
            canId : canId,
        });
        
        action.setCallback(this,function(response){
            var result = response.getReturnValue();
            debugger;
            if(response.getState() == "SUCCESS"){
                if(result!=null){
                    component.set("v.attachmentId",result);
                    component.set("v.isOpen",false);
                    component.set("v.displayCV",true);
                }else{
                    component.set("v.displayCV",false);
					swal.fire({
                    title: "Error!",
                    text: "No Attachment Found",
                    type: "success",
                    timer: 3000
                });                    
                }
            }
        })                
        $A.enqueueAction(action);
    }
})