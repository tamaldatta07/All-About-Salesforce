import { LightningElement, track, api } from "lwc";
import getReportData from "@salesforce/apex/ReportSearchController.getReportData";

export default class ReportSearcher extends LightningElement {
  // Hardcoded default based on your requirement
  @api reportId = "00OgK00000DlhbVUAR";

  @track columns = [];
  @track allData = [];
  @track displayedData = [];

  isLoading = true;
  errorMessage;

  connectedCallback() {
    if (this.reportId) {
      this.loadReport();
    } else {
      this.errorMessage = "Please provide a valid Report ID.";
      this.isLoading = false;
    }
  }

  loadReport() {
    this.isLoading = true;
    this.errorMessage = null;

    getReportData({ reportId: this.reportId })
      .then((result) => {
        const reportJSON = JSON.parse(result);
        this.parseReportResponse(reportJSON);
        this.isLoading = false;
      })
      .catch((error) => {
        console.error("Error fetching report", error);
        this.errorMessage =
          "Failed to load report data. Ensure the Report ID is correct and you have access to it.";
        this.isLoading = false;
      });
  }

  parseReportResponse(reportJSON) {
    const colInfo = reportJSON.reportExtendedMetadata.detailColumnInfo;
    const columnKeys = reportJSON.reportMetadata.detailColumns;

    // 1. Extract Columns
    this.columns = columnKeys.map((key) => {
      return {
        label: colInfo[key].label,
        fieldName: key,
        type: "text",
        sortable: true
      };
    });

    // 2. Extract Rows from the Tabular FactMap
    const tabularRows = reportJSON.factMap["T!T"].rows;

    this.allData = tabularRows.map((row, index) => {
      let rowData = { id: `row-${index}` };

      row.dataCells.forEach((cell, cellIndex) => {
        const colKey = columnKeys[cellIndex];
        rowData[colKey] = cell.label;
      });

      return rowData;
    });

    // 3. Set Display Data
    this.displayedData = [...this.allData];
  }

  handleSearch(event) {
    const searchTerm = event.target.value.toLowerCase();

    if (!searchTerm) {
      this.displayedData = [...this.allData];
      return;
    }

    this.displayedData = this.allData.filter((row) => {
      return Object.values(row).some((value) => {
        return value ? String(value).toLowerCase().includes(searchTerm) : false;
      });
    });
  }
}
