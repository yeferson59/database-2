-- Cree un procedimiento que permita crear una vista de
-- todas las tareas que tiene asociada una
-- categoría de tareas.

CREATE OR REPLACE PROCEDURE crear_vista_tareas_por_categoria(
  p_nombre_vista TEXT,
  p_tgid INTEGER
)
LANGUAGE plpgsql
AS $$
BEGIN
  EXECUTE format('
  CREATE VIEW %I AS
  SELECT t.*
  FROM tasks t
  JOIN task_tags tt ON t.tid = tt.tid
  WHERE tt.tgid = %L
  ', p_nombre_vista, p_tgid);
END;
$$;

CALL crear_vista_tareas_por_categoria('tareas_urgentes', 1);

-- Cree una vista materializada con usuarios que tengan tareas pendientes.

CREATE MATERIALIZED VIEW usuarios_con_tareas_pendientes AS
SELECT u.uid, u.name
FROM users u
JOIN tasks t ON t.uid = u.uid
WHERE t.status = 'pendiente';

SELECT name, COUNT(uid) As cantidad_tareas
FROM usuarios_con_tareas_pendientes
GROUP BY uid, name;

-- Cree una transacción que permita cerrar las tareas que ya ha expirado por fecha

-- BEGIN;
UPDATE tasks
SET status = 'cerrada'
WHERE limit_date < CURRENT_DATE
  AND status <> 'cerrada';
-- COMMIT;

--  Cree una transacción que permita clonar las tareas y sean asignadas a otro usuario.

CREATE OR REPLACE PROCEDURE clonar_tareas(
  usuario_origen INT,
  usuario_destino INT
)
LANGUAGE plpgsql
AS $$
DECLARE
  nueva_tarea tasks%ROWTYPE;
BEGIN
  FOR nueva_tarea IN SELECT * FROM tasks WHERE uid = usuario_origen LOOP
    INSERT INTO tasks (title, summary, status, created_date, limit_date, uid, pid)
    VALUES (nueva_tarea.title, nueva_tarea.summary, nueva_tarea.status, NOW(), nueva_tarea.limit_date, usuario_destino, nueva_tarea.pid);
  END LOOP;
END;
$$;


CALL clonar_tareas(3, 2);

-- Cree una tabla temporal con toda la información de las tareas.

CREATE TEMP TABLE temp_tasks AS
SELECT
    tid,
    title,
    created_date,
    limit_date,
    pid,
    uid,
    summary,
    status
FROM tasks;

--  Cree un procedimiento que permita llenar cualquier tabla en cualquier base de datos utilizando los ciclos.

CREATE OR REPLACE PROCEDURE llenar_tabla(
  _tabla text,
  _cantidad integer,
  _esquema text default 'public'
)
AS $$
DECLARE
  i integer := 1;
  column_names text;
  default_values text;
  max_uid integer;
BEGIN
  IF _tabla = 'tasks' THEN
    SELECT MAX(uid) INTO max_uid FROM users;
    IF max_uid IS NULL THEN
      INSERT INTO users (uid, name, email, country, register_date)
      VALUES (1, 'Default User', 'default@example.com', 'Default Country', now());
      max_uid := 1;
    END IF;

    WHILE i <= _cantidad LOOP
      EXECUTE format('INSERT INTO %I.%I (title, summary, status, pid, limit_date, created_date, uid)
                      VALUES (%L, %L, %L, 1, %L, now(), %L)',
                      _esquema, _tabla, 'Task ' || i, 'Summary ' || i, 'new', '2024-01-01', max_uid);
      i := i + 1;
    END LOOP;
  ELSE
    WHILE i <= _cantidad LOOP
      EXECUTE format('INSERT INTO %I.%I DEFAULT VALUES', _esquema, _tabla);
      i := i + 1;
    END LOOP;
  END IF;
END;
$$ LANGUAGE plpgsql;



-- Ejemplo de uso:
CALL llenar_tabla('tasks', 10);


-- Cree una función que devuelva el nombre de la persona junto con su tarea.

CREATE OR REPLACE FUNCTION obtener_nombre_y_tarea(p_uid INT, p_tid INT)
RETURNS TEXT
LANGUAGE plpgsql
AS $$
DECLARE
  v_resultado TEXT;
BEGIN
  SELECT CONCAT(u.name, ' - ', t.title)
  INTO v_resultado
  FROM tasks t
  JOIN users u ON t.uid = u.uid
  WHERE t.tid = p_tid AND u.uid = p_uid;

  IF v_resultado IS NULL THEN
    RAISE EXCEPTION 'Tarea no encontrada con ID: %', p_tid;
  END IF;

  RETURN v_resultado;
END;
$$;

SELECT obtener_nombre_y_tarea(0);

-- Cree un procedimiento que recorra todas las tareas y
-- concatena las etiquetas y la prioridad quedando
-- de la siguiente manera, puede utilizar
-- o modificar el ejercicio anterior para esto
-- #No - Nombre Completo - Tareas - Prioridad – Tags

CREATE OR REPLACE PROCEDURE tareas_con_detalles()
LANGUAGE plpgsql
AS $$
DECLARE
  rec RECORD;
BEGIN
  FOR rec IN
    SELECT t.tid, u.name AS usuario, t.title AS tarea, p.p_name AS prioridad,
           STRING_AGG(e.tg_name, ', ') AS etiquetas
    FROM tasks t
    JOIN users u ON t.uid = u.uid
    JOIN priorities p ON t.pid = p.pid
    LEFT JOIN task_tags te ON t.tid = te.tid
    LEFT JOIN tags e ON te.tgid = e.tgid
    GROUP BY t.tid, u.name, t.title, p.p_name
  LOOP
    RAISE NOTICE '#% - % - % - % - %', rec.tid, rec.usuario, rec.tarea, rec.prioridad, rec.etiquetas;
  END LOOP;
END;
$$;

CALL tareas_con_detalles();

-- Elabore un procedimiento que permita la construcción de vistas normales o materializadas, el
-- procedimiento debe permitir crear cualquiera de estos dos tipos de vista con cualquier tipo de
-- información. De un ejemplo de ejecución del procedimiento teniendo en cuenta el ejercicio todolist.
-- Utilizar CASE

CREATE OR REPLACE PROCEDURE crear_vista_tipo(
  p_tipo_vista TEXT, -- 'normal' o 'materializada'
  p_nombre_vista TEXT,
  p_tabla TEXT,
  p_condicion TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
  IF p_tipo_vista NOT IN ('normal', 'materializada') THEN
    RAISE EXCEPTION 'Tipo de vista inválido: %', p_tipo_vista;
  END IF;

  EXECUTE format('
    CREATE %s VIEW %I AS
    SELECT * FROM %I %s
  ',
  CASE p_tipo_vista
    WHEN 'normal' THEN ''
    WHEN 'materializada' THEN 'MATERIALIZED'
  END,
  p_nombre_vista,
  p_tabla,
  CASE WHEN p_condicion IS NULL OR p_condicion = '' THEN '' ELSE 'WHERE ' || p_condicion END
  );
END;
$$;


CALL crear_vista_tipo('normal', 'vista_tareas_pendiente', 'tasks', 'status = ''pendiente''');
CALL crear_vista_tipo('materializada', 'vista_tareas_urgentes', 'tasks', 'limit_date < CURRENT_DATE + INTERVAL ''1 day''');

-- Elabore un procedimiento que permita clonar cualquier tabla en una tabla temporal. Este procedimiento
-- servirá para cualquier tabla.

CREATE OR REPLACE PROCEDURE clonar_tabla(
    p_tabla_nombre text
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_sql text;
BEGIN
    v_sql := format('CREATE TEMP TABLE %s_temp AS SELECT * FROM %s', p_tabla_nombre, p_tabla_nombre);
    EXECUTE v_sql;
END;
$$;


CALL clonar_tabla('tasks');
