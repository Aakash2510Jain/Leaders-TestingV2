global class DeleteContactAttachmentBatch implements Database.Batchable<sObject> , Schedulable , Database.Stateful{
    
    global List<Attachment> toDelete = new List<Attachment>();
    global id contactId;
    global set<Id> contactIds = new set<Id>();
    global list<sObject> conlist = new List<sObject>();
    global Id lastId = null;
    global boolean flagIR = false;
    global boolean flagCBFR = false;
    global boolean flagCBEN = false;
    global boolean flagOPFR = false;
    global boolean flagOPEN = false;
    
    
    global DeleteContactAttachmentBatch()
    {
      toDelete = new List<Attachment>();  
    }
    
    
    
     global DeleteContactAttachmentBatch(Id conId)
    {
        contactId = conId;
        lastId = null;
    }
    
    global DeleteContactAttachmentBatch(set<Id> conIds)
    {
            contactIds = conIds;
            toDelete = new List<Attachment>();
            flagIR = false;
            flagCBFR = false;
            flagCBEN = false;
            flagOPFR = false;
            flagOPEN = false;
            Id lastId = null;
    }
    
    
    
    
/*    global static void schedule()
    {
        
    }*/

    webservice static void ExecuteBatch()
    {
        DeleteContactAttachmentBatch n = new DeleteContactAttachmentBatch();
        Database.executeBatch(n);
    } 
    
    global void execute(SchedulableContext SC)
    {
        DeleteContactAttachmentBatch  n = new DeleteContactAttachmentBatch();
        Database.executeBatch(n);
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
      
      
         List<Attachment> bio_OnePage_Attachments = [SELECT Id, ParentId FROM Attachment WHERE ParentId IN :contactIds AND Name LIKE 'Candidate Biography%' ORDER BY LastModifiedDate] ;
         return Database.getQueryLocator([Select Id, Name, CreatedDate, ParentId, IsDeleted From Attachment 
                                          WHERE IsDeleted != true AND ParentId IN :contactIds 
	                                                     order by ParentId, CreatedDate DESC]); 
        
     //   return Database.getQueryLocator([select id from Contact]);
      
        
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope)
    {
        
     /*  if(scope.size()>0)
       {
           for ( sObject con :scope)
           {
               Contact c = (Contact)con;
               conlist.add(c.id);
               
           }
       }*/
        
        
        
        
        
        
        System.debug('Start Execute');
        if(scope.size()>0)
        {
            Attachment s =(Attachment)scope[0];
	        lastId = s.ParentId;
            
            for(sObject so :scope)
            {
                Attachment attach =(Attachment)so;
                system.debug('Attach Name'+attach.Name);
                
                If(attach.ParentId != lastId)
                {
                       lastId = attach.ParentId;
	            		system.debug('[CleanIdentificationReportsBatch] lastId (IF) '+ lastId);
	            		flagIR = false;
    					flagCBFR = false;
    					flagCBEN = false;
    					flagOPFR = false;
    					flagOPEN = false;   
                }
                
                System.debug('[CleanIdentificationReportsBatch]attach.Name.startsWith(Candidate Biography FR) && flagCBFR '+attach.Name.startsWith('Candidate Biography FR') +' and '+ flagCBFR);
	            	if (attach.Name.startsWith('Candidate Biography FR') && flagCBFR)
	            	{
	            		toDelete.add(attach);
	            		System.debug('[CleanIdentificationReportsBatch] toDelete added: ' + toDelete[toDelete.size()-1]);
	            	}else
	            	{
	            		if (attach.Name.startsWith('Candidate Biography FR'))
	            			flagCBFR = true;
	            	}
	            	
	            	System.debug('[CleanIdentificationReportsBatch]attach.Name.startsWith(Candidate Biography EN) && flagCBEN '+attach.Name.startsWith('Candidate Biography EN') +' and '+ flagCBEN);
	            	if (attach.Name.startsWith('Candidate Biography EN') && flagCBEN)
	            	{
	            		toDelete.add(attach);
	            		System.debug('[CleanIdentificationReportsBatch] toDelete added: ' + toDelete[toDelete.size()-1]);
	            	}else
	            	{
	            		if (attach.Name.startsWith('Candidate Biography EN'))
	            			flagCBEN = true;
	            	}
	            	System.debug('[CleanIdentificationReportsBatch]attach.Name.startsWith(One Page FR) && flagOPFR '+attach.Name.startsWith('One Page FR')+ ' and ' +  flagOPFR );
	            	if (attach.Name.startsWith('One Page FR') && flagOPFR)
	            	{
	            		toDelete.add(attach);
	            		System.debug('[CleanIdentificationReportsBatch] toDelete added: ' + toDelete[toDelete.size()-1]);
	            	}else
	            	{
	            		if (attach.Name.startsWith('One Page FR'))
	            			flagOPFR = true;	            		
	            	}
	            	System.debug('[CleanIdentificationReportsBatch]attach.Name.startsWith(One Page EN) && flagOPEN '+attach.Name.startsWith('One Page EN') +' and '+ flagOPEN);
	            	if (attach.Name.startsWith('One Page EN') && flagOPEN)
	            	{
	            		toDelete.add(attach);
	            		System.debug('[CleanIdentificationReportsBatch] toDelete added: ' + toDelete[toDelete.size()-1]);
	            	}else
	            	{
	            		if (attach.Name.startsWith('One Page EN'))
	            			flagOPEN = true;
	            	}
	            	System.debug('----------------------------------------------------');
                
            }
        }     
        
    }
    
    global void finish(Database.BatchableContext BC)
    {
       if(toDelete.size()>0){
                delete toDelete;	
    	    } 
    }
}