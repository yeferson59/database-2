-- Tabla de usuarios
CREATE TABLE usuarios (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de tareas
CREATE TABLE tareas (
    id SERIAL PRIMARY KEY,
    titulo VARCHAR(255) NOT NULL,
    descripcion TEXT,
    estado VARCHAR(50) DEFAULT 'pendiente', -- pendiente, en_progreso, completada
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_limite DATE,
    usuario_id INTEGER REFERENCES usuarios (id) ON DELETE CASCADE
);

-- Insertar un usuario
INSERT INTO
    usuarios (nombre, email)
VALUES
    ('Juan Pérez', 'juan@example.com');

-- Insertar una tarea
INSERT INTO
    tareas (
        titulo,
        descripcion,
        fecha_limite,
        usuario_id,
        estado,
        prioridad_id,
        fecha_creacion
    )
VALUES
    (
        'Terminar reporte mensual',
        'Preparar y enviar el reporte mensual de ventas.',
        '2025-05-20',
        1,
        'Pendiente',
        1,
        '2025-05-01'
    ),
    (
        'Revisar y responder correos electrónicos',
        'Revisar y responder a los correos electrónicos pendientes.',
        '2025-05-15',
        1,
        'Pendiente',
        2,
        '2025-05-05'
    ),
    (
        'Crear un nuevo informe de ventas',
        'Crear un nuevo informe de ventas para el equipo de ventas.',
        '2025-05-25',
        1,
        'Pendiente',
        3,
        '2025-05-10'
    ),
    (
        'Realizar una reunión con el equipo',
        'Realizar una reunión con el equipo para discutir los objetivos y metas.',
        '2025-05-22',
        1,
        'Pendiente',
        1,
        '2025-05-12'
    ),
    (
        'Investigar y analizar los resultados de ventas',
        'Investigar y analizar los resultados de ventas para identificar áreas de mejora.',
        '2025-05-28',
        1,
        'Pendiente',
        2,
        '2025-05-15'
    );

INSERT INTO
    tareas (
        titulo,
        estado,
        usuario_id,
        descripcion,
        prioridad_id,
        fecha_limite,
        fecha_creacion
    )
VALUES
    (
        'Tarea con prioridad alta',
        'Pendiente',
        1,
        'Descripción de la tarea',
        3,
        '2024-12-31',
        NOW ()
    );

INSERT INTO
    tareas (
        titulo,
        estado,
        usuario_id,
        descripcion,
        prioridad_id,
        fecha_limite,
        fecha_creacion
    )
VALUES
    (
        'Tarea con suficiente daño',
        'en_progreso',
        1,
        'Descripción de la tarea',
        2,
        '2024-12-31',
        NOW ()
    );

-- Tabla de prioridades
CREATE TABLE prioridades (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(20) UNIQUE NOT NULL
);

-- Insertar valores comunes
INSERT INTO
    prioridades (nombre)
VALUES
    ('baja'),
    ('media'),
    ('alta');

-- Modificar la tabla tareas para agregar columna de prioridad
ALTER TABLE tareas
ADD COLUMN prioridad_id INTEGER REFERENCES prioridades (id);

-- Tabla de etiquetas
CREATE TABLE etiquetas (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(50) UNIQUE NOT NULL
);

-- Tabla intermedia tareas-etiquetas (muchos a muchos)
CREATE TABLE tareas_etiquetas (
    tarea_id INTEGER REFERENCES tareas (id) ON DELETE CASCADE,
    etiqueta_id INTEGER REFERENCES etiquetas (id) ON DELETE CASCADE,
    PRIMARY KEY (tarea_id, etiqueta_id)
);

CREATE TABLE comentarios (
    id SERIAL PRIMARY KEY,
    contenido TEXT NOT NULL,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    tarea_id INTEGER REFERENCES tareas (id) ON DELETE CASCADE,
    usuario_id INTEGER REFERENCES usuarios (id) ON DELETE SET NULL
);

--- create a view for show three tasks
CREATE VIEW three_task as
SELECT
    TITULO,
    ESTADO
FROM
    TAREAS
LIMIT
    3;

CREATE materialized VIEW three_task_physy;

as
SELECT
    TITULO,
    ESTADO
FROM
    TAREAS;

select
    *
from
    three_task_physy;

select
    *
from
    three_task;

drop view two_high_task;

CREATE VIEW two_high_task as
SELECT
    TITULO,
    ESTADO
FROM
    TAREAS
WHERE
    prioridad_id = (
        SELECT
            id
        FROM
            prioridades
        where
            nombre = 'alta'
    )
LIMIT
    2;
