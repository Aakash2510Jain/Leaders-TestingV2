({
    canList: function(component, event, helper) {
        // action = component.get("c.fetchCandidatesList");
        //  var mId = component.get("v.mandateId");
        //   console.log(mId);
        
        component.set("v.spinner",true);
        debugger;
        var action = component.get("c.fetchCandidatesList");
        action.setParams({
            "AssignId": component.get("v.mandateRecId"),
            "PageType": component.get("v.PageType")
        });
        //  console.log(AssignId);   
        action.setCallback(this, $A.getCallback(function(response) {
            var state = response.getState();
            var storeResponse = response.getReturnValue();
            
            if (state == "SUCCESS") {
                //  var res = JSON.parse(storeResponse);
                var respMap = response.getReturnValue();
                
                component.set("v.candidates", respMap.resultList);
                component.set("v.InternalLength", respMap.mandate.Leaders_interviews__c);
                component.set("v.ClientLength", respMap.mandate.Client_interviews__c);
                component.set("v.candidateLength", respMap.resultList.length);
                component.set("v.maxPage", Math.floor((respMap.resultList.length + 749) / 750));
                
                component.set("v.mandateRec", respMap.mandate);
                
                var potCandidates = [];
                var potentialCandidates = [];
                var nonPotentialCandidates = [];
                var candidatesMap = {};
                var resultList = response.getReturnValue().resultList;
                var allCandidatesBySSL =  [];
                var TotalCandidate = resultList.length;
                var allPotCandidatesBySSL =  [];
                
                for(var i=0;i<resultList.length;i++){
                    if(allCandidatesBySSL.length > 0  ){
                        var temp = false;
                        for(var j=0;j<allCandidatesBySSL.length;j++){
                            if(resultList[i].candidate.Status_Summary_Line__c == allCandidatesBySSL[j].SSLname && resultList[i].candidate.InternalTopStatus__c == false){
                                allCandidatesBySSL[j].Count = allCandidatesBySSL[j].Count+1 ;
                                temp = true;
                            }
                        }
                        if(temp == false){
                            if(resultList[i].candidate.InternalTopStatus__c == false){
                                allCandidatesBySSL.push({'SSLname':resultList[i].candidate.Status_Summary_Line__c,'Count':1});
                            }
                        }
                    }else{
                        if(resultList[i].candidate.InternalTopStatus__c == false){
                            allCandidatesBySSL.push({'SSLname':resultList[i].candidate.Status_Summary_Line__c,'Count':1});
                        }
                    }  
                    
                }
                console.log('allCandidatesBySSL'+allCandidatesBySSL);
               var sortedCandidatesBySSL = [];
                sortedCandidatesBySSL = allCandidatesBySSL;
                sortedCandidatesBySSL.sort(function(a, b) {
                    return b["Count"] - a["Count"];
                });
                
                for(var i=0;i<resultList.length;i++){
                    if(allPotCandidatesBySSL.length > 0  ){
                        var temp = false;
                        for(var j=0;j<allPotCandidatesBySSL.length;j++){
                            debugger;
                            if(resultList[i].candidate.Status_Summary_Line__c == allPotCandidatesBySSL[j].SSLname && resultList[i].candidate.InternalTopStatus__c == true){
                                allPotCandidatesBySSL[j].Count = allPotCandidatesBySSL[j].Count+1 ;
                                temp = true;
                            }
                        }
                        if(temp == false){
                            debugger;
                            if(resultList[i].candidate.InternalTopStatus__c == true){
                                allPotCandidatesBySSL.push({'SSLname':resultList[i].candidate.Status_Summary_Line__c,'Count':1});
                            }
                        }
                    }else{
                        if(resultList[i].candidate.InternalTopStatus__c == true){
                            allPotCandidatesBySSL.push({'SSLname':resultList[i].candidate.Status_Summary_Line__c,'Count':1});
                        }
                    }  
                }
                console.log('allPotCandidatesBySSL'+allPotCandidatesBySSL);
               
                var sortedPotCandidatesBySSL = [];
                sortedPotCandidatesBySSL = allPotCandidatesBySSL;
                sortedPotCandidatesBySSL.sort(function(a, b) {
                    return b["Count"] - a["Count"];
                });
               
                for (var i = 0; i < resultList.length; i++) {
                    
                    candidatesMap[resultList[i].candidate.Id] = resultList[i].candidate;
                    if (resultList[i].candidate.InternalTopStatus__c) {
                        potCandidates.push(resultList[i].candidate.Id);
                        potentialCandidates.push(resultList[i]);
                    }else{
                        nonPotentialCandidates.push(resultList[i]);
                    }
                }
                
                component.set("v.allCandidatesBySSL",sortedCandidatesBySSL);
                component.set("v.allPotCandidatesBySSL",sortedPotCandidatesBySSL);
                component.set("v.candidatesMap", JSON.stringify(candidatesMap));
                component.set("v.potentialCandidatesList",potentialCandidates);
                component.set("v.nonPotentialCandidatesList",nonPotentialCandidates);
                component.set("v.potentialCandidateIds", potCandidates);
                component.set("v.TotalNumberOfRecord", storeResponse.length);
                component.set("v.NumberOfCandidate", TotalCandidate);
               
                
                
                //this.renderPage(component,true);
                //var mandate = component.get("v.simpleRecord");
                var field = respMap.mandate.sortExpression__c;
                var sortOrder = respMap.mandate.sortDirection__c;
                if(field != undefined){
                    if(sortOrder == "ASC")
                    	component.set("v.sortAsc",true);
                	else
                    	component.set("v.sortAsc",false);
                }else{
                    field='LastName';
                    component.set("v.sortAsc",false);
                }
                
                component.set("v.sortField",field);
                this.sortBy(component, field, false);
            } else if (state == "ERROR") {
                var errors = response.getError();
                //  console.error(errors);
            }
            
            var num = component.get("v.TotalNumberOfRecord");
            component.set("v.spinner",false);
            //   console.log(num);
            
            
        }));
        $A.enqueueAction(action);
        
        
    },
     BackToAppPage  : function(canva, event, helper) {
            var urlEvent = $A.get("e.force:navigateToURL");
         
            var website = window.location.hostname;
            var cont_id = 
            urlEvent.setParams({
                
                'url': 'https://'+website+'/lightning/r/Contact/'+ +'/view'
                
            });
            urlEvent.fire();
     },
       selPCandidates: function(component, event, helper) {
        console.log(" In the selPCandidates");
        
        var action = component.get("c.selectPotentialCandidates");
        action.setParams({
            "rwList": component.get("v.candidates")
        });
        
        action.setCallback(this, $A.getCallback(function(response) {
            console.log(" In the setCallback");
            var state = response.getState();
            console.log(state);
            if (state == "SUCCESS") {
                component.set("v.candidates", response.getReturnValue());
                var ITS = component.get("v.candidates");
                console.log(ITS);
            }
        }));
        $A.enqueueAction(action);
        
        
    },
    
    selectPotCandidates: function(component, event, helper) {
        
        console.log("In selectPotCandidates");
        
        
        
        
        
        
        /*  var action = component.get("c.selectPotentialCandidates");
            action.setParams({
                "rwList" : component.get("v.candidates")
            });
            
    action.setCallback(this,$A.getCallback(function(response){
            system.log("In selectPotentialCandidates")
      var state= response.getState();
            if(state=="SUCCESS"){
                console.log(state);
                component.set("v.candidates",response.getReturnValue());
                
                var cans = component.get("v.candidates");
            console.log(cans);
            }else if(state =="ERROR"){
                var errors = response.getError();
                console.log(errors);
            }
    }));
        
        $A.enqueueAction(action);*/
    },
    
    delCan: function(component, event, helper) {
        var action = component.get("c.deleteCandidate");
        action.setParams({
            "recId2Del": component.get("deleteCan")
        })
        
        action.setCallback(this, $A.getCallback(function(response) {
            
            var state = response.getState();
            var storeResponse = response.getReturnValue();
        }))
    },
    
    deleteSelectedHelper: function(component, event, deleteRecordsIds) {
        
        var action = component.get('c.deleteRecords');
        
        action.setParams({
            "lstRecordId": deleteRecordsIds
        });
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            if (state === "SUCCESS") {
                
                if (response.getReturnValue() != '') {
                    
                    alert('The following error has occurred. while Delete record-->' + response.getReturnValue());
                } else {
                    console.log('check it--> delete successful');
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    deleteToast: function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "message": "The candidate has been deleted successfully.",
            "type": 'success'
        });
        toastEvent.fire();
    },
    
    
    getselectedId: function(component, event, helper) {
        // create var for store record id's for selected checkboxes  
        var selId = [];
        // get all checkboxes 
        var getAllId = component.find("boxPack");
        
        if (!Array.isArray(getAllId)) {
            if (getAllId.get("v.value") == true) {
                selId.push(getAllId.get("v.text"));
            }
        } else {
            // play a for loop and check every checkbox values 
            // if value is checked(true) then add those Id (store in Text attribute on checkbox) in delId var.
            for (var i = 0; i < getAllId.length; i++) {
                if (getAllId[i].get("v.value") == true) {
                    selId.push(getAllId[i].get("v.text"));
                }
            }
        }
        
        component.set("v.selectedIds", selId);
        var ids = component.get("v.selectedIds");
        console.log(ids);
    },
    sortBy: function(component, field, cacheSort) {
        debugger;
        var finalRecordsList = component.get("v.potentialCandidatesList");
        
        
        var sortAsc = component.get("v.sortAsc"),
            sortField = component.get("v.sortField"),
            records = component.get("v.nonPotentialCandidatesList");
        
        sortAsc = sortField != field || !sortAsc;
        //debugger;
        //Specific sort functionality
        if (field == 'Origin__c' || field == 'Location_City__c' || field == 'Status_Summary_Line__c' || field == 'Current_Company_EN__c' || field == 'Current_Title__c' || field == 'LastModifiedDate') {
            records.sort(function(a, b) {
                var t1 = a.candidate[field] == b.candidate[field],
                    t2 = (!a.candidate[field] && b.candidate[field]) || (a.candidate[field] < b.candidate[field]);
                return t1 ? 0 : (sortAsc ? -1 : 1) * (t2 ? 1 : -1);
            });
            finalRecordsList.sort(function(a, b) {
                var t1 = a.candidate[field] == b.candidate[field],
                    t2 = (!a.candidate[field] && b.candidate[field]) || (a.candidate[field] < b.candidate[field]);
                return t1 ? 0 : (sortAsc ? -1 : 1) * (t2 ? 1 : -1);
            });
        } else {
            console.log('a.candidate.Id');
            records.sort(function(a, b) {
                console.log(a.candidate.Id);
                console.log(b.candidate.Id);
                if(a.candidate.Contact__r != undefined && b.candidate.Contact__r != undefined){
                    var t1 = a.candidate.Contact__r[field] == b.candidate.Contact__r[field],
                    t2 = (!a.candidate.Contact__r[field] && b.candidate.Contact__r[field]) || (a.candidate.Contact__r[field] < b.candidate.Contact__r[field]);
                	return t1 ? 0 : (sortAsc ? -1 : 1) * (t2 ? 1 : -1);
                }
                
            });
            finalRecordsList.sort(function(a, b) {
                if(a.candidate.Contact__r != undefined && b.candidate.Contact__r != undefined){
                var t1 = a.candidate.Contact__r[field] == b.candidate.Contact__r[field],
                    t2 = (!a.candidate.Contact__r[field] && b.candidate.Contact__r[field]) || (a.candidate.Contact__r[field] < b.candidate.Contact__r[field]);
                return t1 ? 0 : (sortAsc ? -1 : 1) * (t2 ? 1 : -1);
                }
            });
        }
        
        finalRecordsList = finalRecordsList.concat(records);
        
        component.set("v.sortAsc", sortAsc);
        component.set("v.sortField", field);
        component.set("v.candidates", finalRecordsList);
        //sortAsc = sortField != field || !sortAsc;
        this.renderPage(component,false);
		
        //Save sort fields DeaGle
        if(cacheSort){
            var mandateRec = component.get("v.simpleRecord");
            if(mandateRec != undefined && mandateRec != null){
                mandateRec.sortDirection__c = !sortAsc ? "ASC" : "DESC";
                mandateRec.sortExpression__c = field;
                component.set("v.simpleRecord",mandateRec);
                this.handleSaveRecord(component);
            }
        }  
        
    },
    handleSaveRecord: function(component) {
        component.find("recordEditor").saveRecord($A.getCallback(function(saveResult) {
            debugger;
            if (saveResult.state === "SUCCESS" || saveResult.state === "DRAFT") {
                console.log("Save completed successfully.");
            } else if (saveResult.state === "INCOMPLETE") {
                console.log("User is offline, device doesn't support drafts.");
            } else if (saveResult.state === "ERROR") {
                console.log('Problem saving record, error: ' + 
                           JSON.stringify(saveResult.error));
            } else {
                console.log('Unknown problem, state: ' + saveResult.state + ', error: ' + JSON.stringify(saveResult.error));
            }
        }));
    },
    renderPage: function(component,boolVal) {
        var records = component.get("v.candidates"),
            pageNumber = component.get("v.pageNumber"),
            pageRecords = records.slice((pageNumber - 1) * 750, pageNumber * 750);
        component.set("v.currentList", pageRecords);
        console.log('render page running');
        component.set("v.spinner", false);
        //if(boolVal == true)
        //this.sortBy(component, 'LastName');
    },
    showSpinnerHelper: function(component) {
        component.set("v.spinner", true);
    },
    hideSpinnerHelper: function(component) {
        component.set("v.spinner", false);
    },
    
    deleteSelected: function(component, event, helper) {
        // create var for store record id's for selected checkboxes  
        var delId = [];
        // get all checkboxes 
        var getAllId = component.find("boxPack");
        
        if (!Array.isArray(getAllId)) {
            if (getAllId.get("v.value") == true) {
                delId.push(getAllId.get("v.text"));
            }
        } else {
            // play a for loop and check every checkbox values 
            // if value is checked(true) then add those Id (store in Text attribute on checkbox) in delId var.
            for (var i = 0; i < getAllId.length; i++) {
                if (getAllId[i].get("v.value") == true) {
                    delId.push(getAllId[i].get("v.text"));
                }
            }
        }
        
        // call the helper function and pass all selected record id's.    
        helper.deleteSelectedHelper(component, event, delId);
        helper.canList(component, event, helper);
        helper.deleteToast(component, event, helper);
        
    },
    handleSelectPotentialEvt: function(component, event, helper) {
        //debugger;
        component.set("v.PotCandidates", true);
        
        var PC = component.get("v.PotCandidates");
        console.log(PC)
        var can = component.get("v.candidates");
        console.log(can);
        /*  var len = can.length;
              console.log(len);
          var i;
              for(i=0; i<24 ; i++){
                  var ITS = component.get("v.candidates[i].listCandidates.InternalTopStatus__c");
                  console.log(ITS);
                  if(component.get("v.candidates[i].listCandidates.InternalTopStatus__c")){
                      component.find("boxPack")[i].set("v.value", true);
                  }
              }  */
        
        var getAllId = component.find("boxPack");
        var getSelectedNumber = component.get("v.selectedCount");
        console.log(getAllId);
        if (!Array.isArray(getAllId)) {
            if (PC == true) {
                component.find("boxPack").set("v.value", true);
                component.set("v.selectedCount", 1);
            } else {
                component.find("boxPack").set("v.value", false);
                component.set("v.selectedCount", 0);
            }
        } else {
            
            if (PC == true) {
                
                // helper.selectPotCandidates(component,event,helper);
                for (var i = 0; i < getAllId.length; i++) {
                    
                    if (component.get("v.candidates")[i].candidate.InternalTopStatus__c) {
                        var ITS = component.get("v.candidates")[i].candidate.InternalTopStatus__c;
                        console.log(ITS);
                        component.find("boxPack")[i].set("v.value", true);
                        //component.set("v.selectedCount", getAllId.length);
                        getSelectedNumber++;
                        
                        
                    } else {
                        // for (var i = 0; i < getAllId.length; i++) {
                        component.find("boxPack")[i].set("v.value", false);
                        // component.set("v.selectedCount", 0);
                    }
                }
            }
            
        }
        
        helper.getselectedId(component, event, helper);
        
        component.set("v.selectedCount", getSelectedNumber);
        var selectedCanNum = component.get("v.selectedCount");
        console.log(selectedCanNum);
        
        
        
        var myEvent = $A.get("e.c:AssignmentCandidatesCompEvent");
        myEvent.setParams({
            "candidateIds": component.get("v.selectedIds"),
            "selectedCount": component.get("v.selectedCount")
        });
        
        myEvent.fire();
    }
})