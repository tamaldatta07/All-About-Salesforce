@isTest
public class PublishPlatformEventCallbackTest {

    // Mock implementation for EventBus.SuccessResult
    private class MockSuccessResult implements EventBus.SuccessResult {
        public List<String> getEventUuids() {
            return new List<String>{ 'UUID-12345', 'UUID-67890' };
        }
    }

    // Mock implementation for EventBus.FailureResult
    private class MockFailureResult implements EventBus.FailureResult {
        public List<String> getEventUuids() {
            return new List<String>{ 'UUID-FAIL-111', 'UUID-FAIL-222' };
        }
    }

    @isTest
    static void testOnSuccessCreatesTask() {
        // Arrange
        PublishPlatformEventCallback callback = new PublishPlatformEventCallback();
        MockSuccessResult successResult = new MockSuccessResult();

        // Act
        Test.startTest();
        callback.onSuccess(successResult);
        Test.stopTest();

        // Assert
        List<Task> tasks = [SELECT Subject, Description FROM Task WHERE Subject = 'Event Published'];
        System.assertEquals(1, tasks.size(), 'One success task should be created');
        System.assert(tasks[0].Description.contains('UUID-12345'), 'Description should contain UUID');
    }

    @isTest
    static void testOnFailureCreatesTask() {
        // Arrange
        PublishPlatformEventCallback callback = new PublishPlatformEventCallback();
        MockFailureResult failureResult = new MockFailureResult();

        // Act
        Test.startTest();
        callback.onFailure(failureResult);
        Test.stopTest();

        // Assert
        List<Task> tasks = [SELECT Subject, Description FROM Task WHERE Subject = 'Event Publish Failed'];
        System.assertEquals(1, tasks.size(), 'One failure task should be created');
        System.assert(tasks[0].Description.contains('UUID-FAIL-111'), 'Description should contain failure UUID');
    }

    
}