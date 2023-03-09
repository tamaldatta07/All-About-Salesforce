@isTest
private class CaseTriggerTest {
    static testMethod void testCaseTrigger() {
        // Create Custom Setting record
        Custom_Settings__c cSettings = new Custom_Settings__c(FB__c = 0, INSTA__c = 0, TWT__c = 0);
        insert cSettings;
        
        // Create a Case record with Origin = 'Phone' and Case_channel__c = 'Facebook'
        Case caseRecord1 = new Case(Origin = 'Phone', Case_channel__c = 'Facebook');
        insert caseRecord1;
        // Verify that the Case record's Case_Name__c field was set to 'FB-1'
        System.assertEquals('FB-1', caseRecord1.Case_Name__c);
        // Verify that the Custom Setting record's FB__c field was incremented to '1'
        cSettings = [SELECT FB__c FROM Custom_Settings__c LIMIT 1];
        System.assertEquals(1, Integer.valueOf(cSettings.FB__c));
        
        // Create a Case record with Origin = 'Phone' and Case_channel__c = 'Instagram'
        Case caseRecord2 = new Case(Origin = 'Phone', Case_channel__c = 'Instagram');
        insert caseRecord2;
        // Verify that the Case record's Case_Name__c field was set to 'INS-1'
        System.assertEquals('INS-1', caseRecord2.Case_Name__c);
        // Verify that the Custom Setting record's INSTA__c field was incremented to '1'
        cSettings = [SELECT INSTA__c FROM Custom_Settings__c LIMIT 1];
        System.assertEquals(1, Integer.valueOf(cSettings.INSTA__c));
        
        // Create a Case record with Origin = 'Phone' and Case_channel__c = 'Twitter'
        Case caseRecord3 = new Case(Origin = 'Phone', Case_channel__c = 'Twitter');
        insert caseRecord3;
        // Verify that the Case record's Case_Name__c field was set to 'TWT-1'
        System.assertEquals('TWT-1', caseRecord3.Case_Name__c);
        // Verify that the Custom Setting record's TWT__c field was incremented to '1'
        cSettings = [SELECT TWT__c FROM Custom_Settings__c LIMIT 1];
        System.assertEquals(1, Integer.valueOf(cSettings.TWT__c));
    }
}