public with sharing class AssignmentAddAdvertiseCtrl {
    
    public string reportName{get;set;}
    public string parentId{get;set;}
    private Mandate__c mandate;
    
    public AssignmentAddAdvertiseCtrl(ApexPages.StandardController stdController){  
      this.mandate = [select Id, Name from Mandate__c where Id =: ApexPages.currentPage().getParameters().get('id')];
        if(this.mandate != null){
               reportName = Label.Advertisement_Label+'_'+String.ValueOf(Date.Today());
             //  reportName = fileOptions+'_'+String.valueOf(Date.today());
               
                system.debug('[Nubik_ContactHoganReportCtrl] reportName '+reportName);
                parentId = this.mandate.Id;
                system.debug('[Nubik_ContactHoganReportCtrl] parentId '+parentId);
        }
    }
}