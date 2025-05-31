-- Cursores
-- apuntadores solo lectura a un conjunto de datos
-- resulset Recordset
--
-- Permiten procesar la información 1 a1
--  Se declara con una consulta con parametro o sin parametros
-- se debe usar un conjunto de comandos
--

do
$$
DECLARE
    reg_user users%ROWTYPE;
    cur_user CURSOR FOR SELECT * FROM users WHERE country = 'Colombia';
BEGIN
    OPEN cur_user;
    FETCH cur_user INTO reg_user;
    RAISE NOTICE 'User: %, Country: %', reg_user.name, reg_user.country;
    CLOSE cur_user;
END;
$$ LANGUAGE plpgsql;


do
$$
DECLARE
    reg_user users%ROWTYPE;
    cur_user CURSOR FOR SELECT * FROM users WHERE country = 'Colombia';
BEGIN
    OPEN cur_user;
    LOOP
        FETCH cur_user INTO reg_user;
        EXIT WHEN NOT FOUND; -- salir del bucle si no hay más registros
        RAISE NOTICE 'User: %, Country: %', reg_user.name, reg_user.country;
    END LOOP;
    CLOSE cur_user;
END;
$$ LANGUAGE plpgsql;

-- Cursor Explicito

do
$$
DECLARE
    reg_user users%ROWTYPE;
    cur_user CURSOR FOR SELECT * FROM users WHERE country = 'Colombia';
BEGIN
    RAISE NOTICE 'Starting cursor processing';
    FOR reg_user IN cur_user LOOP
        RAISE NOTICE 'User: %, Country: %', reg_user.name, reg_user.country;
    END LOOP;
    RAISE NOTICE 'Cursor processing completed';
END;
$$ LANGUAGE plpgsql;


-- Cursor Implicito

do
$$
DECLARE
    reg_user users%ROWTYPE;
BEGIN
    RAISE NOTICE 'Starting implicit cursor processing';
    FOR reg_user IN SELECT * FROM users WHERE country = 'Colombia' LOOP
        RAISE NOTICE 'User: %, Country: %', reg_user.name, reg_user.country;
    END LOOP;
    RAISE NOTICE 'Implicit cursor processing completed';
END;
$$ LANGUAGE plpgsql;

-- Explicito con parametros

do
$$
DECLARE
    reg_user users%ROWTYPE;
    cur_user CURSOR (country_param TEXT) FOR SELECT * FROM users WHERE country = country_param;
    pais TEXT := 'Colombia';
BEGIN
    RAISE NOTICE 'Starting cursor processing with parameter';
    FOR reg_user IN cur_user(pais) LOOP
        RAISE NOTICE 'User: %, Country: %', reg_user.name, reg_user.country;
    END LOOP;
    RAISE NOTICE 'Cursor processing with parameter completed';
END;
$$ LANGUAGE plpgsql;
