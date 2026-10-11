
CREATE DATABASE IF NOT EXISTS college;
USE college;

-- Drop child tables before parent tables so the script can be rerun.
DROP TABLE IF EXISTS ENROLLMENT;
DROP TABLE IF EXISTS ADMISSION;
DROP TABLE IF EXISTS SOCIETY;
DROP TABLE IF EXISTS COURSE;
DROP TABLE IF EXISTS STUDENT;

CREATE TABLE STUDENT (
  Rollno VARCHAR(8) NOT NULL,
  Name VARCHAR(40) NOT NULL,
  Dateofbirth DATE,
  CONSTRAINT pk_student PRIMARY KEY (Rollno)
);

CREATE TABLE COURSE (
  SID VARCHAR(6) NOT NULL,
  Cname VARCHAR(40) NOT NULL,
  TotalSeats INT NOT NULL,
  Duration INT,
  Coursetype VARCHAR(10) NOT NULL,
  TeacherInCharge VARCHAR(40),
  CONSTRAINT pk_course PRIMARY KEY (SID),
  CONSTRAINT uq_cname UNIQUE (Cname),
  CONSTRAINT chk_seats CHECK (TotalSeats > 0),
  CONSTRAINT chk_duration CHECK (Duration BETWEEN 1 AND 6),
  CONSTRAINT chk_ctype CHECK (Coursetype IN ('Fulltime','Parttime'))
);

CREATE TABLE SOCIETY (
  SocID VARCHAR(6) NOT NULL,
  Socname VARCHAR(40) NOT NULL,
  Mentor VARCHAR(40),
  TotalSeats INT NOT NULL,
  CONSTRAINT pk_society PRIMARY KEY (SocID),
  CONSTRAINT uq_socname UNIQUE (Socname),
  CONSTRAINT chk_socseats CHECK (TotalSeats > 0)
);

