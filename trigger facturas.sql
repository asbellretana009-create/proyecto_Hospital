
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

-- ==========================================
-- 2. PROCEDIMIENTO: APROBAR INGRESO DE INVENTARIO
-- ==========================================
CREATE OR REPLACE PROCEDURE SP_Aprobar_Inventario (
    p_Num_Ingreso IN NUMBER
) AS
BEGIN
    -- 1. Actualizar el estado del detalle a 'Aprobado'
    UPDATE Detalle_Inventario
    SET Estado = 'Aprobado'
    WHERE Num_Ingreso = p_Num_Ingreso
      AND Estado = 'Pendiente de aprobación';

    -- 2. Recorrer los productos de ese ingreso y sumarlos a las existencias reales
    FOR reg IN (
        SELECT di.Cod_Producto, di.Cant_Real, i.Cod_Sucursal
        FROM Detalle_Inventario di
        JOIN Inventarios i ON di.Num_Ingreso = i.Num_Ingreso
        WHERE di.Num_Ingreso = p_Num_Ingreso
    ) LOOP
        UPDATE Existencias
        SET Cantidad_Existencia = Cantidad_Existencia + reg.Cant_Real
        WHERE Cod_Producto = reg.Cod_Producto
          AND Cod_Sucursal = reg.Cod_Sucursal;
    END LOOP;
    
    -- 3. Confirmar los cambios
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('Inventario aprobado y sumado con éxito.');
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error al aprobar inventario: ' || SQLERRM);
END SP_Aprobar_Inventario;
/

