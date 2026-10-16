/* ==========================================================================
   students_db_backup.sql
   CIS 4720 Database Management and SQL

   WHAT THIS FILE IS
   A starter database for in_class_lab7b. It builds a schema called
   students_db holding one table of students, plus a view. The lab PCs are
   wiped every night, so a script like this one is how you get a working
   database back in a few seconds instead of typing it all again. The file
   is the database. The server is disposable.

   WHAT IT BUILDS
     1. A schema called students_db
     2. One table, STUDENT, with six columns and a primary key
     3. Five rows of data
     4. One view, STUDENT_GPA, showing just the names and the grade averages

   BEFORE YOU RUN IT
   The schema has to exist before VS Code can connect to it, and VS Code
   will not create one for you. Step 4 of the lab has you create it at the
   command prompt first. Do that step before you open VS Code.

   HOW TO RUN IT
   Open it in VS Code with SQLTools connected to students_db, then run the
   whole file. Lab7b walks you through it.

   READ THIS BEFORE YOU RUN IT A SECOND TIME
   Run it once and everything works. Run it twice and you get errors,
   because the table already exists and the rows are already there. Step 10
   of the lab explains which parts to comment out and why.
   ========================================================================== */


-- ======================================================================
-- SECTION 1. The schema
-- A schema is the container that holds your tables. CREATE DATABASE makes
-- one, and USE tells the server which one the statements below apply to.
-- ======================================================================

-- Create the schema. IF NOT EXISTS means this line is safe to run twice,
-- and safe to run even though you already made it at the command prompt.
CREATE DATABASE IF NOT EXISTS students_db;

-- Switch into it. Everything below lands inside this schema.
USE students_db;


-- ======================================================================
-- SECTION 2. The table
-- Each column gets a data type that fits what it holds:
--   INT           whole numbers, used here for the id
--   VARCHAR(30)   text up to 30 characters
--   DECIMAL(3,2)  a number with 1 digit before the point and 2 after,
--                 which is exactly the shape of a grade average
--   DATE          a real date, stored as YYYY-MM-DD
-- NOT NULL means the column may never be left empty.
-- PRIMARY KEY means student_id must be unique and may never be empty.
-- ======================================================================

-- CREATE TABLE STUDENT (
--     student_id  INT          NOT NULL,
--     first_name  VARCHAR(30)  NOT NULL,
--     last_name   VARCHAR(30)  NOT NULL,
--     major       VARCHAR(40),
--     gpa         DECIMAL(3,2),
--     enrolled_on DATE,
--     PRIMARY KEY (student_id)
-- );


-- -- ======================================================================
-- -- SECTION 3. The data
-- -- Five students. Two enrolled in the same term, which is useful later when
-- -- you start filtering on a date.
-- -- ======================================================================

-- INSERT INTO STUDENT VALUES (1,'Ana',   'Reyes', 'CIS',              3.75,'2025-08-25');
-- INSERT INTO STUDENT VALUES (2,'Marcus','Bell',  'Computer Science', 3.20,'2025-08-25');
-- INSERT INTO STUDENT VALUES (3,'Priya', 'Nair',  'Mathematics',      3.90,'2026-01-12');
-- INSERT INTO STUDENT VALUES (4,'Devon', 'Rao',   'CIS',              2.85,'2026-01-12');
-- INSERT INTO STUDENT VALUES (5,'Elena', 'Vargas','Business',         3.45,'2026-08-24');


-- -- ======================================================================
-- -- SECTION 4. The view
-- -- A view is a stored SELECT statement you can query as if it were a table.
-- -- This one shows only the names and the grade average, so anyone using it
-- -- cannot reach the id, the major or the enrollment date.
-- -- ======================================================================

-- CREATE VIEW STUDENT_GPA AS
-- SELECT first_name, last_name, gpa
-- FROM STUDENT;


-- ======================================================================
-- SECTION 5. Checks
-- These only read. They are safe to run as many times as you like, so
-- leave them switched on even after the first run.
-- ======================================================================

