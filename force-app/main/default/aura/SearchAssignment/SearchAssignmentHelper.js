({
    industryhelper : function(component, event, helper) {
        debugger;
        component.set("v.checkSpinner",true);
        var pickList=[];
        var fieldList = ['Assignment_Status__c','Industry_Types__c','Job_Function__c','Level__c','Country__c','State__c'];
        
        
        var getAllPickListValue = component.get('c.getAllPickVal'); 
        getAllPickListValue.setParams({
            'fieldList':fieldList,
            'obj':'Mandate__c'
        });
        getAllPickListValue.setCallback(this, function(res){
            var state = res.getState(); // get the response state
            if(state == 'SUCCESS') {
                pickList=res.getReturnValue();
                if(pickList.Length!=0)
                {   
                    //StateForCanda
                    var statesForCanada = ['Alberta','British Columbia','Manitoba','New Brunswick','Newfoundland and Labrador','Nova Scotia','Ontario','Prince Edward Island','Quebec','Saskatchewan'];
                    var Options = [];
                    for(var i=0;i<statesForCanada.length;i++){
                        Options.push({label:statesForCanada[i],value:statesForCanada[i]});
                    }
                    component.set('v.StateValueListForCanada',Options);
                    
                    //Industry
                    var Industry = pickList['Industry_Types__c'];
                    var IndustryOptions = [];
                    for(var i=0;i<Industry.length;i++){
                        IndustryOptions.push({label:Industry[i],value:Industry[i]});
                    }
                    component.set('v.listOfIndustry',IndustryOptions);
                    //Country
                    var Country = pickList['Country__c'];
                    var CountryOptions = [];
                    for(var i=0;i<Country.length;i++){
                        CountryOptions.push({label:Country[i],value:Country[i]});
                    }
                    component.set('v.CountryValueList',CountryOptions);
                    //State
                    var State = pickList['State__c'];
                    var StateOptions = [];
                    for(var i=0;i<State.length;i++){
                        StateOptions.push({label:State[i],value:State[i]});
                    }
                    component.set('v.StateValueList',StateOptions);
                    //LEVEL
                    var Levels = pickList['Level__c'];
                    var LevelOptions = [];
                    for(var i=0;i<Levels.length;i++){
                        LevelOptions.push({label:Levels[i],value:Levels[i]});
                    }
                    component.set('v.listOfLevel',LevelOptions);
                    //STATUS
                    var Status = pickList['Assignment_Status__c'];
                    var StatusOptions = [];
                    for(var i=0;i<Status.length;i++){
                        StatusOptions.push({label:Status[i],value:Status[i]});
                    }
                    component.set('v.listOfStatus',StatusOptions);
                    //JOBFUNCTION
                    var JobFun = pickList['Job_Function__c'];
                    var JobFunOptions = [];
                    for(var i=0;i<JobFun.length;i++){
                        JobFunOptions.push({label:JobFun[i],value:JobFun[i]});
                    }
                    component.set('v.listOfJobFunction',JobFunOptions);
                    component.set("v.checkSpinner",false);
                }    
            }
        });
        $A.enqueueAction(getAllPickListValue);	
    },
    getFieldsHelper:function(component, event, helper){
        debugger;
        console.log("getFieldsHelper method called");
        var fieldsList={};
        var getField = component.get('c.getFields'); 
        getField.setCallback(this, function(res){
            var state = res.getState(); // get the response state
            if(state == 'SUCCESS') {
                debugger;
                fieldsList=res.getReturnValue();
                component.set("v.fieldAPIList",fieldsList['API']);
                
                component.set("v.fieldLabelList",fieldsList['Label']);
                component.set("v.fieldList",fieldsList);
                //component.set("v.fieldLabelList",fieldsList);
                console.log('Apirec='+component.get("v.fieldAPIList"));
            }
            
        });
        $A.enqueueAction(getField);
    },
    getUserNames:function(component, event, helper){
        debugger;
        var UserDetails={};
        var getuserRec = component.get('c.UserList'); 
        getuserRec.setCallback(this, function(res){
            var state = res.getState(); // get the response state
            if(state == 'SUCCESS') {
                UserDetails=res.getReturnValue();
                
                var UserList = UserDetails['UserName'];
                var UserOptions = [];
                for(var i=0;i<UserList.length;i++){
                    UserOptions.push({label:UserList[i],value:UserList[i]});
                }
                
                component.set("v.UserListOptions",UserOptions);
                
                component.set("v.UserList",UserDetails['UserName']);
                component.set("v.UserIds",UserDetails['UserID']);
                component.set("v.UserMap",UserDetails);
                
            }
            
        });
        $A.enqueueAction(getuserRec);
    },
    
    doSearchHelper:function(component, event, helper){
        debugger; 
        var booleanvalue = component.get('v.ValueForBooleanSearch');
        component.set("v.checkSearchTable",false);
        var pickListMap={};
        var allRecords=[];
        if(component.get('v.selectedCountryItem').length!=0){
            pickListMap['Country__c']=component.get('v.selectedCountryItem');
        }
        if(component.get('v.selectedIndustryItem').length!=0){
            pickListMap['Industry_Types__c']=component.get('v.selectedIndustryItem');
        }
        if(component.get('v.selectedStateItem').length!=0)
        {
            pickListMap['State__c']=component.get('v.selectedStateItem');
        }
        if(component.get('v.selectedStatusItem').length!=0){
            pickListMap['Status__c']=component.get('v.selectedStatusItem');    
        }
        var getAccountRec = component.get('c.getAssignRec'); 
        getAccountRec.setParams({
            "fetchdata" : pickListMap,
            "BooleanSearchValue": booleanvalue
        });
        getAccountRec.setCallback(this, function(res){
            var state = res.getState(); // get the response state
            if(state == 'SUCCESS') {
                allRecords=res.getReturnValue();
                component.set("v.allRecord",allRecords);
                if(allRecords != null)
                {
                   component.set("v.allRecordLength",allRecords.length);
                 
                }
                component.set("v.checkSearchTable",true);
                
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
                }  console.log("checkSearchTable"+component.get("v.checkSearchTable"));
            }
        });
        $A.enqueueAction(getAccountRec);
    },
     doDeleteHelper:function(component, event, helper){
        debugger;
        component.set("v.checkSpinner",true);
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
                 component.set("v.checkSpinner",false);
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