({
	doInit : function(component, event, helper) 
    {
        debugger;
		helper.doInitHelper(component, event, helper);
	},    
    onNext : function(component, event, helper) 
    {        
        var pageNumber = component.get("v.currentPageNumber");
        component.set("v.currentPageNumber", pageNumber+1);
        helper.buildData(component, helper);
    },
    onselect : function(component, event, helper)
    {    
        
        var pageNumber = component.get("v.currentPageNumber");
        component.set("v.currentPageNumber", pageNumber+1);
        helper.buildData(component, helper);
    },
    showAssDetails : function(component, event, helper) {    
        debugger;
        var ConId = event.getSource().get("v.title");
      //  var ConId = document.getElementById("demo").getAttribute("data-value"); 
        var action = component.get("c.getAssDetailsFromCon");
        
        action.setParams({
            "ConId": ConId,
        });
        
        action.setCallback(this, $A.getCallback(function(response) {
            var state = response.getState();
            var storeResponse = response.getReturnValue();
            
            if (state == "SUCCESS") {
                {
                    debugger;
                    if(storeResponse.length > 0){
                        component.set("v.AssAvailable",true);               
                    }
                    component.set("v.AssDetails",storeResponse);
         
                    component.set("v.ShowPeopleinfoPage",true);
                }
            }else{}
        }));
        $A.enqueueAction(action);
    
    },
    handleClickForPeople: function(component,event,helper){
        debugger;
        var selectedItem = event.currentTarget
        var recId = selectedItem.dataset.record;
        console.log(recId);
        
       // location.href = 'https://leadersinternational--test.lightning.force.com/lightning/r/Contact/'+recId+'/view';
        window.open('https://leadersinternational.lightning.force.com/lightning/r/Contact/'+recId+'/view');
       /* var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": 'https://leadersinternational--test.lightning.force.com/lightning/r/Contact/'+recId+'/view'
        });
        urlEvent.fire(); */
    } ,
    onPrev : function(component, event, helper) 
    {        
        var pageNumber = component.get("v.currentPageNumber");
        component.set("v.currentPageNumber", pageNumber-1);
        helper.buildData(component, helper);
    },    
    openCV : function(component, event, helper) 
    {  
        debugger;
        var attId = event.getSource().get("v.alternativeText");
       
        component.set("v.CVID",attId);
        component.set("v.viewCVfromPeople",true);               
       
        
    },
    openOP : function(component, event, helper) 
    {  
        debugger;
        var attId = event.getSource().get("v.alternativeText");
       
        component.set("v.OPID",attId);
        component.set("v.viewOPfromPeople",true);               
       
        
    },
    processMe : function(component, event, helper) 
    {
        component.set("v.currentPageNumber", parseInt(event.target.name));
        helper.buildData(component, helper);
    },
    
    onFirst : function(component, event, helper) 
    {        
        component.set("v.currentPageNumber", 1);
        helper.buildData(component, helper);
    },
   
    onLast : function(component, event, helper) 
    {        
        component.set("v.currentPageNumber", component.get("v.totalPages"));
        helper.buildData(component, helper);
    },
    sortByField:function(component, event, helper) 
    {
        helper.sortByFieldHelper(component, event, helper);
    },
    onCheck:function(component, event, helper)
    {
        debugger;
        helper.onCheckHelper(component, event, helper);
    },
    OnDeleteSplice:function(component, event, helper)
    {
    }
  

})