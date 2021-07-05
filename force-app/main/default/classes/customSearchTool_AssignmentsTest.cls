/*
*	Name: customSearchTool_AssignmentsTest
*	Test class for customSearchTool_Assignments Controller 
* 	C113860 - Cristina Sananez
*	02/26/2016
*/


@isTest
public class customSearchTool_AssignmentsTest {

    public static testMethod void testMyController() {
        
        PageReference pageRef = new PageReference('customSearchTool_Assignments');
        Test.setCurrentPage(pageRef);
     	
     	customSearchTool_Assignments controller = new customSearchTool_Assignments();
        
        //Test Load all the picklists
        controller.getFilterCriteria();
        controller.getStatus();
        controller.getIndustries();
        controller.getIndustriesFR();
        
        controller.getJobFunctions();
        controller.getJobLevels();
        controller.getUsers();
        
        controller.resetFilters();
        
        Integer i=0;
        
        for (i=0;i==2;i++){
        	
        	Mandate__c anAssignment=new Mandate__c(Name='Name'+i);
        	customSearchTool_Assignments.assignmentWrapper cw = new customSearchTool_Assignments.assignmentWrapper(anAssignment);
        	controller.aWrapperList.add(cw);
        	
        }
        
        //select value from picklists
        controller.fCriteria='AND';
        controller.statusFilter.add(Mandate__c.Status__c.getDescribe().getPicklistValues()[0].getValue());
        controller.industryFilter.add(Account.Industry.getDescribe().getPicklistValues()[0].getValue());
    //    controller.industryFilterFR.add(Account.Industries__c.getDescribe().getPicklistValues()[0].getValue());
        controller.jobFunctionFilter.add(Mandate__c.Job_Function__c.getDescribe().getPicklistValues()[0].getValue());
        controller.jobLevelFilter.add(Mandate__c.Level__c.getDescribe().getPicklistValues()[0].getValue());
        
        
        PageReference page=controller.searchAss();
        
        
        controller.searchAssBegining();
        
        controller.Beginning();
        controller.Previous();
        controller.Next();
        controller.End();
        controller.getDisablePrevious();
        controller.getDisableNext();
        controller.getTotal_size();
        controller.getPageNumber();
        controller.getTotalPages();
        controller.getSortDirection();
        controller.setSortDirection('DESC');
        
        
    }
    
}