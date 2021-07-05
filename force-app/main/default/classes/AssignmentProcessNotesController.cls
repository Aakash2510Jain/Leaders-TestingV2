public class AssignmentProcessNotesController {
    
    
    
    @AuraEnabled 
    public static  List<Mandate__c> getingvalues(Id Recid){
        
        system.debug('Status'+Recid);
        
        List<Mandate__c> manlist= [SELECT Name,Company__r.Name,Assignment_Status__c,Module__c FROM Mandate__c WHERE Id =:Recid];
        system.debug('manlist'+manlist);
        return manlist;
        
        
    }
    
    
    @AuraEnabled 
    public static String updateNotes(Assignment_Notes__c assignmentNoteRec){
        try{
            system.debug('Ass_note'+assignmentNoteRec);
            
            
            
            update assignmentNoteRec;
            
            return 'Success';
        }catch(Exception e){
            return e.getMessage();
        }
    }
    
    
    @AuraEnabled 
    public static Assignment_Notes__c fetchNotes(Id recId)
    {
        String query ='';
        String SobjectApiName = 'Assignment_Notes__c';
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Map<String, Schema.SObjectField> fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
        String strFields = '';
        
        for(String fieldName : fieldMap.keyset() )
        {
            if(strFields == null || strFields == '')
            {
                strFields = fieldName;
            }else
            {
                strFields = strFields + ' , ' + fieldName;
            }
        }
        
        //      IPO__c
        //Share_meeting_dates_with_admin__c
        //Upload_all_info_into_LRA__c
        //Stakeholder_interviews_Survey__c
        //Schedule_bi_weekly_updates__c
        
        
        system.debug('recId'+recId);
        query = 'select ' + strFields + ' from ' + SobjectApiName + ' where Assignment_Research__c =:recId ';
      //  query='select Contract_received_sign_and_upload_in_lra__c,X1st_invoice_sent_to_the_client__c,Contract_signed_and_sent_Thearin__c,Create_folder_in_One_Drive__c,Create_other_invoices__c from Assignment_Notes__c LIMIT 1';
        system.debug('notesList'+query);
        
        List <Assignment_Notes__c> notesList = Database.query(query);
        
        system.debug('notesList'+notesList);
        
        return notesList[0];
    }
    
    @AuraEnabled 
    public static List<String> getValueOfModule(){
        
        List<String> options = new List<String>();
        
        Schema.DescribeFieldResult fieldResult = Mandate__c.Module__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        for( Schema.PicklistEntry f : ple)
        {
            options.add(f.getValue());
        }       
        system.debug('options'+options);
        
        return options;
        
    }  
    
    @AuraEnabled 
    public static String updateModulevalue(Id Recid , String Module ){
        
        
        try{
            system.debug('Status'+Recid);
            system.debug('Status'+Module);
            
            mandate__c man = new Mandate__c();
            man.Id = Recid;
            man.Module__c = Module;
            
            update man;
            Return 'Module Updated';}
        
        catch(Exception e)
        {
            return e.getMessage();
        }
        
    }
    @AuraEnabled 
    public static List<String> getValueOfStatus(){
        
        List<String> options = new List<String>();
        
        Schema.DescribeFieldResult fieldResult = Mandate__c.Assignment_Status__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        for( Schema.PicklistEntry f : ple)
        {
            options.add(f.getValue());
        }       
        system.debug('options'+options);
        
        return options;
        
    }  
    
    @AuraEnabled 
    public static String updatestatusvalue(Id Recid , String status ){
        
        try{
            
            system.debug('Status'+Recid);
            system.debug('Status'+status);
            
            mandate__c man = new Mandate__c();
            man.Id = Recid;
            man.Assignment_Status__c = status;
            
            update man;
            
            Return 'Status Updated';
        }
        catch(Exception e)
        {
            return e.getMessage();
        }
        
    }
}