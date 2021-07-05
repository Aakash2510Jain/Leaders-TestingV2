public class DeleteOnePagerResponseHelper {
    
    public static String Del_One_Pager_Response(List<One_Pager__c> OnePagerRec){
        
        try{
            List<One_Pager_Response__c > ResponseListToBeDeleted = new List<One_Pager_Response__c >(); 
            
            set<ID> onePagerId = new set<ID>();
            
            for(One_Pager__c op:OnePagerRec){
                onePagerId.add(op.Id);
            }
            system.debug('onePagerId'+onePagerId);
            ResponseListToBeDeleted = [select id from One_Pager_Response__c where One_Pager__c  IN:onePagerId];
            system.debug('ResponseListToBeDeleted'+ResponseListToBeDeleted);
            delete ResponseListToBeDeleted;
            return 'Success';
        }
        catch(exception e){
            system.debug('Line number of Error'+e.getLineNumber()+'The error is'+e.getMessage());
            return null;
        }
    }
}