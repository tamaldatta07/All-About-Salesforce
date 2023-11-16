public class CaseTriggerHandler {
    public static void updateCaseOwner(List<Case> newCases, Map<Id, Case> oldMap) {
        List<Id> caseIdsToUpdate = new List<Id>();
        
        for (Case newCase : newCases) {
            Case oldCase = oldMap.get(newCase.Id);
            
            // Check if the subject field has changed
            if (newCase.Subject != oldCase.Subject) {
                caseIdsToUpdate.add(newCase.Id);
            }
        }
        
        if (!caseIdsToUpdate.isEmpty()) {
            resetCaseOwnerToQueue(caseIdsToUpdate);
        }
    }

    private static void resetCaseOwnerToQueue(List<Id> caseIds) {
        
        List<Case> casesToUpdate = new List<Case>();
        
        for (Id caseId : caseIds) {
            Case c = new Case(Id = caseId, OwnerId = '00G5h000003WXOeEAO');
            casesToUpdate.add(c);
        }
        
        update casesToUpdate;
    }
}