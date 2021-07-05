public class ContactCandidatesCtrl {
	
	private Id contactId;
	
	public List<Application__c> candidates {get;set;}
	
	public String candidateId{
        get;
        set {
            candidateId = value;
        }
    }
		
	public ContactCandidatesCtrl(ApexPages.StandardController stdController) {
        contactId = stdController.getId();
        
        candidates = [Select Id, Name, Mandate__c, Mandate__r.Name, Client_Company__c, 
                             Status_Summary_Line__c
                        from Application__c
                       where Contact__c = :contactId];        
    }
    
    private List<Meeting_Note__c> recentMeetingNotes(Id candId){
   	
   		List<Meeting_Note__c> notes = [Select Id, Contact__c, Contact__r.Name,
                                              Status_Summary_Line__c, 
                                              Description__c ,
                                              Candidate_Assigned__c,
                                              Candidate_Assigned__r.Name
                                         from Meeting_Note__c 
                                        where Candidate_Assigned__c = :candId 
                                          and Most_Recent__c = true];
                                              
        return notes;
   }   
    
    public PageReference createReportNote(){
    
    system.debug(':: candidateId :: '+ candidateId);
    
        if (!String.isEmpty(candidateId)){
            
            List<Meeting_Note__c> notes = recentMeetingNotes(candidateId);
                        
            Schema.DescribeSObjectResult r = Meeting_Note__c.sObjectType.getDescribe();
            String keyPrefix = r.getKeyPrefix();
            String urlParams = '';
            Map<String, String> fieldsId = NubikHelper.getFieldsForObject('Meeting_Note__c'); 
                                              
            if (notes.size()>0){
                Meeting_Note__c note = notes[0];                            
                
                if(fieldsId.get('contact__c') != null){
                    urlParams += fieldsId.get('contact__c') + '=' + note.Contact__r.Name + '&'+ fieldsId.get('contact__c') + '_lkid=' + note.Contact__c + '&';
                }
                        
                
                if(fieldsId.get('candidate_assigned__c') != null){
                    urlParams += fieldsId.get('candidate_assigned__c') + '=' + note.Candidate_Assigned__r.Name + '&'+ fieldsId.get('candidate_assigned__c') + '_lkid=' + note.Candidate_Assigned__c + '&';
                }
                        
                
                if (fieldsId.get('status_summary_line__c') != null && note.Status_Summary_Line__c != null ){
                    
                    String encodedString = EncodingUtil.urlEncode(note.Status_Summary_Line__c, 'UTF-8');

                    system.debug('EncodedString :'+encodedString);
                    
                    urlParams += fieldsId.get('status_summary_line__c') + '=' + encodedString + '&';
                }
                
                
                String description = '';
                
                if (note.Description__c!=null){
                    description = EncodingUtil.urlEncode(note.Description__c, 'UTF-8');
                }
                                
                if (fieldsId.get('description__c') != null){
                    urlParams += fieldsId.get('description__c') + '=' + description + '&';
                }                 
                
            }else{
                
                List<Application__c> app = [Select Id, Name, Contact__c, 
                                                   Contact__r.Name
                                              from Application__c
                                             where Id = :candidateId];
                
                if(fieldsId.get('contact__c') != null){
                    urlParams += fieldsId.get('contact__c') + '=' + app[0].Contact__r.Name + '&'+ fieldsId.get('contact__c') + '_lkid=' + app[0].Contact__c + '&';
                }
                
                if(fieldsId.get('candidate_assigned__c') != null){
                    urlParams += fieldsId.get('candidate_assigned__c') + '=' + app[0].Name + '&'+ fieldsId.get('candidate_assigned__c') + '_lkid=' + app[0].Id + '&';
                }
                
            }
            
            if (fieldsId.get('most_recent__c') != null){
                urlParams += fieldsId.get('most_recent__c') + '=1&';
            }   
            
            urlParams += 'retURL=%2F' + contactId; 
            //urlParams += '&saveUrl=%2F' + contactId; 
            
            system.debug(':: urlParams :: '+ urlParams);            
            Pagereference pr = new Pagereference('/' + keyPrefix + '/e?' + urlParams );             
            return pr;
            
        }
        return null;
   }
   
    public PageReference editReportNote(){
   	
   		if (!String.isEmpty(candidateId)){
   			
   			List<Meeting_Note__c> notes = recentMeetingNotes(candidateId);
                                              
            if (notes.size()>0){
             	Meeting_Note__c note = notes[0];  
                String urlParams = 'retURL=%2F' + contactId; 
             	//urlParams += '&saveUrl=%2F' + contactId; 
             	Pagereference pr = new Pagereference('/' + note.Id + '/e?'+urlParams);             
            	return pr;
            }else{
            	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'No recent Leaders Report Notes to edit.'));
            }
   			
   		}
   	
   		return null;
   }

}