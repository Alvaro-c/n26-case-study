/**
 * REST resource class to integrate extenal system and provide information about a Contact with 
 * related product and pricing. 
 * If the Contact doesn't have a product related, the class still returns the contact information
 */
@RestResource(urlMapping='/contactproductinformation/*')
global with sharing class REST_ContactProductInformation {
    // Using get method, as it's only requesting information, param is in URL
    @HttpGet
    global static Payload doGet() {
        RestRequest req = RestContext.request;
        // Get ID from url
        String contactId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);

        // Form payload based in two queries to provide all relevant info
        Payload response = new Payload();
        Contact[] con = [
            SELECT 
            Id,
            FirstName, 
            LastName,
            Product__c, 
            Home_Country__c 
            FROM Contact 
            WHERE Id = :contactId 
            WITH SECURITY_ENFORCED
        ];

        // Exit if no contact is found
        if (con.isEmpty()) {
            return response;
        }
        response.contactData = con[0];

        PricebookEntry[] priceEntry = [
            SELECT
            Id, 
            Product2.Name,
            Cost_per_Calendar_Month__c, 
            ATM_Fee_in_other_currencies__c, 
            Card_Replacement_Cost__c, 
            CurrencyIsoCode
            FROM PricebookEntry 
            WHERE Product2Id = :response.contactData.Product__c 
            AND Pricebook2.Country__c = :response.contactData.Home_Country__c
            WITH SECURITY_ENFORCED
            LIMIT 1 // Precondition: Only one pricebookEntry per product, per country
        ];

        // If no product related, still return the contact information
        if (priceEntry.isEmpty()) {
            return response;
        }

        // If contact and product is found, send back all the info
        response.productAndPriceData = priceEntry[0];
        return response;
    }

    // Helper class to provide a payload with information about the contact and product
    global class Payload {
        global Contact contactData;
        global PricebookEntry productAndPriceData;
    }
}