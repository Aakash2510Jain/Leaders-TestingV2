({
	addCompany: function(component, event, helper) {
		console.log('showCompanyAddModal');
		component.find("companyModal").showCompanyAddModal({});
		console.log('showCompanyAddModal2');
		
	},

	saveCompany: function(component, event, helper) {
		var companies = component.get('v.companies');
		var company = event.getParam('company');

		if(company.position) {
			companies[company.position] = company;
			company.position = undefined;
		} else {
			companies.push(company);
		}
		
		component.set('v.companies', companies);

		var item = {};
		var companiesType = component.get('v.companiesType');
		if(companiesType=='primary') {
			item["companiesPrimary"] = companies;
		} else {
			item["companiesExecutif"] = companies;
		}

		var eventSelected = $A.get("e.c:CandidateInputUpdateEvt");
	    eventSelected.setParams({ "item": item});
	    eventSelected.fire();
	},

	handleMenuCompanySelect: function(component, event, helper) {
		var companies = component.get('v.companies');

		var value = event.getParam("value").split('-')[0];
		var index = event.getParam("value").split('-')[1];
		
		if(value=="edit") {
			var company = companies[index];
			company.position = index;
			component.find("companyModal").showCompanyAddModal(companies[index]);

		} else if(value=="delete") {
			companies.splice(index, 1);
			
		}

		component.set('v.companies', companies);

		var item = {};
		var companiesType = component.get('v.companiesType');
		if(companiesType=='primary') {
			item["companiesPrimary"] = companies;
		} else {
			item["companiesExecutif"] = companies;
		}

		var eventSelected = $A.get("e.c:CandidateInputUpdateEvt");
	    eventSelected.setParams({ "item": item});
	    eventSelected.fire();
	}
})