public class AssignmentCandidatesHelper {
    
    public static Map<Id,Id> mandateIdByContactId =  new Map<Id,Id>();
    public static Boolean RunOnce = false;
    public static Boolean RunOncebeforeupdate = false;
    //public static Integer triggerCount = 1;
    public static void generateSelfAssessment(List<Application__c> appList,Map<Id,Application__c> oldMap){
        for(Application__c apprec:appList){
            if(apprec.Self_Assesment_Updated__c == true && oldMap.get(apprec.Id).Self_Assesment_Updated__c != true){
                //updateSelfAssessmentCtrl.Generate_Self_Ass('a021k00000D8ShKAAV');
                CongaHelperToolLightning.myMethod(apprec.Self_Assesment_Link__c);
            }
        }
    }
    
    public static void updateCompanyOffLimit(List<Application__c> appList,Map<Id,Application__c> oldMap){
        
        set<String> contactIdToUpdated 						= new set<String>();
        Map<Id,Application__c> ApplicationIdByContactId 	= new Map<Id,Application__c>();
        Map<Id,Mandate__c> mandateMap						= new Map<Id,Mandate__c>();
        List<Contact> conToUpdated 							= new List<Contact>();
        if(!appList.isEmpty()){
            for(Application__c appRecord:appList){
                if(appRecord.Status_Summary_Line__c == Constants.CANDIDATE_ACCEPTED && oldMap.get(appRecord.Id).Status_Summary_Line__c != appRecord.Status_Summary_Line__c){
                    contactIdToUpdated.add(appRecord.Contact__c);
                    mandateIdByContactId.put(appRecord.Contact__c,appRecord.Mandate__c);
                    ApplicationIdByContactId.put(appRecord.Contact__c,appRecord);
                }
            }
        }
        mandateMap = new Map<ID, Mandate__c>([select Id,Name,Company__c from Mandate__c where Id IN:mandateIdByContactId.values()]);
        
        if(!contactIdToUpdated.isEmpty()){
            System.debug('!!!!!!'+ApplicationIdByContactId);
            for(String conId: contactIdToUpdated){
                Mandate__c manrec=mandateMap.get(mandateIdByContactId.get(conId));
                Application__c appRec= ApplicationIdByContactId.get(conId);
                System.debug('!!!!!!'+appRec);
                conToUpdated.add(new Contact(Id=conId,AccountId=manrec.Company__c,Title=manrec.Name));
            }
            if(!conToUpdated.isEmpty()){
                System.debug('@@@@@@@'+conToUpdated);
                update conToUpdated;
            }
        }
    }
    
