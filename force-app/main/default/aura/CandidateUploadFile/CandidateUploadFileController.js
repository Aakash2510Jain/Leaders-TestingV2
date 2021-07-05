({
	uploadFile : function(component, event, helper) {

		var fileInput = component.find("file").getElement();
    	var file = fileInput.files[0];

    	var eventSelected = $A.get("e.c:CandidateInputUpdateEvt");

    	var reader = new FileReader();
	   reader.readAsDataURL(file);
	   reader.onload = function () {
	  	 var fileValue = reader.result.replace('data:','');

	  	 //console.log(fileValue);
	     var item = {};
	     item.fileCV = fileValue.split(';')[1].replace('base64,','');
	     
	     item.contentType = fileValue.split(';')[0];
	     //console.log(item.contentType);
		 eventSelected.setParams({ "item": item});
		 eventSelected.fire();
	   };
	   reader.onerror = function (error) {
	    
	   };

	},

	uploadFile2 : function(component, event, helper) {

		var fileInput = component.find("file2").getElement();
    	var file = fileInput.files[0];

    	var eventSelected = $A.get("e.c:CandidateInputUpdateEvt");

    	var reader = new FileReader();
	   reader.readAsDataURL(file);
	   reader.onload = function () {
	  	 var fileValue = reader.result.replace('data:','');

	  	 //console.log(fileValue);
	     var item = {};
	     item.fileCV2 = fileValue.split(';')[1].replace('base64,','');
	     
	     item.contentType2 = fileValue.split(';')[0];
	     //console.log(item.contentType);
		 eventSelected.setParams({ "item": item});
		 eventSelected.fire();
	   };
	   reader.onerror = function (error) {
	    
	   };

	}
})