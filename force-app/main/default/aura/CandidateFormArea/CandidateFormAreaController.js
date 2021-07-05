({
	updateInput : function(component, event, helper) {

		var areaSelected = component.get('v.areaSelected');

		var checkBoxValue = event.getSource().get("v.value");

		if (areaSelected.hasOwnProperty(checkBoxValue)) {
			delete areaSelected[checkBoxValue];
		} else {
			areaSelected[checkBoxValue] = true;
		}

		var item = {};
		item.area = Object.keys(areaSelected);

		var eventSelected = $A.get("e.c:CandidateInputUpdateEvt");
	    eventSelected.setParams({ "item": item});
	    eventSelected.fire();
	}
})