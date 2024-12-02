-- Eliminación de tablas
DROP TABLE Cobertura_Poliza;
DROP TABLE Cobertura;
DROP TABLE Poliza;
DROP TABLE Etapa_Reclamo_Negado;
DROP TABLE Etapa_Reclamo_Parcial;
DROP TABLE Reclamo_Negado;
DROP TABLE Reclamo_Parcial;
DROP TABLE Reclamo_Aprobado;
DROP TABLE Reclamos_Consecutivos;
DROP TABLE Reclamo;
DROP TABLE Cita;
DROP TABLE Alergias_Paciente;
DROP TABLE Vinculo_Paciente;
DROP TABLE Paciente;
DROP TABLE Vinculo;
DROP TABLE Motivo_No_Pago;
DROP TABLE Compania_Seguro;
DROP TABLE Motivo_Cita;
DROP TABLE Titulo_Miembro;
DROP TABLE Titulo;
DROP TABLE Etapa;
DROP TABLE Miembro_Personal;
DROP TABLE Alergia;

-- Creación de tablas
CREATE TABLE Miembro_Personal (
    cedula INT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    sexo VARCHAR(255) NOT NULL,
    direccion VARCHAR(255) NOT NULL,
    cargo VARCHAR(255) NOT NULL,
    CONSTRAINT chk_sexo CHECK (sexo IN ('Masculino', 'Femenino'))
);

