\i ~/TrabalhoABD/Ex1/Ex1.sql

--EXERCÍCIO 3
CREATE OR REPLACE FUNCTION f_desempenhoMedico (dataInicio date, dataFinal date) 
RETURNS SETOF RECORD 
AS
$$
DECLARE
    reg_medico RECORD;
BEGIN
    FOR reg_medico IN
        SELECT nome, COUNT(*) AS quantidade_atendimentos
        FROM medico 
        INNER JOIN atende ON medico.id_medico = atende.id_medico 
        WHERE data_atende BETWEEN dataInicio AND dataFinal
        GROUP BY nome
    LOOP
        RETURN NEXT reg_medico;
    END LOOP;
    RETURN;
END;
$$
LANGUAGE plpgsql;

--Testar function
SELECT * FROM f_desempenhoMedico('01/01/2003', '31/12/2006') AS (nome varchar(45), quantidade_atendimentos bigint);