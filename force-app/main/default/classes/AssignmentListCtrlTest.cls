@isTest
public with sharing class AssignmentListCtrlTest {

	public static void CreateData(){
		
		List<Mandate__c> mandates = new List<Mandate__c> ();
		
		Mandate__c m = new Mandate__c();
        m.Name='Mandate test1';
        m.Assignment_Status__c = 'Active';
        
        mandates.add(m);
        
        m = new Mandate__c();
        m.Name='Mandate test2';
        m.Assignment_Status__c = 'Active';
        m.Consultant__c = UserInfo.getUserId();
        
        mandates.add(m);
        
        m = new Mandate__c();
        m.Name='Mandate test3';
        m.Consultant__c = UserInfo.getUserId();
        
        mandates.add(m);
        
        m = new Mandate__c();
        m.Name='Mandate test4';
        m.Consultant__c = UserInfo.getUserId();
        
        mandates.add(m);
        
        insert mandates;
		
	}
	
	@isTest
	static void AssignmentListTest() {
		
		CreateData();		
		  	
    	AssignmentListCtrl ctrl = new AssignmentListCtrl();
    	
    	system.assert(ctrl.listViewType.size() == 4);
    	
    	system.assert(ctrl.assigmentList.size() == 1);
    	
    	ctrl.selectedView = 'All';
    	ctrl.ViewData();
    	system.assert(ctrl.assigmentList.size() == 4);
    	
    	ctrl.selectedView = 'Active';
    	ctrl.ViewData();
    	system.assert(ctrl.assigmentList.size() == 2);
    	
    }

}