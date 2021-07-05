public class RadarRatingHelper {
    @AuraEnabled 
    public static list<Radar_Rating__c> RadarValues(String mandateRecId){
        
        List<Radar_Rating__c > RadRatingList =  [select Radar_Rating_Fr_Ques__c,Radar_Rating_Ques__c,Assignment__c from Radar_Rating__c  where Assignment__c =: mandateRecId ];
        List<Radar_Values__c> customSettingData = [select name,French__c from Radar_Values__c];
        List<Radar_Rating__c > newRadarList = new List<Radar_Rating__c >();
        List<One_Pager__c> One_Pager_List =  [select English__c,French__c from One_Pager__c where Mandate__c =: mandateRecId ];
        
        if(RadRatingList.size() > 0){
            return  RadRatingList;
        }else{
            if(One_Pager_List.size() > 0){
                for(One_Pager__c op:One_Pager_List ){
                    newRadarList.add(new Radar_Rating__c(Radar_Rating_Ques__c = op.English__c,Radar_Rating_Fr_Ques__c = op.French__c,Assignment__c = mandateRecId));}
            }else{
                for(Radar_Values__c ra :customSettingData)
                {
                    newRadarList.add(new Radar_Rating__c(Radar_Rating_Ques__c = ra.Name,Radar_Rating_Fr_Ques__c = ra.French__c,Assignment__c = mandateRecId));}
            }
            
            return newRadarList;
        }
    }
    @AuraEnabled 
    public static String createRadarRating(List<Radar_Rating__c> RadarList,List<String> deleteList){
        
        List<Radar_Rating__c> listToBeUpdated = new List<Radar_Rating__c>();
        List<Radar_Rating__c> listToBeInserted = new List<Radar_Rating__c>();
        
        if(!deleteList.isEmpty()){
            Database.delete(deleteList);
        }
        for(Radar_Rating__c rad : RadarList ){
            if(rad.Id != null){
                listToBeUpdated.add(rad);
            }else{
                listToBeInserted.add(rad);
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