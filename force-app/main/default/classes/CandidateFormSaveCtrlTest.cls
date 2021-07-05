@isTest
private class CandidateFormSaveCtrlTest
{
	@isTest
	static void saveCandidate()
	{
			String candidateJSON = '{"lastName":"Test","firstName":"Test","email":"test@ts.com","phoneNumber":"54354333","order":["Association des MBA","Association professionnelle des gestionnaires de project du Québec"],"domains":[{"name":"Droit","competencies":["Assurances","Commerce international"]},{"name":"Comptabilité et finances","competencies":["Financement","Coût de revient"]}],"area":["Asie"],"absence":"À l\'occasion","comittee":"Oui","summary":"Test summary","companiesPrimary":[{"name":"Easycloud","cieType":"Coopérative","secteur":"Aérospatial","revenue":"Entre 25 M$ et 50 M$","startYear":"2016","endYear":"2018"}],"companiesExecutif":[{"name":"Easy Test","cieType":"Coopérative","revenue":"Entre 10 M$ et 25 M$","startYear":"2015"}],"otherOrder":"Autre"}';
			CandidateFormSaveCtrl.saveCandidate(candidateJSON, null, null, null, null);
	}
}