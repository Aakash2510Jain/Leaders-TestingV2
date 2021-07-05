({
    doInit : function(component, event, helper){
        debugger;
        if(JSON.stringify(component.get("v.selectedRecord")) != "{}")
            helper.recordSelectedCssHelper(component,event);
    },
    itemSelected : function(component, event, helper) {
        helper.itemSelected(component, event, helper);
    },
    serverCall :  function(component, event, helper) {
        helper.serverCall(component, event, helper);
    },
    handleComponentEvent : function(component, event, helper) {
        helper.handleComponentEventHelper(component, event, helper);
    },
    clear : function(component, event, helper) {
        helper.clearSelection(component, event);
    },
    keyPressController : function(component, event, helper) {
        // get the search Input keyword
        var getInputkeyWord = component.get("v.SearchKeyWord");
        component.set("v.textEntered",getInputkeyWord);
        // check if getInputKeyWord size id more then 0 then open the lookup result List and
        // call the helper
        // else close the lookup result List part.
        if( getInputkeyWord.length > 1 ){
            var forOpen = component.find("searchRes");
            $A.util.addClass(forOpen, 'slds-is-open');
            $A.util.removeClass(forOpen, 'slds-is-close');
            helper.searchHelper(component,event,getInputkeyWord);
        }
        else{
            component.set("v.listOfSearchRecords", null );
            var forclose = component.find("searchRes");
            $A.util.addClass(forclose, 'slds-is-close');
            $A.util.removeClass(forclose, 'slds-is-open');
        }
        
    }
})