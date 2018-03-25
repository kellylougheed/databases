/*
* Author: Kelly Lougheed
* Assignment: Module 5 #1 (Physical Database Design)
* 
* Summary of Indexes (in order of appearance, included in SQL below)
* PARTY_ROLE_ASSIGNMENT: PARTY_ROLE_ASSIGNMENT_ID, PARTY_ID
* PARTY_ROLE_ASSIGNMENT: PARTY_ROLE_ASSIGNMENT_ID, PARTY_ROLE_TYPE_CODE
* CONTACT_MECHANISM_USAGE: PARTY_ID, CONTACT_MECHANISM_ID, CONTACT_USAGE_TYPE_CODE
* PURCHASE_ORDER: PURCHASE_ORDER_NUMBER, PARTY_ROLE_ASSIGNMENT_ID
* EMPLOYMENT: EMPLOYEE_ID, PAY_GRADE_CODE
* EMPLOYMENT: EMPLOYEE_ID, PARTY_ROLE_ASSIGNMENT_ID
* DIVISION: DIVISION_ID, DIVISION_MANAGER_EMPLOYEE_ID
* DEPARTMENT: DEPARTMENT_ID, DIVISION_ID
* DEPARTMENT: DEPARTMENT_ID, DEPARTMENT_MANAGER_EMPLOYEE_ID
* WORK_GROUP: WORK_GROUP_ID, DEPARTMENT_ID
* WORK_GROUP: WORK_GROUP_ID, WORK_GROUP_MANAGER_EMPLOYEE_ID
*/

CREATE TABLE PARTY
(
  PARTY_ID INTEGER NOT NULL,
  PARTY_TYPE_CODE VARCHAR(10) NOT NULL
);

ALTER TABLE PARTY
ADD CONSTRAINT PARTY_PK_PARTY_ID PRIMARY KEY (PARTY_ID);

CREATE TABLE INDIVIDUAL
(
  PARTY_ID INTEGER NOT NULL,
  GIVEN_NAME VARCHAR(40) NOT NULL,
  MIDDLE_NAME VARCHAR(40) NULL,
  LAST_NAME VARCHAR(40) NOT NULL,
  BIRTH_DATE DATE NOT NULL
);

ALTER TABLE INDIVIDUAL
ADD CONSTRAINT INDIVIDUAL_PK_PARTY_ID PRIMARY KEY (PARTY_ID);

ALTER TABLE INDIVIDUAL
ADD CONSTRAINT INDIVIDUAL_FK_PARTY_ID
    FOREIGN KEY (PARTY_ID)
    REFERENCES PARTY (PARTY_ID);

CREATE TABLE ORGANIZATION
(
  PARTY_ID INTEGER NOT NULL,
  PARTY_NAME VARCHAR(60) NOT NULL
);

ALTER TABLE ORGANIZATION
ADD CONSTRAINT ORGANIZATION_PK_PARTY_ID PRIMARY KEY (PARTY_ID);

ALTER TABLE ORGANIZATION
ADD CONSTRAINT ORGANIZATION_FK_PARTY_ID
    FOREIGN KEY (PARTY_ID)
    REFERENCES PARTY (PARTY_ID);

CREATE TABLE PARTY_ROLE_ASSIGNMENT
(
  PARTY_ROLE_ASSIGNMENT_ID INTEGER NOT NULL,
  PARTY_ID INTEGER NOT NULL,
  PARTY_ROLE_TYPE_CODE VARCHAR(10) NOT NULL,
  ROLE_EFFECTIVE_DATE DATE NOT NULL,
  ROLE_TERMINATION_DATE DATE NULL
);

ALTER TABLE PARTY_ROLE_ASSIGNMENT
ADD CONSTRAINT PARTY_ROLE_ASSIGNMENT_PK_PARTY_ID PRIMARY KEY (PARTY_ID);

ALTER TABLE PARTY_ROLE_ASSIGNMENT
ADD CONSTRAINT PARTY_ROLE_ASSIGNMENT_FK_PARTY_ID
    FOREIGN KEY (PARTY_ID)
    REFERENCES PARTY (PARTY_ID);

