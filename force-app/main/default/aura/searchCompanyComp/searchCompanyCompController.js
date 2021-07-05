({
	myAction : function(component, event, helper) {
		
	},
    
    doInit :function(component,event,helper){
        helper.searchCompanyRec(component,event,helper);
        
    },
    
    closeModel: function(component,event,helper){
        
        var cmpTarget = component.find('Modalbox');
		var cmpBack = component.find('Modalbackdrop');
		$A.util.removeClass(cmpBack,'slds-backdrop--open');
		$A.util.removeClass(cmpTarget, 'slds-fade-in-open'); 
        component.set("v.openSearchCompanyModal",false);
        //component.set("v.searchCompany",null);
    },
    
    addCompany:function(component,event,helper){
      //  var cmphide = component.find('Modalbox');
      //  component.set("v.displayCompany",true); 
        helper.createCompany (component,event,helper);
        helper.hideSearchCompanyComp(component,event,helper);
       
        
      
    }
})