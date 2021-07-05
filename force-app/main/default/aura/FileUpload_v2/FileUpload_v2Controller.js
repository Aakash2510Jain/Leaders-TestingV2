({
    
    doSave: function(component, event, helper) {
        debugger;
         
        if( component.get("v.docType") == "")
        {
            alert('Please Select File Type');
            return;
        }
        else if( component.get("v.docType") == "Others")
        {
           //component.set("v.othersvaluetobeshown",True);
        }
        //component.find("text-input-id-1").getValue
        
        debugger;
        
        if(component.get("v.otherFileName") == "" && component.get("v.docType") =='Others')
        {
         alert('Please Enter the File Name'); 
            return;
        }
            
        
        if(component.find("fileId").get("v.files") == null)
            alert('Please Select a File');
        
        
        else if (component.find("fileId").get("v.files").length > 0) 
        {
            if(component.get("v.operationType")=='mandate')
            helper.updateDocumentTypeOnAssignmentHelper(component, event, helper);
            helper.uploadHelper(component, event);
        }
            else 
        {
            alert('Please Select a Valid File');
        }
        
         //helper.navigateToParentRecord(component,event,helper);
         //helper.showToast(component,event,helper);
     },
    handleFilesChange: function(component, event, helper) {
        debugger;
        var customFileName = 'No File Selected..';
        var customFileType = '';
        var fileExtension ='';
        if (event.getSource().get("v.files").length > 0) {
            customFileName = event.getSource().get("v.files")[0]['name'];
            customFileType = event.getSource().get("v.files")[0]['type'];
            fileExtension = customFileName.split('.')[1];
        }
        if(component.get("v.docType")  != 'Others' ){
            if(component.get("v.docType")  != 'Corporate Presentation'){
                
                if(customFileType != 'application/pdf'){
                    component.set("v.isPDF",false);
                    alert('Please upload PDF only.');
                    return;
                }    
            }   
        }        
        component.set("v.fileName", customFileName);
    },
    closeModel: function(component,event,helper){
        var cmpTarget = component.find('Modalbox');
        var cmpBack = component.find('Modalbackdrop');
        $A.util.removeClass(cmpBack,'slds-backdrop--open');
        $A.util.removeClass(cmpTarget, 'slds-fade-in-open'); 
        component.set("v.showFileUpload",false);
    },
})