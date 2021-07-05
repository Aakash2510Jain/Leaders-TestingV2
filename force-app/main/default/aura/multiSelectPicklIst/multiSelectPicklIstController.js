({
    
    
    
    
    
    handleSelection :function(component, event, helper){
        debugger;
        helper.handleSelectionHelper(component, event, helper);
        
    },
    pkgboxSelected: function(component, event, helper) 
    {	debugger;
        helper.pkgboxSelected(component, event, helper);
        
    },
    clickMe: function(component, event, helper) {
        //helper.handleSelectionHelper(component, event, helper);
    },
   
    handleMouseLeave: function(component, event, helper) {
//component.set("v.dropdownOver",false);
        var cmpTarget = component.find('pkgDropdown');
        $A.util.removeClass(cmpTarget, 'slds-is-open');
       
    },
    
    handleMouseEnter: function(component, event, helper) {
        component.set("v.dropdownOver",true);
    },
 
})