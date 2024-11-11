public with sharing class AccountContactController {
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccountWithContacts() {
        return [SELECT Id, Name, Phone, Industry, 
                       (SELECT Id, Name, Email FROM Contacts)
                FROM Account
                WHERE Id != null
                ORDER BY Name];
    }

    @AuraEnabled(cacheable=true)
    public static Account getAccountDetails(Id accountId) {
        return [SELECT Id, Name, Phone, Industry, Website FROM Account WHERE Id = :accountId LIMIT 1];
    }
}