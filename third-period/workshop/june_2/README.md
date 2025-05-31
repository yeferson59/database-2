Cuando trabajamos con bases de datos relacionales, muchas veces necesitamos realizar una acción específica en respuesta a un evento, como una inserción **(INSERT)**, una actualización **(UPDATE)** o una eliminación **(DELETE)**. Esto es precisamente lo que nos permite hacer un **trigger** en SQL.

# Qué es y cómo usar un trigger en SQL

Un **trigger** es un procedimiento almacenado en la base de datos que se ejecuta automáticamente cada vez que ocurre un evento especial en la base de datos. Por ejemplo, un desencadenante puede activarse cuando se inserta una fila en una tabla específica o cuando ciertas columnas de la tabla se actualizan.

Por lo general, estos eventos que desencadenan los triggers son cambios en las tablas mediante operaciones de inserción, eliminación y actualización de datos (insert, delete y update).

## ¿Cómo se utilizan los triggers y en qué ocasiones se usan?

Los triggers se utilizan principalmente para automatizar tareas y reforzar reglas de negocio dentro de la base de datos, sin necesidad de intervención manual o de depender exclusivamente del código de la aplicación. A continuación, se describen algunas de las situaciones más comunes en las que se emplean triggers:

- **Auditoría y registro de cambios:** Cuando es necesario llevar un historial de las modificaciones realizadas en una tabla, como registrar quién y cuándo se hizo un cambio en los datos. Por ejemplo, se puede crear un trigger que inserte automáticamente un registro en una tabla de auditoría cada vez que se actualiza o elimina una fila.

- **Validación de datos y reglas de negocio:** Los triggers pueden validar datos antes de que se inserten o actualicen en la base de datos, asegurando que cumplan ciertas condiciones o restricciones adicionales que no pueden ser implementadas fácilmente con restricciones estándar (CHECK, UNIQUE, etc.).

- **Mantenimiento de integridad referencial compleja:** Aunque las claves foráneas ayudan a mantener la integridad referencial, en ocasiones se requieren reglas más complejas que pueden ser implementadas mediante triggers, como la actualización o eliminación en cascada personalizada.

- **Cálculo automático de valores derivados:** Cuando se necesita calcular y almacenar automáticamente valores derivados a partir de otros datos, como actualizar un campo de suma total o un saldo después de una transacción.

- **Sincronización y replicación de datos:** Los triggers pueden ayudar a mantener sincronizadas varias tablas o bases de datos, replicando cambios automáticamente cuando se detecta una modificación.

- **Prevención de operaciones no permitidas:** Se pueden usar triggers para evitar ciertas acciones, como impedir la eliminación de registros críticos o restringir modificaciones bajo determinadas condiciones.

- **Notificaciones y acciones externas:** En algunos sistemas, los triggers pueden utilizarse para enviar notificaciones, correos electrónicos o ejecutar procedimientos externos cuando ocurre un evento específico en la base de datos.

En resumen, los triggers se utilizan cuando se requiere que la base de datos reaccione automáticamente a cambios en los datos, garantizando la consistencia, seguridad y cumplimiento de reglas de negocio, sin depender únicamente de la lógica de la aplicación.

## Hay dos clases de Triggers en SQL

**Triggers DDL (Data Definition Language)**:
Esta clase de Triggers se activa en eventos que modifican la estructura de la base de datos (como crear, modificar o eliminar una tabla) o en ciertos eventos relacionados con el servidor, como cambios de seguridad o actualización de eventos estadísticos.

**Triggers DML (Data Modification Language)**:
Esta es la clase más común de Triggers. En este caso, el evento de disparo es una declaración de modificación de datos; podría ser una declaración de inserción, actualización o eliminación en una tabla o vista.

## Los Triggers DML tienen diferentes tipos

FOR o AFTER [INSERT, UPDATE, DELETE]: Estos tipos de Triggers se ejecutan después de completar la instrucción de disparo (inserción, actualización o eliminación).

INSTEAD OF [INSERT, UPDATE, DELETE]: A diferencia del tipo FOR (AFTER), los Triggers INSTEAD OF se ejecutan en lugar de la instrucción de disparo. En otras palabras, este tipo de trigger reemplaza la instrucción de disparo. Son de gran utilidad en los casos en los que es necesario tener integridad referencial entre bases de datos.

## Ventajas de los Triggers

- Generar automáticamente algunos valores de columna derivados.
- Aplicar la integridad referencial.
- Registro de eventos y almacenamiento de información sobre el acceso a la tabla.
- Auditoría.
- Replicación sincrónica de tablas.
- Imponer autorizaciones de seguridad.
- Prevenir transacciones inválidas.

## Desventajas de los Triggers

- Pueden dificultar el mantenimiento y la depuración, ya que la lógica de negocio queda distribuida entre el código de la aplicación y la base de datos.
- Si no se gestionan correctamente, pueden afectar el rendimiento de la base de datos, ya que se ejecutan automáticamente en cada evento.
- La ejecución de triggers puede ser difícil de rastrear, lo que puede llevar a resultados inesperados o difíciles de diagnosticar.
- Pueden generar dependencias ocultas entre tablas y procesos.
- No todos los sistemas de gestión de bases de datos implementan triggers de la misma manera, lo que puede dificultar la portabilidad del código.

