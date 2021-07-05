({
    doInit: function(component, event, helper){
        component.find('accName').set('v.value', component.get("v.SearchKeyWord"));
        
    },
    closeModal : function(component, event, helper){

        component.set("v.displayNewCandidate",false);
    },
    handleAccountSubmit: function(component, event, helper) {
        debugger;
        event.preventDefault();
        var fields = event.getParam('fields');
        component.find('myAccForm').submit(fields);
        
    },
    handleAccerror : function(component, event, helper){
        debugger;
    },
    handleAccountSuccess : function(component, event, helper) {
        debugger;
        component.set("v.SearchKeyWord",component.find("accName").get("v.value"));
        var payload = event.getParams();
        console.log(payload.response.id);
         component.set("v.displayNewCandidate",false);
        
          var compEvent = component.getEvent("oSelectedRecordEvent");
        // set the Selected sObject Record to the event attribute.  
        compEvent.setParams({"recordByEvent" : {'Name':component.find("accName").get("v.value"),'Id':payload.response.id} });  
        // fire the event  
             compEvent.fire();
	}
 })