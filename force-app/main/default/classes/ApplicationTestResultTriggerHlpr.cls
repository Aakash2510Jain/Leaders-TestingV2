public without sharing class ApplicationTestResultTriggerHlpr {
    
    public static void updateResultCategoriesWise(map<id, Application_Test_Result__c> newMap ){
        system.debug('newMap::'+newMap);
        // newly inserted associations response
        Map<String, List<Application_Test_Result__c>> appTestResultMapByCategory = new Map<String, List<Application_Test_Result__c>>();
        for(Application_Test_Result__c appTestResult : newMap.values()){
            if(appTestResultMapByCategory.ContainsKey(appTestResult.Category__c)){
                system.debug('Category'+appTestResult.Category__c);
                system.debug('contins Category'+appTestResultMapByCategory.ContainsKey(appTestResult.Category__c));
                List<Application_Test_Result__c> appTestResultListedToBeAdded = appTestResultMapByCategory.get(appTestResult.Category__c);
                appTestResultListedToBeAdded.add(appTestResult);
                appTestResultMapByCategory.put(appTestResult.Category__c, appTestResultListedToBeAdded);
                system.debug('appTestResultMapByCategory'+appTestResultMapByCategory);
            }
            else{
                system.debug('No category existed');
                appTestResultMapByCategory.put(appTestResult.Category__c, new List<Application_Test_Result__c>{appTestResult});
           		system.debug('appTestResultMapByCategory'+appTestResultMapByCategory);
            }
        }
        system.debug('appTestResultMapByCategory'+appTestResultMapByCategory);
        List<CategoryWise_Result__c> categoryResultListToBeUpdated = new List<CategoryWise_Result__c>();
        string ApplicationTestAssociationId ;
        for(string category: appTestResultMapByCategory.keyset()){
            system.debug('category'+category);
            CategoryWise_Result__c categoryResult = new CategoryWise_Result__c();
            categoryResult.Name = category;
            integer totalQuestion = 0;
            integer totalMarks = 0;
            system.debug('appTestResultMapByCategory.get(category)'+appTestResultMapByCategory.get(category));
            for(Application_Test_Result__c appTestResult : appTestResultMapByCategory.get(category)){
                totalQuestion++;
                ApplicationTestAssociationId = appTestResult.Application_Test_Association__c;
                system.debug('ApplicationTestAssociationId'+appTestResult.Application_Test_Association__c);
                system.debug('appTestResult.Marks__c'+appTestResult.Marks__c);
                totalMarks = totalMarks + integer.valueOf(appTestResult.Marks__c);
            }
            system.debug('ApplicationTestAssociationId'+ApplicationTestAssociationId);
            categoryResult.Application_Test_Association__c = ApplicationTestAssociationId;
            categoryResult.Total_Questions__c = totalQuestion;
            categoryResult.Total_Marks_Obtained__c = totalMarks;
            categoryResultListToBeUpdated.add(categoryResult);
            system.debug('categoryResultListToBeUpdated'+categoryResultListToBeUpdated);
        }
        system.debug('categoryResultListToBeUpdated'+categoryResultListToBeUpdated);
        List<CategoryWise_Result__c> finalsedList = [Select id,Name,Application_Test_Association__c,Total_Questions__c,Total_Marks_Obtained__c From CategoryWise_Result__c Where Application_Test_Association__c =: ApplicationTestAssociationId];
        List<CategoryWise_Result__c> finalisedResultCategoryListToBeUpdated = new List<CategoryWise_Result__c>();
       system.debug('finalsedList'+finalsedList.size());
        system.debug('finalsedList'+finalsedList);
        if(!finalsedList.isEmpty()){
            // for loop on finalsedList
            for(CategoryWise_Result__c categoryResult : categoryResultListToBeUpdated){
                for(CategoryWise_Result__c queriedList : finalsedList){
                    if(queriedList.Name == categoryResult.Name){
                        CategoryWise_Result__c categoryResultRec = new CategoryWise_Result__c();
                        categoryResultRec.Id = queriedList.id;
                        categoryResultRec.Name = categoryResult.Name;
                        categoryResultRec.Total_Questions__c = categoryResult.Total_Questions__c;
                        categoryResultRec.Total_Marks_Obtained__c = categoryResult.Total_Marks_Obtained__c;
                        categoryResultRec.Application_Test_Association__c = categoryResult.Application_Test_Association__c;
                        finalisedResultCategoryListToBeUpdated.add(categoryResultRec);
                    }
                }
            }
            system.debug('finalisedResultCategoryListToBeUpdated'+finalisedResultCategoryListToBeUpdated);
            upsert finalisedResultCategoryListToBeUpdated;
        }
        else{
            system.debug('categoryResultListToBeUpdated'+categoryResultListToBeUpdated);
            upsert categoryResultListToBeUpdated;
        }
    }
    
}