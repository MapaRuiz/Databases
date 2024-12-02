-- Drop sequence if it exists
DROP SEQUENCE SECUENCIAPEDIDOSLOG;

-- Create sequence for PEDIDOS_LOG
CREATE SEQUENCE SECUENCIAPEDIDOSLOG
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

-- Drop sequence if it exists
DROP SEQUENCE SECUENCIACLIENTESLOG;

-- Create sequence for CLIENTES_LOG
CREATE SEQUENCE SECUENCIACLIENTESLOG
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

-- Drop sequence if it exists
DROP SEQUENCE SEQ_NOTIFICACION;

-- Create sequence for NOTIFICACIONES
CREATE SEQUENCE SEQ_NOTIFICACION
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

-- Elaborar un procedimiento almacenado que permita la actualización del valor de un producto:
CREATE OR REPLACE PROCEDURE PROCEDIMIENTOACTUALIZARVALORPRODUCTO (
p_codigoproducto VARCHAR2, p_precioventa NUMBER) AS 
BEGIN
    UPDATE PRODUCTOS
    SET PRECIOVENTA = p_precioventa
    WHERE CODIGOPRODUCTO = p_codigoproducto;
    COMMIT;
END PROCEDIMIENTOACTUALIZARVALORPRODUCTO;
/

-- Elaborar un procedimiento almacenado que permita la actualización del inventario de un producto:
CREATE OR REPLACE PROCEDURE PROCEDIMIENTOACTUALIZARINVENTARIO (
    p_codigoproducto IN VARCHAR2,
    p_nuevo_stock IN NUMBER
) AS 
    stock_actual NUMBER;
BEGIN
    SELECT CANTIDADENSTOCK INTO stock_actual
    FROM PRODUCTOS
    WHERE CODIGOPRODUCTO = p_codigoproducto;

    IF p_nuevo_stock < 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'El nuevo stock no puede ser menor que cero');
    END IF;

    UPDATE PRODUCTOS
    SET CANTIDADENSTOCK = p_nuevo_stock
    WHERE CODIGOPRODUCTO = p_codigoproducto;
    COMMIT;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20002, 'No se encontró ningún producto con el código especificado');
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END PROCEDIMIENTOACTUALIZARINVENTARIO;
/

-- Elaborar un procedimiento almacenado que permita insertar información del detalle de un pedido:
CREATE OR REPLACE PROCEDURE PROCEDIMIENTODETALLESPEDIDO (
    p_cod_pedido IN NUMBER,
    p_cod_producto IN VARCHAR2,
    p_cantidad IN NUMBER,
    p_precio_unidad IN NUMBER,
    p_numero_linea IN NUMBER
) AS
BEGIN
    INSERT INTO DETALLEPEDIDOS (CODIGOPEDIDO, CODIGOPRODUCTO, CANTIDAD, PRECIOUNIDAD, NUMEROLINEA)
    VALUES (p_cod_pedido, p_cod_producto, p_cantidad, p_precio_unidad, p_numero_linea);
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END PROCEDIMIENTODETALLESPEDIDO;
/

-- Elaborar una función que devuelva el valor de producto más vendido:
CREATE OR REPLACE FUNCTION FUNCIONPRODUCTOMASVENDIDO RETURN VARCHAR2 AS 
    v_producto_mas_vendido VARCHAR2(100);
BEGIN
    SELECT CODIGOPRODUCTO INTO v_producto_mas_vendido
    FROM (
        SELECT CODIGOPRODUCTO, SUM(CANTIDAD) AS TOTAL_VENDIDO
        FROM DETALLEPEDIDOS
        GROUP BY CODIGOPRODUCTO
        ORDER BY TOTAL_VENDIDO DESC
    )
    WHERE ROWNUM = 1;
    RETURN v_producto_mas_vendido;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
END FUNCIONPRODUCTOMASVENDIDO;
/

-- Elaborar una función que devuelva la gama de productos más vendido:
CREATE OR REPLACE FUNCTION FUNCIONGAMAMASVENDIDA RETURN VARCHAR2 AS 
    v_gama_mas_vendida VARCHAR2(100);
BEGIN
    SELECT GAMA
    INTO v_gama_mas_vendida
    FROM (
        SELECT GAMA, SUM(CANTIDAD) AS total_vendido
        FROM DETALLEPEDIDOS dp
        JOIN PRODUCTOS p ON dp.CODIGOPRODUCTO = p.CODIGOPRODUCTO
        GROUP BY GAMA
        ORDER BY SUM(CANTIDAD) DESC
    ) WHERE ROWNUM = 1;
    RETURN v_gama_mas_vendida;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
    WHEN OTHERS THEN
        RAISE;
