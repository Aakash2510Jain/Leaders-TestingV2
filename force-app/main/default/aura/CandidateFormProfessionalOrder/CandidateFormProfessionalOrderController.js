({

	doInit : function(component, event, helper) {

		var orders = ["Aucune","Ordre des administrateurs agréés du Québec","Association des MBA","Ordre des comptables professionnels agréés du Québec","Association professionnelle des gestionnaires de project du Québec","Ordre des conseillers en ressources humaines agréés du Québec","Barreau du Québec","Ordre des ingénieurs du Québec","Chartered Financial Analyst Institute","Ordre des pharmaciens du Québec","Chambre des notaires du Québec","Ordre des psychologues du Québec","Collège des médecins du Québec","GOUVERNANCE: Collège des administrateurs de sociétés (ASC)","Expert en évaluation d'entreprises","GOUVERNANCE: Insititut des administrateurs de sociétés (IAS.A)","Institut canadien des actuaires"];

		component.set('v.orders',orders);


	},

	updateInput : function(component, event, helper) {

		var orderSelected = component.get('v.orderSelected');

		var checkBoxValue = event.getSource().get("v.value");

		if (orderSelected.hasOwnProperty(checkBoxValue)) {
			delete orderSelected[checkBoxValue];
		} else {
			orderSelected[checkBoxValue] = true;
		}

		var item = {};
		item.order = Object.keys(orderSelected);

		var eventSelected = $A.get("e.c:CandidateInputUpdateEvt");
	    eventSelected.setParams({ "item": item});
	    eventSelected.fire();
	},

	updateOtherOrder : function(component, event, helper) {

		var item = {};
		item.otherOrder = component.get('v.otherOrder');

		var eventSelected = $A.get("e.c:CandidateInputUpdateEvt");
	    eventSelected.setParams({ "item": item});
	    eventSelected.fire();

	}
})