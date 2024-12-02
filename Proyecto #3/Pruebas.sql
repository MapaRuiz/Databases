--------------------------------------------------------
--  Procedure to update the price of a product
--------------------------------------------------------

    GRANT EXECUTE ON PROCEDIMIENTOACTUALIZARVALORPRODUCTO TO JPALACIO;
    
    -- Precio de venta original: 14. 
    EXECUTE PROCEDIMIENTOACTUALIZARVALORPRODUCTO('11679', 17);
    
    -- Consulta de prueba de actualización de precio
    SELECT
        "A1"."CODIGOPRODUCTO"  "CODIGOPRODUCTO",
        "A1"."NOMBRE"          "NOMBRE",
        "A1"."GAMA"            "GAMA",
        "A1"."DIMENSIONES"     "DIMENSIONES",
        "A1"."PROVEEDOR"       "PROVEEDOR",
        "A1"."DESCRIPCION"     "DESCRIPCION",
        "A1"."CANTIDADENSTOCK" "CANTIDADENSTOCK",
        "A1"."PRECIOVENTA"     "PRECIOVENTA",
        "A1"."PRECIOPROVEEDOR" "PRECIOPROVEEDOR"
    FROM
        "IS360019"."PRODUCTOS" "A1"
    WHERE
        "A1"."CODIGOPRODUCTO" = '11679';

--------------------------------------------------------
--  Procedure to update the stock
--------------------------------------------------------

    GRANT EXECUTE ON PROCEDIMIENTOACTUALIZARINVENTARIO TO JPALACIO;
    
    -- Cantidad de stock original: 15.
    EXECUTE PROCEDIMIENTOACTUALIZARINVENTARIO('OR-248', 20);
    
    -- Consulta para verificar que el inventario se actualizó correctamente
    SELECT
        "A1"."CODIGOPRODUCTO"  "CODIGOPRODUCTO",
        "A1"."NOMBRE"          "NOMBRE",
        "A1"."GAMA"            "GAMA",
        "A1"."DIMENSIONES"     "DIMENSIONES",
        "A1"."PROVEEDOR"       "PROVEEDOR",
        "A1"."DESCRIPCION"     "DESCRIPCION",
        "A1"."CANTIDADENSTOCK" "CANTIDADENSTOCK",
        "A1"."PRECIOVENTA"     "PRECIOVENTA",
        "A1"."PRECIOPROVEEDOR" "PRECIOPROVEEDOR"
    FROM
        "IS360015"."PRODUCTOS" "A1"
    WHERE
        "A1"."CODIGOPRODUCTO" = 'OR-248';

--------------------------------------------------------
--  Procedure to enter information of order details
--------------------------------------------------------
    
    GRANT EXECUTE ON PROCEDIMIENTODETALLESPEDIDO TO JPALACIO;
    
    -- Eliminación de tuplas
    DELETE FROM DETALLEPEDIDOS WHERE CODIGOPEDIDO = 140;
    DELETE FROM PEDIDOS WHERE CODIGOPEDIDO = 140;
    
    -- Inserción de tuplas para no violar restricciones de llaves
    INSERT INTO PEDIDOS (CODIGOPEDIDO, FECHAPEDIDO, FECHAESPERADA, FECHAENTREGA, ESTADO, CODIGOCLIENTE) VALUES (140, TO_DATE('10/11/08', 'DD/MM/RR'), TO_DATE('10/12/08', 'DD/MM/RR'), TO_DATE('29/12/08', 'DD/MM/RR'), 'Rechazado', 38);
    
    -- Ejecutar procedimiento para insertar detalle de pedido
    EXECUTE PROCEDIMIENTODETALLESPEDIDO(140, 'OR-104', 18, 2, 2);
    
    -- Consulta para verificar inserción
    SELECT
        "A1"."CODIGOPEDIDO"     "CODIGOPEDIDO",
        "A1"."CODIGOPRODUCTO"   "CODIGOPRODUCTO",
        "A1"."CANTIDAD"         "CANTIDAD",
        "A1"."PRECIOUNIDAD"     "PRECIOUNIDAD",
        "A1"."NUMEROLINEA"      "NUMEROLINEA"
    FROM
        "DETALLEPEDIDOS" "A1"
    WHERE
        "A1"."CODIGOPEDIDO" = 140;