END FUNCIONGAMAMASVENDIDA;
/

-- Elabore un (procedimiento almacenado / función) que permita el registro de nuevos medios de pago, debe verificar la existencia del “códigocliente” de manera previa:
CREATE OR REPLACE PROCEDURE PROCEDIMIENTOMEDIOPAGO (
    p_codigo_cliente IN NUMBER,
    p_forma_pago IN VARCHAR2
) AS
    v_id_transaccion PAGOS.IDTRANSACCION%TYPE;
BEGIN
    SELECT IDTRANSACCION
    INTO v_id_transaccion
    FROM PAGOS
    WHERE CODIGOCLIENTE = p_codigo_cliente
    AND FORMAPAGO = p_forma_pago;
    RAISE_APPLICATION_ERROR(-20002, 'Ya existe un registro para este cliente y forma de pago');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        SELECT NVL(MAX(SUBSTR(IDTRANSACCION, INSTR(IDTRANSACCION, '-', -1) + 1)), 0) + 1
        INTO v_id_transaccion
        FROM PAGOS
        WHERE CODIGOCLIENTE = p_codigo_cliente;
        INSERT INTO PAGOS (CODIGOCLIENTE, FORMAPAGO, IDTRANSACCION, FECHAPAGO, CANTIDAD)
        VALUES (p_codigo_cliente, p_forma_pago, 'ak-std-' || LPAD(v_id_transaccion, 6, '0'), SYSDATE, 0);
        COMMIT;
END PROCEDIMIENTOMEDIOPAGO;
/

-- Elaborar un disparador que permita descontar las existencias de los productos cuando se haga un pedido:
CREATE OR REPLACE TRIGGER DISPARADORACTUALIZARINVENTARIO
AFTER INSERT ON DETALLEPEDIDOS
FOR EACH ROW
DECLARE
    v_estado_pedido VARCHAR2(50);
    stock_actual NUMBER;
BEGIN
    SELECT ESTADO INTO v_estado_pedido
    FROM PEDIDOS
    WHERE CODIGOPEDIDO = :NEW.CODIGOPEDIDO;

    IF v_estado_pedido = 'Entregado' THEN
        SELECT CANTIDADENSTOCK INTO stock_actual
        FROM PRODUCTOS
        WHERE CODIGOPRODUCTO = :NEW.CODIGOPRODUCTO;

        IF stock_actual < :NEW.CANTIDAD THEN
            RAISE_APPLICATION_ERROR(-20001, 'No hay suficiente stock para el producto ' || :NEW.CODIGOPRODUCTO);
        ELSE
            UPDATE PRODUCTOS
            SET CANTIDADENSTOCK = stock_actual - :NEW.CANTIDAD
            WHERE CODIGOPRODUCTO = :NEW.CODIGOPRODUCTO;
        END IF;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        RAISE;
END;
/

-- Elabore un disparador que evite que un empleado sea su propio jefe. Este se deberá activar en caso de que desee registrar a un empleado su jefe, ya sea al momento del registro de un nuevo empleado o en un proceso de actualización:
CREATE OR REPLACE TRIGGER DISPARADOREMPLEADOPROPIOJEFE
AFTER INSERT OR UPDATE ON EMPLEADOS
FOR EACH ROW
DECLARE
BEGIN
    IF :NEW.CODIGOJEFE = :NEW.CODIGOEMPLEADO THEN
        RAISE_APPLICATION_ERROR(-20001, 'No se puede asignar a un empleado como su propio jefe.');
    END IF;
END;
/

-- Elaborar unos disparadores que permitan realizar el proceso de auditoria a las tablas, clientes y pedidos, para los procesos de inserción, actualización y borrado:
CREATE OR REPLACE TRIGGER DISPARADORPEDIDOSLOG
AFTER INSERT OR UPDATE OR DELETE ON PEDIDOS
FOR EACH ROW
DECLARE
    V_ESTADO_ANTERIOR VARCHAR2(100);
    V_ESTADO_NUEVO VARCHAR2(100);
