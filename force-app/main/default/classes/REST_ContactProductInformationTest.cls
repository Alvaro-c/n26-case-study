/**
 * Test for Apex class REST_ContactProductInformation
 */
@isTest
public with sharing class REST_ContactProductInformationTest {
    public static final String COUNTRY = 'DE';

    @TestSetup
    static void makeData(){
        // Create product
        Product2 pr = TestDataFactory.createProduct('Standard');
        insert pr;

        // Update Pricebook and add entry for the product
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

        // Create Contact
        Contact con = TestDataFactory.createContact();
        con.Product__c = pr.Id; 
        insert con;
    }

    @isTest
    public static void doGetTest() {
        // Given a Contact 
        Contact con = [SELECT Id FROM Contact LIMIT 1];

        // Initiate Request context
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/contactproductinformation/' + con.Id;
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response= res;
    
        // When quering the Id of the contact to the REST resource
        Test.startTest();
        REST_ContactProductInformation.Payload response = REST_ContactProductInformation.doGet();
        Test.stopTest();

        // Information about the contact, product and pricing is retrieved
        System.assertEquals(COUNTRY, response.contactData.Home_Country__c, 'Expected Country in payload same as in contact created');
        System.assertEquals(0.017, response.productAndPriceData.ATM_Fee_in_other_currencies__c, 'Expected values created present in payload');
        System.assertEquals('Standard', response.productAndPriceData.Product2.Name, 'Expected information about the product');
    }

    @isTest
    public static void doGetOnlyContactTest() {
        // Given a Contact with no product related
        Contact con = [SELECT Id FROM Contact LIMIT 1];
        con.Product__c = null;
        update con;

        // Initiate Request context
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/contactproductinformation/' + con.Id;
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response= res;
    
        // When quering the Id of the contact to the REST resource
        Test.startTest();
        REST_ContactProductInformation.Payload response = REST_ContactProductInformation.doGet();
        Test.stopTest();

        // Information about the contact, product and pricing is retrieved
        System.assertEquals(COUNTRY, response.contactData.Home_Country__c, 'Expected Country in payload same as in contact created');
        System.assertEquals(null, response.productAndPriceData, 'Expected product null');
    }

    @isTest
    public static void doGetTestNegative() {
        // Given a Contact that doens't exist
        Contact con = [SELECT Id FROM Contact LIMIT 1];
        Id contactId = con.Id;
        delete con;

        // Initiate Request context
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/contactproductinformation/' + con.Id;
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response= res;
    
        // When quering the Id of the contact to the REST resource
        Test.startTest();
        REST_ContactProductInformation.Payload response = REST_ContactProductInformation.doGet();
        Test.stopTest();

        // Information about the contact, product and pricing is retrieved
        System.assertEquals(null, response.contactData, 'Expected null, no contact exist');
        System.assertEquals(null, response.productAndPriceData, 'Expected null, no contact exist');
    }
}