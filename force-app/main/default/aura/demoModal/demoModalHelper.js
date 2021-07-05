({
    doInitHelper : function(component,event,helper) {
        debugger;
        component.set("v.spinnerModal", true);
        var objIdList=[];
        if(component.get('v.isFromSearchEngine') =='Yes'){
            var selectedRecord=component.get('v.selectedRecord');
            objIdList=[];
            var maplist={};
            //  var recordList=[];
            for(var i=0; i<selectedRecord.length; i++){
                var obj=selectedRecord[i];
                objIdList.push(obj['Id']);
                
            }
        }else{
            var selectedRecord=component.get('v.selectedRecord');
            objIdList=selectedRecord;
        }
        
        //call Aura Enabled method
        var getRecord = component.get("c.getRecord");
        getRecord.setParams({ objIdList : objIdList });
        getRecord.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set('v.recordList',response.getReturnValue());
                component.set('v.spinnerModal',false);
                var existingRec = response.getReturnValue()[0];
                var i=0;
                for(var propt in existingRec){
                    console.log('propt='+propt);
                    i++;
                }
                var existingRec1 = response.getReturnValue()[0];
                var j=0;
                for(var propt in existingRec1){
                    j++;
                }
                helper.getFieldLabelNameHelper(component,event,helper);
            }
        });
        $A.enqueueAction(getRecord);
        
    },//this method return key(FieldapiName) value(Field's Label name) Map
    getFieldLabelNameHelper:function(component,event,helper){
        debugger;
        var objIdList=[];
        var selectedRecord=component.get('v.selectedRecord');
        if(component.get('v.isFromSearchEngine') =='Yes'){
            for(var i=0; i<selectedRecord.length; i++){
                var obj=selectedRecord[i];
                objIdList.push(obj['Id']);
            }
        }else{
            objIdList =selectedRecord;
        }
        //call Aura Enabled method
        var getFieldLabelName = component.get("c.getFieldLabelName");
        getFieldLabelName.setParams({ objIdList : objIdList });
        getFieldLabelName.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
               component.set('v.fieldLabelList',response.getReturnValue());
               console.log('fieldLabelList'+component.get('v.fieldLabelList'));
                component.set("v.spinnerrun",false);
            }
        });
        $A.enqueueAction(getFieldLabelName);
    },
    onCheckForPrimaryAccountHelper:function(component,event,helper){
        debugger;
        let finalRec = event.getSource().get("v.name");
        component.set("v.CheckedRecord",finalRec);
        component.set("v.somerec",JSON.stringify(finalRec));
        //console.log("something");
    },
    onCheckForFieldsHelper:function(component,event,helper){
        debugger;
        var existingRec = component.get("v.CheckedRecord");
        var clickedRec=event.getSource().get("v.name");
        var clickedApi=event.getSource().get("v.text");
        var clickedValue=event.getSource().get("v.value");
        
        var valueToBeupdated = clickedRec[clickedApi];
        
        var cloneExistingRec=component.get("v.somerec");
        if(clickedApi!='Name'){
            if(clickedApi == 'Comp__c'){
                if(clickedValue){
                    console.log('clickedRec.AccountId==>'+clickedRec.AccountId)
                    existingRec['AccountId']=clickedRec.AccountId;
                    console.log('existingRec==>'+existingRec['AccountId'])

                }else{
                    console.log('clickedRec.AccountId==>'+clickedRec.AccountId)
                    existingRec['AccountId']=cloneExistingRec.AccountId;
                    console.log('existingRec==>'+existingRec['AccountId'])

                }
            }else{
                if(clickedValue){
                	existingRec[clickedApi] = valueToBeupdated;    
                }else{
                    var previousVersion=JSON.parse(cloneExistingRec);
                    existingRec[clickedApi]=cloneExistingRec[clickedApi];
                }
            }
        }
        //console.log(component.get("v.somerec").AccountNumber);
        component.set("v.CheckedRecord",existingRec); 
        /*var i=0;
        for(var propt in existingRec){
            i++;
        }*/
        //component.set("v.selectedFields",fields);
    },
    mergeHelper:function(component,event,helper){
        debugger;
        var checkAssigment=true;
        var checkActivity=true;
        var checkNotes=true;
        var checkFile=true;
        var deleteRecordisList=[];
        var deleteRecord=[];
		
        

            var winnerAccount=component.get("v.CheckedRecord");
            var selectedAccountList=component.get("v.recordList");
            for(var recordData in selectedAccountList){
                //console.log(selectedAccountList[recordData].Id);
                if(selectedAccountList[recordData].Id!=winnerAccount.Id){
                    deleteRecordisList.push(selectedAccountList[recordData].Id);
                    var inst={
                        "Name":selectedAccountList[recordData].Name,
						"Id":selectedAccountList[recordData].Id

                    }
                    deleteRecord.push(inst);
                    //deleteRecord.push(selectedAccountList[recordData]);
                }
            }
            component.set('v.toBeDeletedRecordList',deleteRecord);
            var mergeDuplicate = component.get("c.mergeDuplicate");
            mergeDuplicate.setParams({ "recordIdDeletion" : deleteRecordisList,
                                      "recAcc":winnerAccount,
                                      "checkAssigment":checkAssigment,
                                      "checkAttachment" : checkNotes,
                                      "checkFile":checkFile,
                                      "checkActivity":checkActivity
                                     });
            mergeDuplicate.setCallback(this, function(response) {
                var state = response.getState();
               
                if (state === "SUCCESS") {
                    
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "message": "Records has been merged Successfully.",
                        "type":"success"
                    });
                    toastEvent.fire();
                   $A.get('e.force:refreshView').fire();
                   //this.mergeDuplicateSpliceHelper(component,event,helper);
                    component.set('v.spinnerModal',false);

                }else{
                    component.set('v.spinnerModal',false);
                    var error=response.getError()[0].message;
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error",
                        "message": error,
                        "type":"error"
                    });
                    toastEvent.fire();

				component.set('v.spinnerModal',false);
                }
            });
            $A.enqueueAction(mergeDuplicate);
            
                  
    },
    onCheckForFieldEventHandlerHelper:function(component,event,helper){
        var CheckBoxValue = event.getParam("CheckBoxValue"); 
        //Set the handler attributes based on event data 
    },
    mergeDuplicateSpliceHelper:function(component,event,helper){
        var dFlag=component.get("v.dataFlag");
        var toBeDeletedRecordList=component.get("v.toBeDeletedRecordList");
    	var dataR=[];
        dataR=component.get("v.data");
        //var asda=Object.prototype.hasOwnProperty.call(dataR, 'bar');
        if(dFlag=== true){
			var oneInstance=[];
            for(var i=0; i<dataR.length; i++){
                	var d=dataR[i];
                oneInstance.push(d['theContact']);
            }   
            for(var i=0; i<toBeDeletedRecordList.length; i++){
            var removeIndex = oneInstance.map(function(item) { return item.Id; }).indexOf(toBeDeletedRecordList[i].Id);
            dataR.splice(removeIndex, 1);
            } 
                        component.set("v.data",dataR);   
        }else{
            for(var i=0; i<toBeDeletedRecordList.length; i++){
                var removeIndex = dataR.map(function(item) { return item.Id; }).indexOf(toBeDeletedRecordList[i].Id);
                dataR.splice(removeIndex, 1);
             }
            component.set("v.data",dataR);   
     }
                    component.set("v.isOpen", false);
    }
})