# Explanation Guide — What Each Thing Is and Why We Use It

Written for someone who hasn't coded hands-on since college. No prior setup assumed.

---

## PART 1: Backend (Node.js + Express)

### What is Node.js?
Normally, JavaScript only runs *inside a web browser*. Node.js is a program that lets
JavaScript run directly on your computer, like a regular application — so it can act
as a **server**: something that sits and waits for requests, then responds.

### What is Express?
Express is a helper library for Node.js that makes building a server much simpler.
Without it, you'd have to write a lot of low-level plumbing code yourself. Express gives
you simple commands like `app.get(...)` and `app.post(...)` to say "when someone visits
this URL, do this."

### Why an "API"?
An API (Application Programming Interface) is just an agreed-upon way for two programs
to talk to each other — in our case, a frontend (like a web form) and our backend server.
The frontend sends data, the backend receives it, stores it, and can hand it back later.

### How our backend works, step by step:
1. `server.js` starts a server and tells it to listen on port 3000 (`localhost:3000`).
2. We keep an **array** in memory (`let formData = []`) — think of this like a simple
   list/notebook that lives only while the server is running.
3. **POST `/api/form`** = "Hey server, here's some new data, please save it."
   The server adds it to the array and gives it back an ID.
4. **GET `/api/form`** = "Hey server, what have you got saved?"
   The server returns everything in the array.
5. Because it's just an array in memory (not a real database), the data disappears
   when you stop the server. That's fine — the task only asked for "simple storage."

### Why we tested it with `curl`
`curl` is a command-line tool that lets you send a fake "request" to a server, the same
way a real frontend would, without needing to build a whole webpage. It's the fastest way
to prove the API works.

---

## PART 2: Automation / Cron

### What is cron?
`cron` is a built-in Linux tool that runs commands automatically on a schedule
(like "every day at 8am"). It's been part of Unix/Linux systems for decades — almost
every real backend server uses it for scheduled jobs (backups, reports, cleanup, etc.).

### Why we needed WSL
Cron is a **Linux** tool. Windows doesn't have it natively. WSL (Windows Subsystem for
Linux) installs a real, lightweight Linux system *inside* Windows, so we get access to
real Linux tools like `cron`, `sudo`, and the Linux file system — without needing a
separate computer.

### What `sudo` means
`sudo` = "Super User DO." Some actions (like installing scripts into system folders,
or starting background services) need administrator-level permission. `sudo` temporarily
grants that, after you type your Linux password.

### How the automation works, step by step:
1. **`collect_data.sh`** is a *shell script* — a small text file full of commands that
   run one after another, like a recipe. This one builds a filename using today's date
   and time (e.g. `cron_07062026_15.00.csv`), then saves data into it.
2. **`cleanup_data.sh`** is another script that looks inside the folder, finds any file
   older than 30 days, and deletes it — keeping the folder from filling up forever.
3. **`crontab.txt`** is the *schedule*: it tells cron "run collect_data.sh at 8am, 12pm,
   and 3pm, and run cleanup_data.sh once a day."
4. We installed that schedule with `crontab crontab.txt` — this tells the Linux cron
   service "remember this schedule and run it automatically from now on."
5. To prove it works without waiting hours, we temporarily added a rule to run
   **every minute**, watched new files appear, then removed that test rule.

---

## PART 3: SQL / Database (SQLite + DBeaver)

### What is SQL?
SQL (Structured Query Language) is the standard language used to talk to databases —
to create tables, insert data, update it, delete it, and ask questions about it
("give me the top 3 by experience," etc.). Nearly every backend system uses some form
of SQL.

### What is SQLite?
There are many database systems (MySQL, PostgreSQL, SQL Server...). SQLite is the
simplest one — it's not a separate program running in the background, it's just a
**single file** on your computer that holds the whole database. That's why it was the
easiest choice for you: no server install, no passwords, just a `.db` file.

### What is DBeaver?
DBeaver is just a *viewer/editor* for databases — it doesn't hold data itself, it
connects to a database (in your case, the SQLite `.db` file) and gives you a friendly
screen to write SQL and see the results in a table, instead of typing everything blind
into a terminal.

### How the SQL script works, step by step:
1. `DROP TABLE IF EXISTS employees;` — wipes any old version of the table first, so
   re-running the script never creates duplicate data. (This is what caused your
   "3,250" bug earlier — we fixed it by adding this line.)
2. `CREATE TABLE employees (...)` — defines the *shape* of the data: what columns exist
   (name, position, salary, etc.) and what type each one is (text, number, date).
3. `INSERT INTO employees VALUES (...)` — adds the 6 starting employees from the task,
   then Albert as a 7th, per instruction #1.
4. `UPDATE employees SET salary = 85 WHERE position = 'Engineer'` — finds every row
   where position is "Engineer" and changes their salary.
5. `SELECT SUM(salary) ...` — asks the database to add up salary for employees who were
   active during 2021, using a date comparison.
6. `SELECT ... ORDER BY years_experience DESC LIMIT 3` — sorts everyone by experience,
   highest first, and only keeps the top 3.
7. The **subquery** (a `SELECT` inside another `SELECT`) — first finds the IDs of
   Engineers with ≤3 years experience, then uses that list to pull their full details.
   Subqueries let you "ask a question about the answer to another question."

---

## Big Picture: Why This Setup Mirrors Real Backend Work
- A real product almost always has: **(1)** an API server for the frontend to talk to,
  **(2)** scheduled background jobs (cron) for maintenance/data collection, and
  **(3)** a database for structured data and reporting. This test essentially asks you
  to demonstrate all three in miniature — which is exactly what real
  backend/DevOps/data roles do day-to-day, just at much larger scale.
