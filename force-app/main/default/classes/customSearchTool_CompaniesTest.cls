/*
*	Name: customSearchTool_CompaniesTest
*	Test class for customSearchTool_Companies Controller 
* 	C113860 - Cristina Sananez
*	02/26/2016
*/


@isTest
public class customSearchTool_CompaniesTest {

    public static testMethod void testMyController() {
        
        PageReference pageRef = new PageReference('customSearchTool_Companies');
        Test.setCurrentPage(pageRef);
     	
     	customSearchTool_Companies controller = new customSearchTool_Companies();
        
        //Test Load all the picklists
        controller.getFilterCriteria();
        controller.getStatus();
        controller.getIndustries();
        controller.getIndustriesFR();
        
        controller.getCountries();
        controller.getStates();
        
        
        controller.resetFilters();
        controller.addToRS();
        
        Integer i=0;
        
        for (i=0;i==2;i++){
        	
        	Account c=new Account(Name='Name'+i);
        	customSearchTool_Companies.companyWrapper cw = new customSearchTool_Companies.companyWrapper(c);
        	controller.cWrapperList.add(cw);
        	
        }
        
        //select value from picklists
        controller.fCriteria='AND';
        controller.industryFilter.add(Account.Industry.getDescribe().getPicklistValues()[0].getValue());
        
        
        PageReference page=controller.searchCompanies();
        
        
        controller.searchCompaniesBegining();
        
        controller.Beginning();
        controller.Previous();
        controller.Next();
        controller.End();
        controller.getDisablePrevious();
        controller.getDisableNext();
        controller.getTotal_size();
        controller.getPageNumber();
        controller.getTotalPages();
        
        
        
    }
    
}