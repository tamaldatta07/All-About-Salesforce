import { LightningElement, api, track } from "lwc";
import getContactEmails from "@salesforce/apex/ContactEmailController.getContactEmails";
import getTotalEmailCount from "@salesforce/apex/ContactEmailController.getTotalEmailCount"; // Import new method

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
  { label: "Status", fieldName: "Status", type: "text", sortable: true },
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

  rowLimit = 20;
  rowOffset = 0;
  enableInfiniteLoading = true;
  searchKey = "";
  filterStartDate = null;
  filterEndDate = null;
  filterStatus = "";
  totalEmailCount = 0; // New tracking variable

  sortBy = "MessageDate";
  sortDirection = "DESC";
  searchTimeout;

  // Dynamic title logic
  get cardTitle() {
    return `Related Emails (${this.totalEmailCount})`;
  }

  get statusOptions() {
    return [
      { label: "All Statuses", value: "" },
      { label: "New", value: "0" },
      { label: "Read", value: "1" },
      { label: "Replied", value: "2" },
      { label: "Sent", value: "3" },
      { label: "Forwarded", value: "4" }
    ];
  }

  // New function to fetch count
  fetchTotalCount() {
    getTotalEmailCount({
      contactId: this.recordId,
      searchKey: this.searchKey,
      startDate: this.filterStartDate,
      endDate: this.filterEndDate,
      statusFilter: this.filterStatus
    })
      .then((count) => {
        this.totalEmailCount = count;
      })
      .catch((error) => {
        console.error("Error retrieving count", error);
        this.totalEmailCount = 0;
      });
  }

  loadEmails(clearExisting = false) {
    if (clearExisting) {
      this.emails = [];
      this.rowOffset = 0;
      this.enableInfiniteLoading = true;
      this.isLoading = true;
      this.fetchTotalCount(); // Fetch count whenever we apply a new filter or refresh
    }

    getContactEmails({
      contactId: this.recordId,
      queryLimit: this.rowLimit,
      queryOffset: this.rowOffset,
      sortField: this.sortBy,
      sortDir: this.sortDirection,
      searchKey: this.searchKey,
      startDate: this.filterStartDate,
      endDate: this.filterEndDate,
      statusFilter: this.filterStatus
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

  handleDateChange(event) {
    const fieldName = event.target.name;
    if (fieldName === "startDate") {
      this.filterStartDate = event.target.value;
    } else if (fieldName === "endDate") {
      this.filterEndDate = event.target.value;
    }

    this.loadEmails(true);
  }

  handleStatusChange(event) {
    this.filterStatus = event.detail.value;
    this.loadEmails(true);
  }

  handleSort(event) {
    const { fieldName: sortedBy, sortDirection } = event.detail;

    this.sortBy = sortedBy === "SubjectUrl" ? "Subject" : sortedBy;
    this.sortDirection = sortDirection;

    this.loadEmails(true);
  }
}
