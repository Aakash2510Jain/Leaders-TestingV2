public class newLRNCompController {
    @AuraEnabled
    public static Meeting_Note__c getLeaderNote(String canId)
    {
        Meeting_Note__c leaderNote = new Meeting_Note__c(Status_Summary_Line__c='',Description__c='',Candidate_Assigned__c=canId);
        String CandId = canId;
        system.debug(candId);
        List<Meeting_Note__c> meetingNotes = [Select Id, Contact__c,Candidate_Offer_Date__c, Contact__r.Name,
                                              Status_Summary_Line__c,Description__c ,Candidate_Assigned__c,Candidate_Assigned__r.Origin__c,
                                              Candidate_Assigned__r.Name,Candidate_Assigned__r.Mandate__c,Candidate_Assigned__r.Current_Title_French__c,Candidate_Assigned__r.Current_Title__c,Candidate_Assigned__r.Status_Summary_Line__c,Candidate_Assigned__r.Current_Company_French__c 
                                              from Meeting_Note__c where Candidate_Assigned__c =: CandId
                                              and Most_Recent__c = true ORDER BY LastModifiedDate limit 1
                                             ];
        
        if(!meetingNotes.isEmpty()){
            leaderNote = meetingNotes[0];
        }else{
            Application__c candidaterec         = new Application__c();
            candidaterec                        = [Select Id,Name,Contact__c from Application__c where id=:canId];
            leaderNote.Contact__c               = candidaterec.Contact__c;
            leaderNote.Candidate_Assigned__c    = canId;
            leaderNote.Most_Recent__c           = true;
            
            upsert leaderNote;
            
            List<Meeting_Note__c> meetingNotesafterUpsert = [Select Id,Candidate_Offer_Date__c, Contact__c, Contact__r.Name,
                                                             Status_Summary_Line__c,Description__c ,Candidate_Assigned__c,Candidate_Assigned__r.Origin__c,
                                                             Candidate_Assigned__r.Name,Candidate_Assigned__r.Current_Title_French__c,Candidate_Assigned__r.Mandate__c,Candidate_Assigned__r.Current_Title__c,Candidate_Assigned__r.Status_Summary_Line__c,Current_Company_French__c
                                                             from Meeting_Note__c where Candidate_Assigned__c =: CandId
                                                             and Most_Recent__c = true ORDER BY LastModifiedDate limit 1
                                                            ];
            
            if(!meetingNotesafterUpsert.isEmpty()){
                leaderNote = meetingNotesafterUpsert[0];
            }
        }
        return leaderNote;
    }
    
    @AuraEnabled
    public static List<Application__c> getRelatedAssignmentRec(Id recordId){
        
        String RecId = [SELECT Contact__c FROM Application__c WHERE Id = :recordId].Contact__c;
        
        List<Application__c> returnRelatedAssignments = new List<Application__c>();
        
        List<Application__c> listOfCan = [select Id, Name, Mandate__c, Mandate__r.Name,Current_Company_French__c,Mandate__r.Assignment_Status__c, Client_Company__c,Status_Summary_Line__c from Application__c where Contact__c =: recId order by CreatedDate desc];
        
        for(Application__c app : listOfCan){
            if(recordId != app.Id){
                returnRelatedAssignments.add(app);    
            }
        }
        return returnRelatedAssignments;
    }
    
  /*  @AuraEnabled
    public static List<List<Meeting_Note__c>> getAllNotesfromOtherAss(Id contactAssigned){
        
        string ConId = [SELECT Contact__c FROM Application__c WHERE id= :contactAssigned].Contact__c;
        List<String> AppIds = new List<String>();
        List<Application__c> apps = [SELECT Id FROM Application__c WHERE Contact__c = :ConId];
        for(Application__c app :apps){
            if(app.Id != contactAssigned){
                AppIds.add(app.Id);    
            }
        }
        Map<Id,List<Meeting_Note__c>> meetingNoteMap=new Map<Id,List<Meeting_Note__c>>();
        List<Meeting_Note__c> mnList=[Select id,CreatedDate,Related_Mandate__c ,Created_Date_Formula__c,Name,Status_Summary_Line__c,Description__c,Contact__c,Candidate_Assigned__c from Meeting_Note__c where Candidate_Assigned__c=:contactAssigned order by CreatedDate desc];
        List<Meeting_Note__c> mnListFromAllAss=[Select id,CreatedDate,Related_Mandate__c ,Created_Date_Formula__c,Name,Status_Summary_Line__c,Description__c,Contact__c,Candidate_Assigned__c from Meeting_Note__c where Candidate_Assigned__c In :AppIds order by CreatedDate desc];
        List<List<Meeting_Note__c>> allNotes =new List<List<Meeting_Note__c>>();
        allNotes.add(mnList);
        allNotes.add(mnListFromAllAss);
        return allNotes;
    } */
    @AuraEnabled
    public static List<Meeting_Note__c> getAllNotes(Id contactAssigned){
        Map<Id,List<Meeting_Note__c>> meetingNoteMap=new Map<Id,List<Meeting_Note__c>>();
        List<Meeting_Note__c> mnList=[Select id,CreatedDate,Created_Date_Formula__c,Related_Mandate__c,Name,Status_Summary_Line__c,Description__c,Current_Company_French__c ,Contact__c,Candidate_Assigned__c from Meeting_Note__c where Candidate_Assigned__c=:contactAssigned order by CreatedDate desc];
        return mnList;
    }
    
    @AuraEnabled
    public static String deleteMeetingNote(Id noteId){
        List<Meeting_Note__c> mnList=[Select id from Meeting_Note__c where id=:noteId];
        delete mnList;
        return 'Success';
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
    public static Meeting_Note__c saveLeadersNote(Meeting_Note__c lrn, String ssl){
        system.debug('lrn'+lrn);
        system.debug('lrn'+lrn);
        if(lrn <> null){
            lrn.Status_Summary_Line__c = ssl;
            upsert  lrn;
        }
        if(lrn.Candidate_Offer_Date__c != null){
            system.debug('1st --->'+lrn.Candidate_Offer_Date__c);
            //update new Application__c(Id=lrn.Candidate_Assigned__r.Id,Candidate_Start_Date__c=lrn.Candidate_Offer_Date__c);
        }
        return lrn;
    }
    
    @AuraEnabled 
    public static String createSelfAssesment(List<Self_Assesment__c> selfAssRecList,List<String> deleteList){
        
        List<Self_Assesment__c> listToBeUpdated = new List<Self_Assesment__c>();
        List<Self_Assesment__c> listToBeInserted = new List<Self_Assesment__c>();
        
        if(!deleteList.isEmpty()){
            Database.delete(deleteList);
        }
        for(Self_Assesment__c selfass : selfAssRecList ){
            
            if(selfass.Id != null){
                listToBeUpdated.add(selfass);
            }else{
                listToBeInserted.add(selfass);
            }            
        }
        if(!listToBeUpdated.isEmpty()){
            update listToBeUpdated;
        }
        if(!listToBeInserted.isEmpty()){
            insert listToBeInserted;
        }
        return 'Success';
    }
    @AuraEnabled
    public static List<One_Pager_Response__c> fetchOnePagerRatingValues(String mandateRecId,String AppId){
        
        List<List<Sobject>> OnePagerRatingData = new List<List<Sobject>>();
        
        List<One_Pager__c> OpData = [SELECT Id,English__c,Numerical_Values__c FROM One_Pager__c WHERE Mandate__c = :mandateRecId];
        
        List<One_Pager_Response__c>  onePagerRatingValue = [SELECT Id,Numerical_Values__c,Question_Eng__c FROM One_Pager_Response__c WHERE Application__c =:AppId];
        
        List<One_Pager_Response__c> ListToBeReturned = new List<One_Pager_Response__c>();
        
        if(!onePagerRatingValue.isEmpty()){
            return onePagerRatingValue;
        }
        else {
            for(One_Pager__c op : OpData){
                One_Pager_Response__c opr = new One_Pager_Response__c();
                opr.Question_Eng__c = op.English__c;
                opr.Numerical_Values__c = 0;
                ListToBeReturned.add(opr);
            }
            return ListToBeReturned;
        }
    }
    @AuraEnabled
    public static List<competencyWrapper> fetchCompetencyData(String mandateRecId,String AppId){
        try{
            List<competencyWrapper> wrapList = new List<competencyWrapper>();
            System.debug('CompId==>'+AppId);
            System.debug('mandateRecId==>'+mandateRecId);
            List<Leader_Report_Note_Competency__c> CompetencyResponse = new List<Leader_Report_Note_Competency__c>();
            List<Mandate_competencies__c> Competency = new List<Mandate_competencies__c>();
            
            List<One_Pager_Response__c> OnePagerRatingValues = [SELECT Id,Question_Eng__c , Numerical_Values__c FROM One_Pager_Response__c WHERE Application__c = :AppId];
            
            List<Mandate_competencies__c> CompetencyList = [SELECT Competencies__c,Competency__c,Id,Ratings__c,Other__c,Picklist_values_2__c,Picklist_values__c,Type__c FROM Mandate_competencies__c where Mandate__c = :mandateRecId];
            System.debug('CompetencyList==>'+CompetencyList);
            CompetencyResponse = [SELECT Multi_select_values__c,Picklist_values_2__c,Picklist_value__c,Numerical_value__c,
                                  Text_value__c,Competency__c FROM Leader_Report_Note_Competency__c WHERE Application__c  =:AppId];
            
            Map<Id,Leader_Report_Note_Competency__c> responseByQuestion = new Map<Id,Leader_Report_Note_Competency__c>();
            if(!CompetencyResponse.isEmpty()){
                for(Leader_Report_Note_Competency__c responseRec:CompetencyResponse){
                    responseByQuestion.put(responseRec.Competency__c,responseRec);
                }
            }
            
            for(Mandate_competencies__c QestionRec:CompetencyList){
                String answer='';
                Decimal rating_Value = 0;
                string CompId;
                if(responseByQuestion.containsKey(QestionRec.Id)){
                    CompId = responseByQuestion.get(QestionRec.Id).Id;
                }else{
                    CompId ='';
                }
                
                List<String> multiAnswer= new List<String>();
                String richTextValue='';
                List<String> pickVal = new List<String>();
                System.debug('QestionRec.Picklist_values_2__c'+QestionRec.Picklist_values_2__c);
                for(String picklistValue: QestionRec.Picklist_values_2__c.split('\n')) {
                    picklistValue = picklistValue.trim();
                    picklistValue = picklistValue.replaceAll('(\\s+)', ' ');
                    pickVal.add(picklistValue);
                }
                System.debug('pickVal'+pickVal);
                if(responseByQuestion.containsKey(QestionRec.Id)){
                    rating_Value = responseByQuestion.get(QestionRec.Id).Numerical_value__c;
                    if(QestionRec.Type__c =='Text')
                        answer = responseByQuestion.get(QestionRec.Id).Text_value__c != null ? responseByQuestion.get(QestionRec.Id).Text_value__c :'';
                    if(QestionRec.Type__c =='Picklist')
                        answer = responseByQuestion.get(QestionRec.Id).Picklist_value__c != null ? responseByQuestion.get(QestionRec.Id).Picklist_value__c :'';
                    richTextValue = responseByQuestion.get(QestionRec.Id).Picklist_values_2__c;
                    //if(QestionRec.Type__c ='Multi-Select')
                    //multiAnswer = responseByQuestion.get(QestionRec.Id).Multi_select_values__c != null ? responseByQuestion.get(QestionRec.Id).Multi_select_values__c :'';
                }
                If(QestionRec.Competencies__c =='Custom Competency'){
                    wrapList.add(new competencyWrapper(QestionRec.Other__c,QestionRec.Type__c,pickVal,answer,multiAnswer,richTextValue,CompId,QestionRec.Id,rating_Value,OnePagerRatingValues));
                }
                else{
                    wrapList.add(new competencyWrapper(QestionRec.Competencies__c,QestionRec.Type__c,pickVal,answer,multiAnswer,richTextValue,CompId,QestionRec.Id,rating_Value,OnePagerRatingValues));
                }
                
            }
            return wrapList;
        }
        catch(Exception e)
        {
            System.debug('Error==>'+e.getMessage()+'Line Number==>'+e.getLineNumber());
            return null;
        }
    }
    @AuraEnabled 
    public static String Create_Comp_Rec(String appId,String selectedField){
        system.debug('appid'+appId);
        system.debug('selectedField'+(selectedField));
        List<competencyWrapper> wrapList = (List<competencyWrapper>)JSON.deserialize(selectedField, List<competencyWrapper>.class);        
        system.debug('wrapList'+(wrapList));
        List<One_Pager_Response__c> OnePagerResponseTobeUpdated = new List<One_Pager_Response__c>();
        List<One_Pager_Response__c> OnePagerResponseTobeInserted = new List<One_Pager_Response__c>();
        
        /*for(One_Pager_Response__c oprs:ratingValue){
system.debug('oprs.Application__c'+oprs.Application__c);
if(oprs.Application__c == null && oprs.Id == null){
One_Pager_Response__c opr = new One_Pager_Response__c();
opr.Application__c = appId;
opr.Numerical_Values__c = oprs.Numerical_Values__c;
opr.Question_Eng__c = oprs.Question_Eng__c;  
OnePagerResponseTobeInserted.add(opr);
}
else{
OnePagerResponseTobeUpdated.add(oprs);
}

}
update OnePagerResponseTobeUpdated;
insert OnePagerResponseTobeInserted;
*/
        List<Leader_Report_Note_Competency__c> CompetencyResponseToBeUpdated = new List<Leader_Report_Note_Competency__c>();
        List<Leader_Report_Note_Competency__c> CompetencyResponseToBeInserted = new List<Leader_Report_Note_Competency__c>();
        
        List<Leader_Report_Note_Competency__c> CompetencyResponsefromAppid = [SELECT Id,Multi_select_values__c,Picklist_values_2__c,Picklist_value__c,
                                                                              Text_value__c,Competency__c,Numerical_value__c FROM Leader_Report_Note_Competency__c WHERE Application__c  =:appId];
        
        /* List<One_Pager_Response__c> RatingToBeUpdate = new List<One_Pager_Response__c>();

for(competencyWrapper cw : wrapList){
system.debug('OPVALUES'+(cw.OnePagerRatingValues));
RatingToBeUpdate  = cw.OnePagerRatingValues;
}
system.debug('RatingToBeUpdate'+RatingToBeUpdate);

update RatingToBeUpdate; */
        
        system.debug('CompetencyResponseToBeUpdated'+CompetencyResponseToBeUpdated);
        system.debug('CompetencyResponseToBeUpdated'+wrapList);
        if(!CompetencyResponsefromAppid.isEmpty()){
            for(competencyWrapper cw : wrapList){
                //for(Leader_Report_Note_Competency__c LRNPC : CompetencyResponsefromAppid){
                
                //system.debug('cw.compId'+cw.compId+'LRNPC.Competency__c'+LRNPC.Competency__c);
                if(cw.compId !='' )
                {   
                    Leader_Report_Note_Competency__c comp = new Leader_Report_Note_Competency__c();
                    comp.Application__c = appId;
                    comp.Id = cw.compId ;    
                    comp.Picklist_value__c = cw.singleAnswer;
                    comp.Picklist_values_2__c = cw.richTextValue;
                    comp.Numerical_value__c = cw.Rating;
                    CompetencyResponseToBeUpdated.add(comp);    
                    
                }
                else{
                    Leader_Report_Note_Competency__c comp = new Leader_Report_Note_Competency__c();
                    comp.Application__c = appId;
                    comp.Competency__c = cw.questionRecId;
                    comp.Picklist_value__c = cw.singleAnswer;
                    comp.Picklist_values_2__c = cw.richTextValue;
                    comp.Numerical_value__c = cw.Rating;
                    CompetencyResponseToBeInserted.add(comp);
                }
            } 
        }
        else{
            for(competencyWrapper cw : wrapList){
                
                Leader_Report_Note_Competency__c comp = new Leader_Report_Note_Competency__c();
                comp.Application__c = appId;
                comp.Competency__c = cw.questionRecId;
                comp.Picklist_value__c = cw.singleAnswer;
                comp.Picklist_values_2__c = cw.richTextValue;
                comp.Numerical_value__c = cw.Rating;
                CompetencyResponseToBeInserted.add(comp);
            }    
        }
        
        if(!CompetencyResponseToBeInserted.isEmpty()){
            insert CompetencyResponseToBeInserted; 
        }
        if(!CompetencyResponseToBeUpdated.isEmpty()){
            update CompetencyResponseToBeUpdated;
        }
        return 'Success';
    }
}