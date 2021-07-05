public class AssignmentCandidatesWrapper implements Comparable{
	
	public Application__c candidates;
	public static String sortBy{get;set;}
	
	public AssignmentCandidatesWrapper(Application__c c) {
        candidates = c;
    }
    
    public Integer compareTo(Object compareTo){
    	
    	Integer oReturn = 0;
    
        AssignmentCandidatesWrapper aCandidateWrapper = (AssignmentCandidatesWrapper) compareTo;
        
        String fOli = candidates.Status_Summary_Line__c != null ? candidates.Status_Summary_Line__c : '0';
        String sOli = aCandidateWrapper.candidates.Status_Summary_Line__c != null ? aCandidateWrapper.candidates.Status_Summary_Line__c : '0';
                
        if(sortBy == 'asc') {
        
           if (fOli.compareTo(sOli) > 0){
        		oReturn = 1;
           }
        	  	        	        	      	
        }	

        if(sortBy == 'desc') {
        	
        	if (fOli.compareTo(sOli) < 0){
	    		oReturn = 1;
		    } 
        }
        
        return oReturn;        
    }
    
	    
}