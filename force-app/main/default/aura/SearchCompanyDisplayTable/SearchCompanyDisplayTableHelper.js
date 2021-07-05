({
    doInitHelper : function(component, event, helper) {
        debugger;
        console.log('AllRecord='+component.get("v.allRecord"));
        component.set("v.totalPages", Math.ceil(component.get("v.allRecord").length/component.get("v.pageSize")));
        
        var sortAsc;
        sortAsc =  !sortAsc;
        var field = 'Name';
        var allData = component.get("v.allRecord");
        
        allData.sort(function(a, b) {
            if(a[field] != undefined && b[field] != undefined){
                var t1 = a[field].toLowerCase() == b[field].toLowerCase(),
                    t2 = (!a[field].toLowerCase() && b[field].toLowerCase()) || (a[field].toLowerCase() < b[field].toLowerCase());
                return t1 ? 0 : (sortAsc ? -1 : 1) * (t2 ? 1 : -1);
            }else{
                if(a[field] == undefined){
                    return 0;
                }else if(b[field] == undefined){
                    return -1;
                }
            }
        });
        
        component.set("v.allData", component.get("v.allRecord"));
        component.set("v.currentPageNumber",1);
        var allData=component.get("v.allRecord");
        console.log("allData="+allData);
        
        
        var custs = [];
        debugger;
        var conts = component.get("v.fieldList");
        var i=0;
        for(var key in conts){
            custs.push({value:conts[key], key:key,sortAsc:true,Id:i}); //Here we are creating the list to show on UI.
            i++;
        }
        component.set("v.fieldMap",custs);
        console.log(component.get("v.fieldMap"));
        console.log('custs='+custs);
        helper.buildData(component, helper);
    },
    buildData : function(component, helper) {
        debugger;
        var data = [];
        var pageNumber = component.get("v.currentPageNumber");
        var pageSize = component.get("v.pageSize");
        var allData = component.get("v.allData");
        var x = (pageNumber-1)*pageSize;
        
        console.log(allData);
        //creating data-table data
        for(; x<(pageNumber)*pageSize; x++){
            if(allData[x]){
                data.push(allData[x]);
            }
        }
        
        var sortAsc;
        sortAsc =  !sortAsc;
        var field = 'Name';
        data.sort(function(a, b) {
            if(a[field] != undefined && b[field] != undefined){
                var t1 = a[field].toLowerCase() == b[field].toLowerCase(),
                    t2 = (!a[field].toLowerCase() && b[field].toLowerCase()) || (a[field].toLowerCase() < b[field].toLowerCase());
                return t1 ? 0 : (sortAsc ? -1 : 1) * (t2 ? 1 : -1);
            }else{
                if(a[field] == undefined){
                    return 0;
                }else if(b[field] == undefined){
                    return -1;
                }
            }
        });
        
        component.set("v.data", data);
        helper.generatePageList(component, pageNumber);
    },
    /*
     * this function generate page list
     * */
    generatePageList : function(component, pageNumber){
        pageNumber = parseInt(pageNumber);
        var pageList = [];
        var totalPages = component.get("v.totalPages");
        if(totalPages > 1){
            if(totalPages <= 10){
                var counter = 2;
                for(; counter < (totalPages); counter++){
                    pageList.push(counter);
                } 
            } else{
                if(pageNumber < 5){
                    pageList.push(2, 3, 4, 5, 6);
                } else{
                    if(pageNumber>(totalPages-5)){
                        pageList.push(totalPages-5, totalPages-4, totalPages-3, totalPages-2, totalPages-1);
                    } else{
                        pageList.push(pageNumber-2, pageNumber-1, pageNumber, pageNumber+1, pageNumber+2);
                    }
                }
            }
        }
        component.set("v.pageList", pageList);
    },
    sortByFieldHelper:function(component, event, helper){
        debugger;
        var sortAsc;
        var fielddesc= event.currentTarget.name;
        var PeopleObject= component.get("v.PeopleObject");
        var AssObject= component.get("v.AssObject");
        var fieldsMap=component.get("v.fieldMap");
        
        for(var i=0;i<fieldsMap.length;i++){
            if(fieldsMap[i].Id ==fielddesc.Id ){
                sortAsc = fieldsMap[i].sortAsc;
                fieldsMap[i].sortAsc = !sortAsc;
            }
        }
        var sortField = fielddesc.value;
        var field = fielddesc.value;
        
        sortAsc = PeopleObject.sortAsc;
        PeopleObject.sortAsc = !sortAsc;
        
        sortAsc = AssObject.sortAsc;
        AssObject.sortAsc = !sortAsc;
        
        var data = component.get("v.data");
        var allData = component.get("v.allRecord");
        sortAsc =  !sortAsc;
        
        if(field == 'Total_Ass__c'){
            var value = component.get("v.BooleanValueAss");
            if(value == true){
                component.set("v.BooleanValueAss",false);
            }else{
                component.set("v.BooleanValueAss",true);
            }
        }else if(field == 'Total_Contacts__c'){
            var value = component.get("v.BooleanValuePeople");
            if(value == true){
                component.set("v.BooleanValuePeople",false);
            }else{
                component.set("v.BooleanValuePeople",true);
            }
        }
        
        if(field == 'Total_Contacts__c'||field == 'Total_Ass__c'){
            
            data.sort(function(a, b) {
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
        
        allData.sort(function(a, b) {
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
            
        }else{
            data.sort(function(a, b) {
            if(a[field] != undefined && b[field] != undefined){
                var t1 = a[field].toLowerCase() == b[field].toLowerCase(),
                    t2 = (!a[field].toLowerCase() && b[field].toLowerCase()) || (a[field].toLowerCase() < b[field].toLowerCase());
                return t1 ? 0 : (sortAsc ? -1 : 1) * (t2 ? 1 : -1);
            }else{
                if(a[field] == undefined){
                    return 0;
                }else if(b[field] == undefined){
                    return -1;
                }
            }
        });
        
        allData.sort(function(a, b) {
            if(a[field] != undefined && b[field] != undefined){
            var t1 = a[field].toLowerCase() == b[field].toLowerCase(),
                t2 = (!a[field].toLowerCase() && b[field].toLowerCase()) || (a[field].toLowerCase() < b[field].toLowerCase());
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
        
        
        
        component.set("v.data",data);
        component.set("v.allRecord",allData);
        component.set("v.PeopleObject",PeopleObject);
        component.set("v.AssObject",AssObject);
        component.set("v.fieldMap",fieldsMap);
    },
    handleViewAllEventHelper:function(component, event, helper){
        debugger;
        component.set("v.checkSpinner",true);
        var isTrue = event.getParam("isTrue");
        component.set("v.clickedViewAll",isTrue);
        setTimeout(function(){ 
            debugger;
            if(component.get("v.checkSpinner")==true){
                component.set("v.checkSpinner",false);
            }
        }, 3000);
        
        
    },
    onCheckHelper:function(component, event, helper){
        debugger;
        var records=event.getSource().get("v.text");
        var selectedRecord=[];
        selectedRecord=component.get("v.selectedRecord");
        var checkBoolean=event.getSource().get("v.value");
        if(checkBoolean==true){
            selectedRecord.push(records);          
        }else{
            //selectedRecord.pop(records);   
            selectedRecord.splice(selectedRecord.indexOf(records),1);
        }
        component.set("v.selectedRecord",selectedRecord); 
        console.log('selectedRecord'+selectedRecord);
    },
    
})