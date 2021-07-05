public class CompetencyBatch {
    
    public static void createCompetencyForrReport(String mandateId){
        
        deletePreviousRecords(mandateId);
        
        List<Mandate_competencies__c> competencyList = [SELECT Competencies__c,Competency__c,Id,Other__c,
                                                        Picklist_values_2__c,Picklist_values__c,Type__c 
                                                        FROM Mandate_competencies__c where Mandate__c = :mandateId And Type__c='Picklist'];
        
        List<String> allPickListValues = new List<String>();
        
        Map<String,List<String>> pickValByName =  new Map<String,List<String>>();
        
        for(Mandate_competencies__c compRec:competencyList){
            
            List<String> pickVal = new List<String>();
            
            String name = compRec.Competencies__c !='Custom Competency'?compRec.Competencies__c:compRec.Other__c;
            
            for(String picklistValue: compRec.Picklist_values_2__c.split('\n')) {
                picklistValue = picklistValue.trim();
                picklistValue = picklistValue.replaceAll('(\\s+)', ' ');
                pickVal.add(picklistValue);
            }
            
            pickValByName.put(name,pickVal);
        }
        //Create Parent rec
        
        //Create Child Rec
        List<Leader_Report_Note_Competency__c> CompetencyResponse = new List<Leader_Report_Note_Competency__c>();
        
        CompetencyResponse = [SELECT Id,Competency_Picklist_Name__c,Mandate__c ,Multi_select_values__c,Picklist_values_2__c,Picklist_value__c,
                              Text_value__c,Competency__c FROM Leader_Report_Note_Competency__c WHERE Mandate__c =:mandateId and Picklist_value__c != null];
        
        System.debug('CompetencyResponse'+CompetencyResponse);
        Map<String,Map<String,Integer>> counts = new Map<String,Map<String,Integer>>(); 
        if(!CompetencyResponse.isEmpty()){
            for(Leader_Report_Note_Competency__c response:CompetencyResponse){
                if(counts.containsKey(response.Competency_Picklist_Name__c)){
                    //get Inner PickList
                    Map<String,Integer> innerMap = counts.get(response.Competency_Picklist_Name__c);
                    System.debug('innerMap'+innerMap);
                    if(innerMap.containsKey(response.Picklist_value__c)){
                        innerMap.put(response.Picklist_value__c,innerMap.get(response.Picklist_value__c)+1);
                    }else{
                        innerMap.put(response.Picklist_value__c,1);
                    }
                    counts.put(response.Competency_Picklist_Name__c,innerMap);
                }else{
                    System.debug('response.Competency_Picklist_Name__c'+response.Competency_Picklist_Name__c);
                    counts.put(response.Competency_Picklist_Name__c,new Map<String ,Integer>{response.Picklist_value__c=>1});
                }
            }
        }
        System.debug('counts'+counts);
        createCompetencyParent(mandateId,pickValByName,counts);
        
    }
    public static void createCompetencyParent(String mandateId,Map<String,List<String>> pickValByName,Map<String,Map<String,Integer>> counts){
        
        List<Competency_Parent__c> allParentList 	= new List<Competency_Parent__c>();
        List<Competency_Child__c> allChildList 	= new List<Competency_Child__c>();
        
        for(String eachParent : pickValByName.keySet()){
            allParentList.add(new Competency_Parent__c(Name=eachParent,Mandate__c=mandateId));
        }
        
        insert allParentList;
        
        for(Competency_Parent__c compRec:allParentList){
            
            Map<String,Integer> innerMap = new Map<String,Integer>();
            
            if(counts.containsKey(compRec.Name)){
                innerMap = counts.get(compRec.Name);
            }
            
            for(String allPicklistValue :pickValByName.get(compRec.Name)){
                Integer noOfRec= 0;
                if(innerMap.containsKey(allPicklistValue)){
                    noOfRec = innerMap.get(allPicklistValue);
                }
                allChildList.add(new Competency_Child__c(Competency_Parent__c=compRec.Id,Name=allPicklistValue,Number_of_Records__c=noOfRec));
            }
                
        }
        
        insert allChildList;
        
    }
    public static void deletePreviousRecords(String mandateId){
        List<Competency_Parent__c> allParentList 	= [Select Id from Competency_Parent__c where Mandate__c=:mandateId];
        delete allParentList;
    }
}