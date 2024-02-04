//Demo of Future Method. This calss will count total number of contacts in an Account.

public class AccountCalculator {
	@future
    public static void countContacts(List<Id> accIds){
        List<Account> accList = [SELECT Id, (SELECT Id FROM Contacts) FROM Account WHERE Id IN: accIds];
        
        for(Account acc : accList){
            acc.Number_of_Contacts__c = acc.Contacts.size(); // Store contact size in 'Number_of_Contacts__c' field on Account object.
        }
        
        if(!accList.isEmpty()){  //Null check statement
            update accList;
        }
    }
}

//Anonymous Window Code
/*List<Account>accList = [SELECT Id FROM Account Limit 5];
List<Id> accIds = new List<Id>();

for(Account acc : accList){
    accIds.add(acc.id);
}
AccountCalculator.countContacts(accIds);*/