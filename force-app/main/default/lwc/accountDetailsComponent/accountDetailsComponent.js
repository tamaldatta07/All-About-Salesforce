import { LightningElement, api, track } from 'lwc';
import getAccountDetailsById from '@salesforce/apex/AccountTreeController.getAccountDetailsById';

export default class AccountDetailsComponent extends LightningElement {
    @api accountId;
    @track accountData;
    @track isLoading = true;

    async connectedCallback() {
        if (this.accountId) {
            await this.fetchAccountDetails();
        }
    }

    async fetchAccountDetails() {
        try {
            const data = await getAccountDetailsById({ accountId: this.accountId });
            this.accountData = data;
        } catch (error) {
            console.error('Error fetching account details:', error);
        } finally {
            this.isLoading = false;
        }
    }

    // Watch for changes in the accountId property
    async renderedCallback() {
        if (this.accountId && !this.accountData) {
            this.isLoading = true;
            await this.fetchAccountDetails();
        }
    }
}
