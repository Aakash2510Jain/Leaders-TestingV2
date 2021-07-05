({  
    doInit: function(component, event, helper) {
        debugger;
        var a = component.get("v.FromOnePager");
        if(a == true){
            debugger;
            helper.MainPageDataFetcher(component,event,helper);  
            
            
        }else{
            debugger;
            helper.onePagerInitialValue(component,event,helper);
            helper.MainPageDataFetcher(component,event,helper);
            helper.OnePagerData(component,event,helper);   
            helper.RadarData(component,event,helper);   
            helper.fetchDataHelper(component,event,helper);
            helper.fetchOnePager(component,event,helper);
            helper.getCVandBoardCVHelper(component,event,helper);
            helper.showWarning(component,event,helper);
        }
    },
    googleSearch : function(component, event, helper) {
        var link = 'https://www.google.com/search?q='+component.get("v.ContactName")+' '+component.get("v.CompanyName"); 
        window.open(link); 
    },
    linkedInSearch : function(component, event, helper) {
        var link = 'https://www.linkedin.com/search/results/all/?keywords='+component.get("v.ContactName")+' '+component.get("v.CompanyName")+'&origin=TYPEAHEAD_ESCAPE_HATCH'; 
        window.open(link);   
    },
    handleCheck : function(component, event, helper) {
        var isChecked = component.find("DisclaimerCheckBox").get("v.checked");
        component.set("v.Include_Compensation", isChecked);
    },
    displayWarning : function(component, event, helper) {
        component.set("v.Warning", true);
    },
    DisplayCV: function(component,event,helper){
        var cmpTarget = component.find('Modalbox');
        var cmpBack = component.find('Modalbackdrop');
        $A.util.removeClass(cmpBack,'slds-backdrop--open');
        $A.util.removeClass(cmpTarget, 'slds-fade-in-open'); 
        component.set("v.displayCVComp",true);
        
        var appId = event.getSource().get("v.value");
        var manId = event.getSource().get("v.title");
        var conID = component.get("v.recordId");
        component.set("v.mandateRecId",manId);
        component.set("v.applicationId",appId);
        component.set("v.selectedConId",conID);
        
        helper.showWarning(component,event,helper);
        helper.fetchDataHelper(component,event,helper);
        helper.fetchOnePager(component,event,helper);
        
        helper.getCVandBoardCVHelper(component,event,helper);
        component.set("v.onePagerWarning",false);
    },
    DisplayOP:function(component,event,helper){
        debugger;
        var canId = event.getSource().get("v.value");
        
        var action = component.get("c.getAttId");
        action.setParams({
            canId : canId,
        });
        
        action.setCallback(this,function(response){
            var result = response.getReturnValue();
            debugger;
            if(response.getState() == "SUCCESS"){
                if(result!=null){
                    component.set("v.attachmentId",result);
                  //  component.set("v.isOpen",false);
                    component.set("v.displayCV",true);
                }else{
                    component.set("v.displayCV",false);
                    swal.fire({
                        title: "Error!",
                        text: "No Attachment Found",
                        type: "success",
                        timer: 3000
                    });                    
                }
            }
        })                
        $A.enqueueAction(action);
    },    
    handleClick: function(component,event,helper){
        debugger;
        var selectedItem = event.currentTarget
        var recId = selectedItem.dataset.record;
        console.log(recId);
        
        var pageReference={
            type: 'standard__component',
            attributes: {
                componentName:'c__AssignmentCandidatesPageComp'
            },
            state:{
                "c__mandateId": recId
            }    
        };        
        component.set("v.pageReference",pageReference);
        
        var navService = component.find("navService");
        var pageReference = component.get("v.pageReference");
        event.preventDefault();
        navService.navigate(pageReference);
    },
    
    back : function(component,event,helper){
        component.set("v.displayOnePagerList",true);
        component.set("v.displayOnePager",false);
        component.set("v.displaySelfAssList",true);
        component.set("v.displaySelfAss",false);
        
    },
    closeModel: function(component,event,helper){
        var cmpTarget = component.find('Modalbox');
        var cmpBack = component.find('Modalbackdrop');
        $A.util.removeClass(cmpBack,'slds-backdrop--open');
        $A.util.removeClass(cmpTarget, 'slds-fade-in-open');
        component.set("v.FromOnePager",false);
        component.set("v.displayCVComp",false);
        component.set("v.displayOPComp",false);
    },
    SetOnePagerId : function(component,event,helper)
    {
        var appId = event.getSource().get("v.value");
        var action = component.get("c.get_Attach_id_OnePager");
        
        action.setParams({
            "recordId": appId,
            "mandateId":component.get("v.mandateRecId")
        });
        
        action.setCallback(this, $A.getCallback(function(response) {
            var state = response.getState();
            var storeResponse = response.getReturnValue();
            
            if (state == "SUCCESS") {
                {
                    component.set("v.onePagerId",storeResponse.OnePagerId);//onePagerFromConId
                  //  component.set("v.onePagerFromConId",storeResponse[1]);
                    component.set("v.displayOnePagerList",false);
                    component.set("v.displayOnePager",true);
                }
            }else{}
        }));
        $A.enqueueAction(action);
    },
     SetOnePagerConId : function(component,event,helper)
    {
        debugger;
        var OpFromConID = component.get("v.onePagerFromConId");
        component.set("v.onePagerId",OpFromConID);
        component.set("v.displayOnePagerList",false);
        component.set("v.displayOnePager",true);

    },
    closeModal: function(component,event,helper){
        var cmpTarget = component.find('Modalbox');
        var cmpBack = component.find('Modalbackdrop');
        $A.util.removeClass(cmpBack,'slds-backdrop--open');
        $A.util.removeClass(cmpTarget, 'slds-fade-in-open'); 
        component.set("v.displayCVComp",false);
        component.set("v.Warning",false);
    },
    displaySplitv : function(component,event,helper){
        $A.util.addClass(component.find("cvView"), "slds-hide");
        component.set("v.displaySplitView",true);
        component.set("v.displayCVView",false);
    },
    createBioDoc : function(component, event, helper) {
        helper.createBioDoc(component);
    },
    saveRecord: function(component,event,helper){
        helper.saveContact(component,event,helper);
        helper.createBioDoc(component);
        helper.closeModel(component,event,helper); 
    },
    recordUpdated: function(component,event,helper)
    {
        helper.recordUpdated(component,event,helper);
    },
    
    save: function(component,event,helper) {
        debugger;
        var selectedValues = component.get("v.one_Pager_Values");
        var boolean = component.get("v.Include_Compensation");
        var radarData = component.get("v.Radar_Values");
        var selectedConValues = component.get("v.Contact_Values");
      //  helper.saveRadarInfo(component,event,helper);
        if(selectedValues.length != 0){
            
            var deleteList = component.get("v.deleteList");
            var appid = component.get("v.applicationId");
            var action = component.get("c.Create_One_Pager_Con_Rec");
            
            action.setParams({ConListtobeUpdated :selectedConValues,RadarListTobeUpdated :radarData, One_Pager_List : selectedValues,deleteList:deleteList,appid : appid,Compensation_To_Be_included:boolean});
            
            action.setCallback(this,function(response){
                var result = response.getReturnValue();
                debugger;
                if(response.getState() === "SUCCESS"){
                    component.set("v.one_Pager_Values",result);
                    {   
                        swal.fire({
                            title: "Success",
                            text: "One Pager Record created",
                            type: "success",
                            timer: 3000,
                            showConfirmButton: false
                        });
                       // component.set('v.displayCVComp',false);
                    }
                }
            });
            $A.enqueueAction(action);
        }
        else{
            swal.fire({
                title: "error",
                text: "No values selected",
                type: "error",
                timer: 3000,
                showConfirmButton: false
            });
        }
    },
     SetSelAssId : function(component,event,helper){
        debugger;
        
        var appId = event.getSource().get("v.value");
        var action = component.get("c.get_Attach_id_OnePager");
        action.setParams({
            "recordId": appId,
            "mandateId":component.get("v.mandateRecId")
        });
        
        action.setCallback(this, $A.getCallback(function(response) {
            var state = response.getState();
            var storeResponse = response.getReturnValue();
            
            if (state == "SUCCESS") {
                {
                   // component.set("v.SelfAssId",storeResponse[0]);
                    component.set("v.SelfAssId",storeResponse.SelfAssId);
                    component.set("v.displaySelfAssList",false);
                    component.set("v.displaySelfAss",true);
                }
            }else{}
        }));
        $A.enqueueAction(action);
    },
})