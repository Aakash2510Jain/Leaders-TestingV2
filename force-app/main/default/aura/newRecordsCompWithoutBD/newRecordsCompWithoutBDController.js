({
	opencontact : function(component, event, helper) {
	//	component.set('v.showPeopleModal',true);
        
        
        var cmpTarget = component.find('Modalbox');
		var cmpBack = component.find('Modalbackdrop');
		$A.util.addClass(cmpTarget, 'slds-fade-in-open');
		$A.util.addClass(cmpBack, 'slds-backdrop--open');
        
	},
    
    openDM :function(component,event,helper){
        var cmpTarget = component.find('Modalbox1');
        var cmpBack = component.find('Modalbackdrop1');
        $A.util.addClass(cmpTarget,'slds-fade-in-open');
        $A.util.addClass(cmpBack,'slds-backdrop--open');
    },
    
    closeDM:function(component,event,helper){    
		var cmpTarget = component.find('Modalbox1');
		var cmpBack = component.find('Modalbackdrop1');
		$A.util.removeClass(cmpBack,'slds-backdrop--open');
		$A.util.removeClass(cmpTarget, 'slds-fade-in-open'); 
    	}, 
    
    closeModal:function(component,event,helper){    
		var cmpTarget = component.find('Modalbox');
		var cmpBack = component.find('Modalbackdrop');
		$A.util.removeClass(cmpBack,'slds-backdrop--open');
		$A.util.removeClass(cmpTarget, 'slds-fade-in-open'); 
    	},
	openmodal:function(component,event,helper) {
		var cmpTarget = component.find('Modalbox');
		var cmpBack = component.find('Modalbackdrop');
		$A.util.addClass(cmpTarget, 'slds-fade-in-open');
		$A.util.addClass(cmpBack, 'slds-backdrop--open'); 
	},
    
    keyPressOpenSearch : function(component,event,helper){
      //  console.log(event.getParams().keyCode);
      //   console.log(event.getParam('keyCode'));
      		if(event.keyCode == 13){
        //	alert('Enter key pressed');
                
              var searchField = component.find('searchPeople');
         	  var isValueMissing = searchField.get('v.validity').valueMissing;
         
                // If value is missing show an error message and focus on field
                
                 if(isValueMissing){
                     searchField.showHelpMessageIfInvalid();
                     searchField.focus();
                 }else{
                      component.set("v.openSearchModal",true);
                 }       
                
                
                
	      	}
      //  alert('Enter key pressed');
         
    },
    
    
    
     openSearch : function(component,event,helper){
         
         
       
         var searchField = component.find('searchPeople');
         var isValueMissing = searchField.get('v.validity').valueMissing;
         
        // If value is missing show an error message and focus on field
        
         if(isValueMissing){
             searchField.showHelpMessageIfInvalid();
             searchField.focus();
         }
         else{
              component.set("v.openSearchModal",true);
         }
         
    },
    
    
    keyPressOpenSearchCompany : function(component,event,helper){
     	if(event.keyCode == 13){
    
     		var searchField = component.find('searchCompany');
        var isValueMissing = searchField.get('v.validity').valueMissing;
        
        // If value is missing show an error message and focus on field
        
        if(isValueMissing){
            searchField.showHelpMessageIfInvalid();
            searchField.focus();
        }else{
            component.set("v.openSearchCompanyModal",true);
        }
        
    
    
		}
	},
       
    
    
    openSearchCompany : function(component,event,helper){
        
        
            var searchField = component.find('searchCompany');
        var isValueMissing = searchField.get('v.validity').valueMissing;
        
        // If value is missing show an error message and focus on field
        
        if(isValueMissing){
            searchField.showHelpMessageIfInvalid();
            searchField.focus();
        }else{
            component.set("v.openSearchCompanyModal",true);
        }
        
        
   },
    
    keyPressOpenSearchBD : function(component,event,helper){
        if(event.keyCode == 13){
          component.set("v.openSearchBDModal",true);  
        }
        
    },
    
    openSearchBD : function(component,event,helper){
        component.set("v.openSearchBDModal",true);
    },
    
   /* createContact: function(component,event,helper){
        var createRecordEvent =$A.get("e.force:createRecord");
        createRecordEvent.setParams({
            "entityApiName":"Contact"
        });
        createRecordEvent.fire();
    }, */
    
    createCompany : function(component,event,helper){
        var createCompanyRecordEvent =$A.get("e.force:createRecord");
        createCompanyRecordEvent.setParams({
            "entityApiName":"Account"  
        });
        createCompanyRecordEvent.fire();
   },
    
    createMandate : function(component,event,helper){
        var createMandateRecordEvent =$A.get("e.force:createRecord");
        createMandateRecordEvent.setParams({
            "entityApiName":"Mandate__c"
        });
        
        createMandateRecordEvent.fire();
    },
    
    createBD : function(component,event,helper){
        var createBDRecordEvent = $A.get("e.force:createRecord");
        createBDRecordEvent.setParams({
            "entityApiName" : "Business_Development__c"
        });
        
        createBDRecordEvent.fire();
        
    },
    
    gotoContact : function(component,event,helper){
        var urlEvent=$A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url":"/lightning/o/Contact/list?filterName=Recent"
        });
        
        urlEvent.fire();
    },
    
    gotoCompany : function(component,event,helper){
        var urlEvent=$A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url":"/lightning/o/Account/list?filterName=Recent"   
            });
        urlEvent.fire();
    },
    
    gotoBD :function(component,event,helper){
        var urlEvent=$A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url":"/lightning/o/Business_Development__c/list?filterName=Recent"
        });
        urlEvent.fire();
    },
    
    gotoSearchPeople : function(component,event,helper){
        var urlEvent=$A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url":"/lightning/n/Search_Tool_Contacts"
        });
        urlEvent.fire();
    },
    
    gotoSearchCompany : function(component,event,helper){
        var urlEvent=$A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url":"/lightning/n/Search_Tool_Companies"
        });
        urlEvent.fire();
    },
    
    gotoSearchAssignment : function(component,event,helper){
        var urlEvent=$A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url":"/lightning/n/Search_Tool_Assignments"
        });
        urlEvent.fire();
    }
    
})