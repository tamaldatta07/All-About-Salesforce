public with sharing class AccountController {
    @AuraEnabled(cacheable=true)
    public static List<Account> searchAccounts(String searchKey) {
        String searchQuery = '%' + searchKey + '%';
        List<Account> accounts = [
            SELECT Id, Name, (SELECT Id, Name FROM Contacts), 
                (SELECT Id, Name FROM Opportunities) 
            FROM Account 
            WHERE Name LIKE :searchQuery 
            LIMIT 10
        ];
        return accounts;
    }
}