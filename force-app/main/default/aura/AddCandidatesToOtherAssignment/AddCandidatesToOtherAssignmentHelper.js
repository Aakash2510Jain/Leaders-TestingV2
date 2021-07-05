/**
 * Created by ET-MARLABS on 06-03-2019.
 */
({
    getAllRecordsHelper : function(component,event,helper){
        var action = component.get("c.getCandidateDummyData");
        
        /*action.setParams({
          "assignmentId":''
        });*/
        action.setCallback(this, $A.getCallback(function(response){
            var state= response.getState();
            var storeResponse = response.getReturnValue();
            
            if(state=="SUCCESS"){
                
                /*for(var i=0; i<response.getReturnValue().length; i++){

              }*/
                
                component.set("v.recordList",storeResponse);
            }else if (state=="ERROR"){
                var errors = response.getError();
            }
            var num= component.get("v.TotalNumberOfRecord");  
        }));
        $A.enqueueAction(action);
    },
    
    handleSelectAllContactHelper : function(component,event,helper){
        debugger;
        component.set("v.showSpinner", true);
        var copyNotes = component.get("v.copyNotes");
        var allApp = component.get("v.recordList");
        console.log(allApp);
        var action = component.get("c.saveAppData");
        
        action.setParams({
            "appListString":JSON.stringify(allApp),
            "mandateId":component.get("v.selectedRecord").Id,
            "status":component.get("v.selectedSSLValue"),
            "copyNotes":copyNotes,
            "AppIds":allApp
        });
        action.setCallback(this,function(response){
            var state= response.getState();
            var storeResponse = response.getReturnValue();
            console.log(storeResponse);
            var toastEvent = $A.get("e.force:showToast");
            if(state=="SUCCESS"){
                
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "Total number of candidates transferred: "+response.getReturnValue().SUCCESS+" \n Total number of existing candidates: "+response.getReturnValue().EXISTING,
                    "type": 'success'
                });
                toastEvent.fire();
                component.set("v.displayAddCandidateToOtherAssignment",false);
                component.set("v.showSpinner", false);
                //if(response.getReturnValue().EXISTING )
                //$A.get('e.force:refreshView').fire();
                
                // component.set("v.recordList",storeResponse);
            }else if (state=="ERROR"){
                var errors = response.getError();
                toastEvent.setParams({
                    "title": "Error!",
                    "message": errors,
                    "type": 'info'
                });
                toastEvent.fire();
                component.set("v.showSpinner", false);
            }
            
            //var num= component.get("v.TotalNumberOfRecord");
            
            
        });
        $A.enqueueAction(action);
    },
    saveCandidate:function(component,event,helper){
        var action = component.get("c.createCandidateRecForContact");
        action.setParams({
            assignmentId : component.get("v.selectedRecord").Id,
            contactID : component.get("v.contactRecId"),
            ssl:component.get("v.selectedSSLValue"),
            description:component.get("v.description"),
            origin:component.get("v.selectedOriginValue")
        });
        
        action.setCallback(this,function(response){
            debugger;
            var state= response.getState();
            var list = response.getReturnValue();
            
            if(state=="SUCCESS"){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "Candidate has been created",
                    "type": 'success'
                });
                toastEvent.fire();
                component.set("v.displayAddCandidateToOtherAssignment",false);
                component.set("v.ShowCandidate",false);
                component.set("v.showSpinner", false);
                
            }else{
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": response.getError()[0].message,
                    "type": 'error'
                });
                toastEvent.fire();
                component.set("v.displayAddCandidateToOtherAssignment",false);
                component.set("v.ShowCandidate",false);
                component.set("v.showSpinner", false);
            }
            
        })
        $A.enqueueAction(action);
        
    },
    
    selectAllHelper: function(component,event,helper){
        var allApp = component.get("v.recordList");
        var valuetoset = component.get("v.isSelectAll");
        for(var i=0;i<allApp.length;i++){
            allApp[i].isSelected=valuetoset;
        }
        component.set("v.recordList",allApp);
        console.log(allApp);
        
    },
    handleComponentEventHelper : function(component,event,getInputkeyWord) {
        var selectedAccountGetFromEvent = event.getParam("accountByEvent");
        component.set("v.selectedRecord" , selectedAccountGetFromEvent);
        debugger;
    },
    fetchPickValHelper: function(component,event,getInputkeyWord,ojName,fieldname,param) {
        
        var action = component.get("c.getPicklistValues");
        action.setParams({
            objectType : ojName,
            selectedField : fieldname
        });
        
        action.setCallback(this,function(response){
            var list = response.getReturnValue();
            component.set(param,list);
            
        })
        $A.enqueueAction(action);
        
        
    },
    
    
    searchAssignment : function(component,event){
        debugger;
        component.find("AsignmentTable").fetchAssignment(component.get("v.selectedRecord.Name"));

        //component.find("dtcContact").go(component.get("v.selectedRecord.Name"));
    },
    doneEventHandler : function(component,event){
        debugger;
        
        component.set("v.showAssignmentForm",false);
    },
    showToastMessage : function(title,message)
    {
        var toastEvent = $A.get("e.force:showToast");  
        toastEvent.setParams({  
            "title": title,  
            "message": message  
        });
        toastEvent.fire();
    },
    changeSelectedRecordHandler:function(component,event){
        component.set("v.selectedRecord.Id",undefined);
        component.set("v.showAssignmentForm",true);
    }
    
})