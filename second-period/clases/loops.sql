CREATE OR REPLACE PROCEDURE see_nacionality(user_id integer) as $$
DECLARE
	reg_users users%ROWTYPE;
BEGIN
  SELECT * INTO reg_users FROM users WHERE uid = user_id;
  CASE reg_users.country
    WHEN 'Colombia' THEN
      RAISE NOTICE 'Es Colombiano';
    WHEN 'Ecuador' THEN
      RAISE NOTICE 'Es Ecuatoriano';
    WHEN 'Peru' THEN
      RAISE NOTICE 'Es Peruano';
    ELSE
      RAISE NOTICE 'Es desconocida la nacionalidad';
  END CASE;
END
$$ LANGUAGE plpgsql;

CALL see_nacionality(2);

CREATE OR REPLACE PROCEDURE ejemplo_loop(p_limite int) as $$
DECLARE
  v_cont integer := 0;
BEGIN
  LOOP
    v_cont := v_cont + 1;
    RAISE NOTICE 'El valor del contador es: %', v_cont;
    IF ( v_cont >= p_limite ) then
      RAISE NOTICE 'Se va a finalizar';
      EXIT;
    END IF;
  END LOOP;
  RAISE NOTICE 'ha finalizado el loop';
END
$$ LANGUAGE plpgsql;


CALL ejemplo_loop(5);

CREATE OR REPLACE PROCEDURE ejemplo_loop2(p_limite int) as $$
DECLARE
  v_cont integer := 0;
BEGIN
  WHILE ( v_cont >= p_limite ) LOOP
    v_cont := v_cont + 1;
    RAISE NOTICE 'El valor del contador es: %', v_cont;
  END LOOP;

  RAISE NOTICE 'ha finalizado el loop';
END
$$ LANGUAGE plpgsql;


CALL ejemplo_loop2(5);

CREATE OR REPLACE PROCEDURE ejemplo_loop3(p_limite int) as $$
DECLARE
  v_cont integer;
BEGIN
  FOR v_cont IN 1..p_limite LOOP
    RAISE NOTICE 'El valor del contador es: %', v_cont;
  END LOOP;

  RAISE NOTICE 'ha finalizado el loop';
END
$$ LANGUAGE plpgsql;

CALL ejemplo_loop3(5);

CREATE OR REPLACE PROCEDURE ejemplo_loop3(p_limite int) as $$
DECLARE
  v_cont integer;
BEGIN
  FOR _ IN 1..p_limite LOOP
    RAISE NOTICE 'El valor del contador es: %', 1;
  END LOOP;

  RAISE NOTICE 'ha finalizado el loop';
END
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE ejemplo_foreach(p_array int[]) as $$
DECLARE
  v_indice int;
  v_contador int := 0;
  v_suma int := 0;
BEGIN
  FOREACH v_indice in array p_array LOOP
  	v_contador := v_contador + 1;
  	RAISE NOTICE 'El valor de contador es %', v_contador;
  	v_suma := v_suma + v_indice;
  	RAISE NOTICE 'La suma es: %', v_suma;
  END LOOP;
  RAISE NOTICE 'ha finalizado';
END
$$ LANGUAGE plpgsql;

CALL ejemplo_foreach(array[1,2,3,4,5,6]);

--- como recorrer una consulta sin cursores

do
$$
  begin
  	insert into users(uid, name, email, register_date, country)
  	values
  	(2, 'pedro perez', 'pedro@example.com', '2025-05-14 12:12:52.864', 'Colombia')
  	expection
  		when UNIQUE_VIOLATION then
  			rollback;
  			RAISE NOTICE 'el correo ya existe';
  		when others then
  			ROLLBACK;
  			RAISE NOTICE 'Otro error diferente';
  end
$$ LANGUAGE plgsql;

-- NO_DATA_FOUND
-- TOO_MANY_ROWS
