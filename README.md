# Case Study

## 1st: LWC in Case that shows Product information related to a Contact
For this first task, I decided to use the following standard Salesforce Objects: 
- Case
- Contact
- Product
- Pricebook
- PricebookEntry

The decision of using this approach has been taken considering the following request from the Case Study: 
>Modifying the existing product information, or adding entirely new products, should be as simple as possible

The approach leverages that request, along with having a scenario as close as possible to a real world case. Using Product, Pricebook and PricebookEntry adds complexity into the Case Study, but I considered it better than creating a Product__c Custom Object, that would have been easier for this task, but would have been a bigger challenge in a production Salesforce Org.

### Preconditions: 
Before deploying the LWC, some changes are needed in the org: 
- Add fields Home_Country__c and Product__c to Contact
- Add field Country__c to Pricebook (this will match the Contact Country with the correct pricebook)
- Update the standard Pricebook to Country__c = 'DE'
- Apply Multicurrency to the org

### LWC: ContactProductInformation
I tried to maintain the LWC as lean as possible, using standard functionalities as well as custom Apex code to demonstrate both approaches. 
#### JavaScript 
1. The lightning/uiRecordApi and wired methods are used to get the information of the Case, that provides the necessary info of the Contact
2. A custom Apex Controller is used to retrieve all the information related to the pricing of the product
3. Several getters give the component the reactivity that populates the values to the user, as well as a loading state.

#### HTML
Standard components have been used to keep the look of the Record Page as close as the styles of Salesforce as possible. Also, formatting the numbers and linking the original Product have been considered.

![N|Solid](https://i.imgur.com/L6gKWzG.png)

#### Apex: ContactProductInformationController.cls
The Apex custom controller is performing a query and a simple check to see that only one product is returned, as I understood that one Contact can only have one Product, but the approach of using Products and Pricebooks opens the door to scale it and have more Products in the future.

#### Testing
The LWC is delivered with Jest tests that cover the scenario of having data, and having a error in the response.
The tests are loading information saved in a JSON to perform checks for the asynchronous load. 

For the Apex part, two classes are provided:
- ```ContactProductInformationControllerTest.cls``` 
- ```TestDataFactory.cls```

The Data Factory is provided to show a realistic scenario as well. 

## 2nd: Endpoint to integrate an external service
The second task is solved with the class ```REST_ContactProductInformation.cls```. 
It uses the annotation ```@RestResource``` that Salesforce provides. The class also uses a Custom Class that provides flexibility to build a response with a Contact and a PricebookEntry. If the Contact exists but the PricebookEntry doesn't, the class still returns the Contact information, so the endpoint is suitable for more scenarios.

The test class ```REST_ContactProductInformationTest.cls``` is also provided, covering the code at 100%

![N|Solid](https://i.postimg.cc/KYNwWDmL/image.png)

To make request to the endpoint created, authentication is needed. This is an example of the payload being requested using Bruno (similar to Postman)

![N|Solid](https://i.postimg.cc/yxfCgqfL/image.png)

## Deploying and testing
The helper class ```ExampleData.cls``` is provided to create a set of data to test both tasks. 
The order of deployment should be: 
-Create new fields to the objects Contact and Pricebook
-Deploying the Apex classes, first the normal classes, then the tests
-Deploying the LWC component
-Adding the LWC component to the Case Record Page

For developing and testing, I used a Playground Org provided by Salesforce. Let me know if I should provide access to it.

For any other doubt, don't hesitate in contacting me. 

Thank you, 

Alvaro Canas
