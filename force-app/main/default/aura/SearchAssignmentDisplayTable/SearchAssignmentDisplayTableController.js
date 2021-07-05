({
    doInit : function(component, event, helper) {
        debugger;
        //$A.get('e.force:refreshView').fire();
        helper.doInitHelper(component, event, helper);
        //helper.sortByFieldHelper(component, event, helper);
    },    
    handleSuccess: function(component, event, helper) {
        $A.get('e.force:refreshView').fire();
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
    showAssDetails : function(component, event, helper) {        
        component.set("v.ShowAssPage", true);
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
        helper.handleViewAllEventHelper(component, event, helper);
         component.set("v.checkSpinner",false);
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
    OnDeleteSplice:function(component, event, helper){
    },
    buildData:function(component,event,helper){
        helper.buildData(component,event,helper);
    }
})