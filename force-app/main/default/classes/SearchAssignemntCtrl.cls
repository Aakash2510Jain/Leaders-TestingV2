public class SearchAssignemntCtrl
{  
    @AuraEnabled
    public static List<Contact> GetPeopleRecFromCompany(String CompId){
        List<Contact> ConList = [SELECT Id,Name,Phone,Email FROM Contact WHERE AccountId =:CompId]; 
        return ConList;
    }
    @AuraEnabled
    public static List<String> getFieldsLabelName(){
        SearchAssignmentColumnList__c searchPeople=SearchAssignmentColumnList__c.getValues('Assignment');
        String FieldLabel=searchPeople.FieldLabelName__c;
        List<String> fieldsLabelName=FieldLabel.split(',');
        return fieldsLabelName;
    }
    @AuraEnabled
    public static List<String> getFieldsAPIName(){
        SearchAssignmentColumnList__c searchPeople=SearchAssignmentColumnList__c.getValues('Assignment');
        String FieldLabel=searchPeople.FieldApiName__c;
        List<String> fieldsAPIName=FieldLabel.split(',');
        return fieldsAPIName;
    }
    @AuraEnabled
    public static String getJobDescID(String mandateId){
        String JobDescId;
        Attachment[] JdIdFromMan = [SELECT Id FROM Attachment WHERE ParentId = :mandateId AND Name LIKE '%Job desc%' ORDER BY LastModifiedDate DESC LIMIT 1];
        if(JdIdFromMan.size() > 0){
            JobDescId = JdIdFromMan[0].Id;    
        }
        return JobDescId;
    }
    @AuraEnabled
    public static Map<String,List<String>> getFields(){
        List<String> labelList=SearchAssignemntCtrl.getFieldsLabelName();
        List<String> apiList=SearchAssignemntCtrl.getFieldsAPIName();
        Map<String,List<String>> fieldList=new Map<String,List<String>>();
        fieldList.put('Label',labelList);
        fieldList.put('API', apiList);
        return fieldList;
    }
    @AuraEnabled
    public static Map<String,List<String>> UserList(){
        Map<String,List<String>> UserNames = new Map<string,List<String>>();
        List<String> Username= new List<string>();
        List<String> UserID= new List<string>();
        
        for(User aUser : [Select Id, Name from User WHERE IsActive = TRUE ORDER BY Name]){
            Username.add(aUser.Name);
            UserID.add(aUser.Id) ;
        }
        UserNames.put('UserName',Username);
        UserNames.put('UserID',UserID);
        return UserNames; 
    }
    
    public static Integer count;
    @AuraEnabled
    public static String[] picklist_values(String object_name, String field_name) 
    {
        system.debug('field_name'+field_name);
        String[] values = new String[]{};
            String[] types = new String[]{object_name};
                Schema.DescribeSobjectResult[] results = Schema.describeSObjects(types);
        for(Schema.DescribeSobjectResult res : results) 
        {
            for (Schema.PicklistEntry entry : res.fields.getMap().get(field_name).getDescribe().getPicklistValues()) 
            {
                if (entry.isActive()) {values.add(entry.getValue());}
            }
        }
        return values;
    }
    
    @AuraEnabled
    public static Map<String,List<String>> getAllPickVal(List<String> fieldList,String obj) 
    {
        Map<String,List<String>> pickvalByFieldName = new Map<String,List<String>>();
        
        for(String str:fieldList)
        {
            if(str == 'Industry_Types__c' ){
                system.debug('Industry_Types__c');
                obj = 'Account';
            }else if(str == 'Country__c' ){
                obj = 'Contact';
            }else if(str == 'State__c' ){
                obj = 'Contact';
            }
            else{
                obj = 'Mandate__c';
            }
            pickvalByFieldName.put(str,picklist_values(obj,str));
        }
        return pickvalByFieldName;   
    }
    
    @Auraenabled
    public static List<Mandate__c> getAssignRec(Map<String,List<String>> fetchdata,String BooleanSearchValue)
    {
        system.debug('BooleanSearchValue'+BooleanSearchValue);
        Boolean booleanSearch = false;
        List<Mandate__c> returnList = new List<Mandate__c>();
        List<String> lstString = new    List<String>();
        String searchTerms = '';
        String searchOp = '';
        if(!String.isEmpty(BooleanSearchValue)){
            booleanSearch = true; 
            if(BooleanSearchValue.contains(',')){
                lstString = BooleanSearchValue.split(',');
                system.debug('lstString'+lstString);
                
                for(String Str:lstString){
                    searchTerms += '("' + Str + '")'+'OR';
                }
                searchTerms = searchTerms.Substring(0,searchTerms.length()-2);
            }else{
                searchTerms = BooleanSearchValue;
            }
        }
        system.debug('searchTerms'+searchTerms);
        if(booleanSearch == true ){
            
            String queryString = 'FIND {'+searchTerms+'} IN ALL FIELDS RETURNING Mandate__c(Id,State__c,Country__c,Company_Name_French__c,Job_description_Id__c,Company__r.Name,Has_Job_Description__c,Industry_Types__c,Name, Company__r.Industry_Types__c, Status__c, Assignment_Status__c, Mandate_Start_Date__c,Job_Function__c,Partner__r.name,Partner_2__r.name,Level__c,Number_of_candidates__c,number_of_days__c)' ;
            //   String queryString = 'select id,Name,Industry,Status__c,Phone,Website,BillingCountry,BillingState,State__c,Country__c,Industry_Types__c,(Select Id from Contacts) from Account  where'+fields+' Limit 12999' ;
            List<List<Mandate__c>>searchList=search.query(queryString);	
            system.debug('searchList'+searchList);
            List<Mandate__c> lstofAssgn  = new List<Mandate__c>();  
            lstofAssgn =  ((List<Mandate__c>)searchList[0]);
            system.debug('BooleanData'+lstofAssgn);
            
            System.debug('@@@@'+queryString);
            
            count= 0;
            
            system.debug(lstofAssgn);
            Set<Id> mandateIds =  new Set<Id>();
            for(Mandate__C man : lstofAssgn) 
            {
                Count++;
                returnList.add(man);
                mandateIds.add(man.Id);
            }
            
            return returnList;
        }
        
        else{
            try{
                system.debug('fetchdata'+fetchdata);
                List<String> fieldvalue = new List<String>();
                
                String fields = '';
                List<String> countryToAvoid = new List<String>();
                countryToAvoid.add('Canada');
                countryToAvoid.add('United State');
                countryToAvoid.add('Europe');
                
                Integer k=0;
                String CountryString = '';
                if(!countryToAvoid.isEmpty()){
                    for(String  country: countryToAvoid) {
                        if(k>0)
                            CountryString += ' , ';
                        CountryString += '\''+country+'\'';
                        k++;
                    }
                }
                system.debug('CountryString'+CountryString);
                
                Boolean stop = false;
                Boolean value = false;
                Boolean Mulitple = false;
                Boolean DateValue = false;
                String innerVar = '';
                system.debug('fetchdata.keySet()'+fetchdata.keySet());
                system.debug('fetchdata.keySet()'+fetchdata.values());
                for(String str : fetchdata.keySet())
                {
                    if(fetchData.get(str) !=null && !fetchData.get(str).isEmpty())
                    {
                        if(fields.length() == 0)
                        {
                            if(str == 'Country__c'){
                                fields += '( ';
                                stop = false;
                            }
                            else if(str == 'Partner__c'){
                                fields += '';
                                stop = true;
                            }
                            else{
                                fields += ' (';  
                            }
                        }
                        else
                        {
                            if(str == 'Country__c'){
                                fields += ' ';
                                stop = true;
                            }
                            if(str == 'Partner__c'){
                                
                                if(innerVar.length()>1){
                                    fields += ' AND (';
                                    stop = true;
                                }else{
                                    fields += ' OR ';
                                    stop = true;    
                                }
                            }
                            else if(str == 'Partner_2__c'){
                                fields += ' OR ';
                                stop = true;
                            }
                            else if(str == 'Partner_3__c'){
                                fields += ' OR ';
                                stop = true;
                            }
                            else if(str == 'Consultant__c'){
                                fields += ' OR ';
                                stop = true;
                            }
                            else if(str == 'Researcher__c'){
                                value = true;
                                fields += ' OR ';
                            }else if(str == 'Researcher_3__c'){
                                value = true;
                                fields += ' OR ';
                            }
                            else if(str == 'Researcher_4__c'){
                                value = true;
                                fields += ' OR ';
                            }
                            else if(str == 'Researcher_5__c'){
                                value = true;
                                stop = false;
                                fields += ' OR ';
                            }
                            else if(str == 'Assignment_Status__c'){
                                fields += ' AND (';
                            }
                        }
                        
                        if(str == 'Mandate_Start_Date__c'){
                            if(innerVar.length() > 5){
                                innerVar = ' AND ('+str+' >';
                            }else{
                                innerVar = str+' >';
                            }
                        }
                        else if(str == 'Mandate_End_Date__c'){
                            if(innerVar.contains('Mandate_Start_Date__c') ){
                                DateValue = true;
                                innerVar = ' AND ((Mandate_End_Date__C = null) OR ('+str+' <';
                            }else{
                                innerVar = +str+' <';
                            } 
                        }
                        else if(str == 'Company_Name_French__c'){
                            innerVar = str+' like ';
                        }
                        else if(str == 'Name'){
                            innerVar = str+' like ';
                        }
                        else if(str == 'Country__c' && fetchdata.get('Country__c')[0] == 'Other'){
                            innerVar = str+' NOT IN ';
                        }
                        else if(str == 'Partner__c' ||str == 'Partner_2__c'||str == 'Partner_3__c'||str == 'Consultant__c'||str == 'Researcher__c'||str == 'Researcher_3__c'||str == 'Researcher_4__c'||str == 'Researcher_5__c' ){
                            if(fetchdata.get(str).size() > 1){
                                String partnerIdString = '';
                                if(!fetchdata.get(str).isEmpty()){
                                    for(String  partner: fetchdata.get(str)) {
                                        if(k>0)
                                            partnerIdString += '\''+partner+'\'';
                                        partnerIdString += ' , ';
                                        k++;
                                    }
                                }
                                system.debug('We are using In');
                                partnerIdString = partnerIdString.Substring(0,partnerIdString.length()-2);
                                system.debug('partnerIdString'+partnerIdString);
                                fields += str+' IN ('+partnerIdString+')';   
                                Mulitple = true; 
                                stop = false;
                                system.debug('');
                            }
                            else{
                                system.debug(fetchdata.get(str).size());
                                system.debug(fetchdata.get(str));
                                innerVar = str+'=';
                            }
                        }
                        //till here
                        else{
                            innerVar = str+'=';
                        }
                        List<String> fieldValues=fetchdata.get(str);
                        if( Mulitple == false){
                            for(Integer i=0;i<fieldValues.size();i++)
                            {
                                if(i==0)
                                {
                                    if(innerVar.contains('like')){
                                        if(fieldValues[i].contains('-'))
                                        {
                                            fields += innerVar+'%'+fieldValues[i]+'%'; 
                                        }
                                        else
                                        {
                                            fields += innerVar+'\'%'+fieldValues[i]+'%'+'\'';    
                                        }
                                    }
                                    else{
                                        if(fieldValues[i].contains('Other'))
                                        {
                                            fields += innerVar+'('+CountryString+')'; 
                                        }
                                        else if(fieldValues[i].contains('-'))
                                        {
                                            fields += innerVar+' '+fieldValues[i]; 
                                        }
                                        else
                                        {   
                                            fields += innerVar+'\''+fieldValues[i]+'\'';    
                                        }
                                    }
                                }else
                                {
                                    fields +=' '+'OR '+innerVar+'\''+fieldValues[i]+'\'';
                                }
                            }
                            if(stop == false){
                                if(fields.contains('(') && fields.contains('Mandate_End_Date__C ') &&  fields.contains('Mandate_End_Date__C = null')){
                                    System.debug('I am getting here 286');
                                    if(fields.contains('))')){
                                        fields += ' )';
                                    }
                                    else{
                                        fields += ' ))';
                                    }        
                                }else{
                                    if(fields.contains('(')){
                                        fields += ' )';        
                                    }
                                }
                            }
                            else{
                                fields += ' ';
                            }
                        }
                        else{
                        }
                    }
                    else
                    {   
                        
                    }
                }
                
                if(fields.contains('AND')){
                    if(fields.contains('IN')){
                        System.debug('I am getting here 303');
                        fields = fields+')';
                    }    
                }else{
                    
                }
                
                System.debug('@@@@'+fields);
                String queryString ;
                queryString  = 'SELECT Id,State__c,Country__c,Company_Name_French__c,Job_description_Id__c,Company__r.Name,Has_Job_Description__c,Industry_Types__c,Name, Company__r.Industry_Types__c, Status__c, Assignment_Status__c, Mandate_Start_Date__c,Job_Function__c,Partner__r.name,Partner_2__r.name,Level__c,Number_of_candidates__c,number_of_days__c From Mandate__c where '+fields+' Limit 49999' ;
                
                System.debug('@@@@'+queryString);
                
               
                
                List<Mandate__c> lstofAssgn =  Database.query(queryString);
                
                count= 0;
                
                system.debug(lstofAssgn);
                Set<Id> mandateIds =  new Set<Id>();
                for(Mandate__C man : lstofAssgn) 
                {
                    Count++;
                    returnList.add(man);
                    mandateIds.add(man.Id);
                }
                
                return returnList;
            }
            catch(Exception e)
            {
                system.debug('Error'+e.getMessage()+'error line'+e.getLineNumber());
                return null;
            }
        }
    }
    
    @AuraEnabled
    public static String deleteRecord(List<Id> idList){
        String res='';
        Database.DeleteResult[] drList= Database.delete(idList,true);
        for(Database.DeleteResult dr : drList) {
            if (dr.isSuccess()) {
                // Operation was successful, so get the ID of the record that was processed
                System.debug('Successfully deleted account with ID: ' + dr.getId());
                res='Success';
            }
            else {
                // Operation failed, so get all errors                
                for(Database.Error err : dr.getErrors()) {
                    System.debug('The following error has occurred.');                    
                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                    System.debug('Account fields that affected this error: ' + err.getFields());
                    res='unSucess';
                }
            }
        }
        return res;
    }
}