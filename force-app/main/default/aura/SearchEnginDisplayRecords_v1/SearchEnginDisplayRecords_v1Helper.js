({
    doInitHelper : function(component, event, helper) {
        debugger;
        var obj=component.get("v.obj");
        var fieldV ='';
        var fieldName=component.get("v.fieldName");
        if(fieldName=='Partner__r.Name'){
            
            if(obj.Partner__r != undefined)
            fieldV=obj.Partner__r['Name'];
        }else if(fieldName=='Partner_2__r.Name'){
            
            if(obj.Partner_2__r != undefined)
            fieldV=obj.Partner_2__r['Name'];
            
        }
        else if(fieldName=='Company__r.Name'){
            
            if(obj.Company__r != undefined)
            fieldV=obj.Company__r['Name'];
            
        }
        else{
            fieldV=obj[fieldName];
        }
         
        //alert(fieldName);
        //alert(fieldV);
        
        component.set("v.fieldValue",fieldV);
        
    }
})