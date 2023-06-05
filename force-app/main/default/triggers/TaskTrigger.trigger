//Whenever a new task is created set the priority High
trigger TaskTrigger on Task (before insert) {
    /*if(Trigger.isInsert && Trigger.isBefore){
        for(Task taskRecord : Trigger.new){
            System.debug('Found Task Record');
            taskRecord.Priority='High';
        }
    }*/

}