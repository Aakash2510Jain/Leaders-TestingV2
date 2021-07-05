({
	helperMethod : function() {
		
	},
    
    showToast : function(component, event, helper) {
    var toastEvent = $A.get("e.force:showToast");
    toastEvent.setParams({
        "type": "error",
        "message": "Company Off-Limit",
        "mode":"sticky"
    });
    toastEvent.fire();
},
    
    getContact :function(component,event,helper){
        var recordId = component.get("v.recordId");
        var action = component.get("c.getCompanyOffLimit");
        action.setParams({recordId : recordId});
        action.setCallback(this,$A.getCallback(function(response){
            var state= response.getState();
            if(state=="SUCCESS")
            {
                component.set("v.offlimit",response.getReturnValue());
            }
            else if(state=="ERROR")
            {
                alert("Error");
            }
            
     /*    var compol = component.get("v.companyol");
            if(compol = "true")
            {
                var companyToastEvent = $A.get("e.force:showToast");
                companyToastEvent.setParams({
                    title : 'company off limit',
                    Message : 'Company Off-Limit',
                    type:' error',
                    mode: 'sticky'
                })
            }*/
            
        }));
        
      /*  var action1 = component.get("c.getContactOffLimit");
        action1.setParams({recordId:recordId});
        action1.setCallback(this,$A.getCallback(function(response){
            var state1 = response.getState();
            if(state1=="ERROR")
            {
                component.set("v.contactol",response.getReturnValue());
            }
            
        }))*/
        
      $A.enqueueAction(action);                                         
                                               
    }
})