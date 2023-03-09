public with sharing class CurrentUserDetailsController {
    @AuraEnabled(cacheable=true)
    public static User getCurrentUserDetails() {
        return [SELECT Id, Name, Email, UserRole.Name, LastLoginDate FROM User WHERE Id = :UserInfo.getUserId()];
    }
}