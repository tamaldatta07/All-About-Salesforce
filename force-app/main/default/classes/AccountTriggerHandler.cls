public with sharing class AccountTriggerHandler{
   /* public AccountTriggerHandler() {
        
    }
    //This method Validate Account record
    public static void validateAccountBeforeInsert(List<Account>accountList){
        for(Account actObj:accountList){
            if(actObj.Rating=='Hot' && actObj.Type==null){
                actObj.addError('Account Type is Mandatory when Rating is Hot');
            }
        }
    }
    //This method insert a contact when a account is created
    public static void insertContact(List<Account>accountList){
        List <Contact> contactList = new List<Contact>(); 
        for(Account actObj:accountList){
            Contact contObj = new Contact();
            contObj.LastName = actObj.Name;
            contObj.AccountId = actObj.Id;
            contactList.add(contObj);
            
        }
        if(contactList!=null && contactList.size()>0){
            insert contactList;
        }
    }
    
    public static void createOpportunity(Map<id,Account>actNewMap,Map<id,Account>actOldMap){
        List<Opportunity>opportunityList = new List<Opportunity>();
        for(Account actObj : actNewMap.values()){
            //Compare old value of rating with new value of rating.
            //check whether new value of rating is hot or not.
            if(actNewMap.get(actObj.Id).Rating!=actOldMap.get(actObj.Id).Rating && actNewMap.get(actObj.Id).Rating == 'Hot'){
                Opportunity oppObj = new Opportunity();
                oppObj.AccountId = actObj.Id;
                oppObj.Name =actObj.Name;
                oppObj.StageName = 'Needs Analysis';
                oppObj.CloseDate = System.today().addDays(3);
                opportunityList.add(oppObj);
            }
        }
        if(!opportunityList.isEmpty()){
            try{
                insert opportunityList;
            }
            catch(Exception e){
                System.debug('eg:'+e.getMessage());
            }
            
        }
    }*/
}