({
    doInit: function(component, event, helper) {
        component.set("v.spinner",true);
        helper.getRelatedAssignments(component,event,helper);
        helper.getAllNotes(component,event,helper);
        //helper.getAllNotesfromAllAss(component,event,helper);
    },
    
    openNewLRN : function(component,event,helper){
        component.set("v.openEditLRNComp",false);
        component.set("v.openLRNComp",true);
        debugger;
        var canId = event.getSource().get("v.value");
        console.log(canId);
        component.set("v.canId",canId);
        
        var LRNEvent = $A.get("e.c:NewLRNCompEvent");
        LRNEvent.setParams({
            "contactCandidateId" : canId
        });
        LRNEvent.fire();
        
        var childComponent = component.find("newLRN");
        childComponent.callChildInit(component.get("v.canId"));
    },
    openEditNewLRN : function(component,event,helper){
        debugger;
        component.set("v.openLRNComp",false);
        component.set("v.openEditLRNComp",true);
        var canId = event.getSource().get("v.value");
        console.log(canId);
        component.set("v.canId",canId);
        var LRNEvent = $A.get("e.c:NewLRNCompEvent");
        LRNEvent.setParams({
            "contactCandidateId" : canId
        });
        LRNEvent.fire();
        var childComponent = component.find("editLRN");
        childComponent.callChildInit(component.get("v.canId"));
        
        console.log(" In the openEditNewLRN")
    },
    
    deleteNote : function(component,event,helper){
        debugger;
        var noteId = event.getSource().get("v.value");
        
        var noteList = component.get("v.NotesList");
        
        for (var i = 0; i < noteList.length; i++) {
            if(noteList[i].Id == noteId ){
                noteList.splice(i, 1);
            }
        }
         
        component.set("v.NotesList",noteList);
        var getAllMeetingNotes = component.get("c.deleteMeetingNote");
        getAllMeetingNotes.setParams({
            'noteId' : noteId
        });
        
        getAllMeetingNotes.setCallback(this,$A.getCallback(function(response){
            var state = response.getState();
            
            if(state=="SUCCESS"){
             /*   swal.fire({
                    title: "success",
                    text: "This Note is Deleted",
                    type: "Success",
                    timer: 3000
                }); */
            }
            else if(state=="ERROR"){
                var error = response.getError();
                console.error(errors);
            }
        }));
        
        $A.enqueueAction(getAllMeetingNotes);
        
    },
    
    handleClick: function(component,event,helper){
        var selectedItem = event.currentTarget
        var recId = selectedItem.dataset.record;
        console.log(recId);
        
        var pageReference={
            type: 'standard__component',
            attributes: {
                componentName:'c__AssignmentCandidatesPageComp'
            },
            state:{
                //  "c__mandateId": "a010B00001cUIfJQAW"
                "c__mandateId": recId
            }    
        };        
        component.set("v.pageReference",pageReference);
        
        //helper.navigateAssignment(component,event,helper);
        
        var navService = component.find("navService");
        var pageReference = component.get("v.pageReference");
        event.preventDefault();
        navService.navigate(pageReference);
    },
    viewNotes:function(component,event,helper){
        debugger;
        var ApplicationID=event.getSource().get("v.value");
        var companyname=event.getSource().get("v.title");
        var name=event.getSource().get("v.name");
        var header  = name+'-'+companyname;
        component.set("v.notesTitle", header);
        var getAllNotes = component.get("c.getAllNotes");
        getAllNotes.setParams({
            contactAssigned : ApplicationID
        });
        getAllNotes.setCallback(this,$A.getCallback(function(response){
            var state = response.getState();
            
            if(state=="SUCCESS"){
                component.set("v.NotesList",response.getReturnValue());
            }
            else if(state=="ERROR"){
                var error = response.getError();
                console.error(errors);
            }
        }));
        $A.enqueueAction(getAllNotes);
        component.set("v.isView",true);
    },
    closeModel: function(component, event, helper) {
        component.set("v.isView", false);
    },
})