public with sharing class ContactEmailController {
    
    @AuraEnabled
    public static List<EmailMessage> getContactEmails(
        Id contactId, Integer queryLimit, Integer queryOffset, 
        String sortField, String sortDir, String searchKey,
        Date startDate, Date endDate, String statusFilter
    ) {
        if (contactId == null) {
            return new List<EmailMessage>();
        }
        
        Integer safeLimit = (queryLimit != null) ? queryLimit : 20;
        Integer safeOffset = (queryOffset != null) ? queryOffset : 0;
        
        String query = 'SELECT Id, Subject, FromAddress, ToAddress, CcAddress, MessageDate, Incoming, toLabel(Status) ' +
                       'FROM EmailMessage ' +
                       'WHERE Id IN (SELECT EmailMessageId FROM EmailMessageRelation WHERE RelationId = :contactId) ';
        
        // 1. Text Search Filter
        if (String.isNotBlank(searchKey)) {
            String likeKey = '%' + String.escapeSingleQuotes(searchKey) + '%';
            query += ' AND (Subject LIKE :likeKey OR FromAddress LIKE :likeKey OR ToAddress LIKE :likeKey) ';
        }
        
        // 2. Status Filter
        if (String.isNotBlank(statusFilter)) {
            query += ' AND Status = :statusFilter ';
        }
        
        // 3. Date Range Filters
        Datetime startDt;
        Datetime endDt;
        
        if (startDate != null) {
            startDt = Datetime.newInstance(startDate.year(), startDate.month(), startDate.day(), 0, 0, 0);
            query += ' AND MessageDate >= :startDt ';
        }
        
        if (endDate != null) {
            endDt = Datetime.newInstance(endDate.year(), endDate.month(), endDate.day(), 23, 59, 59);
            query += ' AND MessageDate <= :endDt ';
        }
        
        String safeSortField = String.isBlank(sortField) ? 'MessageDate' : String.escapeSingleQuotes(sortField);
        String safeSortDir = String.isBlank(sortDir) ? 'DESC' : String.escapeSingleQuotes(sortDir);
        
        query += ' ORDER BY ' + safeSortField + ' ' + safeSortDir +
                 ' LIMIT :safeLimit OFFSET :safeOffset';
                 
        return Database.query(query);
    }
}
