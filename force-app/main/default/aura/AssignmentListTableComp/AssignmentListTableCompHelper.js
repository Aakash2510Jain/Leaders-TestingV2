({
    
    getDefaultAssignments : function(component,event,helper) {
        
        var action = component.get("c.getDefaultValues");
        action.setCallback(this, $A.getCallback(function(response){
            var state= response.getState();
            
            if(state=="SUCCESS"){
                component.set("v.mydata",response.getReturnValue());
                component.set("v.Num_Of_Ass",response.getReturnValue().Num_of_Ass);
                component.set("v.Avg_Of_Num_OF_Days",response.getReturnValue().Avg_of_ass);
                helper.hideSpinner(component);
                console.error(response.getReturnValue().Num_of_Ass);
                
                
            }else if (state=="ERROR"){
                var errors = response.getError();
                console.error(errors);
            }
            
        } ));
        $A.enqueueAction(action);
    },
    
    getMyAssignments : function(component,event,helper){
        
        var action = component.get("c.getMyAssignmentValues");
        action.setCallback(this,$A.getCallback(function(response){
            var state = response.getState();
            
            if(state== "SUCCESS"){
                component.set("v.mydata",response.getReturnValue());
                component.set("v.Num_Of_Ass",response.getReturnValue().Num_of_Ass);
                component.set("v.Avg_Of_Num_OF_Days",response.getReturnValue().Avg_of_ass);
                
                helper.hideSpinner(component);
                
            }else if(state=="ERROR"){
                var errors = response.getError();
                console.error(errors);
            }
        }));
        $A.enqueueAction(action);
    },
    
    getMontrealreview : function(component,event,helper){
        
        debugger;
        var action = component.get("c.getAllAssignmentByTeam");
        
        action.setParams({ teamName : 'The Montreal Team' });
        
        action.setCallback(this,$A.getCallback(function(response){
            var state = response.getState();
            
            if(state== "SUCCESS"){
                component.set("v.mydata",response.getReturnValue());
                component.set("v.Num_Of_Ass",response.getReturnValue().Num_of_Ass);
                component.set("v.Avg_Of_Num_OF_Days",response.getReturnValue().Avg_of_ass);
                
                helper.hideSpinner(component);
                
                
            }else if(state=="ERROR"){
                var errors = response.getError();
                console.error(errors);
            }
        }));
        $A.enqueueAction(action);
    },
    getOttawareview : function(component,event,helper){
        
        debugger;
        var action = component.get("c.getAllAssignmentByTeam");
        
        action.setParams({ teamName : 'Ottawa Team' });
        
        action.setCallback(this,$A.getCallback(function(response){
            var state = response.getState();
            
            if(state== "SUCCESS"){
                component.set("v.mydata",response.getReturnValue());
                component.set("v.Num_Of_Ass",response.getReturnValue().Num_of_Ass);
                component.set("v.Avg_Of_Num_OF_Days",response.getReturnValue().Avg_of_ass);
                
                helper.hideSpinner(component);
                
                
            }else if(state=="ERROR"){
                var errors = response.getError();
                console.error(errors);
            }
        }));
        $A.enqueueAction(action);
    },
    
    getTorontoreview : function(component,event,helper){
        debugger;
        var action = component.get("c.getAllAssignmentByTeam");
        
        action.setParams({ teamName : 'Toronto Team' });
        
        action.setCallback(this,$A.getCallback(function(response){
            var state = response.getState();
            
            if(state== "SUCCESS"){
                component.set("v.mydata",response.getReturnValue());
                component.set("v.Num_Of_Ass",response.getReturnValue().Num_of_Ass);
                component.set("v.Avg_Of_Num_OF_Days",response.getReturnValue().Avg_of_ass);
                
                helper.hideSpinner(component);
                
                
            }else if(state=="ERROR"){
                var errors = response.getError();
                console.error(errors);
            }
        }));
        $A.enqueueAction(action);
    },
     getIndigenousreview : function(component,event,helper){
        debugger;
        var action = component.get("c.getAllAssignmentByTeam");
        
        action.setParams({ teamName : 'Indigenous Team' });
        
        action.setCallback(this,$A.getCallback(function(response){
            var state = response.getState();
            
            if(state== "SUCCESS"){
                component.set("v.mydata",response.getReturnValue());
                component.set("v.Num_Of_Ass",response.getReturnValue().Num_of_Ass);
                component.set("v.Avg_Of_Num_OF_Days",response.getReturnValue().Avg_of_ass);
                
                helper.hideSpinner(component);
                
                
            }else if(state=="ERROR"){
                var errors = response.getError();
                console.error(errors);
            }
        }));
        $A.enqueueAction(action);
    },
    
    
    getAllActiveAssignments : function(component,event,helper){
        
        var action = component.get("c.getAllActiveAssignmentValues");
        
        action.setParams({ value : event.getParam("selectedlist") });
        
        action.setCallback(this,$A.getCallback(function(response){
            var state = response.getState();
            
            if(state=="SUCCESS"){
                component.set("v.mydata",response.getReturnValue());
                component.set("v.Num_Of_Ass",response.getReturnValue().Num_of_Ass);
                component.set("v.Avg_Of_Num_OF_Days",response.getReturnValue().Avg_of_ass);
                
                helper.hideSpinner(component);
                
            } else if(state=="ERROR"){
                var errors = response.getError();
                console.error(errors);
                
            }
        }));
        $A.enqueueAction(action);
    },
    
    getAllAssignments :function(component,event,helper){
        
        var action = component.get("c.getAllAssignmentValues");
        action.setCallback(this,$A.getCallback(function(response){
            var state= response.getState();
            
            if(state=="SUCCESS"){
                component.set("v.mydata",response.getReturnValue());
                component.set("v.Num_Of_Ass",response.getReturnValue().Num_of_Ass);
                component.set("v.Avg_Of_Num_OF_Days",response.getReturnValue().Avg_of_ass);
                
                helper.hideSpinner(component);
                
                
            }else if(state=="ERROR"){
                var errors = response.getError();
                console.error(errors);
            }       
        }));
        
        $A.enqueueAction(action)
    },
    
    navigateAssignment : function(component,event,helper){
        
        var navService = component.find("navService");
        var pageReference = component.get("v.pageReference");
        //event.preventDefault();
        navService.navigate(pageReference);
    },
    viewNoteshelper : function(component,event,helper){
        
        debugger;
        
        // var selectedItem = event.currentTarget;
        
        var recId = event.currentTarget.id;
        console.log(recId);
        
        var action = component.get("c.getAllNotes");
        
        action.setParams({ RecId : recId });
        
        action.setCallback(this,$A.getCallback(function(response){
            var state= response.getState();
            
            if(state=="SUCCESS"){
                console.log(response.getReturnValue());
                component.set("v.myNotes",response.getReturnValue());
                helper.hideSpinner(component);
                
                
            }else if(state=="ERROR"){
                var errors = response.getError();
                console.error(errors);
            }       
        }));
        
        $A.enqueueAction(action)
        
    },
    showSpinner: function (component, event, helper) {
        debugger;
        var spinner = component.find("mySpinner");
        $A.util.removeClass(spinner, "slds-hide");
    },
    
    hideSpinner: function (component, event, helper) {
        debugger;
        var spinner = component.find("mySpinner");
        $A.util.addClass(spinner, "slds-hide");
    },
    sortBy: function(component, field, cacheSort) {
        debugger;
        
        var sortAsc = component.get("v.sortAsc");
        var sortAsc_1 = component.get("v.sortAsc_1");
        var sortAsc_2 = component.get("v.sortAsc_2");
        
        var sortField = component.get("v.sortField");
        
        
        var finalRecordsList = component.get("v.mydata.lstAssignments");
        console.log('finalRecordsList'+finalRecordsList['Assignment_Name']);
        
        sortAsc = sortField != field || !sortAsc;
        sortAsc_1 = sortField != field || !sortAsc_1;
        sortAsc_2 = sortField != field || !sortAsc_2;
        
        if (field == 'Assignment_Status__c'  ) {
            
            finalRecordsList.sort(function(a, b) {
                if(a[field] != undefined && b[field] != undefined){
                    var t1 = a[field] == b[field],
                        t2 = (!a[field] && b[field]) || (a[field] < b[field]);
                    return t1 ? 0 : (sortAsc ? -1 : 1) * (t2 ? 1 : -1);
                }else{
                    if(a[field] == undefined){
                        return 0;
                    }else if(b[field] == undefined){
                        return -1;
                    }
                }
                
            });
            
        }
        if (field == 'Module__c'  ) {
            finalRecordsList.sort(function(a, b) {
                if(a[field] != undefined && b[field] != undefined){
                var t1 = a[field] == b[field],
                    t2 = (!a[field] && b[field]) || (a[field] < b[field]);
                return t1 ? 0 : (sortAsc ? -1 : 1) * (t2 ? 1 : -1);
                }else{
                    if(a[field] == undefined){
                        return 0;
                    }else if(b[field] == undefined){
                        return -1;
                    }
                }
            });
        }
        
        
        if (field == 'Company__r.Name'  ) {
            field = 'Company_Name_French__c';
            finalRecordsList.sort(function(a, b) {
                if(a.Company__r != undefined && b.Company__r != undefined) {
                    var t1 = a[field].toLowerCase() == b[field].toLowerCase(),
                        t2 = (!a[field].toLowerCase() && b[field].toLowerCase() || (a[field].toLowerCase() < b[field].toLowerCase()));
                    return t1 ? 0 : (sortAsc ? -1 : 1) * (t2 ? 1 : -1);
                    
                }else{
                    if(a.Company__r == undefined){
                        //alert(a.Name);
                        return 0;
                    }else if(b.Company__r == undefined){
                        return -1;
                    }
                }
            });
        }
        if ( field == 'Name' ) {
            finalRecordsList.sort(function(a, b) {
                if(a[field] != undefined && b[field] != undefined){
                     var t1 = a[field] == b[field],
                    t2 = (!a[field] && b[field]) || (a[field] < b[field]);
                return t1 ? 0 : (sortAsc ? -1 : 1) * (t2 ? 1 : -1);
                }
                else{
                    if(a[field] == undefined){
                        return 0;
                    }else if(b[field] == undefined){
                        return -1;
                    }
                }
            });
        }
        if (field == 'number_of_days__c'  ) {
            finalRecordsList.sort(function(a, b) {
                if(a[field] != undefined && b[field] != undefined){
                    var t1 = a[field] == b[field],
                        t2 = (!a[field] && b[field]) || (a[field] < b[field]);
                    return t1 ? 0 : (sortAsc ? -1 : 1) * (t2 ? 1 : -1);
                }else{
                    if(a[field] == undefined){
                        return 0;
                    }else if(b[field] == undefined){
                        return -1;
                    }
                }
            });
        }
        component.set("v.sortAsc", sortAsc);
        component.set("v.sortAsc_1", sortAsc_1);
        component.set("v.sortAsc_2", sortAsc_2);
        component.set("v.sortField", sortField); 
        component.set("v.mydata.lstAssignments", finalRecordsList);
    }
})