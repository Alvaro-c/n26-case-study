/**
 * @descritpion: This class will create example data for the case study
 */
public with sharing class ExampleData {
    public static void createExampleData() {
        // Create three products
        Product2[] prList = new Product2[]{};
        Product2 standard = new Product2();
        standard.Name = 'Standard';
        standard.IsActive = true;
        prList.add(standard);

        Product2 black = new Product2();
        black.Name = 'Black';
        black.IsActive = true;
        prList.add(black);

        Product2 metal = new Product2();
        metal.Name = 'Metal';
        metal.IsActive = true;
        prList.add(metal);
        insert prList;

        // The price structure will be one price book for each market. The defaul pricebook will be the German market
        // German market
        Pricebook2 stdPb = [SELECT Id FROM Pricebook2 WHERE isStandard = true LIMIT 1];
        stdPb.Country__c = 'DE';
        update stdPb;
        PricebookEntry[] pbeList = new PricebookEntry[]{};
        // Germany Standard
        PricebookEntry pbeDeStand = createPriceBookEntry(stdPb.Id, standard.Id, 0, 0.017, 6);
        pbeList.add(pbeDeStand);
        // Germany Black
        PricebookEntry pbeDeBl = createPriceBookEntry(stdPb.Id, black.Id, 9.90, 0, 6);
        pbeList.add(pbeDeBl);
        // Germany Metal
        PricebookEntry pbeDeMe = createPriceBookEntry(stdPb.Id, metal.Id, 16.90, 0, 6);
        pbeList.add(pbeDeMe);

        // French market
        Pricebook2[] pbList = new Pricebook2[]{};
        Pricebook2 frPb = new Pricebook2();
        frPb.Name = 'France Pricebook';
        frPb.Country__c = 'FR';
        frPb.IsActive = true;
        pbList.add(frPb);
        insert pbList;
        
        // France Standard
        PricebookEntry pbeSpSt = createPriceBookEntry(frPb.Id, standard.Id, 0, 0.017, 6);
        pbeList.add(pbeSpSt);
        // France black
        PricebookEntry pbeFrBl = createPriceBookEntry(frPb.Id, black.Id, 9.90, 0, 6);
        pbeList.add(pbeFrBl);
        // France metal
        PricebookEntry pbeFrMe = createPriceBookEntry(frPb.Id, metal.Id, 16.90, 0, 6);
        pbeList.add(pbeFrMe);

        insert pbeList;

        // Insert two Contact and Cases to visualize examples
        Contact con1 = new Contact();
        con1.FirstName = 'Valentin';
        con1.LastName = 'Stalf';
        con1.Product__c = metal.Id; 
        con1.Home_Country__c = 'DE';

        Contact con2 = new Contact();
        con2.FirstName = 'Maximilian';
        con2.LastName = 'Tayenthal';
        con2.Product__c = black.Id;
        con2.Home_Country__c = 'UK';
        insert new Contact[]{con1, con2};

        Case cs1 = new Case();
        cs1.Subject = 'Example 1';
        cs1.ContactId = con1.Id;

        Case cs2 = new Case();
        cs2.Subject = 'Example 2';
        cs2.ContactId = con2.Id;
        insert new Case[]{cs1, cs2};
    }

    public static PricebookEntry createPriceBookEntry(
        Id pricebookId, Id productId, Decimal base, Decimal atm, Decimal repl
        ) {
        PricebookEntry pbe = new PricebookEntry();
        pbe.Pricebook2Id = pricebookId;
        pbe.Product2Id = productId;
        pbe.IsActive = true;
        pbe.UnitPrice = 0;  // Not using the default price to use custom fields instead
        pbe.UseStandardPrice = false;
        pbe.CurrencyIsoCode = 'EUR';
        pbe.Cost_per_Calendar_Month__c = base;
        pbe.ATM_Fee_in_other_currencies__c = atm;
        pbe.Card_Replacement_Cost__c = repl;
        return pbe;
    }
}