@IsTest
private class AccountControllerTest {
    @IsTest
    static void testSearchAccounts() {
        // Create test data
        List<Account> testAccounts = new List<Account>();
        for (Integer i = 1; i <= 10; i++) {
            Account acc = new Account(Name = 'Test Account ' + i);
            testAccounts.add(acc);
        }
        insert testAccounts;
        
        // Call the method being tested
        Test.startTest();
        List<Account> result = AccountController.searchAccounts('Test');
        Test.stopTest();
        
        // Verify the returned results
        System.assertEquals(10, result.size());
        
        // Verify that each Account has the expected fields populated
        for (Integer i = 0; i < 10; i++) {
            Account account = result[i];
            System.assertEquals('Test Account ' + (i + 1), account.Name);
            System.assertEquals(0, account.Contacts.size());
            System.assertEquals(0, account.Opportunities.size());
        }
    }
}