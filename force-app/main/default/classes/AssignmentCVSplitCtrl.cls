public class AssignmentCVSplitCtrl {
    
    public string cvid {get;set;} 
    public id contactid {get;set;}
    public id candidateid {get;set;}
 //   public id mandateid {get;set;}
    public Note stdNote {get;set;}
    
  //  public Meeting_Note__c leaderNote {get;set;}
    public Meeting_Note__c leadersNote {get;set;}
    
    public AssignmentCVSplitCtrl(ApexPAges.StandardController sc)
    {
        cvid = ApexPages.currentPage().getParameters().get('cvId');
        contactid = ApexPages.currentPage().getParameters().get('contactId');
        candidateid = ApexPages.currentPage().getParameters().get('candidateId');
   //     mandateid = ApexPages.currentPage().getParameters().get('mandateId');
        
       
            leadersNote = [SELECT Id, Contact__c,Candidate_Assigned__r.Origin__c,Contact__r.Origin__c,Contact__r.LastName, Candidate_Assigned__c,Status_Summary_Line__c, Description__c, Candidate_Assigned__r.Mandate__c  FROM Meeting_Note__c WHERE Candidate_Assigned__c =: candidateid and Most_Recent__c = true ORDER BY LastModifiedDate LIMIT 1];
          
            
            system.debug( 'leaders note data'+leadersNote);
        
        
           stdNote = [SELECT Id, Title, IsPrivate, Body ,ParentId FROM Note LIMIT 1 ] ;
            stdNote.Title ='';
            stdNote.Body='';
            stdNote.IsPrivate = false ; 
            
            
       
        
        
        
        
        
    }
    
    
    
 /*   public PageReference goToNewNote()
    {
       // PageReference newNote = new PageReference('/002/e?parent_id='+contactid+'&retURL=%2F'+contactid);
        String contactid15digit = String.valueOf(contactid).substring(0,15);
        
        String newurl = URL.getSalesforceBaseUrl().toExternalForm();
        
        
     //   PageReference newNote = new PageReference(newurl);
        PageReference newNote = new PageReference('/002/e?parent_id='+contactid15digit+'&retURL=%2F'+contactid);
      //   PageReference newNote = new PageReference('/002/e?parent_id=0030B000022qEHY&retURL=%2F0030B000022qEHYQA2');
        
        newNote.setRedirect(false);
        return newNote;
        
    } */
    
    
    public PageReference saveLeaderNote()
    {
        Meeting_Note__c newLRN = new Meeting_Note__c();
        newLRN.Candidate_Assigned__c =leadersNote.Candidate_Assigned__c;
        newLRN.Contact__c = leadersNote.Contact__c;
        newLRN.Status_Summary_Line__c =  leadersNote.Status_Summary_Line__c;
        newLRN.Description__c = leadersNote.Description__c;
        
        insert newLRN;
        
        apexpages.addMessage(new ApexPages.message(apexpages.Severity.CONFIRM ,'Leaders Report Note Added Successfully !'));
        
       
        
        return null;
    }
    
    
    public PageReference cancelLeaderNote()
    
    {
    /*    Meeting_Note__c newLRN = new Meeting_Note__c();
        newLRN.Candidate_Assigned__c =leadersNote.Candidate_Assigned__c;
        newLRN.Contact__c = leadersNote.Contact__c;
        newLRN.Status_Summary_Line__c =  leadersNote.Status_Summary_Line__c;
        newLRN.Description__c = leadersNote.Description__c;
        
        insert newLRN;
        
        apexpages.addMessage(new ApexPages.message(apexpages.Severity.CONFIRM ,'Leaders Report Note Added Successfully !'));*/
        
       
        
        return null;
    }
    
    
    public PageReference saveNote()
    {
        Note n = new Note();
      //  string contactid15digit = String.valueOf(contactid).substring(0,15);
      //  system.debug('Parent ID for notes is'+contactid15digit);
        n.Title = stdNote.Title ;
        n.ParentId = contactid ;
        n.Body = stdNote.Body ;
        insert n ;
        system.debug('Parent ID for notes is'+n.ParentId);
     //   n.IsPrivate = stdNote.IsPrivate ;
       
      
        
        
        system.debug(n.ParentId);
        
       
        
        apexpages.addMessage(new ApexPages.message(apexpages.Severity.CONFIRM ,' Note Added Successfully !'));
        
        stdNote.IsPrivate = false;
        stdNote.Title = '';
        stdNote.Body = '';
        
        return null;  
        
        
    }
    
    
    public PageReference cancelNote()
    {
        return null;
    }
    
    
    public PageReference saveOrigin()
        
    {
       // Contact con = new Contact();
          Application__c can= new Application__c();
        
      //  con.Origin__c= leadersNote.Contact__r.Origin;
        can.Origin__c = leadersNote.Candidate_Assigned__r.Origin__c; 
      //  con.Id = leadersNote.Contact__r.Id ;
        can.Id = leadersNote.Candidate_Assigned__r.Id;
        
        system.debug('Origin Value :'+can.Origin__c);
        
        
        update can;
        apexpages.addMessage(new ApexPages.message(apexpages.Severity.CONFIRM ,' Origin Updated Successfully !'));
        
        
        
        return null;
        
    }
   
    
   

}