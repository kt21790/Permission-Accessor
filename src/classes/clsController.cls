public with sharing class clsController {

    public List<Contact> contacts{get;set;}
    
    public clsController() {
    
        contacts = [select id,name ,accountId, email, phone from Contact Limit 10];
    
    }
}