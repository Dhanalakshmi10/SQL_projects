/*Q1. Create a table “student” with the structure/dictionary given above and insert 10 records
given in the table created.
Create a table “faculty” with the structure/dictionary given above and insert 8 records given
in the table created.
Create a table “course” with the structure/dictionary given above and insert 8 records given
in the table created.
Create a table “registration” with the structure/dictionary given above and insert 18 records
given in the table created*/

use DSML;

CREATE TABLE student (sid VARCHAR2(3) NOT NULL,sname VARCHAR2(10) NOT NULL,sex VARCHAR2(3),major VARCHAR2(3),gpa NUMBER(3,2),PRIMARY KEY(sid));
CREATE TABLE faculty (fid VARCHAR2(3) NOT NULL ,fname VARCHAR2(10) NOT NULL,ext VARCHAR2(3),dept VARCHAR2(3),rank1 VARCHAR2(4),salary INT check (salary >0),PRIMARY KEY(fid));
CREATE TABLE course (CRSNBR VARCHAR2(6) NOT NULL,cname VARCHAR2(25) NOT NULL,credit NUMBER(1),fid VARCHAR2(3),maxenrl INT, FOREIGN KEY (fid) REFERENCES faculty(fid)); 
CREATE TABLE registration (CRSNBR VARCHAR2(6)NOT NULL,sid VARCHAR2(3) NOT NULL,grade VARCHAR2(1),PRIMARY KEY(CRSNBR,SID),FOREIGN KEY (Sid) REFERENCES STUDENT(Sid));
DROP TABLE REGISTRATION;
--imported data for student,facltyand registration table through excel.

INSERT INTO COURSE (CRSNBR, CNAME, CREDIT, MAXENRL, FID ) VALUES ('MGT630','INTRODUCTION TO MGMT',4,'30',138);

INSERT INTO COURSE (CRSNBR, CNAME, CREDIT, MAXENRL, FID) VALUES ('FIN60','MANAGERIAL FINANCE',4,'25',117);

INSERT INTO COURSE (CRSNBR, CNAME, CREDIT, MAXENRL, FID) VALUES ('MKT610','MARKETING FOR MANAGERS',3,'35',75);

INSERT INTO COURSE (CRSNBR, CNAME, CREDIT, MAXENRL, FID) VALUES ('MKT661','TAXATION',3,'30',98);

INSERT INTO COURSE (CRSNBR, CNAME, CREDIT, MAXENRL, FID) VALUES ('FIN602','INVESTMENT SKILLS',3,'25',219);

INSERT INTO COURSE (CRSNBR, CNAME, CREDIT, FID) VALUES ('ACC601','BASIC ACCOUNTING',4,'25',98);

INSERT INTO COURSE (CRSNBR, CNAME, CREDIT, MAXENRL, FID) VALUES ('MGT681',' INTERL. MANAGEMENT',3,'20',36);

INSERT INTO COURSE (CRSNBR, CNAME, CREDIT, MAXENRL, FID) VALUES ('MKT670','PRODUCT MARKETING',3,'20',75);

DESCRIBE REGISTRATION;

select * from COURSE;
--Q2 
SELECT * FROM STUDENT 
ORDER BY SNAME;
--Q3
SELECT * FROM STUDENT 
WHERE GPA > 3.25 AND SEX ='F';
--Q4 
SELECT SNAME,MAJOR,GPA 
FROM STUDENT
WHERE GPA > 3.5 AND MAJOR IN ('ACC','FIN');
--Q5 
SELECT FNAME,SALARY,(.5*SALARY+SALARY) AS NEWSALARY
FROM FACULTY;
--Q6
SELECT AVG(GPA) FROM STUDENT 
WHERE MAJOR ='MGT';
--Q7
CREATE TABLE RGN_COPY AS SELECT * FROM REGISTRATION;
UPDATE RGN_COPY 
SET GRADE ='F'
WHERE CRSNBR ='MGT681';

select * from RGN_COPY;
select * from REGISTRATION;
--Q8 
CREATE TABLE STD_COPY AS SELECT * FROM STUDENT;

DELETE FROM RGN_COPY 
where SID in (SELECT S.SID FROM RGN_COPY R INNER JOIN STD_COPY S ON R.SID =S.SID  WHERE R.SID = 748);

