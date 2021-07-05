public class BiographyHelper {
	
	
	public static Map<String, Id> biographyRecordTypeIdByName = null;
	
	public static Map<String, Id> getBiographyRecordTypeIdByName(){
    	
    	if (biographyRecordTypeIdByName == null){
    		biographyRecordTypeIdByName = new Map<String, Id>();
    		
    		for (RecordType rt : [SELECT Id, DeveloperName
			                      FROM RecordType 
			                     WHERE SobjectType = 'Work_Experience__c']){
		        
	    		biographyRecordTypeIdByName.put(rt.DeveloperName, rt.Id);
	    	}
    		
    	}
    	
    	return biographyRecordTypeIdByName;
    	
    }
    
    public static List<Work_Experience__c> addNewBiographyList (List<Work_Experience__c> experienceList, Id recordTypeId, Id contactId, Integer nRows){
    	for (Integer i =0; i< nRows; i++){
    		Work_Experience__c newRecord = new Work_Experience__c();
	    	newRecord.RecordTypeId = recordTypeId;
	    	newRecord.Contact__c = contactId;
	    	newRecord.Company__c = null;
	    	experienceList.add(newRecord);
    	}    	
    	return experienceList;
    }
    
    public static List<Work_Experience__c> addExistBiographyList(List<Work_Experience__c> experienceList, Id recordTypeId, Id contactId, List<Work_Experience__c> allWorkExperiences){
    	for (Work_Experience__c we : allWorkExperiences){
    		if (we.RecordTypeId == recordTypeId){
    			experienceList.add(we);
    		}
    	}
    	return experienceList;
    }
    
    public static List<Work_Experience__c> removeRowToBiographyList(Integer rowToRemove, List<Work_Experience__c> biographyList, List<Work_Experience__c> toDelete){    	 	   
    	Work_Experience__c toRemove = biographyList.get(rowToRemove);
    	//delete toRemove;    	    	    	 	
    	biographyList.remove(rowToRemove);
    	if(toRemove.id != null){
    	   toDelete.add(toRemove);
    	}    	
    	system.debug('::  biographyList :: '+biographyList);
    	system.debug('::  toDelete :: '+toDelete);
    	
        return biographyList;
    }
    
    
    public static List<Work_Experience__c> removeEmptyRecords(List<Work_Experience__c> biographyList){
    	
    	system.debug(':::::: removeEmptyRecords '+biographyList);    
    	
    	//List<Work_Experience__c> cleanList = new List<Work_Experience__c>();
    	for(Integer j=0; j<biographyList.size(); j++){
    		System.debug('List size ' + biographyList.size());
    		Work_Experience__c wE = biographyList.get(j);
    		//this is for the experience block    		
    		System.debug('the element ' + j +': ' + wE);
            if (String.isEmpty(wE.Company__c) && String.isEmpty(wE.Title__c) && 
			    String.isEmpty(wE.Title_FR__c) && String.isEmpty(wE.Start_Year__c) &&
			    String.isEmpty(wE.End_Year__c) ){
			    	
				biographyList.remove(j);
                System.debug('Erased ' + j);
                j--;
                    
			}
    	}
    	
    	return biographyList;
    	
    }
    
    public static void save(List<Work_Experience__c> eList, List<Work_Experience__c> eduList, List<Work_Experience__c> pList, List<Work_Experience__c> bList, List<Work_Experience__c> toDelete) {
    	
    	system.debug('::  eList :: '+eList);
    	system.debug('::  toDelete :: '+toDelete);
    	
    	List<Work_Experience__c> biographyToBeInserted = new List<Work_Experience__c>();
    	if(eList !=null && !eList.isEmpty()){
    		List<Work_Experience__c> toBeInserted = removeEmptyRecords(eList);
    		if (!toBeInserted.isEmpty()){
                System.debug('elist not empty ' + toBeInserted);
    			biographyToBeInserted.addAll(toBeInserted);
    		}    		
    				
    	}
    	
    	if(eduList !=null && !eduList.isEmpty()){
    		List<Work_Experience__c> toBeInserted = removeEmptyRecords(eduList);
    		if (!toBeInserted.isEmpty()){
                System.debug('edulist not empty ' + toBeInserted);
    			biographyToBeInserted.addAll(toBeInserted);
    		}       		    		
    	}
    	
    	if(pList !=null && !pList.isEmpty()){
    		List<Work_Experience__c> toBeInserted = removeEmptyRecords(pList);
    		if (!toBeInserted.isEmpty()){
                System.debug('plist not empty ' + toBeInserted);
    			biographyToBeInserted.addAll(toBeInserted);
    		}    		
    	}
    	
    	if(bList !=null && !bList.isEmpty()){
    		List<Work_Experience__c> toBeInserted = removeEmptyRecords(bList);
    		if (!toBeInserted.isEmpty()){
                System.debug('blist not empty ' + toBeInserted);
    			biographyToBeInserted.addAll(toBeInserted);
    		}     		
    	}
    	
    	if(biographyToBeInserted.size()>0){
    		//insert biographyToBeInserted;
    		upsert biographyToBeInserted;
    	}
    	
    	if(toDelete.size()>0){
    		delete toDelete;
    	}
    } 

}