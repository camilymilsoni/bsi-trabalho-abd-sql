--EXERCÍCIO 1
--b) CRIAÇÃO BANCO DE DADOS
SELECT '
CREATE DATABASE trabalhoabd
    WITH 
    OWNER = postgres   
    CONNECTION LIMIT = -1;
'
WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'trabalhoabd')\gexec
ALTER DATABASE trabalhoabd SET datestyle TO 'ISO, DMY';

\c trabalhoabd

SET TIMEZONE TO 'UTC';

CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

--c) CRIAÇÃO DAS SEQUÊNCIAS
CREATE SEQUENCE IF NOT EXISTS sid_paciente;
CREATE SEQUENCE IF NOT EXISTS sid_medico;
CREATE SEQUENCE IF NOT EXISTS sid_atende;
CREATE SEQUENCE IF NOT EXISTS sid_cirurgia;

--d) CRIAÇÃO DAS TABELAS
CREATE TABLE IF NOT EXISTS paciente(
	id_paciente INTEGER,
	codigo VARCHAR(10) UNIQUE,
	nome VARCHAR(45),
	idade INTEGER,
	CONSTRAINT pk_paciente PRIMARY KEY (id_paciente)
);

CREATE TABLE IF NOT EXISTS medico(
	id_medico INTEGER,
	crm VARCHAR(10) UNIQUE,
	nome VARCHAR(45),
	especialidade VARCHAR(45),
	CONSTRAINT pk_medico PRIMARY KEY (id_medico)
);

CREATE TABLE IF NOT EXISTS atende(
	id_atende INTEGER,
	id_paciente INTEGER,
	id_medico INTEGER, 
	data_atende DATE,
	CONSTRAINT pk_atende PRIMARY KEY (id_atende),
	CONSTRAINT fk_atende_paciente FOREIGN KEY (id_paciente) REFERENCES paciente,
	CONSTRAINT fk_atende_medico FOREIGN KEY (id_medico) REFERENCES medico
);

CREATE TABLE IF NOT EXISTS cirurgia(
	id_cirurgia INTEGER,
	codigo VARCHAR(10) UNIQUE,
	data_cirurgia DATE,
	descricao VARCHAR(50),
	id_paciente INTEGER,
	CONSTRAINT pk_cirurgia PRIMARY KEY (id_cirurgia),
	CONSTRAINT fk_cirurgia_paciente FOREIGN KEY (id_paciente) REFERENCES paciente
);

--INSERÇÕES
INSERT INTO paciente 
SELECT NEXTVAL('sid_paciente'), 'p1', 'João', 12 
WHERE NOT EXISTS (SELECT 1 FROM paciente WHERE codigo = 'p1')
UNION
SELECT NEXTVAL('sid_paciente'), 'p2', 'Maria', 38 
WHERE NOT EXISTS (SELECT 1 FROM paciente WHERE codigo = 'p2')
UNION
SELECT NEXTVAL('sid_paciente'), 'p3', 'Pedro', 21 
WHERE NOT EXISTS (SELECT 1 FROM paciente WHERE codigo = 'p3')
UNION
SELECT NEXTVAL('sid_paciente'), 'p4', 'Antônio', 29 
WHERE NOT EXISTS (SELECT 1 FROM paciente WHERE codigo = 'p4');

INSERT INTO medico 
SELECT NEXTVAL('sid_medico'), 'm1', 'Marcos', 'Oftalmologista' 
WHERE NOT EXISTS (SELECT 1 FROM medico WHERE crm = 'm1')
UNION
SELECT NEXTVAL('sid_medico'), 'm2', 'Tereza', 'Clínico Geral' 
WHERE NOT EXISTS (SELECT 1 FROM medico WHERE crm = 'm2')
UNION
SELECT NEXTVAL('sid_medico'), 'm3', 'Paulo', 'Pediatra' 
WHERE NOT EXISTS (SELECT 1 FROM medico WHERE crm = 'm3')
UNION
SELECT NEXTVAL('sid_medico'), 'm4', 'João', 'Clínico Geral' 
WHERE NOT EXISTS (SELECT 1 FROM medico WHERE crm = 'm4');

