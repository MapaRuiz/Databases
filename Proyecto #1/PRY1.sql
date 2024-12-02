--Eliminación de relaciones entre tablas con POLIZA
ALTER TABLE POLIZA DROP CONSTRAINT fk_poliza_tipo_cubrimiento;
ALTER TABLE POLIZA DROP CONSTRAINT fk_poliza_tomador;

--Eliminación de relaciones entre tablas con TOMADOR
ALTER TABLE TOMADOR DROP CONSTRAINT fk_tomador_departamento;

-- Eliminación de tablas
DROP TABLE POLIZA;
DROP TABLE TIPO_CUBRIMIENTO;
DROP TABLE TOMADOR;
DROP TABLE DEPARTAMENTO;

--Creación de tablas e inserción de valores
CREATE TABLE DEPARTAMENTO (
    ID NUMBER(10,0) GENERATED ALWAYS AS IDENTITY,
    NOMBRE VARCHAR2(100) UNIQUE NOT NULL,
    PORCENTAJE NUMBER(5,2) NOT NULL,
    CONSTRAINT pk_departamento PRIMARY KEY (ID)
);

INSERT INTO DEPARTAMENTO (NOMBRE, PORCENTAJE) VALUES ('Antioquia', 0.15);
INSERT INTO DEPARTAMENTO (NOMBRE, PORCENTAJE) VALUES ('Atlántico', 0.12);
INSERT INTO DEPARTAMENTO (NOMBRE, PORCENTAJE) VALUES ('Valle del Cauca', 0.18);
INSERT INTO DEPARTAMENTO (NOMBRE, PORCENTAJE) VALUES ('Cundinamarca', 0.13);
INSERT INTO DEPARTAMENTO (NOMBRE, PORCENTAJE) VALUES ('Santander', 0.17);
INSERT INTO DEPARTAMENTO (NOMBRE, PORCENTAJE) VALUES ('Bolívar', 0.14);
INSERT INTO DEPARTAMENTO (NOMBRE, PORCENTAJE) VALUES ('Boyacá', 0.16);
INSERT INTO DEPARTAMENTO (NOMBRE, PORCENTAJE) VALUES ('Nariño', 0.12);
INSERT INTO DEPARTAMENTO (NOMBRE, PORCENTAJE) VALUES ('Tolima', 0.15);
INSERT INTO DEPARTAMENTO (NOMBRE, PORCENTAJE) VALUES ('Córdoba', 0.18);
INSERT INTO DEPARTAMENTO (NOMBRE, PORCENTAJE) VALUES ('Meta', 0.13);
INSERT INTO DEPARTAMENTO (NOMBRE, PORCENTAJE) VALUES ('Huila', 0.16);
INSERT INTO DEPARTAMENTO (NOMBRE, PORCENTAJE) VALUES ('Cesar', 0.14);
INSERT INTO DEPARTAMENTO (NOMBRE, PORCENTAJE) VALUES ('Magdalena', 0.17);
INSERT INTO DEPARTAMENTO (NOMBRE, PORCENTAJE) VALUES ('Sucre', 0.15);

CREATE TABLE TOMADOR (
    ID NUMBER(10,0) GENERATED ALWAYS AS IDENTITY,
    CEDULA VARCHAR2(20) UNIQUE NOT NULL,
    NOMBRE VARCHAR2(100) NOT NULL,
    GENERO VARCHAR2(10) NOT NULL CHECK (GENERO IN ('masculino', 'femenino')),
    EDAD NUMBER(3,0) NOT NULL CHECK (EDAD BETWEEN 18 AND 100),
    IDDEPARTAMENTO NUMBER(10,0) NOT NULL,
    CONSTRAINT pk_tomador PRIMARY KEY (ID),
    CONSTRAINT fk_tomador_departamento FOREIGN KEY (IDDEPARTAMENTO) REFERENCES DEPARTAMENTO(ID)
);

