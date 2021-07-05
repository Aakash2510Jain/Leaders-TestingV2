public class SelfAssessmentClass
{
     @AuraEnabled 
    public static list<Self_Assesment__c> SelfAssesmentValues(String mandateRecId){
        
        List<Self_Assesment__c > selfAssList =  [select English__c,French__c,Assignment_Research__c from Self_Assesment__c  where Assignment_Research__c =: mandateRecId ];
        List<Self_Assessment__c> customSettingData = [select name,French__c from Self_Assessment__c];
        List<One_Pager__c> One_Pager_List =  [select English__c,French__c from One_Pager__c where Mandate__c =: mandateRecId ];
        List<String> French = new List<String>();
        List<String> English = new List<String>();
        
        if(One_Pager_List.size() > 0)
        {
            for(One_Pager__c op:One_Pager_List ){
                English.add(op.English__c);
                French.add(op.French__c);  
            }
        }
        system.debug('English'+English+'French'+French);
        for(Self_Assessment__c sa :customSettingData)
        {
            English.add(sa.Name);
            French.add(sa.French__c);
        }
        system.debug('English'+English+'French'+French);
        
        if(selfAssList.size() > 0){
            return  selfAssList;
        }else{
            if(One_Pager_List.size() > 0){
                for(One_Pager__c op:One_Pager_List ){
                    selfAssList.add(new Self_Assesment__c(English__c = op.English__c,French__c = op.French__c,Assignment_Research__c = mandateRecId));}   
                for(Self_Assessment__c sa :customSettingData)
                {
                    selfAssList.add(new Self_Assesment__c(English__c = sa.Name,French__c = sa.French__c,Assignment_Research__c = mandateRecId));}
            }
            else{
                for(Self_Assessment__c sa :customSettingData)
                {
                    selfAssList.add(new Self_Assesment__c(English__c = sa.Name,French__c = sa.French__c,Assignment_Research__c = mandateRecId));}
            }
        }
        return selfAssList;
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
    
}