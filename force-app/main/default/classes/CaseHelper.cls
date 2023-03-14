public class CaseHelper {
    public static void assignUniqueCaseNames(List<Case> newCases) {
        String actualOrigin = 'Phone';
        Custom_Settings__c cSettings = new Custom_Settings__c();
        cSettings = [select FB__c,INSTA__c,TWT__c from Custom_Settings__c LIMIT 1];
        Integer FBNumber = Integer.valueOf(cSettings.FB__c);
        Integer INSNumber = Integer.valueOf(cSettings.INSTA__c);
        Integer TWTNumber = Integer.valueOf(cSettings.TWT__c);
        for(Case caseRecord : newCases){
            if(caseRecord.Origin == actualOrigin && caseRecord.Case_channel__c == 'Facebook'){
                caseRecord.Case_Name__c = 'FB-'+(FBNumber + 1);
                cSettings.FB__c = FBNumber + 1;
            }
            else if(caseRecord.Origin == actualOrigin && caseRecord.Case_channel__c == 'Instagram'){
                caseRecord.Case_Name__c = 'INS-'+(INSNumber + 1);
                cSettings.INSTA__c = INSNumber + 1;
            }
            else if(caseRecord.Origin ==actualOrigin && caseRecord.Case_channel__c == 'Twitter'){
                caseRecord.Case_Name__c = 'TWT-'+(TWTNumber + 1);
                cSettings.TWT__c = TWTNumber + 1;
            }
        }
        update cSettings;
    }
}