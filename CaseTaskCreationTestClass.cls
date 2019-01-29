@isTest 
private class CaseTaskCreationTestClass {

    static testMethod void TestCaseTaskCreation1() { 
    
         //Get user from User table
         User u = [select name, Id  FROM user Where profileId=:[select Id from profile where name='system administrator'].Id LIMIT 1];
        // Create an account to insert for Contact     
        Account acct = new Account(Name='Test Account');
        insert acct;
        // Create Case with 'Primary' Level                                                                 
        Contact con = new Contact (FirstName = 'Venkat', LastName = 'Test', Level__c = 'Primary',
                                   AccountId = acct.Id, OwnerId = u.Id);
        Test.StartTest(); 
        //insert contact                          
        insert con;
        Test.StopTest();
        //Query for the Cases related to the Contact inserted above
        List<Case> Cases = new List<Case>([Select Id, Priority, Origin, OwnerId, AccountId From Case Where ContactId = :con.Id]);
        //Check that the Case is created 
        System.assertequals(Cases.size(),1);
        //Check that Case is created with High priority as the level on contact is Primary
        System.assertequals(Cases[0].Priority, 'High');
        //Case origin check
        System.assertequals(Cases[0].Origin, 'New Contact');
        //Check the owner of the Case is same as the owner of Contact
        System.assertequals(Cases[0].OwnerId, con.OwnerId);
        //Check the Account is populated on Case
        System.assertequals(Cases[0].AccountId, acct.Id);
        //Query the list of cases created as they should be inserted on case creation
        List<Task> Tasks = new List<Task>([Select Id, ActivityDate, OwnerId From Task Where WhatId = :Cases[0].Id]);
        //Check that Task is sucessfully created
        System.assertequals(Tasks.size(),1);
        //Check the due date on the case is in 7 days as the Priority on the Case is High
        System.assertequals(Tasks[0].ActivityDate,Date.today().addDays(7));
        //Check the owner of the Task is same as the owner of Contact
        System.assertequals(Tasks[0].OwnerId, con.OwnerId);
    }
    
        static testMethod void TestCaseTaskCreation2() {
        
        //Get user from User table
         User u = [select name, Id  FROM user Where profileId=:[select Id from profile where name='system administrator'].Id LIMIT 1];
        
        // Create an account to insert for Contact     
        Account acct = new Account(Name='Test Account');
        insert acct; 
        // Create Case with 'Secondary' Level                                                                  
        Contact con = new Contact (FirstName = 'Venkat', LastName = 'Test', Level__c = 'Secondary',
                                   AccountId = acct.Id, OwnerId = u.Id);
        Test.StartTest(); 
        // insert contact                          
        insert con;
        Test.StopTest();
        //Query for the Cases related to the Contact inserted above
        List<Case> Cases = new List<Case>([Select Id, Priority, Origin, OwnerId, AccountId From Case Where ContactId = :con.Id]);
        //Check that the Case is created 
        System.assertequals(Cases.size(),1);
        //Check that Case is created with Medium priority as the level on contact is Secondary
        System.assertequals(Cases[0].Priority, 'Medium');
        //Case origin check
        System.assertequals(Cases[0].Origin, 'New Contact');
        //Check the owner of teh Case is same as the owner of Contact
        System.assertequals(Cases[0].OwnerId, con.OwnerId);
        //Check the Account is populated on Case
        System.assertequals(Cases[0].AccountId, acct.Id);
        //Query the list of cases created as they should be inserted on case creation
        List<Task> Tasks = new List<Task>([Select Id, ActivityDate, OwnerID From Task Where WhatId = :Cases[0].Id]);
        //Check that Task is sucessfully created
        System.assertequals(Tasks.size(),1);
        //Check the due date on the case is in 14 days as the Priority on the Case is Medium
        System.assertequals(Tasks[0].ActivityDate,Date.today().addDays(14));
        //Check the owner of the Task is same as the owner of Contact
        System.assertequals(Tasks[0].OwnerId, con.OwnerId);
    }
    
        static testMethod void TestCaseTaskCreation3() {
        //Get user from User table
         User u = [select name, Id  FROM user Where profileId=:[select Id from profile where name='system administrator'].Id LIMIT 1];
        
   
        // Create Case with 'Secondary' Level with no Account                                                                 
        Contact con = new Contact (FirstName = 'Venkat', LastName = 'Test', Level__c = 'Tertiary',
                                    OwnerId = u.Id);
        Test.StartTest(); 
        // insert contact                          
        insert con;
        Test.StopTest();
        //Query for the Cases related to the Contact inserted above
        List<Case> Cases = new List<Case>([Select Id, Priority, Origin, OwnerId From Case Where ContactId = :con.Id]);
        //Check that the Case is created 
        System.assertequals(Cases.size(),1);
        //Check that Case is created with Low priority as the level on contact is Tertiary
        System.assertequals(Cases[0].Priority, 'Low');
        //Case origin check
        System.assertequals(Cases[0].Origin, 'New Contact');
        //Check the owner of teh Case is same as the owner of Contact
        System.assertequals(Cases[0].OwnerId, con.OwnerId);
        //Query the list of cases created as they should be inserted on case creation
        List<Task> Tasks = new List<Task>([Select Id, ActivityDate, OwnerID From Task Where WhatId = :Cases[0].Id]);
        //Check that Task is sucessfully created
        System.assertequals(Tasks.size(),1);
        //Check the due date on the case is in 21 days as the Priority on the Case is Low
        System.assertequals(Tasks[0].ActivityDate,Date.today().addDays(21));
        //Check the owner of the Task is same as the owner of Contact
        System.assertequals(Tasks[0].OwnerId, con.OwnerId);
    }
}