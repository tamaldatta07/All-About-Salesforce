import { LightningElement, wire } from 'lwc';


import getCurrentUserDetails from '@salesforce/apex/CurrentUserDetailsController.getCurrentUserDetails';

export default class UserDetails extends LightningElement {
    user;

    @wire(getCurrentUserDetails)
    wiredUser({ data, error }) {
        if (data) {
            this.user = data;
        } else if (error) {
            console.error(error);
        }
    }
}