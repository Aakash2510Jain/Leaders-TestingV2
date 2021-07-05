({
    doInit: function(component, event, helper){
        debugger;
        //component.find('ConName').set('v.value', component.get("v.SearchKeyWord"));
        
    },
    closeModal : function(component, event, helper){

        component.set("v.ShowCandidate",false);
    },
    handleConSubmit: function(component, event, helper) {
        debugger;
        event.preventDefault();
        var fields = event.getParam('fields');
        fields.Residence_City__c = component.get("v.selectedRecord");
        component.find('myConForm').submit(fields);
        
    },
    addtoAssignment:function(component, event, helper) {
        event.preventDefault();
        var fields = event.getParam('fields');
        fields.Residence_City__c = component.get("v.selectedRecord");
        component.find('myConForm').submit(fields);
        
        //code to open Assignment Form
    },
    handleConcerror : function(component, event, helper){
        debugger;
    },
    handleConSuccess : function(component, event, helper) {
        debugger;
       // component.set("v.SearchKeyWord",component.find("ConName").get("v.value"));
        var payload = event.getParams();
       // fields.Residence_City__c = component.get("v.selectedRecord");
        console.log(payload.response.id);
        alert(payload.response.id);
        component.set("v.conrecId",payload.response.id);
        component.set("v.showConForm",false);
        /* component.set("v.ShowCandidate",false);
        
          var compEvent = component.getEvent("oSelectedRecordEvent");
        // set the Selected sObject Record to the event attribute.  
        compEvent.setParams({"recordByEvent" : {'Name':component.find("ConName").get("v.value"),'Id':payload.response.id} });  
        // fire the event  
             compEvent.fire();*/
	}
 })