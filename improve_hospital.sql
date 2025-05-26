-- ==========================================
-- improve_hospital.sql
-- Mejora del modelo hospital: buenas prácticas, auditoría y seguridad
-- ==========================================

-- 1. Limpieza previa
DROP TABLE IF EXISTS treatment CASCADE;
DROP TABLE IF EXISTS appointment CASCADE;
DROP TABLE IF EXISTS patient CASCADE;
DROP TABLE IF EXISTS doctor CASCADE;
DROP TABLE IF EXISTS specialty CASCADE;
DROP TABLE IF EXISTS audit_log CASCADE;

-- 2. Creación de tablas normalizadas y mejoradas

CREATE TABLE specialty (
    spe_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE department (
    dept_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    location VARCHAR(100)
);

CREATE TABLE doctor (
    doc_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    surname VARCHAR(100) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    email VARCHAR(120) UNIQUE,
    spe_id INTEGER NOT NULL REFERENCES specialty (spe_id),
    dept_id INTEGER REFERENCES department (dept_id),
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE patient (
    pat_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    surname VARCHAR(100) NOT NULL,
    birth_date DATE NOT NULL,
    gender CHAR(1) CHECK (gender IN ('M','F','O')),
    phone VARCHAR(20) NOT NULL,
    address VARCHAR(255) NOT NULL,
    email VARCHAR(120) UNIQUE,
    blood_type VARCHAR(3),
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE insurance (
    ins_id SERIAL PRIMARY KEY,
    company VARCHAR(100) NOT NULL,
    policy_number VARCHAR(50) NOT NULL UNIQUE,
    pat_id INTEGER NOT NULL REFERENCES patient (pat_id) ON DELETE CASCADE
);

CREATE TABLE patient_emergency_contact (
    contact_id SERIAL PRIMARY KEY,
    pat_id INTEGER NOT NULL REFERENCES patient (pat_id) ON DELETE CASCADE,
    name VARCHAR(100) NOT NULL,
    relationship VARCHAR(50),
    phone VARCHAR(20) NOT NULL
);

CREATE TABLE appointment (
    app_id SERIAL PRIMARY KEY,
    date DATE NOT NULL,
    time TIME NOT NULL,
    reason VARCHAR(255) NOT NULL,
    pat_id INTEGER NOT NULL REFERENCES patient (pat_id) ON DELETE CASCADE,
    doc_id INTEGER NOT NULL REFERENCES doctor (doc_id) ON DELETE CASCADE,
    dept_id INTEGER REFERENCES department (dept_id),
    status VARCHAR(20) NOT NULL DEFAULT 'scheduled', -- scheduled, completed, cancelled
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE treatment (
    tre_id SERIAL PRIMARY KEY,
    description VARCHAR(500) NOT NULL,
    start_date TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    end_date TIMESTAMPTZ DEFAULT NULL,
    app_id INTEGER NOT NULL REFERENCES appointment (app_id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Historial clínico
CREATE TABLE clinical_history (
    history_id SERIAL PRIMARY KEY,
    pat_id INTEGER NOT NULL REFERENCES patient (pat_id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    notes TEXT
);

CREATE TABLE clinical_history_entry (
    entry_id SERIAL PRIMARY KEY,
    history_id INTEGER NOT NULL REFERENCES clinical_history (history_id) ON DELETE CASCADE,
    entry_date TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    doctor_id INTEGER REFERENCES doctor (doc_id),
    diagnosis TEXT,
    treatment_plan TEXT,
    observations TEXT
);

-- Medicamentos y prescripciones
CREATE TABLE medication (
    med_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT
);

CREATE TABLE prescription (
    presc_id SERIAL PRIMARY KEY,
    entry_id INTEGER NOT NULL REFERENCES clinical_history_entry (entry_id) ON DELETE CASCADE,
    med_id INTEGER NOT NULL REFERENCES medication (med_id),
    dosage VARCHAR(100) NOT NULL,
    frequency VARCHAR(100) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE
);

-- Habitaciones y hospitalización
CREATE TABLE room (
    room_id SERIAL PRIMARY KEY,
    room_number VARCHAR(10) NOT NULL UNIQUE,
    dept_id INTEGER REFERENCES department (dept_id),
    type VARCHAR(50) -- Ej: UCI, General, Privada
);

CREATE TABLE hospitalization (
    hosp_id SERIAL PRIMARY KEY,
    pat_id INTEGER NOT NULL REFERENCES patient (pat_id) ON DELETE CASCADE,
    room_id INTEGER REFERENCES room (room_id),
    admission_date TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    discharge_date TIMESTAMPTZ,
    reason TEXT
);

-- 3. Tabla de auditoría para cambios críticos
CREATE TABLE audit_log (
    log_id SERIAL PRIMARY KEY,
    table_name VARCHAR(50) NOT NULL,
    operation VARCHAR(10) NOT NULL, -- INSERT, UPDATE, DELETE
    record_id INTEGER NOT NULL,
    changed_by VARCHAR(50) DEFAULT current_user,
    changed_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    old_data JSONB,
    new_data JSONB
);

-- 4. Función y triggers de auditoría
CREATE OR REPLACE FUNCTION audit_changes() RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'UPDATE' THEN
        INSERT INTO audit_log(table_name, operation, record_id, changed_by, old_data, new_data)
        VALUES (TG_TABLE_NAME, TG_OP, NEW.*::jsonb->>'id', current_user, to_jsonb(OLD), to_jsonb(NEW));
    ELSIF TG_OP = 'DELETE' THEN
        INSERT INTO audit_log(table_name, operation, record_id, changed_by, old_data)
        VALUES (TG_TABLE_NAME, TG_OP, OLD.*::jsonb->>'id', current_user, to_jsonb(OLD));
    ELSIF TG_OP = 'INSERT' THEN
        INSERT INTO audit_log(table_name, operation, record_id, changed_by, new_data)
        VALUES (TG_TABLE_NAME, TG_OP, NEW.*::jsonb->>'id', current_user, to_jsonb(NEW));
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Triggers para tablas principales
CREATE TRIGGER audit_doctor
AFTER INSERT OR UPDATE OR DELETE ON doctor
FOR EACH ROW EXECUTE FUNCTION audit_changes();

CREATE TRIGGER audit_patient
AFTER INSERT OR UPDATE OR DELETE ON patient
FOR EACH ROW EXECUTE FUNCTION audit_changes();

CREATE TRIGGER audit_appointment
AFTER INSERT OR UPDATE OR DELETE ON appointment
FOR EACH ROW EXECUTE FUNCTION audit_changes();

CREATE TRIGGER audit_treatment
AFTER INSERT OR UPDATE OR DELETE ON treatment
FOR EACH ROW EXECUTE FUNCTION audit_changes();

-- 5. Trigger para actualizar automáticamente updated_at
CREATE OR REPLACE FUNCTION set_updated_at() RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER set_updated_at_doctor
BEFORE UPDATE ON doctor
FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER set_updated_at_patient
BEFORE UPDATE ON patient
FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER set_updated_at_appointment
BEFORE UPDATE ON appointment
FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER set_updated_at_treatment
BEFORE UPDATE ON treatment
FOR EACH ROW EXECUTE FUNCTION set_updated_at();

-- 6. Seguridad: usuarios y permisos mínimos
DO $$
BEGIN
    IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'hospital_app') THEN
        CREATE ROLE hospital_app LOGIN PASSWORD 'StrongPassword123!';
    END IF;
END$$;

GRANT CONNECT ON DATABASE current_database() TO hospital_app;
GRANT USAGE ON SCHEMA public TO hospital_app;
GRANT SELECT, INSERT, UPDATE ON doctor, patient, appointment, treatment TO hospital_app;
GRANT SELECT ON specialty TO hospital_app;

-- 7. Índices recomendados
CREATE INDEX idx_appointment_pat_id ON appointment(pat_id);
CREATE INDEX idx_appointment_doc_id ON appointment(doc_id);
CREATE INDEX idx_treatment_app_id ON treatment(app_id);

-- 8. Ejemplo de inserción segura
INSERT INTO specialty (name) VALUES ('Cardiología'), ('Pediatría'), ('Neurología') ON CONFLICT DO NOTHING;

-- 9. Vista útil: próximas citas de un paciente
CREATE OR REPLACE VIEW upcoming_appointments AS
SELECT
    a.app_id,
    p.name AS patient_name,
    d.name AS doctor_name,
    a.date,
    a.time,
    a.status
FROM appointment a
JOIN patient p ON a.pat_id = p.pat_id
JOIN doctor d ON a.doc_id = d.doc_id
WHERE a.date >= CURRENT_DATE
ORDER BY a.date, a.time;

-- ==========================================
-- Procedimientos Almacenados y Funciones Útiles
-- ==========================================

-- 1. Agregar una entrada al historial clínico de un paciente
CREATE OR REPLACE PROCEDURE add_clinical_history_entry(
    p_pat_id INTEGER,
    p_doctor_id INTEGER,
    p_diagnosis TEXT,
    p_treatment_plan TEXT,
    p_observations TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_history_id INTEGER;
BEGIN
    -- Buscar o crear historial clínico para el paciente
    SELECT history_id INTO v_history_id FROM clinical_history WHERE pat_id = p_pat_id;
    IF v_history_id IS NULL THEN
        INSERT INTO clinical_history (pat_id) VALUES (p_pat_id) RETURNING history_id INTO v_history_id;
    END IF;

    -- Insertar nueva entrada
    INSERT INTO clinical_history_entry (history_id, doctor_id, diagnosis, treatment_plan, observations)
    VALUES (v_history_id, p_doctor_id, p_diagnosis, p_treatment_plan, p_observations);
END;
$$;

-- 2. Registrar hospitalización de un paciente
CREATE OR REPLACE PROCEDURE admit_patient(
    p_pat_id INTEGER,
    p_room_id INTEGER,
    p_reason TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO hospitalization (pat_id, room_id, reason)
    VALUES (p_pat_id, p_room_id, p_reason);
END;
$$;

-- 3. Dar de alta a un paciente hospitalizado
CREATE OR REPLACE PROCEDURE discharge_patient(
    p_hosp_id INTEGER
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE hospitalization
    SET discharge_date = CURRENT_TIMESTAMP
    WHERE hosp_id = p_hosp_id AND discharge_date IS NULL;
END;
$$;

-- 4. Prescribir medicamento a una entrada de historial clínico
CREATE OR REPLACE PROCEDURE prescribe_medication(
    p_entry_id INTEGER,
    p_med_id INTEGER,
    p_dosage VARCHAR,
    p_frequency VARCHAR,
    p_start_date DATE,
    p_end_date DATE DEFAULT NULL
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO prescription (entry_id, med_id, dosage, frequency, start_date, end_date)
    VALUES (p_entry_id, p_med_id, p_dosage, p_frequency, p_start_date, p_end_date);
END;
$$;

-- 5. Función: obtener resumen de historial clínico de un paciente
CREATE OR REPLACE FUNCTION resumen_historial_clinico(p_pat_id INTEGER)
RETURNS TABLE(
    entry_date TIMESTAMPTZ,
    doctor VARCHAR,
    diagnosis TEXT,
    treatment_plan TEXT
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        che.entry_date,
        d.name,
        che.diagnosis,
        che.treatment_plan
    FROM clinical_history ch
    JOIN clinical_history_entry che ON ch.history_id = che.history_id
    LEFT JOIN doctor d ON che.doctor_id = d.doc_id
    WHERE ch.pat_id = p_pat_id
    ORDER BY che.entry_date DESC;
END;
$$ LANGUAGE plpgsql;

-- 6. Trigger: registrar automáticamente una entrada en el historial clínico al crear una hospitalización
CREATE OR REPLACE FUNCTION auto_history_entry_on_admit()
RETURNS TRIGGER AS $$
DECLARE
    v_history_id INTEGER;
BEGIN
    -- Buscar o crear historial clínico
    SELECT history_id INTO v_history_id FROM clinical_history WHERE pat_id = NEW.pat_id;
    IF v_history_id IS NULL THEN
        INSERT INTO clinical_history (pat_id) VALUES (NEW.pat_id) RETURNING history_id INTO v_history_id;
    END IF;
    -- Insertar entrada
    INSERT INTO clinical_history_entry (history_id, entry_date, diagnosis, observations)
    VALUES (v_history_id, NEW.admission_date, 'Ingreso hospitalario', NEW.reason);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_auto_history_entry_on_admit
AFTER INSERT ON hospitalization
FOR EACH ROW EXECUTE FUNCTION auto_history_entry_on_admit();

-- 7. Trigger: notificar (RAISE NOTICE) cuando se prescribe un medicamento peligroso (ejemplo: 'Warfarina')
CREATE OR REPLACE FUNCTION notify_dangerous_medication()
RETURNS TRIGGER AS $$
DECLARE
    v_med_name VARCHAR;
BEGIN
    SELECT name INTO v_med_name FROM medication WHERE med_id = NEW.med_id;
    IF v_med_name ILIKE '%warfarina%' THEN
        RAISE NOTICE '¡Atención! Se ha prescrito un medicamento de alto riesgo: %', v_med_name;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_notify_dangerous_medication
AFTER INSERT ON prescription
FOR EACH ROW EXECUTE FUNCTION notify_dangerous_medication();

-- ==========================================
-- Ejemplos de Consultas Avanzadas
-- ==========================================

-- 1. Obtener historial clínico completo de un paciente
SELECT
    p.name AS paciente,
    ch.history_id,
    che.entry_date,
    d.name AS doctor,
    che.diagnosis,
    che.treatment_plan,
    che.observations
FROM clinical_history ch
JOIN patient p ON ch.pat_id = p.pat_id
LEFT JOIN clinical_history_entry che ON ch.history_id = che.history_id
LEFT JOIN doctor d ON che.doctor_id = d.doc_id
WHERE p.pat_id = 1
ORDER BY che.entry_date DESC;

-- 2. Consultar pacientes hospitalizados actualmente y su habitación
SELECT
    p.name AS paciente,
    r.room_number,
    r.type AS tipo_habitacion,
    h.admission_date
FROM hospitalization h
JOIN patient p ON h.pat_id = p.pat_id
JOIN room r ON h.room_id = r.room_id
WHERE h.discharge_date IS NULL;

-- 3. Listar todas las prescripciones activas para un paciente
SELECT
    p.name AS paciente,
    m.name AS medicamento,
    pr.dosage,
    pr.frequency,
    pr.start_date,
    pr.end_date
FROM prescription pr
JOIN clinical_history_entry che ON pr.entry_id = che.entry_id
JOIN clinical_history ch ON che.history_id = ch.history_id
JOIN patient p ON ch.pat_id = p.pat_id
JOIN medication m ON pr.med_id = m.med_id
WHERE p.pat_id = 1 AND (pr.end_date IS NULL OR pr.end_date >= CURRENT_DATE);

-- 4. Consultar el número de citas por departamento en el último mes
SELECT
    d.name AS departamento,
    COUNT(a.app_id) AS total_citas
FROM appointment a
JOIN department d ON a.dept_id = d.dept_id
WHERE a.date >= CURRENT_DATE - INTERVAL '1 month'
GROUP BY d.name
ORDER BY total_citas DESC;

-- 5. Ver el historial de auditoría de cambios en la tabla patient
SELECT
    log_id,
    operation,
    changed_by,
    changed_at,
    old_data,
    new_data
FROM audit_log
WHERE table_name = 'patient'
ORDER BY changed_at DESC;

-- Fin del script de mejora hospitalaria
