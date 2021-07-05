({
    getRecordsHelper : function(component, event, searchText,helper) {
        debugger;
        var whereClause='';
        var fieldAPIs = component.get("v.fieldAPIs");
        var objectAPI = component.get("v.objectAPI");
        if(component.get("v.whereClause")!='')
        whereClause = component.get("v.whereClause")+'\'' +component.get("v.clauseValue")  + '\'';
        if(fieldAPIs != undefined && objectAPI != undefined){
            var action = component.get('c.getRecords');
            action.setParams({
                "fieldAPIs" : fieldAPIs,
                "sObjectType" : objectAPI,
                "filter" : searchText,
                "replaceHeaders":component.get("v.replaceHeaders"),
                "whereClause":whereClause
            });
			//"whereClause":component.get("v.whereClause")+'\'' + 'Active' + '\''
            action.setCallback(this, function(response){
                var state = response.getState();
                if( state === 'SUCCESS' && component.isValid()){
                    //component.find("dynamicBody").set("v.body",[]);
                    component.set("v.tableData",response.getReturnValue());
                    if(response.getReturnValue().sObjectData.length==0){
                        component.set("v.noRecordsError","No Records found in Database for this Entry :) ");
                    }
                    //this.renderTable(component,event,helper);
                    
                }
                else{
                    var errors = response.getError();
                    $A.log('Error Details '+errors);
                    if( errors || errors[0].message){
                        console.log('Error Details '+errors[0].message);
                    }
                }
                component.set("v.showSpinner",false);
            });
            $A.enqueueAction(action);
        }
        else{
            //component.set('v.isSending' , false);
        }


    },
    select : function(component, event){
        debugger;
        
        var records = component.get("v.tableData").sObjectData;
        var objectAPI = component.get("v.objectAPI");
        var rec = event.target.name;
        for(var i = 0; i < records.length; i++){
            if(rec == records[i].Id){
                component.set("v.selectedRecord",records[i]);
                break;
            }
        }
            
        var compEvent = component.getEvent("doneEvent");
        compEvent.setParams({"type":objectAPI});  
        compEvent.fire();
    },
    goHelper : function(component, event,helper) {
        var params = event.getParam('arguments');
        if (params) {
            var searchText = params.searchString;
            this.getRecordsHelper(component,event,searchText,helper);
            
        }
    },
    sortBy: function(component, field, cacheSort) {
        debugger;
        var sortAsc = component.get("v.sortAsc"),
            sortField = component.get("v.sortField"),
            records = component.get("v.tableData").sObjectData;
        
        sortAsc = sortField != field || !sortAsc;
        //debugger;
        //Specific sort functionality
        if (field == 'Name' || field =='Company_Name_French__c' || field=='Assignment_Status__c') {
            records.sort(function(a, b) {
                var t1 = a[field] == b[field],
                    t2 = (!a[field] && b[field]) || (a[field] < b[field]);
                return t1 ? 0 : (sortAsc ? -1 : 1) * (t2 ? 1 : -1);
            });
            
        }
        else if(field =='Company__r.Name'){
            
            records.sort(function(a, b) {
                if(a['Company__r'] !=undefined && b['Company__r']!=undefined){
                var t1 = a['Company__r'].Name == b['Company__r'].Name,
                    t2 = (!a['Company__r'].Name && b['Company__r'].Name) || (a['Company__r'].Name < b['Company__r'].Name);
                return t1 ? 0 : (sortAsc ? -1 : 1) * (t2 ? 1 : -1);
                }
            });
            
        }
        else if(field =='Partner__r.Name'){
            records.sort(function(a, b) {
                if(a['Partner__r'] !=undefined && b['Partner__r']!=undefined){
                var t1 = a['Partner__r'].Name == b['Partner__r'].Name,
                    t2 = (!a['Partner__r'].Name && b['Partner__r'].Name) || (a['Partner__r'].Name < b['Partner__r'].Name);
                return t1 ? 0 : (sortAsc ? -1 : 1) * (t2 ? 1 : -1);
                }
            });
        }
        else if(field =='Partner_2__r.Name'){
            records.sort(function(a, b) {
                if(a['Partner_2__r'] !=undefined && b['Partner_2__r']!=undefined){
                    var t1 = a['Partner_2__r'].Name == b['Partner_2__r'].Name,
                    t2 = (!a['Partner_2__r'].Name && b['Partner_2__r'].Name) || (a['Partner_2__r'].Name < b['Partner_2__r'].Name);
                	return t1 ? 0 : (sortAsc ? -1 : 1) * (t2 ? 1 : -1);
                }
                
            });
        }
        
        component.set("v.sortAsc", sortAsc);
        component.set("v.sortField", field);
        component.set("v.tableData.sObjectData", records);
    },
})