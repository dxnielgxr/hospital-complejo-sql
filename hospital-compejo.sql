DROP DATABASE IF EXISTS hospital;
CREATE DATABASE hospital;
USE hospital;

-- Tabla Pacientes
CREATE TABLE pacientes (
    id_paciente INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50),
    apellido VARCHAR(50),
    fecha_nacimiento DATE,
    genero VARCHAR(10),
    telefono VARCHAR(15)
);

-- Tabla Doctores
CREATE TABLE doctores (
    id_doctor INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50),
    especialidad VARCHAR(50),
    telefono VARCHAR(15)
);

-- Tabla Citas
CREATE TABLE citas (
    id_cita INT AUTO_INCREMENT PRIMARY KEY,
    fecha DATE,
    motivo VARCHAR(100),
    id_paciente INT,
    id_doctor INT,
    FOREIGN KEY (id_paciente) REFERENCES pacientes(id_paciente),
    FOREIGN KEY (id_doctor) REFERENCES doctores(id_doctor)
);

-- Tabla Medicamentos
CREATE TABLE medicamentos (
    id_medicamento INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50),
    descripcion VARCHAR(100)
);

-- Tabla Recetas
CREATE TABLE recetas (
    id_recetas INT AUTO_INCREMENT PRIMARY KEY,
    id_cita INT,
    id_medicamento INT,
    dosis VARCHAR(50),
    FOREIGN KEY (id_cita) REFERENCES citas(id_cita),
    FOREIGN KEY (id_medicamento) REFERENCES medicamentos(id_medicamento)
);

-- Tabla Habitaciones
CREATE TABLE habitaciones (
    id_habitacion INT AUTO_INCREMENT PRIMARY KEY,
    numero_habitacion VARCHAR(10) NOT NULL,
    tipo VARCHAR(50), -- General, UCI, Pediatría
    estado VARCHAR(20) -- Disponible, Ocupada, Mantenimiento
);

-- Tabla Internaciones (Relación Paciente - Habitación)
CREATE TABLE internaciones (
    id_internacion INT AUTO_INCREMENT PRIMARY KEY,
    id_paciente INT,
    id_habitacion INT,
    fecha_ingreso DATE,
    fecha_salida DATE,
    diagnostico_ingreso VARCHAR(100),
    FOREIGN KEY (id_paciente) REFERENCES pacientes(id_paciente),
    FOREIGN KEY (id_habitacion) REFERENCES habitaciones(id_habitacion)
);

-- Tabla Facturación (Relación Paciente - Cita / Costos)
CREATE TABLE facturacion (
    id_factura INT AUTO_INCREMENT PRIMARY KEY,
    id_paciente INT,
    id_cita INT,
    total DECIMAL(10, 2),
    estado_pago VARCHAR(20), -- Pagado, Pendiente
    fecha_emision DATE,
    FOREIGN KEY (id_paciente) REFERENCES pacientes(id_paciente),
    FOREIGN KEY (id_cita) REFERENCES citas(id_cita)
);

-- ==========================================
-- INSERCIÓN DE DATOS DE PRUEBA
-- ==========================================

INSERT INTO pacientes (nombre, apellido, fecha_nacimiento, genero, telefono) VALUES
("Felipe", "Caicedo", "1999-04-14", "Masculino", "3006566628"),
("Ana", "Hernandez", "1999-07-24", "Femenino", "3006567648"),
("Pedro", "Garcia", "1998-04-11", "Masculino", "3005566628"),
("Lina", "Flores", "1997-01-04", "Femenino", "3006567648"),
("Carlos", "Tabio", "2000-03-14", "Masculino", "3046576628"),
("Valentina", "Alvarez", "2010-02-24", "Femenino", "3136567648");

INSERT INTO doctores (nombre, especialidad, telefono) VALUES
("Dr. Ramirez", "Cardiologia", "3003211234"),
("Dra. Torres", "Pediatria", "3003261284"),
("Dr. Sanchez", "Dermatologia", "3153213234"),
("Dra. Gomez", "Medicina General", "3104567890");

INSERT INTO citas (fecha, motivo, id_paciente, id_doctor) VALUES
("2026-03-20", "Dolor de pecho", 1, 1),
("2026-03-21", "Control Infantil", 6, 2),
("2026-04-24", "Alergia en la piel", 2, 3),
("2026-05-10", "Chequeo general", 4, 4);

INSERT INTO medicamentos (nombre, descripcion) VALUES
("Paracetamol", "Analgesico y antipiretico"),
("Ibuprofeno", "Antiflamatorio"),
("Amoxicilina", "Antibiotico"),
("Loratadina", "Antihistamínico");

INSERT INTO recetas (id_cita, id_medicamento, dosis) VALUES
(1, 1, "500mg cada 8 horas"),
(2, 3, "250mg cada 12 horas"),
(3, 2, "400mg cada 8 horas"),
(3, 4, "10mg cada 24 horas");

INSERT INTO habitaciones (numero_habitacion, tipo, estado) VALUES
("101", "General", "Ocupada"),
("102", "General", "Disponible"),
("201", "UCI", "Ocupada"),
("301", "Pediatría", "Disponible");

INSERT INTO internaciones (id_paciente, id_habitacion, fecha_ingreso, fecha_salida, diagnostico_ingreso) VALUES
(1, 3, "2026-03-20", "2026-03-25", "Infarto agudo de miocardio"),
(2, 1, "2026-04-24", "2026-04-26", "Dermatitis alérgica severa");

INSERT INTO facturacion (id_paciente, id_cita, total, estado_pago, fecha_emision) VALUES
(1, 1, 350000.00, "Pagado", "2026-03-20"),
(6, 2, 120000.00, "Pagado", "2026-03-21"),
(2, 3, 200000.00, "Pendiente", "2026-04-24");

-- ==========================================
-- CONSULTAS COMPLEJAS
-- ==========================================


SELECT
    estado AS categoria_servicio,
    numero_habitacion AS codigo_cuarto
FROM habitaciones;


SELECT
    id_paciente AS paciente_id,
    diagnostico_ingreso AS motivo_ingreso,
    DATEDIFF(fecha_salida, fecha_ingreso) AS dias_hospitalizado
FROM internaciones;


SELECT
    id_doctor,
    COUNT(*) AS total_citas
FROM citas
GROUP BY id_doctor
HAVING COUNT(*) >= 1;


SELECT
    p.id_paciente AS paciente_id,
    p.nombre AS nombre_paciente,
    p.apellido AS apellido_paciente
FROM pacientes AS p
WHERE p.id_paciente NOT IN (
    SELECT id_paciente
    FROM internaciones
);


SELECT
    nombre AS paciente,
    IFNULL((SELECT COUNT(*)
            FROM citas
            WHERE citas.id_paciente = pacientes.id_paciente), 0) AS cantidad_citas
FROM pacientes
ORDER BY cantidad_citas DESC;