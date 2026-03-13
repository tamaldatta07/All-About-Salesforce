public class CaseFieldTrackerService {
    
    public class FieldTrackerConfig {
        public Boolean trackAllFields       { get; set; }
        public Set<String> includedFields   { get; set; }
        public Set<String> excludedFields   { get; set; }
        
        public FieldTrackerConfig() {
            this.trackAllFields   = false;
            this.includedFields   = new Set<String>();
            this.excludedFields   = new Set<String>();
        }
    }
    
    public static FieldTrackerConfig getConfig() {
        FieldTrackerConfig config = new FieldTrackerConfig();
        
        List<Case_Field_Tracker__mdt> records = [
            SELECT Field_API_Name__c,
                   Field_Label_Override__c,
                   Is_Active__c,
                   Is_Excluded__c,
                   Track_All_Fields__c
            FROM Case_Field_Tracker__mdt
            WHERE Is_Active__c = true
        ];
        
        for (Case_Field_Tracker__mdt record : records) {
            // If any record has Track All Fields = true, track everything
            if (record.Track_All_Fields__c) {
                config.trackAllFields = true;
            }
            
            if (record.Is_Excluded__c) {
                config.excludedFields.add(record.Field_API_Name__c.toLowerCase());
            } else {
                config.includedFields.add(record.Field_API_Name__c.toLowerCase());
            }
        }
        
        return config;
    }
}