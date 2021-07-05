({
    doInit: function(component,event,helper){
        
        /*debugger;
        var action = component.get("c.getUserTeamByTeam");
        action.setCallback(this, $A.getCallback(function(response){
            
            var state= response.getState();
            
            var result = response.getReturnValue();    
            if(state=="SUCCESS"){
                if(result == 'The Montreal Team')
                {
                    component.set("v.selectedValue", "Montreal Weekly Review");
                    helper.getMontrealreview(component,event,helper);   
                }
                else if(result == 'Ottawa Team')
                {
                    debugger;
                    component.set("v.selectedValue", "Ottawa Weekly Review");
                    helper.getOttawareview(component,event,helper);
                    
                }
                    else if(result == 'Toronto Team')
                    {
                        component.set("v.selectedValue", "Toronto Weekly Review");
                        helper.getTorontoreview(component,event,helper); 
                    }
                        else{
                            component.set("v.selectedValue", "Montreal Weekly Review");
                            helper.getMontrealreview(component,event,helper); 
                            
                        }
                
            }
            
        }
       ));
        
        $A.enqueueAction(action);*/
        //helper.displayAssignmentLists(component, event, helper);
        
    },   
    sortByName: function(component, event, helper) {
        debugger;
        
        var sortAsc = component.get("v.sortAsc");
        var sortField = event.currentTarget.getAttribute('data-sortAttType');
        component.set("v.sortAsc", sortAsc);
        component.set("v.sortField", sortField);
        
        console.log('sortAsc'+event.currentTarget.getAttribute('data-sortAttType'));
        helper.sortBy(component, event.currentTarget.getAttribute('data-sortAttType'), true);
    },
    handleClick:function(component,event,helper){
        
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
        
        helper.navigateAssignment(component,event,helper);
        
        
        /* var navService = component.find("navService");
        var pageReference1 = component.get("v.pageReference");
        event.preventDefault();
        navService.navigate(pageReference1);*/
    },
    viewNotes:function(component,event,helper){
        var recId = event.currentTarget.id;
        var selectedItem = event.currentTarget
        //var recId = selectedItem.dataset.record;
        console.log(recId);
        
        var pageReference={
            type: 'standard__component',
            attributes: {
                componentName:'c__AssignmentProcessNotes'
            },
            state:{
                //  "c__mandateId": "a010B00001cUIfJQAW"
                "c__mandateId": recId,
                "c__teamName": component.get("v.TeamName")
            }    
        };        
        component.set("v.pageReference",pageReference);
        
        helper.navigateAssignment(component,event,helper);
        
        
    },
    
    displayAssignmentLists:function(component,event,helper){
        var selectedlist = event.getParam("selectedlist");
        console.log("Received component event"+selectedlist);
        
        
        if(selectedlist == "My Active Assignments")
        {debugger;
         helper.showSpinner(component);
         helper.getDefaultAssignments(component,event,helper);
        }  
        
        else if (selectedlist == "My Assignments")
        {
            helper.showSpinner(component);
            helper.getMyAssignments(component,event,helper);
        }
        
            else if(selectedlist=="All Active Assignments") 
            {
                helper.showSpinner(component);
                helper.getAllActiveAssignments(component,event,helper);
            }
                else if(selectedlist=="All Assignments") 
                {
                    helper.showSpinner(component);
                    helper.getAllAssignments(component,event,helper)
                }
                    else if(selectedlist == "Montreal Weekly Review" )
                    {
                        debugger;
                        helper.showSpinner(component);
                        helper.getMontrealreview(component,event,helper);
                    }   
                        else if(selectedlist == "Ottawa Weekly Review" )
                        {
                            debugger;
                            helper.showSpinner(component);
                            helper.getOttawareview(component,event,helper);
                        }   
                            else if(selectedlist == "Toronto Weekly Review" )
                            {
                                debugger;
                                helper.showSpinner(component);
                                helper.getTorontoreview(component,event,helper);
                            }   
                                else if(selectedlist == "Indegenous Weekly Review")
                                {debugger;
                                 helper.showSpinner(component);
                                 helper.getIndigenousreview(component,event,helper);
                                } 
    },
    
    handleOpenModal: function(component, event, helper) {
        //For Display Modal, Set the "openModal" attribute to "true"
        
    },
    
    handleCloseModal: function(component, event, helper) {
        //For Close Modal, Set the "openModal" attribute to "fasle"  
        component.set("v.openModal", false);
    },
    
})