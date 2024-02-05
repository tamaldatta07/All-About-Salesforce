/**
 * ScheduledAccountUpdate.cls
 * 
 * This Queueable Apex class updates the 'AnnualRevenue' on Account record to a fixed value of '1500000'.
 */

global class ScheduledAccountUpdate implements Schedulable {

    // The execute method is called when the job is scheduled to run
    global void execute(SchedulableContext context) {
        // Perform processing
        List<Account> accountsToUpdate = [SELECT Id, Name, AnnualRevenue FROM Account LIMIT 100];

        // Update the 'AnnualRevenue' to a fixed value (for demonstration purposes)
        Decimal newAnnualRevenue = 1500000;
        for (Account acc : accountsToUpdate) {
            acc.AnnualRevenue = newAnnualRevenue;
        }

        // Update the batch of accounts in the database
        update accountsToUpdate;

        // For demonstration purposes, log the number of accounts updated
        System.debug(accountsToUpdate.size() + ' Account(s) updated with AnnualRevenue: ' + newAnnualRevenue);
    }
}