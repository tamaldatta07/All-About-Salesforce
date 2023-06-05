// On Account Object for Creating a new record if the rating is "Hot" then user should put type, Otherwise the record will not save. Create a contact when an account is created.


trigger AccountTrigger on Account (before insert, after insert) {
   /* if(trigger.isInsert && trigger.isBefore){
        for(Account actObj:trigger.new){
            if(actObj.Rating=='Hot' && actObj.Type==null){
                actObj.addError('Account Type is Mandatory when Rating is Hot');
            }
        }
    }
    if(trigger.isInsert && trigger.isAfter){
        List <Contact> contactList = new List<Contact>(); 
        for(Account actObj:trigger.new){
            Contact contObj = new Contact();
            contObj.LastName = actObj.Name;
            contObj.AccountId = actObj.Id;
            contactList.add(contObj);
            
        }
        if(contactList!=null && contactList.size()>0){
            insert contactList;
        }
    }
    */
}