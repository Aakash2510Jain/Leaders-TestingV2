public with sharing class Nubik_HumanCapitalStudyController {
	
	public Date dateDebut;
	public Date dateFinish;
	public String masterId {get;set;}
	public String url;
	public String attachId;
	private Mandate__c mandate {get;set;}
	
	public void setDateDebut(Date u) {
        this.dateDebut = u;
    }
    
    public Date getDateDebut() {
        return this.dateDebut;
    }
    
    public void setDateFinish(Date u) {
        this.dateFinish = u;
    }
    
    public Date getDateFinish() {
        return this.dateFinish;
    }
	
	public void setUrl(String u) {
        this.url = u;
    }
    
    public String getUrl() {
        return this.url;
    }
    
    public void setAttachId(String aId) {
        this.attachId = aId;
    }
    
    public String getAttachId() {
        return this.attachId;
    }
	
	public Nubik_HumanCapitalStudyController(ApexPages.StandardController controller) {
		masterId = ApexPages.currentPage().getParameters().get('id');
		url = 'https://composer.congamerge.com?serverUrl={@!@API.Partner_Server_URL_290}&Id=' + masterId + 
        	'&TemplateId=a0AU000000q2j0J&OFN=Human+Capital+Study+' + masterId + '&BML=Loading&FP0=1&LG4=2&DefaultPDF=1&DS7=1';
        
        if(masterId!=null && masterId!=''){       	
        	List<Mandate__c> mandates = [Select Id, Human_Capital_Conga_Link__c,Human_Capital_SSL_Conga_Link__c,
        									Language__c,Confidential__c, Company_Name_French__c,
        									Company__r.Name, Name 
        									from Mandate__c 
        									where Id = :masterId];
        	if(!mandates.isEmpty()){
        		mandate = mandates[0];
        	}
        }
	}
	public Nubik_HumanCapitalStudyController() {
	
	}	
	public string generateReport(String manurl, Date dateD, Date dateF, string reportName, String company, boolean fromBatch){
		if(manurl!=null){
	       	System.debug(dateD + '' + dateF);
	       	
	       	String dateDebutString = dateD.month()+'/'+dateD.day()+'/'+dateD.year();
	       	String dateFinishString = dateF.month()+'/'+dateF.day()+'/'+dateF.year();
	       	url = manurl;
	       	//url = url + '&ReportId=00OU0000002P2Ur?pv0=' + masterId + '~pv1=' + dateDebutString + '~pv2=' + dateFinishString;       
	       	//url = url.replace('START_DATE', dateDebutString);
	       	//url = url.replace('END_DATE', dateFinishString);   
	       	String sDate = String.valueOf(dateD)+'T00:00:00Z';
            String eDate = String.valueOf(dateF)+'T00:00:00Z';
            url = url.replace('START_DATE', sDate);
	       	url = url.replace('END_DATE', eDate);   
	       		
	       	url = url + '&OFN='+EncodingUtil.urlEncode(reportName, 'UTF-8');
	       	url = url + '&DV0='+EncodingUtil.urlEncode(company, 'UTF-8');
	       	System.debug(url);
	       	if(fromBatch){
	       		url = CongaHelperTool.fixBatchURL(url,reportName,company,null,null);
	       	}
	        //Org credentials
	        CongaSession__c cs = CongaSession__c.getValues('NubikDev');
	        String username = cs.Username__c;
	        String password = cs.Password__c;
	        String sessiondId = CongaHelperTool.getSessionId(username, password);
			
			url = url.replace('SESSION_ID', sessiondId);
			
	        System.debug(':: [CongaAppController] EndPoint :: ' + url);
	        
	        try {
	            attachId = 'Result: ' + CongaHelperTool.HttpReq(url);
	            System.debug(':: [CongaAppController] attachId :: ' + attachId);
	            if (attachId.indexOf('</body>/') != -1) {
	              attachId = attachId.substring(attachId.indexOf('</body>/')+8);
	            }else if (attachId.indexOf('/') != -1){
	                attachId = attachId.substring(attachId.indexOf('/')+1);
	            }
	        } catch (Exception e) {
	            attachId = 'Result: There is an error when the attachament id was generated';
	            System.debug(':: [CongaAppController] attachId :: ' + attachId 
	                + '----> ' + e);
	        }
		}
		return attachId;
	}
	public PageReference next() {
		
		String hCapitalName = CongaHelperTool.getReportName('Human Capital Study',mandate.name,mandate.Language__c);
		String companyName = CongaHelperTool.getCompanyName(mandate, mandate.Language__c);
		
		attachId = generateReport(mandate.Human_Capital_Conga_Link__c, dateDebut, dateFinish, hCapitalName, companyName, false);		
        Pagereference pref = new Pagereference('/' + masterId);
        return pref;      
    }
    
    public string generateReportSSL(String manurl, Date dateD, Date dateF, string reportName, String company, boolean fromBatch){
		if(manurl!=null){
	       	System.debug(dateD + '' + dateF);
	       	
	       	String dateDebutString = dateD.month()+'/'+dateD.day()+'/'+dateD.year();
	       	String dateFinishString = dateF.month()+'/'+dateF.day()+'/'+dateF.year();
	       	url = manurl;
	       	//url = url + '&ReportId=00OU0000002P2Ur?pv0=' + masterId + '~pv1=' + dateDebutString + '~pv2=' + dateFinishString;       
	       	url = url.replace('START_DATE', dateDebutString);
	       	url = url.replace('END_DATE', dateFinishString);   	
	       	url = url + '&OFN='+EncodingUtil.urlEncode(reportName, 'UTF-8');
	       	url = url + '&DV0='+EncodingUtil.urlEncode(company, 'UTF-8');
	       	System.debug(url);
	       	if(fromBatch){
	       		url = CongaHelperTool.fixBatchURL(url,reportName,company,null,null);
	       	}
	        //Org credentials
	        CongaSession__c cs = CongaSession__c.getValues('NubikDev');
	        String username = cs.Username__c;
	        String password = cs.Password__c;
	        String sessiondId = CongaHelperTool.getSessionId(username, password);
			
			url = url.replace('SESSION_ID', sessiondId);
			
	        System.debug(':: [CongaAppController] EndPoint :: ' + url);
	        
	        try {
	            attachId = 'Result: ' + CongaHelperTool.HttpReq(url);
	            System.debug(':: [CongaAppController] attachId :: ' + attachId);
	            if (attachId.indexOf('</body>/') != -1) {
	              attachId = attachId.substring(attachId.indexOf('</body>/')+8);
	            }else if (attachId.indexOf('/') != -1){
	                attachId = attachId.substring(attachId.indexOf('/')+1);
	            }
	        } catch (Exception e) {
	            attachId = 'Result: There is an error when the attachament id was generated';
	            System.debug(':: [CongaAppController] attachId :: ' + attachId 
	                + '----> ' + e);
	        }
		}
		return attachId;
	}
    
	
}