-- All five rows, straight from the table.
SELECT * FROM STUDENT;

-- The view, highest grade average first. Three columns, not six.
SELECT * FROM STUDENT_GPA ORDER BY gpa DESC;

-- Should come back as 5 students and an average of 3.43.
SELECT COUNT(*) AS students, ROUND(AVG(gpa), 2) AS average_gpa FROM STUDENT;

-- STUDENT is a BASE TABLE and STUDENT_GPA is a VIEW. SHOW TABLES on its
-- own does not tell them apart, which is why this one says FULL.
SHOW FULL TABLES;


-- ######################################################################
-- YOUR LAB7B WORK STARTS BELOW THIS LINE
--
-- Add your Chapter 5 statements under the headings below, in order. Put a
-- comment above every statement saying what it does, in your own words.
-- The comments are graded.
-- ######################################################################


-- STEP 11. Section 5.1, look at your schema
-- The first statement shows the database name as an alias called my_schema. The second statement shows the tables in the schema, and whether they are base tables or views.
SELECT DATABASE() AS my_schema;
SHOW FULL TABLES;
-- STEP 12. Section 5.2, look at the data types
-- The statement shows the column names, data types, and other information about the STUDENT table.
DESCRIBE STUDENT;
-- STEP 13. Section 5.3, create a table by copying with a subquery
-- The statement creates a new table called STUDENT_COPY that contains the student_id, first_name, last_name, and gpa columns from the STUDENT table. The second statement selects all rows from the STUDENT_COPY table to display its contents. The third statement shows the CREATE TABLE statement for the STUDENT_COPY table, which includes its structure and column definitions.
CREATE TABLE STUDENT_COPY AS
SELECT student_id, first_name, last_name, gpa
FROM STUDENT;

SELECT * FROM STUDENT_COPY;
SHOW CREATE TABLE STUDENT_COPY;
-- STEP 14. Section 5.4, change the structure of the copy
-- adds a new honors column to the end
ALTER TABLE STUDENT_COPY ADD COLUMN honors CHAR(1);

-- changes the last_name column to allow up to 50 characters and not allow nulls
ALTER TABLE STUDENT_COPY MODIFY COLUMN last_name VARCHAR(50) NOT NULL;

--adds back the primary key constraint on student_id, which was lost when the table was copied
ALTER TABLE STUDENT_COPY ADD PRIMARY KEY (student_id);

-- shows the new structure of the STUDENT_COPY table, including the new honors column and the modified last_name column
DESCRIBE STUDENT_COPY;
--failed like it should have
INSERT INTO student_copy VALUES (1, 'Duplicate', 'Row', 0.00, NULL);

-- removes the honors column from the STUDENT_COPY table
ALTER TABLE STUDENT_COPY DROP COLUMN honors;
-- STEP 15. Section 5.5, insert, update and delete a row
-- inserts a new row into the STUDENT_COPY table with student_id 6, first_name 'Omar', last_name 'Faruqi', and gpa 3.10
INSERT INTO STUDENT_COPY VALUES (6, 'Omar', 'Faruqi', 3.10);
SELECT * FROM STUDENT_COPY WHERE student_id = 6;
-- updates the gpa of the row with student_id 6 in the STUDENT_COPY table to 3.35
UPDATE STUDENT_COPY SET gpa = 3.35 WHERE student_id = 6;
SELECT * FROM STUDENT_COPY WHERE student_id = 6;
--removes the student from the table
DELETE FROM STUDENT_COPY WHERE student_id = 6;
SELECT * FROM STUDENT_COPY WHERE student_id = 6;
-- STEP 16. Section 5.6, create a view and update through it
--creates a view called HIGH_GPA that selects the student_id, first_name, last_name, and gpa columns from the STUDENT_COPY table for students with a gpa greater than 3.50
CREATE VIEW HIGH_GPA AS
SELECT student_id, first_name, last_name, gpa
FROM student_copy
WHERE gpa > 3.50;

