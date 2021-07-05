public class ScheduleInterviewController {
    
    @AuraEnabled
    public static Boolean updateStatus(String recListString){
        try{
            System.debug('--->'+recListString);
            List<Object> recList = (List<Object>) JSON.deserializeUntyped(recListString);
            system.debug('recList'+recList);
            Map<Id,Application__c> updateAppMap = new Map<Id,Application__c>();
            Map<String,Object> appObj;
            for(Object rec : recList){
                appObj = (Map<String,Object>)rec;
                if(((Boolean)appObj.get('isSelected')) == true){
                    {
                        String myDate  = (String)appObj.get('Interview_Date__c');
                        String myTime  = (String)appObj.get('Schedule_Interview_Time__c');
                        if(myDate != null && myDate != ''){
                            Date dt = date.valueOf(myDate);
                            System.debug(myDate);
                            System.debug(myTime);
                            System.debug(dt);
                            updateAppMap.put((Id)appObj.get('Id'),new Application__c(Id=(Id)appObj.get('Id'),Interview_Date__c = dt,Schedule_Interview_Time__c = myTime,contact__c = (Id)appObj.get('Contact__c')));
                        }
                        else{
                            updateAppMap.put((Id)appObj.get('Id'),new Application__c(Id=(Id)appObj.get('Id'),Interview_Date__c = null,Schedule_Interview_Time__c = null,contact__c = (Id)appObj.get('Contact__c')));
                        } 
                    }
                }
            }
            System.debug('---> '+updateAppMap);
            if(!updateAppMap.isEmpty()){
                update updateAppMap.values();
            }
            return true;
        }
        catch(Exception e){
            System.debug('---> Exception '+e.getMessage());
            System.debug('---> Line no '+e.getLineNumber());
            return false;
        }
    }
}