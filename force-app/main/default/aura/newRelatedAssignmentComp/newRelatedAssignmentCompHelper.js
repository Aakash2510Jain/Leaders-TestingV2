({
	helperMethod : function() {
		
	},
    
    fetchOrigin: function(component,event,helper)
    {
        var action = component.get("c.getPicklistValues");
        action.setParams({
            objectType : 'Application__c',
            selectedField : 'Origin__c'
        });
            
            action.setCallback(this,function(response){
            var list = response.getReturnValue();
            
            component.set("v.origin",list);     
        })
            $A.enqueueAction(action);
    },
    
    fetchSSL : function(component,event,helper)
    {
        var action = component.get("c.getPicklistValues");
        action.setParams({
            objectType : 'Application__c',
            selectedField : 'Status_Summary_Line__c'
        });
        
        action.setCallback(this,function(response){
            var list = response.getReturnValue();
            component.set("v.SSLValues",list);
            
        })
    	$A.enqueueAction(action);
    },
    
    fetchAssignmentName : function(component,event,helper)
    {
        var action = component.get("c.getAssignmentName");
        action.setParams({
            mandateId : component.get("v.mandateRecId")
        });
        
        action.setCallback(this,function(response){
            var assignName = response.getReturnValue();
            
            
            component.set("v.AssignName",assignName);
            console.log(assignName);
            
           var mName = component.get("v.AssignName").Name ;
            console.log(mName);
            
        })
        
        $A.enqueueAction(action);
    },
    
    helperSave : function(component,event,helper)
    {
        var action = component.get("c.save");
        action.setParams({
            pId : component.get("v.peopleId"),
            mId : component.get("v.mandateRecId"),
            Origin : component.get("v.OriginValue"),
            SSL :  component.get("v.SSLValue"),
            Description : component.get("v.Description")
        });
        
        action.setCallback(this,function(response){
            var can = response.getReturnValue();
            var state = response.getState();
          /*  if(state === "SUCCESS"){
                helper.handleShowToast(component,event,helper)
            }*/
            
            component.set("v.candidate",can);
            console.log(can);
        })
        
        $A.enqueueAction(action);
    },
    
    handleShowToast : function(component,event,helper)
    {
        component.find("notifLib").showToast({
            "variant" : 'success',
            "mode" : 'pester', 
            "duration" : 3000,
        	"title": "Success",
        	"message": "The record created successfully."        
        });
	}
    
})