CREATE INDEX PARTY_ROLE_ASSIGNMENT_IX_PARTY_ID ON PARTY_ROLE_ASSIGNMENT (PARTY_ROLE_ASSIGNMENT_ID, PARTY_ID);

CREATE TABLE PARTY_ROLE_TYPE
(
  PARTY_ROLE_TYPE CODE VARCHAR(10) NOT NULL,
  PARTY_ROLE_TYPE_NAME VARCHAR(40) NOT NULL
);

ALTER TABLE PARTY_ROLE_TYPE
ADD CONSTRAINT PARTY_ROLE_TYPE_PK_PARTY_ROLE_TYPE_CODE PRIMARY KEY (PARTY_ROLE_TYPE_CODE);

ALTER TABLE PARTY_ROLE_ASSIGNMENT
ADD CONSTRAINT PARTY_ROLE_ASSIGNMENT_FK_PARTY_ROLE_TYPE_CODE
    FOREIGN KEY (PARTY_ROLE_TYPE_CODE)
    REFERENCES PARTY_ROLE_TYPE (PARTY_ROLE_TYPE_CODE);

CREATE INDEX PARTY_ROLE_ASSIGNMENT_IX_PARTY_ROLE_TYPE_CODE ON PARTY_ROLE_ASSIGNMENT (PARTY_ROLE_ASSIGNMENT_ID, PARTY_ROLE_TYPE_CODE);

CREATE TABLE CONTACT_MECHANISM_USAGE
(
  PARTY_ID INTEGER NOT NULL,
  CONTACT_MECHANISM_ID INTEGER NOT NULL,
  CONTACT_USAGE_TYPE_CODE VARCHAR(10) NOT NULL
);

ALTER TABLE CONTACT_MECHANISM_USAGE
ADD CONSTRAINT CONTACT_MECHANISM_USAGE_PK_PARTY_ID_CONTACT_MECHANISM_ID PRIMARY KEY (PARTY_ID, CONTACT_MECHANISM_ID);

CREATE TABLE CONTACT_USAGE_TYPE
(
  CONTACT_USAGE_TYPE_CODE VARCHAR(10) NOT NULL,
  CONTACT_USAGE_TYPE_DESCRIPTION VARCHAR(100) NOT NULL
);

ALTER TABLE CONTACT_USAGE_TYPE
ADD CONSTRAINT CONTACT_USAGE_TYPE_PK_CONTACT_USAGE_TYPE_CODE PRIMARY KEY (CONTACT_USAGE_TYPE_CODE);

ALTER TABLE CONTACT_MECHANISM_USAGE
ADD CONSTRAINT CONTACT_MECHANISM_USAGE_FK_CONTACT_USAGE_TYPE_CODE
    FOREIGN KEY (CONTACT_USAGE_TYPE_CODE)
    REFERENCES CONTACT_USAGE_TYPE (CONTACT_USAGE_TYPE_CODE);

CREATE INDEX CONTACT_MECHANISM_USAGE_IX_CONTACT_USAGE_TYPE_CODE ON CONTACT_MECHANISM_USAGE (PARTY_ID, CONTACT_MECHANISM_ID, CONTACT_USAGE_TYPE_CODE);

CREATE TABLE CONTACT_MECHANISM
(
  CONTACT_MECHANISM_ID INTEGER NOT NULL,
  CONTACT_MECHANISM_TYPE_CODE VARCHAR(10) NOT NULL
);

ALTER TABLE CONTACT_MECHANISM
ADD CONSTRAINT CONTACT_MECHANISM_PK_CONTACT_MECHANISM_ID PRIMARY KEY (CONTACT_MECHANISM_ID);

CREATE TABLE POSTAL_ADDRESS
(
  CONTACT_MECHANISM_ID INTEGER NOT NULL,
  ADDRESS_LINE_1_TEXT VARCHAR(60) NOT NULL,
  ADDRESS_LINE_2_TEXT VARCHAR(60) NULL,
  CITY_NAME VARCHAR(40) NOT NULL,
  STATE_PROVINCE_CODE VARCHAR(10) NOT NULL,
  COUNTRY_CODE VARCHAR(10) NOT NULL,
  POSTAL_CODE VARCHAR(10) NOT NULL
);

