({
    
    
    doInit: function(component,event,helper){
        
       var pickvalueState  =localStorage.getItem("Action");
        //alert(getState);
       component.set("v.teamNameFromEvent",pickvalueState);
        
        
        var selectedlist = component.find("myselect").get("v.value");
        component.set("v.selectlist",selectedlist);
        
        helper.myAction(component, event, helper);
    },
    reInit : function(component, event, helper) {
        alert('def');
        $A.get('e.force:refreshView').fire();
    },
    
    onChangeMySelect : function(component,event,helper){
        var selectedlist = component.find("myselect").get("v.value");
        localStorage.setItem("Action", "activeAssignment");
        
        console.log("got the selectedlist"+selectedlist);
        var AssignE = $A.get("e.c:AssignmentListEvent");
        AssignE.setParams({"selectedlist": selectedlist});
        AssignE.fire();  
    },
    
    
})