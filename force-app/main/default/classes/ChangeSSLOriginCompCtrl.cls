public class ChangeSSLOriginCompCtrl {
	public ChangeSSLOriginCompCtrl() {
		
	}

	@AuraEnabled
    public static List<String> getPicklistValues(String objectType, String selectedField){
        List<String> pickListValuesList = new List<String>();
        Schema.SObjectType convertToObj = Schema.getGlobalDescribe().get(objectType);
        Schema.DescribeSObjectResult res = convertToObj.getDescribe();
        Schema.DescribeFieldResult fieldResult = res.fields.getMap().get(selectedField).getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            pickListValuesList.add(pickListVal.getLabel());
        }     
        return pickListValuesList;
    }

    @AuraEnabled
    public static Boolean updateStatus(String ssl, String origin, String recListString, String saveType){
        try{
            System.debug('--->'+recListString);
            List<Object> recList = (List<Object>) JSON.deserializeUntyped(recListString);
            Map<Id,Application__c> updateAppMap = new Map<Id,Application__c>();
            Map<String,Object> appObj;
            for(Object rec : recList){
                appObj = (Map<String,Object>)rec;
                System.debug('---> isSelected '+appObj);
                System.debug('---> isSelected '+appObj.keySet());
                System.debug('---> isSelected '+appObj.get('isSelected'));
                if(((Boolean)appObj.get('isSelected')) == true){
                    if(saveType == 'STATUS_SUMMARY_LINE'){
                        updateAppMap.put((Id)appObj.get('Id'),new Application__c(Id=(Id)appObj.get('Id'), Status_Summary_Line__c = ssl, contact__c = (Id)appObj.get('Contact__c')));
                    }
                    else if(saveType == 'ORIGIN'){
                        updateAppMap.put((Id)appObj.get('Id'),new Application__c(Id=(Id)appObj.get('Id'), Origin__c = origin, contact__c = (Id)appObj.get('Contact__c')));
                    }
                    else {
                        updateAppMap.put((Id)appObj.get('Id'),new Application__c(Id=(Id)appObj.get('Id'), Status_Summary_Line__c = ssl,  Origin__c = origin, contact__c = (Id)appObj.get('Contact__c')));
                    }
                }
            }
            System.debug('---> '+updateAppMap);
            if(!updateAppMap.isEmpty()){
                update updateAppMap.values();
                List<Meeting_Note__c> lrnList = [Select Id, Contact__c, Contact__r.Name,
                                              Status_Summary_Line__c, 
                                              Description__c ,
                                              Candidate_Assigned__c,
                                              Candidate_Assigned__r.Origin__c,
                                              Candidate_Assigned__r.Name,
                                              Candidate_Assigned__r.Mandate__c
                                          from Meeting_Note__c 
                                          where Candidate_Assigned__c IN: updateAppMap.keySet()
                                          and Most_Recent__c = true ORDER BY LastModifiedDate ];

                List<Meeting_Note__c> leadersNotes = new List<Meeting_Note__c>();

                for(Meeting_Note__C note : lrnList)
                {
                    if(updateAppMap.containsKey(note.Candidate_Assigned__r.Id))
                        leadersNotes.add(new Meeting_Note__c(Contact__c = updateAppMap.get(note.Candidate_Assigned__r.Id).contact__c , 
                            Candidate_Assigned__c= updateAppMap.get(note.Candidate_Assigned__r.Id).Id , 
                            Status_Summary_Line__c = updateAppMap.get(note.Candidate_Assigned__r.Id).Status_Summary_Line__c, 
                            Description__c = note.Description__C));
                }
                System.debug('---> leadersNotes'+leadersNotes);
                if(!leadersNotes.isEmpty())
                    database.insert(leadersNotes,false);
            }
            return true;
        }catch(Exception e){
            System.debug('---> Exception '+e.getMessage());
            System.debug('---> Line no '+e.getLineNumber());
            return false;
        }
    }
	
}