--------------------------------------------------------
--  Function to return most ordered product
--------------------------------------------------------        
    
    GRANT EXECUTE ON FUNCIONPRODUCTOMASVENDIDO TO JPALACIO;
    
    -- El producto más vendido es OR-203 con una cantidad de 900000
    SELECT FUNCIONPRODUCTOMASVENDIDO() AS PRODUCTO_MAS_VENDIDO FROM DUAL;
    
--------------------------------------------------------
--  Function to return most ordered category
--------------------------------------------------------        
    
    GRANT EXECUTE ON FUNCIONGAMAMASVENDIDA TO JPALACIO;
    
    -- La gama más vendida son las flores ornamentales a la que pertence el producto OR-203
    SELECT FUNCIONGAMAMASVENDIDA() AS GAMA_MAS_VENDIDA FROM DUAL; 

--------------------------------------------------------
--  Procedure to add new pay form
--------------------------------------------------------        
    
    GRANT EXECUTE ON PROCEDIMIENTOMEDIOPAGO TO JPALACIO;
    
    -- Eliminar resultado de procedimiento
    DELETE FROM PAGOS WHERE CODIGOCLIENTE = 5 AND FORMAPAGO = 'DaviPlata';
    
    -- Prueba con cliente inexistente y cliente correcto
    EXECUTE PROCEDIMIENTOMEDIOPAGO(2, 'NEQUI'); 
    EXECUTE PROCEDIMIENTOMEDIOPAGO(5, 'DaviPlata');
    
    -- Consulta para verificar procedimiento
    SELECT
        "CODIGOCLIENTE" AS "CODIGOCLIENTE",
        "FORMAPAGO" AS "FORMAPAGO",
        "IDTRANSACCION" AS "IDTRANSACCION",
        "FECHAPAGO" AS "FECHAPAGO",
        "CANTIDAD" AS "CANTIDAD"
    FROM
        "PAGOS"
    WHERE
        "CODIGOCLIENTE" = 5;

--------------------------------------------------------
--  Trigger to update the stock
--------------------------------------------------------
    
    -- Eliminar las inserciones anteriores
    DELETE FROM DETALLEPEDIDOS WHERE CODIGOPEDIDO IN (130, 131);
    DELETE FROM PEDIDOS WHERE CODIGOPEDIDO IN (130, 131);
    
    -- Cantidades originales en stock de productos - OR-250: 15, OR-251: 1500
    -- Resultados esperados - Inserción 1 no actualiza stock por estar Reprobado, Inserción 2 no es posible por tener una cantidad superior de productos en pedido que en el stock, Inserción 3 actualiza stock
    INSERT INTO PEDIDOS (CODIGOPEDIDO, FECHAPEDIDO, FECHAESPERADA, FECHAENTREGA, ESTADO, CODIGOCLIENTE) VALUES (130, TO_DATE('10/11/08', 'DD/MM/RR'), TO_DATE('10/12/08', 'DD/MM/RR'), TO_DATE('29/12/08', 'DD/MM/RR'), 'Entregado', 38);
    INSERT INTO PEDIDOS (CODIGOPEDIDO, FECHAPEDIDO, FECHAESPERADA, FECHAENTREGA, ESTADO, CODIGOCLIENTE) VALUES (131, TO_DATE('10/11/08', 'DD/MM/RR'), TO_DATE('10/12/08', 'DD/MM/RR'), TO_DATE('29/12/08', 'DD/MM/RR'), 'Entregado', 38);
    INSERT INTO DETALLEPEDIDOS (CODIGOPEDIDO, CODIGOPRODUCTO, CANTIDAD, PRECIOUNIDAD, NUMEROLINEA) VALUES (130, 'OR-250', 18, 2, 2);
    INSERT INTO DETALLEPEDIDOS (CODIGOPEDIDO, CODIGOPRODUCTO, CANTIDAD, PRECIOUNIDAD, NUMEROLINEA) VALUES (131, 'OR-251', 10, 2, 2);
    
    -- Consulta para verificar que el inventario se actualizó correctamente. Tener en cuenta que al ejecutar varias veces los insert, se resta también el stock el mismo número de veces para OR-251
    SELECT
        "A1"."CODIGOPRODUCTO"  "CODIGOPRODUCTO",
        "A1"."CANTIDADENSTOCK" "CANTIDADENSTOCK"
    FROM
        "IS360015"."PRODUCTOS" "A1"
    WHERE
        "A1"."CODIGOPRODUCTO" = 'OR-251'
        OR "A1"."CODIGOPRODUCTO" = 'OR-250';

