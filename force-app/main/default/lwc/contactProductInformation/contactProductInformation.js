import { LightningElement, wire, api } from 'lwc';
import { getRecord, getFieldValue,  getFieldDisplayValue } from 'lightning/uiRecordApi';
import getPricebookEntry from '@salesforce/apex/ContactProductInformationController.getPricebookEntry';

import HOME_COUNTRY_FIELD from '@salesforce/schema/Case.Contact.Home_Country__c';
import PRODUCT_ID_FIELD from '@salesforce/schema/Case.Contact.Product__r.Id';
import PRODUCT_NAME_FIELD from '@salesforce/schema/Case.Contact.Product__r.Name';

const fields = [
    HOME_COUNTRY_FIELD,
    PRODUCT_ID_FIELD, 
    PRODUCT_NAME_FIELD
];

export default class ContactProductInformation extends LightningElement {
    // Get record Id from the Record Page using uiRecordApi
    @api recordId;

    // With the record Id, get the Case information using standard getRecord function
    @wire(getRecord, { recordId: '$recordId', fields }) 
    caseRecord;

    // Once the info of the case is available, use custom Apex controller to fetch the missing relevant information
    @wire(getPricebookEntry, {productId: '$productId', country: '$country'})
    pricebookEntry;

    // Getters for the properties used in by the wired methods and/or in the HTML template
    get productId() {
        return getFieldValue(this.caseRecord.data, PRODUCT_ID_FIELD);
    }

    get productName() {
        return getFieldValue(this.caseRecord.data, PRODUCT_NAME_FIELD);
    }

    get productURL() {
        return `/${this.productId}`;
    }

    get country() {
        return getFieldValue(this.caseRecord.data, HOME_COUNTRY_FIELD);
    }

    get localisedCountry() {
       return getFieldDisplayValue(this.caseRecord.data, HOME_COUNTRY_FIELD);
    }
    
    get title() {
        return `${this.productName} (${this.localisedCountry})`;
    }

    // Wait until all info is available to show the final component
    // Spinner is showed if data is loading or not available
    get isLoading()  {
        return !(this.caseRecord.data && this.pricebookEntry.data);
    }
}