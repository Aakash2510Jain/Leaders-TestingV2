({
    
    doEvent : function(component,event,helper){
        var canId = event.getParam("candidateId");
        console.log(canId);
        component.set("v.candidateId",canId);
        component.find("SSL").set("v.value","Test SSSL");
    },
    
    
    doInit : function(component,event,helper){
        debugger;
        component.set("v.checkSpinner", true);
        var canid = component.get("v.candidateId");
        var abc = component.get("v.mandateId");
        helper.fetchSSL(component,event,helper);
        helper.fetchLRN(component,event,helper);
        helper.getRelatedAssignments(component,event,helper);
        helper.fetchCompetencies(component,event,helper);
        helper.viewNotes(component,event,helper);
       // component.set("v.checkSpinner", false);
        
    },
    viewNotes:function(component,event,helper){
        debugger;
        component.set("v.Spinner", true);
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
                if(response.getReturnValue().length > 0){
                    component.set("v.NotesLists",response.getReturnValue());
                    component.set("v.noNotesFromOtherAss",true);
                    component.set("v.Spinner", false);
                    //component.set("v.checkSpinner", false);
                }
            }
            else if(state=="ERROR"){
                var error = response.getError();
                console.error(errors);
                component.set("v.Spinner", false);
                //component.set("v.checkSpinner", false);
            }
        }));
        $A.enqueueAction(getAllNotes);
        component.set("v.isView",true);
        component.set("v.Spinner", false);
        //component.set("v.checkSpinner", false);
    },
    addNotes:function(component,event,helper){
        debugger;
        var notes = component.get("v.SelectedNotes");
        var boolean = event.getSource().get("v.value");
        if(boolean == true){
            var note = event.getSource().get("v.name");
            notes.push(note);
             var energy = notes.join(" <br/> ");
            component.set("v.SelectedNotes",energy);
        }
        else{
            var notevalue   = component.get("v.NotesLists");
            for (var i = 0; i < notevalue.length; i++) {
                if(notevalue.includes(notevalue[i].Description__c))
                {
                    const index = selectedcomp.indexOf(comp);
                    notevalue.splice(index, 1);
                }
            }
            component.set("v.SelectedNotes",notevalue);
        }
    },
    selectAll:function(component,event,helper){
        var selectedHeaderCheck = event.getSource().get("v.value");
        component.set("v.SelectedallNotes",true);
        var getAllId = component.find("TheCheckBox");
        
        if (!Array.isArray(getAllId)) {
            if (selectedHeaderCheck == true) {
                component.set("v.SelectedallNotes",true);
                component.find("TheCheckBox").set("v.value", true);
            } else {
                component.find("TheCheckBox").set("v.value", false);
               }
        } else {
            if (selectedHeaderCheck == true) {
                for (var i = 0; i < getAllId.length; i++) {
                    component.find("TheCheckBox")[i].set("v.value", true);
                 }
            } else {
                for (var i = 0; i < getAllId.length; i++) {
                    component.find("TheCheckBox")[i].set("v.value", false);
                 }
            }
        }
       
    },
    saveNotes:function(component,event,helper){
        debugger;
        if(component.get("v.SelectedallNotes") == true){
            var notes = [];
            var existingNotes = component.get("v.leaderNote.Description__c");
            if(existingNotes != undefined && existingNotes.length > 0){
                notes.push(existingNotes);    
            }
            
            var notevalue   = component.get("v.NotesLists");
            for (var i = 0; i < 1; i++) {
                notes.push(notevalue[i].Description__c); 
            }
            var energy = notes.join(" <br/> ");
            component.set("v.leaderNote.Description__c",energy);
            component.set("v.isView",false);
        }else{
            var existingNotes = component.get("v.leaderNote.Description__c");
            var notevalue = component.get("v.SelectedNotes");
            var notes = [];
            if(existingNotes != undefined && existingNotes.length > 0){
                notes.push(existingNotes);    
            }
            notes.push(notevalue);
            var energy = notes.join(" <br/> ");
            component.set("v.leaderNote.Description__c",energy);
            component.set("v.isView",false);
        }
        
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
            }
            else if(state=="ERROR"){
                var error = response.getError();
                console.error(errors);
            }
        }));
        
        $A.enqueueAction(getAllMeetingNotes);
        
    },
    deleteNoteFromOtherAss : function(component,event,helper){
        debugger;
        //component.set("v.displayWarning",true);
        //var noteId = event.getSource().get("v.value");
        var noteId = component.get("v.notesId");
        var NotesLists = component.get("v.NotesLists");
        for (var i = 0; i < NotesLists.length; i++) {
            if(NotesLists[i].Id == noteId ){
                NotesLists.splice(i, 1);
            }
        }
        component.set("v.NotesLists",NotesLists);
        component.set("v.displayWarning",false);
        var getAllMeetingNotes = component.get("c.deleteMeetingNote");
        getAllMeetingNotes.setParams({
            'noteId' : noteId
        });
        
        getAllMeetingNotes.setCallback(this,$A.getCallback(function(response){
            var state = response.getState();
            
            if(state=="SUCCESS"){
            }
            else if(state=="ERROR"){
                var error = response.getError();
                console.error(errors);
            }
        }));
        
        $A.enqueueAction(getAllMeetingNotes);
        
    },
    closeWarning: function(component,event,helper){
        component.set("v.displayWarning",false);
    },
    showWarning: function(component,event,helper){
        var noteId = event.getSource().get("v.value");
        component.set("v.notesId",noteId);
        component.set("v.displayWarning",true);
    },
    setCandidateId : function(component,event,helper){
        var canId = event.getParam("candidateId");
        console.log(canId);
        component.set("v.candidateId",canId);
    },
    
    closeModel: function(component,event,helper){
        var cmpTarget = component.find('Modalbox');
        var cmpBack = component.find('Modalbackdrop');
        $A.util.removeClass(cmpBack,'slds-backdrop--open');
        $A.util.removeClass(cmpTarget, 'slds-fade-in-open'); 
        component.set("v.openLRNComp",false);
        component.set("v.openEditLRNComp",false);
    },
    closeModal: function(component,event,helper){
        component.set("v.isView",false);
    },
    
    saveLRN : function(component,event,helper){
        
        helper.saveLeadersNote(component,event,helper);
        helper.saveCompetencyResponse(component,event,helper);
        
    },
    openFinalAcceptanceDialogue: function(component,event,helper){
        debugger;
        if(component.get("v.selectedValue")=='Final candidate, has accepted the offer of employment.'){
            //component.set("v.showConfirmDialog",true);
            //Prinz changes here 04/03/2020
            $A.createComponent(
                "c:LRNConfirmationComponent",
                {
                    "message":"This Candidate will now be off limit. Please update employment information(Company Name and Title)."
                },
                function(msgBox){                
                    if (component.isValid()) {
                        var targetCmp = component.find('ModalDialogPlaceholder');
                        var body = targetCmp.get("v.body");
                        body.push(msgBox);
                        targetCmp.set("v.body", body); 
                    }
                });
            
        }
    },
    handleConfirmDialogNo: function(component,event,helper){
        component.set("v.showConfirmDialog",false);
    }
    
})