--------------------------------------------------------
--  Trigger to verify no employee is its own boss
--------------------------------------------------------

    -- Insert y update donde se intenta crear un empleado que es su propio jefe
    INSERT INTO EMPLEADOS (CODIGOEMPLEADO,NOMBRE,APELLIDO1,APELLIDO2,EXTENSION,EMAIL,CODIGOOFICINA,CODIGOJEFE,PUESTO) VALUES (32,'Juan','Perez','Gomez','2845','jperez@jardineria.es','TAL-ES',32,'Representante Ventas');
    UPDATE EMPLEADOS SET CODIGOJEFE = 1 WHERE CODIGOEMPLEADO = 1;
    
    -- Consulta para verificar que no se crearon
    SELECT 
        E.CODIGOEMPLEADO AS "Codigo Empleado",
        E.NOMBRE AS "Nombre",
        E.APELLIDO1 AS "Apellido1",
        E.APELLIDO2 AS "Apellido2",
        E.EXTENSION AS "Extension",
        E.EMAIL AS "Email",
        E.CODIGOOFICINA AS "Codigo Oficina",
        E.CODIGOJEFE AS "Codigo Jefe",
        E.PUESTO AS "Puesto"
    FROM 
        EMPLEADOS E
    WHERE 
        E.CODIGOEMPLEADO = E.CODIGOJEFE;

--------------------------------------------------------
--  Trigger when creating, updating or deleting an user
--------------------------------------------------------
    
    -- Inserción
    INSERT INTO CLIENTES (CODIGOCLIENTE,NOMBRECLIENTE,NOMBRECONTACTO,APELLIDOCONTACTO,TELEFONO,FAX,LINEADIRECCION1,LINEADIRECCION2,CIUDAD,REGION,PAIS,CODIGOPOSTAL,CODIGOEMPLEADOREPVENTAS,LIMITECREDITO) VALUES (50,'DGPRODUCTIONS GARDEN','Daniel G','GoldFish','5556901745','5556901746','False Street 52 2 A','Wall-e Avenue','San Francisco','Wall-e Avenue','USA','24006',19,3000);
        
    -- Actualización
    UPDATE CLIENTES SET NOMBRECLIENTE = 'DagobertoSAS' WHERE CODIGOCLIENTE = 50;
        
    -- Eliminación
    DELETE FROM CLIENTES WHERE CODIGOCLIENTE = 50;
        
    -- Consulta para ver el log
    SELECT 
        "ID_AUDITORIA" AS ID_AUDITORIA,
        "CODIGOCLIENTE" AS CODIGOCLIENTE,
        "NOMBRE_ANTERIOR" AS NOMBRE_ANTERIOR,
        "NOMBRE_NUEVO" AS NOMBRE_NUEVO,
        "APELLIDO_ANTERIOR" AS APELLIDO_ANTERIOR,
        "APELLIDO_NUEVO" AS APELLIDO_NUEVO,
        "FECHA_MODIFICACION" AS FECHA_MODIFICACION,
        "USUARIO_MODIFICADOR" AS USUARIO_MODIFICADOR
    FROM 
        CLIENTES_LOG;

