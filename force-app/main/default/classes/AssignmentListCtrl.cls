/* **************************************************************************
* Test Class: AssignmentListCtrl
* Created by Karyn Cuenca, 08/21/2015
*
* Unit test: AssignmentListCtrlTest 
*
* Modifications:
* - {DevName}, {MM/DD/YYYY} – {Description of changes made post deployment to client}
*
************************************************************************** */
public with sharing class AssignmentListCtrl {
    
    public List<Mandate__c> assigmentList{get;set;}
        
    public String selectedView {get;set;}
    
    private String sortDirection = 'ASC';
    private String sortExp = 'number_of_days__c';//'Company__r.Name';
    
    private List<String> statusValues;
    
    public List<String> getStatusValues(){
        if(statusValues == null){
            statusValues = new List<String>{'Active','Identification','Selection','Consulting','Integration'};            
        }
        return statusValues;
    }
    
    public AssignmentListCtrl(){
        
        selectedView = 'MyActive';
        getStatusValues();
        ViewData();
        
    }
    
    public List<SelectOption> listViewType {get {
        if (listViewType == null) {
            
            listViewType = new List<SelectOption>();
            listViewType.add(new SelectOption('My','My Assignments'));
            listViewType.add(new SelectOption('MyActive','My Active Assignments'));
            listViewType.add(new SelectOption('Active','All Active Assignments'));
            listViewType.add(new SelectOption('All','All Assignments'));
        }
        return listViewType;
    } set;}
    
    
    public List<Mandate__c> myActiveAssignments(String sortFullExp){
        
        Id userId = UserInfo.getUserId();   
        String status = getStringFromList(statusValues);
    
        //query the database based on the sort expression
        List<Mandate__c> myAssignmentList = Database.query('Select Name, Company__c, '+
                                                  'Company__r.Name, '+
                                                  'Company_Name_French__c, '+
                                                  'Job_Function__c, Level__c, '+
                                                  'Assignment_Status__c, '+
                                                  'Consultant__r.Name, '+
                                                  'Partner__r.Name, '+
                                                  'Number_of_potential_candidates__c, '+
                                                  'Number_of_candidates__c, '+
                                                  'number_of_days__c, '+
                                                  'Has_Job_Description__c, '+
                                                  'Has_Research_Strategy__c, '+
                                                  'Leaders_interviews__c, ' +
                                                  'Client_interviews__c ' +
                                                  'from Mandate__c '+
                                                  'where Assignment_Status__c in ('+ status + ') '+     
                                                  'and (Consultant__c = \''+ userId +'\' '+
                                                  'or Partner__c = \''+ userId +'\' '+
                                                  'or Partner_2__c = \''+ userId +'\' '+
                                                  'or Researcher__c = \''+ userId +'\' '+ 
                                                  'or Researcher_3__c = \''+ userId +'\' '+
                                                  'or Researcher_4__c = \''+ userId +'\' '+
                                                  'or Researcher_5__c = \''+ userId +'\' )'+         
                                                  'order by ' + sortFullExp + ' limit 1000');
       
        
         return myAssignmentList;                 
        
    }
    
    
    public List<Mandate__c> myAssignments(String sortFullExp){
        
        Id userId = UserInfo.getUserId();       
    
        //query the database based on the sort expression
        List<Mandate__c> myAssignmentList = Database.query('Select Name, Company__c, '+
                                                  'Company__r.Name, '+
                                                  'Company_Name_French__c, '+
                                                  'Job_Function__c, Level__c, '+
                                                  'Assignment_Status__c, '+
                                                  'Consultant__r.Name, '+
                                                  'Partner__r.Name, '+
                                                  'Number_of_potential_candidates__c, '+
                                                  'Number_of_candidates__c, '+
                                                  'number_of_days__c, '+
                                                  'Has_Job_Description__c, '+
                                                  'Has_Research_Strategy__c, '+
                                                  'Leaders_interviews__c, ' +
                                                  'Client_interviews__c ' +
                                                  'from Mandate__c '+
                                                  'where Consultant__c = \''+ userId +'\' '+
                                                  'or Partner__c = \''+ userId +'\' '+
                                                  'or Partner_2__c = \''+ userId +'\' '+
                                                  'or Researcher__c = \''+ userId +'\' '+ 
                                                  'or Researcher_3__c = \''+ userId +'\' '+
                                                  'or Researcher_4__c = \''+ userId +'\' '+
                                                  'or Researcher_5__c = \''+ userId +'\' '+ 
                                                  'order by ' + sortFullExp + ' limit 1000');
       
        
         return myAssignmentList;                 
        
    }
    
    
    public List<Mandate__c> allAssignments(String sortFullExp){
                
        //query the database based on the sort expression
        List<Mandate__c> allAssigmentList = Database.query('Select Name, Company__c, '+
                                                  'Company__r.Name, '+
                                                  'Company_Name_French__c, '+
                                                  'Job_Function__c, Level__c, '+
                                                  'Assignment_Status__c, '+
                                                  'Consultant__r.Name, '+
                                                  'Partner__r.Name, '+
                                                  'Number_of_potential_candidates__c, '+
                                                  'Number_of_candidates__c, '+
                                                  'number_of_days__c, '+
                                                  'Has_Job_Description__c, '+
                                                  'Has_Research_Strategy__c, '+
                                                  'Leaders_interviews__c, ' +
                                                  'Client_interviews__c ' +
                                                  'from Mandate__c '+                                                 
                                                  'order by ' + sortFullExp + ' limit 1000');
        
        return allAssigmentList;              
        
    }
    
    
    public List<Mandate__c> activeAssignments(String sortFullExp){
                
        //query the database based on the sort expression       
        String status = getStringFromList(statusValues);                       
        List<Mandate__c> aAssignmentList = Database.query('Select Name, Company__c, '+
                                                  'Company__r.Name, '+
                                                  'Company_Name_French__c, '+
                                                  'Job_Function__c, Level__c, '+
                                                  'Assignment_Status__c, '+
                                                  'Consultant__r.Name, '+
                                                  'Partner__r.Name, '+
                                                  'Number_of_potential_candidates__c, '+
                                                  'Number_of_candidates__c, '+
                                                  'number_of_days__c, '+
                                                  'Has_Job_Description__c, '+
                                                  'Has_Research_Strategy__c, '+
                                                  'Leaders_interviews__c, ' +
                                                  'Client_interviews__c ' +
                                                  'from Mandate__c '+   
                                                  'where Assignment_Status__c in ('+ status +') '+                                        
                                                  'order by ' + sortFullExp + ' limit 1000');
        
        return aAssignmentList;              
        
    }
    
    
    public PageReference ViewData() {
        
        //build the full sort expression
        string sortFullExp = sortExpression  + ' ' + sortDirection;
        
        if(selectedView == 'All'){
            assigmentList = allAssignments(sortFullExp);
        }else if(selectedView == 'Active'){
            assigmentList = activeAssignments(sortFullExp);
        }else if(selectedView == 'My'){
            assigmentList = myAssignments(sortFullExp);
        }else{
            assigmentList = myActiveAssignments(sortFullExp);
        }
        
        return null;
        
    }
    
    
    public String sortExpression{
         get{
            return sortExp;
         }
         set{
           //if the column is clicked on then switch between Ascending and Descending modes
           if (value == sortExp){
             sortDirection = (sortDirection == 'ASC')? 'DESC' : 'ASC';
           }else{
             sortDirection = 'ASC';
           }
           sortExp = value;
         }
    }

    public String getSortDirection() {
        //if not column is selected 
        if (sortExpression == null || sortExpression == '')
          return 'ASC';
        else
         return sortDirection;
    }
    
    public void setSortDirection(String value){  
       sortDirection = value;
    }
    
    public static String getStringFromList(List<String> sStatus) {
        string s;
        for(String status : sStatus){
            s = (!String.isBlank(s)) ? (s + ',\'' + status + '\'') : ('\'' + status + '\'');
        }
        return s; 
     }

}