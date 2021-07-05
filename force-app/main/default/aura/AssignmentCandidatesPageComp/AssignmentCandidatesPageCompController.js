({
    selectPotential: function(component, event, helper) 
    {
        //debugger;
        var appEvent = $A.get("e.c:selectPotentialEvt");
        appEvent.setParams({ "actionType": "SELECT_POTENTIAL" });
        appEvent.fire();
        //helper.selectPotential(component,event,helper);
    },
    OnePagerAlert: function(component, event, helper) 
    {
        component.set("v.displayRadar", true);
    },
     generateSelfAss : function(component, event, helper) {
        debugger;
        
        var action = component.get("c.Generate_Self_Ass");
        action.setParams({
            "manid": component.get("v.mandateRecId")
        });
        action.setCallback(this, $A.getCallback(function(response) {
            var state = response.getState();
            var storeResponse = response.getReturnValue();
            
            if (state == "SUCCESS") {
                /*swal.fire({
                    title: "Success",
                    text: "Self Assesment Generated.",
                    type: "success",
                    timer: 3000,
                    showConfirmButton: false,    
                });*/
                alert('Success Pop-up In Devlopment Mode');
                
                //component.set("v.spinner",false);
                 
            }else{
                
            }
        } ));
        $A.enqueueAction(action);
    },
    
    doInit: function(component, event, helper) {
        var myPageRef = component.get("v.pageReference");
        console.log("the url is :" +myPageRef);
        var mandateId = myPageRef.state.c__mandateId;
        component.set("v.mandateRecId", mandateId);
        var mId = component.get("v.mandateRecId");
        console.log(mId);
        
        component.set("v.displayCandidateList", true);
        
        helper.fetchLangHelper(component, event, helper);
        
    },
    
    BackToMontreal  : function(component, event, helper) {
            var urlEvent = $A.get("e.force:navigateToURL");
            urlEvent.setParams({
                'url': 'https://leadersinternational--test.lightning.force.com/lightning/page/home'
            });
            urlEvent.fire();
    },
    
    CandidateList: function(component, event, helper)
    {
        
        component.set("v.PageType", "CandidateListPage");
        component.set("v.displayCandidateList", true);
        component.set("v.displayClientList", false);
        component.set("v.displaySourceList", false);
        component.set("v.displayRawList", false);
        component.set("v.displayNewRelAssign", false);
        component.set("v.ButtonClassForHCSL", 'forestGreen');
        component.set("v.ButtonClassRL", '');
        component.set("v.ButtonClassForSL", '');
        component.set("v.ButtonClassForCL", '');
    },
    
    RawList: function(component, event, helper)
    {
        component.set("v.PageType", "RawListPage");
        component.set("v.displayRawList", true);
        component.set("v.displayClientList", false);
        component.set("v.displaySourceList", false);
        component.set("v.displayCandidateList", false);
        component.set("v.displayNewRelAssign", false);
        component.set("v.ButtonClassRL", 'forestGreen');
        component.set("v.ButtonClassForHCSL", '');
        component.set("v.ButtonClassForSL", '');
        component.set("v.ButtonClassForCL", '');
        
    },
    
    SourceList: function(component, event, helper) {
        component.set("v.PageType", "SourceListPage")
        component.set("v.displaySourceList", true);
        component.set("v.displayClientList", false);
        component.set("v.displayRawList", false);
        component.set("v.displayCandidateList", false);
        component.set("v.ButtonClassForSL", 'forestGreen');
        component.set("v.ButtonClassRL", '');
        component.set("v.ButtonClassForHCSL", '');
        component.set("v.ButtonClassForCL", '');
        
    },
    
    ClientList: function(component, event, helper) {
        component.set("v.PageType", "ClientListPage");
        component.set("v.displayClientList", true);
        component.set("v.displayCandidateList", false);
        component.set("v.displaySourceList", false);
        component.set("v.displayRawList", false);
        component.set("v.displayNewRelAssign", false);
        component.set("v.ButtonClassForCL", 'forestGreen');
        component.set("v.ButtonClassRL", '');
        component.set("v.ButtonClassForSL", '');
        component.set("v.ButtonClassForHCSL", '');
    },
    CreateSelfAssesment: function(component, event, helper) {
        debugger;
        component.set("v.displaySelfAssesment", true);
        var abc = component.get("v.Self_Ass_Created");
        
        
        //component.get()
    },
     CreateOnePager: function(component, event, helper) {
        debugger;
        component.set("v.displayOnePager", true);
    },
      CreateAgenda: function(component, event, helper) {
        debugger;
        component.set("v.displayAgenda", true);
    },
       CreateExecSumm: function(component, event, helper) {
        debugger;
        component.set("v.displayExec_Summ", true);
    },
    addCandidate: function(component, event, helper) {
        //debugger;
        
        component.set("v.displayNewRelAssign", true);
        component.set("v.displayClientList", false);
        component.set("v.displayCandidateList", false);
        component.set("v.displaySourceList", false);
        component.set("v.displayRawList", false);
        
    },
    
    reInit: function(component, event, helper) {
        var myPageRef = component.get("v.pageReference");
        var mandateId = myPageRef.state.c__mandateId;
        component.set("v.mandateRecId", mandateId);
        var mId = component.get("v.mandateRecId");
        console.log(mId);
        component.set("v.PageType", "CandidateListPage");
        component.set("v.displayCandidateList", true);
        
    },
    
    handleNewRelAssignmentEvent: function(component, event, helper) {
        {
            var displayRel = event.getParam("displayNewRel");
            component.set("v.displayNewRelAssign", false);
            component.set("v.displayCandidateList", true);
        }
    },
    
    handleAssignmentDetails: function(component, event, helper) {
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": component.get("v.mandateRecId")
        });
        
        navEvt.fire();
    },
    
    handleLeadersReport: function(component, event, helper) {
        //debugger;
        console.log(component.get("v.selectedcandidateIds"));
        component.set("v.displayLeadersReportModal", true);
        component.set("v.spinner", true);
        
        var childComponent = component.find("LeadersComp");
        childComponent.passAllCandidateIds(component.get("v.selectedcandidateIds"));
        
    },
    handleScheduleInterview: function(component, event, helper) {
        debugger;
        var passRecordsList = [];
        var potCan = component.get("v.potentialCandidateIds");
        var canIds = component.get("v.selectedcandidateIds");
        var canMap = component.get("v.candidatesMap");
        canMap = JSON.parse(canMap);
        
        if( canIds.length == 0 && potCan.length == 0){
            swal.fire({
                title: "No Candidates Selected!",
                text: "No candidate selected. Please select at least one candidate to send emails.",
                type: "error",
                timer: 3000
            });

        }
        
        if (canIds.length == 0) {
            potCan.forEach(function(entry) {
                if (canMap.hasOwnProperty(entry)) {
                    canMap[entry].isSelected = true;
                    passRecordsList.push(canMap[entry]);
                }
            }) 
        }else{
                canIds.forEach(function(entry) {
                    if (canMap.hasOwnProperty(entry)) {
                        canMap[entry].isSelected = true;
                        passRecordsList.push(canMap[entry]);
                    }
                })
        };

        console.log(passRecordsList);
        component.set("v.candidateRecordList", passRecordsList);
        component.set("v.displaySchdIntr", true);
      },
    sendEmail: function(component, event, helper) {
        debugger;
        var canIds = component.get("v.selectedcandidateIds");
        if (canIds.length == 0) {
            
            swal.fire({
                title: "No Candidates Selected!",
                text: "No candidate selected. Please select at least one candidate to send emails.",
                type: "error",
                timer: 3000
            });
            return;
        }
        
        var canIds = component.get("v.selectedcandidateIds");
        var canMap = component.get("v.candidatesMap");
        var allEmails = [];
        var allCandidates = [];
        canMap = JSON.parse(canMap);
        canIds.forEach(function(entry) {
            allEmails.push(canMap[entry].Contact__r.Email);
            allCandidates.push(canMap[entry].Contact__r.Email);
        })
        console.log(allEmails);
        
        component.set("v.emailIdList", allEmails);
        component.set("v.displaySendEmail", true);
    },
    openChangeSSLModal: function(component, event, helper) {
        //debugger;
        //TODO:
        var passRecordsList = [];
        var canIds = component.get("v.selectedcandidateIds");
        if (canIds.length == 0) {
                swal.fire({
                        title: "No Candidates!",
                        text: "Please select Candidates to proceed!",
                        type: "error",
                        timer: 3000
                    });
            return;
        }
        var canMap = component.get("v.candidatesMap");
        canMap = JSON.parse(canMap);
        canIds.forEach(function(entry) {
            if (canMap.hasOwnProperty(entry)) {
                canMap[entry].isSelected = true;
                passRecordsList.push(canMap[entry]);
            }
        });
        console.log(passRecordsList);
        component.set("v.candidateRecordList", passRecordsList);
        component.set("v.displayChangeSSLOriginModal", true);
        
        
    },
    
    
    handleAssignmentCandidatesCompEvent: function(component, event, helper) {
        //alert('a');
        var canIds = event.getParam("candidateIds");
        component.set("v.selectedcandidateIds", canIds);
        
        var selCount = event.getParam("selectedCount");
        component.set("v.selectedCount", selCount);
        var test = component.get("v.selectedcandidateIds");
        console.log(test);
        
        var testc = component.get("v.selectedCount");
        console.log(testc);
    },
    
    openPop: function(component, event, helper) {
        var cmpTarget = component.find('pop');
        $A.util.addClass(cmpTarget, 'slds-show');
        $A.util.removeClass(cmpTarget, 'slds-hide');
    },
    
    closePop: function(component, event, helper) {
        var cmpTarget = component.find('pop');
        $A.util.addClass(cmpTarget, 'slds-hide');
        $A.util.removeClass(cmpTarget, 'slds-show');
    },
    addCandidateToOtherAsignment: function(component, event, helper) {
        var passRecordsList = [];
        var canIds = component.get("v.selectedcandidateIds");
        if (canIds.length == 0) {
              swal.fire({
                        title: "No Candidates!",
                        text: "Please select Candidates to proceed!",
                        type: "error",
                        timer: 3000
                    });
            return;
        }
        var canMap = component.get("v.candidatesMap");
        canMap = JSON.parse(canMap);
        canIds.forEach(function(entry) {
            if (canMap.hasOwnProperty(entry)) {
                canMap[entry].isSelected = true;
                passRecordsList.push(canMap[entry]);
            }
        });
        console.log(passRecordsList);
        component.set("v.candidateRecordList", passRecordsList);
        component.set("v.displayAddCandidateToOtherAssignment", true);
    },
    addCandidate: function(component, event, helper)
    {
        // component.set("v.displayNewCandidate", true);
        
        //window.open("https://leadersinternational--test.lightning.force.com/lightning/n/Search_Create");
        debugger;
        var sPageURL = decodeURIComponent(window.location.search.substring(1));
        var cururl = window.location.href.substring(1);
        var splitUrl = cururl.split('/');
        
        var updated_url= 'https://'+document.location.hostname + '/' +'lightning/n/Search_Create'+'?' +sPageURL ;
        
        
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({'url':updated_url
                           });
        urlEvent.fire();
        
        
    },
    deleteCandidates: function(component, event, helper) {
        debugger;
        var canIds = component.get("v.selectedcandidateIds");
        if (canIds.length == 0) {
                  swal.fire({
                        title: "No Candidates!",
                        text: "Please select Candidates to proceed!",
                        type: "error",
                        timer: 3000
                    });
        }else
        {
            component.set("v.showConfirmDialog", true);
            
        }
    },
    handleApplicationEvent : function(cmp, event) {
        var message = event.getParam("message");
        // alert('@@@ ==> ' + message);
        if(message == 'Ok')
        {
            var appEvent = $A.get("e.c:selectPotentialEvt");
            appEvent.setParams({ "actionType": "DELETE" });
            appEvent.fire();
            // if the user clicked the OK button do your further Action here
        }
        else if(message == 'Cancel')
        {
            // if the user clicked the Cancel button do your further Action here for canceling
        }
    },
    showNotesAndAttachment: function(component, event, helper) {
        component.set("v.showNotesAndAttachment",true);
    },
    uploadFile: function(component, event, helper) {
        component.set("v.showFileUpload",true);
        
    },handleConfirmDialog : function(component, event, helper) {
        component.set('v.showConfirmDialog', true);
    },
    
    handleConfirmDialogYes : function(component, event, helper)
    {
        var appEvent = $A.get("e.c:selectPotentialEvt");
        appEvent.setParams({ "actionType": "DELETE" });
        appEvent.fire();
        console.log('Yes');
        component.set('v.showConfirmDialog', false);
    },
    
    handlehover : function (component, event, helper){
      debugger;
     component.get("v.allPotCandidatesBySSL");
     component.get("v.allCandidatesBySSL");
     if(component.get("v.ShowToolTip") == false)
     {
      component.set('v.ShowToolTip', true);   
     }
        else{
            component.set('v.ShowToolTip', false);
        }
    },

    handleConfirmDialogNo : function(component, event, helper) {
        console.log('No');
        component.set('v.showConfirmDialog', false);
    },
    showtooltip : function(component, event, helper) {
        helper.toggleHelper(component, event);
    },
    
    hidetooltip : function(component, event, helper) {
        helper.toggleHelper(component, event);
    },
    closeToolTip:function(component, event, helper){
        component.set("v.ShowToolTip",false);
    }
})