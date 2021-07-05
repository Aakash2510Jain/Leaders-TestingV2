public class PickListHandler 
{  
    @AuraEnabled
    public static List<Application__c> getAssDetailsFromCon(String ConId){
        List<Application__c> applist  = [SELECT Mandate__R.NAME,Mandate__R.Assignment_Status__c,Mandate__R.Mandate_Start_Date__c,Mandate__R.Company_Name_French__c  FROM Application__c WHERE Contact__c =:ConId];
        return   applist;
    }
    @AuraEnabled
    public static List<String> getFieldsLabelName(){
        Peoplelist__c searchPeople=Peoplelist__c.getValues('Contact');
        String FieldLabel=searchPeople.FieldLabelName__c;
        List<String> fieldsLabelName=FieldLabel.split(',');
        return fieldsLabelName;
    }
    @AuraEnabled
    public static  map<String,List<String>> getFieldsAPIName(){
        Peoplelist__c searchPeople=Peoplelist__c.getValues('Contact');
        map<String,List<String>> apiNameByLevelName = new map<String,List<String>>();
        String FieldApi=searchPeople.FieldApiName__c;
        String FieldLabel=searchPeople.FieldLabelName__c;
        List<String> fieldsLabelName=FieldLabel.split(',');
        List<String> fieldsAPIName=FieldApi.split(',');
        apiNameByLevelName.put('API',fieldsAPIName);
        apiNameByLevelName.put('Label',fieldsLabelName);
        return apiNameByLevelName;
    }
    
    public static List<Id> getOPRContaingKeyword(String SearchWord){
        
        string value = '';
        value = SearchWord;
        List<String> OpString = new    List<String>();
        if(value.contains(',')){
            OpString = value.split(',');
        }else{
            OpString.add(value);
        }
        List<Id> OPRContainingKey = new List<Id>();
        
        List<One_Pager_Response__c> OPRData = [SELECT Id,One_Pager__c,Application__c,Response_Fr__c,Response__c FROM One_Pager_Response__c ];
        system.debug('OPRContainingKey'+OPRData);
        for(One_Pager_Response__c opr:OPRData){
            for(String Keyword:OpString){
                if((opr.Response_Fr__c != null && opr.Response_Fr__c.contains(Keyword)) || (opr.Response__c != null && opr.Response__c.contains(Keyword) || (opr.Response__c != null && opr.Response__c.contains(Keyword.capitalize())) || (opr.Response_Fr__c != null && opr.Response_Fr__c.contains(Keyword.capitalize())) || (opr.Response__c != null && opr.Response__c.contains(Keyword.toUpperCase())) || (opr.Response_Fr__c != null && opr.Response_Fr__c.contains(Keyword.toUpperCase())) || (opr.Response__c != null && opr.Response__c.contains(Keyword.toLowerCase()))) || (opr.Response_Fr__c != null && opr.Response_Fr__c.contains(Keyword.toLowerCase()) )){
                    OPRContainingKey.add(opr.Application__c);
                }    
            }
        }
        system.debug('OPRContainingKey'+OPRContainingKey.size());
        return OPRContainingKey;
    }
    
    public static Integer count;
    @AuraEnabled
    public static String[] picklist_values(String object_name, String field_name) 
    {
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
            pickvalByFieldName.put(str,picklist_values(obj,str));
        }
        return pickvalByFieldName;   
    }
    
    
    @Auraenabled
    public static List<contactWrapper> getPeopleRec(Map<String,List<String>> fetchdata,String BooleanSearchValue,String opSearchValue)
    {
        
        system.debug('BooleanSearchValue'+BooleanSearchValue);
        system.debug('opSearchValue'+opSearchValue);
        Boolean booleanSearch = false;
        Boolean OnePagerSearch = false;
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
        if(!String.isEmpty(opSearchValue)){
            OnePagerSearch = true; 
        }
        system.debug('booleanSearch'+booleanSearch);
        system.debug('opSearchValue'+OnePagerSearch);
        system.debug('searchTerms'+searchTerms);
        Map<String, Integer> nbCVByContactId = new Map<String, Integer>();
        Map<String, Integer> nbOnePagerByContactId = new Map<String, Integer>();
        Map<String, String> lastCVByContactId = new Map<String, String>();
        Map<String, String> lastOnepagerByContactId = new Map<String, String>();
        Map<String, Boolean> AssDetailsByContactId = new Map<String, Boolean>();
        
        try{
            if(booleanSearch == true ){
                String queryString = 'FIND {'+searchTerms+'} IN ALL FIELDS RETURNING Contact(id,Name,Title,Account.Id,Account.Name,Email,MobilePhone,Phone,Office_Country__c,Office_State__c,Country__c,State__c,Company_Name_French__c ,hasCV__c,LinkedIn_URL__c)' ;  
                List<List<SObject>>searchList=search.query(queryString);	
                system.debug('searchList'+searchList);
                List<Contact> BooleanData  = new List<Contact>();  
                BooleanData =  ((List<Contact>)searchList[0]);
                system.debug('BooleanData'+BooleanData);
                Map<Id,Id> AppIDByContactId = new Map<Id,Id>();
                List<Contact> returnList = new List<Contact>();
                Set<Id> contactIds =  new Set<Id>();
                integer count = 0;
                for(Contact con : BooleanData) 
                {
                    Count++;
                    returnList.add(con);
                    contactIds.add(con.Id);
                }
               
                List<application__C> appListByCon = [select id,Contact__c from application__c where Contact__c in:contactIds];
                for(application__C app:appListByCon){
                    AppIDByContactId.put(app.Id,app.Contact__c);
                }
                system.debug('AppIDByContactId'+AppIDByContactId);
                if(!contactIds.isEmpty()) {
                    for(AggregateResult result: [SELECT ParentId, COUNT(Id) FROM Attachment WHERE ParentId IN :contactIds AND Name LIKE 'CV%' GROUP BY ParentId]) {
                        if(Integer.valueOf(result.get('expr0'))>0) {
                            nbCVByContactId.put(String.valueOf(result.get('ParentId')),Integer.valueOf(result.get('expr0')));
                        }
                    }
                    
                    for(AggregateResult result: [SELECT ParentId, COUNT(Id) FROM Attachment WHERE ParentId IN :AppIDByContactId.keySet() AND Name LIKE 'One Pag%' GROUP BY ParentId]) {
                        if(Integer.valueOf(result.get('expr0'))>0) {
                            nbOnePagerByContactId.put(String.valueOf(AppIDByContactId.get(String.valueOf(result.get('ParentId')))),Integer.valueOf(result.get('expr0')));
                        }
                    }
                    for(Attachment result: [SELECT Id, ParentId FROM Attachment WHERE ParentId IN :contactIds AND Name LIKE 'CV%' ORDER BY LastModifiedDate ASC]) {
                        lastCVByContactId.put(String.valueOf(result.ParentId),String.valueOf(result.Id));
                        
                    }
                    for(Attachment result: [SELECT Id, ParentId FROM Attachment WHERE ParentId IN :AppIDByContactId.keySet() AND Name LIKE 'One Pag%' ORDER BY LastModifiedDate ASC]) {
                        lastOnepagerByContactId.put(String.valueOf(AppIDByContactId.get(String.valueOf(result.get('ParentId')))),String.valueOf(result.Id));
                     }
                    List<Application__c> Applist = [SELECT Mandate__R.NAME,Mandate__R.Assignment_Status__c,Mandate__R.Mandate_Start_Date__c,Contact__c  FROM Application__c WHERE Contact__c IN :contactIds LIMIT 13000];
                    
                    for(Application__c appRec :Applist){
                        AssDetailsByContactId.put(appRec.Contact__c,true);
                    }
                    
                    system.debug('AssDetailsByContactId'+AssDetailsByContactId);
                    
                }
                List<contactWrapper> cWrapperList = new List<contactWrapper>();
                for(Contact aC :BooleanData ){
                    contactWrapper aCW = new contactWrapper(aC);
                    
                    if(nbCVByContactId.containsKey(aC.Id)) 
                    {
                        aCW.hasCV = true;
                        if(lastCVByContactId.containsKey(String.valueOf(aC.Id)))
                            aCW.cvId = lastCVByContactId.get(String.valueOf(aC.Id));   
                    }
                    if(nbOnePagerByContactId.containsKey(aC.Id)){
                        aCW.hasOnePager = true;
                        aCW.onePagerId= lastOnepagerByContactId.get(String.valueOf(aC.Id));
                    }
                    if(AssDetailsByContactId.containsKey(aC.Id) && (AssDetailsByContactId.get(aC.Id) == true)){
                        aCW.IsAssAvailable = true;
                    }
                    
                    cWrapperList.add(aCW);
                    
                }
                return cWrapperList;
                //return BooleanData;    
            }
            else if(OnePagerSearch == true){
                Boolean first = true;
                
                List<ID> AppIds = PickListHandler.getOPRContaingKeyword(opSearchValue);
                
                List<Id> ConIds = new List<Id>();
               
                system.debug('AppIds'+AppIds);
                List<Application__c> ConidsFromApp = [SELECT Contact__c FROM Application__c where ID IN:AppIds ];
                for(Application__c op : ConidsFromApp){
                    ConIds.add(op.Contact__c);
                }
                system.debug('ConIds'+ConIds);
                List<Contact> BooleanData = [select id,Name,Title,Account.Id,Account.Name,Email,MobilePhone,Phone,Office_Country__c,Office_State__c,Country__c,State__c,Company_Name_French__c ,hasCV__c,LinkedIn_URL__c from Contact  where Id IN:ConIds Limit 13000];
                system.debug('BooleanData'+BooleanData);
                List<Contact> returnList = new List<Contact>();
                Map<Id,Id> AppIDByContactId = new Map<Id,Id>();
                Set<Id> contactIds =  new Set<Id>();
                integer count = 0;
                for(Contact con : BooleanData) 
                {
                    Count++;
                    returnList.add(con);
                    contactIds.add(con.Id);
                }
                
                
                List<application__C> appListByCon = [select id,Contact__c from application__c where Contact__c in:contactIds];
                for(application__C app:appListByCon){
                    AppIDByContactId.put(app.Id,app.Contact__c);
                }
                if(!contactIds.isEmpty()) {
                    for(AggregateResult result: [SELECT ParentId, COUNT(Id) FROM Attachment WHERE ParentId IN :contactIds AND Name LIKE 'CV%' GROUP BY ParentId]) {
                        if(Integer.valueOf(result.get('expr0'))>0) {
                            nbCVByContactId.put(String.valueOf(result.get('ParentId')),Integer.valueOf(result.get('expr0')));
                        }
                    }
                    
                    for(AggregateResult result: [SELECT ParentId, COUNT(Id) FROM Attachment WHERE ParentId IN :AppIDByContactId.keySet() AND Name LIKE 'One Pag%' GROUP BY ParentId]) {
                        if(Integer.valueOf(result.get('expr0'))>0) {
                            nbOnePagerByContactId.put(String.valueOf(AppIDByContactId.get(String.valueOf(result.get('ParentId')))),Integer.valueOf(result.get('expr0')));
                        }
                    }
                    for(Attachment result: [SELECT Id, ParentId FROM Attachment WHERE ParentId IN :contactIds AND Name LIKE 'CV%' ORDER BY LastModifiedDate ASC]) {
                        lastCVByContactId.put(String.valueOf(result.ParentId),String.valueOf(result.Id));
                        
                    }
                    for(Attachment result: [SELECT Id, ParentId FROM Attachment WHERE ParentId IN :AppIDByContactId.keySet() AND Name LIKE 'One Pag%' ORDER BY LastModifiedDate ASC]) {
                          lastOnepagerByContactId.put(String.valueOf(AppIDByContactId.get(String.valueOf(result.get('ParentId')))),String.valueOf(result.Id));
                     }
                    List<Application__c> Applist = [SELECT Mandate__R.NAME,Mandate__R.Assignment_Status__c,Mandate__R.Mandate_Start_Date__c,Contact__c  FROM Application__c WHERE Contact__c IN :contactIds LIMIT 13000];
                    
                    for(Application__c appRec :Applist){
                        AssDetailsByContactId.put(appRec.Contact__c,true);
                    }
                    
                    system.debug('AssDetailsByContactId'+AssDetailsByContactId);
                    
                }
                List<contactWrapper> cWrapperList = new List<contactWrapper>();
                for(Contact aC :BooleanData ){
                    contactWrapper aCW = new contactWrapper(aC);
                    
                    if(nbCVByContactId.containsKey(aC.Id)) 
                    {
                        aCW.hasCV = true;
                        if(lastCVByContactId.containsKey(String.valueOf(aC.Id)))
                            aCW.cvId = lastCVByContactId.get(String.valueOf(aC.Id));   
                    }
                    if(nbOnePagerByContactId.containsKey(aC.Id)){
                        aCW.hasOnePager = true;
                        aCW.onePagerId= lastOnepagerByContactId.get(String.valueOf(aC.Id));
                    }
                    if(AssDetailsByContactId.containsKey(aC.Id) && (AssDetailsByContactId.get(aC.Id) == true)){
                        aCW.IsAssAvailable = true;
                        // aCW.onePagerId= lastOnepagerByContactId.get(String.valueOf(aC.Id));
                    }
                    
                    cWrapperList.add(aCW);
                    
                }
                return cWrapperList; 
            }
            else{
                List<String> fieldvalue = new List<String>();
                
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
                
                
                String fields = '';
                String innerVar;
                integer j = 0;
                for(String str : fetchdata.keySet())
                {j++;
                    if(fetchData.get(str) !=null && !fetchData.get(str).isEmpty())
                    {
                        if(fields.length() == 0)
                        {
                            fields += ' (';
                        }
                        else if(str == 'Country__c'){
                            if(j == 1){
                                fields += ' ( ';
                            }else{
                                fields += ' AND ( ';   
                            }
                        
                        }
                        else{
                            fields += ' AND (';
                        }
                        if(str == 'Title'){
                            innerVar =  str+' Like ';
                        }
                        else if(str == 'Country__c' && fetchdata.get('Country__c')[0] == 'Other'){
                            innerVar = str+' NOT IN ';
                        }
                        else{
                            innerVar = str+' = ';    
                        }
                        List<String> fieldValues=fetchdata.get(str);
                        
                        for(Integer i=0;i<fieldValues.size();i++)
                        {
                            String searchKey ='';
                            
                            if(innerVar.contains('Title')){
                                searchKey = '\''+'%'+fieldValues[i].escapeUnicode()+'%'+'\'';
                            }
                            else{
                                searchKey = '\''+fieldValues[i].escapeUnicode()+'\'';
                            }
                            if(i==0)
                            {
                                if(fieldValues[i].contains('Other'))
                                {
                                    fields += innerVar+'('+CountryString+')'; 
                                }
                                else{
                                    fields += innerVar+searchKey;
                                }   
                            }
                            else
                            {
                                if(fieldValues[i].contains('Other'))
                                {
                                    fields += innerVar+'('+CountryString+')'; 
                                }else{
                                    fields +=' '+'OR '+innerVar+'\''+fieldValues[i]+'\'';    
                                }
                                
                            }
                        }
                        fields += ' )';
                    }
                    else
                    {
                        
                    }
                }
                System.debug('@@@@'+fields);
                System.debug('@@@@booleanSearch'+booleanSearch);
                String  queryString = 'select id,Name,Title,Account.Id,Account.Name,Email,MobilePhone,Phone,Office_Country__c,Office_State__c,Country__c,State__c,Company_Name_French__c ,hasCV__c,LinkedIn_URL__c from Contact  where'+fields+' Limit 13000' ;
                
                System.debug('@@@@'+queryString);
                
                List<Contact> returnList = new List<Contact>();
                
                List<Contact> lstofPeople =  Database.query(queryString);
                
                count= 0;
                
                system.debug(lstofPeople);
                Set<Id> contactIds =  new Set<Id>();
                Map<Id,Id> AppIDByContactId = new Map<Id,Id>();
                
                for(Contact con : lstofPeople) 
                {
                    Count++;
                    returnList.add(con);
                    contactIds.add(con.Id);
                }
                
                List<application__C> appListByCon = [select id,Contact__c from application__c where Contact__c in:contactIds limit 13000];
                for(application__C app:appListByCon){
                    AppIDByContactId.put(app.Id,app.Contact__c);
                }
                
                
                if(!contactIds.isEmpty()) {
                    for(AggregateResult result: [SELECT ParentId, COUNT(Id) FROM Attachment WHERE ParentId IN :contactIds AND Name LIKE 'CV%' GROUP BY ParentId]) {
                        if(Integer.valueOf(result.get('expr0'))>0) {
                            nbCVByContactId.put(String.valueOf(result.get('ParentId')),Integer.valueOf(result.get('expr0')));
                        }
                    }
                    
                    for(AggregateResult result: [SELECT ParentId, COUNT(Id) FROM Attachment WHERE ParentId IN :AppIDByContactId.keySet() AND Name LIKE 'One Pag%' GROUP BY ParentId]) {
                        if(Integer.valueOf(result.get('expr0'))>0) {
                            nbOnePagerByContactId.put(String.valueOf(AppIDByContactId.get(String.valueOf(result.get('ParentId')))),Integer.valueOf(result.get('expr0')));
                        }
                    }
                    for(Attachment result: [SELECT Id, ParentId FROM Attachment WHERE ParentId IN :contactIds AND Name LIKE 'CV%' ORDER BY LastModifiedDate ASC]) {
                        lastCVByContactId.put(String.valueOf(result.ParentId),String.valueOf(result.Id));
                    }
                    for(Attachment result: [SELECT Id, ParentId FROM Attachment WHERE ParentId IN :contactIds AND Name LIKE 'One Pag%' ORDER BY LastModifiedDate ASC]) {
                        lastOnepagerByContactId.put(String.valueOf(AppIDByContactId.get(String.valueOf(result.get('ParentId')))),String.valueOf(result.Id));
                        
                    }
                    List<Application__c> Applist = [SELECT Mandate__R.NAME,Mandate__R.Assignment_Status__c,Mandate__R.Mandate_Start_Date__c,Contact__c  FROM Application__c WHERE Contact__c IN :contactIds LIMIT 13000];
                    
                    for(Application__c appRec :Applist){
                        AssDetailsByContactId.put(appRec.Contact__c,true);
                    }
                    
                    system.debug('AssDetailsByContactId'+AssDetailsByContactId);
                    
                }
                List<contactWrapper> cWrapperList = new List<contactWrapper>();
                for(Contact aC :lstofPeople ){
                    contactWrapper aCW = new contactWrapper(aC);
                    
                    if(nbCVByContactId.containsKey(aC.Id)) 
                    {
                        aCW.hasCV = true;
                        if(lastCVByContactId.containsKey(String.valueOf(aC.Id)))
                            aCW.cvId = lastCVByContactId.get(String.valueOf(aC.Id));   
                    }
                    if(nbOnePagerByContactId.containsKey(aC.Id)){
                        aCW.hasOnePager = true;
                        aCW.onePagerId= lastOnepagerByContactId.get(String.valueOf(aC.Id));
                    }
                    if(AssDetailsByContactId.containsKey(aC.Id) && (AssDetailsByContactId.get(aC.Id) == true)){
                        aCW.IsAssAvailable = true;
                        // aCW.onePagerId= lastOnepagerByContactId.get(String.valueOf(aC.Id));
                    }
                    
                    cWrapperList.add(aCW);
                    
                }
                return cWrapperList;
            }
        }catch(Exception e){
            System.debug('@@@@'+e.getMessage()+' AT '+e.getLineNumber()+' STACKTRACE '+e.getStackTraceString());
            throw new AuraHandledException('Error :'+e.getMessage() +'at '+ e.getLineNumber());
        }
    }
    public class contactWrapper
    {
        @AuraEnabled
        public Contact theContact {get;set;}
        @AuraEnabled
        public boolean hasCV {get;set;}
        @AuraEnabled
        public boolean hasOnePager {get;set;}
        @AuraEnabled
        public String cvId {get;set;}
        @AuraEnabled
        public String onePagerId {get;set;}
        @AuraEnabled
        public Boolean IsAssAvailable {get;set;}
        
        public contactWrapper(Contact aContact)
        {
            hasCV = false;
            hasOnePager = false;
            IsAssAvailable = false;
            theContact = aContact;
        }
    }
    
    @AuraEnabled 
    public static Map<String, List<String>> getDependentMap(sObject objDetail, string contrfieldApiName,string depfieldApiName) 
    {
        String controllingField = contrfieldApiName.toLowerCase();
        String dependentField = depfieldApiName.toLowerCase();
        
        Map<String,List<String>> objResults = new Map<String,List<String>>();
        
        Schema.sObjectType objType = objDetail.getSObjectType();
        if (objType==null){
            return objResults;
        }
        
        Map<String, Schema.SObjectField> objFieldMap = objType.getDescribe().fields.getMap();
        
        if (!objFieldMap.containsKey(controllingField) || !objFieldMap.containsKey(dependentField)){
            return objResults;     
        }
        
        Schema.SObjectField theField = objFieldMap.get(dependentField);
        Schema.SObjectField ctrlField = objFieldMap.get(controllingField);
        
        List<Schema.PicklistEntry> contrEntries = ctrlField.getDescribe().getPicklistValues();
        List<PicklistEntryWrapper> depEntries = wrapPicklistEntries(theField.getDescribe().getPicklistValues());
        List<String> controllingValues = new List<String>();
        
        for (Schema.PicklistEntry ple : contrEntries) {
            String label = ple.getLabel();
            objResults.put(label, new List<String>());
            controllingValues.add(label);
        }
        
        for (PicklistEntryWrapper plew : depEntries) {
            String label = plew.label;
            String validForBits = base64ToBits(plew.validFor);
            for (Integer i = 0; i < validForBits.length(); i++) {
                String bit = validForBits.mid(i, 1);
                if (bit == '1') 
                {
                    objResults.get(controllingValues.get(i)).add(label);
                }
            }
        }
        return objResults;
    }
    public static String decimalToBinary(Integer val) {
        String bits = '';
        while (val > 0) {
            Integer remainder = Math.mod(val, 2);
            val = Integer.valueOf(Math.floor(val / 2));
            bits = String.valueOf(remainder) + bits;
        }
        return bits;
    }
    
    public static String base64ToBits(String validFor) {
        if (String.isEmpty(validFor)) return '';
        
        String validForBits = '';
        
        for (Integer i = 0; i < validFor.length(); i++) {
            String thisChar = validFor.mid(i, 1);
            Integer val = base64Chars.indexOf(thisChar);
            String bits = decimalToBinary(val).leftPad(6, '0');
            validForBits += bits;
        }
        
        return validForBits;
    }
    
    private static final String base64Chars = '' +
        'ABCDEFGHIJKLMNOPQRSTUVWXYZ' +
        'abcdefghijklmnopqrstuvwxyz' +
        '0123456789+/';
    
    private static List<PicklistEntryWrapper> wrapPicklistEntries(List<Schema.PicklistEntry> PLEs) {
        return (List<PicklistEntryWrapper>)
            JSON.deserialize(JSON.serialize(PLEs), List<PicklistEntryWrapper>.class);
    }
    public class PicklistEntryWrapper{
        public String active {get;set;}
        public String defaultValue {get;set;}
        public String label {get;set;}
        public String value {get;set;}
        public String validFor {get;set;}
        public PicklistEntryWrapper(){            
        }
    }
}