CREATE TABLE Titulo (
    titulo_id VARCHAR(255) PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE Titulo_Miembro (
    titulo_id VARCHAR(255) NOT NULL,
    cedula INT NOT NULL,
    PRIMARY KEY (titulo_id, cedula),
    FOREIGN KEY (titulo_id) REFERENCES Titulo(titulo_id),
    FOREIGN KEY (cedula) REFERENCES Miembro_Personal(cedula)
);

CREATE TABLE Etapa (
    etapa_id VARCHAR(255) PRIMARY KEY,
    descripcion VARCHAR(255) NOT NULL,
    fecha_final DATE NOT NULL,
    motivo VARCHAR(255) NOT NULL,
    fecha_procesamiento DATE NOT NULL,
    cedula INT,
    FOREIGN KEY (cedula) REFERENCES Miembro_Personal(cedula)
);

CREATE TABLE Cobertura (
    cobertura_id VARCHAR(255) PRIMARY KEY,
    tipo VARCHAR(255) NOT NULL,
    monto_maximo FLOAT NOT NULL
);

CREATE TABLE Alergia (
    alergia_id INT PRIMARY KEY,
    nombre VARCHAR(255) UNIQUE NOT NULL
);

CREATE TABLE Motivo_No_Pago (
    codigo_motivo_no_pago VARCHAR(255) PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL UNIQUE,
   descripcion VARCHAR(255) NOT NULL
);

CREATE TABLE Compania_Seguro (
    nit VARCHAR(255) PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    direccion VARCHAR(255) NOT NULL,
    ip VARCHAR(255) NOT NULL,
    telefono_contacto VARCHAR(255) NOT NULL
);

CREATE TABLE Motivo_Cita (
    motivo_id VARCHAR(255) PRIMARY KEY,
    descripcion VARCHAR(255) UNIQUE NOT NULL
);

CREATE TABLE Vinculo (
    cedula INT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    telefono INT NOT NULL,
    tipo VARCHAR(255) NOT NULL
);

CREATE TABLE Paciente (
    cedula INT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    sexo VARCHAR(255) NOT NULL,
    direccion VARCHAR(255) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    CONSTRAINT check_sexo CHECK (sexo IN ('Masculino', 'Femenino'))
);

CREATE TABLE Vinculo_Paciente (
    cedula_paciente INT,
    cedula_vinculo INT,
    PRIMARY KEY (cedula_paciente, cedula_vinculo),
    FOREIGN KEY (cedula_paciente) REFERENCES Paciente(cedula),
    FOREIGN KEY (cedula_vinculo) REFERENCES Vinculo(cedula)
);

CREATE TABLE Alergias_Paciente (
    alergia_id INT,
    cedula INT,
    PRIMARY KEY (alergia_id, cedula),
    FOREIGN KEY (alergia_id) REFERENCES Alergia(alergia_id),
    FOREIGN KEY (cedula) REFERENCES Paciente(cedula)
);

CREATE TABLE Cita (
    cita_id VARCHAR(255) PRIMARY KEY,
    fecha_programacion DATE NOT NULL,
    hora_programacion VARCHAR(255) NOT NULL,
    fecha_realizacion DATE NOT NULL,
    hora_realizacion VARCHAR(255) NOT NULL,
    motivo_id VARCHAR(255),
    cedula_paciente INT,
    cedula_miembro_personal INT,
    FOREIGN KEY (motivo_id) REFERENCES Motivo_Cita(motivo_id),
    FOREIGN KEY (cedula_paciente) REFERENCES Paciente(cedula),
    FOREIGN KEY (cedula_miembro_personal) REFERENCES Miembro_Personal(cedula)
);

CREATE TABLE Reclamo (
    codigo_reclamo VARCHAR(255) PRIMARY KEY,
    fecha_accion DATE NOT NULL,
    fecha_reclamo DATE NOT NULL,
    monto_reclamado FLOAT NOT NULL,
    cita_id VARCHAR(255),
    FOREIGN KEY (cita_id) REFERENCES Cita(cita_id)
);

CREATE TABLE Reclamos_Consecutivos (
    codigo_reclamo_anterior VARCHAR(255),
    codigo_reclamo_siguiente VARCHAR(255),
    PRIMARY KEY (codigo_reclamo_anterior, codigo_reclamo_siguiente),
    FOREIGN KEY (codigo_reclamo_anterior) REFERENCES Reclamo,
    FOREIGN KEY (codigo_reclamo_siguiente) REFERENCES Reclamo
);

CREATE TABLE Reclamo_Aprobado (
    codigo_reclamo VARCHAR(255) PRIMARY KEY,
    monto_pagado FLOAT,
    FOREIGN KEY (codigo_reclamo) REFERENCES Reclamo(codigo_reclamo)
);

CREATE TABLE Reclamo_Parcial (
    codigo_reclamo VARCHAR(255) PRIMARY KEY,
    monto_pagado FLOAT NOT NULL,
    fecha_pago_parcial DATE NOT NULL,
    codigo_motivo_no_pago VARCHAR(255),
    FOREIGN KEY (codigo_reclamo) REFERENCES Reclamo,
    FOREIGN KEY (codigo_motivo_no_pago) REFERENCES Motivo_No_Pago(codigo_motivo_no_pago)
);

CREATE TABLE Reclamo_Negado (
    codigo_reclamo VARCHAR(255) PRIMARY KEY,
    FOREIGN KEY (codigo_reclamo) REFERENCES Reclamo
);

CREATE TABLE Etapa_Reclamo_Parcial (
    codigo_reclamo VARCHAR(255),
    etapa_id VARCHAR(255),
    PRIMARY KEY (codigo_reclamo, etapa_id),
    FOREIGN KEY (codigo_reclamo) REFERENCES Reclamo_Parcial,
    FOREIGN KEY (etapa_id) REFERENCES Etapa
);

CREATE TABLE Etapa_Reclamo_Negado (
    codigo_reclamo VARCHAR(255),
    etapa_id VARCHAR(255),
    PRIMARY KEY (codigo_reclamo, etapa_id),
    FOREIGN KEY (codigo_reclamo) REFERENCES Reclamo_Negado,
    FOREIGN KEY (etapa_id) REFERENCES Etapa
);

CREATE TABLE Poliza (
    codigo_poliza VARCHAR(255) PRIMARY KEY,
    nit VARCHAR(255),
    cedula INT,
    codigo_reclamo VARCHAR(255),
    FOREIGN KEY (nit) REFERENCES Compania_Seguro(nit),
    FOREIGN KEY (cedula) REFERENCES Paciente(cedula),
    FOREIGN KEY (codigo_reclamo) REFERENCES Reclamo
);

CREATE TABLE Cobertura_Poliza (
    cobertura_id VARCHAR(255),
    codigo_poliza VARCHAR(255),
    PRIMARY KEY (cobertura_id, codigo_poliza),
    FOREIGN KEY (cobertura_id) REFERENCES Cobertura,
    FOREIGN KEY (codigo_poliza) REFERENCES Poliza
);

-- Dar acceso a cada tabla a JPALACIO
GRANT ALL ON Miembro_Personal TO JPALACIO;
GRANT ALL ON Titulo TO JPALACIO;
GRANT ALL ON Titulo_Miembro TO JPALACIO;
GRANT ALL ON Etapa TO JPALACIO;
GRANT ALL ON Cobertura TO JPALACIO;
GRANT ALL ON Alergia TO JPALACIO;
GRANT ALL ON Motivo_No_Pago TO JPALACIO;
GRANT ALL ON Compania_Seguro TO JPALACIO;
GRANT ALL ON Motivo_Cita TO JPALACIO;
GRANT ALL ON Vinculo TO JPALACIO;
GRANT ALL ON Paciente TO JPALACIO;
GRANT ALL ON Vinculo_Paciente TO JPALACIO;
GRANT ALL ON Alergias_Paciente TO JPALACIO;
GRANT ALL ON Cita TO JPALACIO;
GRANT ALL ON Reclamo TO JPALACIO;
GRANT ALL ON Reclamo_Aprobado TO JPALACIO;
GRANT ALL ON Reclamo_Parcial TO JPALACIO;
GRANT ALL ON Reclamo_Negado TO JPALACIO;
GRANT ALL ON Etapa_Reclamo_Parcial TO JPALACIO;
GRANT ALL ON Etapa_Reclamo_Negado TO JPALACIO;
GRANT ALL ON Poliza TO JPALACIO;
GRANT ALL ON Cobertura_Poliza TO JPALACIO;

-- Insertar datos en la tabla Miembro_Personal
INSERT INTO Miembro_Personal (cedula, nombre, sexo, direccion, cargo) 
VALUES (123456, 'Juan Pérez', 'Masculino', 'Av. Siempre Viva 123', 'Doctor');
INSERT INTO Miembro_Personal (cedula, nombre, sexo, direccion, cargo) 
VALUES (789012, 'Ana López', 'Femenino', 'Calle Falsa 456', 'Enfermera');
INSERT INTO Miembro_Personal (cedula, nombre, sexo, direccion, cargo) 
VALUES (102715, 'Daniel Castro', 'Masculino', 'Calle 127 #59-69', 'Medico');

-- Insertar datos en la tabla Titulo
INSERT INTO Titulo (titulo_id, nombre) 
VALUES ('T1', 'Doctorado');
INSERT INTO Titulo (titulo_id, nombre) 
VALUES ('T2', 'Maestría');

-- Insertar datos en la tabla Titulo_Miembro
INSERT INTO Titulo_Miembro (titulo_id, cedula) 
VALUES ('T1', 123456);
INSERT INTO Titulo_Miembro (titulo_id, cedula) 
VALUES ('T2', 789012);
INSERT INTO Titulo_Miembro (titulo_id, cedula) 
VALUES ('T2', 102715);

-- Insertar datos en la tabla Vinculo
INSERT INTO Vinculo (cedula, nombre, telefono, tipo) 
VALUES (123, 'Juan Erasmo', 123456789, 'Familiar');
INSERT INTO Vinculo (cedula, nombre, telefono, tipo) 
VALUES (456, 'María Gómez', 987654321, 'Amiga');
INSERT INTO Vinculo (cedula, nombre, telefono, tipo) 
VALUES (789, 'Juan Rozo', 019283746, 'Mejor Amigo');

-- Insertar datos en la tabla Paciente
INSERT INTO Paciente (cedula, nombre, sexo, direccion, fecha_nacimiento) 
VALUES (111, 'Carlos Pérez', 'Masculino', 'Calle 1, Ciudad 1', TO_DATE('1980-01-01', 'YYYY-MM-DD'));
INSERT INTO Paciente (cedula, nombre, sexo, direccion, fecha_nacimiento) 
VALUES (222, 'Laura Martínez', 'Femenino', 'Calle 2, Ciudad 2', TO_DATE('1990-02-02', 'YYYY-MM-DD'));
INSERT INTO Paciente (cedula, nombre, sexo, direccion, fecha_nacimiento) 
VALUES (333, 'Mapa Ruiz', 'Femenino', 'Calle 19, Carrera 91', TO_DATE('2005-12-10', 'YYYY-MM-DD'));
INSERT INTO Paciente (cedula, nombre, sexo, direccion, fecha_nacimiento) 
VALUES (444, 'Carlos Ferrer', 'Masculino', 'Calle 3, Carrera 20', TO_DATE('1995-03-03', 'YYYY-MM-DD'));

-- Insertar datos en la tabla Vinculo_Paciente
INSERT INTO Vinculo_Paciente (cedula_vinculo, cedula_paciente) 
VALUES (123, 111);
INSERT INTO Vinculo_Paciente (cedula_vinculo, cedula_paciente) 
VALUES (456, 222);
INSERT INTO Vinculo_Paciente (cedula_vinculo, cedula_paciente) 
VALUES (789, 444);

-- Insertar datos en la tabla Alergia
INSERT INTO Alergia (alergia_id, nombre) 
VALUES (1, 'Penicilina');
INSERT INTO Alergia (alergia_id, nombre) 
VALUES (2, 'Mariscos');

-- Insertar datos en la tabla Alergias_Paciente
INSERT INTO Alergias_Paciente (alergia_id, cedula) 
VALUES (1, 111);
INSERT INTO Alergias_Paciente (alergia_id, cedula) 
VALUES (2, 222);

-- Insertar datos en la tabla Motivo_Cita
INSERT INTO Motivo_Cita (motivo_id, descripcion) 
VALUES ('M1', 'Consulta general');
INSERT INTO Motivo_Cita (motivo_id, descripcion) 
VALUES ('M2', 'Revisión de resultados');

-- Insertar datos en la tabla Cita
INSERT INTO Cita (cita_id, fecha_programacion, hora_programacion, fecha_realizacion, hora_realizacion, motivo_id, cedula_paciente, cedula_miembro_personal) 
VALUES ('C1', TO_DATE('2024-05-01', 'YYYY-MM-DD'), '10:00:00', TO_DATE('2024-05-01', 'YYYY-MM-DD'), '10:30:00', 'M1', 111, 123456);
INSERT INTO Cita (cita_id, fecha_programacion, hora_programacion, fecha_realizacion, hora_realizacion, motivo_id, cedula_paciente, cedula_miembro_personal) 
VALUES ('C2', TO_DATE('2024-05-02', 'YYYY-MM-DD'), '11:00:00', TO_DATE('2024-05-02', 'YYYY-MM-DD'), '11:30:00', 'M2', 222, 789012);
INSERT INTO Cita (cita_id, fecha_programacion, hora_programacion, fecha_realizacion, hora_realizacion, motivo_id, cedula_paciente, cedula_miembro_personal) 
VALUES ('C3', TO_DATE('2024-04-30', 'YYYY-MM-DD'), '12:00:00', TO_DATE('2024-05-02', 'YYYY-MM-DD'), '12:30:00', 'M1', 333, 102715);

-- Insertar datos en la tabla Etapa
INSERT INTO Etapa (etapa_id, descripcion, fecha_final, motivo, fecha_procesamiento, cedula) 
VALUES ('E1', 'Primera revisión', TO_DATE('2024-05-02', 'YYYY-MM-DD'), 'Datos incompletos', TO_DATE('2024-05-01', 'YYYY-MM-DD'), 123456);
INSERT INTO Etapa (etapa_id, descripcion, fecha_final, motivo, fecha_procesamiento, cedula) 
VALUES ('E2', 'Segunda revisión', TO_DATE('2024-05-03', 'YYYY-MM-DD'), 'Administración de medicamentos', TO_DATE('2024-05-01', 'YYYY-MM-DD'), 789012);
INSERT INTO Etapa (etapa_id, descripcion, fecha_final, motivo, fecha_procesamiento, cedula) 
VALUES ('E3', 'Tercera revisión', TO_DATE('2024-05-05', 'YYYY-MM-DD'), 'Sello aprobacion', TO_DATE('2024-05-04', 'YYYY-MM-DD'), 102715);

-- Insertar datos en la tabla Cobertura
INSERT INTO Cobertura (cobertura_id, tipo, monto_maximo) 
VALUES ('C1', 'Salud', 10000);
INSERT INTO Cobertura (cobertura_id, tipo, monto_maximo) 
VALUES ('C2', 'Vida', 50000);

-- Insertar datos en la tabla Motivo_No_Pago
INSERT INTO Motivo_No_Pago (codigo_motivo_no_pago, nombre, descripcion) 
VALUES ('MNP1', 'Sin autorización', 'Pago no autorizado');
INSERT INTO Motivo_No_Pago (codigo_motivo_no_pago, nombre, descripcion) 
VALUES ('MNP2', 'Datos incompletos', 'Información insuficiente');

-- Insertar datos en la tabla Compania_Seguro
INSERT INTO Compania_Seguro (nit, nombre, direccion, ip, telefono_contacto) 
VALUES ('NIT123', 'Seguros Generales', 'Av. Principal 123', '192.168.5.1', '555-1234');
INSERT INTO Compania_Seguro (nit, nombre, direccion, ip, telefono_contacto) 
VALUES ('NIT456', 'Seguros Avanzados', 'Calle Grande 789', '192.168.5.2', '555-5678');

-- Insertar datos en la tabla Reclamo
INSERT INTO Reclamo (codigo_reclamo, fecha_accion, fecha_reclamo, monto_reclamado, cita_id) 
VALUES ('R1', TO_DATE('2024-05-02', 'YYYY-MM-DD'), TO_DATE('2024-05-03', 'YYYY-MM-DD'), 5000, 'C1');
INSERT INTO Reclamo (codigo_reclamo, fecha_accion, fecha_reclamo, monto_reclamado, cita_id) 
VALUES ('R2', TO_DATE('2024-05-03', 'YYYY-MM-DD'), TO_DATE('2024-05-04', 'YYYY-MM-DD'), 7000, 'C2');
INSERT INTO Reclamo (codigo_reclamo, fecha_accion, fecha_reclamo, monto_reclamado, cita_id) 
VALUES ('R3', TO_DATE('2024-05-04', 'YYYY-MM-DD'), TO_DATE('2024-05-05', 'YYYY-MM-DD'), 10000, 'C3');
INSERT INTO Reclamo (codigo_reclamo, fecha_accion, fecha_reclamo, monto_reclamado, cita_id) 
VALUES ('R4', TO_DATE('2024-05-05', 'YYYY-MM-DD'), TO_DATE('2024-05-06', 'YYYY-MM-DD'), 14000, 'C3');

-- Insertar datos en la tabla Reclamos_Consecutivos
INSERT INTO Reclamos_Consecutivos (codigo_reclamo_anterior, codigo_reclamo_siguiente) 
VALUES ('R3', 'R4');

-- Insertar datos en la tabla Reclamo_Aprobado
INSERT INTO Reclamo_Aprobado (codigo_reclamo, monto_pagado) 
VALUES ('R1', 5000);

-- Insertar datos en la tabla Reclamo_Parcial
INSERT INTO Reclamo_Parcial (codigo_reclamo, monto_pagado, fecha_pago_parcial, codigo_motivo_no_pago) 
VALUES ('R2', 3000, TO_DATE('2024-05-05', 'YYYY-MM-DD'), 'MNP1');

-- Insertar datos en la tabla Reclamo_Negado
INSERT INTO Reclamo_Negado (codigo_reclamo) 
VALUES ('R3');

-- Insertar datos en la tabla Etapa_Reclamo_Parcial
INSERT INTO Etapa_Reclamo_Parcial (codigo_reclamo, etapa_id) 
VALUES ('R2', 'E1');

-- Insertar datos en la tabla Etapa_Reclamo_Negado
INSERT INTO Etapa_Reclamo_Negado (codigo_reclamo, etapa_id) 
VALUES ('R3', 'E2');
INSERT INTO Etapa_Reclamo_Negado (codigo_reclamo, etapa_id) 
VALUES ('R3', 'E3');

-- Insertar datos en la tabla Poliza
INSERT INTO Poliza (codigo_poliza, nit, cedula, codigo_reclamo) 
VALUES ('P1', 'NIT123', 111, 'R1');
INSERT INTO Poliza (codigo_poliza, nit, cedula, codigo_reclamo) 
VALUES ('P2', 'NIT456', 222, 'R2');

-- Insertar datos en la tabla Cobertura_Poliza
INSERT INTO Cobertura_Poliza (cobertura_id, codigo_poliza) 
VALUES ('C1', 'P1');
INSERT INTO Cobertura_Poliza (cobertura_id, codigo_poliza) 
VALUES ('C2', 'P2');

-- Eliminar vistas
DROP VIEW Reclamaciones_Paciente;
DROP VIEW Reclamaciones_No_Reembolsadas;
DROP VIEW Paciente_Personas_Relacionadas;
DROP VIEW Reclamaciones_Poliza_Compania;
DROP VIEW Etapas_Reclamo;

-- Primera consulta
CREATE VIEW Reclamaciones_Paciente AS
SELECT 
    p.nombre AS "Nombre Paciente",
    p.sexo AS "Genero Paciente",
    COALESCE(COUNT(DISTINCT c.cita_id), 0) AS "Número de Citas",
    COALESCE(SUM(r.monto_reclamado), 0) AS "Valor Total Monto Reclamado",
    COALESCE(SUM(COALESCE(ra.monto_pagado, 0) + COALESCE(rp.monto_pagado, 0)), 0) AS "Valor Total Monto Pagado",
    COALESCE(SUM(r.monto_reclamado) - SUM(COALESCE(ra.monto_pagado, 0) + COALESCE(rp.monto_pagado, 0)), 0) AS "Diferencia Reclamado-Pagado"
FROM 
    Paciente p
LEFT JOIN 
    Cita c ON p.cedula = c.cedula_paciente
LEFT JOIN 
    Reclamo r ON c.cita_id = r.cita_id
LEFT JOIN 
    Reclamo_Aprobado ra ON r.codigo_reclamo = ra.codigo_reclamo
LEFT JOIN 
    Reclamo_Parcial rp ON r.codigo_reclamo = rp.codigo_reclamo
GROUP BY 
    p.nombre, p.sexo

UNION ALL

SELECT 
    'Total' AS "Nombre Paciente",
    NULL AS "Genero Paciente",
    COUNT(DISTINCT c.cita_id) AS "Número de Citas",
    COALESCE(SUM(r.monto_reclamado), 0) AS "Valor Total Monto Reclamado",
    COALESCE(SUM(COALESCE(ra.monto_pagado, 0) + COALESCE(rp.monto_pagado, 0)), 0) AS "Valor Total Monto Pagado",
    COALESCE(SUM(r.monto_reclamado) - SUM(COALESCE(ra.monto_pagado, 0) + COALESCE(rp.monto_pagado, 0)), 0) AS "Diferencia Reclamado-Pagado"
FROM 
    Paciente p
LEFT JOIN 
    Cita c ON p.cedula = c.cedula_paciente
LEFT JOIN 
    Reclamo r ON c.cita_id = r.cita_id
LEFT JOIN 
    Reclamo_Aprobado ra ON r.codigo_reclamo = ra.codigo_reclamo
LEFT JOIN 
    Reclamo_Parcial rp ON r.codigo_reclamo = rp.codigo_reclamo;

-- Segunda consulta
CREATE VIEW Reclamaciones_No_Reembolsadas AS
SELECT
    mp.cargo AS "Clase",
    SUM(CASE WHEN mp.sexo = 'Masculino' AND (r.monto_reclamado - COALESCE(rp.monto_pagado, 0)) <> 0 THEN 1 ELSE 0 END) AS "Número de reclamaciones masculino",
    SUM(CASE WHEN mp.sexo = 'Femenino' AND (r.monto_reclamado - COALESCE(rp.monto_pagado, 0)) <> 0 THEN 1 ELSE 0 END) AS "Número de reclamaciones femenino",
    SUM(CASE WHEN (r.monto_reclamado - COALESCE(rp.monto_pagado, 0)) <> 0 THEN r.monto_reclamado - COALESCE(rp.monto_pagado, 0) ELSE 0 END) AS "Valor de reclamaciones no pagadas totalmente"
FROM 
    Reclamo_Parcial rp
LEFT JOIN 
    Reclamo r ON rp.codigo_reclamo = r.codigo_reclamo
LEFT JOIN 
    Cita c ON r.cita_id = c.cita_id
LEFT JOIN 
    Miembro_Personal mp ON c.cedula_miembro_personal = mp.cedula
GROUP BY 
    mp.cargo;
    
-- Tercera consulta
CREATE VIEW Paciente_Personas_Relacionadas AS
SELECT 
    p.nombre AS "Nombre Paciente",
    COALESCE(v.nombre, 'N/A') AS "Nombre Persona Relacionada",
    COALESCE(v.tipo, 'N/A') AS "Naturaleza de la Relación"
FROM 
    Paciente p
LEFT JOIN 
    Vinculo_Paciente vp ON p.cedula = vp.cedula_paciente
LEFT JOIN 
    Vinculo v ON vp.cedula_vinculo = v.cedula;
    
-- Cuarta consulta
CREATE VIEW Reclamaciones_Poliza_Compania AS
SELECT 
    cs.nombre AS "Nombre Compañía",
    p.codigo_poliza AS "Número de póliza",
    COUNT(r.codigo_reclamo) AS "Total de Reclamaciones"
FROM 
    Poliza p
JOIN 
    Compania_Seguro cs ON p.nit = cs.nit
LEFT JOIN 
    Reclamo r ON p.codigo_reclamo = r.codigo_reclamo 
GROUP BY 
    cs.nombre, p.codigo_poliza;

-- Quinta consulta
CREATE VIEW Etapas_Reclamo AS
SELECT
    r.codigo_reclamo AS "ID de Reclamo",
    COUNT(DISTINCT ep.etapa_id) + COUNT(DISTINCT en.etapa_id) AS "Número Total de Etapas de Negociación",
    rc.codigo_reclamo_siguiente AS "ID de Nuevo Reclamo"
FROM
    Reclamo r
LEFT JOIN
    Etapa_Reclamo_Parcial ep ON r.codigo_reclamo = ep.codigo_reclamo
LEFT JOIN
    Etapa_Reclamo_Negado en ON r.codigo_reclamo = en.codigo_reclamo
LEFT JOIN
    Reclamos_Consecutivos rc ON r.codigo_reclamo = rc.codigo_reclamo_anterior
GROUP BY
    r.codigo_reclamo, rc.codigo_reclamo_siguiente;

-- Dar acceso a todas las vistas
GRANT ALL ON Reclamaciones_Paciente TO JPALACIO;
GRANT ALL ON Reclamaciones_No_Reembolsadas TO JPALACIO;
GRANT ALL ON Paciente_Personas_Relacionadas TO JPALACIO;
GRANT ALL ON Reclamaciones_Poliza_Compania TO JPALACIO;
GRANT ALL ON Etapas_Reclamo TO JPALACIO;