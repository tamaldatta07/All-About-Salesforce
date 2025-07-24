@isTest
public class publishPlatformEventTest {

    @isTest
    static void testPublishPlatformEventDemo() {
        // Start test context
        Test.startTest();

        // Call the method to test platform event publishing
        publishPlatformEvent.publishPlatformEventDemo();

        // End test context to ensure all async behavior is completed
        Test.stopTest();

        // Validate that Task records are created as callback logs
        List<Task> tasks = [
            SELECT Subject, Description, ActivityDate
            FROM Task
            WHERE Subject IN ('Event Published', 'Event Publish Failed')
        ];

        // We expect at least one Task to be created by the callback
        System.assert(tasks.size() > 0, 'At least one Task should be created after publishing platform events');

        // Optionally log task details for visibility
        for (Task t : tasks) {
            System.debug('Task Subject: ' + t.Subject);
            System.debug('Task Description: ' + t.Description);
        }
    }
}