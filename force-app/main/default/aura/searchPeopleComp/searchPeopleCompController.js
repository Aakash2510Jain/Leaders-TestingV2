({
	myAction : function(component, event, helper) {
		
	},
    
    doInit :function(component,event,helper){
        helper.searchPeopleRec(component,event,helper);
        
    },
    
    closeModel: function(component,event,helper){
        
        var cmpTarget = component.find('Modalbox');
		var cmpBack = component.find('Modalbackdrop');
		$A.util.removeClass(cmpBack,'slds-backdrop--open');
		$A.util.removeClass(cmpTarget, 'slds-fade-in-open'); 
        component.set("v.openSearchModal",false);
        //component.set("v.searchPeople",null)
    },
    
    addPeople:function(component,event,helper){
        /* Previous Code Starts Here
      //  var cmphide = component.find('Modalbox');
      // close previos modal

        component.set("v.displayNewPeople",true);


        helper.hideSearchPeopleComp(component,event,helper);
        component.set("v.openSearchModal",false);
        
        ends here*/
        helper.createPeople (component,event,helper);
        helper.hideSearchCompanyComp(component,event,helper);
      
    },
    
    parentComponentEvent : function(component,event,helper){
        var value = event.getParam("displaySearchPeopleModal");
        console.log(value);
        component.set("openSearchModal",value);
    },
    showCVModel:function(component,event,helper){
        //alert('showing cv');
        var conId = event.getSource().get("v.name");
        //alert(conId);
        component.set("v.contactId",event.getSource().get("v.name"));
        component.set("v.displayCV",true);
    }
    
    
    
})