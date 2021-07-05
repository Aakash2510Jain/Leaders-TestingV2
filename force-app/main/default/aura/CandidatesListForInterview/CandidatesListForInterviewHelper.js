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
    getTotalData: function(component,event,helper){
        debugger;
       var potCandidates = component.get("v.potentialCandidatesList");
       var nonPotCandidates = component.get("v.nonPotentialCandidatesList");
       var totalCandidates = potCandidates.concat(nonPotCandidates);
       component.set("v.totalCandidates",totalCandidates);
       
       var SearchNames = [] ;
        var CanDate = [];
       for(var i=0;i<totalCandidates.length;i++){
           if(totalCandidates[i].candidate != null && totalCandidates[i].candidate != undefined ){
           SearchNames.push(totalCandidates[i].candidate.Contact__r.Name);    
           CanDate.push(totalCandidates[i].candidate);    
           }
           
       }
        
       console.log(SearchNames); 
      component.set("v.listOfSearchRecords",CanDate);
    },
	handleSelectAllContactHelper : function(component,event) {
        // get the selected Account record from the COMPONETN event
       var selectedAccountGetFromEvent = event.getParam("accountByEvent");
       debugger;
       component.set("v.selectedRecord" , selectedAccountGetFromEvent);
    },
     addRecord: function(component, event) {
        debugger;
         
      	var recordList = component.get("v.recordList");    
            
            recordList.push({"record":{
            'sobjectType': 'Application__c',
            Id: "",
            Interview_Date__c: "",
            Name: "",
            "lookupObj":{}
                            
            }});            
            component.set("v.recordList", recordList);
    }
})