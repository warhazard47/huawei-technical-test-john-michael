CREATE TABLE IF NOT EXISTS employees (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    position VARCHAR(100) NOT NULL,
    join_date DATE NOT NULL,
    release_date DATE NULL,
    years_experience DECIMAL(4,1) NOT NULL,
    salary DECIMAL(10,2) NOT NULL
);

INSERT INTO employees (name, position, join_date, release_date, years_experience, salary) VALUES
('Jacky', 'Solution Architect', '2018-07-25', '2022-07-25', 8,  150),
('John',  'Assistant Manager',  '2016-02-02', '2021-02-02', 12, 155),
('Alano', 'Manager',            '2010-11-09', NULL,         14, 175),
('Aaron', 'Engineer',           '2021-08-16', '2022-08-16', 1,  80),
('Allen', 'Engineer',           '2024-06-06', NULL,         4,  75),
('Peter', 'Team Leader',        '2020-01-09', NULL,         3,  85);

INSERT INTO employees (name, position, join_date, years_experience, salary)
VALUES ('Albert', 'Engineer', '2024-01-24', 2.5, 50);

UPDATE employees
SET salary = 85
WHERE position = 'Engineer';

SELECT SUM(salary) AS total_salary_2021
FROM employees
WHERE join_date <= '2021-12-31'
  AND (release_date IS NULL OR release_date >= '2021-01-01');

SELECT name, position, years_experience
FROM employees
ORDER BY years_experience DESC
LIMIT 3;

SELECT name, position, years_experience
FROM employees
WHERE position = 'Engineer'
  AND id IN (
      SELECT id
      FROM employees
      WHERE position = 'Engineer'
        AND years_experience <= 3
  );
