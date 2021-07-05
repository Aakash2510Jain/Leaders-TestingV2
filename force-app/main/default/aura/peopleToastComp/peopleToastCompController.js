({
	myAction : function(component, event, helper) {
		
	},
    
    doInit : function(component,event,helper){
        var recordId = component.get("v.recordId");
        helper.getContact(component,event,helper);
      //  helper.showToast(component,event,helper);
       var con = component.get("v.offlimit");
        
        var companyofflimit = con;
        
       if(companyofflimit = true)
       {
          helper.showToast(component,event,helper); 
       }
        
        var compol = component.get("v.companyol");
            if(compol == true)
            {
                var companyToastEvent = $A.get("e.force:showToast");
                companyToastEvent.setParams({
                    title : 'company off limit',
                    Message : 'Company Off-Limit',
                    type:' error',
                    mode: 'sticky'
                })
                
                companyToastEvent.fire();
           }
        
    }

})