INSERT INTO TOMADOR (CEDULA, NOMBRE, GENERO, EDAD, IDDEPARTAMENTO) VALUES ('1234567890', 'Juan Pérez', 'masculino', 30, 1);
INSERT INTO TOMADOR (CEDULA, NOMBRE, GENERO, EDAD, IDDEPARTAMENTO) VALUES ('521478963', 'Carla Espinosa', 'femenino', 27, 1);
INSERT INTO TOMADOR (CEDULA, NOMBRE, GENERO, EDAD, IDDEPARTAMENTO) VALUES ('9876543210', 'María López', 'femenino', 25, 2);
INSERT INTO TOMADOR (CEDULA, NOMBRE, GENERO, EDAD, IDDEPARTAMENTO) VALUES ('789654123', 'Luis Alberto Ruiz', 'masculino', 31, 2);
INSERT INTO TOMADOR (CEDULA, NOMBRE, GENERO, EDAD, IDDEPARTAMENTO) VALUES ('321456987', 'Elena Nito del Bosque', 'femenino', 24, 3);
INSERT INTO TOMADOR (CEDULA, NOMBRE, GENERO, EDAD, IDDEPARTAMENTO) VALUES ('1357924680', 'Pedro Gómez', 'masculino', 40, 3);
INSERT INTO TOMADOR (CEDULA, NOMBRE, GENERO, EDAD, IDDEPARTAMENTO) VALUES ('2468013579', 'Ana Martínez', 'femenino', 35, 4);
INSERT INTO TOMADOR (CEDULA, NOMBRE, GENERO, EDAD, IDDEPARTAMENTO) VALUES ('9871234560', 'Luisa Rodríguez', 'femenino', 45, 5);
INSERT INTO TOMADOR (CEDULA, NOMBRE, GENERO, EDAD, IDDEPARTAMENTO) VALUES ('6547893210', 'Carlos García', 'masculino', 55, 6);
INSERT INTO TOMADOR (CEDULA, NOMBRE, GENERO, EDAD, IDDEPARTAMENTO) VALUES ('1239876540', 'Sofía Ramírez', 'femenino', 22, 7);
INSERT INTO TOMADOR (CEDULA, NOMBRE, GENERO, EDAD, IDDEPARTAMENTO) VALUES ('7894561230', 'Jorge Pérez', 'masculino', 28, 8);
INSERT INTO TOMADOR (CEDULA, NOMBRE, GENERO, EDAD, IDDEPARTAMENTO) VALUES ('3692581470', 'Diana Sánchez', 'femenino', 33, 9);
INSERT INTO TOMADOR (CEDULA, NOMBRE, GENERO, EDAD, IDDEPARTAMENTO) VALUES ('8527419630', 'Miguel López', 'masculino', 50, 10);
INSERT INTO TOMADOR (CEDULA, NOMBRE, GENERO, EDAD, IDDEPARTAMENTO) VALUES ('1478523690', 'Laura González', 'femenino', 60, 11);
INSERT INTO TOMADOR (CEDULA, NOMBRE, GENERO, EDAD, IDDEPARTAMENTO) VALUES ('2589631470', 'Alejandro Ruiz', 'masculino', 42, 12);
INSERT INTO TOMADOR (CEDULA, NOMBRE, GENERO, EDAD, IDDEPARTAMENTO) VALUES ('3691472580', 'Paula Herrera', 'femenino', 29, 13);
INSERT INTO TOMADOR (CEDULA, NOMBRE, GENERO, EDAD, IDDEPARTAMENTO) VALUES ('4563219870', 'Andrés Castro', 'masculino', 38, 14);
INSERT INTO TOMADOR (CEDULA, NOMBRE, GENERO, EDAD, IDDEPARTAMENTO) VALUES ('1597538520', 'Gabriela Gómez', 'femenino', 26, 15);
INSERT INTO TOMADOR (CEDULA, NOMBRE, GENERO, EDAD, IDDEPARTAMENTO) VALUES ('800123456', 'Sofia Castro', 'femenino', 30, 3);
INSERT INTO TOMADOR (CEDULA, NOMBRE, GENERO, EDAD, IDDEPARTAMENTO) VALUES ('800654321', 'Miguel Ángel Torres', 'masculino', 34, 6);
INSERT INTO TOMADOR (CEDULA, NOMBRE, GENERO, EDAD, IDDEPARTAMENTO) VALUES ('801234567', 'Diana Carolina Ruiz', 'femenino', 29, 9);
INSERT INTO TOMADOR (CEDULA, NOMBRE, GENERO, EDAD, IDDEPARTAMENTO) VALUES ('809876543', 'José Manuel Gómez', 'masculino', 45, 12);


