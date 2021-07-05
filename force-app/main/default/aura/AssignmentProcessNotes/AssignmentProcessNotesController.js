({
    doInit: function(component, event, helper) {
        
        helper.fetchDataHelper(component,event,helper);
        helper.getvalueofstatusandmoduleHelper(component,event,helper);
           
    },
    reInit : function(component, event, helper) {
        $A.get('e.force:refreshView').fire();
    },
    getvalueofstatusandmodule : function(component, event, helper) {
        debugger;
        helper.getvalueofstatusandmoduleHelper(component,event,helper);
    },
 
    Modulechange : function(component, event, helper) {
        debugger;
        component.set("v.displayChangeModule", true);
        helper.getValueOfmodule(component,event,helper);
    },
    closeModule : function(component, event, helper) {
        debugger;
        component.set("v.displayChangeModule", false);
    },
    updateModule : function(component, event, helper) {
        debugger;
        
        helper.updatemodulehelper(component, event, helper);
        
        
    },
    statuschange : function(component, event, helper) {
        debugger;
        component.set("v.displayChangeStatus", true);
        helper.getValueOfStatus(component,event,helper);
    },
    closeStatus : function(component, event, helper) {
        debugger;
        component.set("v.displayChangeStatus", false);
    },
    updatestatus : function(component, event, helper) {
        debugger;
        
        helper.updatestatushelper(component, event, helper);
    },
    
    sectionOne : function(component, event, helper) {
        helper.helperFun(component,event,'articleOne');
    },
    sectiontwo : function(component, event, helper) {
        helper.helperFun(component,event,'articletwo');
    },
    sectionthree : function(component, event, helper) {
        helper.helperFun(component,event,'articlethree');
    },
    sectionfour : function(component, event, helper) {
        helper.helperFun(component,event,'articlefour');
    },
    sectionfive : function(component, event, helper) {
        helper.helperFun(component,event,'articlefive');
    },
    sectionsix : function(component, event, helper) {
        helper.helperFun(component,event,'articlesix');
    },
    sectionseven : function(component, event, helper) {
        helper.helperFun(component,event,'articleseven');
    },
    sectioneight : function(component, event, helper) {
        helper.helperFun(component,event,'articleeight');
    },
    sectionnine : function(component, event, helper) {
        helper.helperFun(component,event,'articlenine');
    },
    sectionten : function(component, event, helper) {
        helper.helperFun(component,event,'articleten');
    },
    sectioneleven : function(component, event, helper) {
        helper.helperFun(component,event,'articleeleven');
    },
    sectiontwelve : function(component, event, helper) {
        helper.helperFun(component,event,'articletwelve');
    },
    sectionthirteen : function(component, event, helper) {
        helper.helperFun(component,event,'articleethirteen');
    },
    sectiontfourteen : function(component, event, helper) {
        helper.helperFun(component,event,'articleFourteen');
    },
    sectionfifteen : function(component, event, helper) {
        helper.helperFun(component,event,'articlefifteen');
    },
     sectionSixteen : function(component, event, helper) {
        helper.helperFun(component,event,'articleSixteen');
    },
    
    
    updateField: function(component,event,helper){
        debugger;
        var fieldValue = event.currentTarget.getAttribute('data-fieldValue');
        var fieldName = event.currentTarget.getAttribute('data-fieldName');
        
        var AssRec = component.get("v.Ass_notes");
       
        AssRec[fieldName] = fieldValue;
        
        
        component.set("v.Ass_notes",AssRec);
        
    },
    goBack : function(component,event,helper){
        
        helper.updateFieldHelper(component,event,helper);
    },
    setOutput : function(component, event, helper) {
        var dateControl = document.querySelector('input[type="date"]');
        dateControl.value = '';
    },
    goBackMyAcAss : function(component, event, helper) {
        var myPageRef = component.get("v.pageReference");
        
        var mandateId = myPageRef.state.c__mandateId;
        
        component.set("v.mandateId", mandateId);
        
        debugger;
        console.log('Ass_notes'+component.get("v.Ass_notes"));
        var action = component.get("c.updateNotes");
        action.setParams({
            assignmentNoteRec : component.get("v.Ass_notes")
        });
        action.setCallback(this,function(response){
            var result = response.getReturnValue();
            debugger;
            if(response.getState() === "SUCCESS"){
                
                swal.fire({
                    title: "Success!",
                    text: "The record has been updated successfully.",
                    type: "success",
                    showConfirmButton: false,
                    timer: 3000
                });
                
                //window.history.back();
                
                localStorage.setItem("Action", "activeAssignment");
                window.location ='/lightning/page/home';
            }else{
                
                localStorage.setItem("Action", "activeAssignment");
                window.location ='/lightning/page/home';
            }
            
        });
        $A.enqueueAction(action);
    }
    
})