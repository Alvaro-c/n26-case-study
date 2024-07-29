/**
 * Helper class to create objects used by the tests in multiple classes
 */
public with sharing class TestDataFactory {
    public static Product2 createProduct(String name) {
        Product2 pr = new Product2();
        pr.Name = name;
        pr.IsActive = true;
        return pr;
    }

    public static PricebookEntry createPricebookEntry(Id pricebookId, Id productId) {
        PricebookEntry pbe = new PricebookEntry();
        pbe.Pricebook2Id = pricebookId;
        pbe.Product2Id = productId;
        pbe.IsActive = true;
        pbe.UnitPrice = 0; 
        pbe.UseStandardPrice = false;
        pbe.CurrencyIsoCode = 'EUR';
        return pbe;
    }

    public static Contact createContact(){
        Contact con = new Contact();
        con.FirstName = 'FirstTest';
        con.LastName = 'LastTest';
        con.Home_Country__c = 'DE';
        return con;
    }

}