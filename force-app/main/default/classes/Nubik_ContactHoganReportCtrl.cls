/* **************************************************************************
* Controller Class: Nubik_ContactHoganReportCtrl
* Created by Jesus Varela, 11-14-2014
*
* Purpose/Methods:
* - Upload Hogan Report
*

* 
* Modifications:
* - 
*
************************************************************************** */
public with sharing class Nubik_ContactHoganReportCtrl {
	public String reportName {get;set;}    
    public String parentId {get;set;}    
    private Contact theContact;
    
    public Nubik_ContactHoganReportCtrl(ApexPages.StandardController stdController){       
        this.theContact = [select Id, FirstName, LastName from Contact where Id =: ApexPages.currentPage().getParameters().get('id')];
        if(this.theContact != null){
        	reportName = Label.Hogan_Repor_Name+'_'+String.ValueOf(Date.Today());
        	system.debug('[Nubik_ContactHoganReportCtrl] reportName '+reportName);
        	parentId = this.theContact.Id;
        	system.debug('[Nubik_ContactHoganReportCtrl] parentId '+parentId);
        }
    }
}