BEGIN
    IF INSERTING THEN
        INSERT INTO PEDIDOS_LOG (ID_AUDITORIA, CODIGOPEDIDO, FECHA_MODIFICACION, USUARIO_MODIFICADOR, ESTADO_ANTERIOR, ESTADO_NUEVO)
        VALUES (SECUENCIAPEDIDOSLOG.NEXTVAL, :NEW.CODIGOPEDIDO, SYSTIMESTAMP, USER, NULL, :NEW.ESTADO);
    ELSIF UPDATING THEN
        V_ESTADO_ANTERIOR := NVL(:OLD.ESTADO, 'NULL');
        V_ESTADO_NUEVO := NVL(:NEW.ESTADO, 'NULL');        
        INSERT INTO PEDIDOS_LOG (ID_AUDITORIA, CODIGOPEDIDO, FECHA_MODIFICACION, USUARIO_MODIFICADOR, ESTADO_ANTERIOR, ESTADO_NUEVO)
        VALUES (SECUENCIAPEDIDOSLOG.NEXTVAL, :OLD.CODIGOPEDIDO, SYSTIMESTAMP, USER, V_ESTADO_ANTERIOR, V_ESTADO_NUEVO);
    ELSIF DELETING THEN
        V_ESTADO_ANTERIOR := NVL(:OLD.ESTADO, 'NULL');
        INSERT INTO PEDIDOS_LOG (ID_AUDITORIA, CODIGOPEDIDO, FECHA_MODIFICACION, USUARIO_MODIFICADOR, ESTADO_ANTERIOR, ESTADO_NUEVO)
        VALUES (SECUENCIAPEDIDOSLOG.NEXTVAL, :OLD.CODIGOPEDIDO, SYSTIMESTAMP, USER, V_ESTADO_ANTERIOR, NULL);
    END IF;
END;
/

CREATE OR REPLACE TRIGGER DISPARADORCLIENTESLOG
AFTER INSERT OR UPDATE OR DELETE ON CLIENTES
FOR EACH ROW
DECLARE
    V_NOMBRE_ANTERIOR VARCHAR2(100);
    V_NOMBRE_NUEVO VARCHAR2(100);
    V_APELLIDO_ANTERIOR VARCHAR2(100);
    V_APELLIDO_NUEVO VARCHAR2(100);
BEGIN
    IF INSERTING THEN
        INSERT INTO CLIENTES_LOG (ID_AUDITORIA, CODIGOCLIENTE, NOMBRE_ANTERIOR, NOMBRE_NUEVO, APELLIDO_ANTERIOR, APELLIDO_NUEVO, FECHA_MODIFICACION, USUARIO_MODIFICADOR)
        VALUES (SECUENCIACLIENTESLOG.NEXTVAL, :NEW.CODIGOCLIENTE, NULL, :NEW.NOMBRECLIENTE, NULL, :NEW.NOMBRECONTACTO, SYSTIMESTAMP, USER);
    ELSIF UPDATING THEN
        V_NOMBRE_ANTERIOR := NVL(:OLD.NOMBRECLIENTE, 'NULL');
        V_NOMBRE_NUEVO := NVL(:NEW.NOMBRECLIENTE, 'NULL');
        V_APELLIDO_ANTERIOR := NVL(:OLD.NOMBRECONTACTO, 'NULL');
        V_APELLIDO_NUEVO := NVL(:NEW.NOMBRECONTACTO, 'NULL');
        INSERT INTO CLIENTES_LOG (ID_AUDITORIA, CODIGOCLIENTE, NOMBRE_ANTERIOR, NOMBRE_NUEVO, APELLIDO_ANTERIOR, APELLIDO_NUEVO, FECHA_MODIFICACION, USUARIO_MODIFICADOR)
        VALUES (SECUENCIACLIENTESLOG.NEXTVAL, :OLD.CODIGOCLIENTE, V_NOMBRE_ANTERIOR, V_NOMBRE_NUEVO, V_APELLIDO_ANTERIOR, V_APELLIDO_NUEVO, SYSTIMESTAMP, USER);
    ELSIF DELETING THEN
        V_NOMBRE_ANTERIOR := NVL(:OLD.NOMBRECLIENTE, 'NULL');
        V_APELLIDO_ANTERIOR := NVL(:OLD.NOMBRECONTACTO, 'NULL');
        INSERT INTO CLIENTES_LOG (ID_AUDITORIA, CODIGOCLIENTE, NOMBRE_ANTERIOR, NOMBRE_NUEVO, APELLIDO_ANTERIOR, APELLIDO_NUEVO, FECHA_MODIFICACION, USUARIO_MODIFICADOR)
        VALUES (SECUENCIACLIENTESLOG.NEXTVAL, :OLD.CODIGOCLIENTE, V_NOMBRE_ANTERIOR, NULL, V_APELLIDO_ANTERIOR, NULL, SYSTIMESTAMP, USER);
    END IF;
