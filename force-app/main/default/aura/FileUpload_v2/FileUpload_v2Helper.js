({
    MAX_FILE_SIZE: 4500000, //Max file size 4.5 MB 
    CHUNK_SIZE: 750000,      //Chunk Max size 750Kb 
    
    uploadHelper: function(component, event) {
        // start/show the loading spinner   
        component.set("v.showLoadingSpinner", true);
        // get the selected files using aura:id [return array of files]
        var fileInput = component.find("fileId").get("v.files");
        // get the first file using array index[0]  
        var file = fileInput[0];
        var self = this;
        // check the selected file size, if select file size greter then MAX_FILE_SIZE,
        // then show a alert msg to user,hide the loading spinner and return from function  
        if (file.size > self.MAX_FILE_SIZE) {
            component.set("v.showLoadingSpinner", false);
            component.set("v.fileName", 'Alert : File size cannot exceed ' + self.MAX_FILE_SIZE + ' bytes.\n' + ' Selected file size: ' + file.size);
            return;
        }
 
        // create a FileReader object 
        var objFileReader = new FileReader();
        // set onload function of FileReader object   
        objFileReader.onload = $A.getCallback(function() {
            var fileContents = objFileReader.result;
            var base64 = 'base64,';
            var dataStart = fileContents.indexOf(base64) + base64.length;
 
            fileContents = fileContents.substring(dataStart);
            // call the uploadProcess method 
            self.uploadProcess(component, file, fileContents);
        });
 
        objFileReader.readAsDataURL(file);
    },
 
    uploadProcess: function(component, file, fileContents) {
        // set a default size or startpostiton as 0 
        var startPosition = 0;
        // calculate the end size or endPostion using Math.min() function which is return the min. value   
        var endPosition = Math.min(fileContents.length, startPosition + this.CHUNK_SIZE);
 
        // start with the initial chunk, and set the attachId(last parameter)is null in begin
        this.uploadInChunk(component, file, fileContents, startPosition, endPosition, '');
    },
 
 
    uploadInChunk: function(component, file, fileContents, startPosition, endPosition, attachId) {
        // call the apex method 'saveChunk'
        var getchunk = fileContents.substring(startPosition, endPosition);
        var action = component.get("c.saveChunk");
        //var otherstype = component.get("");
        //var selectedtype = component.find("selectUploadType").get("v.value");
        var fileName = component.get("v.docType")=='Others'?component.get("v.otherFileName"):component.get("v.docType");
        action.setParams({
            parentId: component.get("v.recordId"),
            fileName:fileName,
            //fileName: component.get("v.fileName"),
           // fileName: file.name,
            base64Data: encodeURIComponent(getchunk),
            contentType: file.type,
            fileId: attachId
        });
 
        // set call back 
        action.setCallback(this, function(response) {
            // store the response / Attachment Id   
            attachId = response.getReturnValue();
            var state = response.getState();
            if (state === "SUCCESS") {
                // update the start position with end postion
                startPosition = endPosition;
                endPosition = Math.min(fileContents.length, startPosition + this.CHUNK_SIZE);
                // check if the start postion is still less then end postion 
                // then call again 'uploadInChunk' method , 
                // else, diaply alert msg and hide the loading spinner
                if (startPosition < endPosition) {
                    this.uploadInChunk(component, file, fileContents, startPosition, endPosition, attachId);
                } else {
                    //alert('your File is uploaded successfully');
                  
                    component.set("v.showLoadingSpinner", false);
              
                    swal.fire({
                        title: "Success!",
                        text: "File Uploaded successfully.",
                        type: "success",
                        timer: 3000
                    });
               		component.set("v.showFileUpload",false);
                }
                // handel the response errors        
            } else if (state === "INCOMPLETE") {
                alert("From server: " + response.getReturnValue());
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        // enqueue the action
        $A.enqueueAction(action);
    },
    
    
    navigateToParentRecord : function(component,event,helper)
    {
                        var navEvt = $A.get("e.force:navigateToSObject");
                    navEvt.setParams({
                      "recordId": component.get("v.recordId")
                    //  "slideDevName": "related"
                    });
                    navEvt.fire();       
                           
    },
    
    showToast : function(component,event,helper)
    {
        swal.fire({
                        title: "Success!",
                        text: "File "+component.get("v.fileName")+" Uploaded successfully..",
                        type: "error",
                        timer: 3000
                    });
        
       
    },
    updateDocumentTypeOnAssignmentHelper:function(component,event,helper){
        debugger;
        //var selectedtype = component.find("selectUploadType").get("v.value");
        //alert(selectedtype);
        var action = component.get("c.updateDocType");
        action.setParams({
            "mandateId" : component.get("v.recordId"),
            "docType":component.get("v.docType")
        });
        
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state=='SUCCESS'){
                var result = response.getReturnValue();
                console.log('Result Returned: ' +result);  
                if(result =='Record Updated Sucessfully'){
                    /*var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "message": "File Uploaded successfully."
                    });
                    toastEvent.fire();*/
                    //component.set("v.showFileUpload",false);
                }else{
                    alert(result);
                    //var cmpTarget = component.find('Modalbox');
                    //var cmpBack = component.find('Modalbackdrop');
                    //$A.util.removeClass(cmpBack,'slds-backdrop--open');
                    //$A.util.removeClass(cmpTarget, 'slds-fade-in-open'); 
                    //component.set("v.showFileUpload",false);
                }
                
            }
        });
        $A.enqueueAction(action);  
    }
})