({
    helperMethod : function() {
        
    },
    getRelatedAssignments: function(component,event,helper)
    {
        var canid = component.get("v.candidateId");
        var action = component.get("c.getRelatedAssignmentRec");
        action.setParams({
            'recordId' : canid
        });
        action.setCallback(this,$A.getCallback(function(response){
            var state = response.getState();
            
            if(state=="SUCCESS"){
                component.set("v.mydata",response.getReturnValue());
                //component.set("v.checkSpinner", false);
            }
            else if(state=="ERROR"){
                var error = response.getError();
                console.error(errors);
               // component.set("v.checkSpinner", false);
            }
            
        }));
        
        $A.enqueueAction(action);
    },
    viewNotes:function(component,event,helper){
        debugger;
        var ApplicationID = component.get("v.candidateId");
        var getAllNotes = component.get("c.getAllNotes");
        getAllNotes.setParams({
            contactAssigned : ApplicationID
        });
        getAllNotes.setCallback(this,$A.getCallback(function(response){
            var state = response.getState();
            if(state=="SUCCESS"){
                if(response.getReturnValue().length > 0){
                    component.set("v.noNotes",true);
                    component.set("v.NotesList",response.getReturnValue()[0]);   
                    component.set("v.NotesListfromAllAss",response.getReturnValue()[1]);  
                    component.set("v.checkSpinner", false);
                }
                else{
                    component.set("v.noNotes",false);
                    component.set("v.checkSpinner", false);
                }
            }
            else if(state=="ERROR"){
                var error = response.getError();
                console.error(errors);
                component.set("v.checkSpinner", false);
            }
        }));
        $A.enqueueAction(getAllNotes);
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
    fetchOnePagerValues : function(component,event,helper){
        debugger;
        var action=component.get("c.fetchOnePagerRatingValues");
        action.setParams({
            mandateRecId : component.get("v.mandateRecId"),
            AppId : component.get("v.candidateId")
        });
        action.setCallback(this, function(response){
            var state= response.getState();
            if(state == 'SUCCESS') {
                debugger;
                var lrn = response.getReturnValue();  
                component.set("v.OnePagerRating",lrn);
                //component.set("v.OnePagerRating",lrn[1]);
                
            }
        });
        $A.enqueueAction(action);
    },
    saveOnePagerRatingValues : function(component,event,helper)
    {
        debugger;   
        var value =  component.get("v.OnePagerRating");
        var action = component.get("c.Create_OnePagerRating_Res");
        action.setParams({
            appId : component.get("v.candidateId"),
            resp : value
        });
        action.setCallback(this,function(response){
            var list = response.getReturnValue();
            var state= response.getState();
            if(state == 'SUCCESS') {
                
            }
        })
        $A.enqueueAction(action);
    },
    fetchCompetencies : function(component,event,helper){
        console.log("inside Competencies");
        var action=component.get("c.fetchCompetencyData");
        action.setParams({
            mandateRecId : component.get("v.mandateRecId"),
            AppId : component.get("v.candidateId")
        });
        action.setCallback(this, function(response){
            var state= response.getState();
            if(state == 'SUCCESS') {
                debugger;
                var lrn = response.getReturnValue();   
                if(response.getReturnValue() != null && response.getReturnValue().length != 0)
                {
                    component.set("v.displayCompetency",true);
                    component.set("v.competencyWrapper",lrn);
                    console.log(response.getReturnValue());
                }
                else{
                    component.set("v.displayCompetency",false);
                }
            }
        });
        $A.enqueueAction(action);
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
        debugger;
        var field1 = component.find("canSD");
        if(field1 != undefined)
        {
            if(field1.get("v.validity").valid) {
                // continue processing
            } else {
                debugger;
                field1.showHelpMessageIfInvalid();
                return;
            }
        }
        var action = component.get("c.saveLeadersNote");
        debugger;
         if(!component.get("v.openEditLRNComp"))
            if(component.get("v.leaderNote") != undefined && component.get("v.leaderNote") != null){
                delete component.get("v.leaderNote")['Id'];
            }
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
    saveCompetencyResponse : function(component,event,helper)
    {
        debugger;   
        var value =  component.get("v.competencyWrapper");
        //  var rating =  component.get("v.OnePagerRating");
        var valueOfOp =  component.get("v.OnePagerRating");
        // var compRes = Json.se            
        var action = component.get("c.Create_Comp_Rec");
        action.setParams({
            appId : component.get("v.candidateId"),
            selectedField :JSON.stringify(value),
        });
        
        action.setCallback(this,function(response){
            var list = response.getReturnValue();
            var state= response.getState();
            if(state == 'SUCCESS') {
                
            }
        })
        $A.enqueueAction(action);
    },
    handleShowToast : function(component,event,helper)
    {   swal.fire({
        title: "success!",
        text: "The record created successfully.",
        type: "success",
        timer: 3000
    });
    },
    
    closeModel: function(component,event,helper){
        var cmpTarget = component.find('Modalbox');
        var cmpBack = component.find('Modalbackdrop');
        $A.util.removeClass(cmpBack,'slds-backdrop--open');
        $A.util.removeClass(cmpTarget, 'slds-fade-in-open'); 
        component.set("v.openLRNComp",false);
    }
})