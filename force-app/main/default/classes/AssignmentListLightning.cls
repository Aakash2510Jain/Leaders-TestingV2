public class AssignmentListLightning {
    public List<String> statusValues;
    
    /*   public List<String> getStatusValues(){
if(statusValues == null){
statusValues = new List<String>{'Active','Identification','Selection','Consulting','Integration'};            
}
return statusValues;
} */
    @AuraEnabled
    public static String getStringFromList(List<String> sStatus) {
        string s;
        for(String status : sStatus){
            s = (!String.isBlank(s)) ? (s + ',\'' + status + '\'') : ('\'' + status + '\'');
                }
        return s; 
    }   
    
    @AuraEnabled
    public static assignmentListWrapper getDefaultValues()
    {
        List<String> statusValues =  AssignmentListLightning.getListOfStatusByViewName('MyActive');
        
        Id UserId = UserInfo.getUserId();
        
        integer no_of_ass = 0;
        Decimal avg_of_no_of_days = 0;
        //    getStatusValues();
        String status = getStringFromList(statusValues);
        // statusValues = 
        //  assignmentListWrapper returnDefaultAssignments = new assignmentListWrapper();
        List<Mandate__C> manlist = Database.query('Select Id, Name, Company__c, '+
                                                  'Company__r.Name, '+
                                                  'Company_Name_French__c, '+
                                                  'Job_Function__c, Level__c, '+
                                                  'Assignment_Status__c, '+
                                                  'Researcher__r.Name, '+
                                                  'Researcher_3__r.Name, '+
                                                  'Researcher_4__r.Name, '+
                                                  'Researcher_5__r.Name, '+
                                                  'Consultant__r.Name, '+
                                                  'Partner__r.Name, '+
                                                  'Partner_2__r.Name, '+
                                                  'Partner_3__r.Name, '+
                                                  'Number_of_potential_candidates__c, '+
                                                  'Number_of_candidates__c, '+
                                                  'number_of_days__c, '+
                                                  'Has_Job_Description__c, '+
                                                  'Has_Research_Strategy__c, '+
                                                  'Leaders_interviews__c, ' +
                                                  'Client_interviews__c, ' +
                                                  'Module__c '+
                                                  'from Mandate__c '+
                                                  'where Assignment_Status__c in ('+ status + ') '+
                                                  'and (Consultant__c = \''+ userId +'\' '+
                                                  'or Partner__c = \''+ userId +'\' '+
                                                  'or Partner_3__c = \''+ userId +'\' '+
                                                  'or Partner_2__c = \''+ userId +'\' '+
                                                  'or Researcher__c = \''+ userId +'\' '+ 
                                                  'or Researcher_3__c = \''+ userId +'\' '+
                                                  'or Researcher_4__c = \''+ userId +'\' '+
                                                  'or Researcher_5__c = \''+ userId +'\' )'  +    
                                                  'and (Company_Name_French__c  != null) '+
                                                  'Order By number_of_days__c DESC ' );
        
        
        for( Mandate__c alw : manlist)
        {
            if(alw.number_of_days__c != null){
            avg_of_no_of_days = avg_of_no_of_days + alw.number_of_days__c;
            }
            no_of_ass  =  no_of_ass+1;
            
            //system.debug('no_of_ass'+avg_of_no_of_days);
        }
        if(no_of_ass != 0)
        {
        avg_of_no_of_days  = (avg_of_no_of_days/no_of_ass);
        
        avg_of_no_of_days = avg_of_no_of_days.setscale(0);
           
        }
        
        
        assignmentListWrapper returnDefaultAssignments = new assignmentListWrapper(manlist,no_of_ass,avg_of_no_of_days);
        
        System.debug('returnDefaultAssignments'+returnDefaultAssignments);
        
        return returnDefaultAssignments;
        
    }
    
    
    @AuraEnabled  
    public static assignmentListWrapper getMyAssignmentValues()
    {
        Id UserId = UserInfo.getUserId(); 
        
        List<String> statusValues = AssignmentListLightning.getListOfStatusByViewName('My'); 
        
        integer no_of_ass = 0;
        Decimal avg_of_no_of_days = 0;
        
        system.debug('statusValues'+statusValues);
        
        List<Mandate__C> manlist  = Database.query('Select Id, Name, Company__c, '+
                                                   'Company__r.Name, '+
                                                   'Company_Name_French__c, '+
                                                   'Job_Function__c, Level__c, '+
                                                   'Assignment_Status__c, '+
                                                   'Researcher__r.Name, '+
                                                   'Researcher_3__r.Name, '+
                                                   'Researcher_4__r.Name, '+
                                                   'Researcher_5__r.Name, '+
                                                   'Consultant__r.Name, '+
                                                   'Partner__r.Name, '+
                                                   'Partner_2__r.Name, '+
                                                   'Partner_3__r.Name, '+
                                                   'Number_of_potential_candidates__c, '+
                                                   'Number_of_candidates__c, '+
                                                   'number_of_days__c, '+
                                                   'Has_Job_Description__c, '+
                                                   'Has_Research_Strategy__c, '+
                                                   'Module__c,'+
                                                   'Leaders_interviews__c, ' +
                                                   'Client_interviews__c ' +
                                                   'from Mandate__c '+
                                                   'where (Company_Name_French__c  != null) And ( Consultant__c = \''+ userId +'\' '+
                                                   'or Partner__c = \''+ userId +'\' '+
                                                   'or Partner_2__c = \''+ userId +'\' '+
                                                   'or Partner_3__c = \''+ userId +'\' '+
                                                   'or Researcher__c = \''+ userId +'\' '+ 
                                                   'or Researcher_3__c = \''+ userId +'\' '+
                                                   'or Researcher_4__c = \''+ userId +'\' '+
                                                   'or Researcher_5__c = \''+ userId +'\' )'+
                                                   'Order By number_of_days__c DESC '      );
        
        
        for( Mandate__c alw : manlist)
        {
           if(alw.number_of_days__c != null){
            avg_of_no_of_days = avg_of_no_of_days + alw.number_of_days__c;
            }
            no_of_ass  =  no_of_ass+1;
            
            //system.debug('no_of_ass'+avg_of_no_of_days);
        }
        avg_of_no_of_days  = (avg_of_no_of_days/no_of_ass);
        
        avg_of_no_of_days = avg_of_no_of_days.setscale(0);
        
        
        assignmentListWrapper returnMyAssignments = new assignmentListWrapper(manlist,no_of_ass,avg_of_no_of_days);
        
        System.debug('returnDefaultAssignments'+returnMyAssignments);
        
        
        return returnMyAssignments;
        
    }
    
    @AuraEnabled
    public static assignmentListWrapper getAllActiveAssignmentValues()
    {
        List<String> statusValues =AssignmentListLightning.getListOfStatusByViewName('All Active'); 
        Id UserId = UserInfo.getUserId(); 
        String status = getStringFromList(statusValues);
        system.debug('status'+status);
        integer no_of_ass = 0;
        Decimal avg_of_no_of_days = 0;
        
        List<Mandate__C> manlist  =  Database.query('Select Id, Name, Company__c, '+
                                                    'Company__r.Name, '+
                                                    'Company_Name_French__c, '+
                                                    'Job_Function__c, Level__c, '+
                                                    'Assignment_Status__c, '+
                                                    'Researcher__r.Name, '+
                                                    'Researcher_3__r.Name, '+
                                                    'Researcher_4__r.Name, '+
                                                    'Researcher_5__r.Name, '+
                                                    'Consultant__r.Name, '+
                                                    'Partner__r.Name, '+
                                                    'Partner_2__r.Name, '+
                                                    'Partner_3__r.Name, '+
                                                    'Number_of_potential_candidates__c, '+
                                                    'Number_of_candidates__c, '+
                                                    'number_of_days__c, '+
                                                    'Has_Job_Description__c, '+
                                                    'Has_Research_Strategy__c, '+
                                                    'Leaders_interviews__c, ' +
                                                    'Client_interviews__c, ' +
                                                    'Module__c '+
                                                    'from Mandate__c '+   
                                                    'where Assignment_Status__c in ('+ status +')'+
                                                    'and (Company_Name_French__c  != null) '+
                                                    'Order By number_of_days__c DESC '  );
        
        for( Mandate__c alw : manlist)
        {
            if(alw.number_of_days__c != null)
            {    
            avg_of_no_of_days = avg_of_no_of_days + alw.number_of_days__c;
            }
            no_of_ass  =  no_of_ass+1;
            
           
        }
        avg_of_no_of_days  = (avg_of_no_of_days/no_of_ass);
        
        avg_of_no_of_days = avg_of_no_of_days.setscale(0);
        
        
        assignmentListWrapper getAllActiveAssignment = new assignmentListWrapper(manlist,no_of_ass,avg_of_no_of_days);
        
        System.debug('returnDefaultAssignments'+getAllActiveAssignment);
        
        return getAllActiveAssignment;
        
    }
    
    
    @AuraEnabled
    public static assignmentListWrapper getAllAssignmentValues()
    {
        List<String> statusValues =AssignmentListLightning.getListOfStatusByViewName('All'); 
        String status = getStringFromList(statusValues);
        integer no_of_ass = 0;
        Decimal avg_of_no_of_days = 0;
        
        Id UserId = UserInfo.getUserId(); 
        
        List<Mandate__C> manlist = Database.query('Select Id, Name, Company__c, '+
                                                  'Company__r.Name, '+
                                                  'Company_Name_French__c, '+
                                                  'Job_Function__c, Level__c, '+
                                                  'Assignment_Status__c, '+
                                                  'Researcher__r.Name, '+
                                                  'Researcher_3__r.Name, '+
                                                  'Researcher_4__r.Name, '+
                                                  'Researcher_5__r.Name, '+
                                                  'Consultant__r.Name, '+
                                                  'Partner__r.Name, '+
                                                  'Partner_2__r.Name, '+
                                                  'Partner_3__r.Name, '+
                                                  'Number_of_potential_candidates__c, '+
                                                  'Number_of_candidates__c, '+
                                                  'number_of_days__c, '+
                                                  'Has_Job_Description__c, '+
                                                  'Has_Research_Strategy__c, '+
                                                  'Leaders_interviews__c, ' +
                                                  'Client_interviews__c, ' +
                                                  'Module__c ' +
                                                  'from Mandate__c '  +
                                                  'where Assignment_Status__c in ('+ status +')'+
                                                  'and (Company_Name_French__c  != null) '+
                                                  'Order By number_of_days__c DESC '  );   
        
        for( Mandate__c alw : manlist)
        {
           if(alw.number_of_days__c != null){
            avg_of_no_of_days = avg_of_no_of_days + alw.number_of_days__c;
            }
            no_of_ass  =  no_of_ass+1;
            
            //system.debug('no_of_ass'+avg_of_no_of_days);
        }
        avg_of_no_of_days  = (avg_of_no_of_days/no_of_ass);
        
        avg_of_no_of_days = avg_of_no_of_days.setscale(0);
        
        
        assignmentListWrapper returnAllAssignments = new assignmentListWrapper(manlist,no_of_ass,avg_of_no_of_days);
        
        System.debug('returnDefaultAssignments'+returnAllAssignments);
        
        
        return returnAllAssignments;
        
    }
    
    @AuraEnabled
    public Static assignmentListWrapper getAllAssignmentByTeam(String teamName){
        List<String> userIds 						= new List<String>();
        integer no_of_ass = 0;
        Decimal avg_of_no_of_days = 0;
        
        userIds 									= getUserIdByTeamName(teamName);
        system.debug('userIds'+userIds);
        List<String> statusValues                   =  AssignmentListLightning.getListOfStatusByViewName('Team'); 
        String status = getStringFromList(statusValues); 
        
        
        String query 								= 'Select Id,Name,Company__c, '+
            'Company__r.Name, '+
            'Company_Name_French__c, '+
            'Job_Function__c, Level__c, '+
            'Assignment_Status__c, '+
            'Researcher__r.Name, '+
            'Researcher_3__r.Name, '+
            'Researcher_4__r.Name, '+
            'Researcher_5__r.Name, '+
            'Consultant__r.Name, '+
            'Partner__r.Name, '+
            'Partner_2__r.Name, '+
            'Partner_3__r.Name, '+
            'Number_of_potential_candidates__c, '+
            'Number_of_candidates__c, '+
            'number_of_days__c, '+
            'Has_Job_Description__c, '+
            'Has_Research_Strategy__c, '+
            'Leaders_interviews__c, ' +
            'Client_interviews__c, ' +
            'Module__c ' +
            'from mandate__c';      
        
        String whereClause 							= ' Where Assignment_Status__c in ('+ status + ') and (Company_Name_French__c  != null) AND (';
        String orderBy 								= ' Order By number_of_days__c DESC ';
        
        for(String partnerId:userIds){
            
            whereClause += 'Partner__c= \''+partnerId+'\'';
            whereClause += ' OR Partner_2__c= \''+partnerId+'\'';
            whereClause += ' OR Partner_3__c= \''+partnerId+'\'' +' OR ';
        }
        
        if(whereClause.length() >10){
            whereClause = whereClause.removeEnd(' OR ');
            whereClause +=')';
        }
        system.debug(query+whereClause+orderBy);
        List<Mandate__C> manlist   =  Database.query(query+whereClause+orderBy);
        
        
        
        for( Mandate__c alw : manlist)
        {
            if(alw.number_of_days__c != null){
            avg_of_no_of_days = avg_of_no_of_days + alw.number_of_days__c;
            }
            no_of_ass  =  no_of_ass+1;
            
        }
        if(no_of_ass != 0)
        {
        avg_of_no_of_days  = (avg_of_no_of_days/no_of_ass);
        
        avg_of_no_of_days = avg_of_no_of_days.setscale(0);
        }
        
        assignmentListWrapper returnAllAssignments = new assignmentListWrapper(manlist,no_of_ass,avg_of_no_of_days);
        
        System.debug('returnDefaultAssignments'+returnAllAssignments);
        
        
        return returnAllAssignments;
    }
    
    
    @AuraEnabled
    public static List<Assignment_Notes__c> getAllNotes(String RecId)
    {
        
        list<mandate__c> manlist = [Select id,(Select name from Assignment_Notes__r) from mandate__c where id =:RecId];
        system.debug('manlist'+manlist);
        
        List<Assignment_Notes__c> noteList = new List<Assignment_Notes__c>();
        
        for(mandate__c man:manlist)
        {
            for(Assignment_Notes__c ass:man.Assignment_Notes__r )
            {
                noteList.add(ass);
                system.debug('Notes'+ass);
            }
        }
        
        system.debug('noteslist'+noteList);
        return noteList;
        
    }
    
    public class assignmentListWrapper{
        @AuraEnabled public List<Mandate__c> lstAssignments{get;set;}
        @AuraEnabled public Decimal Num_of_Ass{get;set;}
        @AuraEnabled public Decimal Avg_of_ass{get;set;}
        
        
        public assignmentListWrapper(List<Mandate__c> lstAssignments,Decimal Num_of_Ass,Decimal Avg_of_ass){
            this.lstAssignments=lstAssignments;
            this.Num_of_Ass=Num_of_Ass;
            this.Avg_of_ass=Avg_of_ass;
            
        }
    }
    
    @AuraEnabled
    public static Map<String,String> getListviewNamesAndStatusValues() 
    {
        
        List<Assignment_Stage_Configuration__mdt> apiKey 					= [SELECT Get_Status_Value__c,List_View_Name__c,Label FROM Assignment_Stage_Configuration__mdt ];
        Map<String,String> teamNameAndMembers 	= new Map<String,String>();
        
        for(Assignment_Stage_Configuration__mdt td :apiKey ){
            teamNameAndMembers.put(td.List_View_Name__c,td.Get_Status_Value__c);
        }
        system.debug('TeamName'+teamNameAndMembers);
        
        return teamNameAndMembers;
    }
    
    @AuraEnabled
    public static List<String> getListOfStatusByViewName(String Listview){
        
        Map<String,String> allstatusValuesbyViewName 	= getListviewNamesAndStatusValues();
        //List<String> userIds 						= new List<String>();
        List<String> StatusValues 						= new List<String>();
        
        if(allstatusValuesbyViewName.containsKey(Listview)){
            if(allstatusValuesbyViewName.get(Listview).contains(','))
                StatusValues = allstatusValuesbyViewName.get(Listview).split(',');
            else{
                StatusValues.add(allstatusValuesbyViewName.get(Listview));
            }
        }
        return StatusValues;
    }
    @AuraEnabled
    public static Map<String,String> getTeamNameAndValues() 
    {
        
        List<Team__mdt> apiKey 					= [SELECT Team_Members__c,Label FROM Team__mdt ];
        Map<String,String> teamNameAndMembers 	= new Map<String,String>();
        
        for(Team__mdt td :apiKey ){
            teamNameAndMembers.put(td.Label,td.Team_Members__c);
        }
        system.debug('TeamName'+teamNameAndMembers);
        
        return teamNameAndMembers;
    }
    
    @AuraEnabled
    public static List<String> getUserIdByTeamName(String teamName){
        system.debug('teamName'+teamName);
        Map<String,String> allTeamMemberbyTeamName 	= getTeamNameAndValues();
        List<String> userIds 						= new List<String>();
        List<String> userNames 						= new List<String>();
        
        if(allTeamMemberbyTeamName.containsKey(teamName)){
            if(allTeamMemberbyTeamName.get(teamName).contains(','))
                userNames = allTeamMemberbyTeamName.get(teamName).split(',');
            else{
                userNames.add(allTeamMemberbyTeamName.get(teamName));
            }
            system.debug('userNames'+userNames);
            for(User userRec:[Select Id,Name from user where Name IN:userNames]){
                userIds.add(userRec.Id);
            }
        }
        
        system.debug('userIds'+userIds);
        return userIds;
    }
    
    @AuraEnabled
    public static String getUserTeamByTeam(){
        
        Map<String,String> allTeamMemberbyTeamName 	= getTeamNameAndValues();
        List<String> userIdsofmontreal 						= new List<String>();
        List<String> userIdsofOttawa 						= new List<String>();
        List<String> userIdsofToronto 						= new List<String>();
        List<String> userIdsofLeaders                       = new List<String>();
        List<String> userIdsofIndigenous                    = new List<String>();
        List<String> userNames 					         	= new List<String>();
        
        if(allTeamMemberbyTeamName.containsKey('The Montreal Team')){
            if(allTeamMemberbyTeamName.get('The Montreal Team').contains(','))
                userNames = allTeamMemberbyTeamName.get('The Montreal Team').split(',');
            else{
                userNames.add(allTeamMemberbyTeamName.get('The Montreal Team'));
            }
            
            for(User userRec:[Select Id,Name from user where Name IN:userNames]){
                userIdsofmontreal.add(userRec.Id);
            }
        }
        
        if(allTeamMemberbyTeamName.containsKey('Ottawa Team')){
            if(allTeamMemberbyTeamName.get('Ottawa Team').contains(','))
                userNames = allTeamMemberbyTeamName.get('Ottawa Team').split(',');
            else{
                userNames.add(allTeamMemberbyTeamName.get('Ottawa Team'));
            }
            
            for(User userRec:[Select Id,Name from user where Name IN:userNames]){
                userIdsofOttawa.add(userRec.Id);
                system.debug('userIdsofOttawa'+userIdsofOttawa);
            }
        }
        
        if(allTeamMemberbyTeamName.containsKey('Toronto Team')){
            if(allTeamMemberbyTeamName.get('Toronto Team').contains(','))
                userNames = allTeamMemberbyTeamName.get('Toronto Team').split(',');
            else{
                userNames.add(allTeamMemberbyTeamName.get('Toronto Team'));
            }
            
            for(User userRec:[Select Id,Name from user where Name IN:userNames]){
                userIdsofToronto.add(userRec.Id);
            }
        }
        if(allTeamMemberbyTeamName.containsKey('Indigenous Team')){
            if(allTeamMemberbyTeamName.get('Indigenous Team').contains(','))
                userNames = allTeamMemberbyTeamName.get('Indigenous Team').split(',');
            else{
                userNames.add(allTeamMemberbyTeamName.get('Indigenous Team'));
            }
            
            for(User userRec:[Select Id,Name from user where Name IN:userNames]){
                userIdsofIndigenous.add(userRec.Id);
            }
        }
        
       /* if(allTeamMemberbyTeamName.get('Leaders').contains(','))
            userNames = allTeamMemberbyTeamName.get('Leaders').split(',');
            
        else{
            userNames.add(allTeamMemberbyTeamName.get('Leaders'));
            
        }
        system.debug('userNames'+userNames);
        for(User userRec:[Select Id,Name from user where Name IN:userNames]){
            userIdsofLeaders.add(userRec.Id);
        } */
        
        
        string Currentuser = userinfo.getUserId();
        String team = '';
        system.debug('userIdsofLeaders'+userIdsofLeaders);
        system.debug('userIdsofIndigenous'+userIdsofIndigenous);
        if(userIdsofmontreal.contains(Currentuser))
        {
            team = 'The Montreal Team';
        }
        
        else if(userIdsofOttawa.contains(Currentuser))
        {
            team = 'Ottawa Team';
        }
        else if(userIdsofToronto.contains(Currentuser))
        {
            team = 'Toronto Team';
        }
        else if(Currentuser == '005U0000003DyYCIA0')
        {
            team = 'Leaders';
        }
         else if(userIdsofIndigenous.contains(Currentuser))
        {
            team = 'Indigenous Team';
        }
        else
        {
            team = 'No team';
        }
        
        system.debug('team'+team);
        return team;
    }
}