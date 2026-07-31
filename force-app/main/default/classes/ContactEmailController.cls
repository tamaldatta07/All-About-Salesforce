public with sharing class ContactEmailController {
    
    // REMOVED cacheable=true so the refresh button fetches live data
    @AuraEnabled
    public static List<EmailMessage> getContactEmails(
        Id contactId, Integer queryLimit, Integer queryOffset, 
        String sortField, String sortDir, String searchKey
    ) {
        if (contactId == null) {
            return new List<EmailMessage>();
        }
        
        Integer safeLimit = (queryLimit != null) ? queryLimit : 20;
        Integer safeOffset = (queryOffset != null) ? queryOffset : 0;
        
        List<EmailMessageRelation> relations = [
            SELECT EmailMessageId FROM EmailMessageRelation WHERE RelationId = :contactId
        ];
        
        Set<Id> emailIds = new Set<Id>();
        for (EmailMessageRelation emr : relations) {
            emailIds.add(emr.EmailMessageId);
        }
        
        String query = 'SELECT Id, Subject, FromAddress, ToAddress, CcAddress, MessageDate, Incoming ' +
                       'FROM EmailMessage WHERE Id IN :emailIds ';
        
        if (String.isNotBlank(searchKey)) {
            String likeKey = '%' + String.escapeSingleQuotes(searchKey) + '%';
            query += ' AND (Subject LIKE :likeKey OR FromAddress LIKE :likeKey OR ToAddress LIKE :likeKey) ';
        }
        
        String safeSortField = String.isBlank(sortField) ? 'MessageDate' : String.escapeSingleQuotes(sortField);
        String safeSortDir = String.isBlank(sortDir) ? 'DESC' : String.escapeSingleQuotes(sortDir);
        
        query += ' ORDER BY ' + safeSortField + ' ' + safeSortDir +
                 ' LIMIT :safeLimit OFFSET :safeOffset';
                 
        return Database.query(query);
    }
}