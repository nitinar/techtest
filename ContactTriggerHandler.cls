/*
  Venkat Akula   Created 29 Jan 2019
*/

public with sharing class ContactTriggerHandler {
    private boolean isExecuting = false;
    private integer batchSize = 0;
    
    public ContactTriggerHandler(boolean isExecuting, integer size){
        isExecuting = isExecuting;
        batchSize = size;
    }
        

    public void OnAfterInsert(Contact[] newContacts){
    // New case list
    List<Case> caseList = new List<Case>();
    // Loop through all new contacts inserted
        for(Contact newContact : newContacts){
    // create a new case instance with the required data    
         case c = new case();
         c.ContactId = newContact.Id;
         c.Status = 'Working';
         c.Origin = 'New Contact';
         c.OwnerId = newContact.OwnerId;
         //Conditional check for level and assigning the case priority
         if(String.isNotBlank(newContact.Level__c) && newContact.Level__c == 'Primary'){
             c.Priority = 'High';
           } else if(String.isNotBlank(newContact.Level__c) && newContact.Level__c == 'Secondary'){
             c.Priority = 'Medium';
           } else{
             c.Priority = 'Low';
           }
           // assign Account to the Case if the Case on Contact is not null
         if(newContact.AccountId != null){
             c.AccountId = newContact.AccountId;   
          } 
         // Add the cases to the above instantiated list            
         caseList.add(c);                         
        }
        //insert the list if the size > 0
        if (caseList.size() > 0) {
        insert caseList;
       }
        
    }
        
}