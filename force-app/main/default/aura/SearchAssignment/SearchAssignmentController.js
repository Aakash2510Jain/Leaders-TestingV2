({
    doInit : function(component, event, helper) 
    {
        debugger;
        helper.industryhelper(component, event, helper);
        helper.getFieldsHelper(component, event, helper);
        helper.getUserNames(component, event, helper);
        var host = window.location.pathname;
        if(host.includes("Search_Assignment")){
             component.set("v.ButtonColor" , "success");
        }
    },
    navigateToSearchCompany  : function(component, event, helper) {
        debugger;
        var urlEvent = $A.get("e.force:navigateToURL");
        var host = window.location.hostname;
        urlEvent.setParams({
            'url': '/lightning/cmp/c__SearchCompany'
        });
        urlEvent.fire();
    },
    navigateToSearchPeople  : function(component, event, helper) {
        debugger;
        var urlEvent = $A.get("e.force:navigateToURL");
        var host = window.location.hostname;
        urlEvent.setParams({
            'url': '/lightning/cmp/c__SearchPeople'
        });
        
        urlEvent.fire();
    },
    onFunctionalareavaluechange: function(component, event, helper) 
    {     
        debugger;
        var controllerValueKey = component.get("v.selectedgfa")[0];
        //var controllerValueKey = event.getSource().get("v.value"); // get selected controller field value
        var depnedentFieldMap = component.get("v.depnedentFieldMap");
        
        if (controllerValueKey != '--- None ---' && controllerValueKey != undefined ) 
        {
            var ListOfDependentFields = depnedentFieldMap[controllerValueKey];
            
            if(ListOfDependentFields.length > 0 )
            {
                component.set("v.bDisabledDependentFld" , false);  
                helper.fetchDepValues(component, ListOfDependentFields);    
            }
            else if(ListOfDependentFields.length = 0 )
            {
                component.set("v.bDisabledDependentFld" , true); 
                component.set("v.listDependingValues", ['--- None ---']);
            }  
            
        } else {
            component.set("v.listDependingValues", ['--- None ---']);
            component.set("v.bDisabledDependentFld" , true);
        }
    },
    doSearch: function(component, event, helper)
    {    
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
        debugger;
        component.set("v.checkSpinner",true);
        //checkSearchTable
        component.set("v.checkSearchTable",false);
        if(component.get('v.selectedCountryItem') != null){
            var selectedCountryItem = [];
            selectedCountryItem = component.get("v.selectedCountryItem");
        }
        if(component.get('v.selectedStateItem') != null){
            var selectedStateItem = [];
            selectedStateItem = component.get("v.selectedStateItem");
        }
        if(component.get('v.selectedIndustry') != null){
            var selectedIndustry = [];
            selectedIndustry = component.get("v.selectedIndustry");
        }
        if(component.get('v.selectedStatus') != null){
            var selectedStatus = [];
            selectedStatus = component.get("v.selectedStatus");
        }
        
        if(component.get('v.selectedStartDate') != null){
            var startdate = [];
            startdate = component.get("v.selectedStartDate");
          //  var startDt = new Date(startdate);

        }
        if(component.get('v.OpenSearch') != null){
            var opensearch = [];
            opensearch = component.get("v.OpenSearch");
        }
        if(component.get('v.StartDateTo') != null){
            var StartDateTo = [];
            StartDateTo = component.get("v.StartDateTo");
           // var startDtTo = new Date(StartDateTo);

        }
        if(component.get('v.AssignmentTitle') != null){
            var AssignmentTitle = [];
            AssignmentTitle = component.get("v.AssignmentTitle");
        }
        if(component.get('v.CompanyName') != null){
            var CompanyName = [];
            CompanyName = component.get("v.CompanyName");
        }
        if(component.get('v.selectedJobFunction') != null){
            var selectedJobFunction = [];
            selectedJobFunction = component.get("v.selectedJobFunction");
        }
        if(component.get('v.selectedLevel') != null){
            var selectedLevel = [];
            selectedLevel = component.get("v.selectedLevel");
        }
        if(component.get('v.selectedPartner1')  != null){
            debugger;
            
            var userMap = [];
            userMap = component.get('v.UserMap') ;
            
            var selectedPartner1 = [];
            var selectedPartner2  = [];
            var selectedResearcher1  = [];
            var selectedResearcher2 = [];
            selectedPartner1 = component.get('v.selectedPartner1') ;
            /*selectedPartner2 = component.get('v.selectedPartner2') ;
            selectedResearcher1 = component.get('v.selectedResearcher1') ;
            selectedResearcher2 = component.get('v.selectedResearcher2') ; 
            */
            
            var mapofuser = new Map();
            var i;
            for (i = 0; i < userMap["UserName"].length; i++) {
                mapofuser.set(userMap["UserName"][i],userMap["UserID"][i])  ;
            }   
            debugger;
            console.log('mapofuser'+mapofuser);   
            var selectedPartner1list = [];    
           /* var selectedPartner2list = [];    
            var selectedPartner3list = [];    
            var selectedPartner4list = []; */   
            
            for (var v of selectedPartner1) {
                selectedPartner1list.push(mapofuser.get(v));
                /*selectedPartner2list.push(mapofuser.get(v));
                selectedPartner3list.push(mapofuser.get(v));
                selectedPartner4list.push(mapofuser.get(v)); */
            }
        }
        /*if(component.get('v.selectedPartner2') != null){
            
            var userMap = [];
            userMap = component.get('v.UserMap') ;
            
            var selectedPartner2 = [];
            selectedPartner2 = component.get('v.selectedPartner2') ;
            
            var mapofuser = new Map();
            var i;
            for (i = 0; i < userMap["UserName"].length; i++) {
                mapofuser.set(userMap["UserName"][i],userMap["UserID"][i])  ;
            }   
            debugger;
            console.log('mapofuser'+mapofuser);   
            var selectedPartner2list = [];    
            
            
            for (var v of selectedPartner2) {
                selectedPartner2list.push(mapofuser.get(v));
            }
        }
        if(component.get('v.selectedResearcher1') != null){
            var userMap = [];
            userMap = component.get('v.UserMap') ;
            
            var selectedResearcher1 = [];
            selectedResearcher1 = component.get('v.selectedResearcher1') ;
            
            var mapofuser = new Map();
            var i;
            for (i = 0; i < userMap["UserName"].length; i++) {
                mapofuser.set(userMap["UserName"][i],userMap["UserID"][i])  ;
            }   
            debugger;
            console.log('mapofuser'+mapofuser);   
            var selectedResearcher1List = [];    
            
            
            for (var v of selectedResearcher1) {
                selectedResearcher1List.push(mapofuser.get(v));
            }
        }
        
        if(component.get('v.selectedResearcher2') != null){
            
            var userMap = [];
            userMap = component.get('v.UserMap') ;
            
            var selectedResearcher2  = [];
            selectedResearcher2 = component.get('v.selectedResearcher2') ;
            
            var mapofuser = new Map();
            var i;
            for (i = 0; i < userMap["UserName"].length; i++) {
                mapofuser.set(userMap["UserName"][i],userMap["UserID"][i])  ;
            }   
            debugger;
            console.log('mapofuser'+mapofuser);   
            var selectedResearcher2list = [];    
            
            
            for (var v of selectedResearcher2) {
                selectedResearcher2list.push(mapofuser.get(v));
            }
        }*/
        var mymap = new Map();
        
        if(selectedCountryItem != undefined)
        {
            mymap['Country__c'] = selectedCountryItem;      
        }   
        if(selectedStateItem != undefined)
        {
            mymap['State__c'] = selectedStateItem;      
        }   
        if(selectedIndustry != undefined)
        {
            mymap['Industry_Types__c'] = selectedIndustry;      
        }
        if(selectedStatus != undefined)
        {
            mymap['Assignment_Status__c'] = selectedStatus;
        }
        
        if(startdate != undefined){
            var sdArray=[];
            sdArray.push(startdate);
            mymap['Mandate_Start_Date__c'] = sdArray;      
        }
        if(StartDateTo != undefined){
            var edArray=[];
            edArray.push(StartDateTo);
            mymap['Mandate_End_Date__c'] = edArray;    
        }
        
        if(AssignmentTitle != undefined){
            var nameArray=[];
            nameArray.push(AssignmentTitle);
            mymap['Name'] = nameArray;
        }
        if(CompanyName != undefined){
            var CompArray=[];
            CompArray.push(CompanyName);
            mymap['Company_Name_French__c'] = CompArray;    
        }
        
        if(selectedJobFunction != undefined){
            mymap['Job_Function__c'] = selectedJobFunction;
        }
        if(selectedLevel != undefined){
            mymap['Level__c'] = selectedLevel;    
        }
        
        if(selectedPartner1list != undefined)        {
            mymap['Partner__c'] = selectedPartner1list; 
            mymap['Partner_2__c'] = selectedPartner1list; 
            mymap['Partner_3__c'] = selectedPartner1list;
            mymap['Consultant__c'] = selectedPartner1list;
            mymap['Researcher__c'] = selectedPartner1list;
            mymap['Researcher_3__c'] = selectedPartner1list;
            mymap['Researcher_4__c'] = selectedPartner1list;
            mymap['Researcher_5__c'] = selectedPartner1list;
        }
        
        console.log(mymap);
        
        debugger;
        var getRecordList = component.get('c.getAssignRec'); 
        var recordList = [];
        getRecordList.setParams({
            fetchdata : mymap ,
            "BooleanSearchValue": booleanvalue
        });
        getRecordList.setCallback(this, function(res)
                                  {
                                      var state = res.getState(); // get the response state
                                      if(state == 'SUCCESS'){
                                         // window.location.reload();
                                          recordList=res.getReturnValue();
                                          component.set("v.allRecord",recordList);
                                          component.set("v.checkSearchTable",true);
                                          
                                          if( recordList != null)
                                          {
                                              component.set("v.allRecordLength",recordList.length);
                                              
                                              component.set("v.checkSpinner",false);
                                              
                                              if(recordList.length == 0){
                                                  var toastEvent = $A.get("e.force:showToast");
                                                  toastEvent.setParams({
                                                      "title": "",
                                                      "message": "No record has been found for this Search.",
                                                      "type":"warning"
                                                  });
                                                  toastEvent.fire();
                                                  component.set("v.checkSearchTable",false);
                                              }               
                                          }
                                          else{
                                              var toastEvent = $A.get("e.force:showToast");
                                              toastEvent.setParams({
                                                  "title": "",
                                                  "message": "No record has been found for this Search.",
                                                  "type":"warning"
                                              });
                                              toastEvent.fire();
                                              component.set("v.checkSearchTable",false);
                                              component.set("v.checkSpinner",false);
                                          } 
                                        }
                                      else{
                                          var error=res.getError()[0].message;
                                          var toastEvent = $A.get("e.force:showToast");
                                          toastEvent.setParams({
                                              "title": "",
                                              "message": error,
                                              "type":"warning"
                                          });
                                          toastEvent.fire();
                                          component.set("v.checkSpinner",false);
                                      }
                                  });
        $A.enqueueAction(getRecordList);
        
    },
    doreset:function(component, event, helper)
    {    
        window.location.reload();
    },
    
    doMerge:function(component, event, helper) {
        debugger;
        //
        var abc= component.get("v.selectedRecord");
        component.set("v.isOpen",true);
    },
    doDelete:function(component, event, helper){
        debugger;
        //component.set("v.showConfirmDialog",true);
    },
    handleConfirmDialogNo : function(component, event, helper) {
        component.set('v.showConfirmDialog', false);
    },
    handleConfirmDialogYes : function(component, event, helper) {
        
        helper.doDeleteHelper(component, event, helper);
        component.set('v.showConfirmDialog', false);
    },
    
    viewall:function(component, event, helper) 
    {
        debugger;
        var isChecked = component.get("v.viewallrec"); 
        component.set("v.checkSpinner",true);
        setTimeout(function(){ 
            component.set("v.checkSpinner",false);
            if(isChecked == true){
                component.set("v.viewallrec",false); 
            }else{
                component.set("v.viewallrec",true); 
            }
            
        }, 3000);
    },
})