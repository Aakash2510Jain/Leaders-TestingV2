public class ContactAura {

    @auraenabled
    public static List<Contact> FetchContacts(){
        return [Select id,name,email from contact where email != null limit 10];
    }


}