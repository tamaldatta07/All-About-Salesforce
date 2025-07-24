/**
 * This class implements the EventBus event publishing callback interfaces
 * to handle success and failure events for platform event publishing.
 * It logs the result in a Task record with basic details.
 */
public with sharing class PublishPlatformEventCallback 
    implements EventBus.EventPublishSuccessCallback, EventBus.EventPublishFailureCallback {

    /**
     * Callback method called when a platform event is successfully published.
     * @param result The success result containing event UUIDs.
     */
    public void onSuccess(EventBus.SuccessResult result) {
        List<String> eventUUIDList = result.getEventUuids();
        insertTask(eventUUIDList, true);
    }

    /**
     * Callback method called when publishing a platform event fails.
     * @param result The failure result containing event UUIDs.
     */
    public void onFailure(EventBus.FailureResult result) {
        List<String> eventUUIDList = result.getEventUuids();
        insertTask(eventUUIDList, false); // Pass false to indicate failure
    }

    /**
     * Helper method to create and insert a Task record based on the result.
     * @param eventUUIDList List of event UUIDs returned by the callback.
     * @param isSuccess Indicates whether the publish operation succeeded.
     */
    private void insertTask(List<String> eventUUIDList, Boolean isSuccess) {
        // Guard clause to skip if no UUIDs are present
        if (eventUUIDList == null || eventUUIDList.isEmpty()) {
            return;
        }

        // Join UUIDs into a comma-separated string for logging
        String eventUUIDString = String.join(eventUUIDList, ', ');

        // Create Task record
        Task taskDetail = new Task();
        taskDetail.ActivityDate = Date.today(); // Set due date to today

        if (isSuccess) {
            taskDetail.Subject = 'Event Published';
            taskDetail.Description = 'Total events successfully published: ' + eventUUIDList.size() +
                                     '\nEvent UUIDs: ' + eventUUIDString;
        } else {
            taskDetail.Subject = 'Event Publish Failed';
            taskDetail.Description = 'Total events failed to publish: ' + eventUUIDList.size() +
                                     '\nEvent UUIDs: ' + eventUUIDString;
        }

        // Perform DML operation with error handling
        try {
            insert taskDetail;
        } catch (DmlException e) {
            // Log the error for debugging purposes
            System.debug('Error inserting task: ' + e.getMessage());
        }
    }
}