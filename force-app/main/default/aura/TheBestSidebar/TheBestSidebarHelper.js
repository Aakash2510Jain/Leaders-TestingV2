({
    
    doInitHelper  : function(component, event, helper)
    { debugger;
     
     var sPageURL = decodeURIComponent(window.location.search.substring(1)); //You get the whole decoded URL of the page.
     component.set("v.urlvalue",sPageURL);
     var sURLVariables = sPageURL.split('&'); //Split by & so that you get the key value pairs separately in a list
     var sParameterName;
     var i;
     for (i = 0; i < sURLVariables.length; i++) 
     {
         sParameterName = sURLVariables[i].split('='); //to split the key from the value.
         if (sParameterName[0] === 'c__mandateId')
         { //lets say you are looking for param name - firstName
             sParameterName[1] === undefined ? 'Not found' : sParameterName[1];
         }
     }
     component.set("v.AssId",sParameterName[1]);
     
    },
    getassname : function(component, event, helper)
    { 
        debugger;
        var recentSearch = component.get('c.getmandatename'); 
        
        recentSearch.setParams({
            "manId" : component.get('v.AssId') 
        });
        
        recentSearch.setCallback(this, function(res)  {
            var state = res.getState(); 
            
            if(state == 'SUCCESS') 
            {
               var searchRecent=res.getReturnValue();
                
                component.set('v.AssName',searchRecent);
                
                component.set('v.showElements',true);
                
            }
            else{
                component.set('v.showElements',false);
                var message=res.getReturnValue();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": message,
                    "type":"Error"
                });
                toastEvent.fire();
            }
            
        });
        $A.enqueueAction(recentSearch);	
    },   

    getprofName : function(component, event, helper)
    { 
        debugger;
        var recentSearch = component.get('c.getProfilename'); 
        
        
        recentSearch.setCallback(this, function(res)  {
            var state = res.getState(); 
            
            
            if(state == 'SUCCESS') 
            {
               var searchRecent=res.getReturnValue();
               console.log('Boolean :'+searchRecent);
               if(searchRecent == true)
               {
                   component.set('v.showMining',false);
                   console.log(component.get("v.showMining"))
               }
            }
           });
        $A.enqueueAction(recentSearch);	
    },   
    
    doSearchHelper : function(component, event, helper) {
        
        debugger;
        var recordList=[];
        var mergeDuplicate={};
        //helper.isMergeDuplicateRequiredHelper(component, event, helper);
        this.getObjectList(component, event, helper);
        var searchValue =component.get("v.SearchValue");
        var name = [];
        name = searchValue.split(' ');
        
        component.set("v.FirstName",name[0]);
        component.set("v.LastName",name[1]);
        
        component.set("v.checkSpinner",true);
        var getRecordList = component.get('c.getRecordList'); 
        
        if(searchValue.length > 0)
        {
            getRecordList.setParams({
                "searchValue" : component.get('v.SearchValue'),
                 "ProfValue" : component.get('v.showMining') 
                
            });
        }
        getRecordList.setCallback(this, function(res){
            var state = res.getState(); // get the response state
            if(state == 'SUCCESS') {
                recordList=res.getReturnValue();
                if(recordList != null)
                {
                if(recordList.length==0 ){
                    component.set("v.NoRecordFound",true);
                }else{
                    component.set("v.NoRecordFound",false);
                }
                
                for(var i=0; i<recordList.length; i++){
                    recordList[i].viewAll=false;
                    var obj=recordList[i];
                    if(recordList[i].objName == 'Contact'){
                        component.set('v.ConLength',recordList[i].recordCount);
                    } 
                    else{
                        component.set('v.AccLength',recordList[i].recordCount);
                    }
                    if(obj['objName']=='Mandate__c')
                    {
                        debugger;
                        recordList[i].isDelete=true;
                        if(recordList[i].objName == 'Contact'){
                            component.set('v.ConLength',recordList[i].recordCount);
                        }
                        else{
                            component.set('v.AccLength',recordList[i].recordCount);
                        }
                    }
                }
                }
                debugger;
                component.set('v.sobject',recordList);
                component.set("v.checkSpinner",false);
                if(! component.get("v.isOnload")){
                    this.recentSearchHelper(component,event,helper); 
                }
            }else{
                var message=res.getReturnValue();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": message,
                    "type":"Error"
                });
                toastEvent.fire();
            }
        });
        
        $A.enqueueAction(getRecordList);	
    },
    recentSearchHelper:function(component,event,helper){
        debugger;
        var searchRecent;
        var recentSearch = component.get('c.recentSearch'); 
        recentSearch.setCallback(this, function(res){
            var state = res.getState(); // get the response state
            if(state == 'SUCCESS') {
                debugger;
                searchRecent=res.getReturnValue();
                //component.set('v.sobject',res.getReturnValue());
                component.set('v.recentSearch',searchRecent);
                if(searchRecent.length >0){
                    if( component.get("v.isOnload")){
                        component.set("v.SearchValue",searchRecent[0].SearchValue__c);
                        this.doSearchHelper(component,event,helper);
                    }
                    
                    
                }
                //this.doSearchHelper(component,event,helper);
            }else{
                var message=res.getReturnValue();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": message,
                    "type":"Error"
                });
                toastEvent.fire();
            }
            
        });
        $A.enqueueAction(recentSearch);	
    },
    deleteHistoryItemHelper:function(component,event,helper){
        debugger;
        var recordId=event.getSource().get('v.title');
        // Code Added for Splice
        var allSearch = component.get('v.recentSearch');
        var index;
        for(var i=0;i<allSearch.length;i++){
            if(allSearch[i].Id == recordId)
                index = i;
        }
        allSearch.splice(index, 1);
        component.set('v.recentSearch',allSearch);
        //Splice code Ends Here
        
        
        var deleteRecord = component.get('c.deleteRecord'); 
        deleteRecord.setParams({
            "idList" :  recordId
        });
        deleteRecord.setCallback(this, function(res){
            var state = res.getState(); // get the response state
            if(state == 'SUCCESS') {
                //Do not remove
                component.set("v.isSerachRequired",true);
                //window.location.reload();
                //alert(res.getReturnValue());
            }else{
                var message=res.getReturnValue();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": message,
                    "type":"Error"
                });
                toastEvent.fire();
                
            }
            
        });
        $A.enqueueAction(deleteRecord);
    },
    keyCheckHelper:function(component,event,helper){
        if (event.which == 13){
            component.set("v.isOnload",false);
            this.doSearchHelper(component,event,helper);
        }
        
    },
    getObjectList:function(component,event,helper){
        debugger;
        var getCustomSetting = component.get('c.getCustomSetting'); 
        
        getCustomSetting.setParams({
            "ProfValue" : component.get('v.showMining') 
        });
        
        
        getCustomSetting.setCallback(this, function(res){
            var state = res.getState(); // get the response state
            if(state == 'SUCCESS') {
                var objList=res.getReturnValue();
                objList.splice(objList.indexOf('Assignment Research'),1);
                component.set('v.objList',objList);
                console.log('objList===>'+objList);
            }else{
                var message=res.getReturnValue();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": message,
                    "type":"Error"
                });
                toastEvent.fire();
            }
            
        });
        $A.enqueueAction(getCustomSetting);
    },
     addtoAssHelper:function(component,event,helper){
        debugger;
        component.set("v.displayAddCandidateToOtherAssignment",true);
    },
    
})