({
    
    doInit : function(component,event,helper){
        if(component.get("v.FromContact") == true)
        {
            helper.getAllFilesForContact(component,event,helper);
        }else{
             helper.getAllFiles(component,event,helper);
        }
       
    },
    
    editAttDetail : function(component, event, helper){
    	helper.editAttDetail(component,event,helper);
    },
    openAttDetail : function(component, event, helper){
        helper.openAttDetail(component,event,helper);
    },
    delAtt : function(component, event, helper){
        component.set("v.deleteWarning",true);
        var actionId = event.target.name;
        component.set("v.AttId",actionId);
     },
    delAttYes : function(component, event, helper){
        debugger;
        helper.delAtt(component, event, helper);
     },
    delAttNo : function(component, event, helper){
        component.set("v.deleteWarning",false);
     },
    
	closeModal : function(component, event, helper) {
		helper.closeModal(component,event);	
	}
})