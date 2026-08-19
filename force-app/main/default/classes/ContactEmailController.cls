public with sharing class ContactEmailController {
    
    // Existing main query method
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
            'WHERE Id IN (SELECT EmailMessageId FROM EmailMessageRelation WHERE RelationId = :contactId) ' +
            'AND Status != \'5\' '; 
        
        if (String.isNotBlank(searchKey)) {
            String likeKey = '%' + String.escapeSingleQuotes(searchKey) + '%';
            query += ' AND (Subject LIKE :likeKey OR FromAddress LIKE :likeKey OR ToAddress LIKE :likeKey) ';
        }
        if (String.isNotBlank(statusFilter)) {
            query += ' AND Status = :statusFilter ';
        }
        
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
        
        query += ' WITH USER_MODE' + ' ORDER BY ' + safeSortField + ' ' + safeSortDir +
            ' LIMIT :safeLimit OFFSET :safeOffset';
        
        return Database.query(query);
    }
    
    //Get total count based on active filters
    @AuraEnabled
    public static Integer getTotalEmailCount(
        Id contactId, String searchKey, Date startDate, Date endDate, String statusFilter
    ) {
        if (contactId == null) {
            return 0;
        }
        
        String query = 'SELECT COUNT() ' +
            'FROM EmailMessage ' +
            'WHERE Id IN (SELECT EmailMessageId FROM EmailMessageRelation WHERE RelationId = :contactId) ' +
            'AND Status != \'5\' '; 
        
        if (String.isNotBlank(searchKey)) {
            String likeKey = '%' + String.escapeSingleQuotes(searchKey) + '%';
            query += ' AND (Subject LIKE :likeKey OR FromAddress LIKE :likeKey OR ToAddress LIKE :likeKey) ';
        }
        if (String.isNotBlank(statusFilter)) {
            query += ' AND Status = :statusFilter ';
        }
        
        if (startDate != null) {
            Datetime startDt = Datetime.newInstance(startDate.year(), startDate.month(), startDate.day(), 0, 0, 0);
            query += ' AND MessageDate >= :startDt ';
        }
        if (endDate != null) {
            Datetime endDt = Datetime.newInstance(endDate.year(), endDate.month(), endDate.day(), 23, 59, 59);
            query += ' AND MessageDate <= :endDt ';
        }
        
        return Database.countQuery(query + ' WITH USER_MODE');
    }
}