INSERT INTO atende 
SELECT NEXTVAL('sid_atende'), 
       (SELECT id_paciente FROM paciente WHERE nome = 'João'), 
       (SELECT id_medico FROM medico WHERE nome = 'Tereza'), 
       '09/02/2008'::DATE
WHERE NOT EXISTS (
    SELECT 1 FROM atende 
    WHERE id_paciente = (SELECT id_paciente FROM paciente WHERE nome = 'João') 
    AND id_medico = (SELECT id_medico FROM medico WHERE nome = 'Tereza') 
    AND data_atende = '09/02/2008'::DATE
)
UNION
SELECT NEXTVAL('sid_atende'), 
       (SELECT id_paciente FROM paciente WHERE nome = 'Maria'), 
       (SELECT id_medico FROM medico WHERE nome = 'Marcos'), 
       '26/03/2006'::DATE
WHERE NOT EXISTS (
    SELECT 1 FROM atende 
    WHERE id_paciente = (SELECT id_paciente FROM paciente WHERE nome = 'Maria') 
    AND id_medico = (SELECT id_medico FROM medico WHERE nome = 'Marcos') 
    AND data_atende = '26/03/2006'::DATE
)
UNION
SELECT NEXTVAL('sid_atende'), 
       (SELECT id_paciente FROM paciente WHERE nome = 'Pedro'), 
       (SELECT id_medico FROM medico WHERE nome = 'Paulo'), 
       '11/09/2003'::DATE
WHERE NOT EXISTS (
    SELECT 1 FROM atende 
    WHERE id_paciente = (SELECT id_paciente FROM paciente WHERE nome = 'Pedro') 
    AND id_medico = (SELECT id_medico FROM medico WHERE nome = 'Paulo') 
    AND data_atende = '11/09/2003'::DATE
)
UNION
SELECT NEXTVAL('sid_atende'), 
       (SELECT id_paciente FROM paciente WHERE nome = 'João'), 
       (SELECT id_medico FROM medico WHERE nome = 'João'), 
       '13/10/2007'::DATE
WHERE NOT EXISTS (
    SELECT 1 FROM atende 
    WHERE id_paciente = (SELECT id_paciente FROM paciente WHERE nome = 'João') 
    AND id_medico = (SELECT id_medico FROM medico WHERE nome = 'João') 
    AND data_atende = '13/10/2007'::DATE
)
UNION
SELECT NEXTVAL('sid_atende'), 
       (SELECT id_paciente FROM paciente WHERE nome = 'Maria'), 
       (SELECT id_medico FROM medico WHERE nome = 'Tereza'), 
       '08/05/2008'::DATE
WHERE NOT EXISTS (
    SELECT 1 FROM atende 
    WHERE id_paciente = (SELECT id_paciente FROM paciente WHERE nome = 'Maria') 
    AND id_medico = (SELECT id_medico FROM medico WHERE nome = 'Tereza') 
    AND data_atende = '08/05/2008'::DATE
);


INSERT INTO cirurgia 
SELECT NEXTVAL('sid_cirurgia'), 
       'c1', 
       '25/07/2008'::DATE,
       'Apendicite',
	(SELECT id_paciente FROM paciente WHERE nome = 'João')
WHERE NOT EXISTS (
    SELECT 1 FROM cirurgia 
    WHERE codigo = 'c1'
)
UNION
SELECT NEXTVAL('sid_cirurgia'), 
       'c2', 
       '07/02/2001'::DATE,
       'Retirada de cálculo renal',
	(SELECT id_paciente FROM paciente WHERE nome = 'Maria')
WHERE NOT EXISTS (
    SELECT 1 FROM cirurgia 
    WHERE codigo = 'c2'
)
UNION
SELECT NEXTVAL('sid_cirurgia'), 
       'c3', 
       '14/11/2007'::DATE,
       'Unha encravada',
	(SELECT id_paciente FROM paciente WHERE nome = 'Pedro')
WHERE NOT EXISTS (
    SELECT 1 FROM cirurgia 
    WHERE codigo = 'c3'
)
UNION
SELECT NEXTVAL('sid_cirurgia'), 
       'c4', 
       '23/01/2008'::DATE,
       'Implante de silicone',
	(SELECT id_paciente FROM paciente WHERE nome = 'Maria')
WHERE NOT EXISTS (
    SELECT 1 FROM cirurgia 
    WHERE codigo = 'c4'
);
