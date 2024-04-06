\i ~/TrabalhoABD/Ex1/Ex1.sql

--EXERCÍCIO 2
CREATE OR REPLACE FUNCTION f_criarCirurgia (codCirurgia text, codPaciente text, dtaCirurgia date, descCirurgia text) RETURNS VOID
AS								 
$$
BEGIN
	IF ((SELECT codigo FROM paciente WHERE codigo = codPaciente) = codPaciente) THEN
		INSERT INTO cirurgia VALUES (nextval('sid_cirurgia'), codCirurgia, dtaCirurgia, descCirurgia, (SELECT id_paciente FROM paciente WHERE codigo = codPaciente));
	ELSE
		RAISE 'O paciente de código % não foi encontrado', codPaciente using ERRCODE='ERR01';
	END IF;						 
END;
$$ 
LANGUAGE plpgsql;

--Testar function
SELECT f_criarCirurgia('c5', 'p4', '07/03/2024', 'Rinoplastia');
SELECT * FROM cirurgia;