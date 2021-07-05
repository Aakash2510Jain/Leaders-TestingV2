public class OnePagerHelper {
    
    @AuraEnabled 
    public static List<List<Application__C>> One_Pager_Main_Data(String conRecId){
        List<Application__C> AppListWithOP = new  List<Application__C>();
        List<Application__C> AppListWithSA = new  List<Application__C>();
        List<Application__C> AppListforMainPage = new  List<Application__C>();
        List<Application__C> App_List_for_Update =  [SELECT Mandate__r.Assignment_Status__c ,Self_Assesment_Status__c,Mandate__r.Company_Name_French__C,Mandate__r.Company__r.Name, Has_One_Pager__c,Id,Current_Company_EN__c ,CompanyId__c ,Created_Date_Formula__c,Language__c,Mandate__c,Mandate__r.Name,Mandate__r.Language__c ,Status_Summary_Line__c  FROM Application__c WHERE Contact__c =:conRecId AND Mandate__r.Assignment_Status__c !='Completed' ORDER BY CreatedDate DESC LIMIT 10];
        List<Application__C> App_List_for_view =  [SELECT Mandate__r.Assignment_Status__c ,Self_Assesment_Status__c,Mandate__r.Company_Name_French__C,Mandate__r.Company__r.Name, Has_One_Pager__c,Id,Current_Company_EN__c ,CompanyId__c ,Created_Date_Formula__c,Language__c,Mandate__c,Mandate__r.Name,Mandate__r.Language__c ,Status_Summary_Line__c  FROM Application__c WHERE Contact__c =:conRecId ORDER BY CreatedDate DESC LIMIT 10];
        
        for(Application__C app : App_List_for_view){
            if(app.Has_One_Pager__c == True){
                AppListWithOP.add(app);
            }
        }
        for(Application__C app : App_List_for_view){
            if(app.Self_Assesment_Status__c =='Template Generated'){
                AppListWithSA.add(app);
            }
        }
        List<List<Application__C>> ListOfData = new List<List<Application__C>>();
        ListOfData.add(App_List_for_Update);
        ListOfData.add(AppListWithOP);
        ListOfData.add(AppListWithSA);
        return ListOfData;
    }
    @AuraEnabled
    public static String getAttId(String canId){
        try{
            String attId;
            Attachment[] att = [SELECT Id FROM Attachment WHERE ParentId = :canId AND Name LIKE '%One Pager%' ORDER BY LastModifiedDate DESC LIMIT 1];
            if(att.size() > 0)
            {
                return att[0].Id;  
            }
            else{
                Id condid =  [SELECT Contact_ID__c FROM Application__c WHERE Id =:canId].Contact_ID__c;
                attId =  [SELECT Id FROM Attachment WHERE ParentId = :condid AND Name LIKE '%One Pager%' ORDER BY LastModifiedDate DESC LIMIT 1].Id;
                return attId;
            }
        }catch(QueryException e){
            return null;
        }
    }
    
    @AuraEnabled 
    public static List<One_Pager__c> One_Pager_Con_Values(String mandateRecId){
        List<One_Pager__c> One_Pager_List =  [select Id,English__c,French__c from One_Pager__c where Mandate__c =: mandateRecId ];
        List<One_Pager_Values__c> customSettingData = [select Id,name,French__c from One_Pager_Values__c];
        if(One_Pager_List.size() > 0 ){
            return  One_Pager_List;
        }else{
            for(One_Pager_Values__c sa :customSettingData){
                One_Pager_List.add(new One_Pager__c(English__c = sa.Name,French__c = sa.French__c,Mandate__c = mandateRecId));
            }
            return One_Pager_List;   
        }   
    }
    
    @AuraEnabled 
    public static List<Boolean> One_Pager_Boolean_Value(String mandateRecId){
        List<One_Pager__c> One_Pager_List =  [select English__c,French__c from One_Pager__c where Mandate__c =: mandateRecId ];
        List<One_Pager_Values__c> customSettingData = [select name,French__c from One_Pager_Values__c];
        List<Boolean> BooleanValues = new  List<Boolean>();
        Boolean is_English;
        Boolean Is_Onepager;
        String Lang = [SELECT Language__c FROM Mandate__c where id=:mandateRecId LIMIT 1].Language__c;
        if(Lang == 'English'){
            is_English = true;
        }else{
            is_English = false;
        }
        if(One_Pager_List.size() > 0 ){
            Is_Onepager =   false;
        }else{
            Is_Onepager = true;   
        }   
        BooleanValues.add(is_English);
        BooleanValues.add(Is_Onepager);
        
        return BooleanValues;
    }
    @AuraEnabled 
    public static String Create_One_Pager_Rec(List<One_Pager__c> One_Pager_List,List<String> deleteList){
        List<One_Pager__c> listToBeUpdated = new List<One_Pager__c>();
        List<One_Pager__c> listToBeInserted = new List<One_Pager__c>();
        if(!deleteList.isEmpty()){
            Database.delete(deleteList);
        }
        for(One_Pager__c ag : One_Pager_List ){
            if(ag.Id != null){
                listToBeUpdated.add(ag);
            }else{
                listToBeInserted.add(ag);
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
    //--------------------------Methods For one pager in DisplaycvComp----------------------------------------
    
    @future(callout=true)
    public static void Generate_One_Pager(String appid)
    {
        try{
            system.debug('appid'+appid);
            Application__c app = [select One_Pager_Link__c ,One_Pager_Link_Fr__c ,mandate__r.Language__c from application__c where id =:appid];
            if(app.mandate__r.Language__c.toLowerCase() == 'english')
            {  
                string attachmentId = CongaHelperToolLightning.generateReport(app.One_Pager_Link__c,'One Pager',null,null,null);       
                system.debug('attachmentId '+attachmentId);
            }   
            else
            {
                string attachmentId = CongaHelperToolLightning.generateReport(app.One_Pager_Link_Fr__c,'One Pager',null,null,null);
                system.debug('attachmentId '+attachmentId);
            } 
        }
        catch(Exception e){
            System.debug('@@@@@'+e.getLineNumber()+'@@@'+e.getMessage());
        }
    }
    @AuraEnabled
    public static String viewAttachment(String parentId,String type)
    {
        try{
            System.debug('parentId::: ' + parentId);
            System.debug('type::: ' + type);
            List<Attachment> attRecList;
            if(parentId != null && type != null){
                if(type == 'View Self Assessment'){
                    attRecList = [SELECT Id,Name,Body,ParentId FROM Attachment WHERE ParentID =: parentId AND Name LIKE '%Self Assesment%' ORDER BY LastModifiedDate DESC LIMIT 1];
                }
            }
            System.debug('attRec::: ' + attRecList.size());
            return attRecList[0].Id;
        }catch(Exception e){
            System.debug('@@@@@'+e.getLineNumber()+'@@@'+e.getMessage());
            return null;
        }
    }
    @AuraEnabled
    public static string changeLanguage(String AppId){
        try{
            System.debug('conId==>'+AppId);
            
            Application__c app =[select id,Mandate__r.Language__c from Application__c where id=:AppId];
            String language = app.Mandate__r.Language__c;
            System.debug('con==>'+app);
            if(app!=null){
                return language;
            }
        }catch(Exception e){
            System.debug('Error==>'+e.getMessage()+'Line Number==>'+e.getLineNumber());
        }
        return null;
    }
    
    @AuraEnabled
    public static List<Radar_Rating_Response__c> RadarResp(String mandateRecId,String ConRecID,String AppRecId){
        try{
            System.debug('conId==>'+mandateRecId);
            System.debug('appId==>'+ConRecID);
            System.debug('ManID==>'+AppRecId);
            String Language = [SELECT Mandate__r.Language__c FROM Application__c where id =:AppRecId].Mandate__r.Language__c;
            List<Radar_Rating_Response__c> RadarNewList = new List<Radar_Rating_Response__c>();
            List<Radar_Rating_Response__c> RadarResList = [SELECT Id,Radar_Rating__c,Radar_Ques__c,To_Be_excluded__c,Radar_Rating_Lookup__c FROM Radar_Rating_Response__c WHERE Related_Assignment__c =:AppRecId];
            List<Radar_Rating__c> RadarList = [select Id,Radar_Rating_Fr_Ques__c,Radar_Rating_Ques__c,Assignment__c from Radar_Rating__c  where Assignment__c =: mandateRecId ];
            
            if(RadarResList.size() > 0 && RadarResList.size() == RadarList.size()){
                system.debug('We are here in greater Response');
                return RadarResList;
            }
            else if(RadarResList.size() > 0 && RadarResList.size() != RadarList.size()){
                List<String> allExistingRadar = new List<String>();
                List<String> allNewRadarResponse = new List<String>();
                for(Radar_Rating_Response__c respo:RadarResList){
                    allExistingRadar.add(respo.Radar_Rating_Lookup__c );
                }
                for(Radar_Rating__c Ques:RadarList){
                    if(!allExistingRadar.contains(Ques.Id)){
                        allNewRadarResponse.add(Ques.Id);
                    }
                }
                List<Radar_Rating_Response__c> RadarResponseList = [SELECT Radar_Ques__c,Radar_Rating_Lookup__c,Radar_Rating__c,Related_Assignment__c FROM Radar_Rating_Response__c where Radar_Rating_Lookup__c IN:allExistingRadar and Related_Assignment__c  =:AppRecId];
                
                for(Radar_Rating_Response__c opr: RadarResponseList){
                    RadarNewList.add(opr);
                }
                
                if(!allNewRadarResponse.isEmpty()){
                    
                    List<Radar_Rating__c> NewradarList = [SELECT Id,Radar_Rating_Fr_Ques__c,Radar_Rating_Ques__c  from Radar_Rating__c where Id IN:allNewRadarResponse ];                        
                    for(Radar_Rating__c sa : NewradarList){
                        Radar_Rating_Response__c sar = new Radar_Rating_Response__c();
                        sar.Related_Assignment__c  = AppRecId;
                        sar.Radar_Rating__c  = 0;
                        sar.Radar_Rating_Lookup__c  = sa.Id;
                        if(Language == 'French'){
                            sar.Radar_Ques__c   = sa.Radar_Rating_Fr_Ques__c;
                        }else{
                            sar.Radar_Ques__c  = sa.Radar_Rating_Ques__c;
                        }
                        RadarNewList.add(sar);
                    }
                }
                system.debug('RadarNewList'+RadarNewList);
                return RadarNewList;
            } 
            else{
                for(Radar_Rating__c sa : RadarList)
                {
                    system.debug('We are here in smaller Response');
                    Radar_Rating_Response__c sar = new Radar_Rating_Response__c();
                    if(language == 'French')
                    {
                        sar.Radar_Ques__c	 = sa.Radar_Rating_Fr_Ques__c;    
                    }
                    else
                    {
                        sar.Radar_Ques__c = sa.Radar_Rating_Ques__c;
                    }
                    sar.Related_Assignment__c = AppRecId;
                    sar.Radar_Rating__c = 0;
                    sar.Radar_Rating_Lookup__c  = sa.Id;
                    
                    RadarNewList.add(sar);
                }
                system.debug('RadarNewList'+RadarNewList);
                return RadarNewList;
            }
        }
        catch(Exception e)
        {
            System.debug('Error==>'+e.getMessage()+'Line Number==>'+e.getLineNumber());
            return null;
        }
    }
    
    @AuraEnabled
    public static List<List<Sobject>> onePagerResp(String mandateRecId,String ConRecID,String AppRecId){
        try{
            System.debug('conId==>'+mandateRecId);
            System.debug('appId==>'+ConRecID);
            System.debug('ManID==>'+AppRecId);
            
            String language = updateSelfAssessmentCtrl.changeLanguage(AppRecId);
            List<contact> Conrecdata = [SELECT Name,Additional_Comments_for_Compensation__c ,Stock_Equity__c ,Allowance__c,Company_Name_French__c,Base_Salary__c,Bonus__c,Other__c FROM Contact where id=:ConRecID];
            
            application__c man = [select Mandate__c from application__c where id =:AppRecId];
            String Man_id = man.Mandate__c;
            system.debug('man.id'+Man_id);
            
            List<One_Pager_Response__c> onePagerResList = new List<One_Pager_Response__c>();
            List<One_Pager_Response__c> onePagerNewList = new List<One_Pager_Response__c>();
            List<Application__C> Is_One_Pager_Available = new List<Application__C>();
            Is_One_Pager_Available = [SELECT Include_In_One_Pager__c FROM Application__c where id =:AppRecId];
            
            List<One_Pager__c> OnePagerList = [SELECT Id,Name,French__c,English__c FROM One_Pager__c WHERE Mandate__c =:Man_id];
            
            onePagerResList = [SELECT Id,Response__c,Response_Fr__c,Question_Fr__c,One_Pager__c,Question_Eng__c,Exclude_From_Radar_Graph__c ,Application__r.Include_In_One_Pager__c,Numerical_Values__c  FROM One_Pager_Response__c WHERE Application__c =:AppRecId];
            
            List<List<Sobject>> All_Data =new List<List<Sobject>>();
            
            All_Data.add(Conrecdata);
            if(onePagerResList.size() > 0 && onePagerResList.size() == OnePagerList.size()){
                system.debug('We are here in greater Response');
                All_Data.add(onePagerResList);
                return All_Data;
            }
            else IF(onePagerResList.size() > 0 && onePagerResList.size() != OnePagerList.size()){
                
                List<String> allExistingOnePager = new List<String>();
                List<String> allNewOnePager = new List<String>();
                for(One_Pager_Response__c respo:onePagerResList){
                    allExistingOnePager.add(respo.One_Pager__c);
                }
                for(One_Pager__c onePagerQues:OnePagerList){
                    if(!allExistingOnePager.contains(onePagerQues.Id)){
                        allNewOnePager.add(onePagerQues.Id);
                    }
                }
                List<One_Pager_Response__c> onePagerResponseList = [SELECT Application__c,Assignment__c,Response__c,Response_Fr__c,One_Pager__c,Question_Fr__c,Question_Eng__c from One_Pager_Response__c where One_Pager__c IN:allExistingOnePager and Application__c =:AppRecId];
                
                for(One_Pager_Response__c opr: onePagerResponseList){
                    onePagerNewList.add(opr);
                }
                
                if(!allNewOnePager.isEmpty()){
                    
                    List<One_Pager__c> NewOnePagerList = [SELECT Id,French__c,English__c from One_Pager__c where Id IN:allNewOnePager ];                        
                    for(One_Pager__c sa : NewOnePagerList){
                        One_Pager_Response__c sar = new One_Pager_Response__c();
                        sar.Application__c = AppRecId;
                        sar.Assignment__c = Man_id;
                        sar.Response__c = '';
                        sar.Response_Fr__c ='';
                        sar.One_Pager__c  = sa.Id;
                        // sar.Exclude_From_Radar_Graph__c = false;
                        sar.Question_Fr__c = sa.French__c;
                        sar.Question_Eng__c = sa.English__c;
                        onePagerNewList.add(sar);
                        //All_Data.Add(onePagerNewList);
                        //All_Data.add(Is_One_Pager_Available);
                    }
                    All_Data.Add(onePagerNewList);
                    All_Data.add(Is_One_Pager_Available);
                    
                }
                else{
                    All_Data.Add(onePagerNewList);
                    All_Data.add(Is_One_Pager_Available);
                    
                }
                return All_Data;
            }
            else{
                for(One_Pager__c sa : OnePagerList)
                {
                    system.debug('We are here in smaller Response');
                    One_Pager_Response__c sar = new One_Pager_Response__c();
                    
                    sar.Application__c = AppRecId;
                    sar.Assignment__c = Man_id;
                    sar.Response__c = '';
                    sar.Response_Fr__c ='';
                    sar.One_Pager__c  = sa.Id;
                    sar.Question_Fr__c = sa.French__c;
                    sar.Question_Eng__c = sa.English__c;
                    onePagerNewList.add(sar);
                }
                system.debug('onePagerNewList'+onePagerNewList);
                All_Data.add(onePagerNewList);
                All_Data.add(Is_One_Pager_Available);
                return All_Data;
            }
        }catch(Exception e)
        {
            System.debug('Error==>'+e.getMessage()+'Line Number==>'+e.getLineNumber());
            return null;
        }
    }
    //----------------------------------------------------------------------------------------------------------------------------------------------------
    
    @AuraEnabled 
    public static List<One_Pager_Response__c> Create_One_Pager_Con_Rec(List<One_Pager_Response__c> One_Pager_List,List<Radar_Rating_Response__c> RadarListTobeUpdated,List<String> deleteList,List<Contact> ConListtobeUpdated,String appid,Boolean Compensation_To_Be_included){
        system.debug('One_Pager_List'+One_Pager_List);
        system.debug('ConListtobeUpdated'+ConListtobeUpdated);
        system.debug('RadarListTobeUpdated'+RadarListTobeUpdated);
        system.debug('Compensation_To_Be_included'+Compensation_To_Be_included);
        List<One_Pager_Response__c> listToBeUpdated = new List<One_Pager_Response__c>();
        List<One_Pager_Response__c> listToBeInserted = new List<One_Pager_Response__c>();
        List<Radar_Rating_Response__c> RadarlistToUpdated = new List<Radar_Rating_Response__c>();
        List<Radar_Rating_Response__c> RadarlistToBeInserted = new List<Radar_Rating_Response__c>();
        
        if(!deleteList.isEmpty()){
            Database.delete(deleteList);
        }
        for(One_Pager_Response__c ag : One_Pager_List ){
            if(ag.Id != null){
                listToBeUpdated.add(ag);
            }else{
                listToBeInserted.add(ag);
            }
        }
        for(Radar_Rating_Response__c rr:RadarListTobeUpdated){
            system.debug('rr.ID'+rr.Id);
            if(rr.Id != null){
                RadarlistToUpdated.add(rr);
            }else{
                RadarlistToBeInserted.add(rr);
            }
            system.debug('RadarlistToUpdated'+RadarlistToUpdated);
            system.debug('RadarlistToBeInserted'+RadarlistToBeInserted);
            
        }
        if(!listToBeInserted.isEmpty()){
            insert listToBeInserted;
        }
        if(!listToBeUpdated.isEmpty()){
            update listToBeUpdated;
        }
        if(!ConListtobeUpdated.isEmpty()){
            update ConListtobeUpdated;
        }
        if(!RadarlistToUpdated.isEmpty()){
            update RadarlistToUpdated;
        }
        if(!RadarlistToBeInserted.isEmpty()){
            insert RadarlistToBeInserted;
        }
        
        {
            update new application__c(id = appid,Has_One_Pager__c = true,Include_In_One_Pager__c = Compensation_To_Be_included );
        }        
        OnePagerHelper.Generate_One_Pager(appid);
        
        if(!listToBeInserted.isEmpty()){
            return listToBeInserted;    
        }
        else{
            return listToBeUpdated;
        }
    }
    @AuraEnabled 
    public static map<string,String> get_Attach_id_OnePager(String recordId,String mandateId)
    {
        map<string,String> AttIdsWithName = new map<string,String>(); 
        List<String> AttIds = new List<String>();
        try{
            Id condid =  [SELECT Contact_ID__c FROM Application__c WHERE Id =:recordId].Contact_ID__c;
            
            String OpId;
            String SelfAssId;
            String OpFrConId;
            String LetterId;
            String JobDescId;
            String PsyId;
            Attachment[] attOPfromApp = [SELECT Id FROM Attachment WHERE ParentId = :recordId AND Name LIKE '%One Pa%' ORDER BY LastModifiedDate DESC LIMIT 1];
            
            Attachment[] attOPfromCon = [SELECT Id FROM Attachment WHERE ParentId = :condid AND Name LIKE '%One Pa%' ORDER BY LastModifiedDate DESC LIMIT 1];
            
            //OpFrConId = [SELECT Id FROM Attachment WHERE ParentId = :condid AND Name LIKE '%One Pa%' ORDER BY LastModifiedDate DESC LIMIT 1].Id;
            if(attOPfromApp.size() > 0)
            { 
                OpId =  attOPfromApp[0].Id; 
                AttIdsWithName.put('OnePagerId',OpId);
                
            }
            else{
                if(attOPfromCon.size() > 0){
                    AttIdsWithName.put('OnePagerId',OpId);
                    OpId =  attOPfromCon[0].Id;
                }
            }            
            if(attOPfromCon.size() > 0){
                OpFrConId =  attOPfromCon[0].Id;
                AttIdsWithName.put('OnePagerFromConId',OpFrConId);
                
            }
            
            Attachment[] attLetterfromCon  =[SELECT Id FROM Attachment WHERE ParentId = :condid AND Name LIKE '%Candidate Intro%' ORDER BY LastModifiedDate DESC LIMIT 1];
            if(attLetterfromCon.size() > 0)
            { 
                LetterId =  attLetterfromCon[0].Id;  
                AttIdsWithName.put('LetterFromConId',LetterId);
            }
            
            Attachment[] attSelfAssfromApp = [SELECT Id FROM Attachment WHERE ParentId = :recordId AND Name LIKE '%Self Ass%' ORDER BY LastModifiedDate DESC LIMIT 1];
            if(attSelfAssfromApp.size() > 0){
                SelfAssId = attSelfAssfromApp[0].Id; 
                AttIdsWithName.put('SelfAssId',SelfAssId);
            }
            Attachment[] JdIdFromMan = [SELECT Id FROM Attachment WHERE ParentId = :mandateId AND Name LIKE '%Job desc%' ORDER BY LastModifiedDate DESC LIMIT 1];
            if(JdIdFromMan.size() > 0){
                JobDescId = JdIdFromMan[0].Id;    
                AttIdsWithName.put('JobDescId',JobDescId);
            }
            
            Attachment[] PsyIdFromCon = [SELECT Id FROM Attachment WHERE ParentId = :condid AND Name LIKE '%Psy Te%' ORDER BY LastModifiedDate DESC LIMIT 1];
            if(PsyIdFromCon.size() > 0){
                PsyId = PsyIdFromCon[0].Id;    
                AttIdsWithName.put('PsyId',PsyId);
            }
            
            system.debug('AttIdsWithName'+AttIdsWithName);
            return AttIdsWithName;
        }
        catch(QueryException e){
            return null;
        }
    }   
    
    @AuraEnabled 
    public static Map<String,String> getCVandBoardCV(String recordId)
    {
        try{
            system.debug('appid'+recordId);
            Map<String,String> cvIdByCVName = new Map<String,String>();
            List<Attachment> canList = [Select id,Name from Attachment where name LIKE '%CV%' AND ParentId=:recordId order by createdDate ];
            for(Attachment attRec:canList){
                if(attRec.Name.contains('CV')){
                    cvIdByCVName.put('CV',attRec.Id);
                }
                if(attRec.Name.contains('Board CV')){
                    cvIdByCVName.put('Board CV',attRec.Id);
                }
            }
            return cvIdByCVName;
        }catch(Exception e){
            System.debug('@@@@@'+e.getLineNumber()+'@@@'+e.getMessage());
            return null;
        }
    }
    public class OnePagerWrapper {
        @AuraEnabled
        public Boolean isOnePAgerCreated {get;set;}
        @AuraEnabled
        public List<One_Pager__c> One_Pager_List {get;set;}
        
        public OnePagerWrapper(Boolean isOnePAgerCreated,List<One_Pager__c> One_Pager_List){
            this.isOnePAgerCreated 			= isOnePAgerCreated;
            this.One_Pager_List 		= One_Pager_List;
        }
    }
}