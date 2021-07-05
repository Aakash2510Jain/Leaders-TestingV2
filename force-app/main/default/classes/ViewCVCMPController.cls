public class ViewCVCMPController {

    public ViewCVCMPController() {
    }
    
    @AuraEnabled
    public static String getCVId(String conId){
        try{
            return [SELECT Id FROM Attachment WHERE ParentId = : conId AND Name LIKE 'CV%' ORDER BY LastModifiedDate DESC limit 1].Id;
        }catch(QueryException e){
            return null;
        }
    }
    
    @AuraEnabled 
    public static List<Application__C> Self_Ass_Data(String conRecId){
        List<Application__C> AppListWithSA = new  List<Application__C>();
        List<Application__C> App_List =  [SELECT Self_Assesment_Status__c,Id,Language__c,Mandate__c,Mandate__r.Company__r.Name,Mandate__r.Name,Mandate__r.Language__c ,Status_Summary_Line__c  FROM Application__c WHERE Contact__c =:conRecId];
        
        for(Application__C app : App_List){
            if(app.Self_Assesment_Status__c =='Template Generated'){
                AppListWithSA.add(app);
            }
        }
        
        return AppListWithSA;
    }
    
    @AuraEnabled 
    public static String get_Attach_id_SelfAss(String recordId)
    {
        try{
            String attId;
            Attachment[] att = [SELECT Id FROM Attachment WHERE ParentId = :recordId AND Name LIKE '%Self Ass%' ORDER BY LastModifiedDate DESC LIMIT 1];
            
            if(att.size() > 0)
            {
                attId = att[0].Id;  
            }
            return attId;
           /* else{
                Id condid =  [SELECT Contact_ID__c FROM Application__c WHERE Id =:recordId].Contact_ID__c;
                attId =  [SELECT Id FROM Attachment WHERE ParentId = :condid AND Name LIKE '%One Pager%' ORDER BY LastModifiedDate DESC LIMIT 1].Id;
                return attId;
            } */
        }
        catch(QueryException e){
            return null;
        }
    } 
    
    

}