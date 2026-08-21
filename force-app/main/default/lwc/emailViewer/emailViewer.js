import { LightningElement, api, wire, track } from "lwc";
import { refreshApex } from "@salesforce/apex";
import getFilteredEmails from "@salesforce/apex/EmailViewController.getFilteredEmails";

const COLUMNS = [
  {
    label: "Subject",
    fieldName: "EmailUrl",
    type: "url",
    typeAttributes: {
      label: { fieldName: "Subject" },
      target: "_blank" // Opens in a new tab. Use '_self' to open in the same tab.
    }
  },
  { label: "From", fieldName: "FromAddress", type: "email" },
  { label: "To", fieldName: "ToAddress", type: "text" },
  { label: "CC", fieldName: "CcAddress", type: "text" },
  { label: "Status", fieldName: "StatusLabel", type: "text" },
  {
    label: "Date",
    fieldName: "MessageDate",
    type: "date",
    typeAttributes: {
      year: "numeric",
      month: "short",
      day: "2-digit",
      hour: "2-digit",
      minute: "2-digit"
    }
  },
  { label: "Case Number", fieldName: "CaseNumber", type: "text" }
];

export default class EmailViewer extends LightningElement {
  @api recordId;

  columns = COLUMNS;
  @track tableData = [];
  @track errorMessage;

  // Filter States
  searchKey = "";
  statusFilter = "";
  startDate = null;
  endDate = null;

  // Holds the raw wire result for manual refreshing
  wiredEmailResult;

  statusOptions = [
    { label: "All", value: "" },
    { label: "New", value: "0" },
    { label: "Read", value: "1" },
    { label: "Replied", value: "2" },
    { label: "Sent", value: "3" },
    { label: "Forwarded", value: "4" }
  ];

  statusMap = {
    0: "New",
    1: "Read",
    2: "Replied",
    3: "Sent",
    4: "Forwarded",
    5: "Draft"
  };

  @wire(getFilteredEmails, {
    recordId: "$recordId",
    statusFilter: "$statusFilter",
    startDateStr: "$startDate",
    endDateStr: "$endDate",
    searchKey: "$searchKey"
  })
  wiredEmails(result) {
    this.wiredEmailResult = result; // Save the complete result for refreshApex
    const { error, data } = result;

    if (data) {
      this.tableData = data.map((record) => {
        return {
          ...record,
          EmailUrl: `/${record.Id}`, // Constructs the URL for the datatable link
          CaseNumber: record.Parent ? record.Parent.CaseNumber : "",
          StatusLabel: this.statusMap[record.Status] || record.Status
        };
      });
      this.errorMessage = undefined;
    } else if (error) {
      console.error("Error fetching emails", error);
      this.errorMessage = error.body
        ? error.body.message
        : "Unknown error occurred";
      this.tableData = [];
    }
  }

  // Refresh Action
  handleRefresh() {
    // Forces the @wire to hit the server again and fetch fresh data
    return refreshApex(this.wiredEmailResult);
  }

  // Handlers
  handleSearchChange(event) {
    this.searchKey = event.target.value;
  }

  handleFilterChange(event) {
    const field = event.target.dataset.field;
    if (field === "status") {
      this.statusFilter = event.detail.value;
    } else if (field === "startDate") {
      this.startDate = event.detail.value;
    } else if (field === "endDate") {
      this.endDate = event.detail.value;
    }
  }
}
