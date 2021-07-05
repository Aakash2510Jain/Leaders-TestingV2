({
	myAction : function(component, event, helper) {
		
	},
    
    
    doSave: function(component, event, helper) {
        //Select Type
        debugger;
        var type= component.find("selectType").get("v.value");
        console.log(type);
        component.set("v.selectedType",type);
        //Select Language
        var language = component.find("selectLanguage").get("v.value");
        console.log(language);
        component.set("v.selectedLanguage",language);
        
        
         if(language=="English"){
            component.set("v.setLanguage","EN");
        }
        else{
            component.set("v.setLanguage","FR")
        }
        
        if(type == "CV" || type=="Psy Test")
        {
          var fName = component.get("v.selectedType")+" "+component.get("v.FirstName")+" "+component.get("v.LastName")+" "+new Date().toJSON().slice(0,10).replace(/-/g,'/')+" "+component.get("v.setLanguage");
        console.log(fName);  
        }else{
            var fName = event.getSource().get("v.files")[0]['name'];
        }
        
        component.set("v.fileName",fName);
        
        
        if (component.find("fileId").get("v.files").length > 0) {
            helper.uploadHelper(component, event,helper);
        } else {
            alert('Please Select a Valid File');
        }
        
         //helper.navigateToParentRecord(component,event,helper);
         helper.showToast(component,event,helper);
        
    },
 
    handleFilesChange: function(component, event, helper) {
        
        
        // File Name Customization starts
        
        var type= component.find("selectType").get("v.value");
        console.log(type);
        component.set("v.selectedType",type);
        //Select Language
        var language = component.find("selectLanguage").get("v.value");
        console.log(language);
        component.set("v.selectedLanguage",language);
        
        
         if(language=="English"){
            component.set("v.setLanguage","EN");
        }
        else{
            component.set("v.setLanguage","FR")
        }
        
        if(type == "CV" || type=="Psy Test")
        {
          var fName = component.get("v.selectedType")+" "+component.get("v.FirstName")+" "+component.get("v.LastName")+" "+new Date().toJSON().slice(0,10).replace(/-/g,'/')+" "+component.get("v.setLanguage");
        console.log(fName);  
        }else{
            var fName = event.getSource().get("v.files")[0]['name'];
        }
        
        var customFileName = 'No File Selected..'
        if (event.getSource().get("v.files").length > 0) {
            customFileName = fName
        }
        component.set("v.fileName", customFileName);
        
        // File Name Customization ends
        
        
      /*  var fileName = 'No File Selected..';
        if (event.getSource().get("v.files").length > 0) {
            fileName = event.getSource().get("v.files")[0]['name'];
        }
        component.set("v.fileName", fileName);*/
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