/*
*	Name: customSearchTool_ContactTest
*	Test class for customSearchTool_Contact Controller 
* 	C113860 - Cristina Sananez
*	02/26/2016
*/


@isTest
public class customSearchTool_ContactTest {

    public static testMethod void testMyController() {
        
        PageReference pageRef = new PageReference('customSearchTool_Contact');
        Test.setCurrentPage(pageRef);
      
        customSearchTool_Contact controller = new customSearchTool_Contact();
        
        //Test Load all the picklists
        controller.getFilterCriteria();
        controller.getFunctionalArea();
        controller.getCompetencies();
        controller.getIndustries();
        controller.getJobLevels();
        controller.getProfDesignations();
        controller.getEducations();
        controller.getLanguages();
        controller.getRegions();
        controller.getGenders();
        
        
        controller.addToAssignment();
        controller.resetFilters();
        
        Integer i=0;
        
        for (i=0;i==2;i++){
        	
        	Contact c=new Contact(LastName='Lastname'+i);
        	customSearchTool_Contact.contactWrapper cw = new customSearchTool_Contact.contactWrapper(c);
        	controller.cWrapperList.add(cw);
        	
        }
        
        //select value from picklists
        controller.fCriteria='AND';
        controller.functionalAreaFilter.add(Contact.Functional_Area_1__c.getDescribe().getPicklistValues()[0].getValue());
        controller.competenciesFilter.add(Contact.Competencies_1__c.getDescribe().getPicklistValues()[0].getValue());
        controller.industryFilter.add(Account.Industry.getDescribe().getPicklistValues()[0].getValue());
        controller.jobLevelFilter.add(Contact.Prof_Title__c.getDescribe().getPicklistValues()[0].getValue());
        controller.educationFilter.add(Contact.Education__c.getDescribe().getPicklistValues()[0].getValue());
        controller.languageFilter.add(Contact.Language_s_Sopken__c.getDescribe().getPicklistValues()[0].getValue());
        controller.regionFilter.add(Contact.Region__c.getDescribe().getPicklistValues()[0].getValue());
        controller.genderFilter.add(Contact.Gender__c.getDescribe().getPicklistValues()[0].getValue());
        
        controller.getFunctionalArea2();
        controller.getFunctionalArea3();
        controller.getFunctionalArea4();
        controller.getCompetencies2();
        controller.getCompetencies3();
        controller.getCompetencies4();
       
        PageReference page=controller.searchContacts();
        
        
        controller.searchContactsBegining();
        
        controller.Beginning();
        controller.Previous();
        controller.Next();
        controller.End();
        controller.getDisablePrevious();
        controller.getDisableNext();
        controller.getTotal_size();
        controller.getPageNumber();
        controller.getTotalPages();
        
        
        
        
        
        
        /*String nextPage = controller.save().getUrl();

        // Verify that page fails without parameters
        System.assertEquals('/apex/failure?error=noParam', nextPage);

        // Add parameters to page URL
        ApexPages.currentPage().getParameters().put('qp', 'yyyy');
      
        // Instantiate a new controller with all parameters in the page
        controller = new thecontroller(); 
        controller.setLastName('lastname');
        controller.setFirstName('firstname');
        controller.setCompany('acme');
        controller.setEmail('firstlast@acme.com');
        nextPage = controller.save().getUrl();

        // Verify that the success page displays
        System.assertEquals('/apex/success', nextPage);
        Lead[] leads = [select id, email from lead where Company = 'acme'];
        System.assertEquals('firstlast@acme.com', leads[0].email);*/
    }
}