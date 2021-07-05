({
    doInitHelper : function(component, event, helper) {
        debugger;
        var pickList=[];
        var getAllPickListValue = component.get('c.getAllPickListValue'); 
        getAllPickListValue.setCallback(this, function(res){
            var state = res.getState(); // get the response state
            if(state == 'SUCCESS') {
                pickList=res.getReturnValue();
                if(pickList.Length!=0)
                {
                    //INDUSTRY
                    var allIndustry = pickList['Industry_Types__c'];
                    var industryOptions = [];
                    for(var i=0;i<allIndustry.length;i++){
                        industryOptions.push({label:allIndustry[i],value:allIndustry[i]});
                    }
                    component.set('v.IndustryValueList',industryOptions);
                    //Status
                    var allfunctionalArea = pickList['Status__c'];
                    var functionalAreaOptions = [];
                    for(var i=0;i<allfunctionalArea.length;i++){
                        functionalAreaOptions.push({label:allfunctionalArea[i],value:allfunctionalArea[i]});
                    }
                    component.set('v.StatusValueList',functionalAreaOptions);
                  
                    //COUNTRY
                    var Countries = pickList['Country__c'];
                    var CountryOptions = [];
                    for(var i=0;i<Countries.length;i++){
                        CountryOptions.push({label:Countries[i],value:Countries[i]});
                    }
                    component.set('v.CountryValueList',CountryOptions);
                    //STATE
                    var States = pickList['State__c'];
                    var StateOptions = [];
                    for(var i=0;i<States.length;i++){
                        StateOptions.push({label:States[i],value:States[i]});
                    }
                    component.set('v.StateValueList',StateOptions);
                    
                    component.set("v.isDataComing",true);
                    this.getFieldsHelper(component, event, helper);
                }    
            }
        });
        $A.enqueueAction(getAllPickListValue);	
    },
    
    doSearchHelper:function(component, event, helper){
        debugger;  
        component.set("v.checkSearchTable",false);
        var booleanvalue = component.get('v.ValueForBooleanSearch');
        
        if(booleanvalue != null){
            swal.fire({
                title: "Success",
                text: "We are only showing you 2000 records",
                type: "success",
                timer: 3000,
                showConfirmButton: false
            });
        }
        
        var pickListMap={};
        var allRecords=[];
        if(component.get('v.selectedCountryItem').length!=0){
            pickListMap['Country__c']=component.get('v.selectedCountryItem');
        }
        if(component.get('v.selectedIndustryItem').length!=0){
            pickListMap['Industry_Types__c ']=component.get('v.selectedIndustryItem');
        }
        if(component.get('v.selectedStateItem').length!=0)
        {
            pickListMap['State__c']=component.get('v.selectedStateItem');
        }
        if(component.get('v.selectedStatusItem').length!=0){
            pickListMap['Status__c']=component.get('v.selectedStatusItem');    
        }
        //Calling Aura Enabled Method
        var getAccountRec = component.get('c.getAccountRec'); 
        getAccountRec.setParams({
            "fetchdata" : pickListMap,
            "BooleanSearchValue": booleanvalue
        });
        getAccountRec.setCallback(this, function(res){
            var state = res.getState(); // get the response state
            if(state == 'SUCCESS') {
                allRecords=res.getReturnValue();
                component.set("v.allRecord",allRecords);
                //var allContactMap = allRecords.contactByAccountId;
                //component.set("v.contactBooleanByAccountId",allContactMap);
                /*for(var i =0;i<allContactMap.length;i++){
                }*/
                component.set("v.checkSearchTable",true);
                component.set("v.allRecordLength",allRecords.length);
                component.set("v.checkSpinner",false);
                if(allRecords.length == 0){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "",
                        "message": "No Record found for this search.",
                        "type":"warning"
                    });
                    toastEvent.fire();
                    component.set("v.checkSearchTable",false);
                    component.set("v.checkSpinner",false);
                }
                /*if(component.get("v.checkSearchTable")==false){
                    component.set("v.checkSearchTable",true);
                    component.set("v.checkSpinner",false);
                }else{
                    component.set("v.checkSearchTable",true);
                    component.set("v.checkSpinner",false);
                }  */  
                console.log("checkSearchTable"+component.get("v.checkSearchTable"));
                component.set("v.checkSpinner",false);
            }
        });
        $A.enqueueAction(getAccountRec);
    },
    getFieldsHelper:function(component, event, helper){
        debugger;
        console.log("getFieldsHelper method called");
        var fieldsList={};
        var getFields = component.get('c.getFields'); 
        getFields.setCallback(this, function(res){
            var state = res.getState(); // get the response state
            if(state == 'SUCCESS') {
                fieldsList=res.getReturnValue();
                component.set("v.fieldList",fieldsList);
            // component.set("v.fieldAPIList",fieldsList['API']);
            //    component.set("v.fieldLabelList",fieldsList['Label']);
            }
        });
        $A.enqueueAction(getFields);
    },
    viewAllHelper:function(component, event, helper){
        debugger;
        component.set("v.checkSpinner",true);
        var appEvent = $A.get("e.c:passBooleanEvt");
        if(component.get("v.clickedViewAll")==false)
        {
            appEvent.setParams({
                "isTrue" : true
            });
            component.set("v.clickedViewAll",true);
            appEvent.fire();
        }  else{
            appEvent.setParams({
                "isTrue" : false
            });
            component.set("v.clickedViewAll",false);
            appEvent.fire();
        }
        
    },
    doDeleteHelper:function(component, event, helper){
        debugger;
        var allRecord=component.get("v.allRecord");
        var selectedRecord=component.get("v.selectedRecord");
        var idList=[];
        for(var i=0; i<selectedRecord.length; i++){
            idList.push(selectedRecord[i].Id);
        }
        var deleteRecord = component.get('c.deleteRecord'); 
        deleteRecord.setParams({
            "idList" : idList
        });
        deleteRecord.setCallback(this, function(res){
            var state = res.getState(); // get the response state
            if(state == 'SUCCESS') {
                var response=res.getReturnValue();
				this.spliceHelper(component, event, helper);
			}
        });
        $A.enqueueAction(deleteRecord);
        
    },
     spliceHelper:function(component, event, helper){
    	var selectedRecord=component.get("v.selectedRecord");
        var data=component.get("v.data");
         console.log('index of='+data.indexOf(selectedRecord[i]))
         for(var i=0; i<selectedRecord.length; i++){
             console.log('selectedRecord='+selectedRecord[i].Id)
            var removeIndex = data.map(function(item) { return item.Id; }).indexOf(selectedRecord[i].Id);
            data.splice(removeIndex, 1);
         }
         component.set("v.data",data)
	}
    
})