CREATE TABLE TIPO_CUBRIMIENTO (
    ID NUMBER(10,0) GENERATED ALWAYS AS IDENTITY,
    NOMBRE VARCHAR2(100) UNIQUE NOT NULL,
    PORCENTAJE NUMBER(5,2) NOT NULL,
    CONSTRAINT pk_tipo_cubrimiento PRIMARY KEY (ID)
);

INSERT INTO TIPO_CUBRIMIENTO (NOMBRE, PORCENTAJE) VALUES ('Cumplimiento de contrato', 0.5);
INSERT INTO TIPO_CUBRIMIENTO (NOMBRE, PORCENTAJE) VALUES ('Cumplimiento de obra', 0.62);
INSERT INTO TIPO_CUBRIMIENTO (NOMBRE, PORCENTAJE) VALUES ('Calidad del servicio', 0.48);
INSERT INTO TIPO_CUBRIMIENTO (NOMBRE, PORCENTAJE) VALUES ('Riesgos laborales', 0.73);
INSERT INTO TIPO_CUBRIMIENTO (NOMBRE, PORCENTAJE) VALUES ('Daños materiales', 0.65);
INSERT INTO TIPO_CUBRIMIENTO (NOMBRE, PORCENTAJE) VALUES ('Robo y hurto', 0.81);
INSERT INTO TIPO_CUBRIMIENTO (NOMBRE, PORCENTAJE) VALUES ('Responsabilidad civil', 0.59);
INSERT INTO TIPO_CUBRIMIENTO (NOMBRE, PORCENTAJE) VALUES ('Incendio', 0.7);
INSERT INTO TIPO_CUBRIMIENTO (NOMBRE, PORCENTAJE) VALUES ('Inundación', 0.64);
INSERT INTO TIPO_CUBRIMIENTO (NOMBRE, PORCENTAJE) VALUES ('Terremoto', 0.92);
INSERT INTO TIPO_CUBRIMIENTO (NOMBRE, PORCENTAJE) VALUES ('Atentado terrorista', 0.87);
INSERT INTO TIPO_CUBRIMIENTO (NOMBRE, PORCENTAJE) VALUES ('Perdida de lucro cesante', 0.54);
INSERT INTO TIPO_CUBRIMIENTO (NOMBRE, PORCENTAJE) VALUES ('Gastos médicos', 0.68);
INSERT INTO TIPO_CUBRIMIENTO (NOMBRE, PORCENTAJE) VALUES ('Asistencia jurídica', 0.75);
INSERT INTO TIPO_CUBRIMIENTO (NOMBRE, PORCENTAJE) VALUES ('Cancelación de viaje', 0.46);

CREATE TABLE POLIZA (
    ID NUMBER(10,0) GENERATED ALWAYS AS IDENTITY,
    numero VARCHAR2(100) UNIQUE NOT NULL,
    valorasegurable NUMBER(10,2) DEFAULT 0 NOT NULL CHECK (valorasegurable >= 0),
    idtipocubrimiento NUMBER(10,0) NOT NULL,
    idtomador NUMBER(10,0) NOT NULL,
    fechainicio DATE NOT NULL,
    fechafin DATE NOT NULL,
    CONSTRAINT pk_poliza PRIMARY KEY (ID),
    CONSTRAINT fk_poliza_tipo_cubrimiento FOREIGN KEY (idtipocubrimiento) REFERENCES TIPO_CUBRIMIENTO(ID),
    CONSTRAINT fk_poliza_tomador FOREIGN KEY (idtomador) REFERENCES TOMADOR(ID)
);

