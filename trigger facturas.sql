
-- SCRIPT: 04_Triggers_Procedimientos.sql
-- Objetivo: Lógica de negocio Triggers 
-- 1. TRIGGER: ACTUALIZAR INVENTARIO POR VENTA

CREATE OR REPLACE TRIGGER TRG_Actualizar_Inventario
AFTER INSERT OR UPDATE ON Detalle_Factura_Productos
FOR EACH ROW
DECLARE
    v_Cod_Sucursal VARCHAR2(10);
BEGIN
    -- Solo restamos del inventario si la línea es de tipo 'Venta' y está 'Facturada'
    IF :NEW.Tipo_Linea = 'Venta' AND :NEW.Estado = 'Facturada' THEN
        
        -- Buscamos a qué sucursal pertenece esta factura (ya que el detalle no tiene la sucursal, la tiene el encabezado)
        SELECT Cod_Sucursal INTO v_Cod_Sucursal
        FROM Facturas
        WHERE Num_Factura = :NEW.Num_Factura;

        -- Actualizamos la tabla de Existencias restando lo que se vendió
        UPDATE Existencias
        SET Cantidad_Existencia = Cantidad_Existencia - :NEW.Cantidad_Vendida
        WHERE Cod_Producto = :NEW.Cod_Producto
          AND Cod_Sucursal = v_Cod_Sucursal;
          
    END IF;
END;
/