CREATE TABLE ADMISSION (
  Rollno VARCHAR(8) NOT NULL,
  SID VARCHAR(6) NOT NULL,
  Dateofadmission DATE NOT NULL,
  CONSTRAINT pk_admission PRIMARY KEY (Rollno, SID),
  CONSTRAINT fk_adm_student FOREIGN KEY (Rollno)
    REFERENCES STUDENT(Rollno) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_adm_course FOREIGN KEY (SID)
    REFERENCES COURSE(SID) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE ENROLLMENT (
  Rollno VARCHAR(8) NOT NULL,
  SocID VARCHAR(6) NOT NULL,
  Dateofenrollment DATE NOT NULL,
  CONSTRAINT pk_enrollment PRIMARY KEY (Rollno, SocID),
  CONSTRAINT fk_enr_student FOREIGN KEY (Rollno)
    REFERENCES STUDENT(Rollno) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_enr_society FOREIGN KEY (SocID)
    REFERENCES SOCIETY(SocID) ON DELETE CASCADE ON UPDATE CASCADE
);

-- ---------------------------------------------------------------------------

INSERT INTO STUDENT (Rollno, Name, Dateofbirth) VALUES
('X2001','Ankit Sharma','2001-03-14'),
('X2002','Riya Verma','2002-05-11'),
('Z2003','Sana Iqbal','2001-11-02'),
('Z2004','Arjun Nair','2003-01-25'),
('X2005','Aditi Rao','2001-07-09'),
('Y2006','Rahul Gupta','2000-09-30'),
('X2007','Neha Joshi','2002-02-18'),
('Z2008','Vikram Singh','2001-12-05'),
('Y2009','Pooja Mehta','2003-04-22'),
('X2010','Amit Kapoor','2001-08-17');

INSERT INTO COURSE (SID, Cname, TotalSeats, Duration, Coursetype, TeacherInCharge) VALUES
('CS01','BSc(P)CS',60,3,'Fulltime','R. K. Gupta'),
('CS02','Computer Science',45,3,'Fulltime','S. Gupta'),
('CH01','Chemistry',40,3,'Fulltime','S. Menon'),
('MA02','Mathematics',50,3,'Parttime','A. Gupta'),
('EN03','English',40,3,'Parttime','P. Das'),
('PH01','Physics',35,3,'Fulltime','V. Rao');

INSERT INTO SOCIETY (SocID, Socname, Mentor, TotalSeats) VALUES
('S01','Debating','Dr. A. Sharma',30),
('S02','Music','Dr. B. Verma',25),
('S03','Dramatics','Dr. C. Nair',20),
('S04','Photography','Dr. D. Rao',15),
('S05','Literary','Dr. E. Das',22);

INSERT INTO ADMISSION (Rollno, SID, Dateofadmission) VALUES
('X2001','CS01','2019-07-15'),
('X2001','MA02','2019-08-01'),
('X2002','CS01','2019-07-16'),
('Z2003','CH01','2019-07-18'),
('Z2003','EN03','2019-08-05'),
('X2005','MA02','2019-07-20'),
('Y2006','CS01','2019-07-17'),
('X2007','CS02','2019-07-19'),
('Z2008','CS01','2019-07-21'),
('Y2009','EN03','2019-08-02'),
('X2010','MA02','2019-07-22'),
('X2010','CS02','2019-07-23');

INSERT INTO ENROLLMENT (Rollno, SocID, Dateofenrollment) VALUES
('X2001','S01','2019-08-10'),
('X2001','S02','2019-08-12'),
('X2002','S01','2019-08-11'),
('Z2003','S03','2019-08-15'),
('X2005','S01','2019-08-13'),
('Y2006','S02','2019-08-14'),
('X2007','S01','2019-08-16'),
('Z2008','S04','2019-08-18'),
('Y2009','S01','2019-08-19'),
('X2010','S03','2019-08-20');

-- -----------------------------------------------------------------------------


-- Q1. Names of students enrolled in any course
SELECT DISTINCT s.Name
FROM STUDENT s
JOIN ADMISSION a ON s.Rollno = a.Rollno;

-- Q2. Students enrolled in at least one part-time course
SELECT DISTINCT s.Name
FROM STUDENT s
JOIN ADMISSION a ON s.Rollno = a.Rollno
JOIN COURSE c ON a.SID = c.SID
WHERE c.Coursetype = 'Parttime';

-- Q3. Students whose names start with A
SELECT Name FROM STUDENT WHERE Name LIKE 'A%';

-- Q4. Details of students studying Computer Science or Chemistry
SELECT DISTINCT s.Rollno, s.Name, s.Dateofbirth
FROM STUDENT s
JOIN ADMISSION a ON s.Rollno = a.Rollno
JOIN COURSE c ON a.SID = c.SID
WHERE c.Cname IN ('Computer Science','Chemistry');

-- Q5. Roll number starts with X or Z and ends with 9
SELECT Name FROM STUDENT
WHERE (Rollno LIKE 'X%' OR Rollno LIKE 'Z%')
  AND Rollno LIKE '%9';

-- Q6. Course details for courses with more than N students; change N as needed
SET @N = 3;
SELECT c.SID, c.Cname, c.TotalSeats, c.Duration, c.Coursetype,
       c.TeacherInCharge, COUNT(a.Rollno) AS Enrolled
FROM COURSE c
JOIN ADMISSION a ON c.SID = a.SID
GROUP BY c.SID, c.Cname, c.TotalSeats, c.Duration, c.Coursetype, c.TeacherInCharge
HAVING COUNT(a.Rollno) > @N;

-- Q7. Modify a student's name (changes sample data)
UPDATE STUDENT SET Name = 'Ankit Kumar Sharma' WHERE Rollno = 'X2001';
SELECT * FROM STUDENT WHERE Rollno = 'X2001';

-- Q8. Course names with more than five admissions
SELECT c.Cname, COUNT(*) AS Enrolled
FROM ADMISSION a
JOIN COURSE c ON a.SID = c.SID
GROUP BY c.SID, c.Cname
HAVING COUNT(*) > 5;

-- Q9. Youngest student enrolled in BSc(P)CS (latest date of birth; ties included)
SELECT s.Name, s.Dateofbirth
FROM STUDENT s
JOIN ADMISSION a ON s.Rollno = a.Rollno
JOIN COURSE c ON a.SID = c.SID
WHERE c.Cname = 'BSc(P)CS'
  AND s.Dateofbirth = (
    SELECT MAX(s2.Dateofbirth)
    FROM STUDENT s2
    JOIN ADMISSION a2 ON s2.Rollno = a2.Rollno
    JOIN COURSE c2 ON a2.SID = c2.SID
    WHERE c2.Cname = 'BSc(P)CS'
  );

-- Q10. Most popular society by number of members (ties included)
SELECT y.Socname, COUNT(*) AS Members
FROM SOCIETY y
JOIN ENROLLMENT e ON y.SocID = e.SocID
GROUP BY y.SocID, y.Socname
HAVING COUNT(*) = (
  SELECT MAX(cnt)
  FROM (SELECT COUNT(*) AS cnt FROM ENROLLMENT GROUP BY SocID) AS t
);

-- Q11. Two most popular part-time courses
SELECT c.Cname, COUNT(*) AS Enrolled
FROM COURSE c
JOIN ADMISSION a ON c.SID = a.SID
WHERE c.Coursetype = 'Parttime'
GROUP BY c.SID, c.Cname
ORDER BY Enrolled DESC, c.Cname
LIMIT 2;

-- Q12. Students admitted to full-time courses only; must have at least one admission
SELECT DISTINCT s.Rollno, s.Name
FROM STUDENT s
JOIN ADMISSION a ON s.Rollno = a.Rollno
WHERE NOT EXISTS (
  SELECT 1
  FROM ADMISSION a2
  JOIN COURSE c2 ON a2.SID = c2.SID
  WHERE a2.Rollno = s.Rollno
    AND c2.Coursetype <> 'Fulltime'
);

-- Q13. Course names with more than 30 admissions
SELECT c.Cname, COUNT(*) AS Admitted
FROM ADMISSION a
JOIN COURSE c ON a.SID = c.SID
GROUP BY c.SID, c.Cname
HAVING COUNT(*) > 30;

-- Q14. Students admitted to any course and courses with at least one student
SELECT DISTINCT s.Name AS Item, 'Student' AS Kind
FROM STUDENT s JOIN ADMISSION a ON s.Rollno = a.Rollno
UNION
SELECT DISTINCT c.Cname, 'Course'
FROM COURSE c JOIN ADMISSION a ON c.SID = a.SID;

-- Q15. Full-time courses whose teacher's name contains Gupta
SELECT Cname, TeacherInCharge
FROM COURSE
WHERE TeacherInCharge LIKE '%Gupta%'
  AND Coursetype = 'Fulltime';

-- Q16. Courses whose enrolment is exactly 10% of total seats
SELECT c.Cname, c.TotalSeats, COUNT(a.Rollno) AS Enrolled
FROM COURSE c
LEFT JOIN ADMISSION a ON c.SID = a.SID
GROUP BY c.SID, c.Cname, c.TotalSeats
HAVING COUNT(a.Rollno) = c.TotalSeats * 0.10;

-- Q17. Filled and vacant seats for every course
SELECT c.Cname, c.TotalSeats, COUNT(a.Rollno) AS Filled,
       c.TotalSeats - COUNT(a.Rollno) AS Vacant
FROM COURSE c
LEFT JOIN ADMISSION a ON c.SID = a.SID
GROUP BY c.SID, c.Cname, c.TotalSeats
ORDER BY Vacant DESC;

-- Q18. Increase every course's seats by 10% (changes data)
UPDATE COURSE SET TotalSeats = CEIL(TotalSeats * 1.10);
SELECT SID, Cname, TotalSeats FROM COURSE;

-- Q19. Add a Yes/No fees-paid field (changes table structure)
ALTER TABLE ENROLLMENT
  ADD COLUMN FeesPaid VARCHAR(3) NOT NULL DEFAULT 'No'
  CHECK (FeesPaid IN ('Yes','No'));

-- Q20. Move all admission dates forward by one year (changes data)
UPDATE ADMISSION
SET Dateofadmission = DATE_ADD(Dateofadmission, INTERVAL 1 YEAR);

-- Q21. Create a view with course enrolment and vacant seats
CREATE OR REPLACE VIEW CourseEnrolment AS
SELECT c.SID, c.Cname, c.TotalSeats, COUNT(a.Rollno) AS TotalEnrolled,
       c.TotalSeats - COUNT(a.Rollno) AS Vacant
FROM COURSE c
LEFT JOIN ADMISSION a ON c.SID = a.SID
GROUP BY c.SID, c.Cname, c.TotalSeats;

SELECT * FROM CourseEnrolment ORDER BY TotalEnrolled DESC;

-- Q22. Number of courses with more than five students, by course type
SELECT Coursetype, COUNT(*) AS PopularCourses
FROM (
  SELECT c.SID, c.Coursetype
  FROM COURSE c
  JOIN ADMISSION a ON c.SID = a.SID
  GROUP BY c.SID, c.Coursetype
  HAVING COUNT(*) > 5
) AS popular
GROUP BY Coursetype;

-- Q23. Add mobile number column (changes table structure)
ALTER TABLE STUDENT
  ADD COLUMN Mobile CHAR(10) DEFAULT '9999999999';

-- Q24. Count students older than 18 years today
SELECT COUNT(*) AS StudentsOver18
FROM STUDENT
WHERE TIMESTAMPDIFF(YEAR, Dateofbirth, CURDATE()) > 18;

-- Q25. Students born in 2001 admitted to at least one part-time course
SELECT DISTINCT s.Name, s.Dateofbirth
FROM STUDENT s
JOIN ADMISSION a ON s.Rollno = a.Rollno
JOIN COURSE c ON a.SID = c.SID
WHERE s.Dateofbirth >= '2001-01-01'
  AND s.Dateofbirth < '2002-01-01'
  AND c.Coursetype = 'Parttime';
  

-- -----------------------------------------------------------------------------


-- Example accounts: replace these sample passwords for local practice.
CREATE USER IF NOT EXISTS 'clerk'@'localhost' IDENTIFIED BY 'PracticeOnly#123';
CREATE USER IF NOT EXISTS 'analyst'@'%' IDENTIFIED BY 'PracticeOnly#456';
SELECT User, Host FROM mysql.user;

ALTER USER 'clerk'@'localhost' IDENTIFIED BY 'ReplaceThis#789';
-- Optional cleanup:
-- DROP USER IF EXISTS 'analyst'@'%';

CREATE ROLE IF NOT EXISTS 'reader', 'data_entry', 'course_admin';
GRANT SELECT ON college.* TO 'reader';
GRANT SELECT, INSERT, UPDATE ON college.* TO 'data_entry';
GRANT ALL PRIVILEGES ON college.* TO 'course_admin';
GRANT SELECT (Rollno, Name) ON college.STUDENT TO 'reader';

GRANT 'data_entry' TO 'clerk'@'localhost';
SET DEFAULT ROLE ALL TO 'clerk'@'localhost';
SHOW GRANTS FOR 'clerk'@'localhost' USING 'data_entry';

-- Revoke examples; execute separately when demonstrating revocation:
-- REVOKE UPDATE ON college.* FROM 'data_entry';
-- REVOKE 'data_entry' FROM 'clerk'@'localhost';
-- REVOKE ALL PRIVILEGES, GRANT OPTION FROM 'course_admin';
-- DROP ROLE IF EXISTS 'course_admin';

CREATE INDEX idx_student_name ON STUDENT(Name);
CREATE INDEX idx_course_type ON COURSE(Coursetype);
CREATE INDEX idx_adm_sid_date ON ADMISSION(SID, Dateofadmission);
-- Cname already has a UNIQUE constraint, which creates an index in MySQL.
SHOW INDEX FROM STUDENT;
EXPLAIN SELECT * FROM STUDENT WHERE Name = 'Ankit Sharma';
-- DROP INDEX idx_student_name ON STUDENT;
