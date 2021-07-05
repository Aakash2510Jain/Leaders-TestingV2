public with sharing class Nubik_ContactAttachCVCtrl {
    
    public String reportName {get;set;}    
    public String parentId {get;set;}    
    private Contact theContact;
    
    public Nubik_ContactAttachCVCtrl(ApexPages.StandardController stdController){       
        this.theContact = [select Id, FirstName, LastName from Contact where Id =: ApexPages.currentPage().getParameters().get('id')];
        if(this.theContact != null){
        	reportName = 'CV_'+theContact.FirstName+' '+theContact.LastName+'_'+String.ValueOf(Date.Today());
        	parentId = this.theContact.Id;
        }
    }
    
    
  
       

}