ALTER TABLE POSTAL_ADDRESS
ADD CONSTRAINT POSTAL_ADDRESS_PK_CONTACT_MECHANISM_ID PRIMARY KEY (CONTACT_MECHANISM_ID);

ALTER TABLE POSTAL_ADDRESS
ADD CONSTRAINT POSTAL_ADDRESS_FK_CONTACT_MECHANISM_ID
    FOREIGN KEY (CONTACT_MECHANISM_ID)
    REFERENCES CONTACT_MECHANISM (CONTACT_MECHANISM_ID);

CREATE TABLE EMAIL
(
  CONTACT_MECHANISM_ID INTEGER NOT NULL,
  EMAIL_ADDRESS VARCHAR(60) NOT NULL
);

ALTER TABLE EMAIL
ADD CONSTRAINT EMAIL_PK_CONTACT_MECHANISM_ID PRIMARY KEY (CONTACT_MECHANISM_ID);

ALTER TABLE EMAIL
ADD CONSTRAINT EMAIL_FK_CONTACT_MECHANISM_ID
    FOREIGN KEY (CONTACT_MECHANISM_ID)
    REFERENCES CONTACT_MECHANISM (CONTACT_MECHANISM_ID);

CREATE TABLE TELEPHONE
(
  AREA_CODE INTEGER NOT NULL,
  PHONE_NUMBER INTEGER NOT NULL,
  PHONE_EXTENSION_NUMBER INTEGER NOT NULL,
  DEVICE_TYPE_CODE VARCHAR(10) NULL
);

ALTER TABLE TELEPHONE
ADD CONSTRAINT TELEPHONE_PK_CONTACT_MECHANISM_ID PRIMARY KEY (CONTACT_MECHANISM_ID);

ALTER TABLE TELEPHONE
ADD CONSTRAINT TELEPHONE_FK_CONTACT_MECHANISM_ID
    FOREIGN KEY (CONTACT_MECHANISM_ID)
    REFERENCES CONTACT_MECHANISM (CONTACT_MECHANISM_ID);

CREATE TABLE PURCHASE_ORDER
(
  PURCHASE_ORDER_NUMBER INTEGER NOT NULL,
  PARTY_ROLE_ASSIGNMENT_ID INTEGER NOT NULL,
  ORDER_DATE DATE NOT NULL,
  ORDER_STATUS_CODE VARCHAR(10) NOT NULL
);

ALTER TABLE PURCHASE_ORDER
ADD CONSTRAINT PURCHASE_ORDER_PK_PURCHASE_ORDER_NUMBER PRIMARY KEY (PURCHASE_ORDER_NUMBER);

ALTER TABLE PURCHASE_ORDER
ADD CONSTRAINT PURCHASE_ORDER_FK_PARTY_ROLE_ASSIGNMENT_ID
    FOREIGN KEY (PARTY_ROLE_ASSIGNMENT_ID)
    REFERENCES PARTY_ROLE_ASSIGNMENT (PARTY_ROLE_ASSIGNMENT_ID);

CREATE INDEX PURCHASE_ORDER_IX_PARTY_ROLE_ASSIGNMENT_ID ON PURCHASE_ORDER (PURCHASE_ORDER_NUMBER, PARTY_ROLE_ASSIGNMENT_ID);

CREATE TABLE ITEM
(
  ITEM_ID INTEGER NOT NULL,
  ITEM_DESCRIPTION VARCHAR(100) NOT NULL,
  ITEM_LIST_PRICE DECIMAL(10,2) NOT NULL
);

CREATE TABLE PURCHASE_ORDER_ITEM
(
  PURCHASE_ORDER_NUMBER INTEGER NOT NULL,
  ITEM_ID INTEGER NOT NULL,
  ITEM_PURCHASE_UNIT_PRICE DECIMAL(10,2) NOT NULL,
  ITEM_PURCHASE_QUANTITY INTEGER NOT NULL
);

