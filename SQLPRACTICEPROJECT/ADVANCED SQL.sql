CREATE SCHEMA Employee;
USE employee;
SELECT * from emp_record_table;
SELECT * FROM data_science_team;
SELECT * FROM proj_table;

-- Q1
SELECT CONCAT(first_name, ' ', last_name) AS 'NAME' 
FROM emp_record_table WHERE DEPT = 'FINANCE';

-- Q2
SELECT * FROM emp_record_table WHERE DEPT = 'HEALTHCARE' OR DEPT = 'FINANCE';

-- Q3
SELECT ROLE, MIN(SALARY), MAX(SALARY) FROM emp_record_table GROUP BY ROLE;

-- Q4
SELECT count('FULL NAME'), CONCAT(supv.first_name, ' ', supv.last_name) AS 'FULL NAME' FROM emp_record_table emp left join emp_record_table supv ON emp.manager_id = supv.emp_id group by CONCAT(supv.first_name, ' ', supv.last_name);

-- Q5 --
SELECT emp_id, first_name, last_name, exp, rank()
OVER (ORDER BY exp DESC) AS 'Rank'
FROM emp_record_table;

-- Q6
CREATE VIEW Test AS SELECT emp_id, first_name, last_name, country, salary
FROM emp_record_table WHERE salary> 6000;
-- Showing the view
SELECT * FROM test;

-- q7 
SELECT * FROM emp_record_table WHERE salary > (SELECT AVG(salary) FROM emp_record_table);

-- Q8 Write a query to create a stored procedure to retrieve the details of 
-- the employees whose experience is more than three years. Name the procedure '3PlusExp'

DELIMITER //
CREATE PROCEDURE 3PlusExp() 
BEGIN 
SELECT * FROM emp_record_table WHERE EXP > 3;
END//
CALL 3PlusExp();

-- Q9 
DELIMITER $$
CREATE FUNCTION check_job_role(exp integer)
RETURNS VARCHAR(40)
DETERMINISTIC
BEGIN
DECLARE chck VARCHAR(40);
if exp < 2 THEN SET chck = 'JUNIOR DATA SCIENTIST';
ELSEIF exp>= 2 and exp< 5 THEN SET chck = 'ASSOCIATE DATA SCIENTIST';
ELSEIF exp>= 5 and exp < 10 THEN SET chck = 'SENIOR DATA SCIENTIST';
ELSEIF exp>= 10 and exp < 12 THEN SET chck = 'LEAD DATA SCIENTIST';
elseif exp>= 12 THEN SET chck = 'MANAGER';
end if; RETURN(chck);
END $$

select emp_id, first_name, last_name, role, check_job_role(exp)
FROM data_science_team WHERE ROLE != check_job_role(exp);

-- Q10
DELIMITER $$$
CREATE INDEX idx_first_name ON emp_record_table (first_name(50));
SHOW INDEX FROM emp_record_table;
END $$$
SELECT * FROM emp_record_table USE INDEX (idx_first_name) WHERE first_name = 'Eric'; -- Duration = 0.000014
SELECT * FROM emp_record_table WHERE first_name = 'Eric'; -- Duration time = 0.0030
END $$$

-- Q11

CREATE TABLE EmployeeArchives (
EMP_ID TEXT,
FIRST_NAME TEXT,
LAST_NAME TEXT,
GENDER TEXT,
ROLE TEXT,
DEPT TEXT,
EXP INT,
COUNTRY TEXT,
CONTINENT TEXT,
SALARY INT,
EMP_RATING INT,
MANAGER_ID TEXT,
PROJ_ID TEXT);

DELIMITER //
CREATE TRIGGER deleted_records
AFTER DELETE ON emp_record_table FOR EACH ROW
BEGIN 
INSERT INTO EmployeeArchives (emp_id,
 first_name,
 last_name,
 gender,
 role,
 dept,
 exp,
 country,
 continent,
 salary,
 emp_rating,
 manager_id,
 proj_id)
 VALUES (OLD.emp_id,
 OLD.first_name,
 OLD.last_name,
 OLD.gender,
 OLD.role,
 OLD.dept,
 OLD.exp,
 OLD.country,
 OLD.continent,
 OLD.salary,
 OLD.emp_rating,
 OLD.manager_id,
 OLD.proj_id);
 END;
 END //
SELECT * FROM EMP_RECORD_TABLE;
DELETE FROM emp_record_table WHERE EMP_ID = 'E010';
SELECT * FROM EmployeeArchives;

-- Q12

INSERT INTO emp_record_table (emp_id, first_name, last_name, gender, role, dept, exp, country, continent, salary, emp_rating, manager_id, proj_id)
VALUES ('E641', 'Michael', 'Jordan', 'M', 'SENIOR DATA SCIENTIST', 'HEALTHCARE', 2, 'ENGLAND', 'EUROPE', 
        (SELECT (MAX(salary)+1) FROM (SELECT * FROM emp_record_table) AS emp_record), 5, 'E101', 'P103');


-- PART 2
SELECT * FROM emp_record_table WHERE emp_id = 'E641';
DELETE FROM EMP_RECORD_TABLE WHERE emp_id = 'E641' AND SALARY = 16500; -- ACCIDENTLY ADDED WRONG SALARY SO TRYING TO DELETE BUT SAFE SQL MODE
DELETE FROM EMP_RECORD_TABLE WHERE emp_id = 'E641';
DELETE FROM EmployeeArchives WHERE emp_id = 'E641'; -- deleting from trigger table too

-- Q13


PREPARE statement
FROM 'SELECT * FROM emp_record_table WHERE GENDER = ?';
SET @GENDER = 'M';
EXECUTE statement USING @GENDER

PREPARE statement
FROM 'SELECT * FROM emp_record_table WHERE GENDER = ?';
SET @GENDER = 'F';
EXECUTE statement USING @GENDER




