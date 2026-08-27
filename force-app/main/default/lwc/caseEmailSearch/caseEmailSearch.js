import { LightningElement, wire, track } from "lwc";
import getReportData from "@salesforce/apex/EmailReportSearchController.getReportData";

export default class CaseEmailSearch extends LightningElement {
  @track allData = [];
  @track filteredData = [];

  columns = [
    { label: "Case Number", fieldName: "CaseNumber", type: "text" },
    { label: "Case Owner", fieldName: "CaseOwner", type: "text" },
    { label: "Case Subject", fieldName: "CaseSubject", type: "text" },
    { label: "Email Subject", fieldName: "Subject", type: "text" },
    { label: "Email Status", fieldName: "Status", type: "text" },
    { label: "Email Message Date", fieldName: "MessageDate", type: "date" },
    { label: "To Address", fieldName: "ToAddress", type: "email" },
    { label: "CC Address", fieldName: "CcAddress", type: "email" },
    { label: "From Address", fieldName: "FromAddress", type: "email" }
  ];

  @wire(getReportData)
  wiredEmails({ error, data }) {
    if (data) {
      // Flatten the data so the datatable can read the relationship fields
      let processedData = data.map((record) => {
        let flattenedRow = { ...record };

        // Pull the Case fields out of the Parent relationship
        if (record.Parent) {
          flattenedRow.CaseSubject = record.Parent.Subject;
          flattenedRow.CaseNumber = record.Parent.CaseNumber;

          // Pull the Owner Name
          if (record.Parent.Owner) {
            flattenedRow.CaseOwner = record.Parent.Owner.Name;
          }
        }

        return flattenedRow;
      });

      this.allData = processedData;
      this.filteredData = processedData;
    } else if (error) {
      console.error("Error fetching data:", error);
    }
  }

  handleSearch(event) {
    const searchKey = event.target.value.toLowerCase();

    if (searchKey) {
      this.filteredData = this.allData.filter((record) => {
        let valuesArray = Object.values(record);
        return valuesArray.some((val) =>
          String(val).toLowerCase().includes(searchKey)
        );
      });
    } else {
      this.filteredData = this.allData;
    }
  }
}
