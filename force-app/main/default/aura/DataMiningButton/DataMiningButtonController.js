({
	 gotoSearchPeople : function(component,event,helper){
         debugger;
        var urlEvent=$A.get("e.force:navigateToURL");
         //"url":"/c/SearchPeopleApp.app"
        urlEvent.setParams({
            "url":"/lightning/cmp/c__SearchPeople"
        });
        urlEvent.fire();
    },
    gotoSearchCompany : function(component,event,helper){
        debugger;
        var urlEvent=$A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url":"/lightning/cmp/c__SearchCompany"
        });
        urlEvent.fire();
    },
    
    gotoSearchAssignment : function(component,event,helper){
        debugger;
        var urlEvent=$A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url":"/lightning/n/Search_Assignment"
        });
        urlEvent.fire();
    }
    
})