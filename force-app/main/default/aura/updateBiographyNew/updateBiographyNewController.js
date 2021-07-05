({
    closeModel: function(component,event,helper){
        debugger;
        if(component.get("v.isrelatedListButton")){
            component.destroy();
					window.history.back();
        }else{
            component.set("v.displayUpdateBioNew",false);
        }
        
       
    },
    onPageReferenceChanged: function(cmp, event, helper) {
        var myPageRef = cmp.get("v.pageReference");
        var contactId = myPageRef.state.c__contactId;
        alert('Page ref Changed');
        alert(contactId);
        alert(component.get("v.recordId"));
        cmp.set("v.recordId", contactId);
    },
    getRecords: function(component, event, helper) {
        //alert('calling get records');
        //alert(component.get("v.recordId"));
		setTimeout(function(){ 
            //helper.getRecordsHelper(component, event, helper);
            //helper.getConRecordsHelper(component, event, helper);
        },2000);
	},
   
    getRecordTypes : function(component, event, helper) {
        //alert('calling get records types');
        //alert(component.get("v.recordId"));
		helper.getRecordTypesHelper(component, event, helper);
	},
    save: function(component, event, helper) {
            helper.saveBiographyList(component, event,helper);
        //debugger;
            //helper.genrateSelfAss(component, event,helper);
        
    },
    handledelete: function(component, event, helper) {
            helper.handledeleteHelper(component, event,helper);
        
    }
})