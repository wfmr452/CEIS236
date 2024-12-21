CREATE SCHEMA IF NOT EXISTS ceis236finalproject 
DEFAULT CHARACTER SET utf8mb4 -- character set
COLLATE utf8mb4_unicode_ci; -- international character and emoji support; case-insensitive comparisons

USE ceis236finalproject;

DROP TABLE IF EXISTS empskill;
DROP TABLE IF EXISTS employee;
DROP TABLE IF EXISTS customer;
DROP TABLE IF EXISTS skill;
DROP TABLE IF EXISTS region;

-- Table region
CREATE TABLE IF NOT EXISTS region (
  regionID INT NOT NULL,
  regionName VARCHAR(15) NOT NULL,
  PRIMARY KEY (regionID),
  UNIQUE INDEX regionID_UNIQUE 
  (regionID ASC) VISIBLE);

-- Table customer
CREATE TABLE IF NOT EXISTS customer (
  cusID INT NOT NULL,
  cusName VARCHAR(30) NOT NULL,
  cusPhone VARCHAR(15) NOT NULL,
  regionID INT NOT NULL,
  PRIMARY KEY (cusID, regionID),
  UNIQUE INDEX cusID_UNIQUE (cusID ASC) 
  VISIBLE,
  INDEX fk_customer_region_idx 
  (regionID ASC) VISIBLE,
  CONSTRAINT fk_customer_region
    FOREIGN KEY (regionID)
    REFERENCES region (regionID)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- Table employee
CREATE TABLE IF NOT EXISTS employee (
  empID VARCHAR(10) NOT NULL,
  empLastName VARCHAR(20) NOT NULL,
  empFirstName VARCHAR(20) NOT NULL,
  empHireDate DATE NOT NULL,
  regionID INT NOT NULL,
  PRIMARY KEY (empID, regionID),
  INDEX fk_employee_region1_idx (regionID ASC) 
  VISIBLE,
  UNIQUE INDEX empID_UNIQUE (empID ASC) VISIBLE,
  CONSTRAINT fk_employee_region1
    FOREIGN KEY (regionID)
    REFERENCES region (regionID)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- Table skill
CREATE TABLE IF NOT EXISTS skill (
  skilID VARCHAR(10) NOT NULL,
  skillDescription VARCHAR(30) NOT NULL,
  skillRate DOUBLE NOT NULL,
  PRIMARY KEY (skilID),
  UNIQUE INDEX skilID_UNIQUE (skilID ASC) 
  VISIBLE);

-- Table empskill
CREATE TABLE IF NOT EXISTS empskill (
  empID VARCHAR(10) NOT NULL,
  skilID VARCHAR(10) NOT NULL,
  INDEX fk_empskill_skill1_idx (skilID ASC) 
  VISIBLE,
  PRIMARY KEY (empID, skilID),
  CONSTRAINT fk_empskill_employee1
    FOREIGN KEY (empID)
    REFERENCES employee (empID)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_empskill_skill1
    FOREIGN KEY (skilID)
    REFERENCES skill (skilID)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);
 
-- Problem 3
INSERT INTO region VALUES (1001, 'Northwest');
INSERT INTO region VALUES (1002, 'Southwest');
INSERT INTO region VALUES (1003, 'Northeast');
INSERT INTO region VALUES (1004, 'Southeast');
INSERT INTO region VALUES (1005, 'Central');

SELECT * FROM region;

-- Problem 4
INSERT INTO customer VALUES (1, 'Bellsouth', '222-333-4571', 1004);
INSERT INTO customer VALUES (2, 'Comcast', '253-444-5555', 1003);
INSERT INTO customer VALUES (3, 'Ford', '367-555-6666', 1005);
INSERT INTO customer VALUES (4, 'Exxon', '444-777-7777',1004);
INSERT INTO customer VALUES (5, 'Tesla', '555-222-8888',1005);

SELECT * FROM customer;

-- Problem 5
INSERT INTO employee VALUES ('E1', 'Radons', 'Markus', '2019-2-7', 1004);
INSERT INTO employee VALUES ('E2', 'Craig', 'Brett', '2019-3-30', 1004);
INSERT INTO employee VALUES ('E3', 'Williams', 'Josh', '1999-3-17', 1005);
INSERT INTO employee VALUES ('E4', 'Cope', 'Leslie', '2017-4-21', 1002);
INSERT INTO employee VALUES ('E5', 'Mudd', 'Roger', '2007-10-18', 1003);

SELECT * FROM employee;

-- Problem 6
INSERT INTO skill VALUES ('S1', 'Data Entry I', 20);
INSERT INTO skill VALUES ('S2', 'Database Admin I', 35);
INSERT INTO skill VALUES ('S3', 'Database Admin II', 50);
INSERT INTO skill VALUES ('S4', 'Database Architect', 65);
INSERT INTO skill VALUES ('S5', 'Java I', 40);
INSERT INTO skill VALUES ('S6', 'Java II', 65);
INSERT INTO skill VALUES ('S7', 'Python I', 35);
INSERT INTO skill VALUES ('S8', 'Python II', 55);

SELECT * FROM skill;

-- Problem 7
INSERT INTO empskill VALUES ('E1', 'S2');
INSERT INTO empskill VALUES ('E1', 'S5');
INSERT INTO empskill VALUES ('E1', 'S8');
INSERT INTO empskill VALUES ('E2', 'S3');
INSERT INTO empskill VALUES ('E3', 'S4');
INSERT INTO empskill VALUES ('E3', 'S6');
INSERT INTO empskill VALUES ('E3', 'S7');
INSERT INTO empskill VALUES ('E4', 'S4');
INSERT INTO empskill VALUES ('E4', 'S5');

SELECT * FROM empskill;

-- Problem 8
SELECT ROUND(AVG(skillRate), 2) AS Average, 
       MAX(skillRate) AS Maximum, 
       MIN(skillRate) AS Minimum
FROM skill;

-- Problem 9
SELECT cusName
FROM customer
JOIN region ON customer.regionID = region.regionID
WHERE regionName = 'Central';


-- Problem 10
SELECT DISTINCT e.empID, empLastName, empFirstName
FROM employee e
JOIN empskill es ON e.empID = es.empID
WHERE skilID IN (
    SELECT skilID FROM skill WHERE skillRate >= 50
)
ORDER BY empID;

-- Problem 11
CREATE OR REPLACE VIEW Employee_Skills AS
(
    SELECT e.empID, empLastName, empFirstName, skillDescription, skillRate
    FROM employee e
    JOIN empskill es ON e.empID = es.empID
    JOIN skill s ON es.skilID = s.skilID
);

SELECT * FROM Employee_Skills;
