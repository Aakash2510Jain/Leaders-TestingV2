({
    helperMethod : function() {
        
    },
    
    fetchLRN : function(component,event,helper){
        console.log("inside fetchLRN");
        var action=component.get("c.getLeaderNote");
        action.setParams({
            canId : component.get("v.candidateId")
        });
        
        action.setCallback(this, function(response){
            var state= response.getState();
            if(state == 'SUCCESS') {
                debugger;
                var lrn = response.getReturnValue();   
                if(lrn.Length!=0)
                {
                    component.set("v.leaderNote",lrn);
                    component.set("v.selectedValue",lrn.Status_Summary_Line__c);   
                    console.log(response.getReturnValue());
                    var lrn_ssl = component.get("v.leaderNote.Status_Summary_Line__c")
                    component.set("v.SSLValue",lrn_ssl);
                    console.log(lrn_ssl);
                    
                }
            }
            
            
            
        });
        $A.enqueueAction(action);
        console.log("finish fetchLRN");
    },
    
    fetchSSL : function(component,event,helper)
    {
        var action = component.get("c.getPicklistValues");
        action.setParams({
            objectType : 'Meeting_Note__c',
            selectedField : 'Status_Summary_Line__c'
        });
        
        action.setCallback(this,function(response){
            var list = response.getReturnValue();
            debugger;
            component.set("v.SSLValues",list);
            
        })
        $A.enqueueAction(action);
    },
    
    saveLeadersNote : function(component,event,helper)
    {
        /* if(component.get("v.selectedValue") =='Final candidate, has accepted the offer of employment.' && component.get("v.leaderNote").Candidate_Offer_Date__c==undefined){
            alert('Please select candidate employment date');
            return;
          }  */
        debugger;
		if(component.get("v.selectedValue") =='Final candidate, has accepted the offer of employment.' && component.get("v.leaderNote").Candidate_Offer_Date__c==undefined){

            var field1 = component.find("canSD");
           
            if(("v.validity").valid != undefined)
            {
                if(field1.get("v.validity").valid) 
                {
    
                } 
                else 
                {
                    debugger;
                    field1.showHelpMessageIfInvalid();
                    return;
                }
        	}
        }
        
        var action = component.get("c.saveLeadersNote");
        debugger;
        if(!component.get("v.openEditLRNComp"))
            delete component.get("v.leaderNote")['Id'];
        
        action.setParams({
            lrn : component.get("v.leaderNote"),
            ssl : component.get("v.selectedValue")
        });
        
        action.setCallback(this,function(response){
            var state = response.getState();
            var newlrn = response.getReturnValue();
            component.set("v.insertedLRN",newlrn);
            //v fix refreshView;
            helper.handleShowToast(component,event,helper)
            helper.closeModel(component,event,helper)
            var lrn_ssl = component.get("v.insertedLRN.Status_Summary_Line__c")
            component.set("v.SSLValue",lrn_ssl);
            console.log(lrn_ssl);
            $A.get('e.force:refreshView').fire();
        });
        $A.enqueueAction(action);
    },
    
    handleShowToast : function(component,event,helper)
    {
        component.find("notifLib").showToast({
            "variant" : 'success',
            "mode" : 'pester', 
            "duration" : 3000,
            "title": "Success",
            "message": "The record created successfully."        
        });
    },
    
    closeModel: function(component,event,helper){
        var cmpTarget = component.find('Modalbox');
        var cmpBack = component.find('Modalbackdrop');
        $A.util.removeClass(cmpBack,'slds-backdrop--open');
        $A.util.removeClass(cmpTarget, 'slds-fade-in-open'); 
        component.set("v.openLRNComp",false);
        component.set("v.openEditLRNComp",false);
        
    }
})