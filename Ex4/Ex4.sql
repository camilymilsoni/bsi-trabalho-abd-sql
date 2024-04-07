\i ~/TrabalhoABD/Ex1/Ex1.sql

--EXERCÍCIO 4
CREATE OR REPLACE FUNCTION  f_verificaCirurgia() RETURNS TRIGGER
AS
$$
BEGIN
	IF (NEW.data_cirurgia > current_date) THEN
		RAISE 'Data inválida, deve ser menor que a data atual' using ERRCODE = 'ER001';
	END IF;
	RETURN NEW;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER trg_verificaCirurgia
BEFORE INSERT OR UPDATE
ON cirurgia FOR EACH ROW
EXECUTE PROCEDURE f_verificaCirurgia();

--Testar trigger
INSERT INTO cirurgia VALUES 
(NEXTVAL('sid_cirurgia'), 'c42', '10/04/2024', 'Implante de silicone', (SELECT id_paciente FROM paciente WHERE nome = 'Maria'));