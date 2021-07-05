public class InvClass {
    
    public List<Invoice__c> invRecList{get;set;}
    public InvClass(){
        invRecList= [Select Id,name,Invoice_Amount__c from Invoice__c limit 10];
    }
    

}