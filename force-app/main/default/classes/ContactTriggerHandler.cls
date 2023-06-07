public with sharing class ContactTriggerHandler{
    public ContactTriggerHandler() {
        
    }
    public static void countContactOnInsert(List<Contact>contactList){
        Set<Id>accountIdSet = new Set<Id>();
        Map<Id,Account>accountMap = new Map<Id,Account>();
        for(Contact contObj:contactList){
            if(contObj.AccountId!=null){
                accountIdSet.add(contObj.AccountId);
            }
        }
        if(accountIdSet!=null && accountIdSet.size()>0){
            for(AggregateResult agResultObj:[select count(id) contCount,AccountId
                                             from Contact where AccountId in:accountIdSet
                                             group by AccountId]){
                                                 Account actObj = new Account(id=(Id)agResultObj.get('AccountId'),
                                                                              Contact_Count__c=(Decimal)agResultObj.get('contCount'));
                                                 accountMap.put(actObj.Id,actObj);
                                             }
            if(accountMap!=null && accountMap.size()>0){
                update accountMap.values();
            }
        }
    }
    public static void countContactOnUpdate(Map<Id,Contact>contNewMap,Map<Id,Contact>contOldMap){
        Set<Id>accountIdSet = new Set<Id>();
        Map<Id,Account>accountMap = new Map<Id,Account>();
        for(Contact contObj:contNewMap.values()){
            if(contNewMap.get(contObj.Id).AccountId!=contOldMap.get(contObj.Id).AccountId){
                if(contNewMap.get(contObj.Id).AccountId!=null){
                    accountIdSet.add(contNewMap.get(contObj.Id).AccountId);
                }
                if(contOldMap.get(contObj.Id).AccountId!=null){
                    accountIdSet.add(contOldMap.get(contObj.Id).AccountId);
                }
            }
        }
        if(accountIdSet!=null && accountIdSet.size()>0){
            for(AggregateResult agResultObj:[select count(id) contCount,AccountId
                                             from Contact where AccountId in:accountIdSet
                                             group by AccountId]){
                                                 Account actObj = new Account(id=(Id)agResultObj.get('AccountId'),
                                                                              Contact_Count__c=(Decimal)agResultObj.get('contCount'));
                                                 accountMap.put(actObj.Id,actObj);
                                             }
            if(accountMap!=null && accountMap.size()>0){
                update accountMap.values();
            }
        }
    }
    public static void countContactOnDelete(List<Contact>contactList){
        Set<Id>accountIdSet = new Set<Id>();
        Map<Id,Account>accountMap = new Map<Id,Account>();
        Set<Id>contactIdSet = new Set<Id>();
        for(Contact contObj:contactList){
            if(contObj.AccountId!=null){
                accountIdSet.add(contObj.AccountId);
                contactIdSet.add(contObj.Id);
            }
        }
        if(accountIdSet!=null && accountIdSet.size()>0){
            for(AggregateResult agResultObj:[select count(id) contCount,AccountId
                                             from Contact where AccountId in:accountIdSet and id not in:contactIdSet
                                             group by AccountId]){
                                                 Account actObj = new Account(id=(Id)agResultObj.get('AccountId'),
                                                                              Contact_Count__c=(Decimal)agResultObj.get('contCount'));
                                                 accountMap.put(actObj.Id,actObj);
                                             }
            if(accountMap!=null && accountMap.size()>0){
                update accountMap.values();
            }
        }
    }
}