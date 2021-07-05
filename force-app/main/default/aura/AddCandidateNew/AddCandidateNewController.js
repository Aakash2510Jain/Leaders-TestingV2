/**
 * Created by  on 12-03-2019.
 */
({
    closeModal : function(component, event, helper){
        component.set("v.displayNewCandidate",false);
    },
    doInit: function(component, event, helper) {
        debugger;
        console.log(component.get('v.FirstName'));
        console.log(component.get('v.LastName'));
        component.set("v.contactData",{FirstName:component.get("v.FirstName"),LastName:component.get("v.LastName")});
        helper.conditionForLocation(component, event, helper);
        helper.getTeamOfUserr(component,event,helper);
    },
  
    cancelOperation: function(component, event, helper){
     helper.cancelOperationHelper(component,event,helper);
    },
    newContact : function(component, event, helper){
      helper.newContactHelper(component,event);
    },
    newAccount : function(component, event, helper){
      helper.newAccountHelper(component,event);
    },
    lookupClick : function(component, event, helper){
      helper.lookupClickHelper(component, event);
    },
    cancelContactForm : function(component, event, helper){
      helper.cancelContactForm(component, event);
    },
    cancelAccountForm : function(component, event, helper){
      helper.cancelAccountForm(component, event);
    },
    handleComponentEvent : function(component, event, helper){
      helper.lookupSelectedEvent(component, event);
    },
    searchContacts : function(component, event, helper){
      helper.searchContacts(component, event);
    },
    searchAccounts : function(component, event, helper){
      helper.searchAccounts(component, event);
    },
    openAccountform : function(component, event, helper){
      helper.openAccountform(component, event);
    },
    doneEventHandler : function(component, event, helper){
      helper.doneEventHandler(component,event);
    },
    cancelShowNewContact : function(component, event, helper){
      helper.cancelShowNewContact(component,event);
    },
    cancelShowNewAccount : function(component, event, helper){
      helper.cancelShowNewAccount(component,event);
    },
      goback : function(component, event, helper){
      helper.gobackHelper(component,event);
    },
    handleContactSuccess : function(component, event, helper) {
        debugger;
        var payload = event.getParams().response;
        console.log(JSON.stringify(payload));
        helper.cancelContactForm(component,event);
        console.log('onsuccess: ',"Contact has been created");
         
    },
    handleContactSubmit: function(component, event, helper) {
       debugger;
        event.preventDefault();       // stop the form from submitting
        var fields = event.getParam('fields');
        var acc = component.get("v.selectedAccRecord.Id");
        if(acc){
            if(component.get("v.selectedAccRecord.Id"))
            fields.AccountId = component.get("v.selectedAccRecord.Id");
            component.find('myContactForm').submit(fields);
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Success",
                "message": "Contact has been Created"
            });
            toastEvent.fire();
             component.set("v.displayNewCandidate",false);
             window.location.reload();
        }
        else{
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Erorr!",
                "message": "Please select company inorder to save People record!"
            });
            toastEvent.fire();
        }
    },
    
    handleAccountSuccess : function(component, event, helper) {
        debugger;
        //var payload = event.getParams().response;
        //console.log(JSON.stringify(payload));
        helper.cancelAccountForm(component,event);
    },
    handleAccountSubmit: function(component, event, helper) {
        debugger;
        event.preventDefault();       // stop the form from submitting
        var fields = event.getParam('fields');
        /*fields.BillingCountryCode = fields.BillingCountry;
        fields.BillingStateCode = fields.BillingState;*/
        component.find('myAccForm').submit(fields);
        
    },
    handleAccerror : function(component, event, helper)
    {
      debugger;
    },
    handleSubmit : function(cmp, event, helper) {
        event.preventDefault();       // stop the form from submitting
        const fields = event.getParam('fields');
        fields.LastName = 'My Custom Last Name'; // modify a field
        cmp.find('myRecordForm').submit(fields);
    }


})