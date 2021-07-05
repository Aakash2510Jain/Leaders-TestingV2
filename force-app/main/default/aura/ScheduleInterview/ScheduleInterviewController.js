({
	
	closeModal : function(component, event, helper){
		component.set("v.displaySchdIntr",false);
	},

	saveBoth : function(component, event, helper){
		helper.saveStatus(component, event, 'BOTH');
	},
    handleClick : function(component, event, helper){
        
        var childCmp = component.find('childCmp');
        childCmp.sampleMethod();

    }
   
})