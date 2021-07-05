@isTest
public with sharing class OpportunityOwnerTest {
	
	@isTest
	public static void opportunityOwnerTets(){
		
		Account acc = new Account(Name = 'TestAccount');
		insert acc;
		
		Opportunity opp = new Opportunity(
			Name = 'OppTest', 
			AccountId = acc.Id,
			StageName = 'Prospecting',
			CloseDate = Date.today(), 
			Owner__c = UserInfo.getUserId());
		insert opp;
		
		system.assert([Select OwnerId 
		                 from Opportunity 
		                where Id = :opp.Id].OwnerId == UserInfo.getUserId());
		
	}

}