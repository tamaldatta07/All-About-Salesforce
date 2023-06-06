@IsTest
private class AccountTriggerHandlerTest {
    @IsTest
    static void testValidateAccountBeforeInsert() {
        List<Account> accountList = new List<Account>();
        
        // Create an Account with Rating as 'Hot' and Type as null
        Account hotAccount = new Account();
        hotAccount.Name = 'Hot Account';
        hotAccount.Rating = 'Hot';
        accountList.add(hotAccount);
        
        // Create an Account with Rating as 'Warm' and Type as null
        Account warmAccount = new Account();
        warmAccount.Name = 'Warm Account';
        warmAccount.Rating = 'Warm';
        accountList.add(warmAccount);
        
        Test.startTest();
        AccountTriggerHandler.validateAccountBeforeInsert(accountList);
        Test.stopTest();
        
        // Verify that the first Account has an error message
        System.assertEquals(1, accountList[0].getErrors().size());
        System.assertEquals('Account Type is Mandatory when Rating is Hot', accountList[0].getErrors()[0].getMessage());
        
        // Verify that the second Account doesn't have an error message
        System.assertEquals(0, accountList[1].getErrors().size());
    }
    
    @IsTest
    static void testInsertContact() {
        List<Account> accountList = new List<Account>();
        
        // Create an Account
        Account account = new Account();
        account.Name = 'Test Account';
        accountList.add(account);
        
        Test.startTest();
        AccountTriggerHandler.insertContact(accountList);
        Test.stopTest();
        
        // Query for the inserted Contact
        List<Contact> insertedContacts = [SELECT LastName, AccountId FROM Contact];
        
        // Verify that a Contact record was inserted
        System.assertEquals(1, insertedContacts.size());
        
        // Verify that the Contact has the correct values
        System.assertEquals(account.Name, insertedContacts[0].LastName);
        System.assertEquals(account.Id, insertedContacts[0].AccountId);
    }
    
    @IsTest
    static void testCreateOpportunity() {
        // Create an existing Account with Rating as 'Cold'
        Account oldAccount = new Account();
        oldAccount.Name = 'Old Account';
        oldAccount.Rating = 'Cold';
        insert oldAccount;
        
        // Create a new Account with Rating as 'Hot'
        Account newAccount = new Account();
        newAccount.Name = 'New Account';
        newAccount.Rating = 'Hot';
        
        Map<Id, Account> oldAccountMap = new Map<Id, Account>();
        oldAccountMap.put(oldAccount.Id, oldAccount);
        
        Map<Id, Account> newAccountMap = new Map<Id, Account>();
        newAccountMap.put(newAccount.Id, newAccount);
        
        Test.startTest();
        AccountTriggerHandler.createOpportunity(newAccountMap, oldAccountMap);
        Test.stopTest();
        
        // Query for the inserted Opportunity
        List<Opportunity> insertedOpportunities = [SELECT AccountId, Name, StageName, CloseDate FROM Opportunity];
        
        // Verify that an Opportunity record was inserted
        System.assertEquals(1, insertedOpportunities.size());
        
        // Verify that the Opportunity has the correct values
        Opportunity insertedOpportunity = insertedOpportunities[0];
        System.assertEquals(newAccount.Id, insertedOpportunity.AccountId);
        System.assertEquals(newAccount.Name, insertedOpportunity.Name);
        System.assertEquals('Needs Analysis', insertedOpportunity.StageName);
        System.assertEquals(System.today().addDays(3), insertedOpportunity.CloseDate);
    }
}