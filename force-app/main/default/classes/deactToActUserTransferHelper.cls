public class deactToActUserTransferHelper 
    {
        
        @AuraEnabled
        public static List<integer> getInfoOfUser(String UserId)
        {
            System.debug('The user id is'+UserId);
            
            List<integer> RecList = new List<integer>();
            Integer Comprec = [SELECT count() FROM Account WHERE OwnerId =:UserId];
            RecList.add(Comprec);
            Integer Peoplerec = [SELECT count() FROM Contact WHERE OwnerId =:UserId];
            RecList.add(Peoplerec);
            Integer Manrec = [SELECT count() FROM Mandate__c WHERE OwnerId =:UserId];
            RecList.add(Manrec);
            
            system.debug('the list of records'+RecList);
            
            return RecList;
            
        }
        @AuraEnabled
        public static void runBatchforContact(String UserId)
        {
            System.debug('The user id is'+UserId);
            
            BatchForDeactivatedUser batch  = new BatchForDeactivatedUser(UserId);
            
            Database.executeBatch(batch);
            
        }
        @AuraEnabled
        public static void runBatchforAccount(String UserId)
        {
            System.debug('The user id is :'+UserId);
            
            BatchForDeactivatedUserAccount batch  = new BatchForDeactivatedUserAccount(UserId);
            
            Database.executeBatch(batch);
        }
        @AuraEnabled
        public static void runBatchforAssignment(String UserId)
        {
            System.debug('The user id is'+UserId);
            
            BatchForDeactivatedUserAss batch  = new BatchForDeactivatedUserAss(UserId);
            
            Database.executeBatch(batch);
        }
    }