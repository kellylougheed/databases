/*
* Author: Kelly Lougheed
* Assignment: Module 6 Part 1
*/

-- Create roles for the Managers, HR Specialists, and Other Users.

CREATE ROLE manager;
CREATE ROLE hr_specialist;
CREATE ROLE other_user;

-- All users have read access to all the tables except Employment.

GRANT SELECT ON * TO other_user;

/* 
* Managers have read access to all the tables (including Employment), 
* plus the ability to apply inserts, updates, and deletes to all tables 
* except Division, Department, Work_Group, Pay_Grade, Employment, 
* and Employee_Work_Group_Assignment
*/

GRANT user TO ROLE manager;

GRANT UPDATE, INSERT, DELETE 
ON PARTY, INDIVIDUAL, ORGANIZATION, PARTY_ROLE_ASSIGNMENT, PARTY_ROLE_TYPE, PURCHASE_ORDER, PURCHASE_ORDER_ITEM, ITEM, CONTACT_USAGE_TYPE, CONTACT_MECHANISM_USAGE, CONTACT_MECHANISM, POSTAL_ADDRESS, EMAIL, TELEPHONE
TO manager;

/* 
* HR Specialists have read access to all tables (including Employment), 
* plus the ability inserts, updates, and deletes to the 
* Division, Department, Work_Group, Pay_Grade, Employment, 
* and Employee_Work_Group_Assignment
*/

GRANT manager TO ROLE hr_specialist;

GRANT UPDATE, INSERT, DELETE
ON DIVISION, DEPARTMENT, WORK_GROUP, PAY_GRADE, EMPLOYMENT, EMPLOYEE_WORK_GROUP_ASSIGNMENT 
TO hr_specialist;