--------------------------------------------------------
--  Trigger when creating, updating or deleting an order
--------------------------------------------------------

    -- Inserción
    INSERT INTO PEDIDOS (CODIGOPEDIDO, FECHAPEDIDO, FECHAESPERADA, FECHAENTREGA, ESTADO, CODIGOCLIENTE) VALUES (155, SYSDATE, SYSDATE+5, SYSDATE+10, 'Pendiente', 30);
        
    -- Actualización
    UPDATE PEDIDOS SET ESTADO = 'Entregado' WHERE CODIGOPEDIDO = 155;
        
    -- Eliminación
    DELETE FROM PEDIDOS WHERE CODIGOPEDIDO = 155;
        
    -- Consulta para ver el log
    SELECT 
        "ID_AUDITORIA" AS ID_AUDITORIA,
        "CODIGOPEDIDO" AS CODIGOPEDIDO,
        "FECHA_MODIFICACION" AS FECHA_MODIFICACION,
        "USUARIO_MODIFICADOR" AS USUARIO_MODIFICADOR,
        "ESTADO_ANTERIOR" AS ESTADO_ANTERIOR,
        "ESTADO_NUEVO" AS ESTADO_NUEVO
    FROM 
        PEDIDOS_LOG;   

--------------------------------------------------------
--  Procedure to update the total value of an order
-------------------------------------------------------- 

    GRANT EXECUTE ON PROCEDIMIENTOACTUALIZARVALORTOTALPEDIDO TO JPALACIO;
    
    EXECUTE PROCEDIMIENTOCALCULARTOTALPEDIDO(1);
    
    -- Consulta para visualizar valor total del pedido
    SELECT 
        "CODIGOPEDIDO" AS codigo_pedido,
        "VALORTOTAL" AS valor_total,
        "CODIGOPRODUCTO" AS codigo_producto,
        "CANTIDAD" AS cantidad,
        "PRECIOUNIDAD" AS precio_unidad,
        "NUMEROLINEA" AS numero_linea
    FROM 
        DETALLEPEDIDOS
    WHERE 
        "CODIGOPEDIDO" = 1;

--------------------------------------------------------
--  Procedure to get the total value of all orders
-------------------------------------------------------- 
    
    GRANT EXECUTE ON PROCEDIMIENTOCALCULARTOTALPEDIDOSUMA TO JPALACIO;
    
    EXECUTE PROCEDIMIENTOCALCULARTOTALPEDIDOSUMA;

--------------------------------------------------------
--  Trigger to automatically calculate total of an order
-------------------------------------------------------- 

    DELETE FROM DETALLEPEDIDOS WHERE CODIGOPEDIDO = 127 AND CODIGOPRODUCTO = 'OR-150';
    INSERT INTO DETALLEPEDIDOS (CODIGOPEDIDO,CODIGOPRODUCTO,CANTIDAD,PRECIOUNIDAD,NUMEROLINEA) values (127,'OR-150',18,2,2);
    
    -- Consulta para verificar cálculo
    SELECT 
        "CODIGOPEDIDO" AS "Codigo_Pedido",
        "VALORTOTAL" AS "Valor_Total",
        "CODIGOPRODUCTO" AS "Codigo_Producto",
        "CANTIDAD" AS "Cantidad",
        "PRECIOUNIDAD" AS "Precio_Unidad",
        "NUMEROLINEA" AS "Numero_Linea"
    FROM 
        "DETALLEPEDIDOS"
    WHERE 
        "CODIGOPEDIDO" = 127;

--------------------------------------------------------
--  Trigger to verify sale price is at least 10% greater than suplier price
-------------------------------------------------------- 

    -- Precio de venta: 11, por lo que debe dar error
    UPDATE PRODUCTOS SET PRECIOVENTA = 12 WHERE CODIGOPRODUCTO = 'OR-99';
    
