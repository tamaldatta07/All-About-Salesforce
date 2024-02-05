/**
 * QueueableAccountUpdate.cls
 * 
 * This Queueable Apex class updates the 'AnnualRevenue' on Account record to a fixed value of '1000000'.
 */

public class QueueableAccountUpdate implements Queueable {

    private List<Id> accountIds;

    // Constructor to accept parameters
    public QueueableAccountUpdate(List<Id> ids) {
        this.accountIds = ids;
    }

    // The execute method is called when the job is processed by the queue
    public void execute(QueueableContext context) {
        // Perform asynchronous processing
        List<Account> accountsToUpdate = [SELECT Id, Name, AnnualRevenue FROM Account WHERE Id IN :accountIds];

        // Update the 'AnnualRevenue' to a fixed value (for demonstration purposes)
        Decimal newAnnualRevenue = 1000000;
        for (Account acc : accountsToUpdate) {
            acc.AnnualRevenue = newAnnualRevenue;
        }

        // Update the batch of accounts in the database
        update accountsToUpdate;

        // For demonstration purposes, log the number of accounts updated
        System.debug(accountsToUpdate.size() + ' Account(s) updated with AnnualRevenue: ' + newAnnualRevenue);
    }
}

/*Anonymous window Code
List<Id> accountIdsToUpdate = new List<Id>{'0015h00001085mJAAQ'};
Queueable myQueueable = new QueueableAccountUpdate(accountIdsToUpdate);

// Enqueue the job
System.enqueueJob(myQueueable);*/