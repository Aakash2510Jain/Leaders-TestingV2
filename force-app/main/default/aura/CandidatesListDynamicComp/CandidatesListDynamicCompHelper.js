({
	selectAllHelper: function(component,event){
        debugger;
       var allApp = component.get("v.recordList");
       var valuetoset = component.get("v.isSelectAll");
       for(var i=0;i<allApp.length;i++){
           allApp[i].isSelected=valuetoset;
       }
       component.set("v.recordList",allApp);
       console.log(allApp);

    },
	handleSelectAllContactHelper : function(component,event) {
        // get the selected Account record from the COMPONETN event
       var selectedAccountGetFromEvent = event.getParam("accountByEvent");
       debugger;
       component.set("v.selectedRecord" , selectedAccountGetFromEvent);


    }
})