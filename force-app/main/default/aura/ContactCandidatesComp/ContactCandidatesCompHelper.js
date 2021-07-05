({
	helperMethod : function() {
		
	},
    
    getRelatedAssignments: function(component,event,helper)
    {
        var action = component.get("c.getRelatedAssignmentRec");
        action.setParams({
            'recordId' : component.get("v.recordId")
        });
        action.setCallback(this,$A.getCallback(function(response){
            var state = response.getState();
            
            if(state=="SUCCESS"){
                component.set("v.mydata",response.getReturnValue());
                component.set("v.spinner",false);
            }
            else if(state=="ERROR"){
                var error = response.getError();
                console.error(errors);
                component.set("v.spinner",false);
            }
            
        }));
            
     $A.enqueueAction(action);
    },
        getAllNotes:function(component,event,helper){
      debugger;
                var getAllMeetingNotes = component.get("c.getAllMeetingNotes");
        getAllMeetingNotes.setCallback(this,$A.getCallback(function(response){
            var state = response.getState();
            
            if(state=="SUCCESS"){
                component.set("v.MeetingNotesMap",response.getReturnValue());
                component.set("v.spinner",false);
               
            }
            else if(state=="ERROR"){
                var error = response.getError();
                console.error(errors);
                component.set("v.spinner",false);
            }
            
        }));
            
     $A.enqueueAction(getAllMeetingNotes);

    },

    
})