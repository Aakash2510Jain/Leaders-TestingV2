public class SearchCompanyCtrl {
    @AuraEnabled
    public static List<List<Sobject>> getPEopleDetailsFromCompany(String CompId){
        List<Contact> applist  = [SELECT Id,Email,Name,Phone,Title__c,Title,Company_Name_French__c FROM Contact where AccountId  =:CompId];
        List<Mandate__c> assList  = [SELECT Assignment_Status__c,Mandate_Start_Date__c,Name,Company_Name_French__c,Id FROM Mandate__c WHERE Company__c =:CompId];
        List<List<Sobject>> recList = new List<List<Sobject>>();
        recList.add(applist);
        recList.add(assList);
        return recList;
    }
    @AuraEnabled
    public static List<String> getFieldsLabelName(){
        SearchCompanyColumnList__c searchCompany=SearchCompanyColumnList__c.getValues('Account');
        String FieldLabel=searchCompany.FieldLabelName__c;
        List<String> fieldsLabelName=FieldLabel.split(',');
        return fieldsLabelName;
    }
    @AuraEnabled
    public static List<String> getFieldsAPIName(){
        SearchCompanyColumnList__c searchCompany=SearchCompanyColumnList__c.getValues('Account');
        String FieldLabel=searchCompany.FieldAPIName__c;
        List<String> fieldsAPIName=FieldLabel.split(',');
        return fieldsAPIName;
    }
    @AuraEnabled
    public static Map<String,String> getFields(){
        List<String> labelList=SearchCompanyCtrl.getFieldsLabelName();
        List<String> apiList=SearchCompanyCtrl.getFieldsAPIName();
        Map<String,String> fieldList=new Map<String,String>();
        for(Integer i=0; i<labelList.size(); i++){
            fieldList.put(labelList[i],apiList[i]);
        }
        return fieldList;
    }
    public static List<String> picklist_values(String object_name, String field_name) 
    {
        List<String> values = new List<String>();
        String[] types = new String[]{object_name};
            Schema.DescribeSobjectResult[] results = Schema.describeSObjects(types);
        for(Schema.DescribeSobjectResult res : results) 
        {
            for (Schema.PicklistEntry entry : res.fields.getMap().get(field_name).getDescribe().getPicklistValues()) 
            {
                if (entry.isActive()) {
                    values.add(entry.getValue());
                }
            }
        }
        system.debug('values'+values.size());
        return values;
    }
    @AuraEnabled
    public static Map<String,List<String>> getAllPickListValue(){
        List<String>  countryValues =SearchCompanyCtrl.picklist_values('Contact','Country__c');
        List<String> stateValues=SearchCompanyCtrl.picklist_values('Contact','State__c');
        List<String> industryValues=SearchCompanyCtrl.picklist_values('Account','Industry_Types__c');
        List<String> statusValues=SearchCompanyCtrl.picklist_values('Account','Status__c');
        Map<String,List<String>> pickListValue=new Map<String,List<String>>();
        pickListValue.put('Country__c',countryValues);
        pickListValue.put('Industry_Types__c',industryValues);
        pickListValue.put('State__c',stateValues);
        pickListValue.put('Status__c',statusValues);
        return pickListValue;
    }
    @Auraenabled
    public static List<Account> getAccountRec(Map<String,List<String>> fetchdata,String BooleanSearchValue)
    {
        system.debug('BooleanSearchValue'+BooleanSearchValue);
        Boolean booleanSearch = false;
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
            String queryString = 'FIND {'+searchTerms+'} IN ALL FIELDS RETURNING Account(id,Name,Industry,Status__c,Phone,Website,BillingCountry,BillingState,State__c,Country__c,Industry_Types__c)' ;
            //   String queryString = 'select id,Name,Industry,Status__c,Phone,Website,BillingCountry,BillingState,State__c,Country__c,Industry_Types__c,(Select Id from Contacts) from Account  where'+fields+' Limit 12999' ;
            List<List<Account>>searchList=search.query(queryString);	
            system.debug('searchList'+searchList);
            List<Account> lstofAcc  = new List<Account>();  
            lstofAcc =  ((List<Account>)searchList[0]);
            system.debug('BooleanData'+lstofAcc);
            
            System.debug('@@@@'+queryString);
            List<Account> returnList = new List<Account>();
           // List<Account> lstofAcc =  Database.query(queryString);
            List<String> accIdList = new List<String>();
            Map<String,Boolean> contactByAccountId = new Map<String,Boolean>();
            Map<Id,Integer> NumberOfPeeopleOnAss = new Map<Id,Integer>();
            Map<Id,Integer> NumberOfAssOnCompany = new Map<Id,Integer>();
            Map<String,Account> allAccountList = new Map<String,Account>();
            Map<String,Mandate__c> allManList = new Map<String,Mandate__C>();
            List<AccWrapper> AccountData = new List<AccWrapper>();
            system.debug(lstofAcc);
            integer CountForPeople = 0;
            
            for(Account acc : lstofAcc){
                NumberOfPeeopleOnAss.put(acc.Id,acc.Contacts.size());
                accIdList.add(acc.Id);
                returnList.add(acc);
                allAccountList.put(acc.Id,acc);
            }
            
            for(Mandate__c manRec:[SELECT Id,Company__c FROM Mandate__c WHERE Company__c In:accIdList] ){
                if(NumberOfAssOnCompany.containsKey(manRec.Company__c)){
                    NumberOfAssOnCompany.put(manRec.Company__c,NumberOfAssOnCompany.get(manRec.Company__c)+1);
                }else{
                    NumberOfAssOnCompany.put(manRec.Company__c,1);
                }
            }
            system.debug('NumberOfPeeopleOnAss'+NumberOfPeeopleOnAss);
            system.debug('NumberOfAssOnCompany'+NumberOfAssOnCompany);
            if(!accIdList.isEmpty()){
                for(Contact conRec :[Select Id,Name,AccountId from Contact where AccountId IN:accIdList LIMIT 10000]){
                    if(allAccountList.containsKey(conRec.AccountId)){
                        Account acc = allAccountList.get(conRec.AccountId);
                        acc.Is_Contact_Available__c = true;
                        acc.Total_Contacts__c = NumberOfPeeopleOnAss.get(conRec.AccountId);
                        allAccountList.put(conRec.AccountId,acc);
                    }
                }
            }
            if(!accIdList.isEmpty()){
                for(Mandate__c manRec : [SELECT Assignment_Status__c,Mandate_Start_Date__c,Name,Company_Name_French__c,Id,Company__c FROM Mandate__c WHERE Company__c IN:accIdList LIMIT 10000]){
                    if(allAccountList.containsKey(manRec.Company__c)){
                        Account acc = allAccountList.get(manRec.Company__c);
                        acc.Is_Ass_Available__c = true;
                        acc.Total_Ass__c = NumberOfAssOnCompany.get(manRec.Company__c);
                        allAccountList.put(manRec.Company__c,acc);
                    }
                }
            }
            return allAccountList.values();
        }
        else{
            System.debug('FetchData='+fetchdata);
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
            
            for(String str : fetchdata.keySet()){
                if(!str.equals(null) )
                {
                    if(fields.length() == 0)
                    {
                        fields += ' (';
                    }
                    else if(str == 'Country__c'){
                        fields += ' ';
                    }
                    else
                    {
                        fields += ' AND (';
                    }
                    String innerVar = str+'=';
                    if(str == 'Country__c' && fetchdata.get('Country__c')[0] == 'Other'){
                        innerVar = str+' NOT IN ';
                    }
                    List<String> fieldValues=fetchdata.get(str);
                    for(Integer i=0;i<fieldValues.size();i++)
                    {
                        if(i==0){
                            if(fieldValues[i].contains('Other'))
                            {
                                fields += innerVar+'('+CountryString+')'; 
                            }
                            else{
                                fields += innerVar+'\''+fieldValues[i]+'\'';
                            }
                            
                        }else
                        {
                            if(fieldValues[i].contains('Other'))
                            {
                                fields += innerVar+'('+CountryString+')'; 
                            }
                            fields +=' '+'OR '+innerVar+'\''+fieldValues[i]+'\'';
                        }
                    }
                    fields += ' )';
                }
                else{
                    
                }
            }
            string str='\'Canada\'';
            System.debug('@@@@'+fields);
            String queryString = 'select id,Name,Industry,Status__c,Phone,Website,BillingCountry,BillingState,State__c,Country__c,Industry_Types__c,(Select Id from Contacts) from Account  where'+fields+' Limit 12999' ;
            System.debug('@@@@'+queryString);
            List<Account> returnList = new List<Account>();
            List<Account> lstofAcc =  Database.query(queryString);
            List<String> accIdList = new List<String>();
            Map<String,Boolean> contactByAccountId = new Map<String,Boolean>();
            Map<Id,Integer> NumberOfPeeopleOnAss = new Map<Id,Integer>();
            Map<Id,Integer> NumberOfAssOnCompany = new Map<Id,Integer>();
            Map<String,Account> allAccountList = new Map<String,Account>();
            Map<String,Mandate__c> allManList = new Map<String,Mandate__C>();
            List<AccWrapper> AccountData = new List<AccWrapper>();
            system.debug(lstofAcc);
            integer CountForPeople = 0;
            
            for(Account acc : lstofAcc){
                NumberOfPeeopleOnAss.put(acc.Id,acc.Contacts.size());
                accIdList.add(acc.Id);
                returnList.add(acc);
                allAccountList.put(acc.Id,acc);
            }
            
            for(Mandate__c manRec:[SELECT Id,Company__c FROM Mandate__c WHERE Company__c In:accIdList] ){
                if(NumberOfAssOnCompany.containsKey(manRec.Company__c)){
                    NumberOfAssOnCompany.put(manRec.Company__c,NumberOfAssOnCompany.get(manRec.Company__c)+1);
                }else{
                    NumberOfAssOnCompany.put(manRec.Company__c,1);
                }
            }
            
            system.debug('NumberOfPeeopleOnAss'+NumberOfPeeopleOnAss);
            
            system.debug('NumberOfAssOnCompany'+NumberOfAssOnCompany);
            
            if(!accIdList.isEmpty()){
                for(Contact conRec :[Select Id,Name,AccountId from Contact where AccountId IN:accIdList LIMIT 10000]){
                    if(allAccountList.containsKey(conRec.AccountId)){
                        Account acc = allAccountList.get(conRec.AccountId);
                        acc.Is_Contact_Available__c = true;
                        acc.Total_Contacts__c = NumberOfPeeopleOnAss.get(conRec.AccountId);
                        allAccountList.put(conRec.AccountId,acc);
                    }
                }
            }
            if(!accIdList.isEmpty()){
                for(Mandate__c manRec : [SELECT Assignment_Status__c,Mandate_Start_Date__c,Name,Company_Name_French__c,Id,Company__c FROM Mandate__c WHERE Company__c IN:accIdList LIMIT 10000]){
                    if(allAccountList.containsKey(manRec.Company__c)){
                        Account acc = allAccountList.get(manRec.Company__c);
                        acc.Is_Ass_Available__c = true;
                        acc.Total_Ass__c = NumberOfAssOnCompany.get(manRec.Company__c);
                        allAccountList.put(manRec.Company__c,acc);
                    }
                }
            }
            return allAccountList.values();
        }
    }
    
    public static Integer NumberOfAssFromComp(String AccID){
        List<Mandate__c> assList  = [SELECT Id,Assignment_Status__c,Mandate_Start_Date__c,Name,Company_Name_French__c FROM Mandate__c WHERE Company__c =:AccID];
        Integer NumberOfAss = 0;
        for(Mandate__c con:assList){
            NumberOfAss++;
        }
        system.debug('NumberOfAss'+NumberOfAss);
        return NumberOfAss;
    }
    
    public class AccWrapper
    {
        @AuraEnabled
        public Account AccRec {get;set;}
        @AuraEnabled
        public Integer NumberOfPeople {get;set;}
        @AuraEnabled
        public Integer NumberOFAssignment {get;set;}
    }
    @AuraEnabled
    public static String deleteRecord(List<Id> idList){
        String res='';
        Database.DeleteResult[] drList= Database.delete(idList,true);
        for(Database.DeleteResult dr : drList) {
            if (dr.isSuccess()) {
                System.debug('Successfully deleted account with ID: ' + dr.getId());
                res='Success';
            }
            else {
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