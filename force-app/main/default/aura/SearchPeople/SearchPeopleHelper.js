({
    industryhelper : function(component, event, helper) {
        var host = window.location.pathname;
        if(host.includes("c__SearchPeople")){
            component.set("v.ButtonColor" , "success");
        }
        debugger;
        component.set("v.checkSpinner",true);
        var pickList=[];
        var fieldList = ['Industry__c','Functional_Area_1__c','Education__c','Prof_Title__c','Country__c','State__c','Competencies_1__c'];
      	
        
        var getAllPickListValue = component.get('c.getAllPickVal'); 
        getAllPickListValue.setParams({
            'fieldList':fieldList,
            'obj':'Contact'
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
                    //INDUSTRY
                    var allIndustry = pickList['Industry__c'];
                    var industryOptions = [];
                    for(var i=0;i<allIndustry.length;i++){
                        industryOptions.push({label:allIndustry[i],value:allIndustry[i]});
                    }
                    component.set('v.lstIndustry',industryOptions);
                    //FunctionalArea
                    var allfunctionalArea = pickList['Functional_Area_1__c'];
                    var functionalAreaOptions = [];
                    for(var i=0;i<allfunctionalArea.length;i++){
                        functionalAreaOptions.push({label:allfunctionalArea[i],value:allfunctionalArea[i]});
                    }
                    component.set('v.lstgfa',functionalAreaOptions);
                    //Education
                    var allEducation = pickList['Education__c'];
                    var EducationOptions = [];
                    for(var i=0;i<allEducation.length;i++){
                        EducationOptions.push({label:allEducation[i],value:allEducation[i]});
                    }
                    component.set('v.lsteductn',EducationOptions);
                    //ProfessionalDesignation
                    var ProfessionalDesignation = pickList['Prof_Title__c'];
                    var ProfDesgOptions = [];
                    for(var i=0;i<ProfessionalDesignation.length;i++){
                        ProfDesgOptions.push({label:ProfessionalDesignation[i],value:ProfessionalDesignation[i]});
                    }
                    component.set('v.lstProfDesg',ProfDesgOptions);
                   //COUNTRY
                    var Countries = pickList['Country__c'];
                    var CountryOptions = [];
                    for(var i=0;i<Countries.length;i++){
                        CountryOptions.push({label:Countries[i],value:Countries[i]});
                    }
                    component.set('v.lstcntry',CountryOptions);
                    //STATE
                    var States = pickList['State__c'];
                    var StateOptions = [];
                    for(var i=0;i<States.length;i++){
                        StateOptions.push({label:States[i],value:States[i]});
                    }
                    component.set('v.lststate',StateOptions);
                    //COMPETENCY
                    var Competencies = pickList['Competencies_1__c'];
                    var CompetencyOptions = [];
                    for(var i=0;i<Competencies.length;i++){
                        
                        CompetencyOptions.push({label:Competencies[i],value:Competencies[i]});
                    }
                    component.set('v.lstCmptncy',CompetencyOptions);
                    
                    component.set("v.checkSpinner",false);
                    component.set("v.picklistData",true);
                }    
            }
        });
        $A.enqueueAction(getAllPickListValue);	
        
    },
     getFieldsHelper:function(component, event, helper){
        debugger;
        console.log("getFieldsHelper method called");
        var fieldsList={};
        var getFields = component.get('c.getFieldsAPIName'); 
        getFields.setCallback(this, function(res){
            var state = res.getState(); // get the response state
            if(state == 'SUCCESS') {
                fieldsList=res.getReturnValue();
                component.set("v.fieldAPIList",fieldsList['API']);
                component.set("v.fieldLabelList",fieldsList['Label']);
                console.log('Apirec='+component.get("v.fieldAPIList"));
            }
        });
        $A.enqueueAction(getFields);
    }, 
   fetchPicklistValues: function(component,objDetails,controllerField, dependentField) {
        // call the server side function  
        var action = component.get("c.getDependentMap");
        // pass paramerters [object definition , contrller field name ,dependent field name] -
        // to server side function 
        action.setParams({
            'objDetail' : objDetails,
            'contrfieldApiName': controllerField,
            'depfieldApiName': dependentField 
        });
        //set callback   
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                //store the return response from server (map<string,List<string>>)  
                var StoreResponse = response.getReturnValue();
                
                // once set #StoreResponse to depnedentFieldMap attribute 
                component.set("v.depnedentFieldMap",StoreResponse);
                
                // create a empty array for store map keys(@@--->which is controller picklist values) 
                var listOfkeys = []; // for store all map keys (controller picklist values)
                var ControllerField = []; // for store controller picklist value to set on lightning:select. 
                
                // play a for loop on Return map 
                // and fill the all map key on listOfkeys variable.
                for (var singlekey in StoreResponse) {
                    listOfkeys.push(singlekey);
                }
                
                //set the controller field value for lightning:select
                if (listOfkeys != undefined && listOfkeys.length > 0) {
                    ControllerField.push('--- None ---');
                }
                
                for (var i = 0; i < listOfkeys.length; i++) {
                    ControllerField.push(listOfkeys[i]);
                }  
                // set the ControllerField variable values to country(controller picklist field)
                component.set("v.listControllingValues", ControllerField);
            }else{
                alert('Something went wrong..');
            }
        });
        $A.enqueueAction(action);
    },
    
    fetchDepValues: function(component, ListOfDependentFields) {
        // create a empty array var for store dependent picklist values for controller field  
        var dependentFields = [];
        dependentFields.push('--- None ---');
        for (var i = 0; i < ListOfDependentFields.length; i++) {
            dependentFields.push(ListOfDependentFields[i]);
        }
        // set the dependentFields variable values to store(dependent picklist field) on lightning:select
        component.set("v.listDependingValues", dependentFields);
        
    },
})