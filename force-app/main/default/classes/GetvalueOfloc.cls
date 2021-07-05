public class GetvalueOfloc 
{
    @auraenabled
    public static List<String> getPickListValuesIntoList()
    {
        List<String> pickListValuesList= new List<String>();
        Schema.DescribeFieldResult fieldResult = Contact.Location__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple)
        {
            pickListValuesList.add(pickListVal.getLabel());
        }     
        return pickListValuesList;
    }
}