INSERT INTO POLIZA (numero, valorasegurable, idtipocubrimiento, idtomador, fechainicio, fechafin)
VALUES ('P001', 5000, 1, 1, TO_DATE('2024-03-01', 'YYYY-MM-DD'), TO_DATE('2024-09-01', 'YYYY-MM-DD'));

INSERT INTO POLIZA (numero, valorasegurable, idtipocubrimiento, idtomador, fechainicio, fechafin)
VALUES ('P002', 7500, 2, 2, TO_DATE('2024-04-15', 'YYYY-MM-DD'), TO_DATE('2024-10-15', 'YYYY-MM-DD'));

INSERT INTO POLIZA (numero, valorasegurable, idtipocubrimiento, idtomador, fechainicio, fechafin)
VALUES ('P003', 6000, 3, 3, TO_DATE('2024-05-20', 'YYYY-MM-DD'), TO_DATE('2024-11-20', 'YYYY-MM-DD'));

INSERT INTO POLIZA (numero, valorasegurable, idtipocubrimiento, idtomador, fechainicio, fechafin)
VALUES ('P004', 5500, 4, 4, TO_DATE('2024-06-25', 'YYYY-MM-DD'), TO_DATE('2024-12-25', 'YYYY-MM-DD'));

INSERT INTO POLIZA (numero, valorasegurable, idtipocubrimiento, idtomador, fechainicio, fechafin)
VALUES ('P005', 7000, 5, 5, TO_DATE('2024-07-30', 'YYYY-MM-DD'), TO_DATE('2025-01-30', 'YYYY-MM-DD'));

INSERT INTO POLIZA (numero, valorasegurable, idtipocubrimiento, idtomador, fechainicio, fechafin)
VALUES ('P006', 6500, 6, 6, TO_DATE('2024-08-05', 'YYYY-MM-DD'), TO_DATE('2025-02-05', 'YYYY-MM-DD'));

INSERT INTO POLIZA (numero, valorasegurable, idtipocubrimiento, idtomador, fechainicio, fechafin)
VALUES ('P007', 8000, 7, 7, TO_DATE('2024-09-10', 'YYYY-MM-DD'), TO_DATE('2025-03-10', 'YYYY-MM-DD'));

INSERT INTO POLIZA (numero, valorasegurable, idtipocubrimiento, idtomador, fechainicio, fechafin)
VALUES ('P008', 4500, 8, 8, TO_DATE('2024-10-15', 'YYYY-MM-DD'), TO_DATE('2025-04-15', 'YYYY-MM-DD'));

INSERT INTO POLIZA (numero, valorasegurable, idtipocubrimiento, idtomador, fechainicio, fechafin)
VALUES ('P009', 8500, 9, 9, TO_DATE('2024-11-20', 'YYYY-MM-DD'), TO_DATE('2025-05-20', 'YYYY-MM-DD'));

INSERT INTO POLIZA (numero, valorasegurable, idtipocubrimiento, idtomador, fechainicio, fechafin)
VALUES ('P010', 5000, 10, 10, TO_DATE('2024-12-25', 'YYYY-MM-DD'), TO_DATE('2025-06-25', 'YYYY-MM-DD'));

INSERT INTO POLIZA (numero, valorasegurable, idtipocubrimiento, idtomador, fechainicio, fechafin)
VALUES ('P011', 6000, 11, 11, TO_DATE('2025-01-30', 'YYYY-MM-DD'), TO_DATE('2025-07-30', 'YYYY-MM-DD'));

INSERT INTO POLIZA (numero, valorasegurable, idtipocubrimiento, idtomador, fechainicio, fechafin)
VALUES ('P012', 7000, 12, 12, TO_DATE('2025-02-05', 'YYYY-MM-DD'), TO_DATE('2025-08-05', 'YYYY-MM-DD'));

