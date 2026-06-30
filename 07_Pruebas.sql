/* Descripción: Pruebas para los procedimientos del proceso de inventario.*/

-- CONSULTAR INVENTARIO ACTUAL

SELECT *
FROM Existencias;


-- CONSULTAR INGRESOS REGISTRADOS


SELECT *
FROM Inventarios;


-- CONSULTAR DETALLE DE INGRESOS


SELECT *
FROM Detalle_Inventario;


-- PRUEBA 1
-- Registrar un ingreso de inventario


BEGIN
    SP_RegistrarIngresoInventario(
        'SJO',
        SYSTIMESTAMP + 1,
        1
    );
END;
/


-- Verificar ingreso registrado


SELECT *
FROM Inventarios
ORDER BY Num_Ingreso DESC;

-- PRUEBA 2
-- Aprobar un ingreso

BEGIN
    SP_AprobarIngresoInventario(1);
END;
/

-- Verificar detalle actualizado

SELECT *
FROM Detalle_Inventario
WHERE Num_Ingreso = 1;
-- Verificar existencias

SELECT *
FROM Existencias;

-- PRUEBA 3
-- Registrar solicitud de transporte

BEGIN
    SP_RegistrarSolicitudTransporte(
        1,
        TRUNC(SYSDATE)+1,
        1, 10, 'SJO','LIB'
    );
END;
/

-- Verificar solicitud registrada
SELECT *
FROM Solicitudes_Transporte
ORDER BY Num_Solicitud DESC;