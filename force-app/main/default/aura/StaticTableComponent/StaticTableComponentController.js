({
    doInit : function(component, event, helper) {
		helper.getRecordsHelper(component, event, component.get("v.initialSearchString"),helper);
    },
    select : function(component, event, helper){
        helper.select(component, event);
    },
    go : function(component, event, helper) {
        component.set("v.showSpinner",true);
		helper.goHelper(component, event,helper);
	},
    sortByName: function(component, event, helper) {
        helper.sortBy(component, event.currentTarget.getAttribute('data-sortAttType'), true);
    },

})