ALTER TABLE PURCHASE_ORDER_ITEM
ADD CONSTRAINT PURCHASE_ORDER_ITEM_PK_PURCHASE_ORDER_NUMBER_ITEM_ID PRIMARY KEY (PURCHASE_ORDER_NUMBER, ITEM_ID);

ALTER TABLE PURCHASE_ORDER_ITEM
ADD CONSTRAINT PURCHASE_ORDER_ITEM_FK_PURCHASE_ORDER_NUMBER
    FOREIGN KEY (PURCHASE_ORDER_NUMBER)
    REFERENCES PURCHASE_ORDER (PURCHASE_ORDER_NUMBER);

ALTER TABLE PURCHASE_ORDER_ITEM
ADD CONSTRAINT PURCHASE_ORDER_ITEM_FK_ITEM_ID
    FOREIGN KEY (ITEM_ID)
    REFERENCES ITEM(ITEM_ID);

CREATE TABLE PAY_GRADE
(
  PAY_GRADE_CODE VARCHAR(10) NOT NULL,
  PAY_GRADE_NAME VARCHAR(40) NOT NULL
);

ALTER TABLE PAY_GRADE
ADD CONSTRAINT PAY_GRADE_PK_PAY_GRADE_CODE PRIMARY KEY (PAY_GRADE_CODE);

CREATE TABLE EMPLOYMENT
(
  EMPLOYEE_ID INTEGER NOT NULL,
  PAY_GRADE_CODE VARCHAR(10) NOT NULL,
  PARTY_ROLE_ASSIGNMENT_ID INTEGER NOT NULL
);

ALTER TABLE EMPLOYMENT
ADD CONSTRAINT EMPLOYMENT_PK_EMPLOYEE_ID PRIMARY KEY (EMPLOYEE_ID);

ALTER TABLE EMPLOYMENT
ADD CONSTRAINT EMPLOYMENT_FK_PAY_GRADE_CODE
    FOREIGN KEY (PAY_GRADE_CODE)
    REFERENCES PAY_GRADE (PAY_GRADE_CODE);

CREATE INDEX EMPLOYMENT_IX_PAY_GRADE_CODE ON EMPLOYMENT (EMPLOYEE_ID, PAY_GRADE_CODE);

ALTER TABLE EMPLOYMENT
ADD CONSTRAINT EMPLOYMENT_FK_PARTY_ROLE_ASSIGNMENT_ID
    FOREIGN KEY (PARTY_ROLE_ASSIGNMENT_ID)
    REFERENCES PARTY_ROLE_ASSIGNMENT (PARTY_ROLE_ASSIGNMENT_ID);

CREATE INDEX EMPLOYMENT_IX_PARTY_ROLE_ASSIGNMENT_ID ON EMPLOYMENT (EMPLOYEE_ID, PARTY_ROLE_ASSIGNMENT_ID);

CREATE TABLE DIVISION
(
  DIVISION_ID INTEGER NOT NULL,
  DIVISION_NAME VARCHAR(60) NOT NULL,
  DIVISION_MANAGER_EMPLOYEE_ID INTEGER NOT NULL
);

ALTER TABLE DIVISION
ADD CONSTRAINT DIVISION_PK_DIVISION_ID PRIMARY KEY (DIVISION_ID);

ALTER TABLE DIVISION
ADD CONSTRAINT DIVISION_FK_DIVISION_MANAGER_EMPLOYEE_ID
    FOREIGN KEY (DIVISION_MANAGER_EMPLOYEE_ID)
    REFERENCES EMPLOYMENT (EMPLOYEE_ID);

CREATE INDEX DIVISION_IX_DIVISION_MANAGER_EMPLOYEE_ID ON DIVISION (DIVISION_ID, DIVISION_MANAGER_EMPLOYEE_ID);

CREATE TABLE DEPARTMENT
(
  DEPARTMENT_ID INTEGER NOT NULL,
  DEPARTMENT_NAME VARCHAR(60) NOT NULL,
  DIVISION_ID INTEGER NOT NULL,
  DEPARTMENT_MANAGER_EMPLOYEE_ID INTEGER NOT NULL
);

ALTER TABLE DEPARTMENT
ADD CONSTRAINT DEPARTMENT_PK_DEPARTMENT_ID PRIMARY KEY (DEPARTMENT_ID);

