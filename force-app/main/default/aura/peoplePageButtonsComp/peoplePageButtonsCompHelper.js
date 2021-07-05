({
    getContactInfo : function(component,event,helper) {
        debugger;
        component.set("v.checkSpinner",true);
        var action = component.get("c.getApplicationDetails");
        action.setParams({
            recId : component.get("v.recordId")
        });
        action.setCallback(this,function(response){
            var result = response.getReturnValue();
            debugger;
            if(response.getState() === "SUCCESS"){
                component.set("v.checkSpinner",false);
                if(result.length >0){
                    component.set("v.mandateId",result[0].manId);
                    var allEmails = [];
                    allEmails.push(result[0].Email);
                    component.set("v.emailId",result[0].Email);
                    var appList = []; 
                    var allCandidateList = [];
                    allCandidateList.push(result[0].canId);
                    appList.push(result[0].aapId);
                    component.set("v.allCandidateList",allCandidateList);
                }
                
            }
        });
        
        $A.enqueueAction(action);
    },
    getAppInfo : function(component,event,helper) {
        debugger;
        component.set("v.checkSpinner",true);
        var action = component.get("c.getAppDetails");
        action.setParams({
            recId : component.get("v.recordId")
        });
        action.setCallback(this,function(response){
            var result = response.getReturnValue();
            debugger;
            if(response.getState() === "SUCCESS"){
                component.set("v.checkSpinner",false);
                if(result.length >0){
                    component.set("v.allAppList",result);
                }
                
            }
        });
        
        $A.enqueueAction(action);
    },
    sendAssessmentLinkHelper: function(component,event,helper) {
        debugger;
        var action =component.get("c.sendSelfAssessmentLink");
        action.setParams({
            recordId: component.get("v.recordId")
        });
        
        action.setCallback(this,function(response){
            var result = response.getReturnValue();
            debugger;
            if(response.getState() === "SUCCESS"){
                //alert(result);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "type":"success",
                    "message": "Assessment link has been sent to candidate successfully."
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    },
    createOnePagerOrBioHelper: function(component,event,helper) {
        
        debugger;
        console.log('method called');
        var action_type = '';
        var message ='';
        var docType='';
        var language ='english';
        
        action_type = event.getSource().get("v.label");
        this.showLoaderHelper(component,event,helper);
        
        
        if(action_type =='Create One Pager'){
            docType = 'ONE_PAGER';
            message = 'One Pager has been Created';
        }else if(action_type =='Create Bio'){
            docType = 'BIO';
            message = 'Bio has been Created';
        }else if(action_type =='View Long Assessment'){
            docType = 'LONGFORM';
            message = 'Long Form has been Created';
        }
        var action = component.get("c.createOnePagerOrBioDocs");
        action.setParams({
            conId : component.get("v.recordId"),
            docType : docType,
            language : language
        });
        action.setCallback(this,function(response){
            
            var result = response.getReturnValue();
            debugger;
            console.log('response came');
            if(response.getState() === "SUCCESS"){
                if(result != null && result != ''){
                    this.hideLoaderHelper(component,event,helper);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success",
                        "message": message,
                        "type": 'success'
                    });
                    
                    toastEvent.fire();
                    window.location.reload();
                    
                }else{
                    this.hideLoaderHelper(component,event,helper);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error",
                        "message": "Some error occurred",
                        "type": 'warning'
                    });
                    
                    toastEvent.fire();
                }
            }
        });
        console.log('method end');
        $A.enqueueAction(action);
        
    },
    
    deletePeopleRecord : function(component,event,helper){
        
        console.log("In delete people record helper method");
        var action =component.get("c.deleteContact");
        action.setParams({recId: "{!v.recordId}"});
        
        action.setCallback(this,function(response){
            
        }
                          );
        $A.enqueueAction(action);
    },
    
    navigateTo: function(component, event,helper){
        var navEvt = $A.get("e.force:navigateToURL");
        navEvt.setParams({
            "url":"/lightning/o/Contact/list?filterName=Recent"
        });
        navEvt.fire();
    },
    openAttachmentHelper : function(component,event,buttonLabel)
    {
        debugger;
        console.log('buttonLabel::: ' + buttonLabel);
        var action = component.get("c.viewAttachment");
        action.setParams({
            parentId : component.get("v.recordId"),
            type : buttonLabel
        });
        action.setCallback(this,function(response){
            var result = response.getReturnValue();
            debugger;
            
            if(response.getState() === "SUCCESS"){
                component.set("v.attachmentId",result);
                component.set("v.displayCV",true);
            }
            else{
                var toastEvent = $A.get("e.force:showToast");
                if(buttonLabel == "View Bio"){
                    toastEvent.setParams({
                        "title": "NO Bio",
                        "message": "No Bio found",
                        "type": 'info'
                    });
                }
                else{
                    toastEvent.setParams({
                        "title": "NO ONE PAGER",
                        "message": "No One Pager found",
                        "type": 'info'
                    });
                }
                toastEvent.fire();
            }
        });
        
        $A.enqueueAction(action);
        
    },
    ChecktemplatesHelper : function(component,event,buttonLabel)
    {
        debugger;
        console.log('buttonLabel::: ' + buttonLabel);
        var action = component.get("c.viewAttachment");
        action.setParams({
            parentId : component.get("v.recordId"),
            type : buttonLabel
        });
        action.setCallback(this,function(response){
            var result = response.getReturnValue();
            debugger;
            
            if(response.getState() === "SUCCESS"){
                component.set("v.attachmentId",result);
                component.set("v.displayCV",true);
            }
            else{
                var toastEvent = $A.get("e.force:showToast");
                if(buttonLabel == "View Bio"){
                    toastEvent.setParams({
                        "title": "NO Bio",
                        "message": "No Bio found",
                        "type": 'info'
                    });
                }
                else{
                    toastEvent.setParams({
                        "title": "NO ONE PAGER",
                        "message": "No One Pager found",
                        "type": 'info'
                    });
                }
                toastEvent.fire();
            }
        });
        
        $A.enqueueAction(action);
        
    },
    
    showLoaderHelper: function(component, event, helper) {
        component.set("v.loader", true);
    },
    hideLoaderHelper : function(component,event,helper){
        component.set("v.loader", false);
    }
    
})