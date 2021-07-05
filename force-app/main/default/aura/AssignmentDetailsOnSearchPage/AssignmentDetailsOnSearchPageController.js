({
    closeModel : function(component, event, helper) {
        component.set("v.ShowCompPage",false);
        component.set("v.ShowPeopleinfoPage",false);
        component.set("v.ManCompPage",false);
    },
    
    
    handleClickForAss: function(component,event,helper){
        debugger;
        var selectedItem = event.currentTarget
        var recId = selectedItem.dataset.record;
        var basicurl = window.location.hostname;
        
        window.open('https://'+basicurl+'/lightning/cmp/c__AssignmentCandidatesPageComp?c__mandateId='+recId);
    },
    handleClickForPeople: function(component,event,helper){
        debugger;
        var selectedItem = event.currentTarget
        var recId = selectedItem.dataset.record;
        var basicurl = window.location.hostname;
        console.log(recId);
        
        window.open('https://'+basicurl+'/lightning/r/Contact/'+recId+'/view');
    } ,
})