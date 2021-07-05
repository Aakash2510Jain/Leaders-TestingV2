({
    doInit : function(component, event, helper){
        debugger;
       
        helper.MainPageDataFetcher(component, event, helper);
        if(component.get("v.attId")==''){
            var action = component.get("c.getCVId");
            action.setParams({
                conId : component.get("v.contactId"),
            });
            
            action.setCallback(this,function(response){
                var result = response.getReturnValue();
                debugger;
                if(result)
                    component.set("v.attId",result);
                else{
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "NO CV",
                        "message": "No CV found",
                        "type": 'info'
                    });
                    toastEvent.fire();
                }
                
            })
            $A.enqueueAction(action);
        }
    },
    
    closeModal : function(component, event, helper) {
        debugger;
        //var cmpTarget = component.find('MainDiv');
        //$A.util.removeClass(cmpTarget, 'slds-modal__container');
        
        component.set("v.displayCV",false);
        component.set("v.displayOP",false);
        component.set("v.displayPSY",false);//displayJD
        component.set("v.displayJD",false);
        component.set("v.viewCVfromPeople",false);
        component.set("v.viewOPfromPeople",false);
    },
    MainPageDataFetcher: function(component, event, helper) {
        debugger;
        var abc = component.get("v.recordId"); 
        var action = component.get("c.Self_Ass_Data");
        action.setParams({
            "conRecId": abc,
        });
        
        action.setCallback(this, $A.getCallback(function(response) {
            var state = response.getState();
            var storeResponse = response.getReturnValue();
            
            if (state == "SUCCESS") {
                {
                    component.set("v.MainPageapplicationData",storeResponse);
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
    SetSelAssId : function(component,event,helper){
        debugger;
        
        var appId = event.getSource().get("v.value");
        var action = component.get("c.get_Attach_id_SelfAss");
        action.setParams({
            "recordId": appId,
           // "mandateId":component.get("v.mandateRecId")
        });
        
        action.setCallback(this, $A.getCallback(function(response) {
            var state = response.getState();
            var storeResponse = response.getReturnValue();
            
            if (state == "SUCCESS") {
                {
                    component.set("v.SelfAssId",storeResponse);
                    //component.set("v.displayOnePagerList",false);
                    //component.set("v.displayOnePager",true);
                }
            }else{}
        }));
        $A.enqueueAction(action);
    },
})