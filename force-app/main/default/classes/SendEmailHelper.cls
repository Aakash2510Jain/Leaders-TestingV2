/**
 * Created by ET-MARLABS on 26-04-2019.
 */

public class SendEmailHelper {



    public static List<EmailTemplate> fetchEmailTemplate() {

        List<Id> folderIdList = new List<Id>();

        for(Folder f : SendEmailHelper.fetchFolder(EmailConstants.folderName)) {
            folderIdList.add(f.Id);
        }

        return fetchEmailTemplate(folderIdList);
    }

    public static List<Folder> fetchFolder(List<string> folderName) {
        return [Select id, Name, DeveloperName from Folder where DeveloperName IN: folderName];
    }

    public static List<EmailTemplate> fetchEmailTemplate(List<String> folderIdList) {
        return [select Id, Name, DeveloperName, Subject, Body from EmailTemplate where FolderId IN: folderIdList ORDER BY Name ASC];
    }
}