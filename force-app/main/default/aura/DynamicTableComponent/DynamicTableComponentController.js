({
	doInit : function(component, event, helper) {
		helper.getRecordsHelper(component, event, component.get("v.initialSearchString"));
	},

	go : function(component, event, helper) {
        component.set("v.showSpinner",true);
		helper.goHelper(component, event);
	},

	selectedRecord : function(component, event, helper){
		debugger;
	}
})