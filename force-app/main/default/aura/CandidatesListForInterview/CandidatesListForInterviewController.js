({
    handleSelectAllContact: function(component, event, helper) {
        helper.handleSelectAllContactHelper(component,event);
    },
    
    
    selectAll: function(component, event, helper) {
        helper.selectAllHelper(component,event);
    },
    doInit : function(component, event, helper) {
        debugger;
        var today = new Date();
        component.set('v.today', today.getFullYear() + "-" + (today.getMonth() + 1) + "-" + today.getDate());
         helper.getTotalData(component, event, helper);
    },
    remove : function(component, event, helper) {
        debugger;
        var target = event.target;
        var index = target.getAttribute("data-row-index");
        var id = target.getAttribute("name");
        var abc = component.get("v.recordList");
        abc[index].Schedule_Interview_Time__c = '-- None --';
        abc[index].Interview_Date__c = '';
        component.set("v.recordList",abc);
    },
    setOutput : function(component, event, helper) {
        var cmpMsg = component.find("msg");
        $A.util.removeClass(cmpMsg, 'hide');
        var todayVal = component.find("today").get("v.value");
        var oDateTime = component.find("oDateTime");
        oDateTime.set("v.value", todayVal);
    },
    addRow: function(component, event, helper) {
        debugger;
        component.set("v.addRow",true);
        helper.addRecord(component, event);
        
    },
    getvalue: function(component, event, helper) {
        debugger;
        component.get("v.DateTime");
        
        
    },
})