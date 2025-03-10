//Write a method that will check the user's password input and it will throw an error after 3rd attempt.
//Anonymous window code :- BasicUseCaseinApex.attemptDifferentPasswords();
public class BasicUseCaseinApex {
    public static String correctPass = 'Hello_World';
    public static Integer attemptCounter = 1;
    
    public static void attemptDifferentPasswords(){
        String finalValue = '';
        finalValue = passwordHandler('Hello_Worldd');
        System.debug(finalValue);
        finalValue = passwordHandler('Hello_Worlld');
        System.debug(finalValue);
        finalValue = passwordHandler('Heello_Worldd');
        System.debug(finalValue);
        finalValue = passwordHandler('Hhello_Worldd');
        System.debug(finalValue);
    }
    
    public static String passwordHandler(String passwordInput){
        if(passwordInput != correctPass){
            //attemptCounter++;
            if(attemptCounter > 3){
                return 'Limit Crossed. Please check with Admin.';
            }
            attemptCounter++;
            return 'failure';
            
        }else{
            return 'success';
        }
    }

}