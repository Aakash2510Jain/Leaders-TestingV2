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
        component.set("v.displayRadar",false);
    },
    remove: function(component,event,helper) {
        debugger;
        var id = event.getSource().get("v.value");
        var index = event.getSource().get("v.title");
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
        var selectedValues = component.get("v.radar_Values");
        var deleteList = component.get("v.deleteList");
        
        var action = component.get("c.createRadarRating");
        action.setParams({RadarList: selectedValues,deleteList:deleteList});
        
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
                    component.set('v.Radar_Rat_Created',true);
                    component.set('v.displayRadar',false);
                    component.set('v.ButtonClassForRR','forestGreen');
                }
            }
        });
        $A.enqueueAction(action);
    },
})