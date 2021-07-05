({
    doInit : function(component, event, helper) { 
        helper.doInitHelper(component, helper);
        console.log('object name = '+component.get("v.objName"));
    },
    onNext : function(component, event, helper) {        
        var pageNumber = component.get("v.currentPageNumber");
        component.set("v.currentPageNumber", pageNumber+1);
        helper.buildData(component, helper);
    },
    addtoAss : function(component, event, helper)
    {        
        debugger;
        helper.addtoAssHelper(component,event,helper);
    },
    onPrev : function(component, event, helper) {        
        var pageNumber = component.get("v.currentPageNumber");
        component.set("v.currentPageNumber", pageNumber-1);
        helper.buildData(component, helper);
    },    
    processMe : function(component, event, helper) {
        component.set("v.currentPageNumber", parseInt(event.target.name));
        helper.buildData(component, helper);
    },
    
    onFirst : function(component, event, helper) {        
        component.set("v.currentPageNumber", 1);
        helper.buildData(component, helper);
    },
    
    onLast : function(component, event, helper) {        
        component.set("v.currentPageNumber", component.get("v.totalPages"));
        helper.buildData(component, helper);
    },
    sortByField:function(component, event, helper) {
        helper.sortByFieldHelper(component, event, helper);
    },
    
  /*  recordOperation:function(component, event, helper){
        debugger;
       // helper.recordOperationHelper(component, event, helper);
       	component.set("v.showConfirmDialog",true);
        
    },*/
    onCheck:function(component, event, helper){
        debugger;
        helper.onCheckHelper(component, event, helper);
        
    },
    deleteAll:function(component, event, helper){
        debugger;
        helper.deleteAllHelper(component, event, helper);
      
    },
    onCheckAll:function(component, event, helper){
        debugger;
        var data=component.get('v.data');
        component.set('v.selectedRecord',data);
        helper.onCheckAllHelper(component, event, helper);
    },
    createNewRecord:function(component,event,helper){
		debugger;        
        helper.createNewRecordHelper(component,event,helper);
    },
    navigate:function(component,event,helper){
        debugger;
          var selectedRecord=component.get('v.selectedRecord');
        if(selectedRecord.length==10 || selectedRecord.length>3)
        {
           
            swal.fire({
                        title: "Error!",
                        text: "You can't select more than 3 record.",
                        type: "Error",
                        timer: 3000
                    });
            

        }
        if(selectedRecord.length>1 && selectedRecord.length<4 ){
		        helper.navigateHelper(component,event,helper);
        }if(selectedRecord.length==1){
       
            swal.fire({
                        title: "Error!",
                        text: "Please select aleast more than 1 record.",
                        type: "Error",
                        timer: 3000
                    });
        }    
		
    },
    viewAll:function(component,event,helper){ 
        debugger;
		component.set("v.sobjectVariable.saveToList",false);
        if(component.get("v.sobjectVariable.viewAll")==false){
            component.set("v.sobjectVariable.viewAll",true);
        }else{
			component.set("v.sobjectVariable.viewAll",false);
        }
        
    },
    ShowCompany:function(component,event,helper)
    {
        debugger;
       component.set("v.ShowCompany",true);
    },
    ShowCandidate:function(component,event,helper)
    {
       debugger;
       component.set("v.ShowCandidate",true);
    },
    saveToList:function(component,event,helper){
        debugger;
		component.set("v.sobjectVariable.viewAll",false);

        if(component.get("v.sobjectVariable.saveToList")==false){
                component.set("v.sobjectVariable.saveToList",true);
        }else{
		component.set("v.sobjectVariable.saveToList",false);
        }
    },
    handleConfirmDialogNo : function(component, event, helper) {
        component.set('v.showConfirmDialog', false);
    },
    handleConfirmDialogYes : function(component, event, helper) {
       helper.recordOperationHelper(component, event, helper);
    	component.set('v.showConfirmDialog', false);
    },
    onSelectDelete:function(component,event,helper){
        var record=event.getSource().get('v.name');
        var value=event.getParam("value");
        component.set("v.recordOperationValue",value);
        component.set("v.eachRecord",record)
       	component.set("v.showConfirmDialog",true);

    },

    
    
})