END;
/

-- Elaborar un procedimiento almacenado que permita actualizar el valor total de un pedido según el detalle de los pedidos, el código de pedido deberá pasar por parámetro de entrada:
create or replace PROCEDURE PROCEDIMIENTOCALCULARTOTALPEDIDO (
    codigo_pedido_param IN DETALLEPEDIDOS.CODIGOPEDIDO%TYPE
)
AS
    v_valor_total_pedido DETALLEPEDIDOS.VALORTOTAL%TYPE := 0;
BEGIN
    SELECT SUM(CANTIDAD * PRECIOUNIDAD) INTO v_valor_total_pedido
    FROM DETALLEPEDIDOS
    WHERE CODIGOPEDIDO = codigo_pedido_param;
    UPDATE DETALLEPEDIDOS
    SET VALORTOTAL = v_valor_total_pedido
    WHERE CODIGOPEDIDO = codigo_pedido_param;
    DBMS_OUTPUT.PUT_LINE('Valor total del pedido actualizado correctamente.');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No se encontraron detalles de pedido para el código de pedido proporcionado.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error al actualizar el valor total del pedido: ' || SQLERRM);
END PROCEDIMIENTOCALCULARTOTALPEDIDO;
/

-- Elaborar un procedimiento almacenado que permita actualizar el valor de todos los pedidos a partir del procedimiento anterior:
CREATE OR REPLACE PROCEDURE PROCEDIMIENTOCALCULARTOTALPEDIDOSUMA
AS
    v_suma_total_pedidos NUMBER := 0;
BEGIN
    FOR detalle IN (SELECT DISTINCT CODIGOPEDIDO FROM DETALLEPEDIDOS)
    LOOP
        PROCEDIMIENTOCALCULARTOTALPEDIDO(detalle.CODIGOPEDIDO);
    END LOOP;
    SELECT SUM(VALORTOTAL) INTO v_suma_total_pedidos
    FROM DETALLEPEDIDOS;
    DBMS_OUTPUT.PUT_LINE('La suma total de los valores de todos los pedidos es: ' || v_suma_total_pedidos);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error al calcular la suma total de los valores de los pedidos: ' || SQLERRM);
END PROCEDIMIENTOCALCULARTOTALPEDIDOSUMA;
/

-- Elaborar un disparador que registre de manera automática el valor total de un pedido a partir del ingreso, actualización o eliminación en la tabla “detallepedido”:
CREATE OR REPLACE TRIGGER DISPARADORACTUALIZARVALORTOTALPEDIDO
AFTER INSERT OR UPDATE OR DELETE ON DETALLEPEDIDOS
FOR EACH ROW
DECLARE
    v_valor_total_pedido DETALLEPEDIDOS.VALORTOTAL%TYPE := 0;
BEGIN
    IF INSERTING THEN
        PROCEDIMIENTOCALCULARTOTALPEDIDO(:NEW.CODIGOPEDIDO);

    ELSIF UPDATING THEN
        PROCEDIMIENTOCALCULARTOTALPEDIDO(:NEW.CODIGOPEDIDO);

    ELSIF DELETING THEN
        PROCEDIMIENTOCALCULARTOTALPEDIDO(:OLD.CODIGOPEDIDO);
    END IF;
END;
/

-- Elabore un disparador que al momento de ingresar o actualizar un producto, verifique que el precio de venta de un producto sea superior un 10% del precio del “proveedor”:
CREATE OR REPLACE TRIGGER DISPARADORVERIFICARPRECIOVENTA
BEFORE INSERT OR UPDATE ON PRODUCTOS
FOR EACH ROW
DECLARE
    v_precio_proveedor NUMBER;
BEGIN
    v_precio_proveedor := :NEW.PRECIOPROVEEDOR;

    IF :NEW.PRECIOVENTA <= (v_precio_proveedor * 1.1) THEN
        RAISE_APPLICATION_ERROR(-20001, 'El precio de venta debe ser al menos un 10% superior al precio del proveedor.');
    END IF;
END;
/

