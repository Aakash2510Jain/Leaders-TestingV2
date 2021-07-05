({
    closeModel: function(component,event,helper){
        var cmpTarget = component.find('Modalbox');
        var cmpBack = component.find('Modalbackdrop');
        $A.util.removeClass(cmpBack,'slds-backdrop--open');
        $A.util.removeClass(cmpTarget, 'slds-fade-in-open'); 
        component.set("v.displayOPComp",false);
        
    },
    onePagerInitialValue: function(component,event,helper){
        debugger;
        var appID = component.get("v.applicationId");
        
        var action = component.get("c.get_Attach_id_OnePager");
        action.setParams({
            "recordId": appID,
            "mandateId":component.get("v.mandateRecId")
        });
        action.setCallback(this, $A.getCallback(function(response) {
            var state = response.getState();
            var storeResponse = response.getReturnValue();
            
            if (state == "SUCCESS") {
                {
                    if(storeResponse != null){
                        component.set("v.onePagerId",storeResponse.OnePagerId);
                        component.set("v.onePagerFromConId",storeResponse.OnePagerFromConId);
                        component.set("v.LetterId",storeResponse.LetterFromConId);
                        component.set("v.JobDescId",storeResponse.JobDescId);
                        component.set("v.PsyId",storeResponse.PsyId);
                    }
                }
            }else{}
        }));
        $A.enqueueAction(action);
    },
    
    saveContact: function(component,event,helper){
        component.find("conRec").saveRecord($A.getCallback(function(saveResult){
            if (saveResult.state === "SUCCESS" || saveResult.state === "DRAFT") {
                console.log("Save completed successfully.");
            } else if (saveResult.state === "INCOMPLETE") {
                component.set("v.recordSaveError","User is offline, device doesn't support drafts.");
            } else if (saveResult.state === "ERROR") { 
                var errMsg = "";
                // saveResult.error is an array of errors, 
                // so collect all errors into one message
                for (var i = 0; i < saveResult.error.length; i++) {
                    errMsg += saveResult.error[i].message + "\n";
                }
                component.set("v.recordSaveError", errMsg);
                
            } else {
                component.set("v.recordSaveError",'Unknown problem, state: ' + saveResult.state + ', error: ' + 
                              JSON.stringify(saveResult.error));
            }
        }));
    },
    showWarning : function(component, event, helper){
        var action = component.get("c.One_Pager_Boolean_Value");
        
        action.setParams({
           "mandateRecId" : component.get("v.mandateRecId"),
        })
        action.setCallback(this, function(response) {
            var state = response.getState();
             var storeResponse = response.getReturnValue();
            if (state === "SUCCESS") {
                debugger;
                component.set("v.Is_English",storeResponse[0]);
                component.set("v.onePagerWarning",storeResponse[1]);
                var abc = component.get("v.Is_English");
                if(abc == true){
                    component.set("v.tabId",'English'); 
                }else{
                    component.set("v.tabId",'French'); 
                }
            }
        });
        $A.enqueueAction(action);
    },
    recordUpdated : function(component, event, helper){
        
        var changeType = event.getParams().changeType;
        if (changeType === "CHANGED") {
            component.find("conRec").reloadRecord();
        }
        
    },
    navigateToRecord : function(component,event,helper){
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId" : recordId
        });
        
        navEvt.fire();
        component.find("Id_Spinner").set("v.class",'slds-hide');
    },
    createBioDoc: function(component){
        var action = component.get("c.createOnePagerOrBioDocs");
        action.setParams({
            conId:component.get("v.recordId"),
            docType:'ONE_PAGER',
            language:'english'
        })
        action.setCallback(this, function(response) {
            var state = response.getState(); 
            var storeResponse = response.getReturnValue();
            if (state === "SUCCESS") {
               
            }
        });
        $A.enqueueAction(action);
    },
    RadarData: function(component,event,helper){
        debugger;
        var action = component.get("c.RadarResp");
        var abc = component.get("v.selectedConId");
        action.setParams({
            "mandateRecId" : component.get("v.mandateRecId"),
            "ConRecID" : component.get("v.selectedConId"),
            "AppRecId" : component.get("v.applicationId")
        });
        action.setCallback(this,function(response){
            var result = response.getReturnValue();
            debugger;
            if(response.getState() === "SUCCESS"){
                {
                    component.set("v.Radar_Values",result);
                    component.set("v.showLoadingSpinner",false);
                }
            }
        });
        $A.enqueueAction(action);
    },
    fetchDataHelper: function(component,event,helper){
        debugger;
        var action = component.get("c.onePagerResp");
        var abc = component.get("v.selectedConId");
        action.setParams({
            "mandateRecId" : component.get("v.mandateRecId"),
            "ConRecID" : component.get("v.selectedConId"),
            "AppRecId" : component.get("v.applicationId")
        });
        action.setCallback(this,function(response){
            var result = response.getReturnValue();
            debugger;
            if(response.getState() === "SUCCESS"){
                {
                    component.set("v.Contact_Values",result[0]);
                    component.set("v.ContactName",result[0][0].Name);
                    component.set("v.CompanyName",result[0][0].Company_Name_French__c);
                    component.set("v.one_Pager_Values",result[1]);
                    if(result[1][0].Application__r != undefined && result[1][0].Application__r != null){
                        component.set("v.Include_Compensation",result[1][0].Application__r.Include_In_One_Pager__c);    
                    }
                    component.set("v.showLoadingSpinner",false);
                }
            }
        });
        $A.enqueueAction(action);
    },
     fetchOnePager: function(component, event, helper) {
        debugger;
        //var target = event.currentTarget.title;
        //"mandateId":component.get("v.mandateRecId")
        var abc = component.get("v.applicationId"); 
        var action = component.get("c.get_Attach_id_OnePager");
        action.setParams({
            "recordId": abc,
            "mandateId":component.get("v.mandateRecId")
        });
        
        action.setCallback(this, $A.getCallback(function(response) {
            var state = response.getState();
            var storeResponse = response.getReturnValue();
            
            if (state == "SUCCESS") {
                {
                    if(storeResponse != null){
                        component.set("v.onePagerId",storeResponse.OnePagerId);  
                        component.set("v.onePagerFromConId",storeResponse.OnePagerFromConId);
                        component.set("v.LetterId",storeResponse.LetterFromConId);
                        component.set("v.JobDescId",storeResponse.JobDescId);
                        component.set("v.PsyId",storeResponse.PsyId);
                    }
                }
            }else{}
        }
      ));
        $A.enqueueAction(action);
    },
   /*  saveRadarInfo: function(component, event, helper) {
        debugger;
        //var target = event.currentTarget.title;
        //"mandateId":component.get("v.mandateRecId")
        var abc = component.get("v.applicationId"); 
        var action = component.get("c.get_Attach_id_OnePager");
        action.setParams({
            "recordId": abc,
            "mandateId":component.get("v.mandateRecId")
        });
        
        action.setCallback(this, $A.getCallback(function(response) {
            var state = response.getState();
            var storeResponse = response.getReturnValue();
            
            if (state == "SUCCESS") {
                {
                    if(storeResponse != null){
                        component.set("v.onePagerId",storeResponse.OnePagerId);  
                        component.set("v.onePagerFromConId",storeResponse.OnePagerFromConId);
                        component.set("v.LetterId",storeResponse.LetterFromConId);
                        component.set("v.JobDescId",storeResponse.JobDescId);
                        component.set("v.PsyId",storeResponse.PsyId);
                    }
                }
            }else{}
        }
      ));
        $A.enqueueAction(action);
    }, */
    MainPageDataFetcher: function(component, event, helper) {
        debugger;
        var abc = component.get("v.recordId");
       // var abc = component.get("v.selectedConId");
        var action = component.get("c.One_Pager_Main_Data");
        action.setParams({
            "conRecId": abc,
        });
        
        action.setCallback(this, $A.getCallback(function(response) {
            var state = response.getState();
            var storeResponse = response.getReturnValue();
            
            if (state == "SUCCESS") {
               {   
                   component.set("v.MainPageapplicationData",storeResponse[0]);
                   debugger;
                   if(storeResponse[1].length == 0){
                       component.set("v.displayOnePagerList",false);
                       component.set("v.OnePagerfromContact",true);
                       var OpId = component.get("v.onePagerId");
                   }  else{
                   component.set("v.OnePAgerapplicationData",storeResponse[1]);    
                   }
                   component.set("v.SelfAssapplicationData",storeResponse[2]);
                   
                   var language = storeResponse[0].Language__c;
                   if(language == 'English'){
                       component.set("v.Is_English",true);
                   }
                   else{
                       component.set("v.Is_English",false);
                   }
                   
               }
            }else{}
        }
      ));
        $A.enqueueAction(action);
    },
     OnePagerData: function(component, event, helper) {
        debugger;
        var conId = component.get("v.selectedConId");
       // var abc = component.get("v.recordId"); 
        var action = component.get("c.One_Pager_Main_Data");
        action.setParams({
            "conRecId": conId,
        });
        
        action.setCallback(this, $A.getCallback(function(response) {
            var state = response.getState();
            var storeResponse = response.getReturnValue();
            
            if (state == "SUCCESS") {
                {
                    component.set("v.MainPageapplicationData",storeResponse);
                }
            }else{}
        }
      ));
        $A.enqueueAction(action);
    },
    getCVandBoardCVHelper: function(component, event, helper) {
        debugger;
        //var target = event.currentTarget.title;
        var abc = component.get("v.selectedConId");
        var action = component.get("c.getCVandBoardCV");
        action.setParams({
            "recordId": abc
        });
        
        action.setCallback(this, $A.getCallback(function(response) {
            var state = response.getState();
            var storeResponse = response.getReturnValue();
            
            if (state == "SUCCESS") {
               /* if(storeResponse[0].Attachments != null || storeResponse[0].Attachments != undefined ){
                    component.set("v.onePagerId",storeResponse[0].Attachments[0].Id);
                    // component.set("v.displayOP",true);
                    // component.set("v.spinner",false);
                }*/
                for (var key in storeResponse){
                    if(key=='CV'){
                        component.set("v.CVID",storeResponse[key]);
                    }
                    if(key=='Board CV'){
                        component.set("v.boardCVID",storeResponse[key]);
                    }
                }
            }else{}
        }
      ));
        $A.enqueueAction(action);
    },
})