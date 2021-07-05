({
	myAction : function(component, event, helper) {
		
	},
    
    doInit: function(component,event,helper){
        helper.fetchOrigin(component,event,helper)
        helper.fetchSSL(component,event,helper)
        helper.fetchAssignmentName(component,event,helper)
    },
    
    
    
    openSearchPopup: function(component,event,helper){
        component.set("v.openSearchPopup",true);
    },
    
    handleNewCanEvent : function(component,event,helper){
        var recId = event.getParam("peopleId");
        var recName = event.getParam("peopleName");
        
        component.set("v.inputName",recName);
        component.set("v.peopleId",recId);
        
        var pId = component.get("v.peopleId");
        console.log(pId);
        
        console.log(recId);
        console.log(recName);
    },
    
    handleSave : function(component,event,helper){
        helper.helperSave(component,event,helper)
        //console.log(recId);
        //console.log(recName);
       //  component.set("v.displayNewRelAssign",false);
        helper.handleShowToast(component,event,helper)
        var appEvent = $A.get("e.c:newRelatedAssignmentEvent");
        appEvent.setParams({
            "displayNewRel" : false
        });
        appEvent.fire();
        
         
    },
    
    handleSaveandNew : function(component,event,helper){
        helper.helperSave(component,event,helper)
        helper.handleShowToast(component,event,helper)
        component.set("v.inputName","");
        component.set("v.OriginValue","--None--");
        component.set("v.SSLValue","--None--");
        component.set("v.Description","");
        
    },
    
    handleCancel : function(component,event,helper){
        var appEvent = $A.get("e.c:newRelatedAssignmentEvent");
        appEvent.setParams({
            "displayNewRel" : false
        });
        appEvent.fire();
    }
})