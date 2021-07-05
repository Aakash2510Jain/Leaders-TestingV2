({
    
    validateAccountList: function(component, event) {
        //Validate all account records
        var isValid = true;
        var accountList = component.get("v.accountList");
        for (var i = 0; i < accountList.length; i++) {
            if (accountList[i].Name == '') {
                isValid = false;
                alert('Account Name cannot be blank on row number ' + (i + 1));
            }
        }
        return isValid;
    },
    
    saveAccountList: function(component, event, helper) {
        //Call Apex class and pass account list parameters
        var action = component.get("c.saveAccounts");
        action.setParams({
            "accList": component.get("v.accountList")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.accountList", []);
                alert('Account records saved successfully');
            }
        }); 
        $A.enqueueAction(action);
    },
    getRecordTypesHelper: function(component,event,helper){
        debugger;
        component.set("v.checkSpinner",true);
        var action = component.get("c.getRecordTypeInfo");
        action.setParams({
            "conId": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var recordTypeKeyValue=new Object();
            if (state === "SUCCESS") {
                var res = response.getReturnValue();
                
                component.set('v.attId',res.attId);
                component.set('v.recordTypes',res.recordTypeInfo);
                component.set("v.checkSpinner",false);
                //alert('In Dev Mode 1');
                helper.getRecordsHelper(component, event, helper);
            	helper.getConRecordsHelper(component, event, helper);
            }else{
                alert('Some Error Occured');
            }
        });
        $A.enqueueAction(action);
        
        
        
        var Profileaction = component.get("c.getProfileInfo");
        
        Profileaction.setCallback(this, function(response) {
            var state = response.getState();
            var recordTypeKeyValue=new Object();
            if (state === "SUCCESS") {
                var res = response.getReturnValue();
                
                component.set('v.profileName',res);
            }
        });
        $A.enqueueAction(Profileaction);
    },
    getRecordsHelper: function(component,event,helper){
        debugger;
        component.set("v.checkSpinner",true);
        var action = component.get("c.getBiograpgyRecords");
        action.setParams({
            'peopleId':component.get("v.recordId")
        })
        action.setCallback(this, function(response) {
            //alert('In Dev Mode');
            var state = response.getState();
            var recordTypeKeyValue=new Object();
            if (state === "SUCCESS") {
                component.set("v.checkSpinner",false);
                var res = response.getReturnValue();
                var educationList = [];
                var expList = [];
                var profList = [];
                var boardList = [];
                var selectedWE={};
                console.log(res);
                for(var i=0;i<res.length;i++){
                    //Prinz
                    debugger;
                    if(res[i].RecordType.DeveloperName=='Education'){
                        if(res[i].Company__c != '' && res[i].Company__c !=null){
                            educationList.push({"record":res[i],"lookupObj":{"Id":res[i].Company__c,"Name":res[i].Company_Name__c}});
                        }else{
                            
                            educationList.push({"record":res[i],"lookupObj":{}});
                        }
                    }else if(res[i].RecordType.DeveloperName=='Experience'){
                        if(res[i].Company__c != '' && res[i].Company__c !=null){
                            expList.push({"record":res[i],"lookupObj":{"Id":res[i].Company__c,"Name":res[i].Company_Name__c}});
                        }else{
                            expList.push({"record":res[i],"lookupObj":{}});
                        }
                    }
                        else if(res[i].RecordType.DeveloperName=='Professional_Order'){
                            if(res[i].Company__c != '' && res[i].Company__c !=null){
                                profList.push({"record":res[i],"lookupObj":{"Id":res[i].Company__c,"Name":res[i].Company_Name__c}});
                            }else{
                                profList.push({"record":res[i],"lookupObj":{}});
                            }
                        }
                            else if(res[i].RecordType.DeveloperName=='Professional_Association'){
                                if(res[i].Company__c != '' && res[i].Company__c !=null){
                                    boardList.push({"record":res[i],"lookupObj":{"Id":res[i].Company__c,"Name":res[i].Company_Name__c}});
                                }else{
                                    boardList.push({"record":res[i],"lookupObj":{}});
                                }
                            }
                }
                if(educationList.length >0){
                    component.set("v.educationList",educationList);
                }else{
                    selectedWE["educationList0"] = "";
                    component.set("v.educationList",[{"record":{'sobjectType': 'Work_Experience__c',
                                                                'Company__c': '',
                                                                'Title__c': '',
                                                                'Title_FR__c': '',
                                                                'Start_Year__c': '',
                                                                'End_Year__c': '',
                                                                'Current_del__c': '',
                                                                'RecordTypeId':component.get("v.recordTypes").Education
                                                               },"lookupObj":{}}]);
                }
                if(expList.length >0){
                    component.set("v.experienceList",expList);
                }else{
                    selectedWE["experienceList0"] = "";
                    component.set("v.experienceList",[{"record":{'sobjectType': 'Work_Experience__c',
                                                                 'Company__c': '',
                                                                 'Title__c': '',
                                                                 'Title_FR__c': '',
                                                                 'Start_Year__c': '',
                                                                 'End_Year__c': '',
                                                                 'Current_del__c': '',
                                                                 'RecordTypeId':component.get("v.recordTypes").Experience
                                                                },"lookupObj":{}}]);
                }
                if(profList.length >0){
                    component.set("v.professionalList",profList);
                }else{
                    selectedWE["professionalList0"] = "";
                    component.set("v.professionalList",[{"record":{'sobjectType': 'Work_Experience__c',
                                                                   'Company__c': '',
                                                                   'Title__c': '',
                                                                   'Title_FR__c': '',
                                                                   'Start_Year__c': '',
                                                                   'End_Year__c': '',
                                                                   'Current_del__c': '',
                                                                   'RecordTypeId':component.get("v.recordTypes").Professional_Order
                                                                  },"lookupObj":{}}]);
                }
                if(boardList.length >0){
                    component.set("v.boardList",boardList);
                }else{
                    selectedWE["boardList0"] = "";
                    component.set("v.boardList",[{"record":{'sobjectType': 'Work_Experience__c',
                                                            'Company__c': '',
                                                            'Title__c': '',
                                                            'Title_FR__c': '',
                                                            'Start_Year__c': '',
                                                            'End_Year__c': '',
                                                            'Current_del__c': '',
                                                            'RecordTypeId':component.get("v.recordTypes").Professional_Association
                                                           },"lookupObj":{}}]);
                }
            }
        });
        $A.enqueueAction(action);
    },
     genrateSelfAss: function(component,event,helper){
       
        debugger;
        var action = component.get("c.Generate_Self_Ass");
        action.setParams({
            conid : component.get("v.recordId")
        });
        
        action.setCallback(this,function(response){
            var result = response.getReturnValue();
            debugger;
            if(response.getState() === "SUCCESS"){
                    component.set("v.attachmentId",result);
                }
            else{
                alert('some error occured');
            }
                    
            }) ;
        $A.enqueueAction(action); 
    },
    
    
    saveBiographyList:function(component,event,helper){
        debugger;
        component.set("v.checkSpinner",true);
        //Added by Deagle~
        var brdCmp = component.find("brdCmp");
        var proCmp = component.find("proCmp");
        var eduCmp = component.find("eduCmp");
        var expCmp = component.find("expCmp");
        
        var brdResult = brdCmp.validateMe();
        var proResult = proCmp.validateMe();
        var eduResult = eduCmp.validateMe();
        var expResult = expCmp.validateMe();
        
        var expList =component.get("v.experienceList");
        var eduList =component.get("v.educationList");
        var profList =component.get("v.professionalList");
        var boardList =component.get("v.boardList");
        
        eduList[0].lookupObj.Id
        
        if(expList[0].lookupObj.Id == undefined){
            expResult = true;
        }
        if(eduList[0].lookupObj.Id == undefined){
            eduResult = true;
        }
        if(profList[0].lookupObj.Id == undefined){
            proResult = true;
        }
        if(boardList[0].lookupObj.Id == undefined){
            brdResult = true;
        }
        
        if(brdResult && proResult && eduResult && expResult){
            
            var finalList = [];
            var j=0;
            if(expList.length >0){
                
                for(var i=0;i<expList.length;i++){
                    if(expList[i].record.Company__c != '' || expList[i].lookupObj.Id!=''){
                        finalList[j] = JSON.parse(JSON.stringify(expList[i]));
                        j++;
                    }
                    
                }
                
            }
            if(eduList.length >0){
                
                for(var i=0;i<eduList.length;i++){
                    if(eduList[i].record.Company__c != '' || eduList[i].lookupObj.Id!=''){
                        finalList[j] = JSON.parse(JSON.stringify(eduList[i]));
                        j++;
                    }
                    
                }
                
            }
            if(profList.length >0){
                
                for(var i=0;i<profList.length;i++){
                    if(profList[i].record.Company__c != '' || profList[i].lookupObj.Id!=''){
                        finalList[j] = JSON.parse(JSON.stringify(profList[i]));
                        j++;
                    }
                    
                }
                
            }
            if(boardList.length >0){
                
                for(var i=0;i<boardList.length;i++){
                    if(boardList[i].record.Company__c != '' || boardList[i].lookupObj.Id!=''){
                        finalList[j] = JSON.parse(JSON.stringify(boardList[i]));
                        j++;
                    }
                    
                }
                
            }
            
            var allRecords =[];
            for(var i=0;i<finalList.length;i++){
                var tempvar = finalList[i].record;
                if(tempvar.RecordType != undefined){
                    delete tempvar['RecordType'];
                }
                if(tempvar.sobjectType==undefined)
                    tempvar['sobjectType']= 'Work_Experience__c';
                tempvar.Contact__c=component.get('v.recordId');
                
                if(finalList[i]['lookupObj'] !=undefined){
                    if(finalList[i]['lookupObj'].Id != undefined)
                        tempvar.Company__c = finalList[i]['lookupObj'].Id;
                    //delete finalList[i]['lookupObj'];
                }
                if(tempvar.Company_Name__c != undefined){
                    delete tempvar['Company_Name__c'];
                }
                if(tempvar.Id == ''){
                    delete tempvar['Id'];
                }
                
                allRecords.push(tempvar);
                
            }
            this.updateContactHelper(component,event);
            //Additional_Comments__c
            debugger;
            var conId = component.get("v.recordId");
            var action = component.get("c.upsertBiography");
            action.setParams({
                'ConId':conId,
                'bioList':allRecords,
                'toBeDeletedList':component.get("v.IdsTodeleteList")
            })
            action.setCallback(this, function(response) {
                var state = response.getState();
                var recordTypeKeyValue=new Object();
                if (state === "SUCCESS") {
                    debugger;
                    if(component.get("v.isrelatedListButton")){
                        component.set("v.checkSpinner",false);
                        component.destroy();
                        window.history.back();
                    }else{
                        component.set("v.checkSpinner",false);
                        component.set("v.displayUpdateBioNew",false);
                          swal.fire({
                    title: "Success!",
                    text: "The Bio has been Updated.",
                    type: "success",
                    timer: 3000
                          });
                        window.location.reload();
                        
                    }                 
                }else{
                    component.set("v.checkSpinner",false);
                    alert(response.getReturnValue());
                }
            });
            $A.enqueueAction(action);
            
        }
        else{
            alert("Please fill all manditory fields");
        }
        
        
    },
    
    handledeleteHelper:function(component,event,helper){
        debugger;
        var idTodelete = event.getParam("IdsTodelete");
        //console.log(idTodelete);
        var existingId =[];
        var existingId =component.get("v.IdsTodeleteList");
        existingId.push(idTodelete);
        //console.log('printing all Id');
        //console.log(existingId);
        component.set("v.IdsTodeleteList",existingId);
        
    },
    updateContactHelper : function(component,event) {
        var conRecord = component.get("v.conRecord");
        conRecord.Id=component.get("v.recordId");
        component.set("v.conRecord",conRecord);
        
        var action = component.get("c.updateContactRecord");
        var conRec = component.get("v.conRecord");
        if(conRec.Additional_Comments__c != null && conRec.Additional_Comments__c != undefined)
        {
        if(conRec.Additional_Comments__c.length >0){
            conRec.comments_Available__c = true;
        }else{
            conRec.comments_Available__c = false;
        }
        }
        action.setParams({
            "conRecord" : component.get("v.conRecord")
        });
        
        action.setCallback(this, function(response) {
            debugger;
            var state = response.getState();
            if (state === "SUCCESS") {
                //alert(response.getReturnValue());
                //component.set("v.loader", false);
            }else{
                //alert('Some Error');
                //console.log('Some Error');
            }
        });
        $A.enqueueAction(action);
        
    },
    getConRecordsHelper : function(component,event) {
        component.set("v.checkSpinner",true);
        var action = component.get("c.getContactData");
        
        action.setParams({
            "recordId" : component.get("v.recordId")
        });
        
        action.setCallback(this, function(response) {
            debugger;
            
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.checkSpinner",false);
                component.set("v.conRecord",response.getReturnValue());
                //alert(response.getReturnValue());
                //component.set("v.loader", false);
            }else{
                //alert('Some Error');
                //console.log('Some Error');
            }
        });
        $A.enqueueAction(action);
        
    }
})