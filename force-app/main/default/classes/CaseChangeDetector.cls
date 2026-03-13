public class CaseChangeDetector {
    
    public static Map<Id, List<String>> detectChanges(
        List<Case> newCases, 
        Map<Id, Case> oldCaseMap
    ) {
        CaseFieldTrackerService.FieldTrackerConfig config = CaseFieldTrackerService.getConfig();
        Map<String, Schema.SObjectField> allCaseFields = Schema.SObjectType.Case.fields.getMap();
        
        Set<String> alwaysExclude = new Set<String>{
            'lastmodifieddate', 'lastmodifiedbyid', 'systemmodstamp',
            'lastvieweddate', 'lastreferenceddate', 'lastactivitydate',
            'createddate', 'createdbyid'
        };
        
        // Changed: Map<Id, List<String>> — one entry per changed field
        Map<Id, List<String>> caseIdToChangeList = new Map<Id, List<String>>();
        
        for (Case newCase : newCases) {
            Case oldCase = oldCaseMap.get(newCase.Id);
            List<String> changes = new List<String>();
            
            for (String fieldApi : allCaseFields.keySet()) {
                String fieldLower = fieldApi.toLowerCase();
                
                if (alwaysExclude.contains(fieldLower)) continue;
                if (config.excludedFields.contains(fieldLower)) continue;
                if (!config.trackAllFields && !config.includedFields.contains(fieldLower)) continue;
                
                Object oldVal, newVal;
                try {
                    oldVal = oldCase.get(fieldApi);
                    newVal = newCase.get(fieldApi);
                } catch (Exception e) {
                    continue;
                }
                
                if (oldVal != newVal) {
                    String fieldLabel = allCaseFields.get(fieldApi).getDescribe().getLabel();
                    String oldStr = oldVal != null ? String.valueOf(oldVal) : 'Empty';
                    String newStr = newVal != null ? String.valueOf(newVal) : 'Empty';
                    
                    // Each field change is a separate entry in the list
                    changes.add(fieldLabel + ': ' + oldStr + ' → ' + newStr);
                }
            }
            
            if (!changes.isEmpty()) {
                caseIdToChangeList.put(newCase.Id, changes);
            }
        }
        
        return caseIdToChangeList;
    }
}