@isTest
private class CaseTriggerTest {
    @isTest
    static void testAssignUniqueCaseNames() {
        // Create test cases
        List<Case> testCases = new List<Case>();
        for (Integer i = 0; i < 5; i++) {
            testCases.add(new Case(
                Subject = 'Test Case ' + i,
                Description = 'Test description'
            ));
        }
        // Insert test cases
        Test.startTest();
        insert testCases;
        Test.stopTest();
        // Verify that case names are unique
        Set<String> caseNames = new Set<String>();
        for (Case c : testCases) {
            caseNames.add(c.CaseNumber);
        }
        System.assertEquals(testCases.size(), caseNames.size());
    }
}