({
    doInit : function(component, event) {

        console.log(decodeURIComponent(window.location.search.substring(1))); 

        component.set('v.assignmentId',decodeURIComponent(window.location.search.substring(1)).split('=')[1]);    
    },

    updateItem : function(component, event, helper) {
		var itemFromEvent = event.getParam('item');
       	var item = component.get('v.item');
        for (var key in itemFromEvent) {
            if (itemFromEvent.hasOwnProperty(key)) {
                item[key] = itemFromEvent[key];
            }
        }
        console.log("Update Item");
        console.log(JSON.stringify(item));
        component.set('v.item',item);
	},
    
	submit : function(component, event, helper) {
		
        var item = component.get('v.item');
        console.log(JSON.stringify(item));
        helper.callAction(
            component,
            "c.saveCandidate",
            {
                "candidateJSON" : JSON.stringify(item),
                "assignmentId": component.get('v.assignmentId'),
                "originFieldName": component.get('v.originFieldName'),
                "originValue": component.get('v.originValue'),
                "defaultAccountId": component.get('v.defaultAccountId')
            },
            function( data ) {

                var urlEvent = $A.get("e.force:navigateToURL");
                    urlEvent.setParams({
                      "url": '/form-success'
                    });
                    urlEvent.fire();
                });
	}
})