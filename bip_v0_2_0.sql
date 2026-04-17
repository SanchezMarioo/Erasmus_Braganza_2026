DROP DATABASE IF EXISTS bip_system;
CREATE DATABASE IF NOT EXISTS bip_system CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE bip_system;

CREATE TABLE Institution (
  id_institution  INT          NOT NULL,
  name            VARCHAR(150) NOT NULL,
  type            VARCHAR(50),
  website         VARCHAR(255),
  localization    VARCHAR(255),
  contact_number  VARCHAR(20),
  PRIMARY KEY (id_institution)
);
CREATE TABLE AcademicYear (
  id_year  INT         NOT NULL,
  label    VARCHAR(10) NOT NULL,
  PRIMARY KEY (id_year)
);
CREATE TABLE User (
  id_user        INT          NOT NULL,
  name           VARCHAR(100) NOT NULL,
  email          VARCHAR(255) NOT NULL,
  password_hash  VARCHAR(255) NOT NULL,
  is_admin       BOOLEAN      NOT NULL,
  id_institution INT          NOT NULL,
  PRIMARY KEY (id_user),
  FOREIGN KEY (id_institution) REFERENCES Institution (id_institution)
);
CREATE TABLE Teacher (
  id_teacher  INT          NOT NULL,
  department  VARCHAR(100),
  id_user     INT          NOT NULL,
  PRIMARY KEY (id_teacher),
  FOREIGN KEY (id_user) REFERENCES User (id_user)
);
CREATE TABLE Student (
  id_student  INT          NOT NULL,
  id_user     INT          NOT NULL,
  study_area  VARCHAR(255),
  PRIMARY KEY (id_student),
  FOREIGN KEY (id_user) REFERENCES User (id_user)
);
CREATE TABLE Discipline (
  id_discipline  INT          NOT NULL,
  name           VARCHAR(255) NOT NULL,
  id_teacher     INT          NOT NULL,
  PRIMARY KEY (id_discipline),
  FOREIGN KEY (id_teacher) REFERENCES Teacher (id_teacher)
);
CREATE TABLE Semester (
  id_semester  INT     NOT NULL,
  id_year      INT     NOT NULL,
  number       TINYINT NOT NULL,
  start_date   DATE    NOT NULL,
  end_date     DATE    NOT NULL,
  PRIMARY KEY (id_semester),
  FOREIGN KEY (id_year) REFERENCES AcademicYear (id_year)
);
CREATE TABLE Bip (
  id_bip      INT          NOT NULL,
  name        VARCHAR(255) NOT NULL,
  id_semester INT          NOT NULL,
  id_teacher  INT          NOT NULL,
  start_date  DATE         NOT NULL,
  end_date    DATE         NOT NULL,
  schedule    VARCHAR(255),
  PRIMARY KEY (id_bip),
  FOREIGN KEY (id_semester) REFERENCES Semester (id_semester),
  FOREIGN KEY (id_teacher)  REFERENCES Teacher  (id_teacher)
);
CREATE TABLE Institution_Bip (
  id_institution  INT  NOT NULL,
  id_bip          INT  NOT NULL,
  PRIMARY KEY (id_institution, id_bip),
  FOREIGN KEY (id_institution) REFERENCES Institution (id_institution),
  FOREIGN KEY (id_bip)         REFERENCES Bip         (id_bip)
);
CREATE TABLE EnrollmentRequest (
  id_request       INT       NOT NULL,
  id_student       INT       NOT NULL,
  id_bip           INT       NOT NULL,
  request_date     TIMESTAMP NOT NULL,
  status           VARCHAR(20) NOT NULL,
  resolution_date  TIMESTAMP,
  PRIMARY KEY (id_request),
  FOREIGN KEY (id_student) REFERENCES Student (id_student),
  FOREIGN KEY (id_bip)     REFERENCES Bip     (id_bip)
);