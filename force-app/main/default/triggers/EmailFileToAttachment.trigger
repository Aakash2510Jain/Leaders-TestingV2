trigger EmailFileToAttachment on FeedItem (after insert) {
     
    set<Id> feedToDelete = new set<Id>();
    Map<Id, Id> attachMap = new Map<Id, Id>();
    set<Id> relatedRecordIds = new set<Id>(); 
    
    for(FeedItem fi : trigger.new){    	
    	
                
        if(fi.Type == 'ContentPost' &&
           fi.RelatedRecordId != null &&
           fi.RelatedRecordId.getSObjectType() == ContentVersion.SObjectType){
            
            if(fi.ParentId.getSObjectType() == Task.SObjectType){
                attachMap.put(fi.RelatedRecordId, fi.ParentId);
                relatedRecordIds.add(fi.RelatedRecordId);               
            }else if(fi.ParentId.getSObjectType() == Account.SObjectType){
                feedToDelete.add(fi.Id);
            }else if(fi.ParentId.getSObjectType() == Contact.SObjectType){
                feedToDelete.add(fi.Id);
            }        
        }
         
    } 
    
    system.debug('FeedItems : '+attachMap);
    
    if(!attachMap.isEmpty()){
        
        Set<Id> taskIds = new Set<Id>();
        taskIds.addAll(attachMap.values());
        
        Map<id, Task> taskMap = new Map<id, Task>();
        
        for (Task tsk : [Select subject, whoId, who.FirstName, who.LastName
                           from Task
                          where Id in :taskIds
                            and subject like '%cv%']){
              
              
              if(tsk.whoId.getSObjectType() == Contact.SObjectType && 
                 !taskMap.containsKey(tsk.whoId)){
                 	
                 taskMap.put(tsk.Id, tsk);
              }
            
        }   
        
        system.debug('taskMap : '+taskMap);
        
        List<Attachment> toInsert = new List<Attachment>();
        
        for(ContentVersion cv : [Select Id, Title, VersionData, FileExtension
                                   from ContentVersion
                                  where Id in :relatedRecordIds]){                                  	
                
                                    
                Id parentId = attachMap.get(cv.Id);
                
                if(taskMap.containsKey(parentId)){
                    
                    Task parentTask = taskMap.get(parentId);
                    
                    Attachment attach = new Attachment();
                
                    String name = 'CV_'+parentTask.who.FirstName+' '+parentTask.who.LastName+'_'+String.ValueOf(Date.Today());
                    if(parentTask.Subject.tolowercase().contains('cv - en')){
                        name = name +'_EN';
                    }else{
                        name = name +'_FR';
                    }               
                    attach.Name =  name+'.'+cv.FileExtension;//cv.Title;
                    attach.ContentType = 'application/pdf';
                    attach.Body = cv.VersionData;
                    attach.ParentId = parentTask.whoId;
                    toInsert.add(attach);
                }
           
        }
        
        if(toInsert.size()>0){          
            insert toInsert; 
                        
            List<FeedItem> fToDelete = new List<FeedItem>();
        
            for(FeedItem fi : [Select id from FeedItem where id in :feedToDelete]){
                fToDelete.add(fi);
            }
            
            delete fToDelete;
            
        }
        
    }

}