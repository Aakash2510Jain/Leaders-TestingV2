public class ContactCandidatesLightningCtrl {
    
    @AuraEnabled
    public static List<ConAttDetailsWrapper> getRelatedAssignments(Id recordId){
        
        Id RecId = recordId;
        List<Application__c> returnRelatedAssignments = new List<Application__c>();
        List<ConAttDetailsWrapper> returnallRelatedDetailswithOnePAger = new List<ConAttDetailsWrapper>();
        
        List<Application__c> listOfCan = [select Id, Has_One_Pager__c ,Name, Mandate__c, Mandate__r.Name,Mandate__r.Assignment_Status__c,Current_Company_EN__c , Client_Company__c,Status_Summary_Line__c from Application__c where Contact__c =: RecId AND Mandate__r.Assignment_Status__c ='Active' order by CreatedDate desc];
        System.debug('listOfCan'+listOfCan);
      
        for(Application__c app : listOfCan){
            if(app.Has_One_Pager__c == true)
            {
            	returnallRelatedDetailswithOnePAger.add(new ConAttDetailsWrapper(app.Mandate__r.Name,app.Mandate__r.Assignment_Status__c,app.Current_Company_EN__c,app.Status_Summary_Line__c,app.Has_One_Pager__c,app.Mandate__c,App.Id));    
            }
          }
        return returnallRelatedDetailswithOnePAger;
    }
    
    @AuraEnabled
    public static List<Application__c> getRelatedAssignmentRec(Id recordId){
        
        Id RecId = recordId;
        List<Application__c> returnRelatedAssignments = new List<Application__c>();
        
        List<Application__c> listOfCan = [select Id, Name, Mandate__c, Mandate__r.Name,Mandate__r.Assignment_Status__c,Mandate_Start_Date__c , Client_Company__c,Status_Summary_Line__c from Application__c where Contact__c =: recId order by CreatedDate desc];
        //  String Query= 'select Id, Name, Mandate__c, Mandate__r.Name, Client_Company__c,Status_Summary_Line__c from Application__c where Contact__c = '+RecId+' ';
        
        // returnRelatedAssignments.candidateList = Database.query(query);
        
        for(Application__c app : listOfCan){
            returnRelatedAssignments.add(app);
        }
        return returnRelatedAssignments;
    }
    
    
    @AuraEnabled   
    public static Meeting_Note__c saveLeadersNote(Meeting_Note__c lrn, String ssl)
    {
        if(lrn <> null){
            lrn.Status_Summary_Line__c = ssl;
            upsert  lrn;
        }
        return lrn;
    }
    @AuraEnabled
    public static String getAttId(String canId){
        try{
            String attId;
            Attachment[] att = [SELECT Id FROM Attachment WHERE ParentId = :canId AND Name LIKE '%One Pager%' ORDER BY LastModifiedDate DESC LIMIT 1];
            if(att.size() > 0)
            {
                  return att[0].Id;  
            }
            else{
                Id condid =  [SELECT Contact_ID__c FROM Application__c WHERE Id =:canId].Contact_ID__c;
                attId =  [SELECT Id FROM Attachment WHERE ParentId = :condid AND Name LIKE '%One Pager%' ORDER BY LastModifiedDate DESC LIMIT 1].Id;
                return attId;
            }
        }catch(QueryException e){
           return null;
        }
    }
    @AuraEnabled
    public static Map<Id,List<Meeting_Note__c>> getAllMeetingNotes(Id contactId){
        Map<Id,List<Meeting_Note__c>> meetingNoteMap=new Map<Id,List<Meeting_Note__c>>();
        List<Meeting_Note__c> mnList=[Select id,CreatedDate,Name,Status_Summary_Line__c,Description__c,Contact__c,Candidate_Assigned__c from Meeting_Note__c where Contact__c=:contactId];
        List<Meeting_Note__c> notelist=new List<Meeting_Note__c>();
        
        for(Meeting_Note__c mn:mnList){
            if( !meetingNoteMap.containsKey(mn.Candidate_Assigned__c)){
                //noteList.add(mn);
                meetingNoteMap.put(mn.Candidate_Assigned__c,new List<Meeting_Note__c>{mn});
            }else{
                meetingNoteMap.get(mn.Candidate_Assigned__c).add(mn);
            }

        }
        System.debug('meetingNoteMap==>'+meetingNoteMap);
        return meetingNoteMap;
    }
    @AuraEnabled
    public static List<Meeting_Note__c> getAllNotes(Id contactAssigned){
        Map<Id,List<Meeting_Note__c>> meetingNoteMap=new Map<Id,List<Meeting_Note__c>>();
        List<Meeting_Note__c> mnList=[Select id,CreatedDate,Created_Date_Formula__c,Name,Status_Summary_Line__c,Description__c,Contact__c,Candidate_Assigned__c from Meeting_Note__c where Candidate_Assigned__c=:contactAssigned order by CreatedDate desc];
        return mnList;
    }
    @AuraEnabled
    public static String deleteMeetingNote(Id noteId){
        
        List<Meeting_Note__c> mnList=[Select id from Meeting_Note__c where id=:noteId];
        
        delete mnList;
        return 'Success';
    }
    public class ConAttDetailsWrapper{
        @AuraEnabled
        public String AssName {get;set;}
        @AuraEnabled
        public String CompanyName {get;set;}        
        @AuraEnabled
        public String Status {get;set;}
        @AuraEnabled
        public String Ass_Status {get;set;}
        @AuraEnabled
        public Boolean Has_One_Pager {get;set;}
        @AuraEnabled
        public String AssId{get;set;}
         @AuraEnabled
        public String AppId{get;set;}
        
        public  ConAttDetailsWrapper(String AssName,String Ass_Status,String CompanyName, String Status,Boolean Has_One_Pager,String AssId,String AppId){            
            this.AssName 		=  AssName;
            this.CompanyName 		=  CompanyName;
            this.Status 		=  Status;
            this.Has_One_Pager 		=  Has_One_Pager;
            this.AssId = AssId;
            this.Ass_Status = Ass_Status;
            this.AppId = AppId;
        }
    }
    
    
    
}