global class DataDisplayController {
    
    public  Map<String,String> responseByQuestion{get;set;}
    
    public String assignmentTitle{get;set;}
    public String companyName{get;set;}
    public String selfAssessmentDate{get;set;}
    public String candidateName{get;set;}
    public Boolean isEnglish{get;set;}
    public String appId{get;set;}
    public String selfAss{get;set;}
    
    public DataDisplayController(){
        appId                           = apexpages.currentpage().getparameters().get('Id');
        responseByQuestion              = new Map<String,String>();
        isEnglish                       = true;
        selfAssessmentDate              = String.valueOf(Date.today());
        candidateName                   = '';
        assignmentTitle                 = '';
    }
    
    public Set<String> keyset {
        get { return responseByQuestion.keyset(); }
    }
    
    public void testinput(){
        
        String question = apexpages.currentPage().getParameters().get('question');
        String response = apexpages.currentPage().getParameters().get('response');
        response =response.replaceAll('\r\n|\n|\r','');
        responseByQuestion.put(question,response);
    }
    public PageReference downloadPDF(){
        
        appId                               = appId.split(' ')[0];
        
        Application__c apprec               = [Select id,Name,Contact__r.Name,Mandate__r.Language__c,Mandate__r.Name,Client_Company__c from Application__c where Id=:appId];
        
        isEnglish                           = apprec.Mandate__r.Language__c =='French' ? false:true;
        candidateName                       = apprec.Contact__r.Name;
        assignmentTitle                     = apprec.Mandate__r.Name;
        companyName                         = apprec.Client_Company__c;
        if(isEnglish == true)
        {
            selfAss = 'Self-Assesment';
        }
        else
        {
            selfAss = 'Auto-évaluation';
        }
        
        System.PageReference pageRef        = new System.PageReference('/apex/PDFGenerator');
        pageRef.getHeaders().put('content-disposition', 'attachment; filename='+apprec.Contact__r.Name+' Self-Assessment.pdf');
        
        return pageRef;
    }
    
}