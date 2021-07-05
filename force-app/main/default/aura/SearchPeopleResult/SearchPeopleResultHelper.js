({
    doInitHelper : function(component, event, helper) 
    {
        debugger;
       // console.log('AllRecord='+component.get("v.PeopleRec"));
        component.set("v.totalPages", Math.ceil(component.get("v.PeopleRec").length/component.get("v.pageSize")));
        console.log(component.get("v.PeopleRec").length);
        
        var sortAsc;
        sortAsc =  !sortAsc;
        var field = 'Name';
        var allData = component.get("v.PeopleRec");
        debugger;
        allData.sort(function(a, b) {
            if(a["theContact"][field] != undefined && b["theContact"][field] != undefined){
                var t1 = a["theContact"][field].toLowerCase() == b["theContact"][field].toLowerCase(),
                    t2 = (!a["theContact"][field].toLowerCase() && b["theContact"][field].toLowerCase()) || (a["theContact"][field].toLowerCase() < b["theContact"][field].toLowerCase());
                return t1 ? 0 : (sortAsc ? -1 : 1) * (t2 ? 1 : -1);
            }else{
                if(a["theContact"][field] == undefined){
                    return 0;
                }else if(b["theContact"][field] == undefined){
                    return -1;
                }
            }
        });
        component.set("v.allData", allData);
        component.set("v.PeopleRec", allData);
        component.set("v.currentPageNumber",1);
       // var allData=component.get("v.PeopleRec");
        var custs = [];
        var conts = component.get("v.fieldsLabelList");
        var cont = component.get("v.fieldAPIList");
        var i=0;
        for(var key in conts)
        {
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
        
        var sortAsc;
        sortAsc =  !sortAsc;
        var field = 'Name';
        allData.sort(function(a, b) {
            if(a["theContact"][field] != undefined && b["theContact"][field] != undefined){
                var t1 = a["theContact"][field].toLowerCase() == b["theContact"][field].toLowerCase(),
                    t2 = (!a["theContact"][field].toLowerCase() && b["theContact"][field].toLowerCase()) || (a["theContact"][field].toLowerCase() < b["theContact"][field].toLowerCase());
                return t1 ? 0 : (sortAsc ? -1 : 1) * (t2 ? 1 : -1);
            }else{
                if(a["theContact"][field] == undefined){
                    return 0;
                }else if(b["theContact"][field] == undefined){
                    return -1;
                }
            }
        });
        console.log(allData);
        
        for(; x<(pageNumber)*pageSize; x++){
            if(allData[x]){
                data.push(allData[x]);
            }
        }
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
        var fieldsMap=component.get("v.fieldMap");
        
        for(var i=0;i<fieldsMap.length;i++){
            if(fieldsMap[i].Id ==fielddesc.Id ){
                sortAsc = fieldsMap[i].sortAsc;
                fieldsMap[i].sortAsc = !sortAsc;
            }
        }
        var sortField = fielddesc.value;
        var field = fielddesc.value;
        if(field == 'ONEPAGER'){
           field = 'hasOnePager'; 
        }
        if(field == 'CV'){
           field = 'hasCV'; 
        }
        if(field == 'ONEPAGER'){
           field = 'hasOnePager'; 
        }
        
        var data =component.get("v.data");
        var allData =component.get("v.PeopleRec");
        sortAsc =  !sortAsc;
        if(field == 'hasCV' || field == 'hasOnePager' || field == 'LinkedIn') {
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
            if(field == 'Country'){
                field = 'Country__c'; 
            }else if(field == 'EMAIL'){
                field = 'Email';
            }else if(field == 'COMPANY'){
               field = 'Company_Name_French__c';
            }else if(field == 'TITLE'){
                field = 'Title';
            }else if(field == 'NAME'){
                field = 'Name';
            }
            
            data.sort(function(a, b) {
                 if(a["theContact"][field] != undefined && b["theContact"][field] != undefined){
                var t1 = a["theContact"][field] == b["theContact"][field],
                    t2 = (!a["theContact"][field] && b["theContact"][field]) || (a["theContact"][field] < b["theContact"][field]);
                return t1 ? 0 : (sortAsc ? -1 : 1) * (t2 ? 1 : -1);
                 }else{
                     if(a["theContact"][field] == undefined){
                         return 0;
                     }else if(b["theContact"][field] == undefined){
                         return -1;
                     }
                 }
            });
            allData.sort(function(a, b) {
                 if(a["theContact"][field] != undefined && b["theContact"][field] != undefined){
                var t1 = a["theContact"][field] == b["theContact"][field],
                    t2 = (!a["theContact"][field] && b["theContact"][field]) || (a["theContact"][field] < b["theContact"][field]);
                return t1 ? 0 : (sortAsc ? -1 : 1) * (t2 ? 1 : -1);
                 }else{
                     if(a["theContact"][field] == undefined){
                         return 0;
                     }else if(b["theContact"][field] == undefined){
                         return -1;
                     }
                 }
            });
        }
        
        component.set("v.data",data);
        component.set("v.PeopleRec",allData);
        component.set("v.fieldMap",fieldsMap);
    },
      onCheckHelper:function(component, event, helper)
    {
        debugger;
                var records=event.getSource().get("v.text");
        
        var selectedRecord=[];
        selectedRecord=component.get("v.selectedRecord");
        var checkBoolean=event.getSource().get("v.value");
        if(checkBoolean==true)
        {
            selectedRecord.push(records);          
        }
        else
        {
            selectedRecord.pop(records);   
        }
        component.set("v.selectedRecord",selectedRecord); 
        console.log('selectedRecord'+selectedRecord);

    }
})