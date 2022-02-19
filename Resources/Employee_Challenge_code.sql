---creating tables----
CREATE TABLE departments (
     dept_no VARCHAR(4) NOT NULL,
     dept_name VARCHAR(40) NOT NULL,
     PRIMARY KEY (dept_no),
     UNIQUE (dept_name)
);
CREATE TABLE employees(
	emp_no int NOT NULL,
	birth_date date NOT NULL,
	first_name varchar (40) NOT NULL,
	last_name varchar(40) NOT NULL,
	gender varchar NOT NULL,
	hire_date date NOT NULL,
	PRIMARY KEY (emp_no)
);

CREATE TABLE dept_manager (
	dept_no VARCHAR(4) NOT NULL,
    emp_no INT NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL,
FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
    PRIMARY KEY (emp_no, dept_no)
);
CREATE TABLE salaries (
  emp_no INT NOT NULL,
  salary INT NOT NULL,
  from_date DATE NOT NULL,
  to_date DATE NOT NULL,
  FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
  PRIMARY KEY (emp_no)
);
CREATE TABLE titles (
	emp_no INT NOT NULL,
	title VARCHAR(40) NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no)
);

CREATE TABLE dept_emp(
	emp_no int NOT NULL,
	dept_no Varchar NOT NULL,
	from_date DATE NOT NULL,
    to_date DATE NOT NULL,
FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
	PRIMARY KEY (emp_no, dept_no)
);

---retrieve data from employee
SELECT emp.emp_no,emp.first_name,emp.last_name, emp.birth_date
INTO retirement_info
FROM employees as emp
WHERE emp.birth_date BETWEEN '1952-01-01' AND '1955-12-31';
-----JOINING
SELECT DISTINCT ON (ri.emp_no) ri.emp_no,ri.first_name,ri.last_name,ri.birth_date, tit.title, tit.to_date, tit.from_date
INTO retire_withtitle_info
FROM retirement_info as ri
LEFT JOIN titles as tit  
ON ri.emp_no=tit.emp_no;
---exclude employyes who left
SELECT * 
INTO unique_title_info
FROM retire_withtitle_info AS ri
WHERE ri.to_date='9999-01-01'
ORDER BY ri.emp_no ASC, ri.to_date DESC;
---counting---
SELECT COUNT(rit.emp_no),rit.title 
FROM retire_withtitle_info AS rit
GROUP BY rit.title
ORDER BY COUNT(rit.emp_no) DESC;
---UNIQUE TITLE COUNTING
SELECT COUNT(uti.emp_no),uti.title 
INTO retiring_titles_info
FROM unique_title_info AS uti
GROUP BY uti.title
ORDER BY COUNT(uti.emp_no) DESC;

---- deleviry 2-----
SELECT DISTINCT ON (emp.emp_no) emp.emp_no,emp.first_name,emp.last_name, emp.birth_date,depem.to_date,depem.from_date,tit.title
INTO mentorship_info
FROM employees as emp
LEFT JOIN dept_emp as depem ON emp.emp_no=depem.emp_no
LEFT JOIN titles as tit ON tit.emp_no=depem.emp_no
WHERE depem.to_date='9999-01-01' AND emp.birth_date BETWEEN '1965-01-01' AND '1965-12-31'
ORDER BY emp.emp_no ASC;






