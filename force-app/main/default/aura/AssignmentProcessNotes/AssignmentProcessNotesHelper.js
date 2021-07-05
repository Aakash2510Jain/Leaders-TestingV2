({
    fetchDataHelper: function(component,event,helper){
        
        var myPageRef = component.get("v.pageReference");
        
        var mandateId = myPageRef.state.c__mandateId;
        var teamName = myPageRef.state.c__teamName;
        component.set("v.mandateId", mandateId);
        component.set("v.teamName", 'Back to '+teamName+' Review');
        
        debugger;
        
        var action = component.get("c.fetchNotes");
        action.setParams({
            recId : component.get("v.mandateId")
        });
        action.setCallback(this,function(response){
            var result = response.getReturnValue();
            debugger;
            if(response.getState() === "SUCCESS"){
                {
                    component.set("v.Ass_notes",result);
                    console.log('Result==>'+result);
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    getvalueofstatusandmoduleHelper : function(component,event,helper){
        
        debugger;
        
        var myPageRef = component.get("v.pageReference");
        var mandateId = myPageRef.state.c__mandateId;
        component.set("v.mandateId", mandateId);
        
        debugger;
        
        var action = component.get("c.getingvalues");
        
        action.setParams({
            Recid : component.get("v.mandateId"),
        });
        
        
        action.setCallback(this,function(response){
            var result = response.getReturnValue();
            console.log('Result'+result[0].Assignment_Status__c);
            console.log('Result'+result[0].Module__c);
            console.log('Result'+result[0]);
            debugger;
            if(response.getState() === "SUCCESS"){
                {
                    component.set("v.SelectedStatus",result[0].Assignment_Status__c);
                    component.set("v.SelectedModule",result[0].Module__c);
                    component.set("v.AssignmentName",result[0].Name);
                    
                    if(result[0].Company__r != null && result[0].Company__r != 'undefined')
                    {
                        component.set("v.CompanyName",result[0].Company__r.Name);
                    }
                }
            }
        });
        $A.enqueueAction(action);
    },
    getValueOfmodule : function(component,event,helper){
        
        debugger;
        
        var action = component.get("c.getValueOfModule");
        
        action.setCallback(this,function(response){
            var result = response.getReturnValue();
            debugger;
            if(response.getState() === "SUCCESS"){
                {
                    component.set("v.StatusValues",result);
                    console.log('Result==>'+result);
                }
            }
        });
        $A.enqueueAction(action);
    },
    getValueOfStatus : function(component,event,helper){
        
        debugger;
        
        var action = component.get("c.getValueOfStatus");
        
        action.setCallback(this,function(response){
            var result = response.getReturnValue();
            debugger;
            if(response.getState() === "SUCCESS"){
                {
                    component.set("v.StatusValues",result);
                    console.log('Result==>'+result);
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    
    helperFun : function(component,event,secId) {
        var acc = component.find(secId);
        for(var cmp in acc) {
            $A.util.toggleClass(acc[cmp], 'slds-show');  
            $A.util.toggleClass(acc[cmp], 'slds-hide');  
        }
    },
    
    updatemodulehelper : function(component,event,helper){
        
        var myPageRef = component.get("v.pageReference");
        var mandateId = myPageRef.state.c__mandateId;
        component.set("v.mandateId", mandateId);
        
        debugger;
        console.log('Status'+component.get("v.SelectedModule"));
        
        var action = component.get("c.updateModulevalue");
        
        action.setParams({
            Recid : component.get("v.mandateId"),
            Module : component.get("v.SelectedModule")
        });
        
        
        
        action.setCallback(this,function(response){
            var result = response.getReturnValue();
            debugger;
            if(response.getState() === "SUCCESS")
            {
                component.set("v.displayChangeModule", false);
                
                swal.fire({
                    title: "Updated!",
                    text: "Module has been Updated.",
                    type: "success",
                    showConfirmButton: false,
                    timer: 3000
                });
            }
            else{
                swal.fire({
                    title: "Error!",
                    text: "Module has Not been Updated.",
                    type: "error",
                    showConfirmButton: false,
                    timer: 3000
                });
            }
        });
        $A.enqueueAction(action);
    },
    
    updatestatushelper : function(component,event,helper){
        
        var myPageRef = component.get("v.pageReference");
        var mandateId = myPageRef.state.c__mandateId;
        component.set("v.mandateId", mandateId);
        
        debugger;
        console.log('Status'+component.get("v.SelectedStatus"));
        
        var action = component.get("c.updatestatusvalue");
        
        action.setParams({
            Recid : component.get("v.mandateId"),
            status : component.get("v.SelectedStatus")
        });
        
        
        action.setCallback(this,function(response){
            var result = response.getReturnValue();
            debugger;
            if(response.getState() === "SUCCESS"){
                
                component.set("v.displayChangeStatus", false);
                
                
                swal.fire({
                    title: "Updated!",
                    text: "Status has been Updated.",
                    type: "success",
                    showConfirmButton: false,
                    timer: 3000
                });
                
            }
            else{
                swal.fire({
                    title: "Error!",
                    text: "Status has Not been Updated.",
                    type: "error",
                    showConfirmButton: false,
                    timer: 3000
                });
            }
            
        });
        $A.enqueueAction(action);
    },
    updateFieldHelper: function(component,event,helper)
    {
        var myPageRef = component.get("v.pageReference");
        
        var mandateId = myPageRef.state.c__mandateId;
        
        component.set("v.mandateId", mandateId);
        
        debugger;
        console.log('Ass_notes'+component.get("v.Ass_notes"));
        var action = component.get("c.updateNotes");
        action.setParams({
            assignmentNoteRec : component.get("v.Ass_notes")
        });
        action.setCallback(this,function(response){
            var result = response.getReturnValue();
            debugger;
            if(response.getState() === "SUCCESS"){
                
                swal.fire({
                    title: "Success!",
                    text: "The record has been updated successfully.",
                    type: "success",
                    showConfirmButton: false,
                    timer: 3000
                });
                
                //window.history.back();
                localStorage.setItem("Action", "review");
                window.location ='/lightning/page/home';
            }else{
                localStorage.setItem("Action", "review");
                window.location ='/lightning/page/home';
            }
            
        });
        $A.enqueueAction(action);
    }
})