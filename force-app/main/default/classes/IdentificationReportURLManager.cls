/* **************************************************************************
* Class: IdentificationReportURLManager
* Created by Jesus Varela - C072136, 10/31/2014
*
* Purpose/Methods:
* - return conga url with language
*
* Unit Test: 
* 
* Modifications:
*
************************************************************************** */
public class IdentificationReportURLManager {
	public static string getOnePagerURL(Contact c, string language){
		string url = c.One_Pager_Conga_Link__c;
		if(language.toLowerCase() == 'english'){
			url = c.One_Pager_Conga_Link__c.replace(c.One_Pager_Template_FR__c, c.One_Pager_Template_EN__c);
		}else{
			url = c.One_Pager_Conga_Link__c.replace(c.One_Pager_Template_EN__c, c.One_Pager_Template_FR__c);
		}
		return url; 
	}
	public static string getCandidateBiographyURL(Contact c, string language){
		string url = c.Candidate_Biography_Conga_Link__c;
		if(language.toLowerCase() == 'english'){
			url = c.Candidate_Biography_Conga_Link__c.replace(c.Candidate_Biography_Template_FR__c, c.Candidate_Biography_Template_EN__c);
		}else{
			url = c.Candidate_Biography_Conga_Link__c.replace(c.Candidate_Biography_Template_EN__c, c.Candidate_Biography_Template_FR__c);
		}
		return url;
	}
    
    public static string getHumanCapitalStudyContactURL(Contact c, string language){
		string url = c.Human_Capital_Conga_Link__c; 
		if(language.toLowerCase() == 'english'){
			url = c.Human_Capital_Conga_Link__c.replace(c.Human_Capital_Template_FR__c, c.Human_Capital_Template_EN__c);
			
		}else{
			url = c.Human_Capital_Conga_Link__c.replace(c.Human_Capital_Template_EN__c, c.Human_Capital_Template_FR__c);
			
		}
		return url;
	}
    
    public static string getHumanCapitalStudyQueryURL(Mandate__c m,String queryId, string language)
    {
        System.debug(m.Human_Capital_Coleman_Conga_Link__c);
        
		string url = m.Human_Capital_Coleman_Conga_Link__c.replace('[queryId]',queryId); 
	   
		return url;
	}
    
    
    
	public static string getHumanCapitalStudyURL(Mandate__c m, string language){
		string url = m.Human_Capital_Conga_Link__c;
		if(language.toLowerCase() == 'english'){
			url = m.Human_Capital_Conga_Link__c.replace(m.Human_Capital_Template_FR__c, m.Human_Capital_Template_EN__c);
			url = url.replace(m.Human_Capital_Report_FR__c, m.Human_Capital_Report_EN__c);
		}else{
			url = m.Human_Capital_Conga_Link__c.replace(m.Human_Capital_Template_EN__c, m.Human_Capital_Template_FR__c);
			url = url.replace(m.Human_Capital_Report_EN__c, m.Human_Capital_Report_FR__c);
		}
		return url;
	}
    
    public static string getHumanCapitalStudySSLURL(Mandate__c m, string language){
       string url = m.Human_Capital_SSL_Conga_Link__c;
        if(language.toLowerCase() == 'english'){
            url = m.Human_Capital_SSL_Conga_Link__c.replace(m.Human_Capital_Template_FR__c,m.Human_Capital_Template_EN__c);
            url = url.replace(m.Human_Capital_SSL_Report_FR__c, m.Human_Capital_SSL_Report_EN__c);
        }else{
			url = m.Human_Capital_SSL_Conga_Link__c.replace(m.Human_Capital_Template_EN__c, m.Human_Capital_Template_FR__c);
			url = url.replace(m.Human_Capital_SSL_Report_EN__c, m.Human_Capital_SSL_Report_FR__c);
		}
		return url;
    }
    
    
	public static string getPotentialCandidateURL(Mandate__c m, string language){
		string url = m.Potential_Candidates_Conga_Link_2__c;
		if(language.toLowerCase() == 'english'){
			url = m.Potential_Candidates_Conga_Link_2__c.replace(m.Potential_Candidates_Template_FR__c, m.Potential_Candidates_Template_EN__c);
		}else{
			url = m.Potential_Candidates_Conga_Link_2__c.replace(m.Potential_Candidates_Template_EN__c, m.Potential_Candidates_Template_FR__c);
		}
		return url;
	}
	public static string getCoverURL(Mandate__c m, string language){
		system.debug(':: getCoverURL Mandate__c ::'+m);
		string url = m.Cover_Conga_Link__c;
		system.debug(':: getCoverURL url ::'+url);
		if(language.toLowerCase() == 'english'){
			url = m.Cover_Conga_Link__c.replace(m.Cover_Template_FR__c, m.Cover_Template_EN__c);
		}else{
			url = m.Cover_Conga_Link__c.replace(m.Cover_Template_EN__c, m.Cover_Template_FR__c);
		}
		return url;
	}
	
	/*** Chart Reports ***/
	public static string getCandidateByGenderURL(Mandate__c m, string language){
		string url = m.candidate_gender_conga_link__c;
		if(language.toLowerCase() == 'english'){
			url = m.candidate_gender_conga_link__c.replace(m.Candidate_gender_template_FR__c, m.Candidate_gender_template_EN__c);
		}else{
			url = m.candidate_gender_conga_link__c.replace(m.Candidate_gender_template_EN__c, m.Candidate_gender_template_FR__c);
		}
		return url;
	}
	/*** End Chart Reports ***/
	
}