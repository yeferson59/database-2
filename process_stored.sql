CREATE OR REPLACE FUNCTION suma_resta(num int, num2 int, out suma int, out resta int) as $$
begin
	suma := num + num2;
	resta := num - num2;
end
$$ LANGUAGE PLPGSQL;


SELECT SUMA_RESTA(1, 8);

CREATE OR REPLACE FUNCTION concatenar(datos users) returns text as $$
begin
  return datos.uid || '-' || datos.name || '-' || datos.email;
end
$$ LANGUAGE PLPGSQL;

select concatenar(u.*) from users u;

CREATE OR REPLACE FUNCTION sendtable()
RETURNS TABLE(
  tid int,
  title varchar,
  summary text
) AS $$
BEGIN
  RETURN QUERY
  SELECT t.tid, t.title, t.summary
  FROM tasks t
  WHERE t.tid = 8;
END
$$ LANGUAGE plpgsql;


select sendtable();
select * from sendtable();

CREATE OR REPLACE FUNCTION sendtable(id int)
RETURNS TABLE(
  tid int,
  title varchar,
  summary text
) AS $$
BEGIN
  RETURN QUERY
  SELECT t.tid, t.title, t.summary
  FROM tasks t
  WHERE t.tid = id;
END
$$ LANGUAGE plpgsql;


select sendtable(7);
select * from sendtable(7);

CREATE OR REPLACE FUNCTION imprimir_valor(p_valor int)
RETURNS int AS $$
BEGIN
    RAISE NOTICE 'El valor es: %', p_valor;
  	return valor;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE PROCEDURE view_user(
  p_user_id integer
)
AS $$
DECLARE
  v_reguser users%ROWTYPE;
BEGIN
  SELECT * INTO v_reguser FROM users WHERE uid = p_user_id;

  IF v_reguser.uid IS NULL THEN
    RAISE NOTICE 'Usuario no encontrado';
    RETURN;
  END IF;

  RAISE NOTICE 'Usuario seleccionado: %', v_reguser.name;

  IF v_reguser.country = 'Colombia' THEN
    RAISE NOTICE 'Es colombiano';
  ELSE
    RAISE NOTICE 'Otra nacionalidad';
  END IF;

  RAISE NOTICE 'Se registro en: %', v_reguser.register_date;
END
$$ LANGUAGE plpgsql;

CALL view_user(3);



--crea un procedimiento que permita listar las tareas con priodad dos,
-- si la tarea está pendiente enviar un mensaje que diga echele ganas,
-- si esta finalizada felicitar

CREATE OR REPLACE PROCEDURE listar_tareas() AS $$
  DECLARE
    t_task tasks%ROWTYPE;
BEGIN
  FOR t_task IN SELECT * FROM tasks t JOIN priorities p ON t.pid = p.pid WHERE p.pid = 2 LOOP
    IF t_task.status = 'pendiente' THEN
      RAISE NOTICE 'echele ganas';
    ELSIF t_task.status = 'completada' THEN
      RAISE NOTICE 'felicitaciones';
    ELSE
      RAISE NOTICE 'siga así';
    END IF;
  END LOOP;
END
$$ LANGUAGE plpgsql;
