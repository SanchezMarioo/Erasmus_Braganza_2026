DROP DATABASE IF EXISTS bip_system;
CREATE DATABASE IF NOT EXISTS bip_system CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE bip_system;

-- CREACION DE TABLA INTERMEDIA ENTRE BIP Y LAS INSTITUCIONES (N:M)
-- CAMPOS DE NAME EN USER Y PROFESOR A USER 
-- INSTITUCION --> WEBSITE, LOCALIZACION, PAIS, NUMERO DE CONTACTO, RESPONSABLE
-- BIP --> NUMERO DE PLAZAS DISPONIBLES

-- BIP --> PUEDE SER ALGO DIFERENTE A LA DISCIPLINA O COINCIDIR CON LA DISCIPLINA --> ASIGNATURAS 
--     --> 
-- TABLA INTERMEDIA ENTRE DISCIPLINA E INSTITUCIONES 
 
-- TABLA INTERMEDIA ENTRE BIP Y REQUEST (BIP Y ESTUDIANTES ACEPTADOS CON LOS IDs)

CREATE TABLE institution (
    id_institution INT AUTO_INCREMENT PRIMARY KEY,
    name           VARCHAR(150) NOT NULL,
    type           ENUM('local', 'partner') NOT NULL,
    website		   VARCHAR (255),
	localization   VARCHAR (255),
    contact_number VARCHAR (25),
    country 	   VARCHAR (64),
    responsible    VARCHAR (128)
);


CREATE TABLE academic_year (
    id_year INT AUTO_INCREMENT PRIMARY KEY,
    label   VARCHAR(20) NOT NULL UNIQUE   -- ej: '2025-2026'
);

CREATE TABLE semester (
    id_semester INT AUTO_INCREMENT PRIMARY KEY,
    id_year     INT NOT NULL,
    number      TINYINT NOT NULL CHECK (number IN (1, 2)),
    start_date  DATE NOT NULL,
    end_date    DATE NOT NULL,
    FOREIGN KEY (id_year) REFERENCES academic_year(id_year)
);


CREATE TABLE user (
    id_user       INT AUTO_INCREMENT PRIMARY KEY,
    name	      VARCHAR (255) NOT NULL,
    email         VARCHAR(150) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    role          ENUM('student', 'teacher', 'admin') NOT NULL
);


CREATE TABLE student (
    id_user        INT NOT NULL UNIQUE,
    id_institution INT NOT NULL,
    study_area     VARCHAR(100) NOT NULL,
    PRIMARY KEY (id_user),
    FOREIGN KEY (id_user)        REFERENCES user(id_user),
    FOREIGN KEY (id_institution) REFERENCES institution(id_institution)
);

CREATE TABLE teacher (
    id_user    INT NOT NULL UNIQUE,
    name       VARCHAR(100) NOT NULL,
    department VARCHAR(100) NOT NULL,
    PRIMARY KEY (id_user),
    FOREIGN KEY (id_user) REFERENCES user(id_user)
);

CREATE TABLE discipline (
	id_discipline INT,
    name 		  VARCHAR(127),
	id_teacher 	  INT,	
    PRIMARY KEY (id_discipline),
    FOREIGN KEY (id_teacher) REFERENCES teacher (id_user)
);



CREATE TABLE admin (
    id_admin   INT AUTO_INCREMENT PRIMARY KEY,
    id_user    INT NOT NULL UNIQUE,
    FOREIGN KEY (id_user)    REFERENCES user(id_user)
);


CREATE TABLE bip (
    id_bip                 INT AUTO_INCREMENT PRIMARY KEY,
    name                   VARCHAR(200) NOT NULL,
    id_semester            INT NOT NULL,
    id_teacher             INT NOT NULL,    -- Profesor que lo imparte
    course_start_date      DATE NOT NULL,   -- Inicio general del curso
    presential_week_start  DATE NOT NULL,
    presential_week_end    DATE NOT NULL,
    schedule               JSON NOT NULL,   -- Horario estructurado
    FOREIGN KEY (id_semester)            REFERENCES semester(id_semester),
    FOREIGN KEY (id_teacher)             REFERENCES teacher(id_user),
    CHECK (presential_week_end >= presential_week_start)
);


CREATE TABLE enrollment_request (
    id_request      INT AUTO_INCREMENT PRIMARY KEY,
    id_bip          INT NOT NULL,
    id_student      INT NOT NULL,
    request_date    DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status          ENUM('pending', 'accepted', 'denied') NOT NULL DEFAULT 'pending',
    resolution_date DATETIME DEFAULT NULL,
    id_teacher      INT DEFAULT NULL,      -- Trazabilidad de quién aprobó/denegó
    FOREIGN KEY (id_bip)     REFERENCES bip(id_bip),
    FOREIGN KEY (id_student) REFERENCES student(id_user),
    FOREIGN KEY (id_teacher) REFERENCES teacher(id_user),
    UNIQUE KEY uq_bip_student (id_bip, id_student)  -- Evita solicitudes duplicadas
);


CREATE TABLE bip_enrollment_request (
	id_bip 		INT,
    id_request	INT,
    PRIMARY KEY (id_bip, id_request),
    FOREIGN KEY (id_bip) REFERENCES bip (id_bip),
    FOREIGN KEY (id_request) REFERENCES enrollment_request (id_request)
);
