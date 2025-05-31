DROP INDEX IF EXISTS index_users;
CREATE INDEX IF NOT EXISTS index_user_name ON users (name);

-- Transacción para insertar una tarea y asignarle una etiqueta
BEGIN;

-- Insertar la tarea y asignar la etiqueta usando WITH y RETURNING
WITH nueva_tarea AS (
    INSERT INTO tasks (
        title,
        summary,
        created_date,
        limit_date,
        uid,
        pid
    ) VALUES (
        'tarea de transaccion',
        'Es una tarea de transaccion',
        '2025-05-14 00:00:00',
        '2025-05-15',
        2,
        1
    )
    RETURNING tid
)
INSERT INTO task_tags (tid, tgid)
SELECT tid, 1 FROM nueva_tarea;

-- Verificar que la tarea se haya insertado correctamente
SELECT * FROM tasks WHERE title = 'tarea de transaccion';

COMMIT;

-- Transacción para transferir una tarea a otro usuario
BEGIN;

-- Transferir todas las tareas del usuario 2 al usuario 3 y mostrar las tareas transferidas
UPDATE tasks
SET uid = 3
WHERE uid = 2
RETURNING *;

COMMIT;

-- clonar una tarea incluyendo las etiquetas
-- Transacción para clonar una tarea incluyendo sus etiquetas
BEGIN;

-- 1. Insertar la nueva tarea y obtener su tid
WITH nueva_tarea AS (
    INSERT INTO tasks (
        title,
        summary,
        created_date,
        limit_date,
        uid,
        pid
    )
    SELECT
        title,
        summary,
        CURRENT_TIMESTAMP, -- Nueva fecha de creación
        limit_date,
        uid,
        pid
    FROM tasks
    WHERE tid = 1
    RETURNING tid
),
original_tags AS (
    SELECT tgid FROM task_tags WHERE tid = 1
)
-- 2. Asignar las etiquetas de la tarea original a la nueva tarea
INSERT INTO task_tags (tid, tgid)
SELECT nueva_tarea.tid, original_tags.tgid
FROM nueva_tarea, original_tags;

-- Verificar que la nueva tarea y sus etiquetas se hayan creado correctamente
SELECT * FROM tasks WHERE tid = (SELECT tid FROM nueva_tarea);
SELECT * FROM task_tags WHERE tid = (SELECT tid FROM nueva_tarea);

COMMIT;
