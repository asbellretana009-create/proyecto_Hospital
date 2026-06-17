-- ==========================================
-- 6. TABLA: INVENTARIOS (Ingresos a bodega)
-- ==========================================
CREATE TABLE Inventarios (
    Num_Ingreso NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    Cod_Sucursal VARCHAR2(10) NOT NULL,
    Fecha_Ingreso TIMESTAMP NOT NULL, -- Nota para Antony: Validar por SP/Trigger que sea a futuro
    Cod_Colaborador_Autoriza NUMBER NOT NULL
);

-- ==========================================
-- 7. TABLA: DETALLE_INVENTARIO
-- ==========================================
CREATE TABLE Detalle_Inventario (
    Num_Ingreso NUMBER NOT NULL,
    Cod_Producto NUMBER NOT NULL,
    Cant_Presupuestada NUMBER NOT NULL,
    Cant_Real NUMBER NOT NULL,
    Estado VARCHAR2(30) DEFAULT 'Pendiente de aprobación',
    
    PRIMARY KEY (Num_Ingreso, Cod_Producto),
    CONSTRAINT FK_Detalle_Inventario FOREIGN KEY (Num_Ingreso) REFERENCES Inventarios(Num_Ingreso),
    CONSTRAINT FK_Detalle_Inv_Prod FOREIGN KEY (Cod_Producto) REFERENCES Productos(Cod_Producto),
    CONSTRAINT CHK_Cant_Real CHECK (Cant_Real <= Cant_Presupuestada),
    CONSTRAINT CHK_Estado_Inv CHECK (Estado IN ('Pendiente de aprobación', 'Aprobado'))
);

-- ==========================================
-- 8. TABLA: FACTURAS (Encabezado)
-- ==========================================
CREATE TABLE Facturas (
    Num_Factura NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    Cod_Sucursal VARCHAR2(10) NOT NULL,
    Cod_Cliente NUMBER NOT NULL,
    Fecha_Creacion TIMESTAMP DEFAULT SYSTIMESTAMP,
    Estado VARCHAR2(20) DEFAULT 'En proceso',
    
    CONSTRAINT FK_Factura_Cliente FOREIGN KEY (Cod_Cliente) REFERENCES Clientes(Num_Cliente),
    CONSTRAINT CHK_Estado_Factura CHECK (Estado IN ('En proceso', 'Emitida'))
);

-- ==========================================
-- 9. TABLA: DETALLE FACTURA SERVICIOS
-- ==========================================
CREATE TABLE Detalle_Factura_Servicios (
    Num_Factura NUMBER NOT NULL,
    Num_Linea NUMBER NOT NULL,
    Cod_Usuario_Ingresa NUMBER NOT NULL,
    Fecha_Hora_Ingreso TIMESTAMP DEFAULT SYSTIMESTAMP,
    Cod_Servicio NUMBER NOT NULL,
    Cantidad_Facturada NUMBER NOT NULL,
    Precio_Facturado_Unit NUMBER(10,2) NOT NULL,
    Porcentaje_Descuento NUMBER(5,2) DEFAULT 0,
    
    PRIMARY KEY (Num_Factura, Num_Linea),
    CONSTRAINT FK_Det_Fac_Serv_Factura FOREIGN KEY (Num_Factura) REFERENCES Facturas(Num_Factura),
    CONSTRAINT FK_Det_Fac_Serv_Servicio FOREIGN KEY (Cod_Servicio) REFERENCES Servicios(Num_Servicio),
    CONSTRAINT CHK_Desc_Servicio CHECK (Porcentaje_Descuento BETWEEN 0 AND 100)
);

-- ==========================================
-- 10. TABLA: DETALLE FACTURA PRODUCTOS
-- ==========================================
CREATE TABLE Detalle_Factura_Productos (
    Num_Factura NUMBER NOT NULL,
    Num_Linea NUMBER NOT NULL,
    Cod_Usuario_Ingresa NUMBER NOT NULL,
    Fecha_Hora_Ingreso TIMESTAMP DEFAULT SYSTIMESTAMP,
    Tipo_Linea VARCHAR2(10) NOT NULL, -- 'Reserva' o 'Venta'
    Estado VARCHAR2(30) NOT NULL,     -- 'Reservada', 'Cancelada por timeout', 'Facturada'
    Cod_Producto NUMBER NOT NULL,
    Cantidad_Reservada NUMBER DEFAULT 0,
    Cantidad_Vendida NUMBER DEFAULT 0,
    Precio_Facturado NUMBER(10,2) NOT NULL,
    Porcentaje_Descuento NUMBER(5,2) DEFAULT 0,
    
    PRIMARY KEY (Num_Factura, Num_Linea),
    CONSTRAINT FK_Det_Fac_Prod_Factura FOREIGN KEY (Num_Factura) REFERENCES Facturas(Num_Factura),
    CONSTRAINT FK_Det_Fac_Prod_Producto FOREIGN KEY (Cod_Producto) REFERENCES Productos(Cod_Producto),
    CONSTRAINT CHK_Tipo_Linea CHECK (Tipo_Linea IN ('Reserva', 'Venta')),
    CONSTRAINT CHK_Estado_Linea CHECK (Estado IN ('Reservada', 'Cancelada por timeout', 'Facturada')),
    CONSTRAINT CHK_Desc_Producto CHECK (Porcentaje_Descuento BETWEEN 0 AND 100)
);

-- ==========================================
-- 11. TABLA: SOLICITUDES DE TRANSPORTE
-- ==========================================
CREATE TABLE Solicitudes_Transporte (
    Num_Solicitud NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    Cod_Usuario_Registra NUMBER NOT NULL,
    Cod_Usuario_Aprueba NUMBER,
    Fecha_Traslado DATE NOT NULL, -- Nota Antony: Validar por SP que sea mañana a las 00:00:00
    Cod_Producto NUMBER NOT NULL,
    Cantidad NUMBER NOT NULL,
    Sucursal_Origen VARCHAR2(10) NOT NULL,
    Sucursal_Destino VARCHAR2(10) NOT NULL,
    Estado VARCHAR2(20) DEFAULT 'Registrado',
    
    CONSTRAINT FK_Sol_Trans_Prod FOREIGN KEY (Cod_Producto) REFERENCES Productos(Cod_Producto),
    CONSTRAINT CHK_Estado_Sol_Trans CHECK (Estado IN ('Registrado', 'Enviado', 'Descartado'))
);

-- ==========================================
-- 12. TABLA: BITACORA TIMEOUT
-- ==========================================
CREATE TABLE Bitacora_Timeout (
    Id_Bitacora NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    Fecha_Registro TIMESTAMP DEFAULT SYSTIMESTAMP,
    Mensaje VARCHAR2(500) NOT NULL
);
