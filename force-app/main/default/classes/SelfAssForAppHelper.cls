public class SelfAssForAppHelper {
    @AuraEnabled(cacheable=true)
    public static List<List<Sobject>> SelfAssesmentValues(String mandateRecId){
        
        List<List<Sobject>> QuestionData = new List<List<Sobject>>();
        List<Self_Assesment__c > selfAssList =  [select English__c,French__c,Assignment_Research__c from Self_Assesment__c  where Assignment_Research__c =: mandateRecId ];
        List<Self_Assessment__c> customSettingData = [select name,French__c from Self_Assessment__c];
        List<Self_Assesment_Response__c> sarList = new List<Self_Assesment_Response__c>();
        
        if(selfAssList.size()>0){
            for(Self_Assesment__c self:selfAssList){
                sarList.add(new Self_Assesment_Response__c(Question_name__c = self.English__c,Response__c = ''));
            }    
        }else{
            for(Self_Assessment__c sa :customSettingData){
                sarList.add(new Self_Assesment_Response__c(Question_name__c = sa.Name,Response__c = ''));
            } 
        }
        system.debug('sarList'+sarList);
        system.debug('selfAssList'+selfAssList);
        List<One_Pager__c > onePagerList =  [select English__c,French__c,Mandate__c  from One_Pager__c  where Mandate__c  =: mandateRecId ];
        List<One_Pager_Values__c> customSettingDataOpr = [select name,French__c from One_Pager_Values__c];
        List<One_Pager_Response__c> oprList = new List<One_Pager_Response__c>();
        
        if(onePagerList.size()>0){
            for(One_Pager__c self:onePagerList){
                oprList.add(new One_Pager_Response__c(Question_Eng__c = self.English__c,Response__c = ''));
            }    
        }else{
            for(One_Pager_Values__c sa :customSettingDataOpr){
                oprList.add(new One_Pager_Response__c(Question_Eng__c = sa.Name,Response__c = ''));
            } 
        }
        system.debug('oprList'+oprList);
        system.debug('onePagerList'+onePagerList);
        
        
        QuestionData.add(sarList);
        QuestionData.add(oprList);
        
        return  QuestionData;
        
    }
    @AuraEnabled(cacheable=true)
    public static list<One_Pager_Response__c> OnePagerValues(String mandateRecId){
        
        List<One_Pager__c > onePagerList =  [select English__c,French__c,Mandate__c  from One_Pager__c  where Mandate__c  =: mandateRecId ];
        List<One_Pager_Values__c> customSettingData = [select name,French__c from One_Pager_Values__c];
        List<One_Pager_Response__c> oprList = new List<One_Pager_Response__c>();
        
        if(onePagerList.size()>0){
            for(One_Pager__c self:onePagerList){
                oprList.add(new One_Pager_Response__c(Question_Eng__c = self.English__c,Response__c = ''));
            }    
        }else{
            for(One_Pager_Values__c sa :customSettingData){
                oprList.add(new One_Pager_Response__c(Question_Eng__c = sa.Name,Response__c = ''));
            } 
        }
        system.debug('oprList'+oprList);
        system.debug('onePagerList'+onePagerList);
        return  oprList;
        
    }
    
    @AuraEnabled
    public static String SelfAssesmentResCreation(list<Self_Assesment_Response__c> selfAssRes){
        system.debug('selfAssRes'+selfAssRes.size());
        List<Self_Assesment_Response__c> sarList = new List<Self_Assesment_Response__c>();
        system.debug(limits.getDmlRows());
        if(selfAssRes.size() > 0){
            try{
             insert selfAssRes;   
                system.debug('error-recID'+selfAssRes[0].Id); 
            }catch(exception e){
            system.debug('error'+e.getMessage());    
            }
        }
        return 'Success';
    }
    @AuraEnabled
    public static String OnePagerResCreation(list<One_Pager_Response__c> onePagerRes){
        system.debug('onePagerRes'+onePagerRes.size());
        List<One_Pager_Response__c> sarList = new List<One_Pager_Response__c>();
        system.debug(limits.getDmlRows());
        if(onePagerRes.size() > 0){
            try{
                insert onePagerRes;   
                system.debug('OPR-recID'+onePagerRes[0].Id); 
            }catch(exception e){
                system.debug('error'+e.getMessage());    
            }
        }
        return 'Success';
    }
}