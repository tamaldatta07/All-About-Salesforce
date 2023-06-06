// On Account Object for Creating a new record if the rating is "Hot" then user should put type, Otherwise the record will not save. Create a contact when an account is created.


trigger AccountTrigger on Account (before insert, after insert, after update) {
    /*if(trigger.isInsert && trigger.isBefore){
        AccountTriggerHandler.validateAccountBeforeInsert(trigger.new);
    }
    if(trigger.isInsert && trigger.isAfter){
        AccountTriggerHandler.insertContact(trigger.new);
    }
    
    if(trigger.isUpdate && trigger.isAfter){
        AccountTriggerHandler.createOpportunity(trigger.NewMap,trigger.OldMap);
    }*/
}