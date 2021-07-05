public class NewCompanyController {
    
    public Account account {get;set;}
    
    private String retUrl = '/';
    
    public NewCompanyController(ApexPages.StandardController ctrl) {
        account = new Account();
        
        if(ApexPages.currentPage().getParameters().get('RecordType')!=null) 
            account.RecordTypeId = ApexPages.currentPage().getParameters().get('RecordType');
        
        if(ApexPages.currentPage().getParameters().get('retURL')!=null) 
            retUrl = ApexPages.currentPage().getParameters().get('retURL');
        
        Boolean isColemanProfile = false;
        
        Id profileId = userinfo.getProfileId();
        String profileName = [select Name from profile where id = :profileId].Name;
          
        if(profileName.startsWith('Force.com Leaders Coleman'))
            isColemanProfile=true;
        
        if(isColemanProfile)
            account.BillingCountryCode = 'US';
    } 

	public PageReference save() {

        insert account;
        
		PageReference pageRef = new PageReference('/'+account.Id);
    	pageRef.setRedirect(true);
    	return pageRef; 
	} 


	public PageReference cancel() {
 
		PageReference pageRef = new PageReference(retUrl);
    	pageRef.setRedirect(true);
    	return pageRef; 
	}     
    

}