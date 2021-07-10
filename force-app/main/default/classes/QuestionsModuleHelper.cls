public class QuestionsModuleHelper {
    public class QuesWrap{
        @auraEnabled
        public Application_Test_Result__c studentResult ;
        @auraEnabled
        public List<String> picklistValues ;
        @auraEnabled
        public String answerType ;
        
        public QuesWrap(Application_Test_Result__c studentResult,List<String> picklistValues,String answerType){
            this.studentResult = studentResult;
            this.picklistValues = picklistValues;
            this.answerType = answerType;
        }
    }
    @auraEnabled
    public static List<QuesWrap> getAllTestQuestions(String applicationTestAssociationId){
        system.debug('applicationTestAssociationId::'+applicationTestAssociationId);
        List<QuesWrap> questionWrapList = new List<QuesWrap>();
        Map<String, Assessment_Question__c> assessmentQuestionMapByQues = new Map<String, Assessment_Question__c>(); 
        String assignmentTestAssociationId = [Select Assignment_Test_Association__c From Application_Test_Association__c Where Id = :applicationTestAssociationId].Assignment_Test_Association__c;
        String testMasterId = [Select Test_Master__c From Assignment_Test_Association__c Where Id =:assignmentTestAssociationId].Test_Master__c;
        List<Assessment_Question__c> assessmentQuestionList = [SELECT Answer_Values__c,Answer__c,Category__c,Id,Name,Question__c,Test_Master__c,Type__c FROM Assessment_Question__c Where Test_Master__c =:testMasterId];
        for(Assessment_Question__c assessmentQuestion : assessmentQuestionList){
            assessmentQuestionMapByQues.put(assessmentQuestion.Question__c, assessmentQuestion);
        }
        List<Application_Test_Result__c> appTestListToBeUpdated = [Select id,Answer__c,Question__c,Application_Test_Association__c From Application_Test_Result__c Where Application_Test_Association__c =:applicationTestAssociationId];
        if(!appTestListToBeUpdated.isEmpty()){
            system.debug('if');
            system.debug('appTestListToBeUpdated::'+appTestListToBeUpdated);
            for( Application_Test_Result__c assessmentTestResultRec : appTestListToBeUpdated){
                string AnswerType = assessmentQuestionMapByQues.get(assessmentTestResultRec.Question__c).Type__c;
                List<String> answerOptionList = new List<String>();
                if(AnswerType == 'Picklist'){
                    String answerOption = assessmentQuestionMapByQues.get(assessmentTestResultRec.Question__c).Answer_Values__c;
                    answerOptionList = answerOption.split(',');
                    system.debug('answerOptionList==>'+answerOptionList);
                }
                else if(AnswerType == 'Text' || AnswerType == '' || AnswerType == null ){
                    answerOptionList = new List<String> {'A,B,C,D'};
                        }
                questionWrapList.add(new QuesWrap(assessmentTestResultRec,answerOptionList,assessmentQuestionMapByQues.get(assessmentTestResultRec.Question__c).Type__c));
            }
        }
        else{
            for(Assessment_Question__c assessmentQues : assessmentQuestionMapByQues.values()){
                Application_Test_Result__c appTestResult = new Application_Test_Result__c();
                appTestResult.Question__c = assessmentQues.Question__c;
                appTestResult.Answer__c = '';
                appTestResult.Category__c = assessmentQues.Category__c;
                appTestResult.Application_Test_Association__c = applicationTestAssociationId;
                List<String> answerOptionList = new List<String>();
                if(assessmentQues.Type__c == 'Picklist'){
                    String answerOption = assessmentQues.Answer_Values__c;
                    answerOptionList = answerOption.split(',');
                    system.debug('answerOptionList==>'+answerOptionList);
                }
                else if(assessmentQues.Type__c == 'Text' || assessmentQues.Type__c == '' || assessmentQues.Type__c == null )
                {
                    answerOptionList = new List<String> {'A,B,C,D'};
                        }
                questionWrapList.add(new QuesWrap(appTestResult,answerOptionList,assessmentQuestionMapByQues.get(assessmentQues.Question__c).Type__c));
            }
        }
        system.debug('questionWrapList::'+questionWrapList);
        return questionWrapList ;
    }
    @auraEnabled
    public static List<Application_Test_Result__c> insertResponse(String responseListToBeInserted){
        try{
            List<Application_Test_Result__c> finallistToBeUpdated = new List<Application_Test_Result__c>();
            System.debug('responseListToBeInserted::'+responseListToBeInserted);
            string appTestAssociationId;
            List<QuesWrap> listToSave = (List<QuesWrap>)JSON.deserialize(responseListToBeInserted, List<QuesWrap>.class);
            List<Application_Test_Result__c> listToBeUpdated = new List<Application_Test_Result__c>();
            for(QuesWrap QuesWrapinstance : listToSave){
                listToBeUpdated.add(QuesWrapinstance.studentResult);
                appTestAssociationId = QuesWrapinstance.studentResult.Application_Test_Association__c;
            }
            
            System.debug('listToBeUpdated'+listToBeUpdated);
            map<string, Application_Test_Result__c> appTestResultMapBuQuestion = new map<string, Application_Test_Result__c>();
            List<Application_Test_Result__c> applicationTestResultList = [SELECT Id,Answer__c,Application_Test_Association__c,Category__c,Marks__c,Question__c FROM Application_Test_Result__c WHERE Application_Test_Association__c = :appTestAssociationId];
            for(Application_Test_Result__c atr : applicationTestResultList){
                appTestResultMapBuQuestion.put(atr.Question__c, atr);
            }
            
            Map<string, string> mapOfAssessmentQuestionByQues = new Map<string, string>();// key: question, value: answer
            String assignmentTestAssociationId = [Select Assignment_Test_Association__c From Application_Test_Association__c Where Id = :appTestAssociationId].Assignment_Test_Association__c;
            String testMasterId = [Select Test_Master__c From Assignment_Test_Association__c Where Id =:assignmentTestAssociationId].Test_Master__c;
            List<Assessment_Question__c> assessmentQuestionList = [SELECT Answer_Values__c,Answer__c,Category__c,Id,Name,Question__c,Test_Master__c,Type__c FROM Assessment_Question__c Where Test_Master__c =:testMasterId];
            for(Assessment_Question__c assessmentQuestion : assessmentQuestionList){
                mapOfAssessmentQuestionByQues.put(assessmentQuestion.Question__c, assessmentQuestion.Answer__c);
            }
            /*if(!applicationTestResultList.isEmpty()){
                system.debug('in if');
                for(Application_Test_Result__c appTest :  listToBeUpdated){
                    if(mapOfAssessmentQuestionByQues.containsKey(appTest.Question__c) ){
                        Application_Test_Result__c appTestResult = new Application_Test_Result__c();
                        if(appTest.Answer__c == mapOfAssessmentQuestionByQues.get(appTest.Question__c)){
                            appTestResult.Id = appTestResultMapBuQuestion.get(appTest.Question__c).id;
                            appTestResult.Answer__c = appTest.Answer__c;
                            appTestResult.Marks__c = 1;
                        }
                        else{
                            appTestResult.Id = appTestResultMapBuQuestion.get(appTest.Question__c).id;
                            appTestResult.Marks__c = 0;
                        }
                        finallistToBeUpdated.add(appTestResult);
                    }
                }
            //}*/
            //else{
                system.debug('in else');
                for(Application_Test_Result__c appTest :  listToBeUpdated){
                    if(mapOfAssessmentQuestionByQues.containsKey(appTest.Question__c) ){
                        if(appTest.Answer__c == mapOfAssessmentQuestionByQues.get(appTest.Question__c) && appTest.Answer__c != null){
                            appTest.Marks__c = 1;
                        }
                        else{
                            appTest.Marks__c = 0;
                        }
                        finallistToBeUpdated.add(appTest);
                    }
                }
            //}
            upsert finallistToBeUpdated;
            return finallistToBeUpdated;
        }
        catch(exception ex){
            List<Application_Test_Result__c> finallistToBeUpdated = new List<Application_Test_Result__c>();
            system.debug('Erro==>'+ex.getMessage()+'Error==>'+ex.getLineNumber());
            return finallistToBeUpdated;
        }
        /* system.debug('reached line number 103+finallistToBeUpdated'+finallistToBeUpdated);
list<Application_Test_Result__c> resultToBeUpdated = new list<Application_Test_Result__c>();
list<Application_Test_Result__c> resultToBeInserted = new list<Application_Test_Result__c>();

if(finallistToBeUpdated.size() > 0){
for(Application_Test_Result__c atr : finallistToBeUpdated ){
system.debug('id of the object'+atr.Id);
if(atr.Id != null ){
resultToBeUpdated.add(atr);
}else{
resultToBeInserted.add(atr);
}
} 
}
system.debug('reached line number 116resultToBeInserted'+resultToBeUpdated);
system.debug('reached line number 117resultToBeInserted'+resultToBeInserted);
if(resultToBeUpdated.size() > 0){
update resultToBeUpdated;
}
else if(resultToBeInserted.size() > 0){
insert resultToBeInserted;
}

if(resultToBeUpdated.size() > 0){
return resultToBeUpdated;   
}else{
return resultToBeInserted;   
}
*/
    }
    
    
    /* public static void updateMarks(string appTestAssociationId){
List<Application_Test_Result__c> applicationTestResultList = [SELECT Id, Answer__c,Application_Test_Association__c,Marks__c,Question__c FROM Application_Test_Result__c Where Application_Test_Association__c =: appTestAssociationId];
Map<string, string> mapOfAssessmentQuestionByQues = new Map<string, string>();// key: question, value: answer
String assignmentTestAssociationId = [Select Assignment_Test_Association__c From Application_Test_Association__c Where Id = :appTestAssociationId].Assignment_Test_Association__c;
String testMasterId = [Select Test_Master__c From Assignment_Test_Association__c Where Id =:assignmentTestAssociationId].Test_Master__c;
List<Assessment_Question__c> assessmentQuestionList = [SELECT Answer_Values__c,Answer__c,Category__c,Id,Name,Question__c,Test_Master__c,Type__c FROM Assessment_Question__c Where Test_Master__c =:testMasterId];
for(Assessment_Question__c assessmentQuestion : assessmentQuestionList){
mapOfAssessmentQuestionByQues.put(assessmentQuestion.Question__c, assessmentQuestion.Answer__c);
}
List<Application_Test_Result__c> appTestResultListToBeUpdated = new List<Application_Test_Result__c>();
for(Application_Test_Result__c appTestResult : applicationTestResultList){
if(mapOfAssessmentQuestionByQues.containsKey(appTestResult.Question__c)){
if(appTestResult.Answer__c == mapOfAssessmentQuestionByQues.get(appTestResult.Question__c )){
appTestResult.Marks__c = 1;
}
else if((appTestResult.Answer__c != mapOfAssessmentQuestionByQues.get(appTestResult.Question__c)) ) {
appTestResult.Marks__c = 0;
}
appTestResultListToBeUpdated.add(appTestResult);
}
}
upsert appTestResultListToBeUpdated;
// upsert finallistToBeUpdated;

}*/
}