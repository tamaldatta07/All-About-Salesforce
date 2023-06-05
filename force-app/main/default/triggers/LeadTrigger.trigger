//Whenever a lead record is updated set the Lead status to "Working-Contacted"
trigger LeadTrigger on Lead (before update) {
    /*if(Trigger.isBefore && Trigger.isUpdate){
        for(Lead leadRec : Trigger.new){
            leadRec.Status = 'Working-Contacted';
        }
    }*/

}