({
    doInit:function(component,event,helper){
        debugger;
        
        helper.doInitHelper(component,event,helper);
    },
   openModel: function(component, event, helper) {
      // for Display Model,set the "isOpen" attribute to "true"
      component.set("v.isOpen", true);
   },
 
   closeModel: function(component, event, helper) {
       debugger;
      // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
      component.set("v.isOpen", false);
   /*   var navigateEvent = $A.get("e.force:navigateToComponent");
        navigateEvent.setParams({
            componentDef: "c:TheBestSidebar"
            //You can pass attribute value from Component1 to Component2
                  
        });
        navigateEvent.fire(); */
   },
 
   likenClose: function(component, event, helper) {
      // Display alert message on the click on the "Like and Close" button from Model Footer 
      // and set set the "isOpen" attribute to "False for close the model Box.
      component.set("v.isOpen", false);
   },
    onCheckForPrimaryAccount:function(component,event,helper){
        helper.onCheckForPrimaryAccountHelper(component,event,helper);
    },
    onCheckForFields:function(component,event,helper){
                var existingRec = component.get("v.CheckedRecord");
        if(existingRec!=null){
                    helper.onCheckForFieldsHelper(component,event,helper);
        }else{
            var toastEvent = $A.get("e.force:showToast");
             toastEvent.setParams({
                        "title": "Error!",
                        "message": "Please select Primary Record", 
                        "type":"Error"
            });
            toastEvent.fire();
        }
    },
    merge:function(component,event,helper){
        debugger;
        
        component.set("v.spinnerModal",true);
        helper.mergeHelper(component,event,helper);
	},
    onCheckForFieldEventHandler:function(component,event,helper){
        debugger;
        helper.onCheckForFieldEventHandlerHelper(component,event,helper);
    },
    onCheckAssigment:function(component,event,helper){
       var checkAssigment=event.getSource().get('v.value');
       // component.set("v.RelatedAssigment",checkAssigment);
    },
    onCheckActivity:function(component,event,helper){
       var checkActivity=event.getSource().get('v.value');
        component.set("v.Activity",checkActivity);
    },
    onCheckNotesAttachment:function(component,event,helper){
        var checkNotesAttachment=event.getSource().get('v.value');
        component.set("v.NotesAttachment",checkNotesAttachment);
    },
    onCheckFile:function(component,event,helper){
         var checkFile=event.getSource().get('v.value');
		component.set("v.File",checkFile);
   },
   mergeDuplicateSplice:function(component,event,helper){
       helper.mergeDuplicateSpliceHelper(component,event,helper);
    }

})