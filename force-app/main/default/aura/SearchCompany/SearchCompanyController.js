({
	doInit : function(component, event, helper) {
        var People = {};
        People.Id = 5;
        People.value = 'Total_Contacts__c';
        People.key = 'People';
        People.sortAsc = true;
        component.set("v.PeopleObject", People);
        
        var Ass = {};
        Ass.Id = 5;
        Ass.value = 'Total_Ass__c';
        Ass.key = 'Assignments';
        Ass.sortAsc = true;
        component.set("v.AssObject", Ass);
        
        var host = window.location.pathname;
        if(host.includes("c__SearchCompany")){
            component.set("v.ButtonColor" , "success");
        }
		helper.doInitHelper(component, event, helper);
	},
    navigateToSearchPeople  : function(component, event, helper) {
        debugger;
        var urlEvent = $A.get("e.force:navigateToURL");
        var host = window.location.hostname;
        urlEvent.setParams({
            'url': '/lightning/cmp/c__SearchPeople'
        });
        
        urlEvent.fire();
    },

     closeModal: function(component,event,helper){
        component.set("v.AddTootherAssWarning",false);
      },
    navigateToSearchAss  : function(component, event, helper) {
        debugger;
        var urlEvent = $A.get("e.force:navigateToURL");
        var host = window.location.hostname;
        urlEvent.setParams({
            'url': '/lightning/cmp/c__SearchAssignment'
        });
        
        urlEvent.fire();
    },
    doSearch:function(component, event, helper){
        debugger;
        if(component.get("v.checkSpinner")==false){
            component.set("v.checkSpinner",true);
        }
        helper.doSearchHelper(component, event, helper);
    },
    getFieldsController:function(component, event, helper){
        debugger;
       // helper.getFieldsHelper(component, event, helper);
    },
     CheckCountry:function(component, event, helper){
        debugger;
       // helper.getFieldsHelper(component, event, helper);
    },
     viewAll:function(component, event, helper){
          debugger;
        if(component.get("v.checkSpinner")==false){
            component.set("v.checkSpinner",true);
        }
        helper.viewAllHelper(component, event, helper);
    },
    doDelete:function(component, event, helper){
        debugger;
		component.set("v.showConfirmDialog",true);
    },
    
    handleConfirmDialogNo : function(component, event, helper) {
        component.set('v.showConfirmDialog', false);
    },
    handleConfirmDialogYes : function(component, event, helper) {
        
        helper.doDeleteHelper(component, event, helper);
    	component.set('v.showConfirmDialog', false);
    },
    doMerge:function(component, event, helper) {
        
        var selectedCandidates = component.get("v.selectedRecord");
        if(selectedCandidates.length > 0){
            //var abc= component.get("v.selectedRecord");
            component.set("v.isOpen",true);   
        }else{
            component.set("v.AddTootherAssWarning",true);
        }
        
       
    },
    doreset:function(component, event, helper){

		$A.get('e.force:refreshView').fire();
    },
    splice:function(component,event,helper){
        helper.spliceHelper(component,event,helper);
    }

})