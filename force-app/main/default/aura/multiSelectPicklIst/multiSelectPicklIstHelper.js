({
    handleSelectionHelper : function(component, event, helper) 
    {
        debugger;
        
        var item = event.currentTarget;
        
        var allselectedItems=[];
        
        allselectedItems = component.get("v.selectedPackageList");
        
        var allItems = document.querySelectorAll('.'+component.get("v.checkBoxClass"));  
        
        //allselectedItems.push(item.dataset.selected);
        
        console.log('allItems::: ',allItems);
        
        console.log('allItems::: index',item.dataset.index);
        var checkboxes = document.querySelectorAll('.'+component.get("v.checkBoxClass"));
        console.log('allItems::: index value',checkboxes[parseInt(item.dataset.index)].checked);
        if (checkboxes[parseInt(item.dataset.index)].checked == true)
        {
            allselectedItems.push(item.dataset.selected);   
        }
        else
        {
            allselectedItems.splice(allselectedItems.indexOf(item.dataset.selected), 1 );
        }
        
        component.set("v.selectedPackageList",allselectedItems);
        
        var cmpTarget = component.find('wfsSurvey.Top_1_to_3_Categories__c');
        $A.util.removeClass(cmpTarget, 'slds-is-open');   
    },
    pkgboxSelected: function(component, event, helper) 
    {
        //debugger;
        console.log("pkgg slds-is-open"); 
        var cmpTarget = component.find('pkgDropdown');
        $A.util.toggleClass(cmpTarget, 'slds-is-open');
        component.set("v.updownicon", component.get("v.updownicon") == "utility:down" ? "utility:up" : "utility:down");
    },
    closeMenu : function(component, event, helper) {
        var comboParentDiv =component.find('pkgDropdown');
        comboParentDiv.classList.remove('slds-is-open');
    },
})