----------------------------------------------------------
-- Trigger to verify non-Empty Inventory
---------------------------------------------------------

    -- Excede el stock    
    DELETE FROM PRODUCTOS WHERE CODIGOPRODUCTO = 'OR-137';
    
    INSERT INTO PRODUCTOS (CODIGOPRODUCTO, NOMBRE, GAMA, DIMENSIONES, PROVEEDOR, CANTIDADENSTOCK, PRECIOVENTA, PRECIOPROVEEDOR)
    VALUES ('OR-137', 'ROSAL TREPADOR', 'Ornamentales', NULL, 'Viveros EL OASIS', 100, 4, 3);

    -- No excede el stock
    DELETE FROM DETALLEPEDIDOS WHERE CODIGOPEDIDO = 1;
     
    INSERT INTO DETALLEPEDIDOS (CODIGOPEDIDO, CODIGOPRODUCTO, CANTIDAD, PRECIOUNIDAD, NUMEROLINEA)
    VALUES (1, 'OR-137', 150, 4, 1);

---------------------------------------------------
-- Trigger to verify if the product is in a range with discount
---------------------------------------------------

    DELETE FROM DETALLEPEDIDOS WHERE CODIGOPEDIDO = 1 AND CODIGOPRODUCTO = 'OR-137';
    
    INSERT INTO PRODUCTOS (CODIGOPRODUCTO, NOMBRE, GAMA, DIMENSIONES, PROVEEDOR, CANTIDADENSTOCK, PRECIOVENTA, PRECIOPROVEEDOR)
    VALUES ('OR-137', 'ROSAL TREPADOR', 'Ornamentales', NULL, 'Viveros EL OASIS', 100, 4, 3);
    INSERT INTO DETALLEPEDIDOS (CODIGOPEDIDO, CODIGOPRODUCTO, CANTIDAD, PRECIOUNIDAD, NUMEROLINEA)
    VALUES (1, 'OR-137', 10, 4, 1);
    
    -- Para este producto hay un descuento del 15 pq es ornamentales el precio por unidad es de 4 por lo tanto el precio unidad es de 3.4 con descuento gracias al trigger.
    
    SELECT 
        CODIGOPEDIDO AS Codigo_Pedido,
        CODIGOPRODUCTO AS Codigo_Producto,
        CANTIDAD AS Cantidad,
        PRECIOUNIDAD AS Precio_Unidad,
        NUMEROLINEA AS Numero_Linea
    FROM 
        DETALLEPEDIDOS
    WHERE 
        CODIGOPEDIDO = 1;
        
-----------------------------------------------------------
-- Trigger to verify strict control of the available quantity of products
-----------------------------------------------------------
    DELETE FROM DETALLEPEDIDOS WHERE CODIGOPEDIDO = 1 AND CODIGOPRODUCTO = 'OR-137';
    
    -- Falla por insuficiente inventario
    INSERT INTO DETALLEPEDIDOS (CODIGOPEDIDO, CODIGOPRODUCTO, CANTIDAD, PRECIOUNIDAD, NUMEROLINEA)
    VALUES (1, 'OR-137', 150, 4, 1); 
    
-----------------------------------------------------------
-- Trigger to verify automatically update quantity available in inventory
-----------------------------------------------------------

    DELETE FROM DETALLEPEDIDOS WHERE CODIGOPEDIDO = 1 AND CODIGOPRODUCTO = 'OR-137';
    INSERT INTO DETALLEPEDIDOS (CODIGOPEDIDO, CODIGOPRODUCTO, CANTIDAD, PRECIOUNIDAD, NUMEROLINEA)
    VALUES (1, 'OR-137', 20, 4, 1);
    
    SELECT CODIGOPRODUCTO, CANTIDADENSTOCK
    FROM PRODUCTOS
    WHERE CODIGOPRODUCTO = 'OR-137';

-------------------------------------------------
-- Trigger to verify that in case a client registers a payment and this exceed the credit limit make a registration of a notification
-------------------------------------------------
    
    DELETE FROM PAGOS WHERE CODIGOCLIENTE = 1; 
    
    INSERT INTO PAGOS (CODIGOCLIENTE, FORMAPAGO, IDTRANSACCION, FECHAPAGO, CANTIDAD)
    VALUES (1, 'Efectivo', 'ak-std-00000100', SYSDATE, 100000);
    
    SELECT ID_NOTIFICACION,
        FECHA,
        DESTINATARIO,
        MENSAJE 
    FROM NOTIFICACIONES;