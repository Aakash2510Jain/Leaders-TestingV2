public with sharing class ViewCV_Ctrl {
    
//    public string cvid{get;set;}
    public   string contactid ;
    public ApexPages.StandardController sc{get;set;}
    string query ;
    
    public ViewCV_Ctrl(ApexPages.StandardController stdController)
    {
       sc=stdController; 
       contactid= ApexPages.currentPage().getParameters().get('id');
       Map<String, String> lastCVByContactId = new Map<String, String>();
        
       if(contactid != null) 
       {
           try{
            List<Attachment>  query = [SELECT Id, ParentId FROM Attachment WHERE ParentId = : contactid AND Name LIKE 'CV%' ORDER BY LastModifiedDate DESC];
              }catch(system.QueryException e)
           {
               ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'No CV for this candidate.' ));
           //    ApexPages.Message MyMessage = new (ApexPages.Message(ApexPages.Severity.ERROR,  'Contact has notany CV Uploaded' )) ;
                   
           }
         //  try{    
           for(Attachment result: [SELECT Id, ParentId FROM Attachment WHERE ParentId = : contactid AND Name LIKE 'CV%' ORDER BY LastModifiedDate DESC] ) {
              if(!lastCVByContactId.containsKey(String.valueOf(result.ParentId)))
                 lastCVByContactId.put(String.valueOf(result.ParentId),String.valueOf(result.Id));              
            }
          /* }catch(system.QueryException e)
           {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Contact has not any CV Uploaded' ));
           } */
       }
        
        
        
        
    }
    
    public Attachment att {
        get {
           
            if (att == null) {
               /* att = [SELECT Body, ContentType, Name FROM Attachment WHERE ID = contactid];*/
               try{ 
               att = [SELECT Id, ParentId , Body, ContentType , Name FROM Attachment WHERE ParentId = : contactid AND Name LIKE 'CV%' ORDER BY LastModifiedDate DESC limit 1];
               }catch(System.QueryException e){
              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'No CV for this candidate.' ));  
            }        
            }
            
            return att;
        }
         set;
    }
    
     public String pdf {
        get {
            if(att != null)
            {
                 return EncodingUtil.Base64Encode(att.body);
            }
            else return null ;
           
        }
         set;
    } 
    
    
    
    
}