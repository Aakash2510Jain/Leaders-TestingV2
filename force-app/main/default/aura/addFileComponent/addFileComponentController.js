({
   /* doInit: function(component,event,helper){
        helper.getRecordDetails(component,event,helper);
        
        var test = component.get("v.contact.Id")
        console.log(test)
        
        var language = component.find("selectLanguage").get("v.value");
        console.log(language);
        component.set("v.selectedLanguage",language);
        
          var type= component.find("selectType").get("v.value");
        console.log(type);
        component.set("v.selectedType",type);
        
    }, */
    
    
    
    handleUploadFinished: function (component,event,helper) {
        
        var language = component.find("selectLanguage").get("v.value");
        console.log(language);
        component.set("v.selectedLanguage",language);
        
        if(language=="English"){
            component.set("v.setLanguage","EN");
        }
        else{
            component.set("v.setLanguage","FR")
        }
        
          var type= component.find("selectType").get("v.value");
        console.log(type);
        component.set("v.selectedType",type);
        
        
      /*   helper.getRecordDetails(component,event,helper);
        
         var firstName = component.get("v.contact.FirstName");
         console.log(firstName);
        
         var lastName = component.get("v.contact.LastName");
         console.log(lastName);*/
        
        
        
        
        // This will contain the List of File uploaded data and status
        var uploadedFiles = event.getParam("files");
        var documentId = uploadedFiles[0].documentId;
        var fileName = uploadedFiles[0].name;
        
        if(type == "CV" || type=="Psy Test")
        {
          var fName = component.get("v.selectedType")+" "+component.get("v.FirstName")+" "+component.get("v.LastName")+" "+new Date().toJSON().slice(0,10).replace(/-/g,'/')+" "+component.get("v.setLanguage");
        console.log(fName);  
        }else{
            var fName = fileName
        }
        
                
        helper.updateNameOfDocument(component,event,documentId,fName);
      
        helper.navigateToParentRecord(component,event,helper);
        
        var toastEvent = $A.get("e.force:showToast");  
             toastEvent.setParams({  
           "title": "Success!",  
           "message": "File "+fileName+" Uploaded successfully."  
        });
        toastEvent.fire();
        
       // alert("Files uploaded : " + uploadedFiles.length);
        
        /* Open File after upload  
     	$A.get('e.lightning:openFiles').fire({  
       	recordIds: [documentId]  
     	});*/  
    },
    
    handleSelectValue : function(component,event,helper){
        
      /*   helper.getRecordDetails(component,event,helper);
        
         var firstName = component.get("v.contact.FirstName");
         console.log(firstName);
        
         var lastName = component.get("v.contact.LastName");
         console.log(lastName); */
        
        
        
        var type= component.find("selectType").get("v.value");
        console.log(type);
        component.set("v.selectedType",type);
        
        
    },
    handleSelectLanguage : function(component,event,helper){
        var language = component.find("selectLanguage").get("v.value");
        console.log(language);
        component.set("v.selectedLanguage",language);
        
    }
})