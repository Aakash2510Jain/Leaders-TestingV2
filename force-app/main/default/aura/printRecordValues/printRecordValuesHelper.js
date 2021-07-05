({
	doInitHelper : function(component, event, helper) {
        debugger;
		var obj=component.get('v.obj');
        var apiName=component.get('v.apiName');
        var fieldValue=obj[apiName];
        component.set('v.fieldValue',fieldValue);
	}
})