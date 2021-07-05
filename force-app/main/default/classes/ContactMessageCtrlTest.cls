@isTest
public class ContactMessageCtrlTest {
	
	public static Contact contact {get;set;}
	
	public static void CreateData(){
		
		Account acc = new Account(Name = 'Test Account', Off_Limit__c =  true);
    	insert acc;
    	
    	contact = new Contact(LastName = 'Test', AccountId = acc.Id);
    	insert contact;
		
	}
	
	@isTest
	public static void showMessageTest (){
		
		CreateData();
		
		ApexPages.StandardController sc = new ApexPages.StandardController(contact);
		
		ContactMessageCtrl ctrl = new ContactMessageCtrl(sc);
		ctrl.init();
		
	}
}