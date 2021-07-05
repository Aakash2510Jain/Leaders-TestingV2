public with sharing class FileUploaderClass {
    @AuraEnabled
    public static String uploadFile(String base64, String filename, String recordId) {
        system.debug('recordId'+recordId);
        Attachment att = new Attachment();
        att.Name = filename;
        att.Body = encodingUtil.base64Decode(base64);
        att.ParentId = recordId;
        insert att;
        system.debug('att.Id'+att.Id);
        return att.Id;
    }
}