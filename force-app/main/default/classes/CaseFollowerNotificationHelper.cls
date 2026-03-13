public class CaseFollowerNotificationHelper {
    
    private static final String NOTIFICATION_DEV_NAME = 'Case_field_update';
    
    // Changed: now accepts Map<Id, List<String>>
    public static void sendNotificationToCaseFollowers(Map<Id, List<String>> caseIdToChangeList) {
        if (caseIdToChangeList == null || caseIdToChangeList.isEmpty()) return;
        
        List<CustomNotificationType> notifTypes = [
            SELECT Id FROM CustomNotificationType 
            WHERE DeveloperName = :NOTIFICATION_DEV_NAME 
            LIMIT 1
        ];
        if (notifTypes.isEmpty()) return;
        Id notifTypeId = notifTypes[0].Id;
        
        Map<Id, Case> caseMap = new Map<Id, Case>([
            SELECT Id, CaseNumber, Subject 
            FROM Case 
            WHERE Id IN :caseIdToChangeList.keySet()
        ]);
        
        List<EntitySubscription> subscriptions = [
            SELECT SubscriberId, ParentId 
            FROM EntitySubscription 
            WHERE ParentId IN :caseIdToChangeList.keySet()
        ];
        if (subscriptions.isEmpty()) return;
        
        Map<Id, Set<String>> caseToFollowers = new Map<Id, Set<String>>();
        for (EntitySubscription sub : subscriptions) {
            if (!caseToFollowers.containsKey(sub.ParentId)) {
                caseToFollowers.put(sub.ParentId, new Set<String>());
            }
            caseToFollowers.get(sub.ParentId).add(sub.SubscriberId);
        }
        
        for (Id caseId : caseToFollowers.keySet()) {
            Case c = caseMap.get(caseId);
            if (c == null) continue;
            
            Set<String> recipients = caseToFollowers.get(caseId);
            List<String> changes = caseIdToChangeList.get(caseId);
            String subject = String.isNotBlank(c.Subject) ? c.Subject : 'No Subject';
            
            //Loop each field change → send ONE notification per change
            for (String changeInfo : changes) {
                Messaging.CustomNotification notif = new Messaging.CustomNotification();
                notif.setNotificationTypeId(notifTypeId);
                notif.setTargetId(caseId);
                notif.setTitle('Case Updated: ' + c.CaseNumber);
                notif.setBody('Case "' + subject + '" updated. ' + changeInfo);
                
                try {
                    notif.send(recipients);
                } catch (Exception e) {
                    System.debug('Notification error for Case ' + caseId + ': ' + e.getMessage());
                }
            }
        }
    }
}