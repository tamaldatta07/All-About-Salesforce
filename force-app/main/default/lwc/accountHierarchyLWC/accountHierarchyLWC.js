import { LightningElement, track } from 'lwc';

export default class AccountHierarchyLWC extends LightningElement {
    @track treeData = [];  // Data for tree grid
    @track selectedItem = null;  // Selected item in the tree grid
    @track progress = 0;  // Progress of Contacts and Opportunities viewed
    @track showProgressBar = false;  // Boolean flag for progress bar visibility

    columns = [
        { label: 'Name', fieldName: 'name', type: 'text', editable: false },
        { label: 'Email', fieldName: 'email', type: 'email', editable: false }
    ];

    connectedCallback() {
        this.initializeTreeData();
    }

    initializeTreeData() {
        // Dummy Data for Accounts, Contacts, and Opportunities
        const accountData = [
            {
                id: 'A001',
                name: 'Acme Corporation',
                email: 'info@acmecorp.com',
                type: 'Account',
                contacts: [
                    {
                        id: 'C001',
                        name: 'Alice Johnson',
                        email: 'alice.johnson@acmecorp.com',
                        type: 'Contact',
                        opportunities: [
                            { id: 'O001', name: 'Acme Opportunity 1', type: 'Opportunity' }
                        ]
                    },
                    {
                        id: 'C002',
                        name: 'Bob Smith',
                        email: 'bob.smith@acmecorp.com',
                        type: 'Contact',
                        opportunities: [
                            { id: 'O002', name: 'Acme Opportunity 2', type: 'Opportunity' }
                        ]
                    }
                ]
            },
            {
                id: 'A002',
                name: 'Global Tech',
                email: 'support@globaltech.com',
                type: 'Account',
                contacts: [
                    {
                        id: 'C003',
                        name: 'Charlie Brown',
                        email: 'charlie.brown@globaltech.com',
                        type: 'Contact',
                        opportunities: [
                            { id: 'O003', name: 'Global Tech Opportunity', type: 'Opportunity' }
                        ]
                    }
                ]
            }
        ];

        // Map the data for tree grid
        this.treeData = accountData.map(account => ({
            id: account.id,
            name: account.name,
            email: account.email,
            type: 'Account',
            _children: account.contacts.map(contact => ({
                id: contact.id,
                name: contact.name,
                email: contact.email,
                type: 'Contact',
                _children: contact.opportunities.map(opportunity => ({
                    id: opportunity.id,
                    name: opportunity.name,
                    email: '',
                    type: 'Opportunity'
                }))
            }))
        }));
    }

    // Handle row selection to update details and progress
    handleRowSelection(event) {
        const selectedRows = event.detail.selectedRows;
        if (selectedRows.length > 0) {
            const selectedItem = selectedRows[0];
            this.selectedItem = selectedItem;
            this.updateProgress(selectedItem);
        }
    }

    updateProgress(account) {
        let totalItems = 0;
        let viewedItems = 0;

        // Calculate the total number of contacts and opportunities for the selected account
        account.contacts.forEach(contact => {
            totalItems++;  // Count Contact
            contact.opportunities.forEach(() => {
                totalItems++;  // Count Opportunity
            });
        });

        // Assuming all Contacts and Opportunities are "viewed" when selected
        viewedItems = account.contacts.length + account.contacts.reduce((acc, contact) => acc + contact.opportunities.length, 0);

        // Calculate progress
        this.progress = Math.round((viewedItems / totalItems) * 100);
        this.showProgressBar = true;
    }
}
