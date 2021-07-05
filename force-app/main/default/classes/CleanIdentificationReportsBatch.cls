/* **************************************************************************
* Batch Class: CleanIdentificationReportsBatch
* Created by Ajeet

************************************************************************** */
global class CleanIdentificationReportsBatch implements Database.Batchable<sObject>, Schedulable,
    Database.Stateful{
    	
    global static void Schedule(){
        CleanIdentificationReportsBatch p = new CleanIdentificationReportsBatch();
        String sch = '0 0 01 * * ?'; 
        system.schedule('Clean Identifaction Reports All Mandates', sch, p); 
    }
    
    WebService static void ExecuteBatch(){
       CleanIdentificationReportsBatch n = new CleanIdentificationReportsBatch();
       Database.executeBatch(n);
    }   	
    global void execute(SchedulableContext SC){
       CleanIdentificationReportsBatch n = new CleanIdentificationReportsBatch();
       Database.executeBatch(n);
    }    	
    	
    	global id mandateId;
    	global set<id> mandateIds= new set<id>();
    	global List<Attachment> toDelete = new List<Attachment>();
    	global boolean flagIR = false;
    	global boolean flagCBFR = false;
    	global boolean flagCBEN = false;
    	global boolean flagOPFR = false;
    	global boolean flagOPEN = false;
    	global Id lastId = null;
    	
    	global CleanIdentificationReportsBatch()
        {            
            toDelete = new List<Attachment>();
            flagIR = false;
            flagCBFR = true;
            flagCBEN = true;
            flagOPFR = true;
            flagOPEN = true;
            Id lastId = null;
            
        }    	
    	
    	global CleanIdentificationReportsBatch(Id mId)
    	{
    		
    		mandateId=mId;
    		toDelete = new List<Attachment>();
    		flagIR = false;
    		flagCBFR = true;
    		flagCBEN = true;
    		flagOPFR = true;
    		flagOPEN = true;
    		Id lastId = null;
    		
    	}
        global CleanIdentificationReportsBatch(set<id> mIds)
        {
            
            mandateIds=mIds;
            toDelete = new List<Attachment>();
            flagIR = false;
            flagCBFR = true;
            flagCBEN = true;
            flagOPFR = true;
            flagOPEN = true;
            Id lastId = null;
            
        }    	
    	global Database.QueryLocator start(Database.BatchableContext BC)
    	{
        	System.debug('[CleanIdentificationReportsBatch] start with mandateId: '+ mandateId);
        	System.debug('[CleanIdentificationReportsBatch] start with mandateId: '+ mandateIds);
        	if(mandateId != null){
	        	List<Application__c> app = [Select Contact__c, Contact__r.FirstName,  
	                						Contact__r.LastName From Application__c 
	                						where Contact__c != null and Mandate__c =:mandateId];
	        	
	        	 List<Id> cId = new List<Id>();
	        	 
	        	 for(Application__c a: app){
	        	 	
	        	 	cId.add(a.Contact__c);
	        	 	
	        	 }
	        	
	        	return Database.getQueryLocator([Select Id, Name, CreatedDate, ParentId, IsDeleted From Attachment 
	        									WHERE IsDeleted != true AND (ParentId =:mandateId or
	        										  ParentId IN :cId) 
	        										  
	        									order by ParentId, CreatedDate DESC]);
        	}else if (mandateIds.size() > 0){
                List<Application__c> app = [Select Contact__c, Contact__r.FirstName,  
	                                        Contact__r.LastName From Application__c 
	                                        where Contact__c != null and Mandate__c IN : mandateIds];
	            
                List<Id> cId = new List<Id>();
	             
                for(Application__c a: app){
	                
	                cId.add(a.Contact__c);
	                
                }
	            
                return Database.getQueryLocator([Select Id, Name, CreatedDate, ParentId, IsDeleted From Attachment 
	                                            WHERE IsDeleted != true AND (ParentId IN : mandateIds or
	                                                  ParentId IN :cId) 
	                                                    
	                                            order by ParentId, CreatedDate DESC]);    
        	}else{
        	    set<id> allmandateIds= new set<id>();
        	    for(Mandate__c assi : [Select Id from Mandate__c]){
                    allmandateIds.add(assi.Id);
                }
                
                List<Application__c> app = [Select Contact__c, Contact__r.FirstName,  
                                            Contact__r.LastName From Application__c 
                                            where Contact__c != null and Mandate__c IN : allmandateIds];
                
                List<Id> cId = new List<Id>();
                 
                for(Application__c a: app){
                    
                    cId.add(a.Contact__c);
                    
                }
                
                return Database.getQueryLocator([Select Id, Name, CreatedDate, ParentId, IsDeleted From Attachment 
                                                WHERE IsDeleted != true AND (ParentId IN : allmandateIds or
                                                      ParentId IN :cId) 
                                                        
                                                order by ParentId, CreatedDate DESC]);                    
        	}
        
        }
    	
    	global void execute(Database.BatchableContext BC, List<sObject> scope)
    	{
    		
    		
    		system.debug('[CleanIdentificationReportsBatch] starting Execute'); 
	        if(scope.size() > 0)
	        {	
	        	
	        	Attachment s =(Attachment)scope[0];
	        	lastId = s.ParentId;
	        	system.debug('[CleanIdentificationReportsBatch] lastId: '+ lastId);
	        	for(sObject so: scope)
	        	{
	            	Attachment attach = (Attachment)so;
	            	system.debug('[CleanIdentificationReportsBatch]****** attach Name: '+ attach.Name);
	            	if(attach.ParentId != lastId)
	            	{
	            		
	            		lastId = attach.ParentId;
	            		system.debug('[CleanIdentificationReportsBatch] lastId (IF) '+ lastId);
	            		flagIR = false;
    					flagCBFR = false;
    					flagCBEN = false;
    					flagOPFR = false;
    					flagOPEN = false;
	            	}
	            	//system.debug('[CleanIdentificationReportsBatch] ********Attachment  '+ attach);
	            	
	            	if (attach.Name.startsWith('Human Capital Study') || attach.Name.startsWith('Cover')
	            		|| attach.Name.startsWith('Potential Candidates'))
	            	{
	            		toDelete.add(attach);
	            		System.debug('[CleanIdentificationReportsBatch] toDelete added: ' + toDelete[toDelete.size()-1]);
	            	}
	            	
	            	System.debug('[CleanIdentificationReportsBatch]attach.Name.startsWith(Identification Report) && flagIR '+attach.Name.startsWith('Identification Report') +' and '+ flagIR);
	            	if (attach.Name.startsWith('Identification Report') && flagIR)
	            	{
	            		toDelete.add(attach);
	            		System.debug('[CleanIdentificationReportsBatch] toDelete added: ' + toDelete[toDelete.size()-1]);
	            	}else
	            	{
	            		if (attach.Name.startsWith('Identification Report'))
	            			flagIR = true;
	            	}
                    System.debug('[CleanIdentificationReportsBatch]attach.Name.startsWith(Leaders Report) && flagIR '+attach.Name.startsWith('Leaders Report') +' and '+ flagIR);
                    if (attach.Name.startsWith('Leaders Report') && flagIR)
                    {
                        toDelete.add(attach);
                        System.debug('[CleanIdentificationReportsBatch] toDelete added: ' + toDelete[toDelete.size()-1]);
                    }else
                    {
                        if (attach.Name.startsWith('Leaders Report'))
                            flagIR = true;
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
	            	//if(toDelete.size() >0)
	            		//System.debug('[CleanIdentificationReportsBatch] toDelete added: ' + toDelete[toDelete.size()-1]);
	            	
	        	}
	        	//delete toDelete;
        	}
             
    	}
    	
    	global void finish(Database.BatchableContext BC)
    	{
    	    if(toDelete.size()>0){
                delete toDelete;	
    	    }
    	}	
    	
    	

}