INSERT INTO POLIZA (numero, valorasegurable, idtipocubrimiento, idtomador, fechainicio, fechafin)
VALUES ('P013', 5500, 13, 13, TO_DATE('2025-03-10', 'YYYY-MM-DD'), TO_DATE('2025-09-10', 'YYYY-MM-DD'));

INSERT INTO POLIZA (numero, valorasegurable, idtipocubrimiento, idtomador, fechainicio, fechafin)
VALUES ('P014', 7500, 14, 14, TO_DATE('2025-04-15', 'YYYY-MM-DD'), TO_DATE('2025-10-15', 'YYYY-MM-DD'));

INSERT INTO POLIZA (numero, valorasegurable, idtipocubrimiento, idtomador, fechainicio, fechafin)
VALUES ('P015', 6500, 15, 15, TO_DATE('2025-05-20', 'YYYY-MM-DD'), TO_DATE('2025-11-20', 'YYYY-MM-DD'));

INSERT INTO POLIZA (numero, valorasegurable, idtipocubrimiento, idtomador, fechainicio, fechafin)
VALUES ('P016', 150000, 1, 1, TO_DATE('2024-02-01', 'YYYY-MM-DD'), TO_DATE('2024-12-31', 'YYYY-MM-DD'));

INSERT INTO POLIZA (numero, valorasegurable, idtipocubrimiento, idtomador, fechainicio, fechafin)
VALUES ('P017', 160000, 2, 1, TO_DATE('2024-03-01', 'YYYY-MM-DD'), TO_DATE('2024-12-31', 'YYYY-MM-DD'));

INSERT INTO POLIZA (numero, valorasegurable, idtipocubrimiento, idtomador, fechainicio, fechafin)
VALUES ('P018', 170000, 3, 1, TO_DATE('2024-04-01', 'YYYY-MM-DD'), TO_DATE('2024-12-31', 'YYYY-MM-DD'));

INSERT INTO POLIZA (numero, valorasegurable, idtipocubrimiento, idtomador, fechainicio, fechafin)
VALUES ('P019', 180000, 4, 1, TO_DATE('2024-05-01', 'YYYY-MM-DD'), TO_DATE('2024-12-31', 'YYYY-MM-DD'));

INSERT INTO POLIZA (numero, valorasegurable, idtipocubrimiento, idtomador, fechainicio, fechafin)
VALUES ('P020', 190000, 5, 1, TO_DATE('2024-06-01', 'YYYY-MM-DD'), TO_DATE('2024-12-31', 'YYYY-MM-DD'));

INSERT INTO POLIZA (numero, valorasegurable, idtipocubrimiento, idtomador, fechainicio, fechafin)
VALUES ('P021', 200000, 6, 1, TO_DATE('2024-07-01', 'YYYY-MM-DD'), TO_DATE('2024-12-31', 'YYYY-MM-DD'));

INSERT INTO POLIZA (numero, valorasegurable, idtipocubrimiento, idtomador, fechainicio, fechafin)
VALUES ('P022', 210000, 7, 1, TO_DATE('2024-08-01', 'YYYY-MM-DD'), TO_DATE('2024-12-31', 'YYYY-MM-DD'));

INSERT INTO POLIZA (numero, valorasegurable, idtipocubrimiento, idtomador, fechainicio, fechafin)
VALUES ('P023', 220000, 8, 1, TO_DATE('2024-09-01', 'YYYY-MM-DD'), TO_DATE('2024-12-31', 'YYYY-MM-DD'));

INSERT INTO POLIZA (numero, valorasegurable, idtipocubrimiento, idtomador, fechainicio, fechafin)
VALUES ('P024', 230000, 9, 1, TO_DATE('2024-10-01', 'YYYY-MM-DD'), TO_DATE('2024-12-31', 'YYYY-MM-DD'));

