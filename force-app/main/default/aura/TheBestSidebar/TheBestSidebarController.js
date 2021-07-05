({
    doInit : function(component, event, helper) 
    {
     helper.getprofName(component, event, helper);
     helper.doInitHelper(component, event, helper);
     helper.getassname(component, event, helper);   
        
    },
    
    showRelatedObject : function(component, event, helper) 
    {
        debugger;
        var objName = event.currentTarget.name;
        
        var allSearchResult = component.get("v.searchresultList");
        
        for(var i=0;i<allSearchResult.length;i++)
        {
            if(allSearchResult[i].ObjName == objName)
            {
                component.set("v.searchresult",allSearchResult[i]);
            }
        }
    },
    doSearch : function(component, event, helper)
    {
        //alert('Hello controller');   
        component.set("v.isOnload",false);
        helper.doSearchHelper(component, event, helper);
        
    },
    Backtoassgn : function(component, event, helper)
    {
        debugger;
        var sPageURL = decodeURIComponent(window.location.search.substring(1));
        var cururl = window.location.href.substring(1);
        var splitUrl = cururl.split('/');
        
        var updated_url= 'https://'+document.location.hostname + '/' +'lightning/cmp/c__AssignmentCandidatesPageComp'+'?' +sPageURL ;
        
        
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({'url':updated_url
                           });
        urlEvent.fire();
    },
    getRecentSearch:function(component, event, helper){
        helper.recentSearchHelper(component, event, helper);
    },
    handleDeleteAllEvent:function(component, event, helper){
        debugger;
        var objLength=event.getParam("objCount");
        // objLength=objLength-1;
        var objName=event.getParam("objName");
        var recListOfList = component.get("v.sobject");
        for(var i=0;i<recListOfList.length;i++){
            if(recListOfList[i].objName == objName){
                recListOfList[i].recordCount = recListOfList[i].recordCount - objLength;
              }                
            
        }
        component.set("v.sobject",recListOfList);
        
    },
    showrelatedSearch:function(component, event, helper){
        debugger;
        //event.currentTarget.name
        if(component.get("v.urlvalue")==true || component.get("v.urlvalue")==''){
            component.set("v.SearchValue",event.currentTarget.name);
            helper.doSearchHelper(component, event, helper);
        }
        
    },
      addtoAss : function(component, event, helper)
    {        
        debugger;
        helper.addtoAssHelper(component,event,helper);
    },
    deleteHistoryItem:function(component, event, helper){
        debugger;
        component.set("v.isSerachRequired",false);
        helper.deleteHistoryItemHelper(component, event, helper);
        
    },
    keyCheck:function(component,event,helper){
        debugger;
        //component.set("v.checkSpinner",true);
        helper.keyCheckHelper(component,event,helper)
    },
    isAssigment:function(component,event,helper){
        debugger;
        
    },
    createNewRecord:function(component,event,helper){
        debugger;        
        helper.createNewRecordHelper(component,event,helper);
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
    
    
})