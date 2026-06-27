SELECT Cod_Sucursal, Cod_Producto, Cantidad_Existencia 
FROM Existencias 
WHERE Cod_Sucursal = 'SJO' AND Cod_Producto = 1;

INSERT INTO Inventarios (Cod_Sucursal, Fecha_Ingreso, Cod_Colaborador_Autoriza)
VALUES ('SJO', SYSTIMESTAMP + 1, 1);

INSERT INTO Detalle_Inventario (Num_Ingreso, Cod_Producto, Cant_Presupuestada, Cant_Real, Estado)
VALUES (1, 1, 50, 50, 'Pendiente de aprobación');

COMMIT;

BEGIN
    SP_Aprobar_Inventario(1);
END;
/