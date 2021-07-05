({
    myAction : function(component, event, helper) {
        
    },
    addRow: function(component, event, helper) {
        
        
        /*var allValid = component.find('req-title').reduce(function (validSoFar, inputCmp) {
            //inputCmp.setCustomValidity("Title is required");
            
            inputCmp.reportValidity();
            return validSoFar && inputCmp.checkValidity();
        }, true);
        if (allValid) {
            alert('All form entries look valid. Ready to submit!');
        } else {
            alert('Please update the invalid form entries and try again.');
        }*/
        
        helper.addRecord(component, event);
    },
    
    //DeaGle~ for validation.
    validateThis : function(component, event, helper){
        debugger;
        var inputCmp = component.find("req-title");
        var valid = true;
        var role = component.get("v.role");
        var validAccount = true;
        if(role == 'experienceList'){
            var oprateList = component.get("v.experienceList");
            oprateList.forEach(function myFunction(item, index) {
                debugger;
                if(Object.keys(item.lookupObj).length == 0){
                    validAccount = false;
                    //break;
                }
            });
            
            
        }else if(role == 'educationList'){
            var oprateList = component.get("v.educationList");
            oprateList.forEach(function myFunction(item, index) {
                debugger;
                if(Object.keys(item.lookupObj).length == 0){
                    validAccount = false;
                    //break;
                }
            });
        }
        else if(role == 'professionalList'){
            var oprateList = component.get("v.professionalList");
            oprateList.forEach(function myFunction(item, index) {
                debugger;
                if(Object.keys(item.lookupObj).length == 0){
                    validAccount = false;
                    //break;
                }
            });
        }else{
            var oprateList = component.get("v.boardList");
            oprateList.forEach(function myFunction(item, index) {
                debugger;
                if(Object.keys(item.lookupObj).length == 0){
                    validAccount = false;
                    //break;
                }
            });
        }
        
        for(var i=0; i< inputCmp.length; i++){
            var value = inputCmp[i].get("v.value");
            
            // Is input empty?
            if (!value) {
                // Set error
               // valid = false;
                //inputCmp[i].setCustomValidity("Title is required"); 
                //inputCmp[i].reportValidity();
            } else {
                // Clear error
                inputCmp[i].setCustomValidity("");
                inputCmp[i].reportValidity();
            }
        }  
        return (validAccount == true && valid == true);
    },
    removeRow: function(component, event, helper) {
        
        debugger;
        var selectedItem = event.currentTarget;
        //Get the selected item index
        var index = selectedItem.dataset.record;
        var idtoDelete = selectedItem.dataset.index;
        
        
        var role = component.get("v.role");
        if(role == 'experienceList'){
            var recordList = component.get("v.experienceList");    
            if(recordList.length>1){
                recordList.splice(index, 1);
                component.set("v.experienceList", recordList);
            }else{
                component.set("v.experienceList",[{"record":{
                    'sobjectType': 'Work_Experience__c',
                    'Company__c': '',
                    'Title__c': '',
                    'Title_FR__c': '',
                    'Start_Year__c': '',
                    'End_Year__c': '',
                    'Current_del__c': '',
                    'RecordTypeId':component.get("v.recordTypeIds")
                },"lookupObj":{}}]
                             );
            }
            
        }else if(role == 'educationList'){
            var recordList = component.get("v.educationList");    
            if(recordList.length>1){
                recordList.splice(index, 1);
                component.set("v.educationList", recordList);
            }else{
                component.set("v.educationList",[{"record":{
                    'sobjectType': 'Work_Experience__c',
                    'Company__c': '',
                    'Title__c': '',
                    'Title_FR__c': '',
                    'Start_Year__c': '',
                    'End_Year__c': '',
                    'Current_del__c': '',
                    'RecordTypeId':component.get("v.recordTypeIds")
                },"lookupObj":{}}]
                             );
            }
        }else if(role == 'professionalList'){
            var recordList = component.get("v.professionalList");    
            if(recordList.length>1){
                recordList.splice(index, 1);
                component.set("v.professionalList", recordList);
            }else{
                component.set("v.professionalList",[{"record":{
                    'sobjectType': 'Work_Experience__c',
                    'Company__c': '',
                    'Title__c': '',
                    'Title_FR__c': '',
                    'Start_Year__c': '',
                    'End_Year__c': '',
                    'Current_del__c': '',
                    'RecordTypeId':component.get("v.recordTypeIds")
                },"lookupObj":{}}]
                             );
            }
        }else if(role == 'boardList'){
            var recordList = component.get("v.boardList");    
            if(recordList.length>1){
                recordList.splice(index, 1);
                component.set("v.boardList", recordList);
            }else{
                component.set("v.boardList",[{"record":{
                    'sobjectType': 'Work_Experience__c',
                    'Company__c': '',
                    'Title__c': '',
                    'Title_FR__c': '',
                    'Start_Year__c': '',
                    'End_Year__c': '',
                    'Current_del__c': '',
                    'RecordTypeId':component.get("v.recordTypeIds")
                },"lookupObj":{}}]
                             );
            }
        }
        else if(role == 'commentList'){
            var recordList = component.get("v.AddCmntList");    
            if(recordList.length>1){
                recordList.splice(index, 1);
                component.set("v.AddCmntList", recordList);
            }else{
                component.set("v.AddCmntList",[{"record":{
                    'sobjectType': 'Work_Experience__c',
                   'Biography_Comments__c':'',
                    'RecordTypeId':component.get("v.recordTypeIds")
                }}]
                             );
            }
        }
        
        if(idtoDelete != undefined){
            var deleteEvent = component.getEvent("deleteEvent");
            deleteEvent.setParams({"IdsTodelete" : idtoDelete });
            deleteEvent.fire();
        }
        
        
    },
})