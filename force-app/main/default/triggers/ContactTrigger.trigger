trigger ContactTrigger on Contact (before insert, after insert, after update,before delete) {
    /*if(trigger.isInsert && trigger.IsBefore){
        for(Contact contObj:trigger.new){
            contObj.LeadSource = 'Trade Show';
        }
    }
    if(trigger.isAfter){
        if(trigger.isInsert){
            ContactTriggerHandler.countContactOnInsert(trigger.new);
        }
        if(trigger.isUpdate){
            ContactTriggerHandler.countContactOnUpdate(trigger.newMap,trigger.oldMap);
        }
    }
    if(trigger.isBefore && trigger.isDelete){
        ContactTriggerHandler.countContactOnDelete(trigger.old);
    }*/
}