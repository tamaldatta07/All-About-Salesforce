import { LightningElement, wire, api } from 'lwc';
import searchAccounts from '@salesforce/apex/AccountController.searchAccounts';
import { refreshApex } from '@salesforce/apex';
import { updateRecord } from 'lightning/uiRecordApi';
const columns = [
    { label: 'Account Name', fieldName: 'Name' },
    { label: 'Account Owner', fieldName: 'Owner.Name' },
    { label: 'Phone', fieldName: 'Phone', type: 'phone' },
    { label: 'Website', fieldName: 'Website', type: 'url' },
];

export default class AccountSearch extends LightningElement {
    searchTerm = '';
    accounts = [];

    @wire(searchAccounts, { searchTerm: '$searchTerm' })
    wiredAccounts({ error, data }) {
        if (data) {
            this.accounts = data;
        } else if (error) {
            console.error(error);
        }
    }

    
    handleSearchChange(event) {
        this.searchTerm = event.target.value;
    }

    get columns() {
        return columns;
    }
}