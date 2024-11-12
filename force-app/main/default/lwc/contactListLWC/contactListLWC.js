import { LightningElement, api, track } from 'lwc';

export default class ContactListLWC extends LightningElement {
    @api contacts;
    @track selectedContact;

    handleContactClick(event) {
        const contactId = event.target.dataset.id;
        this.selectedContact = this.contacts.find(con => con.id === contactId);

        // Emit contact click event
        const contactClickEvent = new CustomEvent('contactclick', {
            detail: contactId
        });
        this.dispatchEvent(contactClickEvent);
    }

    @api
    showOpportunities(opportunities) {
        this.selectedContact.opportunities = opportunities;
    }
}
