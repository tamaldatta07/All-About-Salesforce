@isTest
private class AccountCalculatorTest {

    @isTest
    static void testCountContacts() {
        // Create test data
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        Contact testContact1 = new Contact(AccountId = testAccount.Id, LastName = 'TestContact1');
        Contact testContact2 = new Contact(AccountId = testAccount.Id, LastName = 'TestContact2');
        insert new List<Contact>{testContact1, testContact2};

        List<Id> accountIds = new List<Id>{testAccount.Id};

        // Call the future method
        Test.startTest();
        AccountCalculator.countContacts(accountIds);
        Test.stopTest();

        // Verify the results
        Account updatedAccount = [SELECT Id, Number_of_Contacts__c FROM Account WHERE Id = :testAccount.Id LIMIT 1];
        System.assertEquals(2, updatedAccount.Number_of_Contacts__c, 'Number_of_Contacts__c should be updated to 2');
    }

    @isTest
    static void testCountContactsNoAccounts() {
        // Test when no accounts are provided
        List<Id> accountIds = new List<Id>();

        // Call the future method
        Test.startTest();
        AccountCalculator.countContacts(accountIds);
        Test.stopTest();

        // No assertions needed since there are no accounts to process
    }

    @isTest
    static void testCountContactsWithoutContacts() {
        // Test when accounts are provided but without associated contacts
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        List<Id> accountIds = new List<Id>{testAccount.Id};

        // Call the future method
        Test.startTest();
        AccountCalculator.countContacts(accountIds);
        Test.stopTest();

        // Verify the results
        Account updatedAccount = [SELECT Id, Number_of_Contacts__c FROM Account WHERE Id = :testAccount.Id LIMIT 1];
        System.assertEquals(0, updatedAccount.Number_of_Contacts__c, 'Number_of_Contacts__c should be 0');
    }
}