import { LightningElement, wire, track } from 'lwc';
import getAccountsAndContacts from '@salesforce/apex/AccountTreeController.getAccountsAndContacts';
import { refreshApex } from '@salesforce/apex';

export default class AccountTreeComponent extends LightningElement {
    @track treeData = [];
    @track selectedAccountId = null;
    wiredAccountResult;

    columns = [
        { label: 'Account Name', fieldName: 'accountName', type: 'text' }
    ];

    @wire(getAccountsAndContacts)
    wiredAccounts(result) {
        this.wiredAccountResult = result;
        const { data, error } = result;
        if (data) {
            this.treeData = this.processData(data);
        } else if (error) {
            console.error('Error fetching account data:', error);
        }
    }

    processData(data) {
        return data.map(account => {
            const children = account.contacts.map(contact => ({
                accountId: contact.contactId,
                accountName: contact.contactName,
                _children: []
            }));

            return {
                accountId: account.accountId,
                accountName: account.accountName,
                _children: children
            };
        });
    }

    handleRowSelection(event) {
        const selectedRows = event.detail.selectedRows;
        if (selectedRows.length > 0) {
            this.selectedAccountId = selectedRows[0].accountId;
        }
    }

    handleRefresh() {
        this.selectedAccountId = null;
        refreshApex(this.wiredAccountResult);
    }
}
