({
    doInit : function(component, event, helper) 
    {
        debugger;
        var host = window.location.pathname;
        if(host.includes("c__SearchPeople")){
            component.set("v.ButtonColor" , "success");
        }
        helper.industryhelper(component, event, helper);
        helper.getFieldsHelper(component, event, helper);
        // call the helper function
        //helper.fetchPicklistValues(component,objDetails,controllingFieldAPI, dependingFieldAPI);
        
    },
    closeModal: function(component,event,helper){
        component.set("v.AddTootherAssWarning",false);
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
    
    
    navigateToSearchAss  : function(component, event, helper) {
        debugger;
        var urlEvent = $A.get("e.force:navigateToURL");
        var host = window.location.hostname;
        urlEvent.setParams({
            'url': '/lightning/n/Search_Assignment'
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
            if(depnedentFieldMap != null && depnedentFieldMap != undefined){
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
            }{
                component.set("v.bDisabledDependentFld" , true); 
                component.set("v.listDependingValues", ['--- None ---']);
            }
              
            
        } else {
            component.set("v.listDependingValues", ['--- None ---']);
            component.set("v.bDisabledDependentFld" , true);
        }
    },
    
    doSearch:function(component, event, helper)
    {    
        debugger;
        component.set("v.checkSpinner",true);
        component.set("v.showResult",false);
        var indstryvalue = [];
        indstryvalue = component.get("v.selectedIndustry");
        
        var funcareavalue = [];
        funcareavalue = component.get("v.selectedgfa");
        
        var ProfDesgvlu = [];
        ProfDesgvlu = component.get("v.selectedProfDesg");
        
        var edeductn = [];
        edeductn = component.get("v.selectedeductn");
        
        var cntryvlu = [];
        cntryvlu = component.get("v.selectedcntry");
        
        var statevlu = [];
        statevlu = component.get("v.selectedstate");
        
        var Cmptncyvlu = [];
        Cmptncyvlu = component.get("v.selectedCmptncy");
        
        var Titlevlu = [];
        Titlevlu = component.get("v.selectedTitle");
        var mymap = {};
        mymap['Industry_Type__c'] = indstryvalue;        
        mymap['Functional_Area_1__c'] = funcareavalue;
        mymap['Education__c'] = edeductn;
        mymap['Prof_Title__c'] = ProfDesgvlu;
        mymap['Country__c'] = cntryvlu;
        mymap['Competencies_1__c'] = Cmptncyvlu;
        mymap['Office_State__c'] = statevlu;
        
        var titleArray = [];
        if(Titlevlu != '' && Titlevlu != undefined){
            titleArray[0] = Titlevlu;
            mymap['Title'] = titleArray;
        }
        console.log(mymap);
        debugger;
        var ValueForBooleanSearch = component.get("v.ValueForBooleanSearch");
        var OnePagerSearch = component.get("v.ValueForOPSearch");
        var getRecordList = component.get('c.getPeopleRec'); 
        //alert(ValueForBooleanSearch+'--'+OnePagerSearch+'--'+getRecordList);
        if(ValueForBooleanSearch != undefined || OnePagerSearch != undefined ){
            swal.fire({
                title: "Success",
                text: "We are only showing you 2000 records",
                type: "success",
                timer: 3000,
                showConfirmButton: false
            });
        }
        var recordList = [];
        getRecordList.setParams({
            fetchdata : mymap,
            BooleanSearchValue : ValueForBooleanSearch,
            opSearchValue : OnePagerSearch
            
        });
        getRecordList.setCallback(this, function(res)
                                  {
                                      var state = res.getState(); // get the response state
                                      if(state == 'SUCCESS'){
                                          recordList=res.getReturnValue();
                                          
                                          var sortAsc;
                                          sortAsc =  !sortAsc;
                                          var field = 'Name';
                                          var allData = recordList;
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
                                          
                                          component.set("v.ReturnedContact",allData);
                                          component.set("v.allRecordLength",recordList.length);
                                          component.set("v.checkSpinner",false);
                                          if(recordList.length>0){
                                              component.set("v.showResult",true);
                                          }else{
                                              var toastEvent = $A.get("e.force:showToast");
                                              toastEvent.setParams({
                                                  "title": "Error!",
                                                  "message": "No record has been found for this Search.",
                                                  "type":"warning"
                                              });
                                              toastEvent.fire();
                                              component.set("v.showResult",false);
                                          }
                                          
                                      }else{
                                          var error=res.getError()[0].message;
                                          var toastEvent = $A.get("e.force:showToast");
                                          toastEvent.setParams({
                                              "title": "Error",
                                              "message": error,
                                              "type":"warning"
                                          });
                                          toastEvent.fire();
                                          
                                          
                                      }
                                  });
        $A.enqueueAction(getRecordList);
        component.set("v.checkSearchTable",true);
    },
    doreset:function(component, event, helper)
    {    
        window.location.reload();
    },
    addtoassgn:function(component, event, helper)
    {
        var selectedCandidates = component.get("v.selectedRecord");
        if(selectedCandidates.length > 0){
            component.set("v.displayAddCandidateToOtherAssignment",true);     
        }else{
            component.set("v.AddTootherAssWarning",true);
        }
        
    },
    doMerge:function(component, event, helper) {
        debugger;
        var selectedCandidates = component.get("v.selectedRecord");
        if(selectedCandidates.length > 0){
            var abc= component.get("v.selectedRecord");
            component.set("v.isOpen",true);   
        }else{
            component.set("v.AddTootherAssWarning",true);
        }
        
      
    },
    viewall:function(component, event, helper) 
    {
        debugger;
        component.set("v.checkSpinner",true);
        var isChecked = component.get("v.viewallrec"); 
        
        if(isChecked == false){
            component.set("v.viewallrec",true);   
        }else{
            component.set("v.viewallrec",false);
        }
        setTimeout(function(){ 
            debugger;
            if(component.get("v.checkSpinner")==true){
                component.set("v.checkSpinner",false);
            }
        }, 3000);
        
    },
})