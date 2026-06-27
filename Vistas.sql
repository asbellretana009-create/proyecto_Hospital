-- ==========================================
-- SCRIPT: 05_Vistas.sql
-- Objetivo: Consultas prefabricadas para el sistema
-- ==========================================

-- ==========================================
-- 1. VISTA: INVENTARIO CRÍTICO (Alerta de escasez)
-- Muestra productos que tienen 20 unidades o menos
-- ==========================================
CREATE OR REPLACE VIEW V_Inventario_Critico AS
SELECT 
    e.Cod_Sucursal,
    p.Cod_Producto,
    p.Nombre AS Nombre_Producto,
    e.Cantidad_Existencia
FROM Existencias e
JOIN Productos p ON e.Cod_Producto = p.Cod_Producto
WHERE e.Cantidad_Existencia <= 20;

-- ==========================================
-- 2. VISTA: RESUMEN DE PRECIOS ACTIVOS
-- Muestra solo los servicios médicos con su precio actual aprobado
-- ==========================================
CREATE OR REPLACE VIEW V_Servicios_Activos AS
SELECT 
    s.Nombre_Servicio,
    s.Nombre_Especialidad,
    ps.Costo,
    s.Porcentaje_Impuesto
FROM Servicios s
JOIN Precios_Servicios ps ON s.Num_Servicio = ps.Id_Servicio
WHERE ps.Estado = 'Aprobado';

SELECT * FROM USER_VIEWS WHERE VIEW_NAME = 'V_INVENTARIO_CRITICO';
SELECT * FROM "V_INVENTARIO_CRITICO";

ROLLBACK;
DELETE FROM Existencias WHERE Cod_Producto = 6;
DELETE FROM Productos WHERE Cod_Producto = 6;
COMMIT;

SELECT * FROM "V_INVENTARIO_CRITICO";
