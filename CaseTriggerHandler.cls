/*
  Venkat Akula   Created 29 Jan 2019
*/

public with sharing class CaseTriggerHandler {
    private boolean isExecuting = false;
    private integer batchSize = 0;
    
    public CaseTriggerHandler(boolean isExecuting, integer size){
        isExecuting = isExecuting;
        batchSize = size;
    }
            
    public void OnAfterInsert(Case[] newCases){
    // Map to store the Owner Id of the Contact that the new cases are related to
    Map<Id,Case> caseContactIds = new Map<Id,Case>([Select Id,Contact.OwnerID From Case Where Id IN: newCases]);
    //New Tasks List
    List<Task> newTasks = new List<Task>();
    // Loop through all new cases
       for(Case newCase : newCases){
       //instantiate a new task with the required data  
         Task t = new Task();
         t.WhatId = newCase.Id;
         t.Status = 'Not Started';
         t.Subject = 'Welcome Call for '+ newCase.CaseNumber;
         t.Priority = 'Normal';
         //assign the owner of the task as the same as contact owner
         t.OwnerId = caseContactIds.get(newCase.Id).Contact.OwnerId;
         //Conditional check for case priority to set the due date accordingly   
         if(newCase.Priority == 'High'){
             t.ActivityDate = Date.today().addDays(7);
         } else if(newCase.Priority == 'Medium'){
             t.ActivityDate = Date.today().addDays(14);
         } else{
             t.ActivityDate = Date.today().addDays(21);
         } 
         // Add task to the list   
         newTasks.add(t);         
         }
        //insert tasks if the list size > 0    
        if (newTasks.size() > 0) {
        insert newTasks;
       }       
    }
        
}