({
	searchHelper : function(component,event,getInputkeyWord) {
	  // call the apex class method
    debugger; 
     var action = component.get("c.fetchAccount");
      // set param to method
        action.setParams({
            'searchKeyWord': getInputkeyWord,
            'ObjectApi':component.get("v.ObjectApi")
          });
      // set a callBack
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
              // if storeResponse size is equal 0 ,display No Result Found... message on screen.
                if (storeResponse.length == 0) {
                    component.set("v.Message", 'No Result Found...');
                } else {
                    component.set("v.Message", 'Search Result...');
                }

                // set searchResult list with return value from server.
                component.set("v.listOfSearchRecords", storeResponse);
            }

        });
      // enqueue the Action
        $A.enqueueAction(action);

	},
	handleComponentEventHelper : function(component,event,getInputkeyWord) {
	    // get the selected Account record from the COMPONETN event
       var selectedAccountGetFromEvent = event.getParam("accountByEvent");
       debugger;
       component.set("v.selectedRecord" , selectedAccountGetFromEvent);
       this.recordSelectedCssHelper(component,event);
        
    },
    clearSelection : function(component, event){
      component.set("v.selectedRecord",{});
      component.set("v.SearchKeyWord","");


      var forclose = component.find("lookup-pill");
      $A.util.addClass(forclose, 'slds-hide');
      $A.util.removeClass(forclose, 'slds-show');

      var lookUpTarget = component.find("lookupField");
      $A.util.addClass(lookUpTarget, 'slds-show');
      $A.util.removeClass(lookUpTarget, 'slds-hide');

      var lookupPill = component.find("delBtnIcon");
      $A.util.addClass(lookupPill, 'slds-hide');
      $A.util.removeClass(lookupPill, 'slds-show');
      
    },

    recordSelectedCssHelper : function(component,event){
      var forclose = component.find("lookup-pill");
      $A.util.addClass(forclose, 'slds-show');
      $A.util.removeClass(forclose, 'slds-hide');

      var forclose = component.find("searchRes");
      $A.util.addClass(forclose, 'slds-is-close');
      $A.util.removeClass(forclose, 'slds-is-open');

      var lookUpTarget = component.find("lookupField");
      $A.util.addClass(lookUpTarget, 'slds-hide');
      $A.util.removeClass(lookUpTarget, 'slds-show');
    }
})