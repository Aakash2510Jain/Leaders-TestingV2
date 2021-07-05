@isTest
private class GenerateIdentificationReportBatchTest {

    static testMethod void myUnitTest() {
        Account Acc = new Account(Name = 'test company');
		insert Acc;
        Mandate__c m = new Mandate__c();
        m.Company__c = Acc.Id;
        m.Name = 'Mandate 1';
        insert m;
        
        Mandate__c mandate = [Select Potential_Candidates_Conga_Link__c,
        							 Potential_Candidates_Conga_Link_2__c
        						from Mandate__c
        					   where Id = :m.Id];
        mandate.Potential_Candidates_Conga_Link_2__c = mandate.Potential_Candidates_Conga_Link__c;
        update mandate;
        
        List<Contact> contacts = new List<Contact>();
        for(integer i = 0; i<1; i++){
        	Contact c = new Contact(LastName = 'Candidate '+i, AccountId = Acc.Id);
        	contacts.add(c);
        }
        insert contacts;
        List<Application__c> apps = new List<Application__c>();
        for(Contact c : contacts){
        	Application__c can = new Application__c();
        	can.Contact__c = c.Id;        	
        	can.Potential_Candidate__c = true;
        	can.Status_Summary_Line__c = 'Potential candidate.'; 
        	can.Mandate__c = m.Id;
        	system.debug('candidate '+c);
        	apps.add(can);
        }
        insert apps;
        CongaSession__c cs = new CongaSession__c();
        cs.Name = 'NubikDev';
        cs.Password__c = '12355';
        cs.Username__c = 'test';
        insert cs;
        Test.startTest();
        	system.debug('mandate Id '+m.Id);
        	system.debug([Select Contact__c, Contact__r.FirstName,  
				Contact__r.LastName, Contact__r.One_Pager_Conga_Link__c,
				Contact__r.Candidate_Biography_Conga_Link__c From Application__c 
				where Contact__c != null and Mandate__c = :m.Id 
				AND Potential_Candidate__c = true]);
        	List<String> reportsNames = new List<String> ();
			reportsNames.add(GenerateIdentificationReportBatch.POTENTIAL_CANDIDATES);
			reportsNames.add(GenerateIdentificationReportBatch.HUMAN_CAPITAL_STUDY_ON_MANDATE);
			reportsNames.add(GenerateIdentificationReportBatch.ONE_PAGER);
			reportsNames.add(GenerateIdentificationReportBatch.CANDIDATE_BIOGRAPHY_ON_CONTACT);
			reportsNames.add(GenerateIdentificationReportBatch.CV);
       		//GenerateIdentificationReportBatch c = new GenerateIdentificationReportBatch(reportsNames, 
       		//	m.Id,date.Today().addDays(-30),date.today(),'English', UserInfo.getUserId(),null,null);
       		
       		String candidates = '';
       		for (Contact c : [Select Id from Contact]){
       			candidates += c.Id+',';
       		}
       		
       		GenerateIdentificationReportBatch c = new GenerateIdentificationReportBatch(reportsNames, 
       			m.Id,date.Today().addDays(-30),date.today(),'English', UserInfo.getUserId(),null,null, candidates,'Client',false);
       		Database.executeBatch(c, 1);
       	Test.stopTest();
    }
    static testMethod void generateIdentificationReportPage() {
        Account Acc = new Account(Name = 'test company');
		insert Acc;
        Mandate__c m = new Mandate__c();
        m.Company__c = Acc.Id;
        m.Name = 'Mandate 1';
        insert m;
        List<Contact> contacts = new List<Contact>();
        for(integer i = 0; i<1; i++){
        	Contact c = new Contact(LastName = 'Candidate '+i, AccountId = Acc.Id);
        	contacts.add(c);
        }
        insert contacts;
        List<Application__c> apps = new List<Application__c>();
        for(Contact c : contacts){
        	Application__c can = new Application__c();
        	can.Contact__c = c.Id;        	
        	can.Potential_Candidate__c = true;
        	can.Status_Summary_Line__c = 'Potential candidate.'; 
        	can.Mandate__c = m.Id;
        	system.debug('candidate '+c);
        	apps.add(can);
        }
        insert apps;
        CongaSession__c cs = new CongaSession__c();
        cs.Name = 'NubikDev';
        cs.Password__c = '12355';
        cs.Username__c = 'test';
        insert cs;
        PageReference pageRef = new PageReference('http://Test.com?id='+m.id);
        Test.setCurrentPage(pageRef);
        Test.startTest();
        	Nubik_IdentificationReportController controller = new Nubik_IdentificationReportController(new ApexPages.standardController(m));
        	controller.getLanguages();
        	controller.biographyReport = true;
        	controller.potentialCandidates = true;
        	controller.humanCapitalStudy = true;
        	controller.CV = true;
        	controller.onePager = true;
        	controller.language = 'English';
        	controller.setStartDate(date.today().addDays(-30));
        	controller.setEndDate(date.today());
        	controller.generate();
       	Test.stopTest();
    }
    static testMethod void generateIdentificationReportPageError() {
        Account Acc = new Account(Name = 'test company');
		insert Acc;
        Mandate__c m = new Mandate__c();
        m.Company__c = Acc.Id;
        m.Name = 'Mandate 1';
        insert m;
        List<Contact> contacts = new List<Contact>();
        for(integer i = 0; i<1; i++){
        	Contact c = new Contact(LastName = 'Candidate '+i, AccountId = Acc.Id);
        	contacts.add(c);
        }
        insert contacts;
        List<Application__c> apps = new List<Application__c>();
        for(Contact c : contacts){
        	Application__c can = new Application__c();
        	can.Contact__c = c.Id;        	
        	can.Potential_Candidate__c = true;
        	can.Status_Summary_Line__c = 'Potential candidate.'; 
        	can.Mandate__c = m.Id;
        	system.debug('candidate '+c);
        	apps.add(can);
        }
        insert apps;
        CongaSession__c cs = new CongaSession__c();
        cs.Name = 'NubikDev';
        cs.Password__c = '12355';
        cs.Username__c = 'test';
        insert cs;
        PageReference pageRef = new PageReference('http://Test.com?id='+m.id);
        Test.setCurrentPage(pageRef);
        Test.startTest();
        	Nubik_IdentificationReportController controller = new Nubik_IdentificationReportController(new ApexPages.standardController(m));
        	controller.biographyReport = false;
        	controller.potentialCandidates = false;
        	controller.humanCapitalStudy = false;
        	controller.hoganReport = false;
        	controller.CV = false;
        	controller.onePager = false;
        	controller.setStartDate(null);
        	controller.setEndDate(null);
        	controller.generate();
        	ApexPages.Message[] msgs=ApexPages.getMessages();
			Boolean found = msgs.size()>0;	
			system.debug('test error 1');	
			System.assert(found);
       	Test.stopTest();
    }
    static testMethod void generateIdentificationReportPageError1() {
        Account Acc = new Account(Name = 'test company');
		insert Acc;
        Mandate__c m = new Mandate__c();
        m.Company__c = Acc.Id;
        m.Name = 'Mandate 1';
        insert m;
        List<Contact> contacts = new List<Contact>();
        for(integer i = 0; i<1; i++){
        	Contact c = new Contact(LastName = 'Candidate '+i, AccountId = Acc.Id);
        	contacts.add(c);
        }
        insert contacts;
        List<Application__c> apps = new List<Application__c>();
        for(Contact c : contacts){
        	Application__c can = new Application__c();
        	can.Contact__c = c.Id;        	
        	can.Potential_Candidate__c = true;
        	can.Status_Summary_Line__c = 'Potential candidate.'; 
        	can.Mandate__c = m.Id;
        	system.debug('candidate '+c);
        	apps.add(can);
        }
        insert apps;
        CongaSession__c cs = new CongaSession__c();
        cs.Name = 'NubikDev';
        cs.Password__c = '12355';
        cs.Username__c = 'test';
        insert cs;
        PageReference pageRef = new PageReference('http://Test.com?id='+m.id);
        Test.setCurrentPage(pageRef);
        Test.startTest();
        	Nubik_IdentificationReportController controller = new Nubik_IdentificationReportController(new ApexPages.standardController(m));
        	controller.humanCapitalStudy = true;
        	controller.generate();
        	ApexPages.Message[] msgs=ApexPages.getMessages();
			Boolean found = msgs.size()>0;		
			System.assert(found);
       	Test.stopTest();
    }
    static testMethod void generateIdentificationReportPageError2() {
    	Account Acc = new Account(Name = 'test company');
		insert Acc;
        Mandate__c m = new Mandate__c();
        m.Company__c = Acc.Id;
        m.Name = 'Mandate 1';
        insert m;
    	Attachment attach=new Attachment();   	
    	attach.Name=GenerateIdentificationReportBatch.IDENTIFICATION_NAME+'_'+string.valueOf(datetime.now())+'_'+UserInfo.getUserId()+'.pdf';
    	Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
    	attach.body=bodyBlob;
        attach.parentId=m.id;
        insert attach;
    }
}