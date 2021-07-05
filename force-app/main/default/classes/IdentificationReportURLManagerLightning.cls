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
*AAAA
************************************************************************** */
public class IdentificationReportURLManagerLightning {
    public static string getOnePagerURL(Application__c app, string language){
       string url = app.One_Pager_Link__c;
        if(language.toLowerCase() == 'english'){
            url = app.One_Pager_Link__c.replace(app.One_Pager_Link__c, app.One_Pager_Link__c);
        }else{
            system.debug('We are in french');
            url = app.One_Pager_Link__c.replace(app.One_Pager_Link__c, app.One_Pager_Link_Fr__c);
            system.debug('url'+url);
        }
        return url; 
    }
    public static string getSelfAssURL(Application__c app, string language){
        
        string url = app.Self_Assesment_Link__c;
        
        if(language.toLowerCase() == 'english'){
            url = app.Self_Assesment_Link__c;
            system.debug('url'+url);
        }else{
            url = app.Self_Assesment_Fr_Link__c;
        }
        
        return url; 
    }
    public static string getCandidateBiographyURL(Contact c, string language)
    {
        string url = c.Candidate_Biography_Conga_Light_Link__c;
        system.debug('URL IS '+url);
        system.debug('teempid IS '+c.Candidate_Biography_Template_Light_EN__c);
        
        if(language.toLowerCase() == 'english'){
            if(c.Additional_Comments__c != null && c.Additional_Comments__c !='')
                url = c.Candidate_Biography_Conga_Light_Link__c.replace('TemplateId=', 'TemplateId='+c.Candidate_Biography_Template_Light_EN__c);
            else{
                url = c.Candidate_Biography_Conga_Light_Link__c.replace('TemplateId=', 'TemplateId='+c.candidate_bio_wo_comment_En__c);
            }
            //url = c.Candidate_Biography_Conga_Light_Link__c.replace(c.Candidate_Biography_Template_Lightning__c, c.Candidate_Biography_Template_Light_FR__c);
        }else{
            //url = c.Candidate_Biography_Conga_Light_Link__c.replace(c.Candidate_Biography_Template_Lightning__c, c.Candidate_Biography_Template_Light_FR__c);
            if(c.Additional_Comments__c != null && c.Additional_Comments__c !='')
                url = c.Candidate_Biography_Conga_Light_Link__c.replace('TemplateId=', 'TemplateId='+c.Candidate_Biography_Template_Light_FR__c);
            else{
                url = c.Candidate_Biography_Conga_Light_Link__c.replace('TemplateId=', 'TemplateId='+c.candidate_bio_wo_comment_Fr__c);
            }
        }
        System.debug('---> cand URL '+url);
        return url;
    }
    
    public static string getCandidateLongForm(Contact c, string language)
    {
        String reportLan = c.Language__c;
        String url = c.Candidate_Long_Form_English_Lightning__c;
        if(reportLan.toLowerCase() == 'english'){
            url = url.replace('TemplateId=', 'TemplateId='+c.New_Long_Form_English_Template__c);
            //url = c.Candidate_Biography_Conga_Light_Link__c.replace(c.Candidate_Biography_Template_Lightning__c, c.Candidate_Biography_Template_Light_EN__c);
        }else{
            url = url.replace('TemplateId=', 'TemplateId='+c.New_Long_Form_FrenchTemplate__c);
        }
        return url;
    }
    
    /*public static String getTemplate(Contact c,String lang){
String reportLan = c.Language__c;
String url = c.Additional_Comments_Link__c;

if(reportLan.toLowerCase() == 'english'){

}else{

}
url = url.replace('TemplateId=', 'TemplateId='+'a0A1k000002p7wK');
return url;
}*/
    public static string getHumanCapitalStudyContactURL(Contact c, string language){
        string url = c.Human_Capital_Conga_Link__c; 
        if(language.toLowerCase() == 'english'){
            url = c.Human_Capital_Conga_Link__c.replace(c.Human_Capital_Template_FR__c, c.Human_Capital_Template_EN__c);
        }else{
            url = c.Human_Capital_Conga_Link__c.replace(c.Human_Capital_Template_EN__c, c.Human_Capital_Template_FR__c);
        }
        return url;
    }
    
