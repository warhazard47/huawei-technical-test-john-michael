# Huawei Technical Test — Dev

This repo contains solutions for the three tasks in the technical test:

1. **Backend Development** — `backend/`
2. **Automation Testing** — `cron/`
3. **Data Processing** — `sql/`

---

## 1. Backend (Node.js + Express)

### Setup
```bash
cd backend
npm install
npm start
```
Server runs on `http://localhost:3000`.

### Endpoints
| Method | Endpoint          | Description                          |
|--------|-------------------|---------------------------------------|
| POST   | `/api/form`       | Save form data (JSON body) in memory  |
| GET    | `/api/form`       | Return all saved records              |
| GET    | `/api/form/:id`   | Return a single record by id          |
| DELETE | `/api/form/:id`   | Remove a record by id                 |

### Test it
- Open `backend/public/index.html` in a browser (simple test form), **or**
- Use curl:
```bash
curl -X POST http://localhost:3000/api/form \
  -H "Content-Type: application/json" \
  -d '{"name":"Budi","email":"budi@example.com"}'

curl http://localhost:3000/api/form
```

Data is stored in-memory (a JS array), so it resets when the server restarts. This satisfies the "simple storage" requirement in the task.

---

## 2. Automation Testing (Cron Jobs)

Located in `cron/`:

- **`collect_data.sh`** — collects data from a target resource and saves it to
  `/home/cron/cron_{MMDDYYYY}_{HH.MM}.csv` (e.g. `cron_12192024_15.00.csv`).
  Replace `SOURCE_URL` inside the script with the real endpoint/resource to collect from.
- **`cleanup_data.sh`** — deletes any `.csv` file in `/home/cron` older than 30 days.
- **`crontab.txt`** — schedule definitions.

### Setup on the server
```bash
mkdir -p /home/cron/scripts
cp collect_data.sh cleanup_data.sh /home/cron/scripts/
chmod +x /home/cron/scripts/*.sh

crontab crontab.txt
crontab -l   # verify installation
```

This schedules:
- Data collection at **08:00, 12:00, 15:00 WIB** daily
- Cleanup at **00:30 WIB** daily (removes files older than 30 days)

Logs are written to `/home/cron/collect.log` and `/home/cron/cleanup.log` for verification.

---

## 3. Data Processing (SQL)

Two versions are provided:
- `sql/data_processing.sql` — MySQL syntax
- `sql/data_processing_sqlite.sql` — SQLite syntax (use this one with DBeaver + SQLite, no server install needed)

Contains, in order:
1. Table creation + seed data matching the given table
2. `INSERT` — add employee Albert (Engineer, joined 24-Jan-2024, 2.5 yrs exp, $50 salary)
3. `UPDATE` — set salary to $85 for all Engineers
4. `SELECT SUM(...)` — total salary expense for employees active during 2021
5. `SELECT ... ORDER BY ... LIMIT 3` — top 3 employees by years of experience
6. Subquery — Engineers with experience ≤ 3 years

### Run it (MySQL example)
```bash
mysql -u root -p < sql/data_processing.sql
```
(Works with minor syntax tweaks on PostgreSQL/SQL Server too — `AUTO_INCREMENT` → `SERIAL`/`IDENTITY`.)

### Run it (SQLite + DBeaver)
1. In DBeaver, create a new **SQLite** connection and pick/create a `.db` file.
2. Open a SQL Editor on that connection.
3. Paste the contents of `sql/data_processing_sqlite.sql`.
4. Run the whole script (Alt+X).

Both scripts start with `DROP TABLE IF EXISTS employees;` so they can be safely re-run
without creating duplicate data.

---

## Notes / Assumptions
- Backend uses in-memory storage per the task wording ("penyimpanan data sederhana ... array"); no external DB is required.
- Cron script assumes the server timezone is set to WIB (Asia/Jakarta) or uses the `TZ=Asia/Jakarta` cron variable.
- SQL "total salary in 2021" is interpreted as employees who were actively employed at some point during 2021 (joined before/at end of 2021, and not released before 2021 started).
