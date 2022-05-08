import { LightningElement, api, wire, track } from "lwc";
import getCategories from "@salesforce/apex/categoriesController.getCategories";
import getCategoryAssignList from "@salesforce/apex/categoriesController.getCategoryAssignList";
import deleteCategoryAssignment from "@salesforce/apex/categoriesController.deleteCategoryAssignment";
import createCategoryAssignment from "@salesforce/apex/categoriesController.createCategoryAssignment";
import { ShowToastEvent } from "lightning/platformShowToastEvent";

export default class AddCategories extends LightningElement {
  @api recordId;

  @track showListbox = false;
  @track testobj = [];
  @track activeOptions = [];
  @track activeOptions_name = [];
  @track listOptions = [];

  obj = {};
  _selected = [];
  objLabel = "";
  added;
  removed;

  @wire(getCategories, {})
  allCategories({ error, data }) {
    if (data) {
      data.forEach((element) => {
        let objvalue = element.Name;
        let resvalue = objvalue.toLowerCase().replace(/\s+/g, "");

        let tempobj = {
          label: element.Name,
          value: resvalue
        };

        this.listOptions.push(tempobj);
      });
    } else if (error) {
      console.log("Couldn't get Categories: " + error);
    }
  }

  @wire(getCategoryAssignList, { recordId: "$recordId" })
  CategoryAssignList({ error, data }) {
    if (data) {
      data.forEach((element) => {
        console.log(element.CategoryId__r.Name);
        let nameoption = element.CategoryId__r.Name;
        let resoption = nameoption.toLowerCase().replace(/\s+/g, "");
        this.activeOptions.push(resoption);
        this.activeOptions_name.push(nameoption);
      });
    } else if (error) {
      console.log("No assigned Categories: " + error);
    }
  }

  get selected() {
    return this._selected.length ? this._selected : "none";
  }

  removedCategories(selectedRemove) {
    let diff = this.activeOptions.filter((x) => !selectedRemove.includes(x));
    return diff;
  }

  addedCategories(selectedAdded) {
    let diff = selectedAdded.filter((x) => !this.activeOptions.includes(x));
    return diff;
  }

  handleChange(event) {
    this._selected = event.detail.value;
    this.added = this.addedCategories(this.selected);
    this.removed = this.removedCategories(this._selected);
  }

  showToast_success() {
    const evt = new ShowToastEvent({
      title: "Categories saved",
      message: "Succesfully saved Categories",
      variant: "success"
    });
    this.dispatchEvent(evt);
  }

  saveChange() {
    //removing
    if (this.removed.length > 0) {
      this.removed.map((elementRemoved) => {
        return new Promise(() => {
          deleteCategoryAssignment({
            recordId: this.recordId,
            name: elementRemoved.toString()
          })
            .then(() => {
              elementRemoved = [];
              this.showListbox = false;
              this.showToast_success();
            })
            .catch((error) => {
              console.log("Failed Deleting Assignment" + JSON.stringify(error));
            });
        });
      });
    }
    //adding
    if (this.added.length > 0) {
      this.added.map((elementAdded) => {
        console.log("Looping Fun:" + elementAdded);
        return new Promise(() => {
          createCategoryAssignment({
            recordId: this.recordId,
            category: elementAdded.toString()
          })
            .then(() => {
              elementAdded = [];
              this.showToast_success();
              this.showListbox = false;
            })
            .catch((error) => {
              console.log("Failed Creating Assignment" + JSON.stringify(error));
            });
        });
      });
    }
  }
  activateListbox() {
    this.showListbox = true;
    console.log("Listbox toggled");
  }
}
