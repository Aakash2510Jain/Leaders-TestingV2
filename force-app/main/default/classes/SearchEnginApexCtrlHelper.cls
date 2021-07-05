public class SearchEnginApexCtrlHelper {
    
    public static List<String> RECORD_ID_TO_BE_DELETED 	= new List<String>();
    public static String WINNER_RECORD_ID 				= '';
    public static String MASTER_OBJ_NAME 				= '';
    
    public static String CLASS_NAME 					= 'SearchEnginApexCtrlHelper';
    public static String METHOD_NAME 					= '';
    
    public static Boolean NOTES_AND_ATTACHMENT 			= true;
    public static Boolean FILES 						= true;
    public static Boolean ACTIVITIES 					= true;
    public static Boolean RELATED_ASSIGNMENT 			= true;
    public static List<String> CONTENT_DOC_ID_LIST	    = new List<String>();
    
    
    public static void deleteOrMergeDuplicate(){
        try{
            system.debug('deleteOrMergeDuplicate');
            METHOD_NAME 								= 'deleteOrMergeDuplicate';
            
            if(MASTER_OBJ_NAME == 'Account'){
                system.debug('deleteOrMergeDuplicate');
                RELATED_ASSIGNMENT						= false;
            }
            
            if(NOTES_AND_ATTACHMENT){
                system.debug('deleteOrMergeDuplicate');
                deleteOrMergeNotes();
                
            }
            if(FILES){
                system.debug('deleteOrMergeDuplicate');
                Set<String> idSet=new Set<String>(RECORD_ID_TO_BE_DELETED);
                List<ContentDocumentLink> fileList=[select ContentDocumentId,LinkedEntityId,ShareType,Visibility from ContentDocumentLink where LinkedEntityId IN:idSet];
                List<String> contentIdList=new List<String>();
                for(ContentDocumentLink content:fileList){
                    contentIdList.add(content.ContentDocumentId);
                }
                System.debug('contentIdList===>'+contentIdList);
                deleteOrMergeFiles(contentIdList);
                
            }
            /* if(ACTIVITIES){
system.debug('deleteOrMergeDuplicate');
deleteOrMergeActivity();

} */
            if(RELATED_ASSIGNMENT){
                system.debug('deleteOrMergeDuplicate');
                System.debug( 'We are Here');
                deleteOrMergeRelatedAssignment();
            }
            
        }catch(Exception e){
            System.debug( e.getMessage() +'at '+ e.getLineNumber());
            ErrorLog.logError(e,CLASS_NAME,METHOD_NAME);
            throw new AuraHandledException('Error :'+e.getMessage() +'at '+ e.getLineNumber());
        }
    }
    
    public static void deleteOrMergeNotes(){
        deleteNotesAndAttachmentFuture(WINNER_RECORD_ID,RECORD_ID_TO_BE_DELETED);
    }
    
    public static void deleteOrMergeFiles(List<String> contentIdList){
        
        deleteFilesFuture(WINNER_RECORD_ID,RECORD_ID_TO_BE_DELETED,contentIdList);
    }
    
    public static void deleteOrMergeRelatedAssignment(){
        try{
            System.debug( 'winnerRecIds '+ WINNER_RECORD_ID);
            System.debug( 'LooserRecIds '+ RECORD_ID_TO_BE_DELETED);
            List<Application__c> appListToBeInserted			= new List<Application__c>();
            List<Application__c> appListToBeUpdated			= new List<Application__c>();
            // Set<ID> idsOfAppforWINNER = new Set<ID>();
            Set<ID> idsOfAppforDeleted = new Set<ID>();
            Set<String> winnerMandateIds = new Set<String>();
            
            for(Application__c app:[select Id,Contact__c,Name,Mandate__c from Application__c where Contact__c IN:new List<String>{WINNER_RECORD_ID}  ]){
                winnerMandateIds.add(app.Mandate__c);
            }
            system.debug('winnerMandateIds'+winnerMandateIds);
            for(Application__c app:[select Id,Contact__c,Name,Mandate__c from Application__c where Contact__c IN:RECORD_ID_TO_BE_DELETED  ]){
                // idsOfAppforWINNER.add(app.Id);
                System.debug( 'Winner Ass '+ winnerMandateIds);
                System.debug( 'Looser Ass '+ app.Mandate__c);
                if(! winnerMandateIds.contains(app.Mandate__c)){
                    System.debug( 'We are here merging contacts');
                    Application__c appli = new Application__c();
                    appli.Contact__c = WINNER_RECORD_ID;
                    appli.Origin__c = 'Fax';
                    appli.Mandate__c = app.Mandate__c;
                    system.debug('appli Details'+appli);
                    appListToBeInserted.add(appli);
                }
            }
            System.debug( 'appListToBeUpdated '+ appListToBeUpdated);
            if(!appListToBeInserted.isEmpty()){
                system.debug('we are inserting appListToBeInserted');
                insert appListToBeInserted;
            }
            if(!appListToBeUpdated.isEmpty()){
                system.debug('we are updating appListToBeUpdated');
                update appListToBeUpdated;
            }
        }catch(Exception e){
            System.debug( e.getMessage() +'at '+ e.getLineNumber());
            ErrorLog.logError(e,CLASS_NAME,METHOD_NAME);
        }
    }
    
    /* public static void deleteOrMergeActivity(){
try{
METHOD_NAME 									= 'deleteOrMergeActivity';

List<Task> taskListToBeUpdate					=new List<Task>();

for(Task taskRec:[select Id,WhoId,whatid,Status,Subject from Task where (WhatId IN:RECORD_ID_TO_BE_DELETED OR WhoId IN:RECORD_ID_TO_BE_DELETED)]){                   
if(taskRec.WhatId == '001'){
taskListToBeUpdate.add(new Task(WhatId=WINNER_RECORD_ID,WhoId=taskRec.WhoId,Status=taskRec.Status,Subject=taskrec.Subject));  
}else{
taskListToBeUpdate.add(new Task(Whoid=WINNER_RECORD_ID,WhatId=taskRec.WhatId,Status=taskRec.Status,Subject=taskrec.Subject)); 
}                    
System.debug('taskListToBeUpdate='+taskListToBeUpdate);
}
if(!taskListToBeUpdate.isEmpty()){
insert taskListToBeUpdate;
}

}catch(Exception e){
System.debug( e.getMessage() +'at '+ e.getLineNumber());
ErrorLog.logError(e,CLASS_NAME,METHOD_NAME);
throw new AuraHandledException('Error :'+e.getMessage() +'at '+ e.getLineNumber());
}
}*/
    @future
    public static void deleteNotesAndAttachmentFuture(String winnerId,List<String> idToDelete){
        try{
            System.debug('winnerId='+winnerId+'   '+'idToDelete==>'+idToDelete);
            System.debug('RECORD_ID_TO_BE_DELETED==>'+RECORD_ID_TO_BE_DELETED);
            System.debug('WINNER_RECORD_ID===>'+WINNER_RECORD_ID);
            METHOD_NAME 									= 'deleteNotesAndAttachmentFuture';
            
            List<Note> noteListToBeUpdate 					= new List<Note>();
            List<Attachment> attachListToBeUpdate 			= new List<Attachment>();
            
            for(Attachment attRec:[Select Id,ParentId,Body,Name from Attachment where ParentId IN:idToDelete All ROWS]){
                attachListToBeUpdate.add(new Attachment(Id=attRec.Id,parentId=winnerId,Name=attRec.Name,Body=attRec.Body));
            }       
            
            for(Note nRec:[select Id,Body,Title from Note where ParentId IN:idToDelete All ROWS]){
                noteListToBeUpdate.add(new Note(ParentId=winnerId,Body=nRec.Body,Title=nRec.Title));
            }
            System.debug('noteListToBeUpdate==>'+noteListToBeUpdate);
            System.debug('attachListToBeUpdate==>'+attachListToBeUpdate);
            
            if(!noteListToBeUpdate.isEmpty()){
                insert noteListToBeUpdate;            
            }
            if(!attachListToBeUpdate.isEmpty()){
                //don't fire
                insert attachListToBeUpdate;            
            }
            
        }catch(Exception e){
            System.debug( e.getMessage() +'at '+ e.getLineNumber());
            ErrorLog.logError(e,CLASS_NAME,METHOD_NAME);
            
        }
    }
    @future
    public static void deleteFilesFuture(String winnerId,List<String> idToDelete,List<String> contentIdList){
        try{
            System.debug('winnerId='+winnerId);
            System.debug('idToDelete='+idToDelete);
            Set<String> idSet=new Set<String>(idToDelete);
            System.debug('contentIdList---------------------'+contentIdList);
            METHOD_NAME 									= 'deleteFilesFuture';
            
            List<ContentDocumentLink> fileListToBeUpdate 					= new List<ContentDocumentLink>();
            
            for(ContentDocumentLink cdl : [select ContentDocumentId,LinkedEntityId,ShareType,Visibility from ContentDocumentLink where ContentDocumentId IN:contentIdList]){
                System.debug('cdl='+cdl);
                ContentDocumentLink ccddll = new ContentDocumentLink();
                ccddll.ContentDocumentId = cdl.ContentDocumentId;
                ccddll.LinkedEntityId = winnerId;
                ccddll.ShareType = 'V';
                fileListToBeUpdate.add(ccddll);
            }
            System.debug('fileListToBeUpdate='+fileListToBeUpdate);
            
            
            if(!fileListToBeUpdate.isEmpty()){
                System.debug('file insert='+fileListToBeUpdate);
                insert fileListToBeUpdate;
            }
            
        }catch(Exception e){
            System.debug( e.getMessage() +'at '+ e.getLineNumber());
            ErrorLog.logError(e,CLASS_NAME,METHOD_NAME);
            
        }
    }
    
}