SELECT * FROM HIGH_GPA ORDER BY gpa DESC;

-- Checks GPA before making changes
SELECT student_id, gpa
FROM student_copy
WHERE student_id = 1;

--Updates the GPA using the HIGH_GPA view, setting the gpa of the student with student_id 1 to 3.95
UPDATE HIGH_GPA
SET gpa = 3.95
WHERE student_id = 1;

-- Checks GPA after making changes
SELECT student_id, gpa
FROM student_copy
WHERE student_id = 1;

--test code that is in the file meant to error
CREATE VIEW GPA_SUMMARY AS
SELECT COUNT(*) AS n, ROUND(AVG(gpa), 2) AS avg_gpa
FROM student_copy;

UPDATE GPA_SUMMARY SET avg_gpa = 4.00;

-- ======================================================================
-- PROJECT 7 STEP 6. Create the COURSE table
-- ======================================================================

-- Stores the available classes and gives each one a unique ID.
CREATE TABLE COURSE (
    course_id INT NOT NULL,
    course_code VARCHAR(10) NOT NULL,
    course_title VARCHAR(50) NOT NULL,
    credits INT,
    dept VARCHAR(30),
    PRIMARY KEY (course_id)
);

DESCRIBE COURSE;

-- ======================================================================
-- PROJECT 7 STEP 7. Add rows to COURSE
-- ==================================================================
--insert five courses into the COURSE table, each with a unique course_id, course_code, course_title, number of credits, and department

INSERT INTO COURSE VALUES (101, 'CIS4720', 'Database Management and SQL',3,'CIS');
INSERT INTO COURSE VALUES (102, 'CIS2000', 'Intro to Programming',3,'CIS');
INSERT INTO COURSE VALUES (103, 'MATH1600', 'Calculus I',4,'Mathematics');
INSERT INTO COURSE VALUES (104, 'BUS2100', 'Principles of Management',3,'Business');
INSERT INTO COURSE VALUES (105, 'CIS4850', 'Advanced Python',3,'CIS');

SELECT * FROM COURSE;
-- ======================================================================
-- PROJECT 7 STEP 8. Create the ENROLLMENT table
-- ==================================================================
--Creates a table called ENROLLMENT that stores the relationship between students and courses. 
--Each row represents a student enrolled in a course, with the student's ID, the course's ID, 
--the term of enrollment, and the grade received. The primary key is a composite key consisting of student_id 
--and course_id, ensuring that each student can only be enrolled in a specific course once. 
--The table also includes foreign key constraints to reference with the STUDENT and COURSE tables.