DELETE FROM STD_COPY 
WHERE SID = 748
--Q9
DELETE TABLE RGN_COPY;
DELETE TABLE STD_COPY;
/*--Q10Create a table IPMFA with the following structure:
FID Character (3) where null values are not allowed; FNAME Varchar2(10) where null
values are not allowed, EXT Varchar2(3) where null values are not allowed, DEPT
Varchar2(3), RANK1 Varchar2(4), SALARY as integer. In this table, FID is the primary
key*/
CREATE TABLE IPMFA (FID CHARACTER(3) NOT NULL,FNAME VARCHAR2(10) NOT NULL,EXT VARCHAR2(3)NOT NULL,DEPT VARCHAR2(3),RANKI VARCHAR2(4),SALARY INT,PRIMARY KEY(FID)); 

/*--Q11Create a table IPMCO with the following structure:
CRSNBR Varchar2(6) with null values not allowed, CNAME Varchar2 25) with null values
not allowed, CREDIT as integer, MAXENRL as integer, FID Varchar2(3) with null values
not allowed. Now, introduce FID as Foreign Key and then reference to IPMFAC table
considering FID of IPMFAC table and FID of IPMCO as common field*/
CREATE TABLE IPMCO (CRSNBR Varchar2(6) NOT NULL,CNAME VARCHAR2(25) NOT NULL,CREDIT INT,MAXENRL INT,FID character(3)NOT NULL, FOREIGN KEY(FID) REFERENCES IPMFA(FID)); 

/*Q12-Create a view “Roster” that enables the individual to visualize selected data from the
STUDENT, REGISTRATION, COURSE and FACULTY tables as being one table, This
view includes course number, course name, name of person teaching the course, student ID
and student name.
Display course number, course name, student ID, and student name from view “Roster” for
the course number “FIN601”*/
CREATE VIEW ROSTER AS 
(
SELECT 
R.CRSNBR ,C.CNAME,F.FNAME,S.SID,S.SNAME 
FROM STUDENT S
INNER JOIN REGISTRATION R
ON S.SID = R.SID 
INNER JOIN COURSE C
ON R.CRSNBR = C.CRSNBR 
INNER JOIN FACULTY F
ON C.FID = F.FID
);

;
CREATE VIEW "ROSTER1" AS 
(
SELECT 
R.CRSNBR,C.CNAME,F.FNAME,S.SID,S.SNAME 
FROM STUDENT S,REGISTRATION R,COURSE C,FACULTY F
WHERE S.SID = R.SID 
AND R.CRSNBR = C.CRSNBR 
AND C.FID = F.FID);

DROP VIEW roster;
SELECT * FROM ROSTER;
SELECT CRSNBR ,CNAME,SID,SNAME  FROM ROSTER 
WHERE CRSNBR ='FIN601';

--Q13Create an index “MAJORIND” using the MAJOR column of Student to improve performance, MAJOR descending
CREATE  INDEX MAJORIND ON STUDENT ( MAJOR DESC);
SELECT * FROM STUDENT;
--Q14 
--Write a stored procedure named “Getstudents” : To list all the sname of table Student

CREATE OR REPLACE PROCEDURE Getstudents IS 
BEGIN
SELECT SNAME FROM STUDENT;
END;

EXECUTE Getstudents;

--Q15 
/*
Create trigger, “salary_changes” to display the following information:
Old salary:
New salary:
Salary difference:
The trigger will be fired when the salary difference is observed in the Faculty table.
*/


;
CREATE OR REPLACE TRIGGER SALARY_CHANGES 
BEFORE DELETE OR INSERT OR UPDATE ON FACULTY
FOR EACH ROW 
WHEN (NEW.FID > 0) 
DECLARE 
   SALARY_DIFFERENCE NUMBER; 
BEGIN 
   SALARY_DIFFERENCE := :NEW.SALARY  - :OLD.SALARY; 
   DBMS_OUTPUT.PUT_LINE('OLD SALARY IS: ' || :OLD.SALARY); 
   DBMS_OUTPUT.PUT_LINE('NEW SALARY IS: ' || :NEW.SALARY); 
   DBMS_OUTPUT.PUT_LINE('SALARY DIFFERENCE IS: ' || SALARY_DIFFERENCE); 
END;
/

--UPDATING TABLE FOR TRIGGER ACTIVATION
UPDATE FACULTY SET SALARY = SALARY + 1000 WHERE FID=219;
SELECT * FROM FACULTY;
--------------------------------------------------------------------------------
CREATE TABLE course1 (CRSNBR VARCHAR2(6) NOT NULL,cname VARCHAR2(25) NOT NULL,credit NUMBER(1),maxenrl INT, fid VARCHAR2(3) NOT NULL,FOREIGN KEY (fid) REFERENCES faculty(fid)); 
SELECT * FROM COURSE1;