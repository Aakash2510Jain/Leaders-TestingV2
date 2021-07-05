({
	updateInput : function(component, event, helper) {
		var eventSelected = $A.get("e.c:CandidateInputUpdateEvt");
	    eventSelected.setParams({ "item": component.get('v.item')});
	    eventSelected.fire();
	}
})