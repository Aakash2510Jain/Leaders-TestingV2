({
	doInit: function(component, event, helper) {
        debugger;
        helper.fetchDataHelper(component,event,helper);
        
    },
    showSelfAss: function(component, event, helper){
       component.set('v.showMainPage',false) ;
        
    }
})