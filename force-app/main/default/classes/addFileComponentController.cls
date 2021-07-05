global class addFileComponentController {
    @AuraEnabled
    public static List<ContentDocument> UpdateFiles(String documentId, String title, String recordId){
        system.debug('title:'+title);
        
        ContentDocument cd = [select id,title from ContentDocument where Id=:documentId]; // Getting files from Parent record 
        cd.Title = title;  // Changing file Title with user entered title
        try{  
            update cd;  // Update ContentDocument (File)
        }  
        catch(DMLException e){  
            system.debug('Exception has occurred! ' +e.getMessage());  
        }  
        List<ContentDocument> DocumentList = new List<ContentDocument>();  
        Set<Id> documentIds = new Set<Id>();  
        List<ContentDocumentLink> cdl=[select id,LinkedEntityId,ContentDocumentId from ContentDocumentLink where LinkedEntityId=:recordId];  
        for(ContentDocumentLink cdLink:cdl){  
            documentIds.add(cdLink.ContentDocumentId);  
        }      
        DocumentList = [select Id,Title,FileType,ContentSize,Description from ContentDocument where id IN: documentIds];  
        return DocumentList;  // Return list of files on parent record
    } 
    
    @AuraEnabled
    public static Contact ContactDeatils(String recordId){
        Contact con = [select Id, FirstName, LastName from Contact where Id=: recordId limit 1]; // Getting details of the Parent Record
        system.debug(con);
        return con;
    } 
    // Apex Methods for addAttachmentComponent Starts
    
    @AuraEnabled
    public static Id saveChunk(String parentId, String fileName, String base64Data, String contentType, String fileId) {
        // check if fileId id ''(Always blank in first chunk), then call the saveTheFile method,
        //  which is save the check data and return the attachemnt Id after insert, 
        //  next time (in else) we are call the appentTOFile() method
        //   for update the attachment with reamins chunks   
        if (fileId == '') {
            fileId = saveTheFile(parentId, fileName, base64Data, contentType);
        } else {
            appendToFile(fileId, base64Data);
        }
        
        return Id.valueOf(fileId);
    }
    
    public static Id saveTheFile(String parentId, String fileName, String base64Data, String contentType) {
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
        
       Attachment oAttachment = new Attachment();
        oAttachment.parentId = parentId;
        
        oAttachment.Body = EncodingUtil.base64Decode(base64Data);
        oAttachment.Name = fileName;
        oAttachment.ContentType = contentType;
        
        insert oAttachment;
        
        return oAttachment.Id;
     
      
      /*  ContentVersion cVersion = new ContentVersion();
        cVersion.IsMajorVersion = false;
        cVersion.ContentLocation = 'S'; //S-Document is in Salesforce. E-Document is outside of Salesforce. L-Document is on a Social Netork.
        cVersion.PathOnClient = fileName;//File name with extention
        cVersion.Origin = 'C';//C-Content Origin. H-Chatter Origin.
        //cVersion.OwnerId = attach.OwnerId;//Owner of the file
        cVersion.Title = fileName;//Name of the file
        cVersion.VersionData = EncodingUtil.base64Decode(base64Data);//File content
        
        system.debug('VersionData'+cVersion);
        Insert cVersion;
        
        //After saved the Content Verison, get the ContentDocumentId
       
        Id conDocument = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cVersion.Id].ContentDocumentId;
        
        //Insert ContentDocumentLink
        ContentDocumentLink cDocLink = new ContentDocumentLink();
        cDocLink.ContentDocumentId = conDocument;//Add ContentDocumentId
        cDocLink.LinkedEntityId = parentId;//Add attachment parentId
        cDocLink.ShareType = 'I';//V - Viewer permission. C - Collaborator permission. I - Inferred permission.
        cDocLink.Visibility = 'AllUsers';//AllUsers, InternalUsers, SharedUsers
        Insert cDocLink;
        
        return cVersion.Id;
        */
        
        
        
    }
    
    private static void appendToFile(Id fileId, String base64Data) {
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
        
        Attachment a = [
            SELECT Id, Body
            FROM Attachment
            WHERE Id =: fileId
        ];
        
        String existingBody = EncodingUtil.base64Encode(a.Body);
        
        a.Body = EncodingUtil.base64Decode(existingBody + base64Data);
        
        update a;
     
       
        /*
         ContentVersion cv = [SELECT ContentDocumentId ,VersionData FROM ContentVersion WHERE Id =:fileId];
        
         system.debug('VersionData'+cv);
        
        
         String existingBody = EncodingUtil.base64Encode(cv.VersionData);
        
         system.debug('VersionData'+existingBody);
        
        cv.VersionData = EncodingUtil.base64Decode(existingBody + base64Data );
        
        
        
        update cv;
        */
        
    }
    @AuraEnabled
    public static String updateDocType(String mandateId,String docType){
        try{
            Mandate__c mandateRec = new Mandate__c(Id=mandateId,Document_Type__c=docType,Has_Research_Strategy__c=(docType=='Research Strategy'?true:false));
            update mandateRec;
            return 'Record Updated Sucessfully';
        }catch(Exception e){
            System.debug('@@@@@'+e.getLineNumber()+'@@@'+e.getMessage());
            return e.getMessage();
        }
        
    }
    
    // Apex Methods for addAttachmentComponent Ends
}