    /*public static void updateAccountOffLimitDate(set<String> assignmentIdToUpdated){

List<Account> accToUpdated 	= new List<Account>();
List<Id> conCompanyIds 		= new List<Id>();
List<Contact> conToUpdated 	= new List<Contact>();

System.debug('assignmentIdToUpdated'+assignmentIdToUpdated);
System.debug('assignmentIdToUpdated'+canStartDateByMandate);
for(Mandate__c assignMentRec: [Select Id,Company__c,Candidate_start_date__c FROM Mandate__c where Id IN:assignmentIdToUpdated]){
System.debug('@@@@'+canStartDateByMandate.get(assignMentRec.Id));
if(canStartDateByMandate.containsKey(assignMentRec.Id))
accToUpdated.add(new Account(Id=assignMentRec.Company__c,Off_Limit_Period__c='12 Months',Candidate_Offer_Date__c=canStartDateByMandate.get(assignMentRec.Id),Off_Limit__c=true));

}

if(!accToUpdated.isEmpty()){
System.debug('@@@@'+accToUpdated);
update accToUpdated;
}



}

public static void updateAssignmentEndDate(List<Application__c> appList,Map<Id,Application__c> oldMap){

List<Mandate__c> manRecToBeUpdated = new List<Mandate__c>();

if(!appList.isEmpty()){
for(Application__c appRecord:appList){
if(appRecord.Candidate_Start_Date__c !=null && oldMap.get(appRecord.Id).Candidate_Start_Date__c != appRecord.Candidate_Start_Date__c){
//manRecToBeUpdated.add(new Mandate__c(Id=appRecord.Mandate__c,Candidate_start_date__c=appRecord.Candidate_Start_Date__c,Mandate_End_Date__c=System.today(),Final_Candidate__c=appRecord.Contact__c));
}
}
}
if(!manRecToBeUpdated.isEmpty()){
update manRecToBeUpdated;
}

}*/
    public static void updatesslFrenchValues(List<Application__c> appList){
        if(RunOnce == false){
            try{
                List<Application__c> appListToUpdate = new List<Application__c>();
                
                List<SSL_Values_Conversion__c> customSettingData = [select SSL_English__c,SSL_French__c	 from SSL_Values_Conversion__c];
                Map<String,String> SslValuesMap = new Map<String,String>() ;    
                
                for( SSL_Values_Conversion__c Ssl: customSettingData){
                    SslValuesMap.put(Ssl.SSL_English__c,Ssl.SSL_French__c);
                }
                system.debug('SslValuesMap'+SslValuesMap);
                system.debug('SslValuesMap'+SslValuesMap);
                for(Application__c apprec:appList){
                    System.debug((apprec.Status_Summary_Line__c));
                    System.debug(SslValuesMap.get(apprec.Status_Summary_Line__c));
                    appListToUpdate.add(new Application__c(Id = apprec.Id,Status_Summary_Line_French__c = SslValuesMap.get(apprec.Status_Summary_Line__c)));
                }
                RunOnce = true;
                system.debug('appListToUpdate'+appListToUpdate);
                update appListToUpdate;
            }catch(Exception e){
                system.debug('Error Message ::'+e.getMessage()+'@'+e.getLineNumber());   
            }    
        }
    }
    public static void checkDuplicateContactsOnAssignment(List<Application__c> appList,Boolean isInsert,Map<Id,Application__c> oldMap){
        Set<Id> mandateIds = new Set<Id>();
        for (Application__c candidate : appList){
            if (isInsert || (!isInsert && candidate.Contact__c != oldMap.get(candidate.Id).Contact__c)){
                mandateIds.add(candidate.Mandate__c);
            }		
        }
        List<String> contactsId = new List<String>();
        set<String> setIds = new set<String>();
        set<String> duplicateIds = new set<String>();
        for(Application__c app : appList){
            contactsId.add(app.Contact__c);
        }
        system.debug(':: mandateIds ::'+mandateIds);
        Map<Id, Set<Id>> candidatesMap = new Map<Id, Set<Id>>();
        if (!mandateIds.isEmpty()){
            for(Application__c app : [Select Id, Contact__c, Mandate__c from Application__c where Mandate__c in :mandateIds]){
                if (!candidatesMap.containsKey(app.Mandate__c)){
                    candidatesMap.put(app.Mandate__c, new Set<Id>{app.Contact__c});
                }else{
                    system.debug('candidatesMap in the else');
                    candidatesMap.get(app.Mandate__c).add(app.Contact__c);
                }  	                              	
            }
        }
        system.debug(':: candidatesMap ::'+candidatesMap+'keyset_Size'+candidatesMap.keySet().size()+'MapValues'+candidatesMap.values().size());
        for (Application__c candidate : appList){
            if (!candidatesMap.isEmpty() && candidatesMap.containsKey(candidate.Mandate__c)){
                Set<Id> contacts = candidatesMap.get(candidate.Mandate__c);
                system.debug('contacts'+contacts+'candidate.Contact__c'+candidate.Contact__c);
                if(candidate.Contact__c != null && contacts.contains(candidate.Contact__c  )){
                    system.debug('Here you get the Error at line  151');
                    candidate.addError('A contact cannot be attached to the assignment more than once');				
                }
            }
        }
        System.debug('duplicateIds'+duplicateIds);
        
    }
    
    public static void checkRemovalOfContactsFromAssignment(List<Application__c> appList,Map<Id,Application__c> oldMap){
        for (Application__c candidate : appList){
            if (( candidate.Contact__c != oldMap.get(candidate.Id).Contact__c) && candidate.Contact__c == null ){
                candidate.addError('Contact cannot be removed from Related Assignment');
            }		
        }
    }
    