    /*   public static string getHumanCapitalStudyQueryURL(Mandate__c m,String queryId, string language){
System.debug(m.Human_Capital_Coleman_Conga_Link__c); 
string url = m.Human_Capital_Coleman_Conga_Link__c.replace('[queryId]',queryId); 

return url;
}*/
    
    
    // originally created by Ajeet backup  
    public static string getHumanCapitalStudyQueryURL(Mandate__c m,String queryId, string language){
        //System.debug(m.Human_Capital_Coleman_Conga_Link__c);
        // string url = m.Human_Capital_Coleman_Conga_Link__c.replace('[queryId]',queryId);
        string url = m.Human_Capital_Conga_Link_Lightning__c.replace('[NOTES]','[NOTES]'+queryId);
        return url;
    }
    
    // Lightning HCS
    public static string getHumanCapitalStudyQueryURL1(Mandate__c m,String queryId, string language){
        /*System.debug(m.Human_Capital_Coleman_Conga_Link__c);
string url = m.Human_Capital_Coleman_Conga_Link__c.replace('[queryId]',queryId);*/
        string url = m.Human_Capital_Conga_Link_Lightning__c.replace('[NOTES]','[NOTES]'+queryId);
        if(language.toLowerCase() == 'english'){
            //url = m.Human_Capital_Conga_Link_Lightning__c.replace('&TemplateId=','&TemplateId='+m.Human_Capital_Template_Lightning_EN__c);
            // url = url.replace(m.Human_Capital_SSL_Report_FR__c, m.Human_Capital_SSL_Report_EN__c);
        }else{
            //url = m.Human_Capital_Conga_Link_Lightning__c.replace('&TemplateId=', '&TemplateId='+m.Human_Capital_Template_Lightning_FR__c);
            // url = url.replace(m.Human_Capital_SSL_Report_EN__c, m.Human_Capital_SSL_Report_FR__c);
        }
        
        return url;
        //return m.Human_Capital_Conga_Link_Lightning__c;
    }
    
