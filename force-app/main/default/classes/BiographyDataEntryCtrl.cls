public class BiographyDataEntryCtrl {
    
    public String contactId {get;set;}
    
    public List<Work_Experience__c> eBiographyList {get;set;}
    
    public List<Work_Experience__c> eduBiographyList {get;set;} 
    
    public List<Work_Experience__c> pBiographyList {get;set;}
    
    public List<Work_Experience__c> bBiographyList {get;set;}
    
    public List<Work_Experience__c> biographyToDelete {get;set;}
    
    public Integer rowToRemove {get;set;}
    
    private Map<String, Id> biographyRecordTypeIdByName;
    private boolean onLoad;
    private List<Work_Experience__c> allWorkExperiences;
    
    public BiographyDataEntryCtrl(){
        /*Test
waAccList = new List<WrapperpaAccountList>();
addNewRowToAccList();
*/
        onLoad = true;
        
        contactId = ApexPages.currentPage().getParameters().get('contactId');
        
        biographyRecordTypeIdByName = BiographyHelper.getBiographyRecordTypeIdByName();
        
        allWorkExperiences = [Select Title__c, Title_FR__c, Start_Year__c, 
                              Name, Id, End_Year__c, Current_del__c, 
                              Contact__c, Company__c, Company_Name__c, 
                              Company_Name_French__c, Add_company_description__c, Location__c , RecordTypeId,Verified__c 
                              From Work_Experience__c
                              Where Contact__c = :contactId
                              order by recordtypeId, Start_Year__c desc];
        
        eBiographyList = new List<Work_Experience__c>();
        addNewExperienceToList();
        
        eduBiographyList = new List<Work_Experience__c>();
        addNewEducationToList();
        
        pBiographyList = new List<Work_Experience__c>();
        addNewProfessionalAToList();
        
        bBiographyList = new List<Work_Experience__c>();
        addNewBoardToList();
        
        biographyToDelete = new List<Work_Experience__c>();
        
        onLoad = false;
        
    }
    
    public Contact contactInfo{
        
        get{
            return [Select Name
                    from Contact
                    where Id = :contactId
                    limit 1];
        }set;
        
    }
    
    public void addNewExperienceToList(){
        Id recordTypeId = biographyRecordTypeIdByName.get('Experience');
        Integer nRows = 1;
        if (onLoad){
            //nRows = 3;
            eBiographyList = BiographyHelper.addExistBiographyList(eBiographyList, recordTypeId, contactId, allWorkExperiences);
        }
        eBiographyList = BiographyHelper.addNewBiographyList(eBiographyList, recordTypeId, contactId, nRows); 
        
    }
    
    public void removeExperienceFromList(){ 
        
        eBiographyList = BiographyHelper.removeRowToBiographyList(rowToRemove, eBiographyList, biographyToDelete);   
        system.debug(':: removeExperienceFromList :: '+eBiographyList); 
    }
    
    public void addNewEducationToList(){
        Id recordTypeId = biographyRecordTypeIdByName.get('Education');
        Integer nRows = 1;
        if (onLoad){
            //nRows = 3;
            eduBiographyList = BiographyHelper.addExistBiographyList(eduBiographyList, recordTypeId, contactId, allWorkExperiences);
        }
        eduBiographyList = BiographyHelper.addNewBiographyList(eduBiographyList, recordTypeId, contactId, nRows);
    }
    
    public void removeEducationFromList(){
        eduBiographyList = BiographyHelper.removeRowToBiographyList(rowToRemove, eduBiographyList, biographyToDelete);     
    }
    
    public void addNewProfessionalAToList(){
        Id recordTypeId = biographyRecordTypeIdByName.get('Professional_Association');
        Integer nRows = 1;
        if (onLoad){
            //nRows = 3;
            pBiographyList = BiographyHelper.addExistBiographyList(pBiographyList, recordTypeId, contactId, allWorkExperiences);
        }
        pBiographyList = BiographyHelper.addNewBiographyList(pBiographyList, recordTypeId, contactId, nRows);
    }
    
    public void removeProfessionalAFromList(){
        pBiographyList = BiographyHelper.removeRowToBiographyList(rowToRemove, pBiographyList, biographyToDelete);     
    }
    
    public void addNewBoardToList(){
        Id recordTypeId = biographyRecordTypeIdByName.get('Professional_Order');
        Integer nRows = 1;
        if (onLoad){
            //nRows = 3;
            bBiographyList = BiographyHelper.addExistBiographyList(bBiographyList, recordTypeId, contactId, allWorkExperiences);
        }
        bBiographyList = BiographyHelper.addNewBiographyList(bBiographyList, recordTypeId, contactId, nRows);    
    }
    
    public void removeBoardFromList(){
        bBiographyList = BiographyHelper.removeRowToBiographyList(rowToRemove, bBiographyList, biographyToDelete);     
    }
    
    
    public PageReference saveBiography() {
        system.debug('controller save method is calling--> '+eBiographyList);
        String language;
        list<Application__c> app =[select id,Mandate__r.Language__c from Application__c where Contact__c =:contactId Limit 1];
        if(app.size() > 0){
            language = app[0].Mandate__r.Language__c;    
        }else{
            language = 'English';
        }
        system.debug('language'+language);
        BiographyDataEntryLightning.createOnePagerOrBioDocs(contactId,'BIO',language);
        BiographyHelper.save(eBiographyList, eduBiographyList, pBiographyList, bBiographyList, biographyToDelete);
        return new PageReference('/'+contactId);
    }
    
    public PageReference cancel() {
        return new PageReference('/'+contactId);
    }
    
    
}