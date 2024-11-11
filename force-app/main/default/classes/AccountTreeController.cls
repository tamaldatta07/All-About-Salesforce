public with sharing class AccountTreeController {
    
    @AuraEnabled(cacheable=true)
    public static List<AccountWrapper> getAccountsAndContacts() {
        List<AccountWrapper> accountList = new List<AccountWrapper>();
        
        // Fetch all Accounts with their related Contacts
        List<Account> accounts = [
            SELECT Id, Name, Industry, Phone, BillingCity, BillingState,
            (SELECT Id, Name, Email FROM Contacts)
            FROM Account
        ];
        
        // Building the wrapper structure
        for (Account acc : accounts) {
            AccountWrapper accWrapper = new AccountWrapper();
            accWrapper.accountId = acc.Id;
            accWrapper.accountName = acc.Name;
            accWrapper.industry = acc.Industry;
            accWrapper.phone = acc.Phone;
            accWrapper.billingCity = acc.BillingCity;
            accWrapper.billingState = acc.BillingState;
            
            // Adding related Contacts
            for (Contact con : acc.Contacts) {
                ContactWrapper conWrapper = new ContactWrapper();
                conWrapper.contactId = con.Id;
                conWrapper.contactName = con.Name;
                conWrapper.email = con.Email;
                accWrapper.contacts.add(conWrapper);
            }
            
            accountList.add(accWrapper);
        }
        return accountList;
    }
    
    public class AccountWrapper {
        @AuraEnabled public String accountId;
        @AuraEnabled public String accountName;
        @AuraEnabled public String industry;
        @AuraEnabled public String phone;
        @AuraEnabled public String billingCity;
        @AuraEnabled public String billingState;
        @AuraEnabled public List<ContactWrapper> contacts = new List<ContactWrapper>();
    }
    
    public class ContactWrapper {
        @AuraEnabled public String contactId;
        @AuraEnabled public String contactName;
        @AuraEnabled public String email;
    }
    @AuraEnabled(cacheable=true)
    public static AccountWrapper getAccountDetailsById(Id accountId) {
        Account acc = [
            SELECT Id, Name, Industry, Phone, BillingCity, BillingState 
            FROM Account
            WHERE Id = :accountId
            LIMIT 1
        ];
        AccountWrapper accWrapper = new AccountWrapper();
        accWrapper.accountId = acc.Id;
        accWrapper.accountName = acc.Name;
        accWrapper.industry = acc.Industry;
        accWrapper.phone = acc.Phone;
        accWrapper.billingCity = acc.BillingCity;
        accWrapper.billingState = acc.BillingState;
        return accWrapper;
    }
    
}