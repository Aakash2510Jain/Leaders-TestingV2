public class UpdateBiographyCurrentHelper {
    
    public static Boolean isFirstRun = true;
    
    public void beforeInsert(List<Work_Experience__c> workExp){
        
        Set<Id> contactIds = new Set<Id>();
        for(Work_Experience__c wExp:workExp) {
            contactIds.add(wExp.Contact__c);
        }
        
        List<Work_Experience__c> wExps= [SELECT Id FROM Work_Experience__c WHERE Contact__c IN :contactIds];
        
        if(!wExps.isEmpty()) {
            for(Work_Experience__c wExp:wExps) {
                wExp.Current_del__c  = false;
            }
            update wExps;
        }
    }
    public void afterUpdate(List<Work_Experience__c> workExp){
        try{
            System.debug('@@@@ after update ');
            System.debug('@@@@ after update '+workExp);
            Map<String, Id> biographyRecordTypeIdByName = BiographyHelper.getBiographyRecordTypeIdByName();
            
            Id recordTypeId = biographyRecordTypeIdByName.get('Experience');
            List<Contact> conList = new List<Contact>();
            System.debug('@@@@ after update '+recordTypeId);
            for(Work_Experience__c wExp:workExp) {
                System.debug('@@@@ after update '+wExp.Current_del__c);
                if(wExp.RecordTypeId == recordTypeId && wExp.Current_del__c){
                    System.debug('@@@@ after update '+wExp.Title__c);
                    System.debug('@@@@ after update '+wExp.Company__c);
                    Contact conInstance = new Contact(Id=wExp.Contact__c,AccountId=wExp.Company__c);
                    if(wExp.Title__c !=null && wExp.Title__c !=''){
                        conInstance.Title=wExp.Title__c;
                    }
                    conList.add(conInstance);
                    //conList.add(new Contact(Id=wExp.Contact__c,Title=wExp.Title__c!=null?wExp.Title__c:'',AccountId=wExp.Company__c));
                }
                
            }
            System.debug('@@@@ after update '+conList);
            if(!conList.isEmpty()){
                
                update conList;
            }
        }catch(Exception e){
            System.debug('Exception'+e.getMessage()+'AT'+e.getLineNumber());
        }
        
    }
    
}