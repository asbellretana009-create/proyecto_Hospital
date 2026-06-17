-- ==========================================
-- 1. TABLA: CLIENTES
-- ==========================================
CREATE TABLE Clientes (
    Num_Cliente NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    Pasaporte VARCHAR2(50) UNIQUE NOT NULL, -- UNIQUE para que no se repitan los pasaportes[cite: 1]
    Pais_Nacionalidad VARCHAR2(50) NOT NULL, -- País de nacionalidad[cite: 1]
    Nombre VARCHAR2(50) NOT NULL,            -- Nombre[cite: 1]
    Apellidos VARCHAR2(100) NOT NULL,        -- Apellidos[cite: 1]
    Sexo CHAR(1) NOT NULL,                   -- Sexo (Ej: 'M' o 'F')[cite: 1]
    Fecha_Nacimiento DATE NOT NULL           -- Fecha de nacimiento[cite: 1]
);
-- ==========================================
-- 2. TABLA: SERVICIOS
-- ==========================================
CREATE TABLE Servicios (
    Num_Servicio NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    Nombre_Servicio VARCHAR2(100) NOT NULL,
    Nombre_Especialidad VARCHAR2(100) NOT NULL,
    Nombre_Desplegar VARCHAR2(100) NOT NULL,
    Porcentaje_Impuesto NUMBER(4,2) NOT NULL -- Dos dígitos más dos decimales (ej. 13.00 o 04.00)
);

-- ==========================================
-- 3. TABLA: PRECIOS DE SERVICIOS (Historial)
-- ==========================================
CREATE TABLE Precios_Servicios (
    Id_Precio NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    Id_Servicio NUMBER NOT NULL,
    Fecha_Inicio TIMESTAMP NOT NULL,
    Fecha_Fin TIMESTAMP,
    Costo NUMBER(10,2) NOT NULL,
    Estado VARCHAR2(25) DEFAULT 'Pendiente de aprobación', 
    Usuario_Registra NUMBER NOT NULL, -- Código del usuario que hace el registro
    Usuario_Aprueba NUMBER,           -- Código del usuario que hace la aprobación
    
    -- Validaciones
    CONSTRAINT CHK_Estado_Precio CHECK (Estado IN ('Pendiente de aprobación', 'Rechazado', 'Aprobado')),
    CONSTRAINT FK_Precio_Servicio FOREIGN KEY (Id_Servicio) REFERENCES Servicios(Num_Servicio)
);

-- ==========================================
-- 4. TABLA: PRODUCTOS
-- ==========================================
CREATE TABLE Productos (
    Cod_Producto NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    Nombre VARCHAR2(100) NOT NULL,
    Horas_Max_Reserva NUMBER DEFAULT 0 NOT NULL,
    
    -- Valida que sea entero mayor o igual a cero
    CONSTRAINT CHK_Horas_Reserva CHECK (Horas_Max_Reserva >= 0) 
);

-- ==========================================
-- 5. TABLA: EXISTENCIAS DE PRODUCTOS
-- ==========================================
CREATE TABLE Existencias (
    Cod_Sucursal VARCHAR2(10) NOT NULL,   -- Ej: 'G' (Grecia) o 'L' (Liberia)
    Cod_Producto NUMBER NOT NULL,
    Cantidad_Existencia NUMBER DEFAULT 0, -- Por default viene en cero
    Cantidad_Reserva NUMBER DEFAULT 0,    -- Por default viene en cero
    
    -- Llave primaria compuesta (Un producto en una sucursal específica)
    PRIMARY KEY (Cod_Sucursal, Cod_Producto),
    
    -- Nunca pueden ser negativos
    CONSTRAINT CHK_Existencia_Positiva CHECK (Cantidad_Existencia >= 0),
    CONSTRAINT CHK_Reserva_Positiva CHECK (Cantidad_Reserva >= 0),
    
    CONSTRAINT FK_Existencia_Producto FOREIGN KEY (Cod_Producto) REFERENCES Productos(Cod_Producto)
);

-- ALGO hola un e¿mensaje normal sss  NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    Nombre_Servicio VARCHAR2(100) NOT NULL,
    Nombre_Especialidad VARCHAR2(100) NOT NULL,
    Nombre_Desplegar VARCHAR2(100) NOT NULL,
    Porcentaje_Impuesto NUMBER(4,2) NOT NULL -- Dos dígitos más dos decimales (ej. 13.00 o 04.00)
);