    public static string getHumanCapitalStudySSLURL(Mandate__c m, string language,String queryId){
        string url = m.Human_Capital_SSL_Conga_Link_Lightning__c.replace('[queryId]',queryId);
        return url;
    }
    public static string getPotentialCandidateLightningURL(Mandate__c m,String queryId){
        system.debug('getPotentialCandidateLightningURL');
        string url = m.Potential_Candidate_Conga_Lightning__c.replace('[queryId]',queryId);
        return url;
    }
    public static string getPotentialCandidateForCandidateToDiscuss(Mandate__c m,String queryId,String language){
        system.debug('getPotentialCandidateLightningURL');
         string url ;
        if(language.toLowerCase() == 'english'){
              url = m.Mandate_from_Candidate__c.replace('[SSL]','[SSL]'+queryId);     
         }else{
              url = m.Mandate_from_Candidate_Fr__c.replace('[SSL]','[SSL]'+queryId);
        }
        return url;
    }
    public static string getCandidateToDiscussURL(Mandate__c m,String queryId,String language){
        system.debug('getPotentialCandidateLightningURL');
        string url ;
        if(language.toLowerCase() == 'english'){
            url = m.Candidate_To_Discuss_En__c.replace('[SSL]','[CANDIDATES]'+queryId);     
        }else{
            url = m.Candidate_To_Discuss_Fr__c.replace('[SSL]','[CANDIDATES]'+queryId);
        }
        return url;
    }
    public static string getPotentialCandidateForCandidateToDiscussByTeam(Mandate__c m,String queryId,String language){
        system.debug('getPotentialCandidateLightningURL');
         string url ;
        if(language.toLowerCase() == 'english'){
              url = m.Mandate_from_Candidate_Team__c.replace('[SSL]','[CANDIDATES]'+queryId);     
         }else{
              url = m.Mandate_from_Candidate_Team_Fr__c.replace('[SSL]','[CANDIDATES]'+queryId);
        }
        return url;
    }
     public static string getScheduledInterviewForCandidateLink(Mandate__c m,String queryId,String language){
         string url ;
        if(language.toLowerCase() == 'english'){
              url = m.Schedule_Interview_Link__c.replace('[SSL]','[SSL]'+queryId);     
         }else{
              url = m.Schedule_Interview_Link_Fr__c.replace('[SSL]','[SSL]'+queryId);
        }
        return url;
    }
    public static string getSecondPageLightningURL(Mandate__c m,String queryId,String language){
        String url;
        url = m.SecondPage_URL__c.replace('[USERLIST]','[USERLIST]'+queryId);
        /*if( language.toLowerCase() =='english' ){
        	url = m.User_By_Partner_Link__c.replace('[USERLIST]','[USERLIST]'+queryId);
            System.debug('[USERLIST]'+url);
        }
         else{
             url = m.User_By_Partner_Link_Fr__c.replace('[USERLIST]','[USERLIST]'+queryId);
         }*/
        System.debug('@@@@@@@ url'+url);
         return url;
    }
    public static string getUserDetailsOfPArtnerLightningURL(Mandate__c m,String queryId,String language){
        String url;
        if( language.toLowerCase() =='english' ){
        	url = m.User_By_Partner_Link__c;
            System.debug('[USERLIST]'+url);
        }
         else{
             url = m.User_By_Partner_Link_Fr__c;
         }
         return url;
    }
    public static string getCompetencyLightningURL(Mandate__c m,String language,String compval){
        system.debug('compList'+compval);
        String url;
        
        Competency_Parent__c comp = [SELECT Competency_Link__c FROM Competency_Parent__c Where mandate__C = :m.Id ANd Name =:compval];
        url = comp.Competency_Link__c;
        system.debug('link '+comp.Competency_Link__c);
        return url;
    }
    public static string getCompetencyRadarURL(Application__c app,String queryId){
        String url;
       // string url = m.Human_Capital_Coleman_Conga_Link__c.
        //Application__c comp = [SELECT Competency_Radar_Link__c FROM Application__c Where ID = :app.Id];
        url = app.Competency_Radar_Link__c.replace('[COMPETENCY]','[COMPETENCY]'+queryId);
        //  system.debug('link '+comp.Competency_Radar_Link__c);
        return url;
    }
    public static string getCandidateCountByStatusURL(Mandate__c m,String language){
        system.debug('language'+language);
        String url;
        if( language.toLowerCase() =='english' ){
            
            url = m.candidate_ssl_word__c;
            System.debug('[USERLIST]'+url);
        }
        else{
            
            url = m.candidate_ssl_word_French__c;
        }
        return url;
    }
    
    //Lightning Cover by Ankita
    
    public static string getCoverURL(Mandate__c m, string language){
        system.debug(':: getCoverURL Mandate__c ::'+m);
        string url = m.Cover_Conga_Link_Lightning__c;
        system.debug(':: getCoverURL url ::'+url);
        if(language == null)
        {
            language = 'english';
        }
        if(language.toLowerCase() == 'english'){
            system.debug(':: getCoverURL Mandate__c Cover_Template_FR__c::'+m.Cover_Template_FR__c);
            system.debug(':: getCoverURL Mandate__c Cover_Template_EN__c::'+m.Cover_Template_EN__c);
            url = m.Cover_Conga_Link_Lightning__c.replace(m.Cover_Template_FR__c, m.Cover_Template_EN__c);
        }else{
            url = m.Cover_Conga_Link_Lightning__c.replace(m.Cover_Template_EN__c, m.Cover_Template_FR__c);
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
   /*  public static string getAgendaURL(Mandate__c m, string language){
        string url = m.Agenda_Link__c;
        if(language.toLowerCase() == 'english'){
            url = m.Agenda_Link__c.replace(m.Agenda_Link__c, m.Agenda_Link__c);
        }else{
            url = m.Agenda_Link__c.replace(m.Agenda_Link__c, m.Agenda_Link_Fr__c);
        }
        return url;
    } 
       public static string Exec_Summary_Url(Mandate__c m, string language){
        string url = m.Executive_Summary_Link__c;
        if(language.toLowerCase() == 'english'){
            url = m.Executive_Summary_Link__c.replace(m.Executive_Summary_Link__c, m.Executive_Summary_Link__c);
        }else{
            url = m.Executive_Summary_Link__c.replace(m.Executive_Summary_Link__c, m.Executive_Summary_Link_Fr__c);
        }
        return url;
    } */
    /*** End Chart Reports ***/
    
}