ALTER TABLE DEPARTMENT
ADD CONSTRAINT DEPARTMENT_FK_DIVISION_ID
    FOREIGN KEY (DIVISION_ID)
    REFERENCES DIVISION (DIVISION_ID);

CREATE INDEX DEPARTMENT_IX_DIVISION_ID ON DEPARTMENT (DEPARTMENT_ID, DIVISION_ID);

ALTER TABLE DEPARTMENT
ADD CONSTRAINT DEPARTMENT_FK_DEPARTMENT_MANAGER_EMPLOYEE_ID
    FOREIGN KEY (DEPARTMENT_MANAGER_EMPLOYEE_ID)
    REFERENCES EMPLOYMENT (EMPLOYEE_ID);

CREATE INDEX DEPARTMENT_IX_DEPARTMENT_MANAGER_EMPLOYEE_ID ON DEPARTMENT (DEPARTMENT_ID, DEPARTMENT_MANAGER_EMPLOYEE_ID);

CREATE TABLE WORK_GROUP
(
  WORK_GROUP_ID INTEGER NOT NULL,
  WORK_GROUP_NAME VARCHAR(60) NOT NULL,
  DEPARTMENT_ID INTEGER NOT NULL,
  WORK_GROUP_MANAGER_EMPLOYEE_ID INTEGER NOT NULL
);

ALTER TABLE WORK_GROUP
ADD CONSTRAINT WORK_GROUP_PK_WORK_GROUP_ID PRIMARY KEY (WORK_GROUP_ID);

ALTER TABLE WORK_GROUP
ADD CONSTRAINT WORK_GROUP_FK_DEPARTMENT_ID
    FOREIGN KEY (DEPARTMENT_ID)
    REFERENCES DEPARTMENT (DEPARTMENT_ID);

CREATE INDEX WORK_GROUP_IX_DEPARTMENT_ID ON WORK_GROUP (WORK_GROUP_ID, DEPARTMENT_ID);

ALTER TABLE WORK_GROUP
ADD CONSTRAINT WORK_GROUP_FK_WORK_GROUP_MANAGER_EMPLOYEE_ID
    FOREIGN KEY (WORK_GROUP_MANAGER_EMPLOYEE_ID)
    REFERENCES EMPLOYMENT (EMPLOYEE_ID);

CREATE INDEX WORK_GROUP_IX_WORK_GROUP_MANAGER_EMPLOYEE_ID ON WORK_GROUP (WORK_GROUP_ID, WORK_GROUP_MANAGER_EMPLOYEE_ID);

CREATE TABLE EMPLOYEE_WORK_GROUP_ASSIGNMENT
(
  EMPLOYEE_ID INTEGER NOT NULL,
  WORK_GROUP_ID INTEGER NOT NULL,
  WORK_GROUP_ASSIGNMENT_EFFECTIVE_DATE DATE NOT NULL,
  WORK_GROUP_ASSIGNMENT_END_DATE DATE NULL
);

ALTER TABLE EMPLOYEE_WORK_GROUP_ASSIGNMENT
ADD CONSTRAINT EMPLOYEE_WORK_GROUP_ASSIGNMENT_PK_EMP_ID_WG_ID_WGA_DATE PRIMARY KEY (EMPLOYEE_ID, WORK_GROUP_ID, WORK_GROUP_ASSIGNMENT_EFFECTIVE_DATE);

ALTER TABLE EMPLOYEE_WORK_GROUP_ASSIGNMENT
ADD CONSTRAINT EMPLOYEE_WORK_GROUP_ASSIGNMENT_FK_EMPLOYEE_ID
    FOREIGN KEY (EMPLOYEE_ID)
    REFERENCES EMPLOYMENT (EMPLOYEE_ID);

ALTER TABLE EMPLOYEE_WORK_GROUP_ASSIGNMENT
ADD CONSTRAINT EMPLOYEE_WORK_GROUP_ASSIGNMENT_FK_WORK_GROUP_ID
    FOREIGN KEY (WORK_GROUP_ID)
    REFERENCES WORK_GROUP (WORK_GROUP_ID);
