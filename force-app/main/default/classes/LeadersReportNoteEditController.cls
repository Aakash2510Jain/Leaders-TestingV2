public class LeadersReportNoteEditController {
    
    
    public Meeting_Note__c leaderNote {get;set;}
    
    public List<Mandate_competencies__c> competencies {get;set;}
    
    public Map<String, Leader_Report_Note_Competency__c > leaderNotecompetencyMapByCompetencyId {get;set;}
    
    public Map<String, List<SelectOption> > competencyPicklistValueMapByCompetencyId {get;set;}
    
    public Map<String, List<String> > competencyMultilPicklistValueMapByCompetencyId {get;set;}
    
    public Map<String, Boolean > competencyHashPicklistValue {get;set;}
    
    public Map<String, Boolean > competencyHashMultiPicklistValue {get;set;}
    
    private Apexpages.Standardcontroller controller;
    
    private   String contactId;
    
    private String saveURL = '';
    
    private String retURL = '';
    
    public boolean isTeam3Profile {get;set;}
    public boolean openpopup {get;set;}
    public boolean closepopup {get;set;}
    
    public LeadersReportNoteEditController(Apexpages.Standardcontroller con) {
        
        
        this.controller = con;
        
        leaderNotecompetencyMapByCompetencyId = new Map<String, Leader_Report_Note_Competency__c >();
        competencyPicklistValueMapByCompetencyId = new Map<String, List<SelectOption> >();
        competencyMultilPicklistValueMapByCompetencyId = new Map<String, List<String> >();
        competencyHashPicklistValue = new Map<String, Boolean>();
        competencyHashMultiPicklistValue = new Map<String, Boolean>();
        competencies = new  List<Mandate_competencies__c>();
        
        saveURL = ApexPages.currentPage().getParameters().get('saveURL');
        retURL = ApexPages.currentPage().getParameters().get('retURL');
        
        
          isTeam3Profile= false;
          openpopup = false;
          closepopup= true ;
          Id profileId = userinfo.getProfileId();
          String profileName = [select Name from profile where id = :profileId].Name;
            
          if(profileName.startsWith('Force.com Leaders team 3'))
            isTeam3Profile=true;
        

        if(con.getId()!=null)
            leaderNote = [SELECT Id, Contact__c, Candidate_Assigned__c,Candidate_Assigned__r.Origin__c, Status_Summary_Line__c, Description__c, Candidate_Assigned__r.Mandate__c  FROM Meeting_Note__c WHERE Id=:con.getId()];
        else {
            contactId = ApexPages.currentPage().getParameters().get('CF00NU00000043QIC_lkid');
            String candidateAssigned = ApexPages.currentPage().getParameters().get('CF00NU00000042znA_lkid');
            
            try {
               
                    leaderNote = [Select Id, Contact__c, Contact__r.Name,
                                              Status_Summary_Line__c, 
                                              Description__c ,
                                              Candidate_Assigned__c,
                                              Candidate_Assigned__r.Origin__c,
                                              Candidate_Assigned__r.Name,
                                              Candidate_Assigned__r.Mandate__c
                                         from Meeting_Note__c 
                                        where Candidate_Assigned__c = :candidateAssigned 
                                          and Most_Recent__c = true ORDER BY LastModifiedDate limit 1];

            } catch(Exception e){}

            if(leaderNote==null)
                leaderNote = new Meeting_Note__c(Contact__c=contactId, Candidate_Assigned__c =candidateAssigned);
            
            if(leaderNote.Candidate_Assigned__c!=null) {
                leaderNote.Status_Summary_Line__c = [SELECT Status_Summary_Line__c FROM Application__c WHERE Id=:leaderNote.Candidate_Assigned__c].Status_Summary_Line__c;
            }
            
        }
        
        if(leaderNote.Candidate_Assigned__c!=null) {
            
            
            
            if(leaderNote.Candidate_Assigned__r.Mandate__c!=null)
                competencies = [SELECT Id, Competencies__c, Picklist_values_2__c, Other__c, Sub_competency__c , Type__c FROM Mandate_competencies__c WHERE Mandate__c =:leaderNote.Candidate_Assigned__r.Mandate__c ORDER BY Name ];
            else { 
                String mandateId = [SELECT Id, Mandate__c FROM Application__c  WHERE Id =:leaderNote.Candidate_Assigned__c ].Mandate__c;
                competencies = [SELECT Id, Competencies__c, Picklist_values_2__c, Other__c, Sub_competency__c , Type__c FROM Mandate_competencies__c WHERE Mandate__c =:mandateId ORDER BY Name ];
            }
        } 
         
        
        if(leaderNote.Id!=null) {
            
            for(Leader_Report_Note_Competency__c leaderReportNoteCompetency: [SELECT Id, Multi_select_values__c ,Picklist_values_2__c, Competency__c, Numerical_value__c, Leader_Report_Notes__c, Text_value__c, Evaluation__c   FROM Leader_Report_Note_Competency__c WHERE Leader_Report_Notes__c=:leaderNote.Id]) {
                leaderNotecompetencyMapByCompetencyId.put(leaderReportNoteCompetency.Competency__c, leaderReportNoteCompetency); 
                
                if(leaderReportNoteCompetency.Multi_select_values__c!=null && leaderReportNoteCompetency.Multi_select_values__c!='') {
                    competencyMultilPicklistValueMapByCompetencyId.put(leaderReportNoteCompetency.Competency__c,leaderReportNoteCompetency.Multi_select_values__c.split(','));
                }
            }
        }
        
        
        for(Mandate_competencies__c competency:competencies) {
            if(!leaderNotecompetencyMapByCompetencyId.containsKey(competency.Id))
                leaderNotecompetencyMapByCompetencyId.put(competency.Id, new Leader_Report_Note_Competency__c (Competency__c=competency.Id));
            
            competencyPicklistValueMapByCompetencyId.put(competency.Id, new List<SelectOption>());
            if(!competencyMultilPicklistValueMapByCompetencyId.containsKey(competency.Id))
                competencyMultilPicklistValueMapByCompetencyId.put(competency.Id, new List<String>());
            competencyHashPicklistValue.put(competency.Id,false);
            competencyHashMultiPicklistValue.put(competency.Id,false);
            if(competency.Picklist_values_2__c!=null && competency.Picklist_values_2__c!='') {
                
                if(competency.Type__c=='Multi-select')
                    competencyHashMultiPicklistValue.put(competency.Id,true);
                else
                    competencyHashPicklistValue.put(competency.Id,true);
                
                competencyPicklistValueMapByCompetencyId.get(competency.Id).add(new SelectOption('','- Select a value -'));
                for(String picklistValue: competency.Picklist_values_2__c.split('\n')) {
                    picklistValue = picklistValue.trim();
                    picklistValue = picklistValue.replaceAll('(\\s+)', ' ');
                    competencyPicklistValueMapByCompetencyId.get(competency.Id).add(new SelectOption(picklistValue,picklistValue));
                }
            }
        } 
        
    }
    
    
    //Cancel and go back
    public PageReference cancel() { 
        String returnUrl = '/';
       
        if(retURL!=null) {
            if(retURL!='') {
                returnUrl = retURL;
            }
        }
        
        
        if(saveURL!=null) {
            if(saveURL!='') {
                returnUrl = saveURL;
            }
        }
        
        
        PageReference pageRef = new PageReference(returnUrl);  
        pageRef.setRedirect(true);
        return pageRef;
    } 
    
    //Save (upsert the contract)
    public PageReference save() { 
        if(contactId!=null)
            leaderNote.id = null;
        
        
        upsert leaderNote;
        
        for(Leader_Report_Note_Competency__c leaderReportNoteCompetency: leaderNotecompetencyMapByCompetencyId.values()) {
            leaderReportNoteCompetency.Leader_Report_Notes__c = leaderNote.Id;
            leaderReportNoteCompetency.Multi_select_values__c = '';
            if(competencyMultilPicklistValueMapByCompetencyId.containsKey(leaderReportNoteCompetency.Competency__c))
                if(!competencyMultilPicklistValueMapByCompetencyId.get(leaderReportNoteCompetency.Competency__c).isEmpty())
                    leaderReportNoteCompetency.Multi_select_values__c = string.join(competencyMultilPicklistValueMapByCompetencyId.get(leaderReportNoteCompetency.Competency__c),',');
        }
        
        upsert leaderNotecompetencyMapByCompetencyId.values();
        String returnUrl = '/'+leaderNote.Id;
       
        if(saveURL!=null) {
            if(saveURL!='') {
                returnUrl = saveURL;
            }
        }
         
        /*Origin Saving start */
  /*      Application__c can= new Application__c();
        
      //  con.Origin__c= leadersNote.Contact__r.Origin;
        can.Origin__c = leaderNote.Candidate_Assigned__r.Origin__c; 
      //  con.Id = leadersNote.Contact__r.Id ;
        can.Id = leaderNote.Candidate_Assigned__r.Id;
        
        system.debug('Origin Value :'+can.Origin__c);
        
        
        update can; */
        
        /* Origin Saving Ends */
        
        
        
        
        
        
        
        
        
        
        
        PageReference pageRef = new PageReference(returnUrl);  
        pageRef.setRedirect(true);
        
        return pageRef;
        
    }
    
    public pageReference editOrigin()
    {
         
     String returnUrl = '/'+leaderNote.Id;
       
        if(saveURL!=null) {
            if(saveURL!='') {
                returnUrl = saveURL;
            }
        }
        
        
        /*Origin Saving start */
       Application__c can= new Application__c();
        
      //  con.Origin__c= leadersNote.Contact__r.Origin;
        can.Origin__c = leaderNote.Candidate_Assigned__r.Origin__c; 
      //  con.Id = leadersNote.Contact__r.Id ;
        can.Id = leaderNote.Candidate_Assigned__r.Id;
        
        system.debug('Origin Value :'+can.Origin__c);
        
        
        update can; 
        
        /* Origin Saving Ends */
        
      /*  PageReference pageRef = new PageReference(returnUrl);  
        pageRef.setRedirect(true);
        
        return pageRef;*/
        
        openpopup= false;
        closepopup=true;
        return null;
        
    }
    
    public void cancelOrigin()
    {
        openpopup= false;
        closepopup=true;
    }
    
    public void openOriginPopup()
    {
        openpopup= true;
        closepopup=false;
    }

}