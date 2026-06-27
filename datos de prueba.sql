
  --Inserts_Prueba.sql
-- Objetivo: Poblar tablas maestras


-- 1. INSERTS: CLIENTES
-- ==========================================
INSERT INTO Clientes (Pasaporte, Pais_Nacionalidad, Nombre, Apellidos, Sexo, Fecha_Nacimiento)
VALUES ('115480547', 'Costa Rica', 'Carlos', 'Mena Rojas', 'M', TO_DATE('1990-05-15', 'YYYY-MM-DD'));

INSERT INTO Clientes (Pasaporte, Pais_Nacionalidad, Nombre, Apellidos, Sexo, Fecha_Nacimiento)
VALUES ('204580963', 'Costa Rica', 'Laura', 'Gómez Vargas', 'F', TO_DATE('1985-11-22', 'YYYY-MM-DD'));

INSERT INTO Clientes (Pasaporte, Pais_Nacionalidad, Nombre, Apellidos, Sexo, Fecha_Nacimiento)
VALUES ('P-854712', 'Nicaragua', 'Miguel', 'López Silva', 'M', TO_DATE('1978-03-10', 'YYYY-MM-DD'));

INSERT INTO Clientes (Pasaporte, Pais_Nacionalidad, Nombre, Apellidos, Sexo, Fecha_Nacimiento)
VALUES ('301250478', 'Costa Rica', 'Ana', 'Brenes Castillo', 'F', TO_DATE('2000-07-04', 'YYYY-MM-DD'));

INSERT INTO Clientes (Pasaporte, Pais_Nacionalidad, Nombre, Apellidos, Sexo, Fecha_Nacimiento)
VALUES ('P-963258', 'Colombia', 'David', 'Ospina Ruiz', 'M', TO_DATE('1995-09-30', 'YYYY-MM-DD'));

-- ==========================================
-- 2. INSERTS: SERVICIOS
-- ==========================================
INSERT INTO Servicios (Nombre_Servicio, Nombre_Especialidad, Nombre_Desplegar, Porcentaje_Impuesto)
VALUES ('Consulta General', 'Medicina General', 'Cons. Med. Gen', 4.00);

INSERT INTO Servicios (Nombre_Servicio, Nombre_Especialidad, Nombre_Desplegar, Porcentaje_Impuesto)
VALUES ('Radiografía de Tórax', 'Radiología', 'Rayos X Torax', 4.00);

INSERT INTO Servicios (Nombre_Servicio, Nombre_Especialidad, Nombre_Desplegar, Porcentaje_Impuesto)
VALUES ('Examen de Sangre Completo', 'Laboratorio', 'Hemograma Comp.', 2.00);

INSERT INTO Servicios (Nombre_Servicio, Nombre_Especialidad, Nombre_Desplegar, Porcentaje_Impuesto)
VALUES ('Limpieza Dental', 'Odontología', 'Limp. Dental', 4.00);

INSERT INTO Servicios (Nombre_Servicio, Nombre_Especialidad, Nombre_Desplegar, Porcentaje_Impuesto)
VALUES ('Terapia Física', 'Fisioterapia', 'Fisioterapia', 2.00);

-- ==========================================
-- 3. INSERTS: PRODUCTOS
-- ==========================================
INSERT INTO Productos (Nombre, Horas_Max_Reserva) VALUES ('Paracetamol 500mg (Caja)', 0);
INSERT INTO Productos (Nombre, Horas_Max_Reserva) VALUES ('Ibuprofeno 400mg (Caja)', 0);
INSERT INTO Productos (Nombre, Horas_Max_Reserva) VALUES ('Silla de Ruedas Estándar', 48);
INSERT INTO Productos (Nombre, Horas_Max_Reserva) VALUES ('Muletas de Aluminio (Par)', 72);
INSERT INTO Productos (Nombre, Horas_Max_Reserva) VALUES ('Suero Fisiológico 500ml', 0);

-- ==========================================
-- 4. INSERTS: EXISTENCIAS
-- (Nota: Usaremos 'SJO' para San José y 'LIB' para Liberia)
-- ==========================================
-- Existencias en Sucursal SJO (San José)
INSERT INTO Existencias (Cod_Sucursal, Cod_Producto, Cantidad_Existencia, Cantidad_Reserva) VALUES ('SJO', 1, 500, 0);
INSERT INTO Existencias (Cod_Sucursal, Cod_Producto, Cantidad_Existencia, Cantidad_Reserva) VALUES ('SJO', 2, 350, 0);
INSERT INTO Existencias (Cod_Sucursal, Cod_Producto, Cantidad_Existencia, Cantidad_Reserva) VALUES ('SJO', 3, 10, 2);

-- Existencias en Sucursal LIB (Liberia)
INSERT INTO Existencias (Cod_Sucursal, Cod_Producto, Cantidad_Existencia, Cantidad_Reserva) VALUES ('LIB', 1, 200, 0);
INSERT INTO Existencias (Cod_Sucursal, Cod_Producto, Cantidad_Existencia, Cantidad_Reserva) VALUES ('LIB', 4, 15, 1);
INSERT INTO Existencias (Cod_Sucursal, Cod_Producto, Cantidad_Existencia, Cantidad_Reserva) VALUES ('LIB', 5, 100, 0);

-- ==========================================
-- 5. INSERTS: PRECIOS DE SERVICIOS
-- (Se asume que el usuario que registra tiene el ID 1)
-- ==========================================
-- Precio Consulta General
INSERT INTO Precios_Servicios (Id_Servicio, Fecha_Inicio, Costo, Estado, Usuario_Registra) 
VALUES (1, SYSTIMESTAMP, 35000.00, 'Aprobado', 1);

-- Precio Radiografía
INSERT INTO Precios_Servicios (Id_Servicio, Fecha_Inicio, Costo, Estado, Usuario_Registra) 
VALUES (2, SYSTIMESTAMP, 25000.00, 'Aprobado', 1);

-- Precio Hemograma
INSERT INTO Precios_Servicios (Id_Servicio, Fecha_Inicio, Costo, Estado, Usuario_Registra) 
VALUES (3, SYSTIMESTAMP, 18000.00, 'Aprobado', 1);

-- ¡IMPORTANTE! Guardar los cambios permanentemente
COMMIT;


-- 1. Asegurarnos de que el Producto 1 exista
INSERT INTO Productos (Nombre, Horas_Max_Reserva) 
VALUES ('Paracetamol 500mg (Caja)', 0);

-- 2. Ingresar las 500 unidades iniciales a San José
INSERT INTO Existencias (Cod_Sucursal, Cod_Producto, Cantidad_Existencia, Cantidad_Reserva) 
VALUES ('SJO', 1, 500, 0);

-- 3. Guardar los cambios permanentemente
COMMIT;