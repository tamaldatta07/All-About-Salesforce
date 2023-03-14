@isTest
public class CaseHelperTest {
    @isTest
    static void testAssignUniqueCaseNames() {
        // Create test custom setting record
        Custom_Settings__c cSettings = new Custom_Settings__c(FB__c=0, INSTA__c=0, TWT__c=0);
        insert cSettings;
        
        // Create test cases
        List<Case> newCases = new List<Case>();
        Case testCase1 = new Case(Subject='Test Case 1', Origin='Phone', Case_channel__c='Facebook');
        Case testCase2 = new Case(Subject='Test Case 2', Origin='Phone', Case_channel__c='Instagram');
        Case testCase3 = new Case(Subject='Test Case 3', Origin='Phone', Case_channel__c='Twitter');
        newCases.add(testCase1);
        newCases.add(testCase2);
        newCases.add(testCase3);
        
        // Call CaseHelper.assignUniqueCaseNames() method
        Test.startTest();
        CaseHelper.assignUniqueCaseNames(newCases);
        Test.stopTest();
        
        // Verify results
        System.assertEquals('FB-2', testCase1.Case_Name__c);
        System.assertEquals(2, cSettings.FB__c);
        System.assertEquals('INS-2', testCase2.Case_Name__c);
        System.assertEquals(2, cSettings.INSTA__c);
        System.assertEquals('TWT-2', testCase3.Case_Name__c);
        System.assertEquals(2, cSettings.TWT__c);
    }
}