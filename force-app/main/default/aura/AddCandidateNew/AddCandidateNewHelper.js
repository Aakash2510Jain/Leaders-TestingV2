/**
 * Created by  on 12-03-2019.
 */
({
    doInitHelper: function(component,event,getInputkeyWord) 
    {
        
        var action = component.get("c.getPicklistValues");
        action.setParams({
            objectType : 'Application__c',
            selectedField : 'Status_Summary_Line__c'
        });
        
        action.setCallback(this,function(response){
            var list = response.getReturnValue();
            component.set("v.SSLValues",list);
            
        })
        $A.enqueueAction(action);
        
    },
    getTeamOfUserr : function(component,event,helper) 
    {
        debugger;
        var action = component.get("c.getTeamOfUser");
        var abc = component.get("v.contactData");
        action.setCallback(this,function(response){
            debugger;
            var userinfo = response.getReturnValue();
            //console.log(userinfo.Team__c);
            
            if(userinfo != null){
                if(userinfo.Team__c != 'Team 3')
                {
                  component.set("v.contactData.Residance_Country__c",'Canada');
                  component.set("v.CountryValue",'Canada');
                }
                //component.set("v.contactData.Residance_Country__c",'Canada');
                //component.set("v.CountryValue",'Canada');
                component.set("v.TeamOfUser",userinfo.Team__c);
            }
            
            
        })
        $A.enqueueAction(action);
        
    },
   
    showSpinner : function(component,event) {
        var spinner = component.find("mySpinner");
        $A.util.removeClass(spinner, "slds-hide");
        $A.util.addClass(spinner, "slds-show");
    },
    //This function is for to hide spinner
    hideSpinner : function(component,event) {
        var spinner = component.find("mySpinner");
        $A.util.removeClass(spinner, "slds-show");
        $A.util.addClass(spinner, "slds-hide");
    },
    contactFormFiller : function(component, event){
        var firstNameAndLastName = component.get("v.selectedContactRecord.Name");
        
        if(firstNameAndLastName != null && firstNameAndLastName != ''){
            firstNameAndLastName 	 = firstNameAndLastName.split(' ');
            if(firstNameAndLastName.length >=1)
                component.find('input_field_Firstname').set('v.value', firstNameAndLastName[0]);
            if(firstNameAndLastName.length ==2){
                component.find('input_field_Lastname').set('v.value', firstNameAndLastName[1]);
            }
        }
    },
    newContactHelper : function(component, event){
        
        component.set("v.showContactForm",true);
        debugger;
        this.contactFormFiller(component, event);
        component.set("v.showAccountForm",false);
        component.set("v.showNewContact",false);
        
    },
     gobackHelper : function(component, event){
        component.set("v.showNewContact",false);
        component.set("v.showNewAccount",false);
        component.set("v.showAccountForm",false);
        component.set("v.showContactForm",true);
        
    },
    newAccountHelper : function(component, event){
        component.set("v.showNewAccount",false);
        component.set("v.showAccountForm",true);
        var firstNameAndLastName = component.get("v.selectedAccRecord.Name");
        if(firstNameAndLastName !='')
            component.find('accName').set('v.value', firstNameAndLastName);
        
    },
    
    
    validateContactForm: function(component) {
        var validContact = true;
        
        // Show error messages if required fields are blank
        var allValid = component.find('contactField').reduce(function (validFields, inputCmp) {
            inputCmp.showHelpMessageIfInvalid();
            return validFields && inputCmp.get('v.validity').valid;
        }, true);
        
        if (allValid) {
            // Verify we have an account to attach it to
            var account = component.get("v.selectedAccRecord");
            if($A.util.isEmpty(account)) {
                validContact = false;
                alert("Please select a valid account.");
                console.log("doesn't have a valid account.");
            }
            return(validContact);
            
        }  
    },
    
    validateAccountForm: function(component) {
        var validAccount = true;
        debugger;
        // Show error messages if required fields are blank
        var allValid = component.find('accField').reduce(function (validFields, inputCmp) {
            inputCmp.showHelpMessageIfInvalid();
            return validFields && inputCmp.get('v.validity').valid;
        }, true);
        
        if (allValid) {
            // Verify we have an account to attach it to
            var account = component.get("v.simpleNewAccount");
            if($A.util.isEmpty(account)) {
                validAccount = false;
                console.log("empty account.");
            }
            return(validAccount);
            
        }  
    },
    searchContacts : function(component,event){
        debugger;
        if(component.get("v.selectedContactRecord.Name") == "" || component.get("v.selectedContactRecord.Name") == undefined)
            this.showToastMessage("error","enter search text!");
        else
            component.find("dtcContact").go(component.get("v.selectedContactRecord.Name"));
    },
    searchAccounts : function(component,event){
        debugger;
        if(component.get("v.selectedAccRecord.Name") == "" || component.get("v.selectedAccRecord.Name") == undefined)
            this.showToastMessage("error","enter search text!");
        else
            component.find("dtcAccount").go(component.get("v.selectedAccRecord.Name"));
    },
    
    lookupSelectedEvent : function(component, event){
        debugger;
        var source = event.getParam("source");
        if(source == "Contact"){
            this.handlecancelLookupDialog(component, event);
        }
    },
    
    lookupClickHelper : function(component, event)
    {
        component.set("v.showNewContact",true);
        component.set("v.showNewAccount",false);
    },
    cancelContactForm : function(component, event){
        var payload = event.getParams().response;
        if(payload)
        {
            var selectedRecord = {Id:payload.id,Name : payload.fields.FirstName.value};
            component.set("v.selectedContactRecord",selectedRecord);
            this.handlecancelLookupDialog(component,event);
        }
        
    },
    cancelAccountForm : function(component, event){
        component.set("v.showNewContact",false);
        component.set("v.showNewAccount",false);
        component.set("v.showAccountForm",false);
        component.set("v.showContactForm",true);
        var payload = event.getParams().response;
        if(payload){
            var selectedRecord = {Id:payload.id,Name : payload.fields.Name.value};
            component.set("v.selectedAccRecord",selectedRecord);
        }
        
        
    },
    openAccountform : function(component,event){
        var contactData = component.get("v.contactData");
        if(contactData.Title == "" || contactData.Title == undefined || contactData.Functional_Area_1__c == "" || contactData.Functional_Area_1__c == undefined ){
            this.showToastMessage("Error","Title and Functional Area is manditory before selecting Company");
            return;
        }
        component.set("v.showNewAccount",true);
        component.set("v.showContactForm",false);
        
    },
    cancelShowNewContact : function(component, event, helper){
        component.set("v.showLookupDialog",false);
        component.set("v.showAccountForm",false);
        component.set("v.showNewAccount",false);
        component.set("v.showNewContact",true);
        component.set("v.showContactForm",false);
    },
    cancelShowNewAccount : function(component, event, helper){
        component.set("v.showNewContact",false);
        component.set("v.showNewAccount",false);
        component.set("v.showContactForm",true);
        component.set("v.showAccountForm",false);
    },
    doneEventHandler : function(component,event){
        debugger;
        var type = event.getParam("type");
        if(type == "Contact"){
            this.handlecancelLookupDialog(component,event);
        }else{
            //component.set("v.showNewContact",true);
            component.set("v.showNewAccount",false);
            component.set("v.showContactForm",true);
            this.contactFormFiller(component, event);
        }
    },
    showToastMessage : function(title,message)
    {
        var toastEvent = $A.get("e.force:showToast");  
        toastEvent.setParams({  
            "title": title,  
            "message": message  
        });
        toastEvent.fire();
    },
    
    conditionForLocation : function(component, event, helper) 
    {
        
        var abc = component.get("v.mandateRecId");
        if(abc != undefined){
            
            var action = component.get("c.getValueofLocationCheckbox");
            
            action.setParams({
                   "Mandateid":abc 
            });
            
            action.setCallback(this,function(response){  
                if(response.getState() == 'SUCCESS'){
                    component.set("v.RequiredLoccation",response.getReturnValue());
                }
            });
            $A.enqueueAction(action);
        }
       
            
        
        
    },
    handlecancelLookupDialog: function(component, event, helper){
    	component.set("v.ShowCandidate",false);
	}
})