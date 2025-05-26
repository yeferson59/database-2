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

BEGIN;
UPDATE tasks
SET status = 'cerrada'
WHERE limit_date < CURRENT_DATE
  AND status <> 'cerrada';
COMMIT;
