({
    transRecHelper : function(component,event,helper){
        debugger;
        var userId = component.get("v.selItem.val");
        
        var selectedValue =  component.find("object").get("v.value");
        
        if( userId != null && selectedValue != null )
        {
            
            if(selectedValue == 'Assignment')
            {
                var action = component.get("c.runBatchforAssignment");
            }    
            
            else if(selectedValue == 'Company')
            {
                var action = component.get("c.runBatchforAccount");
            }
            else if(selectedValue == 'People')
            {
                var action = component.get("c.runBatchforContact");          
            }
                else
                {
                   alert('Please Select The Object Also');
                   return; 
                }
        }
        else 
        {
            alert('Please Select The User First');
            return;
        }
        
        action.setParams({
            UserId :  userId           
        });
        
        action.setCallback(this,function(response)
                           {  
                               if(response.getState() == 'SUCCESS')   
                               {
                                   alert("Success!!The record has been updated successfully");                 
                               }
                           })
        $A.enqueueAction(action);    
    }  ,
    
    showToast : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "message": "The record has been updated successfully."
        });
        toastEvent.fire();
    },
    
    getInfoHelper: function(component,event,helper){
        debugger;
        var userId = component.get("v.selItem.val");
        
        var selectedValue =  component.find("object").get("v.value");
        
        if( userId != null && selectedValue != null )
        {
            var action = component.get("c.getInfoOfUser");
        }
        else 
        {
            alert('Please Select The User First');
            return;
        }
        action.setParams({
            UserId :  userId           
        });
        
        action.setCallback(this,function(response)
                           {  
                               if(response.getState() == 'SUCCESS')   
                               {
                                   var allcounts = [];
                                   var allobjects = ['Company','People','Assignment'];
                                   for(var i = 0;i <= response.getReturnValue().length;i++)
                                   {
                                       allcounts.push({'object':allobjects[i],'Count': response.getReturnValue()[i] });
                                   }
                                   component.set("v.RecCounts",allcounts);
                                   console.log('The response value is:'+response.getReturnValue());
                               }
                           })
        $A.enqueueAction(action);    
    }  ,
    
    showToast : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "message": "The record has been updated successfully."
        });
        toastEvent.fire();
    },
})