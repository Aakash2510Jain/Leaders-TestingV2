public class newLRNContactCandidatesController {
@AuraEnabled
    public static Meeting_Note__c getLeaderNote(String canId)
    {
        Meeting_Note__c leaderNote = new Meeting_Note__c();
        String CandId = canId;
        
        system.debug(candId);
        
        leaderNote = [Select Id, Contact__c, Contact__r.Name,Candidate_Offer_Date__c,
                                              Status_Summary_Line__c, 
                                              Description__c ,
                                              Candidate_Assigned__c,
                                              Candidate_Assigned__r.Origin__c,
                                              Candidate_Assigned__r.Name,
                                              Candidate_Assigned__r.Mandate__c,
                      							Candidate_Assigned__r.Status_Summary_Line__c
                                         from Meeting_Note__c 
                                        where Candidate_Assigned__c =: CandId
                                          and Most_Recent__c = true ORDER BY LastModifiedDate limit 1];
        
        return leaderNote;
        
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
    public static Meeting_Note__c saveLeadersNote(Meeting_Note__c lrn, String ssl)
    {
       
        if(lrn <> null){
          lrn.Status_Summary_Line__c = ssl;
          upsert  lrn;
        }
        if(lrn.Candidate_Offer_Date__c != null){
            update new Application__c(Id=lrn.Candidate_Assigned__r.Id,Candidate_Start_Date__c=lrn.Candidate_Offer_Date__c);
        }
        
        return lrn;
        
        
    }
    
}