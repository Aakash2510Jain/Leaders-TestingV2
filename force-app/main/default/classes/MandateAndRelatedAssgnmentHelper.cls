public class MandateAndRelatedAssgnmentHelper {
    @auraEnabled
    public static List<Application__c> getMandatesRelatedAssignment(string mandateId){
        system.debug('mandateId'+mandateId);
<<<<<<< HEAD
        List<Application__c> applicationList = [SELECT Id,Contact_Email__c,First_Name__c,Last_Name__c,Email__c,Contact_ID__c,Phone__c,Status_Summary_Line__c,CV__c,Language__c,mandate_company_name__c,Has_CV__c,Contact__r.hasCV__c,Has_One_Pager__c,Mandate__c  FROM Application__c WHERE Mandate__c =:mandateId AND Contact_Full_Name__c != null];
=======
        List<Application__c> applicationList = [SELECT Id,Contact_Email__c,First_Name__c,Last_Name__c,Email__c,Contact_ID__c,Phone__c,Status_Summary_Line__c,CV__c,Language__c,mandate_company_name__c,Has_CV__c,Contact__r.hasCV__c FROM Application__c WHERE Mandate__c =:mandateId AND Contact_Full_Name__c != null];
>>>>>>> ad9b07c5964cf2f1cd377ee469c8bb8c2c3c16a8
        System.debug('applicationList'+applicationList);
        return applicationList;
    }
    @auraEnabled
    public static String getAttahment(String conId){
        String attachmentId = [SELECT Id FROM Attachment WHERE Name = 'CV.pdf' AND ParentId =: conId].Id;
        return attachmentId;
    }
<<<<<<< HEAD
    @auraEnabled 
    public static List<One_Pager_Response__c> getOnePAgerQuestions(string assignmentId,string conid){
        system.debug('assignmentId::'+assignmentId);
        system.debug('conid::'+conid);
        string applicationId = [Select Id from Application__c Where  Mandate__c =:assignmentId AND Contact_ID__c =: conid].Id;
        system.debug('applicationId::'+applicationId);
        List<One_Pager__c> onePagerList = [SELECT English__c,French__c,Id,Mandate__c,Name,One_Pager_Response__c FROM One_Pager__c WHERE Mandate__c =: assignmentId];
        system.debug('onePagerList::'+onePagerList);
        system.debug('assignmentId::'+assignmentId);
        List<One_Pager_Response__c> onePagerResponse = [SELECT Application__c,Assignment__c,One_Pager__c,Question_Eng__c,Response__c FROM One_Pager_Response__c WHERE Application__c =: applicationId];
        system.debug('onePagerResponse::'+onePagerResponse);
        system.debug('onePagerResponse::'+onePagerResponse.size());
        List<One_Pager_Response__c> onePagerResponseListToBeUpdated = new List<One_Pager_Response__c>();
        if(!onePagerResponse.isEmpty()){
            onePagerResponseListToBeUpdated = onePagerResponse;
        }
        else{
            for(One_Pager__c onePagerRec : onePagerList ){
                One_Pager_Response__c onePagerRespo = new One_Pager_Response__c();
                onePagerRespo.Application__c = applicationId;
                onePagerRespo.Assignment__c = assignmentId;
                //onePagerRespo.One_Pager__c = onePagerRec.English__c;
                onePagerRespo.Question_Eng__c = onePagerRec.English__c;
                onePagerRespo.Response__c = '';
                onePagerResponseListToBeUpdated.add(onePagerRespo);
            }
        }
         system.debug('onePagerResponseListToBeUpdated::'+onePagerResponseListToBeUpdated);
        return onePagerResponseListToBeUpdated;
    }
    @auraEnabled
    public static void saveOnePagerResponseonApplication( List<One_Pager_Response__c> onePagerResponseList){
        system.debug('onePagerResponseList::'+onePagerResponseList);
        upsert onePagerResponseList;
        string applicationId ;
        for(One_Pager_Response__c onePagerRespo : onePagerResponseList){
            applicationId = onePagerRespo.Application__c;
        }
        Application__c app = new Application__c();
        app.Id = applicationId;
        app.Has_One_Pager__c = True;
        update app;
    }
=======
>>>>>>> ad9b07c5964cf2f1cd377ee469c8bb8c2c3c16a8
}