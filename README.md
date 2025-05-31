# 📚 Projects Database 2

A comprehensive collection of practical SQL scripts for learning and mastering advanced relational database concepts with PostgreSQL. This repository covers real-world modeling, stored procedures, triggers, views, user management, security, and more—ideal for students, educators, and professionals.

---

## 🚀 What’s Inside?

- **Ready-to-use SQL scripts** for hands-on practice.
- **Advanced hospital and task management models**.
- **Stored procedures, triggers, and functions** for automation and business logic.
- **Security best practices** including Row-Level Security (RLS).
- **Practical exercises, workshops, and cursor usage**.
- **Examples for each major PostgreSQL feature**.

---

## 🗂️ Project Structure

```
second-period/
  ├── clases/
  │     ├── class_view_database.sql
  │     ├── configure_databse.sql
  │     ├── improve_configure_database.sql
  │     ├── loops.sql
  │     ├── process_stored.sql
  │     ├── tempory_tables.sql
  │     └── transactions.sql
  ├── exercises/
  │     ├── contacts.sql
  │     └── practice_examen.sql
  ├── projects/
  │     ├── hospital.sql
  │     └── improve_hospital.sql
  └── row-level.security.png

third-period/
  ├── clases/
  │     └── cursores.sql
  ├── exercises/
  │     └── cursores.sql
  └── workshop/
        └── june_2/
              ├── hospital_triggers.sql
              └── README.md
```

---

## 🧩 Main Topics & PostgreSQL Examples

### 1. Relational Modeling (Tables & Relationships)

**Example: Users and Tasks**

```sql
CREATE TABLE users (
    uid SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE tasks (
    tid SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    status VARCHAR(50) DEFAULT 'pending',
    uid INTEGER REFERENCES users(uid) ON DELETE CASCADE
);
```

---

### 2. Stored Procedures & Functions

**Example: Simple Calculation Function**

```sql
CREATE OR REPLACE FUNCTION add_and_subtract(a INT, b INT, OUT sum INT, OUT diff INT) AS $$
BEGIN
    sum := a + b;
    diff := a - b;
END
$$ LANGUAGE plpgsql;

SELECT * FROM add_and_subtract(10, 3);
```

---

### 3. Triggers

**Example: Audit Log Trigger**

```sql
CREATE TABLE audit_log (
    log_id SERIAL PRIMARY KEY,
    table_name TEXT,
    operation TEXT,
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE OR REPLACE FUNCTION log_update() RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO audit_log(table_name, operation)
    VALUES (TG_TABLE_NAME, TG_OP);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tasks_update_audit
AFTER UPDATE ON tasks
FOR EACH ROW EXECUTE FUNCTION log_update();
```

---

### 4. Views & Materialized Views

**Example: Pending Tasks View**

```sql
CREATE VIEW pending_tasks AS
SELECT t.title, u.name
FROM tasks t
JOIN users u ON t.uid = u.uid
WHERE t.status = 'pending';

-- Materialized view for users with pending tasks
CREATE MATERIALIZED VIEW users_with_pending_tasks AS
SELECT u.uid, u.name
FROM users u
JOIN tasks t ON t.uid = u.uid
WHERE t.status = 'pending';
```

---

### 5. Cursors

**Example: Explicit and Implicit Cursors**

```sql
-- Explicit cursor
DO $$
DECLARE
    rec_task tasks%ROWTYPE;
    cur CURSOR FOR SELECT * FROM tasks WHERE status = 'pending';
BEGIN
    OPEN cur;
    LOOP
        FETCH cur INTO rec_task;
        EXIT WHEN NOT FOUND;
        RAISE NOTICE 'Task: %, Status: %', rec_task.title, rec_task.status;
    END LOOP;
    CLOSE cur;
END
$$;

-- Implicit cursor
DO $$
DECLARE
    rec_task tasks%ROWTYPE;
BEGIN
    FOR rec_task IN SELECT * FROM tasks WHERE status = 'pending' LOOP
        RAISE NOTICE 'Task: %, Status: %', rec_task.title, rec_task.status;
    END LOOP;
END
$$;
```

---

### 6. Transactions

**Example: Atomic Insert with Tag Assignment**

```sql
BEGIN;

WITH new_task AS (
    INSERT INTO tasks (title, status, uid)
    VALUES ('Transactional Task', 'pending', 1)
    RETURNING tid
)
INSERT INTO task_tags (tid, tgid)
SELECT tid, 1 FROM new_task;

COMMIT;
```

---

### 7. Temporary Tables

**Example: Session and Transaction Temporary Tables**

```sql
-- Session-level temporary table
CREATE TEMPORARY TABLE temp_session (id INT, data TEXT) ON COMMIT PRESERVE ROWS;

-- Transaction-level temporary table
CREATE TEMPORARY TABLE temp_tx (id INT, data TEXT) ON COMMIT DELETE ROWS;

INSERT INTO temp_session VALUES (1, 'session data');
INSERT INTO temp_tx VALUES (2, 'transaction data');
```

---

### 8. Security & Row-Level Security (RLS)

**Example: Enabling RLS for a Table**

```sql
ALTER TABLE users ENABLE ROW LEVEL SECURITY;

CREATE POLICY user_isolation
  ON users
  USING (uid = current_setting('myapp.current_uid')::INTEGER);

ALTER TABLE users FORCE ROW LEVEL SECURITY;
```
> Note: Set the session variable `myapp.current_uid` to the current user's ID for RLS to work as intended.

---

## 🛠️ How to Use

1. **Prerequisites**
   - PostgreSQL 13+ installed
   - SQL client (psql, DBeaver, PgAdmin, etc.)

2. **Running Scripts**
   - Execute `.sql` files in your preferred order:
     ```sh
     psql -U your_user -d your_db -f second-period/clases/configure_databse.sql
     psql -U your_user -d your_db -f second-period/projects/improve_hospital.sql
     ```

3. **Experiment & Extend**
   - Modify scripts, try new queries, or combine features for your own exercises.

---

## 🌟 Best Practices

- Always use primary and foreign keys for referential integrity.
- Define unique constraints for fields like emails or usernames.
- Use stored procedures for reusable business logic.
- Apply roles and permissions—never use the `postgres` user for daily operations.
- Leverage views and materialized views for complex or frequent queries.
- Implement triggers for auditing if you need to track changes.
- Make regular backups of your databases.

---

## ❓ FAQ

**Can I use these scripts with MySQL or SQL Server?**  
Most scripts are designed for PostgreSQL and may require adjustments for other engines.

**How do I run a stored procedure?**  
Use the `CALL procedure_name(params);` statement.

**What if I get a permissions error?**  
Ensure your user has the necessary privileges on the schema and tables.

**Can I adapt these scripts for my own projects?**  
Absolutely! Feel free to modify and experiment.

---

## 🔗 Useful Resources

- [PostgreSQL Official Documentation](https://www.postgresql.org/docs/)
- [PL/pgSQL Manual](https://www.postgresql.org/docs/current/plpgsql.html)
- [W3Schools SQL Tutorial](https://www.w3schools.com/sql/)
- [DBDesigner ER Diagrams](https://www.dbdesigner.net/)
- [PostgreSQL Exercises](https://pgexercises.com/)

---

## 🤝 Contributing

Have an improvement, correction, or new exercise? Contributions are welcome! Open a Pull Request or suggest changes via Issues.

---

## 📝 License

This project is free to use for educational and personal purposes.

---

Happy learning and good luck on your journey to becoming a database expert! 🚀
