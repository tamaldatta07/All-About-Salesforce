@isTest
public class CaseServiceTest {

    @isTest
    public static void testCloseCasesShouldCloseCasesWithTheSpecifiedReason() {
        setupTests();
        
        Set<Id> insertedCasesId = new Set<Id>();
        for (Case c : [SELECT Id FROM Case]) {
            insertedCasesId.add(c.Id);
        }
        
        System.assertEquals(100, insertedCasesId.size());
        
        CaseService.closeCases(insertedCasesId, 'This is my test reason');
        
        System.assertEquals(100, [SELECT Id FROM Case WHERE Status = 'Closed' AND Reason = 'This is my test reason'].size());
    }
    
    @isTest
    public static void testCloseCasesShouldThrowACaseServiceExceptionWithoutCasesToClose() {
        try {
            CaseService.closeCases(new Set<Id>(), '');
            System.assert(false);
        } catch (CaseService.CaseServiceException e) {
            System.assertEquals('You should tell me which cases you wanna close', e.getMessage());
        }    
    }
    
    
    @isTest
    public static void testCloseCasesShouldThrowACaseServiceExceptionWithoutReason() {
        setupTests();
        
        Set<Id> insertedCasesId = new Set<Id>();
        for (Case c : [SELECT Id FROM Case]) {
            insertedCasesId.add(c.Id);
        }
        
        System.assertEquals(100, insertedCasesId.size());
        
        try {
            CaseService.closeCases(insertedCasesId, '');
            System.assert(false);
        } catch (CaseService.CaseServiceException e) {
            System.assertEquals('I won\'t close a case without any reason', e.getMessage());
        }   
    }
    
    private static void setupTests() {
        List<Case> testCases = new List<Case>();
        
        for (Integer i = 0; i < 100; i++) {
            testCases.add(new Case(
            	Subject='This is the test case number ' + i,
                Status='New'
            ));
        }
                
        insert testCases;
    }
}