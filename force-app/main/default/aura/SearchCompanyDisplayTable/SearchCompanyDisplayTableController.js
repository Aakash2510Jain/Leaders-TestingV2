({
    doInit : function(component, event, helper) {
        
        
        console.log("SearchCompanyDisplayTable doint called");
        debugger;
        helper.doInitHelper(component, event, helper);
    },    
    onNext : function(component, event, helper) {        
        var pageNumber = component.get("v.currentPageNumber");
        component.set("v.currentPageNumber", pageNumber+1);
        helper.buildData(component, helper);
    },
    onPrev : function(component, event, helper) {        
        var pageNumber = component.get("v.currentPageNumber");
        component.set("v.currentPageNumber", pageNumber-1);
        helper.buildData(component, helper);
    },    
    processMe : function(component, event, helper) {
        component.set("v.currentPageNumber", parseInt(event.target.name));
        helper.buildData(component, helper);
    },
    
    onFirst : function(component, event, helper) {        
        component.set("v.currentPageNumber", 1);
        helper.buildData(component, helper);
    },
    handleViewAllEvent:function(component, event, helper){
        debugger;
        if(component.get("v.checkSpinner")==false){
            component.set("v.checkSpinner",true);
        }
        helper.handleViewAllEventHelper(component, event, helper);
    },
    
    showPeopleDetails : function(component, event, helper) {    
        debugger;
        //var CompId = document.getElementById("demo").getAttribute("data-value"); 
        
        var CompId = event.currentTarget.title;
        var from = event.currentTarget.id;
        var action = component.get("c.getPEopleDetailsFromCompany");
        action.setParams({
            "CompId": CompId,
        });
        
        action.setCallback(this, $A.getCallback(function(response) {
            var state = response.getState();
            var storeResponse = [];
            storeResponse = response.getReturnValue();
            
            if (state == "SUCCESS") {
                {
                    debugger;//
                    component.set("v.PeopleDetails",storeResponse[0]);
                    component.set("v.CompanyName",storeResponse[0][0].Company_Name_French__c);
                    component.set("v.AssDetails",storeResponse[1]);
                    component.set("v.TotalPeople",storeResponse[0].length);
                    if(from == "People"){
                        component.set("v.ShowCompPage",true);
                    }else{
                        component.set("v.ShowAssPage",true);    
                    }
                    
                }
            }else{}
        }));
        $A.enqueueAction(action);
    },
    onLast : function(component, event, helper) {        
        component.set("v.currentPageNumber", component.get("v.totalPages"));
        helper.buildData(component, helper);
    },
    sortByField:function(component, event, helper) {
        helper.sortByFieldHelper(component, event, helper);
    },
    onCheck:function(component, event, helper){
        debugger;
        helper.onCheckHelper(component, event, helper);
    },
    showCompDetails:function(component, event, helper){
        debugger;
        component.set("v.ShowCompPage",true);
    },
    OnDeleteSplice:function(component, event, helper){
    },
    buildData:function(component,event,helper){
        helper.buildData(component,event,helper);
    }
    
    
})