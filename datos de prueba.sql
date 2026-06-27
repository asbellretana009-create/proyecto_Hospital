
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