INSERT INTO POLIZA (numero, valorasegurable, idtipocubrimiento, idtomador, fechainicio, fechafin)
VALUES ('P025', 240000, 10, 1, TO_DATE('2024-11-01', 'YYYY-MM-DD'), TO_DATE('2024-12-31', 'YYYY-MM-DD'));

INSERT INTO POLIZA (numero, valorasegurable, idtipocubrimiento, idtomador, fechainicio, fechafin)
VALUES ('P026', 250000, 11, 1, TO_DATE('2024-12-01', 'YYYY-MM-DD'), TO_DATE('2024-12-31', 'YYYY-MM-DD'));

INSERT INTO POLIZA (numero, valorasegurable, idtipocubrimiento, idtomador, fechainicio, fechafin)
VALUES ('P027', 260000, 12, 1, TO_DATE('2025-01-01', 'YYYY-MM-DD'), TO_DATE('2025-12-31', 'YYYY-MM-DD'));

INSERT INTO POLIZA (numero, valorasegurable, idtipocubrimiento, idtomador, fechainicio, fechafin)
VALUES ('P028', 270000, 13, 1, TO_DATE('2025-02-01', 'YYYY-MM-DD'), TO_DATE('2025-12-31', 'YYYY-MM-DD'));

INSERT INTO POLIZA (numero, valorasegurable, idtipocubrimiento, idtomador, fechainicio, fechafin)
VALUES ('P029', 280000, 14, 1, TO_DATE('2025-03-01', 'YYYY-MM-DD'), TO_DATE('2025-12-31', 'YYYY-MM-DD'));

INSERT INTO POLIZA (numero, valorasegurable, idtipocubrimiento, idtomador, fechainicio, fechafin)
VALUES ('P030', 290000, 15, 1, TO_DATE('2025-04-01', 'YYYY-MM-DD'), TO_DATE('2025-12-31', 'YYYY-MM-DD'));

--Consultas
//Punto 1
DROP VIEW vista_valor_poliza;

CREATE VIEW vista_valor_poliza AS
    SELECT p.ID AS id_poliza,
           SUM(p.valorasegurable * (1 + tc.PORCENTAJE + d.PORCENTAJE)) AS valor_total
    FROM POLIZA p
    JOIN TIPO_CUBRIMIENTO tc ON p.idtipocubrimiento = tc.ID
    JOIN TOMADOR t ON p.idtomador = t.ID
    JOIN DEPARTAMENTO d ON t.IDDEPARTAMENTO = d.ID
    GROUP BY p.ID
    ORDER BY id_poliza;

//Punto 2
DROP VIEW vista_datos_poliza;

CREATE VIEW vista_datos_poliza AS

    SELECT 
        T.NOMBRE AS NOMBRE_TOMADOR,
        TC.NOMBRE AS NOMBRE_TIPO_CUBRIMIENTO,
        D.NOMBRE AS NOMBRE_DEPARTAMENTO,
        P.NUMERO AS NUMERO_POLIZA,
        V.VALOR_TOTAL AS VALOR_POLIZA
    FROM 
        TOMADOR T
        JOIN vista_valor_poliza V ON V.id_poliza = T.id
        LEFT JOIN POLIZA P ON T.ID = P.IDTOMADOR
        LEFT JOIN TIPO_CUBRIMIENTO TC ON P.IDTIPOCUBRIMIENTO = TC.ID
        LEFT JOIN DEPARTAMENTO D ON T.IDDEPARTAMENTO = D.ID;

//Punto 3
DROP VIEW vista_valor_tomador;

CREATE VIEW vista_valor_tomador AS
    SELECT 
        COALESCE(T.NOMBRE, 'TOTAL') AS NOMBRE_TOMADOR,
        SUM(P.VALORASEGURABLE) AS TOTAL_ASEGURABLE,
        SUM(V.valor_total) AS TOTAL_POLIZAS
    FROM 
        TOMADOR T
        JOIN vista_valor_poliza V ON V.id_poliza = T.id
        JOIN POLIZA P ON T.ID = P.IDTOMADOR
    GROUP BY ROLLUP (T.NOMBRE);

