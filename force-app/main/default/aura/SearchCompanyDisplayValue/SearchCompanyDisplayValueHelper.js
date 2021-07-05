({
    doInitHelper : function(component, event, helper) {
        var obj=component.get('v.record');
        var fieldName=component.get('v.fieldName');
        
        
        console.log("field Name="+fieldName);
        
        if(fieldName == "Partner__r" || fieldName == "Partner_2__r" )
        {
            if(obj[fieldName] != undefined && obj[fieldName] != null)
                var fieldValue=obj[fieldName]["Name"];
            
        }
        else if(fieldName == 'Company_Name_French__c' ){
            if(obj["Company__r"] != undefined && obj["Company__r"] != null){
                var fieldValue=obj["Company__r"]["Name"];  
            }
        }
            else{
                var fieldValue=obj[fieldName];    
            }
        component.set('v.fieldValue',fieldValue);
    },
   
})