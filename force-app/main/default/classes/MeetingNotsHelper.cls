public class MeetingNotsHelper {
    
    public static Boolean RunOnce = false;
    public static void updatesslFrenchValues(List<Meeting_Note__c> appList){
        if(RunOnce == false){
            try{
                List<Meeting_Note__c> appListToUpdate = new List<Meeting_Note__c>();
                
                List<SSL_Values_Conversion__c> customSettingData = [select SSL_English__c,SSL_French__c	 from SSL_Values_Conversion__c];
                Map<String,String> SslValuesMap = new Map<String,String>() ;    
                
                for( SSL_Values_Conversion__c Ssl: customSettingData){
                    SslValuesMap.put(Ssl.SSL_English__c,Ssl.SSL_French__c);
                }
                system.debug('SslValuesMap'+SslValuesMap);
                
                for(Meeting_Note__c apprec:appList){
                    System.debug(SslValuesMap.get(apprec.Status_Summary_Line__c));
                    appListToUpdate.add(new Meeting_Note__c(Id = apprec.Id,Status_Summary_Line_French__c = SslValuesMap.get(apprec.Status_Summary_Line__c)));
                }
                RunOnce = true;
                update appListToUpdate;
            }catch(Exception e){
                system.debug('Error Message ::'+e.getMessage()+'@'+e.getLineNumber());   
            }    
        }
    }
}