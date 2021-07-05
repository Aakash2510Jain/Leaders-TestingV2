({
    doInit: function(component, event, helper) {
        debugger;
        helper.handleChange(component,event,helper);
        helper.fetchDataHelper(component,event,helper);
        
    }, 
    
    closeModel: function(component,event,helper){
        var cmpTarget = component.find('Modalbox');
        var cmpBack = component.find('Modalbackdrop');
        $A.util.removeClass(cmpBack,'slds-backdrop--open');
        $A.util.removeClass(cmpTarget, 'slds-fade-in-open'); 
        component.set("v.displaySelfAssesment",false);
    },
    remove: function(component,event,helper) {
        debugger;
        var target = event.target;
        var index = target.getAttribute("data-row-index");
        var id = target.getAttribute("name");
        if(id!=undefined){
            var deleteList = component.get("v.deleteList");
            deleteList.push(id)         ;
            component.set("v.deleteList",deleteList);
        }
        helper.removeValues(component, index);
        
    },
    add: function(component,event,helper) {
        helper.addValues(component);
    },
    
    save: function(component,event,helper) {
        debugger;
        var selectedValues = component.get("v.self_Ass_Values");
        if(selectedValues.length != 0){
            for (var i = 0; i < selectedValues.length; i++) {
                if((selectedValues[i].English__c!= null  && selectedValues[i].English__c.length > 1000 )|| (selectedValues[i].French__c != null  && selectedValues[i].French__c.length > 1000))
                {
                    alert('Please Make sure the character count is not more than One Thousand ');
                    return;
                }
                
            }
            var deleteList = component.get("v.deleteList");
            
            var action = component.get("c.createSelfAssesment");
            action.setParams({selfAssRecList: selectedValues,deleteList:deleteList});
            
            action.setCallback(this,function(response){
                var result = response.getReturnValue();
                debugger;
                if(response.getState() === "SUCCESS"){
                    {
                        swal.fire({
                            title: "Success",
                            text: "Self Assesment Record created",
                            type: "success",
                            timer: 3000,
                            showConfirmButton: false
                        });
                        component.set('v.Self_Ass_Created',true);
                        component.set('v.displaySelfAssesment',false);
                        component.set('v.ButtonClassForSelf','forestGreen');
                    }
                }
            });
            $A.enqueueAction(action);
        }
        else{
            swal.fire({
                title: "error",
                text: "No values selected",
                type: "error",
                timer: 3000,
                showConfirmButton: false
                
            });
        }
    },
})