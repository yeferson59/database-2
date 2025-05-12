DROP TABLE IF EXISTS treatment CASCADE;

DROP TABLE IF EXISTS appointment CASCADE;

DROP TABLE IF EXISTS patient CASCADE;

DROP TABLE IF EXISTS doctor CASCADE;

DROP TABLE IF EXISTS specialty CASCADE;

CREATE TABLE specialty (
    spe_id SERIAL PRIMARY KEY,
    name TEXT NOT NULL UNIQUE
);

CREATE TABLE doctor (
    doc_id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    surname TEXT NOT NULL,
    phone TEXT,
    email TEXT,
    spe_id INTEGER NOT NULL REFERENCES specialty (spe_id)
);

CREATE TABLE patient (
    pat_id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    surname TEXT NOT NULL,
    birth_date DATE NOT NULL,
    gender CHAR(1),
    phone TEXT,
    address TEXT
);

CREATE TABLE appointment (
    app_id SERIAL PRIMARY KEY,
    date DATE NOT NULL,
    time TIME NOT NULL,
    reason TEXT,
    pat_id INTEGER NOT NULL REFERENCES patient (pat_id),
    doc_id INTEGER NOT NULL REFERENCES doctor (doc_id)
);

CREATE TABLE treatment (
    tre_id SERIAL PRIMARY KEY,
    description TEXT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE,
    app_id INTEGER NOT NULL REFERENCES appointment (app_id)
);
