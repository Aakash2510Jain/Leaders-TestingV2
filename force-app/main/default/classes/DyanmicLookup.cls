public with sharing class DyanmicLookup {
    @AuraEnabled
    public static List <SObject> fetchAccount(String searchKeyWord,String ObjectApi) {
        try {
            string queryString='select Name,id from '+ObjectApi+' where Name like \'%'+searchKeyWord+'%\''+' Limit 10';
            System.debug('queryString'+queryString);
            List<SObject> listRec = Database.query(queryString);
            System.debug('queryString'+queryString);
            return listRec;
        } catch (Exception e) {
            System.debug('Error:'+e.getLineNumber()+' AT '+e.getMessage());
            return null;
        }



    }

}