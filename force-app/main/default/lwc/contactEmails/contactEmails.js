import { LightningElement, api, track } from "lwc";
import getContactEmails from "@salesforce/apex/ContactEmailController.getContactEmails";

const COLUMNS = [
  {
    label: "Subject",
    fieldName: "SubjectUrl",
    type: "url",
    typeAttributes: { label: { fieldName: "Subject" }, target: "_blank" },
    cellAttributes: {
      iconName: { fieldName: "DirectionIcon" },
      iconPosition: "left"
    },
    sortable: true
  },
  { label: "From", fieldName: "FromAddress", type: "email", sortable: true },
  { label: "To", fieldName: "ToAddress", type: "text", sortable: false },
  {
    label: "Date",
    fieldName: "MessageDate",
    type: "date",
    sortable: true,
    typeAttributes: {
      year: "numeric",
      month: "short",
      day: "2-digit",
      hour: "2-digit",
      minute: "2-digit"
    }
  }
];

export default class ContactEmails extends LightningElement {
  _recordId;

  @api
  set recordId(value) {
    this._recordId = value;
    if (this._recordId) {
      this.loadEmails(true);
    }
  }

  get recordId() {
    return this._recordId;
  }

  columns = COLUMNS;
  @track emails = [];
  error;
  isLoading = false;

  // Pagination & Search State
  rowLimit = 20;
  rowOffset = 0;
  enableInfiniteLoading = true;
  searchKey = "";

  // Sort State
  sortBy = "MessageDate";
  sortDirection = "DESC";
  searchTimeout;

  // --- Core Data Fetching ---
  loadEmails(clearExisting = false) {
    if (clearExisting) {
      this.emails = [];
      this.rowOffset = 0;
      this.enableInfiniteLoading = true;
      this.isLoading = true;
    }

    getContactEmails({
      contactId: this.recordId,
      queryLimit: this.rowLimit,
      queryOffset: this.rowOffset,
      sortField: this.sortBy,
      sortDir: this.sortDirection,
      searchKey: this.searchKey
    })
      .then((result) => {
        const processedData = result.map((record) => ({
          ...record,
          SubjectUrl: `/${record.Id}`,
          DirectionIcon: record.Incoming
            ? "utility:arrow_left"
            : "utility:arrow_right"
        }));

        this.emails = [...this.emails, ...processedData];

        if (result.length < this.rowLimit) {
          this.enableInfiniteLoading = false;
        }

        this.error = undefined;
      })
      .catch((error) => {
        this.error = error;
        this.emails = [];
      })
      .finally(() => {
        this.isLoading = false;
      });
  }

  // --- Feature Actions ---
  handleRefresh() {
    this.loadEmails(true);
  }

  loadMoreData(event) {
    if (!this.enableInfiniteLoading) return;

    const { target } = event;
    target.isLoading = true;

    this.rowOffset += this.rowLimit;

    this.loadEmails(false);
    target.isLoading = false;
  }

  handleSearch(event) {
    const searchValue = event.target.value;

    window.clearTimeout(this.searchTimeout);
    this.searchTimeout = setTimeout(() => {
      this.searchKey = searchValue;
      this.loadEmails(true);
    }, 350);
  }

  handleSort(event) {
    const { fieldName: sortedBy, sortDirection } = event.detail;

    this.sortBy = sortedBy === "SubjectUrl" ? "Subject" : sortedBy;
    this.sortDirection = sortDirection;

    this.loadEmails(true);
  }
}
