-- 1. Crear una tabla de prueba simple
CREATE TABLE EMPLEADOS_TEST (
    employee_id NUMBER,
    first_name VARCHAR2(50),
    last_name VARCHAR2(50),
    hire_date DATE,
    manager_id NUMBER
);

-- 2. Insertar 3 empleados de ejemplo
INSERT INTO EMPLEADOS_TEST VALUES (1, 'Juan', 'Perez', SYSDATE, NULL);
INSERT INTO EMPLEADOS_TEST VALUES (2, 'Maria', 'Gomez', SYSDATE - 100, 1);
INSERT INTO EMPLEADOS_TEST VALUES (3, 'Carlos', 'Lopez', SYSDATE - 500, 1);

--
-- 1. Verificamos si ya existe (para evitar errores)
SELECT table_name FROM user_tables WHERE table_name = 'EMPLEADOS_PROYECTO';

-- 2. Creamos la tabla (si no existía, se creará)
-- Si te da error de "name is already used", es que ya existe y podemos saltar al paso 3
BEGIN
   EXECUTE IMMEDIATE 'CREATE TABLE EMPLEADOS_PROYECTO (
      employee_id NUMBER,
      first_name VARCHAR2(50),
      last_name VARCHAR2(50),
      hire_date DATE,
      manager_id NUMBER
   )';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -955 THEN RAISE; END IF;
END;
/

-- 3. Insertamos datos de prueba
INSERT INTO EMPLEADOS_PROYECTO VALUES (1, 'Juan', 'Perez', ADD_MONTHS(SYSDATE, -24), NULL);
INSERT INTO EMPLEADOS_PROYECTO VALUES (2, 'Maria', 'Gomez', SYSDATE, 1);
INSERT INTO EMPLEADOS_PROYECTO VALUES (3, 'Carlos', 'Lopez', ADD_MONTHS(SYSDATE, -60), 1);
COMMIT;

-- 4. Confirmamos que la tabla existe y tiene datos
SELECT * FROM EMPLEADOS_PROYECTO;
---


-- Vista de Jerarquía (usando tu tabla propia)
CREATE OR REPLACE VIEW v_jerarquia_empleados AS
SELECT 
    e.first_name || ' ' || e.last_name AS empleado,
    m.first_name || ' ' || m.last_name AS jefe_directo,
    mm.first_name || ' ' || mm.last_name AS jefe_del_jefe
FROM EMPLEADOS_PROYECTO e
LEFT JOIN EMPLEADOS_PROYECTO m ON e.manager_id = m.employee_id
LEFT JOIN EMPLEADOS_PROYECTO mm ON m.manager_id = mm.employee_id;
/

-- Vista de Empleados del Mes
CREATE OR REPLACE VIEW v_employees_of_the_month AS
SELECT 
    employee_id,
    first_name || ' ' || last_name AS full_name,
    FLOOR(MONTHS_BETWEEN(SYSDATE, hire_date) / 12) AS antiguedad_anios,
    hire_date
FROM EMPLEADOS_PROYECTO
WHERE EXTRACT(MONTH FROM hire_date) = EXTRACT(MONTH FROM SYSDATE);
/

-- Ejecución para evidencia 1
SELECT * FROM v_jerarquia_empleados;

-- Ejecución para evidencia 2
SELECT * FROM v_employees_of_the_month;

-----

-- Creamos las tablas necesarias en tu propio esquema
BEGIN
   EXECUTE IMMEDIATE 'CREATE TABLE ORDERS_TEST (order_id NUMBER, order_date DATE, customer_id NUMBER)';
   EXECUTE IMMEDIATE 'CREATE TABLE CUSTOMERS_TEST (customer_id NUMBER, cust_first_name VARCHAR2(50), cust_last_name VARCHAR2(50))';
   EXECUTE IMMEDIATE 'CREATE TABLE ORDER_ITEMS_TEST (line_item_id NUMBER, order_id NUMBER, unit_price NUMBER, quantity NUMBER)';
EXCEPTION
   WHEN OTHERS THEN NULL; -- Si ya existen, no pasa nada
END;
/

-- Insertamos un par de datos de prueba para que tu procedimiento tenga algo que contar
INSERT INTO ORDERS_TEST VALUES (1, SYSDATE, 100);
INSERT INTO CUSTOMERS_TEST VALUES (100, 'Asbell', 'Vargas');
INSERT INTO ORDER_ITEMS_TEST VALUES (1, 1, 50, 3);
COMMIT;

--- aqui

CREATE OR REPLACE PROCEDURE pr_calcular_devoluciones(
    p_orden_inicio IN NUMBER,
    p_orden_fin IN NUMBER
) IS
    CURSOR c_detalles IS
        SELECT o.order_id, o.order_date, c.customer_id, 
               c.cust_first_name || ' ' || c.cust_last_name as nombre_cliente,
               COUNT(oi.line_item_id) as total_articulos,
               SUM(oi.unit_price * oi.quantity) as total_compra
        FROM ORDERS_TEST o
        JOIN CUSTOMERS_TEST c ON o.customer_id = c.customer_id
        JOIN ORDER_ITEMS_TEST oi ON o.order_id = oi.order_id
        WHERE o.order_id BETWEEN p_orden_inicio AND p_orden_fin
        GROUP BY o.order_id, o.order_date, c.customer_id, c.cust_first_name, c.cust_last_name;

    v_porcentaje NUMBER;
    v_devolucion NUMBER;
BEGIN
    FOR r IN c_detalles LOOP
        -- Tu lógica de negocio original
        IF r.total_articulos = 3 THEN v_porcentaje := 0.15;
        ELSIF r.total_articulos = 4 THEN v_porcentaje := 0.20;
        ELSIF r.total_articulos >= 5 THEN v_porcentaje := 0.25;
        ELSE CONTINUE;
        END IF;

        v_devolucion := r.total_compra * v_porcentaje;

        DBMS_OUTPUT.PUT_LINE('Al cliente con id ' || r.customer_id || ' (' || r.nombre_cliente || ') en la orden ' || r.order_id || 
                             ' hay que devolverle $' || ROUND(v_devolucion, 2));
    END LOOP;
END;
/



---prueba 3 

-- 1. Insertamos una orden nueva (ID 99)
INSERT INTO ORDERS_TEST VALUES (99, SYSDATE, 100);

-- 2. Insertamos 3 artículos para que la orden tenga "3 artículos" (esto dispara tu IF)
INSERT INTO ORDER_ITEMS_TEST VALUES (10, 99, 10, 1);
INSERT INTO ORDER_ITEMS_TEST VALUES (11, 99, 10, 1);
INSERT INTO ORDER_ITEMS_TEST VALUES (12, 99, 10, 1);
COMMIT;

SET SERVEROUTPUT ON;
-- Ejecutamos buscando en un rango que incluya nuestra orden 99
EXEC pr_calcular_devoluciones(1, 100);