## Cómo usar un Trigger en SQL

La instrucción CREATE TRIGGER permite crear un nuevo trigger que se activa automáticamente cada vez que ocurre un evento, como INSERT, DELETE o UPDATE, en una tabla.

## La sintaxis de la instrucción CREATE TRIGGER:

```sql
CREATE  TRIGGER  [Nombre_Trigger] -- es el nombre definido por el usuario para el nuevo Trigger
ON  [Nombre_tabla] -- es la tabla a la que se aplica Trigger.
AFTER {[INSERT],[UPDATE],[DELETE]}
[NOT  FOR  REPLICATION] -- Esta opción indica a SQL Server que no active el disparador cuando la modificación de datos se realiza como parte de un proceso de replicación.
AS
{sql_statements}

```

La sintaxis anterior es genérica, pero sirve de base para la mayoría de bases de datos, como veremos a continuación.

## Ejemplo de Triggers en Oracle

Oracle también permite especificar el evento que activará el trigger y el momento de ejecución.

Un trigger es un bloque llamado PL/SQL (un lenguaje para desarrollar programas dentro del servidor de base de datos Oracle) almacenado en la base de datos Oracle y se ejecuta automáticamente cuando ocurre un evento de trigger.

En Oracle, puedes definir procedimientos que se ejecutan implícitamente cuando se emite una instrucción INSERT, UPDATE o DELETE en la tabla asociada. Estos procedimientos se llaman triggers de base de datos.

Existen seis instrucciones CREATE TRIGGER según sus puntos de disparo.

```sql
CREATE  [OR  REPLACE]  TRIGGER  trigger_name
{BEFORE  |  AFTER  }  triggering_event  ON  table_name
[FOR  EACH  ROW]
[FOLLOWS  |  PRECEDES  another_trigger]
[ENABLE  /  DISABLE  ]
[WHEN  condition]
DECLARE
declaration  statements
BEGIN
executable  statements
EXCEPTION
exception_handling  statements
END;
```
Si no incluyes las palabras clave OR REPLACE, recibirás un mensaje de error que indica que otro objeto está utilizando el nombre de tu trigger.

## Ejemplo de Triggers en MySQL

El Trigger en MySQL es un objeto de base de datos asociado a una tabla. Se activa cuando se realiza una acción definida en la tabla. El trigger se puede ejecutar cuando realizas una de las siguientes instrucciones de MySQL en la tabla: INSERT, UPDATE y DELETE, y se puede activar antes o después del evento.

```sql
delimiter //
CREATE TRIGGER nombre_Trigger
AFTER INSERT ON usuario_voto
FOR EACH ROW
BEGIN
-- Aquí se coloca la estructura de Trigger.
END //
delimiter ;
```

## Ejemplo de Triggers en PostgreSQL

En PostgreSQL, los triggers funcionan en conjunto con funciones escritas en PL/pgSQL u otros lenguajes soportados. Primero se crea la función que define la lógica del trigger y luego se asocia esa función a un evento en una tabla mediante la instrucción CREATE TRIGGER.

```sql
-- Paso 1: Crear la función del trigger
CREATE OR REPLACE FUNCTION ejemplo_trigger_funcion()
RETURNS TRIGGER AS $$
BEGIN
  -- Aquí va la lógica del trigger
  RAISE NOTICE 'Se ha activado el trigger en la tabla.';
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Paso 2: Crear el trigger y asociarlo a la tabla
CREATE TRIGGER ejemplo_trigger
AFTER INSERT ON nombre_tabla
FOR EACH ROW
EXECUTE FUNCTION ejemplo_trigger_funcion();
```

**Datos importantes sobre triggers en PostgreSQL:**
- Los triggers pueden ejecutarse BEFORE, AFTER o INSTEAD OF los eventos INSERT, UPDATE o DELETE.
- Se pueden definir triggers a nivel de fila (FOR EACH ROW) o a nivel de sentencia (FOR EACH STATEMENT).
- PostgreSQL permite múltiples triggers sobre el mismo evento y tabla.
- Es posible deshabilitar y habilitar triggers temporalmente con los comandos `ALTER TABLE ... DISABLE TRIGGER` y `ENABLE TRIGGER`.

## Comandos comunes

- Para eliminar un trigger, puedes usar el comando: DROP TRIGGER nombre_del_trigger;
- Para ver todos los triggers, puedes usar el comando: SHOW TRIGGERS;

## Conclusión

Los triggers son herramientas poderosas en las bases de datos relacionales que permiten automatizar tareas, reforzar reglas de negocio y mantener la integridad de los datos. Sin embargo, su uso debe ser cuidadoso, ya que pueden complicar el mantenimiento, afectar el rendimiento y dificultar la depuración de errores. Es recomendable documentar bien los triggers y evaluar si la lógica implementada en ellos no podría resolverse de manera más clara en la aplicación o mediante otras características de la base de datos. Utilizados correctamente, los triggers pueden aportar gran valor y robustez a los sistemas de información.
