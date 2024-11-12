import { LightningElement, api, track } from 'lwc';

export default class OpportunityListLWC extends LightningElement {
    @api opportunities;
    @track selectedOpportunity;

    handleOpportunityClick(event) {
        const opportunityId = event.target.dataset.id;
        this.selectedOpportunity = this.opportunities.find(op => op.id === opportunityId);
    }
}