//Punto 4
DROP VIEW vista_total_mes_y_año;

CREATE VIEW vista_total_mes_y_año AS
    SELECT 
        EXTRACT(YEAR FROM fechafin) AS AñoVencimiento,
        EXTRACT(MONTH FROM fechafin) AS MesVencimiento,
        SUM(valorasegurable) AS TotalMes,
        SUM(SUM(valorasegurable)) OVER (PARTITION BY EXTRACT(YEAR FROM fechafin)) AS TotalAño
    FROM POLIZA
    GROUP BY EXTRACT(YEAR FROM fechafin), EXTRACT(MONTH FROM fechafin)
    ORDER BY AñoVencimiento, MesVencimiento;

//Punto 5
DROP VIEW vista_participacion_departamento;

CREATE VIEW vista_participacion_departamento AS
    SELECT 
        DEPARTAMENTO.nombre,
        COUNT(TOMADOR.ID) AS TotalTomadores,
        (COUNT(TOMADOR.ID) * 100.0 / (SELECT COUNT(*) FROM TOMADOR)) AS PorcentajeParticipacion
    FROM DEPARTAMENTO
    JOIN TOMADOR ON TOMADOR.IDDEPARTAMENTO = DEPARTAMENTO.ID
    GROUP BY DEPARTAMENTO.nombre;

//Punto 6
DROP VIEW vista_persona_todos_cubrimientos;

CREATE VIEW vista_persona_todos_cubrimientos AS
    WITH TOTAL AS 
    (SELECT COUNT(ID) AS Total
    FROM TIPO_CUBRIMIENTO)
    
    SELECT O.nombre
    FROM 
        TOMADOR O, 
        (SELECT ID
        FROM 
            TOTAL, 
            (SELECT T.id, count(DISTINCT P.idtipocubrimiento) AS TT 
            FROM TOMADOR T 
            INNER JOIN POLIZA P ON T.ID = P.IDTOMADOR 
            GROUP BY T.ID)
        WHERE TOTAL.Total = TT) E
    WHERE O.id = E.ID;
    
//Punto 7: modo mapa
DROP VIEW vista_tabla;

CREATE VIEW vista_tabla AS
    WITH TCONTAR AS (
        SELECT
            D.NOMBRE AS DPTOS,
            SUM(CASE WHEN T.GENERO = 'femenino' THEN 1 ELSE 0 END) AS CMUJERES,
            SUM(CASE WHEN T.GENERO = 'masculino' THEN 1 ELSE 0 END) AS CHOMBRES,
            COUNT(T.ID) AS CTOTALDPTO
        FROM DEPARTAMENTO D
        INNER JOIN TOMADOR T ON D.ID = T.IDDEPARTAMENTO
        GROUP BY D.NOMBRE),
        
    TSUMAR AS (
        SELECT
            'TOTAL' AS TOTAL,
            SUM(CMUJERES) AS TOTALM,
            SUM(CHOMBRES) AS TOTALH,
            SUM(CTOTALDPTO) AS TOTALT
        FROM TCONTAR)
            
    SELECT
        DPTOS,
        CMUJERES,
        CHOMBRES,
        CTOTALDPTO
    FROM TCONTAR
    UNION ALL
    SELECT
        TOTAL,
        TOTALM,
        TOTALH,
        TOTALT
    FROM
        TSUMAR;

--Privilegios
GRANT SELECT ON vista_valor_poliza TO JPALACIO;
GRANT SELECT ON vista_datos_poliza TO JPALACIO;
GRANT SELECT ON vista_valor_tomador TO JPALACIO;
GRANT SELECT ON vista_total_mes_y_año TO JPALACIO;
GRANT SELECT ON vista_participacion_departamento TO JPALACIO;
GRANT SELECT ON vista_persona_todos_cubrimientos TO JPALACIO;
GRANT SELECT ON vista_tabla TO JPALACIO;