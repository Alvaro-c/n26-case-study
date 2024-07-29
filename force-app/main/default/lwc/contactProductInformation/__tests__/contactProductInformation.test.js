import { createElement } from 'lwc';
import ContactProductInformation from 'c/contactProductInformation';
import { getRecord } from "lightning/uiRecordApi";
import getPricebookEntry from '@salesforce/apex/ContactProductInformationController.getPricebookEntry';

const mockGetRecord = require("./data/getRecord.json");
const mocGetPricebookEntry = require('./data/getPricebookEntry.json');

// Mock mock Apex wire adapter
jest.mock(
    '@salesforce/apex/ContactProductInformationController.getPricebookEntry',
    () => {
        const {
            createApexTestWireAdapter
        } = require('@salesforce/sfdx-lwc-jest');
        return {
            default: createApexTestWireAdapter(jest.fn())
        };
    },
    { virtual: true }
);

describe('c-contact-product-information', () => {
    afterEach(() => {
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
        jest.clearAllMocks();
    });

    // resolve promises to populate data from wire addapters 
    async function flushPromises() {
        return Promise.resolve();
    }

    describe('mocGetPricebookEntry @wire', () => {
        it('Renders the information from the product related with the contact', async () => {
            // Create component
            const element = createElement('c-contact-product-information', {
                is: ContactProductInformation
            });
            document.body.appendChild(element);

            // Emit data from 2 @wire records
            getRecord.emit(mockGetRecord);
            getPricebookEntry.emit(mocGetPricebookEntry);

            // Wait for any asynchronous DOM updates
            await flushPromises();

            // Assert element is added
            const cards = element.shadowRoot.querySelectorAll('lightning-card');
            expect(cards.length).toBe(1);

            // Assert data from the addapter is loaded correctly
            const details = element.shadowRoot.querySelectorAll('lightning-formatted-number');
            expect(details.length).toBe(3);
            expect(details[0].value).toBe(mocGetPricebookEntry.Cost_per_Calendar_Month__c);
            expect(details[1].value).toBe(mocGetPricebookEntry.ATM_Fee_in_other_currencies__c);
            expect(details[2].value).toBe(mocGetPricebookEntry.Card_Replacement_Cost__c);
        });

        it('Shows an spinner when there is an error', async () => {
            const element = createElement('c-apex-wire-method-to-property', {
                is: ContactProductInformation
            });
            document.body.appendChild(element);

            // Emit error from @wire 
            getPricebookEntry.error();

            // Wait for any asynchronous DOM updates
            await flushPromises();

            // Check for spinner element
            const spinner = element.shadowRoot.querySelector('lightning-spinner');
            expect(spinner).not.toBeNull();
        });
    });
});