({
    doInitHelper : function(component, event, helper) {
        debugger;
        console.log('AllRecord='+component.get("v.allRecord"));
        if(component.get("v.allRecord") != null)
        {
            component.set("v.totalPages", Math.ceil(component.get("v.allRecord").length/component.get("v.pageSize")));
            
            var allData = component.get("v.allRecord");
            var sortAsc;
            sortAsc =  !sortAsc;
            allData.sort(function(b, a) {
                if(a['Mandate_Start_Date__c'] != undefined && b['Mandate_Start_Date__c'] != undefined) {
                    var t1 = a['Mandate_Start_Date__c'] == b['Mandate_Start_Date__c'],
                        t2 = (!a['Mandate_Start_Date__c'] && b['Mandate_Start_Date__c'] || (a['Mandate_Start_Date__c'] < b['Mandate_Start_Date__c']));
                    return t1 ? 0 : (sortAsc ? -1 : 1) * (t2 ? 1 : -1);
                }
                else{
                    if(a['Mandate_Start_Date__c'] == undefined){
                        return -1;
                    }else if(b['Mandate_Start_Date__c'] == undefined){
                        return 0;
                    }
                }
                
            });
            
            component.set("v.allData", allData);
            
            component.set("v.currentPageNumber",1);
            var allData=component.get("v.allRecord");
            console.log("allData="+allData);
            
            var custs = [];
            var conts = component.get("v.fieldList");
            var i=0;
            for(var key in conts.API){
                custs.push({value:conts.API[i], key:key,Label:conts.Label[i],sortAsc:true,Id:i}); 
                i++;
            }
            component.set("v.fieldMap",custs);
            console.log(component.get("v.fieldMap"));
            console.log('custs='+custs);
            helper.buildData(component, helper);
        }
    },
    buildData : function(component, helper) {
        debugger;
        var data = [];
        var pageNumber = component.get("v.currentPageNumber");
        var pageSize = component.get("v.pageSize");
        var allData = component.get("v.allData");
        var x = (pageNumber-1)*pageSize;
        
        console.log(allData);
        for(; x<(pageNumber)*pageSize; x++){
            if(allData[x]){
                data.push(allData[x]);
            }
        }
        var sortAsc;
        sortAsc =  !sortAsc;
        
        data.sort(function(b, a) {
            if(a['Mandate_Start_Date__c'] != undefined && b['Mandate_Start_Date__c'] != undefined) {
                var t1 = a['Mandate_Start_Date__c'] == b['Mandate_Start_Date__c'],
                    t2 = (!a['Mandate_Start_Date__c'] && b['Mandate_Start_Date__c'] || (a['Mandate_Start_Date__c'] < b['Mandate_Start_Date__c']));
                return t1 ? 0 : (sortAsc ? -1 : 1) * (t2 ? 1 : -1);
            }
            else{
                if(a['Mandate_Start_Date__c'] == undefined){
                    return -1;
                }else if(b['Mandate_Start_Date__c'] == undefined){
                    return 0;
                }
            }
            
        });
        component.set("v.data", data);
        helper.generatePageList(component, pageNumber);
    },
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
        
        var data =component.get("v.data");
        var allData = component.get("v.allRecord");
        sortAsc =  !sortAsc;
        
        
        if (field == 'Partner__r'  ) {
            field = 'Name';
            data.sort(function(a, b) {
                if(a.Partner__r != undefined && b.Partner__r != undefined) {
                    var t1 = a.Partner__r[field] == b.Partner__r[field],
                        t2 = (!a.Partner__r[field] && b.Partner__r[field] || (a.Partner__r[field] < b.Partner__r[field]));
                    return t1 ? 0 : (sortAsc ? -1 : 1) * (t2 ? 1 : -1);
                }
                else{
                    if(a.Partner__r == undefined){
                        return 0;
                    }else if(b.Partner__r == undefined){
                        return -1;
                    }
                }
                
            });
            
            allData.sort(function(a, b) {
                if(a.Partner__r != undefined && b.Partner__r != undefined) {
                    var t1 = a.Partner__r[field] == b.Partner__r[field],
                        t2 = (!a.Partner__r[field] && b.Partner__r[field] || (a.Partner__r[field] < b.Partner__r[field]));
                    return t1 ? 0 : (sortAsc ? -1 : 1) * (t2 ? 1 : -1);
                } else{
                    if(a.Partner__r == undefined){
                        return 0;
                    }else if(b.Partner__r == undefined){
                        return -1;
                    }
                }
            });
            
            
            
        }
        else if (field == 'Partner_2__r' ) {
            field = 'Name';
            data.sort(function(a, b) {
                if(a.Partner_2__r != undefined && b.Partner_2__r != undefined) {
                    var t1 = a.Partner_2__r[field] == b.Partner_2__r[field],
                        t2 = (!a.Partner_2__r[field] && b.Partner_2__r[field] || (a.Partner_2__r[field] < b.Partner_2__r[field]));
                    return t1 ? 0 : (sortAsc ? -1 : 1) * (t2 ? 1 : -1);
                }
                else{
                    if(a.Partner_2__r == undefined){
                        //alert(a.Name);
                        return 0;
                    }else if(b.Partner_2__r == undefined){
                        return -1;
                    }
                }
            });
            
            allData.sort(function(a, b) {
                if(a.Partner_2__r != undefined && b.Partner_2__r != undefined) {
                    var t1 = a.Partner_2__r[field] == b.Partner_2__r[field],
                        t2 = (!a.Partner_2__r[field] && b.Partner_2__r[field] || (a.Partner_2__r[field] < b.Partner_2__r[field]));
                    return t1 ? 0 : (sortAsc ? -1 : 1) * (t2 ? 1 : -1);
                }else{
                    if(a.Partner_2__r == undefined){
                        //alert(a.Name);
                        return 0;
                    }else if(b.Partner_2__r == undefined){
                        return -1;
                    }
                }
            });
            
        }
            else{
                if (field == 'Job_Function__c' ||field == 'Mandate_Start_Date__c' ||field == 'Company_Name_French__c' ||field == 'number_of_days__c'||field == 'Number_of_candidates__c' || field == 'Has_Job_Description__c' || field == 'Assignment_Status__c' || field == 'Industry_Types__c'){
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
                }
                else{
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
                        if(a[field].toLowerCase() != undefined && b[field].toLowerCase() != undefined){
                            var t1 = a[field] == b[field],
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
                
            }
        component.set("v.data",data);
        component.set("v.allRecord",allData);
        component.set("v.fieldMap",fieldsMap);
    },
    handleViewAllEventHelper:function(component, event, helper){
        debugger;
        var isTrue = event.getParam("isTrue");
        component.set("v.clickedViewAll",isTrue);	
        component.set("v.checkSpinner",false);
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