    public static void AssigningDepartment(List<Application__c> appList,Boolean IsInsert){
        RunOncebeforeupdate = true;
        Map<String,List<ID>> departmentMemberByDept = new  Map<String,List<ID>>();
        Map<String,Integer> numberOffAppsPerDeptMember = new Map<String,Integer>();
        Map<Integer,String> numberOffAppsPerDeptMemberReverse = new Map<Integer,String>();
        List<String> AppStatus = new List<String>();
        
        if(IsInsert == true){
            AppStatus.add('On Boarded');
            for(Application__c app : appList){
                app.Status_of_App__c = 'On Boarded';
            }    
        }else{
            for(Application__c app : appList){
                AppStatus.add(app.Status_of_App__c );
            }
        }
        system.debug('AppStatus'+AppStatus);
        List<Application__C> appslist = [SELECT Department_Member__c,Status_of_App__c FROM Application__c WHERE Department_Member__c != null and Status_of_App__c in:AppStatus];
        List<Department__c> deplist = [SELECT Application_Status__c,Id,(SELECT ID, User__c from Department_Members__r) FROM Department__c where Application_Status__c IN:AppStatus];
        
        //Creating a map of Dept and their Users
        for(Department__c dept : deplist){
            List<ID> departmentMembers = new List<ID> ();
            for(Department_Member__c depMem:dept.Department_Members__r)
            {
                departmentMembers.add(depMem.Id);
            }
            departmentMemberByDept.put(dept.Application_Status__c,departmentMembers);
        }
        system.debug('departmentMemberByDept'+departmentMemberByDept);
        
        // Creating a map for dept members with application -- for Load Balancing
        
        for(Application__C app: appslist){
            if(numberOffAppsPerDeptMember.containsKey(app.Department_Member__c)){
                numberOffAppsPerDeptMember.put(app.Department_Member__c,numberOffAppsPerDeptMember.get(app.Department_Member__c)+1);
            }else{
                numberOffAppsPerDeptMember.put(app.Department_Member__c,1);
            }
        }
        List<ID> MissingMembers = new List<ID>();
        List<ID> TotalMissingMembers = new List<ID>();
        for(String str : AppStatus){
            MissingMembers = departmentMemberByDept.get(str);
        }
        TotalMissingMembers.addAll(MissingMembers);
        
        for(Id member:TotalMissingMembers){
            if(!numberOffAppsPerDeptMember.containsKey(member)){
                numberOffAppsPerDeptMember.put(member,0);
            }
        }
        // List<ID> totalMissingMembers = departmentMemberByDept.get();
        
        system.debug('numberOffAppsPerDeptMember'+numberOffAppsPerDeptMember);
        
        
        List<Id> sortedDeptMembers = new List<Id>();
        
        for(application__c app : appList){
            for(String str : AppStatus){
                List<Id> deptmember = departmentMemberByDept.get(str);
                system.debug('deptmember'+deptmember+'deptmember.size()'+deptmember.size());
                if(deptmember.size() == 1){
                    app.Department_Member__c =  deptmember[0];
                }
                if(deptmember.size() == 2){
                    for(integer i = 1 ; i < deptmember.size();i++){
                        system.debug('sortedDeptMembers'+deptmember[i]);
                        system.debug('deptmember[i]'+deptmember[i]+'count'+numberOffAppsPerDeptMember.get(deptmember[i]));
                        system.debug('deptmember[i-1]'+deptmember[i-1]+'count'+numberOffAppsPerDeptMember.get(deptmember[i-1]));
                        if(numberOffAppsPerDeptMember.get(deptmember[i-1]) > numberOffAppsPerDeptMember.get(deptmember[i])){
                            sortedDeptMembers.add(deptmember[i]);
                            system.debug('deptmember[i]'+deptmember[i]+'count'+numberOffAppsPerDeptMember.get(deptmember[i]));
                        }else{
                            sortedDeptMembers.add(deptmember[i-1]);
                            system.debug('deptmember[i-1]'+deptmember[i-1]+'count'+numberOffAppsPerDeptMember.get(deptmember[i-1]));
                        }
                    }
                    system.debug('sortedDeptMembers'+sortedDeptMembers);    
                    app.Department_Member__c =  sortedDeptMembers[0];
                }
                else{
                    for(integer i = 1 ; i < deptmember.size();i++){
                        system.debug('sortedDeptMembers'+deptmember[i]);
                        system.debug('deptmember[i]'+deptmember[i]+'count'+numberOffAppsPerDeptMember.get(deptmember[i]));
                        system.debug('deptmember[i-1]'+deptmember[i-1]+'count'+numberOffAppsPerDeptMember.get(deptmember[i-1]));
                        if(numberOffAppsPerDeptMember.get(deptmember[i-1]) > numberOffAppsPerDeptMember.get(deptmember[i])){
                            sortedDeptMembers.add(deptmember[i]);
                            system.debug('deptmember[i]'+deptmember[i]+'count'+numberOffAppsPerDeptMember.get(deptmember[i]));
                        }else{
                            sortedDeptMembers.add(deptmember[i-1]);
                            system.debug('deptmember[i-1]'+deptmember[i-1]+'count'+numberOffAppsPerDeptMember.get(deptmember[i-1]));
                        }
                    }
                    system.debug('sortedDeptMembers'+sortedDeptMembers);    
                    app.Department_Member__c =  sortedDeptMembers[sortedDeptMembers.size() - 1];
                }
            }
        }
    }
    // application test association will be created as application status = On Boarded
    public static void createApplicationTestAssociation(map<id, Application__c> newApplicationMap, map<id, Application__c> oldApplicationMap){
        system.debug('newApplicationMap'+newApplicationMap);
        system.debug('oldApplicationMap'+oldApplicationMap);
        List<Application_Test_Association__c> listToBeInserted = new List<Application_Test_Association__c>();
        for(Application__c app : newApplicationMap.values()){
            if( app.Status_of_App__c == 'On Boarded'){ 
                system.debug('app.Status_of_App__c'+app.Status_of_App__c);
                //system.debug('oldApplicationMap.get(app.Id).Status_of_App__c'+oldApplicationMap.get(app.Id).Status_of_App__c);
                System.debug('app.Name'+app.Mandate__c);
                List<Assignment_Test_Association__c> assisgnmentTestAssociationList = [SELECT Id FROM Assignment_Test_Association__c WHERE Assignment__c =: app.Mandate__c];
                System.debug('assisgnmentTestAssociationList'+assisgnmentTestAssociationList);
                for(Assignment_Test_Association__c assisgnmentTestAssociation : assisgnmentTestAssociationList){
                    Application_Test_Association__c appTestAssociation = new Application_Test_Association__c();
                    appTestAssociation.Assignment_Test_Association__c = assisgnmentTestAssociation.id;
                    appTestAssociation.Applicant__c = app.Id;
                    listToBeInserted.add(appTestAssociation);
                }
            }
        }
        System.debug('listToBeInserted'+listToBeInserted);
        insert listToBeInserted;
    }
    public static void sendTestsToApplicant(map<id, Application__c> newApplicationMap, map<id, Application__c> oldApplicationMap){
        system.debug('newApplicationMap'+newApplicationMap);
        system.debug('oldApplicationMap'+oldApplicationMap);
        List<Question_Module__c> questionModuleList =  [SELECT Application_Status__c,Assignment_Name__c,Company_Name__c,Name,Test_Master__c FROM Question_Module__c];
        map<String, Question_Module__c> questionMapByApplicationStatus = new map<String, Question_Module__c>();
        for(Question_Module__c questionModule : questionModuleList){
            questionMapByApplicationStatus.put(questionModule.Application_Status__c, questionModule);
        }
        List<String> testMasterLists = new  List<String>();
        string applicantId ;
        for(Application__c app : newApplicationMap.values()){
            if(app.Status_of_App__c != oldApplicationMap.get(app.Id).Status_of_App__c && app.Status_of_App__c == 'Under Assessment'){ 
                system.debug('app.Status_of_App__c'+app.Status_of_App__c);
                system.debug('oldApplicationMap.get(app.Id).Status_of_App__c'+oldApplicationMap.get(app.Id).Status_of_App__c);
                Question_Module__c questionModuleRec = questionMapByApplicationStatus.get(app.Status_of_App__c);
                String allTestMaster = questionModuleRec.Test_Master__c;
                testMasterLists = allTestMaster.split(',');
                system.debug('testMasterLists::'+testMasterLists);
                applicantId = app.Id;
            }
        }
        List<Application_Test_Association__c> applicationTestAssociationList = [SELECT Applicant__c,Assignment_Test_Association__c,Id,Name,Test_Master_Name__c FROM Application_Test_Association__c WHERE Applicant__c=: applicantId];
        Map<String, id> applicationTestAssociationMapByTestMasterName = new Map<String, id>();
        for(Application_Test_Association__c appTestAssociationRec : applicationTestAssociationList){
            applicationTestAssociationMapByTestMasterName.put(appTestAssociationRec.Test_Master_Name__c, appTestAssociationRec.Id);
        }
        system.debug('applicationTestAssociationList::'+applicationTestAssociationList);
        List<string> studentTestAssociationIdList = new List<string>();
        map<String, string> mapOfApplicatioTestAssociationById = new map<String, string>();//key:Id value:Name
        for(Application_Test_Association__c appTestAssociationRec : applicationTestAssociationList){
            for(String testMaster : testMasterLists){
                if(appTestAssociationRec.Test_Master_Name__c == testMaster){
                    system.debug('appTestAssociationRec.Test_Master_Name__c::'+appTestAssociationRec.Test_Master_Name__c);
                    system.debug('testMaster'+testMaster);
                    if(applicationTestAssociationMapByTestMasterName.containsKey(appTestAssociationRec.Test_Master_Name__c)){
                        String studentTestAssociationId = applicationTestAssociationMapByTestMasterName.get(appTestAssociationRec.Test_Master_Name__c);
                        system.debug('studentTestAssociationId::'+studentTestAssociationId);
                        system.debug('applicantId::'+applicantId);
                        studentTestAssociationIdList.add(studentTestAssociationId);
                        mapOfApplicatioTestAssociationById.put(studentTestAssociationId,testMaster);
                    }
                }
            }
            
        }
        system.debug('studentTestAssociationIdList::'+studentTestAssociationIdList);
        system.debug('mapOfApplicatioTestAssociationById::'+mapOfApplicatioTestAssociationById);
        emailNotification.sendEmail(applicantId, mapOfApplicatioTestAssociationById);
    }
}