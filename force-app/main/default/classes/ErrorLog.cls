public class ErrorLog {
	public static void logError(Exception ex,String classname,String methodname){
        insert (new ErrorLog__c(Class_Name__c =classname,Method_Name__c=methodname,Error_Message__c=ex.getMessage(),Error_Line__c=String.valueOf(ex.getLineNumber()),Error_Stack_String__c = ex.getStackTraceString()));
    }
}