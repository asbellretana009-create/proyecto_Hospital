/* Descripción:Procedimientos para el proceso completo de ingreso de inventario.*/


/*
    PROCEDIMIENTO: SP_RegistrarIngresoInventario
    Función:
    • Valida que la fecha del ingreso sea futura.
    • Registra un nuevo ingreso de inventario.*/

CREATE OR REPLACE PROCEDURE SP_RegistrarIngresoInventario(

    p_Cod_Sucursal              IN VARCHAR2,
    p_Fecha_Ingreso             IN TIMESTAMP,
    p_Cod_Colaborador_Autoriza  IN NUMBER
)
AS
BEGIN
    -- Validar que la fecha sea futura

    IF p_Fecha_Ingreso <= SYSTIMESTAMP THEN
        RAISE_APPLICATION_ERROR( --Validación de estados y actualización de tablas.
            -20001,
            'La fecha del ingreso debe ser posterior a la fecha actual.'
        );
    END IF;

    -- Registrar el ingreso
    INSERT INTO Inventarios(
        Cod_Sucursal,
        Fecha_Ingreso,
        Cod_Colaborador_Autoriza
    )
    VALUES(
        p_Cod_Sucursal,
        p_Fecha_Ingreso,
        p_Cod_Colaborador_Autoriza

    );
END;
/
SHOW ERRORS;   


/*PROCEDIMIENTO: SP_AprobarIngresoInventario

    Descripción:
    Aprueba un ingreso de inventario y actualiza
    automáticamente las existencias.*/

CREATE OR REPLACE PROCEDURE SP_AprobarIngresoInventario(
    p_Num_Ingreso IN NUMBER
)
AS
    v_Cod_Sucursal Inventarios.Cod_Sucursal%TYPE;
    CURSOR c_Detalle IS
        SELECT Cod_Producto,
               Cant_Real,
               Estado
        FROM Detalle_Inventario
        WHERE Num_Ingreso = p_Num_Ingreso;
BEGIN


    -- Obtener la sucursal del ingreso
    SELECT Cod_Sucursal
    INTO v_Cod_Sucursal
    FROM Inventarios
    WHERE Num_Ingreso = p_Num_Ingreso;

    -- Recorrer todos los productos del ingreso
    FOR registro IN c_Detalle LOOP

        -- Validar estado
        IF registro.Estado <> 'Pendiente de aprobación' THEN
            RAISE_APPLICATION_ERROR(
                -20002,
                'El ingreso ya fue aprobado.'
            );
        END IF;

        -- Cambiar estado
        UPDATE Detalle_Inventario
           SET Estado = 'Aprobado'
         WHERE Num_Ingreso = p_Num_Ingreso
           AND Cod_Producto = registro.Cod_Producto;

        -- Actualizar existencias
        UPDATE Existencias
           SET Cantidad_Existencia =
               Cantidad_Existencia + registro.Cant_Real
         WHERE Cod_Sucursal = v_Cod_Sucursal
           AND Cod_Producto = registro.Cod_Producto;
           IF SQL%ROWCOUNT = 0 THEN 
         INSERT INTO Existencias --Si el producto no existe en la sucursal
    (
        Cod_Sucursal,
        Cod_Producto,
        Cantidad_Existencia,
        Cantidad_Reserva
    )
    VALUES
    (
        v_Cod_Sucursal,
        registro.Cod_Producto,
        registro.Cant_Real,
        0
    );
END IF;
    END LOOP;
END;
/
SHOW ERRORS;


/* TRIGGER: TRG_Validar_Fecha_Inventario

    Descripción:
    Valida que la fecha de ingreso sea posterior
    a la fecha y hora actuales.*/

CREATE OR REPLACE TRIGGER TRG_Validar_Fecha_Inventario
BEFORE INSERT OR UPDATE
ON Inventarios
FOR EACH ROW
BEGIN
    IF :NEW.Fecha_Ingreso <= SYSTIMESTAMP THEN
        RAISE_APPLICATION_ERROR(
            -20003,
            'La fecha del ingreso debe ser futura.'
        );
    END IF;
END;
/
SHOW ERRORS;
/*TRIGGER: TRG_Validar_Estado_Inventario
    Descripción:
    Valida que solamente existan los estados
    permitidos para un detalle de inventario.*/

CREATE OR REPLACE TRIGGER TRG_Validar_Estado_Inventario
BEFORE INSERT OR UPDATE
ON Detalle_Inventario
FOR EACH ROW
BEGIN
    IF :NEW.Estado NOT IN
    (
        'Pendiente de aprobación',
        'Aprobado'
    )
    THEN
        RAISE_APPLICATION_ERROR(
            -20004,
            'Estado de inventario no permitido.'
        );
    END IF;
END;
/
SHOW ERRORS;

/* PROCEDIMIENTO: SP_RegistrarSolicitudTransporte

    Descripción:
    Registra una solicitud de transporte y valida
    que la fecha de traslado sea el día siguiente
    a las 00:00:00.*/

CREATE OR REPLACE PROCEDURE SP_RegistrarSolicitudTransporte(

    p_Cod_Usuario_Registra   IN NUMBER,
    p_Fecha_Traslado         IN DATE,
    p_Cod_Producto           IN NUMBER,
    p_Cantidad               IN NUMBER,
    p_Sucursal_Origen        IN VARCHAR2,
    p_Sucursal_Destino       IN VARCHAR2

)
AS
    v_Fecha_Valida DATE;
BEGIN
    -- Fecha válida: mañana a las 00:00:00
    v_Fecha_Valida := TRUNC(SYSDATE) + 1;
    IF p_Fecha_Traslado <> v_Fecha_Valida THEN
        RAISE_APPLICATION_ERROR(
            -20005,
            'La fecha de traslado debe ser mañana a las 00:00:00.'
        );
    END IF;

    -- Registrar la solicitud
    INSERT INTO Solicitudes_Transporte
    (
        Cod_Usuario_Registra,
        Fecha_Traslado,
        Cod_Producto,
        Cantidad,
        Sucursal_Origen,
        Sucursal_Destino
    )
    VALUES
    (
        p_Cod_Usuario_Registra,
        p_Fecha_Traslado,
        p_Cod_Producto,
        p_Cantidad,
        p_Sucursal_Origen,
        p_Sucursal_Destino
    );
END;
/
SHOW ERRORS;