CREATE TABLE ENROLLMENT (
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    term VARCHAR(15),
    grade CHAR(1),
    PRIMARY KEY (student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES STUDENT(student_id),
    FOREIGN KEY (course_id) REFERENCES COURSE(course_id)
);

DESCRIBE ENROLLMENT;
-- ======================================================================
-- PROJECT 7 STEP 9. Add rows to ENROLLMENT
-- ==================================================================
-- this inserts eight rows into the ENROLLMENT table, representing the enrollment of students
-- in different courses during specific terms, along with their grades. Each row contains the student_id,
-- course_id, term, and grade for a specific enrollment record.

--eight pairings of student with a class
INSERT INTO ENROLLMENT VALUES (1, 101, 'Fall 2026', 'A');
INSERT INTO ENROLLMENT VALUES (1, 102, 'Fall 2026', 'B');
INSERT INTO ENROLLMENT VALUES (1, 103, 'Spring 2026', 'A');
INSERT INTO ENROLLMENT VALUES (2, 101, 'Fall 2026', 'B');
INSERT INTO ENROLLMENT VALUES (2, 104, 'Fall 2026', 'C');
INSERT INTO ENROLLMENT VALUES (3, 101, 'Fall 2026', 'A');
INSERT INTO ENROLLMENT VALUES (3, 103, 'Spring 2026', 'A');
INSERT INTO ENROLLMENT VALUES (4, 102, 'Fall 2026', 'C');

SELECT COUNT (*) AS enrollment_rows FROM ENROLLMENT;

-- this student_id doesn't exist. The student_id broke it
--INSERT INTO ENROLLMENT VALUES (99, 101, 'Fall 2026', 'A');

--this course_id doesn't exist. The course_id broke it
--INSERT INTO ENROLLMENT VALUES (1, 999, 'Fall 2026', 'A');

-- this is would be a duplicate. Duplicate entry for '1-101' for key enrollment.PRIMARY. The primary key broke it
--INSERT INTO ENROLLMENT VALUES (1, 101, 'sPRING 2027', 'B');

-- ======================================================================
-- PROJECT 7 STEP 10. Join one, all three tables together
-- ==================================================================
--this selects the name, course, title, term, and grade for each enrollment by joining the STUDENT,
--ENROLLMENT, and COURSE tables together based on their respective IDs. The results are ordered by 
--the student's last name and course code.

--every enrollment written out in full, with the student's name
--and the class title instead of the id numbers.

SELECT s.first_name, s.last_name, c.course_code, c.course_title, e.term, e.grade
FROM STUDENT s
JOIN ENROLLMENT e ON s.student_id = e.student_id
JOIN COURSE c ON e.course_id = c.course_id
ORDER BY s.last_name, c.course_code;

-- ======================================================================
-- PROJECT 7 STEP 11. Join two, an outer join that keeps the rows with no match
-- ==================================================================
--selects the student's first and last name, along with the count of courses they are taking. 
--It uses a LEFT JOIN to include all students, even those who are not enrolled in any courses.

--every student and how many classes they are taking, including the ones taking none

SELECT s.first_name, s.last_name, COUNT(e.course_id) AS courses_taken
FROM STUDENT s
LEFT JOIN ENROLLMENT e ON s.student_id = e.student_id
GROUP BY s.student_id, s.first_name, s.last_name
ORDER BY courses_taken DESC, s.last_name;

--classes with no students in them
SELECT c.course_code, c.course_title
FROM COURSE c
LEFT JOIN ENROLLMENT e ON c.course_id = e.course_id
WHERE e.student_id IS NULL;
-- ======================================================================
-- PROJECT 7 STEP 12. View one, STUDENT_SCHEDULE
-- ==================================================================
--created a table to view student, course, title, and term and grade so everything can be read

--the three table join saved under a name, so the full class schedule can be read
--without writing the join again

CREATE VIEW STUDENT_SCHEDULE AS
SELECT s.first_name, s.last_name, c.course_code, c.course_title, e.term, e.grade
FROM STUDENT s
JOIN ENROLLMENT e ON s.student_id = e.student_id
JOIN COURSE c ON e.course_id = c.course_id;

SELECT * FROM STUDENT_SCHEDULE; 
SELECT * FROM STUDENT_SCHEDULE WHERE last_name = 'Reyes';
SELECT * FROM STUDENT_SCHEDULE WHERE course_code = 'CIS4720';
-- ======================================================================
-- PROJECT 7 STEP 13. View two, COURSE_HEADCOUNT
-- ==================================================================
--how many students are in each class, counting the empty classes as zero instead of
-- leaving them out. 
--***I know the replace was not in the instructions but I messed up the alias and had to fix it. It was a good lesson*** 
CREATE OR REPLACE VIEW COURSE_HEADCOUNT AS
SELECT c.course_code, c.course_title, COUNT(e.student_id) AS students_enrolled
FROM COURSE c
LEFT JOIN ENROLLMENT e ON c.course_id = e.course_id
GROUP BY c.course_id, c.course_code, c.course_title;

SELECT * FROM COURSE_HEADCOUNT ORDER BY students_enrolled DESC;

SHOW FULL TABLES;