/**
 * Controller class for the LWC ContactProductInformation
 * Given a product Id and a country, it provides the info related with the pricing and currency. 
 * Only one product is expected for country, if no results or more than one result is retrieved, null is returned
 */
public with sharing class ContactProductInformationController {
    @AuraEnabled(cacheable=true)
    public static PricebookEntry getPricebookEntry(Id productId, String country) {
        PricebookEntry[] pbe = [
            SELECT Id, 
            Cost_per_Calendar_Month__c, 
            ATM_Fee_in_other_currencies__c, 
            Card_Replacement_Cost__c, 
            CurrencyIsoCode
            FROM PricebookEntry 
            WHERE Product2Id = :productId 
            AND Pricebook2.Country__c = :country
            WITH SECURITY_ENFORCED
        ];
        
        if (pbe.size() != 1) {
            return null;
        }
        return pbe[0];
    }
}