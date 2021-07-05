({
	doInit : function(component, event, helper) {
		helper.fetchSSL(component,event,'Meeting_Note__c','Status_Summary_Line__c','v.sslList'); 
        helper.fetchSSL(component,event,'Application__c','Origin__c','v.originList'); 
		
	},

	closeModal : function(component, event, helper){
		component.set("v.displayChangeSSLOriginModal",false);
	},

	saveSummaryStatusLine : function(component, event, helper){
		helper.saveStatus(component, event, 'BOTH');
	},
	/*saveOrigin : function(component, event, helper){
		helper.saveStatus(component, event, 'ORIGIN');
	},
	saveBoth : function(component, event, helper){
		helper.saveStatus(component, event, 'BOTH');
	},*/

})