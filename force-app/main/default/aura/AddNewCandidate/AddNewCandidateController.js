/**
 * Created by  on 12-03-2019.
 */
({
    closeModal : function(component, event, helper){
        component.set("v.displayNewCandidate",false);
    },
    doInit: function(component, event, helper) {
       helper.fetchSSL(component,event,'Meeting_Note__c','Status_Summary_Line__c','v.SSLValues');
       helper.fetchSSL(component,event,'Application__c','Origin__c','v.originList');
       helper.fetchSSL(component,event,'Contact','Location__c','v.locationList');
       helper.conditionForLocation(component, event, helper);

    },
    saveAppRecord: function(component, event, helper){

       helper.saveAppRecordHelper(component,event,helper);
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
    /*handleSaveContact : function(component, event, helper){
      helper.handleSaveContactHelper(component,event);
    },*/
    /*handleSaveAccount : function(component, event, helper){
      helper.handleSaveAccountHelper(component,event);
    },*/
    cancelLookupDialog : function(component, event, helper){
      helper.handlecancelLookupDialog(component,event);
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
    handleContactSuccess : function(component, event, helper) {
        debugger;
        var payload = event.getParams().response;
        console.log(JSON.stringify(payload));
        helper.cancelContactForm(component,event);
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