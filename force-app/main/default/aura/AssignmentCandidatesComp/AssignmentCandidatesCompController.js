({
    handleActionEvent: function(component, event, helper) {
        var eventType = event.getParam("actionType");
        if(eventType === "SELECT_POTENTIAL")
            helper.handleSelectPotentialEvt(component,event,helper);
        else if(eventType === "DELETE") 
            helper.deleteSelected(component,event,helper);
    },
    
    doInit: function(component, event, helper) {
        var mId = component.get("v.mandateRecId");
        console.log(mId);
        helper.canList(component, event, helper);
        
    },
    
    getVal: function(component, event, helper) {
        console.log("?");
        var mId = event.getParam("mandate_RecId");
        
    },
    generateSelfAss : function(component, event, helper) {
        
        component.set("v.spinner",true);
        var target = event.currentTarget.id;
        var canva = event.currentTarget.title;
        
        var action = component.get("c.Generate_Self_Ass");
        action.setParams({
            "appId": target
        });
        action.setCallback(this, $A.getCallback(function(response) {
            var state = response.getState();
            var storeResponse = response.getReturnValue();
            
            if (state == "SUCCESS") {
                swal.fire({
                    title: "Success",
                    text: "Self Assessment is being generated.",
                    type: "success",
                    timer: 3000,
                    showConfirmButton: false,    
                });
                
                component.set("v.spinner",false);
                
                //helper.BackToAppPage(canva, event, helper);   
                
                
            }else{}
        }
                                               ));
        $A.enqueueAction(action);
    },
    
    reInit: function(component, event, helper) {
        
        var mId = component.get("v.mandateRecId");
        console.log(mId);
        var ptype = component.get("v.PageType");
        console.log(ptype);
        
        helper.canList(component, event, helper);
    },
    
    deleteCandidate: function(component, event, helper) {
        var selectedItem = event.currentTarget;
        var recId = selectedItem.dataset.id;
        component.set("deleteCan", recId);
        
        helper.delCan(component, event, helper);
        
    },
    
    openNewLRN: function(component, event, helper) {
        component.set("v.openEditLRNComp", false);
        component.set("v.openLRNComp", true);
        debugger;
        var canId = event.getSource().get("v.value");
        console.log(canId);
        component.set("v.canId", canId);
        
        var LRNEvent = $A.get("e.c:NewLRNCompEvent");
        LRNEvent.setParams({
            "candidateId": canId
        });
        LRNEvent.fire();
        
        var childComponent = component.find("newLRN");
        childComponent.callChildInit(component.get("v.canId"));
        
    },
    openEditNewLRN: function(component, event, helper) {
        debugger;
        component.set("v.openLRNComp", false);
        component.set("v.openEditLRNComp", true);
        var canId = event.getSource().get("v.value");
        console.log(canId);
        component.set("v.canId", canId);
        
        var LRNEvent = $A.get("e.c:NewLRNCompEvent");
        LRNEvent.setParams({
            "candidateId": canId
        });
        LRNEvent.fire();
        
        var childComponent = component.find("editLRN");
        childComponent.callChildInit(component.get("v.canId"));
        
        console.log(" In the openEditNewLRN")
    },

    selectAllCB: function(component, event, helper) {
        var selectedHeaderCheck = event.getSource().get("v.value");
        
        var getAllId = component.find("boxPack");
        
        if (!Array.isArray(getAllId)) {
            if (selectedHeaderCheck == true) {
                component.find("boxPack").set("v.value", true);
                component.set("v.selectedCount", 1);
            } else {
                component.find("boxPack").set("v.value", false);
                component.set("v.selectedCount", 0);
            }
        } else {
            if (selectedHeaderCheck == true) {
                for (var i = 0; i < getAllId.length; i++) {
                    component.find("boxPack")[i].set("v.value", true);
                    component.set("v.selectedCount", getAllId.length);
                }
            } else {
                for (var i = 0; i < getAllId.length; i++) {
                    component.find("boxPack")[i].set("v.value", false);
                    component.set("v.selectedCount", 0);
                }
            }
        }
        
        helper.getselectedId(component, event, helper);
        
        var myEvent = $A.get("e.c:AssignmentCandidatesCompEvent");
        myEvent.setParams({
            "candidateIds": component.get("v.selectedIds"),
            "selectedCount": component.get("v.selectedCount")
        });
        
        myEvent.fire();
        
        var selectedCanNum = component.get("v.selectedCount");
        console.log(selectedCanNum);
        
    },
    
    selectCB: function(component, event, helper) {
        debugger;
        var selectedRec = event.getSource().get("v.value");
        var getSelectedNumber = component.get("v.selectedCount");
        
        if (selectedRec == true) {
            getSelectedNumber++;
        } else {
            getSelectedNumber--;
        }
        component.set("v.selectedCount", getSelectedNumber);
        helper.getselectedId(component, event, helper);
        
        var myEvent = $A.get("e.c:AssignmentCandidatesCompEvent");
        myEvent.setParams({
            "candidateIds": component.get("v.selectedIds"),
            "selectedCount": component.get("v.selectedCount")
        });
        
        myEvent.fire();
        
        
        var selectedCanNum = component.get("v.selectedCount");
        console.log(selectedCanNum);
        
    },
    
    openOP: function(component, event, helper) {
        debugger;
        
        var appId = event.currentTarget.title;
        component.set("v.applicationId", appId);
        
        var selectedopId = event.currentTarget.dataset.onepagerid;
        component.set("v.selectedOPId", selectedopId)
        
        var selectedbioId = event.currentTarget.dataset.bioid;
        component.set("v.selectedBioId", selectedbioId);
        
        var selectedContactId = event.currentTarget.dataset.canid;
        component.set("v.selectedConId", selectedContactId);
        
        var conId = component.get("v.selectedConId");
        component.set("v.displayCVComp", true);
        
    },
     openBIO: function(component, event, helper) {
        debugger;
         
         var selectedContactId = event.currentTarget.dataset.canid;
         component.set("v.selectedConId", selectedContactId);
         var target = event.currentTarget.id
         component.set("v.selectedCVId", target);
         var selectedbioId = event.currentTarget.dataset.bioid;
         component.set("v.selectedBioId", selectedbioId);
        
         
        component.set("v.displayBiography", true);
        
    },
     openCV: function(component, event, helper) {
        debugger;
         
         var target = event.currentTarget.id
         component.set("v.selectedCVId", target);
         
         component.set("v.displayCV", true);
     },
    openPSY: function(component, event, helper) {
        debugger;
        
        var target = event.currentTarget.id
        component.set("v.selectedPSYId", target);
        component.set("v.displayPSY", true);
    },
    
    showNotesAndAttachment: function(component, event, helper) {
        component.set("v.showNotesAndAttachment",true);
    },
    
    closePop: function(component, event, helper) {
        var cmpTarget = component.find('pop');
        $A.util.addClass(cmpTarget, 'slds-hide');
        $A.util.removeClass(cmpTarget, 'slds-show');
    },
    sortByName: function(component, event, helper) {
        helper.sortBy(component, event.currentTarget.getAttribute('data-sortAttType'), true);
    },
    showSpinner: function(component, event, helper) {
        helper.showSpinnerHelper(component);
    },
    hideSpinner: function(component, event, helper) {
        helper.hideSpinnerHelper(component);
    },
    renderPage: function(component, event, helper) {
        helper.renderPage(component);
    },
    openViewAssessment: function(component, event, helper) {
        debugger;
        var target = event.currentTarget.title;
        component.set("v.selectedConId",target);
        var action = component.get("c.get_Attach_id");
        action.setParams({
            "recordId": target,
            "mandateId":component.get("v.mandateRecId")
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            var storeResponse = response.getReturnValue();
            
            if (state == "SUCCESS") {
                if(storeResponse != undefined && storeResponse.length >0){
                    if(storeResponse[0].Attachments != undefined && storeResponse[0].Attachments.length >0)
                    component.set("v.attachmentId",storeResponse[0].Attachments[0].Id);
                    component.set("v.displaySA",true);
                    component.set("v.spinner",false);
                }
                
                
            }
        });
        $A.enqueueAction(action);
    },
    openOnePager: function(component, event, helper) {
        debugger;
        var target = event.currentTarget.title;
        
        var action = component.get("c.get_Attach_id_OnePager");
        action.setParams({
            "recordId": target,
            "mandateId":component.get("v.mandateRecId")
        });
        
        action.setCallback(this, $A.getCallback(function(response) {
            var state = response.getState();
            var storeResponse = response.getReturnValue();
            
            if (state == "SUCCESS") {
                if(storeResponse[0].Attachments != null || storeResponse[0].Attachments != undefined ){
                    component.set("v.attachmentId",storeResponse[0].Attachments[0].Id);
                }
                component.set("v.displayOP",true);
                component.set("v.spinner",false);
                
            }else{}
        }
      ));
        $A.enqueueAction(action);
    },
    
    
})