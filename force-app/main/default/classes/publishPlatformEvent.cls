public class publishPlatformEvent {
    public static void publishPlatformEventDemo(){
        List<Order_Detail__e> orderDetailsEvent = new List<Order_Detail__e>();
        orderDetailsEvent.add(
            new Order_Detail__e (
                Order_Number__c = 'ORD0011',
                Generate_Invoice__c = false
            )
        );
        
        orderDetailsEvent.add(
            new Order_Detail__e (
                Order_Number__c = 'ORD0091',
                Generate_Invoice__c = false
            )
        );
        
        orderDetailsEvent.add(
            new Order_Detail__e (
                Order_Number__c = 'ORD00011',
                Generate_Invoice__c = false
            )
        );
        
        List<Database.SaveResult> publishList = Eventbus.publish(orderDetailsEvent);
        
        for(Database.SaveResult publishItem : publishList){
            if(publishItem.isSuccess()){
                System.debug('Platform Event Published successfully');
            }
            else{
                List<Database.error> errList = publishItem.getErrors();
                for (Database.error errorDetail : errList){
                    System.debug('Error Detail: '+ errorDetail.getMessage());
                }
            }
        }
    }
}