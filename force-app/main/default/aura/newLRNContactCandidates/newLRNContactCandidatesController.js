({
	myAction : function(component, event, helper) {
		
	},
    
    doEvent : function(component,event,helper){
        var canId = event.getParam("contactCandidateId");
        console.log(canId);
        component.set("v.candidateId",canId);
        
        component.find("SSL").set("v.value","Test SSSL");
    },
    
    
    
    doInit : function(component,event,helper){
        
       /* var params = event.getParam('arguments');
        if (params) {
            var param1 = params.param1;
            // add your code here
        }
        console.log(param1);*/
        
      /*  var canId = event.getParam("candidateId");
        console.log(canId);
        component.set("v.candidateId",canId);*/
        
        console.log("inside DoInit")
        var cid =  component.get("v.candidateId");
        console.log(cid);
        
        
        
        helper.fetchSSL(component,event,helper)
        
        helper.fetchLRN(component,event,helper)
    },
    
    setCandidateId : function(component,event,helper){
        var canId = event.getParam("contactCandidateId");
        console.log(canId);
        component.set("v.candidateId",canId);
    },
    
    closeModel: function(component,event,helper){
        var cmpTarget = component.find('Modalbox');
		var cmpBack = component.find('Modalbackdrop');
		$A.util.removeClass(cmpBack,'slds-backdrop--open');
		$A.util.removeClass(cmpTarget, 'slds-fade-in-open'); 
        component.set("v.openLRNComp",false);
        component.set("v.openEditLRNComp",false);
    },
    
    saveLRN : function(component,event,helper){
        debugger;
        helper.saveLeadersNote(component,event,helper)
        
    },
    openFinalAcceptanceDialogue: function(component,event,helper){
        debugger;
        if(component.get("v.selectedValue")=='Final candidate, has accepted the offer of employment.'){
            $A.createComponent(
            "c:LRNConfirmationComponent",
            {
                "message":"This Candidate will now be off limit. Please update employment information(Company Name and Title)."
            },
            function(msgBox){                
                if (component.isValid()) {
                    var targetCmp = component.find('ModalDialogPlaceholder');
                    var body = targetCmp.get("v.body");
                    body.push(msgBox);
                    targetCmp.set("v.body", body); 
                }
            });
        }
        
    },
    handleConfirmDialogNo: function(component,event,helper){
         component.set("v.showConfirmDialog",false);
    }
   
})