--Elabore un disparador que verifique al momento de realizar los pedidos, el
--inventario no quede vacío
CREATE OR REPLACE TRIGGER DISPARADORVERIFICARCANTIDADINVENTARIO
BEFORE INSERT OR UPDATE ON DETALLEPEDIDOS
FOR EACH ROW
DECLARE
    v_cantidad_disponible NUMBER;
BEGIN
    SELECT CANTIDADENSTOCK INTO v_cantidad_disponible
    FROM PRODUCTOS
    WHERE CODIGOPRODUCTO = :NEW.CODIGOPRODUCTO;
    IF :NEW.CANTIDAD > v_cantidad_disponible THEN
        RAISE_APPLICATION_ERROR(-20001, 'La cantidad solicitada excede la cantidad disponible en inventario.');
    END IF;
END;
/
--Elaborar un disparador que se active después de una acción de manipulación 
--(inserción, actualización) sobre la tabla de “detallepedido” el cual deberá 
--verificar si el producto que se está facturando se encuentra en una gama con 
--descuento, si en efecto tiene descuento entonces automáticamente ha de aplicar al momento de facturar
CREATE OR REPLACE TRIGGER DISPARADORAPLICARDESCUENTO
BEFORE INSERT OR UPDATE ON DETALLEPEDIDOS
FOR EACH ROW
DECLARE
    v_descuento NUMBER := 0;
    v_gama VARCHAR2(50);
BEGIN
    -- Obtener la gama del producto
    SELECT GAMA INTO v_gama
    FROM PRODUCTOS
    WHERE CODIGOPRODUCTO = :NEW.CODIGOPRODUCTO;
    
    -- Obtener el descuento de la gama del producto si existe
    SELECT DESCUENTO INTO v_descuento
    FROM GAMASPRODUCTOS
    WHERE GAMA = v_gama;
    
    -- Aplicar el descuento si existe
    IF v_descuento IS NOT NULL THEN
        :NEW.PRECIOUNIDAD := :NEW.PRECIOUNIDAD - (:NEW.PRECIOUNIDAD * (v_descuento / 100));
    END IF;
END;
/
--Construir un disparador que permita actualizar automáticamente la cantidad
--disponible en el inventario a partir del registro de un nuevo pedido.
CREATE OR REPLACE TRIGGER DISPARADOR_ACTUALIZAR_INVENTARIO
AFTER INSERT ON DETALLEPEDIDOS
FOR EACH ROW
DECLARE
    v_cantidad_disponible NUMBER;
BEGIN
    
    UPDATE PRODUCTOS
    SET CANTIDADENSTOCK = CANTIDADENSTOCK - :NEW.CANTIDAD
    WHERE CODIGOPRODUCTO = :NEW.CODIGOPRODUCTO;

END;
/

--Construir un disparador que en caso de que un cliente registre un pago y este 
--supere el límite de crédito realice un registro de una notificación de “ha 
--superado el límite de crédito” en la tabla de notificaciones
CREATE OR REPLACE TRIGGER TRIGGER_SUPERAR_LIMITE_CREDITO
AFTER INSERT ON PAGOS
FOR EACH ROW
DECLARE
    v_limite_credito NUMBER;
BEGIN
    -- Attempt to select the credit limit for the given client
    BEGIN
        SELECT LIMITECREDITO INTO v_limite_credito
        FROM CLIENTES
        WHERE CODIGOCLIENTE = :NEW.CODIGOCLIENTE;
        DBMS_OUTPUT.PUT_LINE('Limite de credito: ' || v_limite_credito);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20002, 'El cliente con código ' || :NEW.CODIGOCLIENTE || ' no existe.');
    END;

    -- Check if the payment exceeds the credit limit
    IF :NEW.CANTIDAD > v_limite_credito THEN
        BEGIN
            INSERT INTO NOTIFICACIONES (ID_NOTIFICACION, FECHA, DESTINATARIO, MENSAJE)
            VALUES (SEQ_NOTIFICACION.NEXTVAL, SYSDATE, :NEW.CODIGOCLIENTE , 
                    'El cliente con código ' || :NEW.CODIGOCLIENTE || ' ha superado su límite de crédito al realizar un pago.');

            DBMS_OUTPUT.PUT_LINE('El cliente ha superado su límite de crédito.');
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR(-20003, 'Error al insertar en NOTIFICACIONES: ' || SQLERRM);
        END;
    ELSE
        DBMS_OUTPUT.PUT_LINE('El cliente no ha superado su límite de crédito.');
    END IF;
END;
/