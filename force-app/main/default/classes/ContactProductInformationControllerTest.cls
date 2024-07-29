/**
 * Test for Apex class ContactProductInformationControllerTest
 */
@isTest
public with sharing class ContactProductInformationControllerTest {
    public static final String COUNTRY = 'DE';

    @TestSetup
    static void makeData(){
        // Create product and add to pricebook
        Product2 pr = TestDataFactory.createProduct('Standard');
        insert pr;
        // Modify country of stanard pricebook
        Pricebook2 stPb = new Pricebook2();
        stPb.Id = Test.getStandardPricebookId();
        stPb.IsActive = true;
        stPb.Country__c = COUNTRY;
        update stPb;

        PricebookEntry pE = TestDataFactory.createPricebookEntry(stPb.Id, pr.Id);
        pE.Cost_per_Calendar_Month__c = 0;
        pE.ATM_Fee_in_other_currencies__c = 0.017;
        pE.Card_Replacement_Cost__c = 6;
        insert pE;
        
    }

    @isTest
    public static void getPricebookEntryPositive() {
        // Given a product and a country
        Product2 pr = [SELECT Id FROM Product2 LIMIT 1];

        // When querying for a product and a specific country
        Test.startTest();
        PricebookEntry pE = ContactProductInformationController.getPricebookEntry(pr.Id, COUNTRY);
        Test.stopTest();

        // Then the necessary information is retrieved
        System.assertNotEquals(null, pE.Cost_per_Calendar_Month__c, 'Expected a value in property Cost_per_Calendar_Month__c');
        System.assertNotEquals(null, pE.ATM_Fee_in_other_currencies__c, 'Expected a value in property ATM_Fee_in_other_currencies__c');
        System.assertNotEquals(null, pE.Card_Replacement_Cost__c, 'Expected a value in property Card_Replacement_Cost__c');
        System.assertNotEquals(null, pE.CurrencyIsoCode, 'Expected a value in property CurrencyIsoCode');
    }

    @isTest
    public static void getPricebookEntryNegative() {
        // Given a query with no results
        Product2 pr = [SELECT Id FROM Product2 LIMIT 1];

        // When executing the class
        Test.startTest();
        PricebookEntry pE = ContactProductInformationController.getPricebookEntry(pr.Id, 'FR');
        Test.stopTest();

        // Then null is returned, no error is thrown (same result would occur with more than one result)
        System.assertEquals(null, pE, 'Expected null when querying non existing product/price or multiple results');
    }
}