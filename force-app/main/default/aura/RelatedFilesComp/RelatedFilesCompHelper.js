({
    
    getAllFilesForContact : function(component,event,helper)
    {
        debugger;
        var abc = component.get("v.allCandidateList") ;
        var action= component.get("c.getAttachmentsForContact");
        action.setParams({mandateId : component.get("v.mandateId"),
                          candateList: component.get("v.allCandidateList") 
                         });
        action.setCallback(this, function(actionResult) {
         component.set('v.attachments', actionResult.getReturnValue());
        });
        $A.enqueueAction(action);
            
    },
    getAllFiles : function(component,event,helper)
    {
        var action= component.get("c.getAttachments");
        action.setParams({mandateId : component.get("v.mandateId"),
                         });
        action.setCallback(this, function(actionResult) {
         component.set('v.attachments', actionResult.getReturnValue());
        });
        $A.enqueueAction(action);
            
    },
    editAttDetail : function(component, event, helper){
        debugger;
        /*var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
          "recordId": event.target.name,
          "slideDevName": "detail"
        });
        navEvt.fire();
        var editRecordEvent = $A.get("e.force:editRecord");
        editRecordEvent.setParams({
             "recordId": event.target.name
        });
        editRecordEvent.fire();*/

        debugger;
        var pageReference = {
            type: 'standard__recordPage',
            attributes: {
                recordId: event.target.name,
                actionName: 'edit'
            }
        };

        var navService = component.find("navService");
        event.preventDefault();
        navService.navigate(pageReference);
    
    },
    openAttDetail : function(component, event, helper){
        debugger;
        var pageReference = {
            type: 'standard__recordPage',
            attributes: {
                recordId: event.target.name,
                actionName: 'view'
            }
        };

        var navService = component.find("navService");
        event.preventDefault();
        navService.navigate(pageReference);
    
    },
    delAtt : function(component, event, helper){
        debugger;
        var action = component.get("c.deleteAttachment");
        var actionId = component.get("v.AttId");
        action.setParams({
            recId : actionId,
           
        });
        action.setCallback(this,function(response){
            var toastEvent = $A.get("e.force:showToast");
            if(response.getReturnValue() == true){
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "Records deleted successfully.",
                     "type": 'success'
                    
                });
                toastEvent.fire();
                var attachments = component.get("v.attachments");
                for( var i = 0; i < attachments.length; i++){ 
                   if (attachments[i].Id == actionId) {
                        attachments.splice(i, 1); 
                   }
                }
                component.set("v.attachments",attachments);
                component.set("v.deleteWarning",false);
                //s$A.get('e.force:refreshView').fire();
            }else{
                toastEvent.setParams({
                    "title": "Something went wrong!",
                    "message": "contact admin",
                     "type": 'error'
                });
                toastEvent.fire();
                component.set("v.deleteWarning",false);
            }
        })
        $A.enqueueAction(action);
    },
	closeModal : function(component, event) {
	   component.set("v.showThisModal",false); //TODO Boolean flag to close model	
	}
})