trigger AssociateEmailToMandat on Task (after insert) {

    
    List<Task> contactTasks = new List<Task>();
    Set<Id> contactIds = new Set<Id>();
    Map<String, Set<Id>> mandateIdsMapByContactId = new  Map<String, Set<Id>>();
    
    for(Task task: Trigger.new) {
        if(task.whoId!=null && task.Subject!=null&& task.WhatId==null) {
            if(String.valueOf(task.whoId).startsWith('003')  && task.Subject.startsWith('Email:')) {
               
                contactTasks.add(task.clone(false, false, false, false));
                contactIds.add(task.whoId);
            }
        }
    }
    
    List<Application__c> applications = [SELECT Id, Contact__c, Mandate__c, Mandate__r.Assignment_Status__c FROM Application__c  WHERE Contact__c IN: contactIds];
    
    for(Application__c app:applications) {
        if(app.Mandate__c!=null && app.Mandate__r.Assignment_Status__c!='Completed' && app.Mandate__r.Assignment_Status__c!='Cancelled' && app.Mandate__r.Assignment_Status__c!='Internal' && app.Mandate__r.Assignment_Status__c!='Additional Hire' && app.Mandate__r.Assignment_Status__c!='Filled by client' ) {
            
            if(!mandateIdsMapByContactId.containsKey(app.Contact__c))
                mandateIdsMapByContactId.put(app.Contact__c, new Set<Id>());
            mandateIdsMapByContactId.get(app.Contact__c).add(app.Mandate__c);
        }
    }
    
    List<Task> mandateTasks = new List<Task>();
    
    
    for(Task contactTask: contactTasks) {
        if(mandateIdsMapByContactId.containsKey(contactTask.whoId) ) {
            for(String mandateId: mandateIdsMapByContactId.get(contactTask.whoId)) {
                Task newTask = contactTask.clone(false, false, false, false);
                newTask.WhatId = mandateId;
                mandateTasks.add(newTask);
            }
        }
    }
    
    insert mandateTasks;
    
}