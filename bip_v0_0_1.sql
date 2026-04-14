CREATE DATABASE IF NOT EXISTS bip_system CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE bip_system;


CREATE TABLE institution (
    id_institution INT AUTO_INCREMENT PRIMARY KEY,
    name           VARCHAR(150) NOT NULL,
    type           ENUM('local', 'partner') NOT NULL
);


CREATE TABLE academic_year (
    id_year INT AUTO_INCREMENT PRIMARY KEY,
    label   VARCHAR(20) NOT NULL UNIQUE  
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
    email         VARCHAR(150) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    role          ENUM('student', 'teacher', 'admin') NOT NULL
);


CREATE TABLE student (
    id_student     INT AUTO_INCREMENT PRIMARY KEY,
    id_user        INT NOT NULL UNIQUE,
    name           VARCHAR(100) NOT NULL,
    id_institution INT NOT NULL,
    study_area     VARCHAR(100) NOT NULL,
    FOREIGN KEY (id_user)        REFERENCES user(id_user),
    FOREIGN KEY (id_institution) REFERENCES institution(id_institution)
);

CREATE TABLE teacher (
    id_teacher INT AUTO_INCREMENT PRIMARY KEY,
    id_user    INT NOT NULL UNIQUE,
    name       VARCHAR(100) NOT NULL,
    department VARCHAR(100) NOT NULL,
    FOREIGN KEY (id_user) REFERENCES user(id_user)
);

CREATE TABLE admin (
    id_admin   INT AUTO_INCREMENT PRIMARY KEY,
    id_user    INT NOT NULL UNIQUE,
    id_teacher INT DEFAULT NULL,            
    FOREIGN KEY (id_user)    REFERENCES user(id_user),
    FOREIGN KEY (id_teacher) REFERENCES teacher(id_teacher)
);


CREATE TABLE bip (
    id_bip                 INT AUTO_INCREMENT PRIMARY KEY,
    name                   VARCHAR(200) NOT NULL,
    id_semester            INT NOT NULL,
    id_host_institution    INT NOT NULL,
    id_partner_institution INT NOT NULL,
    id_teacher             INT NOT NULL,    
    course_start_date      DATE NOT NULL,   
    presential_week_start  DATE NOT NULL,
    presential_week_end    DATE NOT NULL,
    schedule               JSON NOT NULL,  
    FOREIGN KEY (id_semester)            REFERENCES semester(id_semester),
    FOREIGN KEY (id_host_institution)    REFERENCES institution(id_institution),
    FOREIGN KEY (id_partner_institution) REFERENCES institution(id_institution),
    FOREIGN KEY (id_teacher)             REFERENCES teacher(id_teacher),
    CHECK (presential_week_end >= presential_week_start)
);


CREATE TABLE enrollment_request (
    id_request      INT AUTO_INCREMENT PRIMARY KEY,
    id_bip          INT NOT NULL,
    id_student      INT NOT NULL,
    request_date    DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status          ENUM('pending', 'accepted', 'denied') NOT NULL DEFAULT 'pending',
    resolution_date DATETIME DEFAULT NULL,
    id_teacher      INT DEFAULT NULL,      
    FOREIGN KEY (id_bip)     REFERENCES bip(id_bip),
    FOREIGN KEY (id_student) REFERENCES student(id_student),
    FOREIGN KEY (id_teacher) REFERENCES teacher(id_teacher),
    UNIQUE KEY uq_bip_student (id_bip, id_student) 
);
