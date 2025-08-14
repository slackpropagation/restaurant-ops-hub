CREATE TABLE IF NOT EXISTS change_log(
  id INTEGER PRIMARY KEY, title TEXT, detail TEXT, category TEXT,
  effective_from TEXT, created_by TEXT, created_at TEXT
);
INSERT INTO change_log(title, detail, category, effective_from, created_by, created_at)
VALUES ('Add runner Fri‑Sat','Second runner 6‑9 pm','staffing', datetime('now'), 'Manager', datetime('now'));