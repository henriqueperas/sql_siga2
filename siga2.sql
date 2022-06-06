CREATE DATABASE siga2
GO
USE siga2
GO

CREATE TABLE aluno (
ra					INT		NOT NULL,
nome				VARCHAR(100)	NOT NULL,
PRIMARY KEY (ra)
)
GO

CREATE TABLE disciplina (
codigo				INT		NOT NULL,
nome				VARCHAR(100)	NOT NULL,
sigla				VARCHAR(5)	NOT NULL,
turno				VARCHAR(20)	NOT NULL,
num_aulas			INT		NOT NULL,
PRIMARY KEY (codigo)
)
GO

CREATE TABLE avaliacao (
codigo				INT		NOT NULL,
tipo				VARCHAR(20)	NOT NULL,
PRIMARY KEY (codigo)
)
GO

CREATE TABLE faltas (
ra_aluno			INT		NULL,
codigo_disciplina	INT		NULL,
data				DATE		NULL,
presenca			INT	NULL,
FOREIGN KEY (ra_aluno) REFERENCES aluno(ra),
FOREIGN KEY (codigo_disciplina) REFERENCES disciplina(codigo)
)
GO

CREATE TABLE notas (
ra_aluno			INT		NOT NULL,
codigo_disciplina	INT		NOT NULL,
codigo_avaliacao	INT		NOT NULL,
nota				DECIMAL(7,2)	NOT NULL,
FOREIGN KEY (ra_aluno) REFERENCES aluno(ra),
FOREIGN KEY (codigo_disciplina) REFERENCES disciplina(codigo),
FOREIGN KEY (codigo_avaliacao) REFERENCES avaliacao(codigo)
)
GO

INSERT INTO disciplina VALUES
(4203010, 'Arquitetura e Organização de Computadores', 'AOC', 'T', 0),--1
(4203020, 'Arquitetura e Organização de Computadores', 'AOC', 'N', 0),--1
(4208010, 'Laboratório de Hardware', 'LH', 'T', 0),--1
(4226004, 'Banco de Dados', 'BD', 'T', 0),--1
(4213003, 'Sistemas Operacionais I', 'SOI', 'T', 0),--2
(4213013, 'Sistemas Operacionais I', 'SOI', 'N', 0),--2
(4233005, 'Laboratório de Banco de Dados', 'LBD', 'T', 0),--3
(5005220, 'Métodos Para a Produção de Conhecimento', 'MPPC', '-', 0)--4

INSERT INTO avaliacao VALUES
(11, 1),
(12, 2),
(13, 3),
(21, 1),
(22, 2),
(23, 3),
(24, 4),
(31, 1),
(32, 2),
(33, 3),
(41, 1),
(42, 2)

--DELETE avaliacao

INSERT INTO aluno VALUES
(1110482010, 'Júlia Seabra Adarga'),
(1110482001, 'Hélia Rabelo Valadares'),
(1110482004, 'Yasmin Candeias Castelo'),
(1110482017, 'Andreia Boto Luz'),
(1110482014, 'Adam Mangueira Boga'),
(1110482007, 'Stefan Maciel Mascarenhas'),
(1110482020, 'Adelaide Toscano Guerra'),
(1110482013, 'Celina Teodoro Amaral'),
(1110482006, 'Erika Varão Caeira'),
(1110482009, 'Noé Onofre Palos'),
(1110482011, 'Ionara Cadaval Carvalhal'),
(1110482002, 'Mohammad Mieiro Rijo'),
(1110482016, 'Rania Barroqueiro Campelo'),
(1110482018, 'Leandro Jesus Varejão'),
(1110482005, 'Rayanne Lages Santana'),
(1110482003, 'Janaína Lima Fontinha'),
(1110482019, 'Anny Monte Barros'),
(1110482015, 'Sandra Ginjeira Belo'),
(1110482012, 'Avelino Caetano Paiva'),
(1110482008, 'Suzana Fonseca Negromonte')

INSERT INTO faltas (codigo_disciplina, data) VALUES
(4203010, '08/08/2022'),
(4203020, '08/08/2022'),
(4208010, '09/08/2022'),
(4226004, '11/08/2022'),
(4213003, '10/08/2022'),
(4213013, '10/08/2022'),
(4233005, '12/08/2022'),
(5005220, '09/08/2022')

SELECT * FROM aluno
SELECT * FROM disciplina
DELETE aluno

--sistema para inserir nota

CREATE PROCEDURE sp_notas2 (@ra_aluno INT, @codigo_disciplina INT , @nota DECIMAL(7,2), @saida VARCHAR(50) OUTPUT)
	AS
		DECLARE @query VARCHAR(MAX), @erro VARCHAR(MAX), @codigo_avaliacao INT

		--pegar certinho que tipo de avaliação vai ser com base no codigo da disciplina
		
		IF (@codigo_disciplina = 4213003 OR @codigo_disciplina = 4213013)
		BEGIN
			SET @codigo_avaliacao = 21
			SET @codigo_avaliacao = @codigo_avaliacao + (SELECT COUNT(ra_aluno) FROM notas WHERE @ra_aluno = ra_aluno AND codigo_disciplina = @codigo_disciplina)
			IF (@codigo_avaliacao = 23)
			BEGIN
				RAISERROR('Erro no armazenamento do produto', 16, 1)
			END
		END
		ELSE IF (@codigo_disciplina = 4233005)
		BEGIN
			SET @codigo_avaliacao = 31
			SET @codigo_avaliacao = @codigo_avaliacao + (SELECT COUNT(ra_aluno) FROM notas WHERE @ra_aluno = ra_aluno AND codigo_disciplina = @codigo_disciplina)
			IF (@codigo_avaliacao = 33)
			BEGIN
				RAISERROR('Erro no armazenamento do produto', 16, 1)
			END
		END
		ELSE IF (@codigo_disciplina = 5005220)
		BEGIN
			SET @codigo_avaliacao = 41
			SET @codigo_avaliacao = @codigo_avaliacao + (SELECT COUNT(ra_aluno) FROM notas WHERE @ra_aluno = ra_aluno AND codigo_disciplina = @codigo_disciplina)
			IF (@codigo_avaliacao = 42)
			BEGIN
				RAISERROR('Erro no armazenamento do produto', 16, 1)
			END
		END
		ELSE IF (@codigo_disciplina = 4203010 OR @codigo_disciplina = 4203020 OR @codigo_disciplina = 4208010 OR @codigo_disciplina = 4226004)
		BEGIN
			SET @codigo_avaliacao = 11
			SET @codigo_avaliacao = @codigo_avaliacao + (SELECT COUNT(ra_aluno) FROM notas WHERE @ra_aluno = ra_aluno AND codigo_disciplina = @codigo_disciplina)
			IF (@codigo_avaliacao = 13)
			BEGIN
				RAISERROR('Erro no armazenamento do produto', 16, 1)
			END
		END
		
		SET @query = 'INSERT INTO notas VALUES ('+CAST(@ra_aluno AS VARCHAR(10))+', '+CAST(@codigo_disciplina AS VARCHAR(7))+',
		'+CAST(@codigo_avaliacao AS VARCHAR(2))+', '+CAST(@nota AS VARCHAR(6))+')'

		EXEC @query
		PRINT @query
		BEGIN TRY
			EXEC (@query)
			SET @saida = 'Entrada inserida com sucesso'
		END TRY
		BEGIN CATCH
			SET @erro = ERROR_MESSAGE()
			IF (@erro LIKE '%primary%')
			BEGIN
				RAISERROR('Id duplicado', 16, 1)
			END
			ELSE
			BEGIN
				RAISERROR('Erro no armazenamento do produto', 16, 1)
			END
		END CATCH

		DECLARE @out3 VARCHAR(20)
		EXEC sp_notas2 1110482010, 4203010,10, @out3 OUTPUT
		PRINT @out3

		SELECT * FROM notas
		--DROP PROCEDURE sp_notas2
		--DELETE notas 

		

--sistema para inserir falta
CREATE PROCEDURE sp_faltas (@ra_aluno INT, @codigo_disciplina INT, @data DATE,  @presenca VARCHAR(1), @saida VARCHAR(50) OUTPUT)
	AS
		DECLARE @query VARCHAR(MAX), @erro VARCHAR(MAX), @dia_semana INT

		IF (@codigo_disciplina = 4203010 OR @codigo_disciplina = 4203020)
		BEGIN
			SET @dia_semana = 2
		END
		ELSE IF (@codigo_disciplina = 4208010 OR @codigo_disciplina = 5005220)
		BEGIN
			SET @dia_semana = 3
		END
		ELSE IF (@codigo_disciplina = 4213003 OR @codigo_disciplina = 4213013)
		BEGIN
			SET @dia_semana = 4
		END
		ELSE IF (@codigo_disciplina = 4226004)
		BEGIN
			SET @dia_semana = 5
		END
		ELSE IF (@codigo_disciplina = 4226005)
		BEGIN
			SET @dia_semana = 6
		END

		IF ((SELECT DISTINCT 1 FROM faltas WHERE codigo_disciplina = @codigo_disciplina AND DATEPART(DW,@data) = @dia_semana AND ra_aluno IS NULL AND presenca IS NULL) = 1)
		BEGIN
			SET @query = 'UPDATE faltas SET ra_aluno = '+CAST(@ra_aluno AS VARCHAR(10))+', presenca = '+CAST(@presenca AS VARCHAR(1))+'
			WHERE codigo_disciplina = '+CAST(@codigo_disciplina AS VARCHAR(7))+''
		END
		ELSE IF ((SELECT DISTINCT 1 FROM faltas WHERE codigo_disciplina = @codigo_disciplina AND DATEPART(DW,@data) = @dia_semana AND ra_aluno IS  NOT NULL AND presenca IS NOT NULL) = 1)
		BEGIN
			SET @query = 'INSERT INTO faltas VALUES ('+CAST(@ra_aluno AS VARCHAR(10))+', '+CAST(@codigo_disciplina AS VARCHAR(7))+',
			'''+CAST(@data AS VARCHAR(12))+''', '+CAST(@presenca AS VARCHAR(1))+')'
		END
		ELSE IF ((SELECT DISTINCT 1 FROM faltas WHERE codigo_disciplina = @codigo_disciplina AND DATEPART(DW,@data) = @dia_semana) IS NULL)
		BEGIN
			RAISERROR('não tem essa aula nesse dia', 16, 1)
		END

		EXEC @query
		PRINT @query
		BEGIN TRY
			EXEC (@query)
			SET @saida = 'Entrada inserida com sucesso'
		END TRY
		BEGIN CATCH
			SET @erro = ERROR_MESSAGE()
			IF (@erro LIKE '%primary%')
			BEGIN
				RAISERROR('Id duplicado', 16, 1)
			END
			ELSE
			BEGIN
				RAISERROR('Erro no armazenamento do produto', 16, 1)
			END
		END CATCH

		--DROP PROCEDURE sp_faltas
		SELECT (DATEPART(DW,'06/06/2022' ))

		DECLARE @out2 VARCHAR(50)
		EXEC sp_faltas 1110482003, 4203010, '29/08/2022', 4, @out2 OUTPUT
		PRINT @out2

		SELECT SUM(CONVERT(INT, presenca)) FROM faltas WHERE ra_aluno = 1110482003 AND codigo_disciplina = 4203010

		DROP PROCEDURE sp_faltas
		SELECT * FROM faltas
		DELETE faltas
--
CREATE FUNCTION	fn_atribui_notas (@codigo_disciplina INT)
RETURNS @tabela TABLE(
ra_aluno				INT,
nome_aluno				VARCHAR(100),
nota1					DECIMAL(7,2),
nota2					DECIMAL(7,2),
nota3					DECIMAL(7,2),
nota4					DECIMAL(7,2),
media_final				DECIMAL(7,2),
situacao				VARCHAR(50)
)
AS
BEGIN
	DECLARE @nome VARCHAR(100),
			@num_aulas INT,
			@codigo_avali INT,
			@tipo_avali INT,
			@ra_alu INT,
			@disci INT,
			@nota DECIMAL(7,2),
			@nota1 DECIMAL(7,2),
			@nota2 DECIMAL(7,2),
			@nota3 DECIMAL(7,2),
			@nota4 DECIMAL(7,2),
			@media DECIMAL(7,2),
			@situacao VARCHAR(50)

	SELECT @num_aulas = num_aulas FROM disciplina WHERE disciplina.codigo = @codigo_disciplina

	INSERT INTO @tabela SELECT aluno.ra, aluno.nome, 0, 0, 0, 0, 0, null 
	FROM aluno, notas, disciplina, avaliacao
	WHERE aluno.ra = notas.ra_aluno
		AND disciplina.codigo = notas.codigo_disciplina
		AND notas.codigo_avaliacao = avaliacao.codigo
		AND disciplina.codigo = @codigo_disciplina
	GROUP BY aluno.ra, aluno.nome

	DECLARE cursor_notas CURSOR
	FOR SELECT aluno.ra, aluno.nome, disciplina.codigo, avaliacao.codigo, notas.nota
	FROM notas, aluno, disciplina, avaliacao
	WHERE notas.ra_aluno = aluno.ra
		AND notas.codigo_disciplina = disciplina.codigo
		AND notas.codigo_avaliacao = avaliacao.codigo
		AND notas.codigo_disciplina = @codigo_disciplina
	ORDER BY aluno.ra, avaliacao.codigo
	OPEN cursor_notas
	FETCH NEXT FROM cursor_notas INTO @ra_alu, @nome, @disci, @codigo_avali, @nota

	WHILE @@FETCH_STATUS = 0
		BEGIN

		SET @nota1 = 0
		SET @nota2 = 0
		SET @nota3 = 0
		SET @nota4 = 0
		SET @media = 0

		SET @codigo_avali = (SELECT DISTINCT SUBSTRING(CONVERT(varchar(2), codigo_avaliacao), 1, 1)FROM notas WHERE @ra_alu = ra_aluno AND @disci = codigo_disciplina)

		IF(@codigo_avali = 1)
		BEGIN
			SET @nota1 = (0.3 *(SELECT nota FROM notas WHERE @ra_alu = ra_aluno AND @disci = codigo_disciplina AND codigo_avaliacao = 11))
			SET @nota2 = (0.5 *(SELECT nota FROM notas WHERE @ra_alu = ra_aluno AND @disci = codigo_disciplina AND codigo_avaliacao = 12))
			SET @nota3 = (0.2 *(SELECT nota FROM notas WHERE @ra_alu = ra_aluno AND @disci = codigo_disciplina AND codigo_avaliacao = 13))
			SET @media = @nota1 + @nota2 + @nota3
		END
		ELSE IF(@codigo_avali = 2)
		BEGIN
			SET @nota1 = (0.35 *(SELECT nota FROM notas WHERE @ra_alu = ra_aluno AND @disci = codigo_disciplina AND codigo_avaliacao = 21))
			SET @nota2 = (0.35 *(SELECT nota FROM notas WHERE @ra_alu = ra_aluno AND @disci = codigo_disciplina AND codigo_avaliacao = 22))
			SET @nota3 = (0.3 *(SELECT nota FROM notas WHERE @ra_alu = ra_aluno AND @disci = codigo_disciplina AND codigo_avaliacao = 23))
			IF(@media >= 3 AND @media <= 6)
			BEGIN
				SET @nota4 = (0.2 *(SELECT nota FROM notas WHERE @ra_alu = ra_aluno AND @disci = codigo_disciplina AND codigo_avaliacao = 24))
				SET @media = @nota1 + @nota2 + @nota3 + @nota4
			END 
			ELSE
			BEGIN
				SET @media = @nota1 + @nota2 + @nota3
			END
		END 
		ELSE IF(@codigo_avali = 3)
		BEGIN
			SET @nota1 = (SELECT nota FROM notas WHERE @ra_alu = ra_aluno AND @disci = codigo_disciplina AND codigo_avaliacao = 31)
			SET @nota2 = (SELECT nota FROM notas WHERE @ra_alu = ra_aluno AND @disci = codigo_disciplina AND codigo_avaliacao = 32)
			SET @nota3 = (SELECT nota FROM notas WHERE @ra_alu = ra_aluno AND @disci = codigo_disciplina AND codigo_avaliacao = 33)
			SET @media = (@nota1 + @nota2 + @nota3) / 3
		END
		ELSE IF(@codigo_avali = 4)
		BEGIN
			SET @nota1 = (0.8 *(SELECT nota FROM notas WHERE @ra_alu = ra_aluno AND @disci = codigo_disciplina AND codigo_avaliacao = 41))
			SET @nota2 = (0.2 *(SELECT nota FROM notas WHERE @ra_alu = ra_aluno AND @disci = codigo_disciplina AND codigo_avaliacao = 42))
		END

		IF(@media < 6)
		BEGIN
			SET @situacao = 'REPROVADO'
		END 
		ELSE
		BEGIN
			SET @situacao = 'APROVADO'
		END 

		UPDATE @tabela SET nota1 = @nota1, nota2 = @nota2, nota3 = @nota3, nota4 = @nota4, media_final = @media, situacao = @situacao WHERE ra_aluno = @ra_alu
		FETCH NEXT FROM cursor_notas INTO @ra_alu, @nome, @disci, @codigo_avali, @nota
	END
	CLOSE cursor_notas
	DEALLOCATE cursor_notas
	RETURN
END

--DROP FUNCTION fn_atribui_notas
SELECT * FROM fn_atribui_notas(4203010)
DROP FUNCTION fn_atribui_notas

CREATE FUNCTION faltas_turma(@codigo_disciplina INT) 
	RETURNS @tabela TABLE(
	ra_aluno CHAR(13),
	Nome_Aluno VARCHAR(100), 
	data1 VARCHAR(4), 
	data2 VARCHAR(4),
	data3 VARCHAR(4),
	data4 VARCHAR(4),
	data5 VARCHAR(4),
	data6 VARCHAR(4),
	data7 VARCHAR(4),
	data8 VARCHAR(4), 
	data9 VARCHAR(4), 
	data10 VARCHAR(4), 
	data11 VARCHAR(4), 
	data12 VARCHAR(4), 
	data13 VARCHAR(4), 
	data14 VARCHAR(4), 
	data15 VARCHAR(4), 
	data16 VARCHAR(4), 
	data17 VARCHAR(4), 
	data18 VARCHAR(4), 
	data19 VARCHAR(4), 
	data20 VARCHAR(4), 
	total_faltas INT)
AS
BEGIN
	DECLARE @ra INT,
			@nome VARCHAR (100),
			@data DATE,
			@presenca INT,
			@num_aulas INT,
			@inter1 INT,
			@inter2 INT,
			@inter3 VARCHAR(4)

	SELECT @num_aulas = num_aulas FROM disciplina WHERE disciplina.codigo = @codigo_disciplina
		
	INSERT INTO @tabela SELECT faltas.ra_aluno, aluno.nome, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 
	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, @num_aulas
		FROM aluno, disciplina, faltas
		WHERE faltas.ra_aluno = aluno.ra
			AND faltas.codigo_disciplina = disciplina.codigo
			AND faltas.codigo_disciplina = @codigo_disciplina
		GROUP BY faltas.ra_aluno, aluno.nome

	DECLARE c_faltas CURSOR 
		FOR SELECT faltas.ra_aluno, aluno.nome, faltas.data, faltas.presenca 
			FROM faltas, aluno, disciplina
			WHERE faltas.ra_aluno = aluno.ra 
				AND faltas.codigo_disciplina = disciplina.codigo
				AND faltas.codigo_disciplina = 4203010
			ORDER BY faltas.ra_aluno, faltas.data

	OPEN c_faltas

	FETCH NEXT FROM c_faltas INTO @ra, @nome, @data, @presenca

	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @inter1 = 1
		SELECT @inter2 = COUNT(ra_aluno) FROM faltas WHERE ra_aluno = @ra
		WHILE @inter1 <= @inter2 AND @@FETCH_STATUS = 0
			BEGIN
			
			IF @presenca = 0
			BEGIN
				SET @inter3 = 'FFFF'
			END
			IF @presenca = 1
			BEGIN
				SET @inter3 = 'PFFF'
			END
			IF @presenca = 2
			BEGIN
				SET @inter3 = 'PPFF'
			END
			IF @presenca = 3
			BEGIN
				SET @inter3 = 'PPPF'
			END
			IF @presenca = 4
			BEGIN
				SET @inter3 = 'PPPP'
			END

			IF @inter1 = 1
			BEGIN
				UPDATE @tabela SET data1 = @inter3 WHERE ra_aluno = @ra
			END
			IF @inter1 = 2
			BEGIN
				UPDATE @tabela SET data2 = @inter3 WHERE ra_aluno = @ra
			END
			IF @inter1 = 3
			BEGIN
				UPDATE @tabela SET data3 = @inter3 WHERE ra_aluno = @ra
			END
			IF @inter1 = 4
			BEGIN
				UPDATE @tabela SET data4 = @inter3 WHERE ra_aluno = @ra
			END
			IF @inter1 = 5
			BEGIN
				UPDATE @tabela SET data5 = @inter3 WHERE ra_aluno = @ra
			END
			IF @inter1 = 6
			BEGIN
				UPDATE @tabela SET data6 = @inter3 WHERE ra_aluno = @ra
			END
			IF @inter1 = 7
			BEGIN
				UPDATE @tabela SET data7 = @inter3 WHERE ra_aluno = @ra
			END
			IF @inter1 = 8
			BEGIN
				UPDATE @tabela SET data8 = @inter3 WHERE ra_aluno = @ra
			END
			IF @inter1 = 9
			BEGIN
				UPDATE @tabela SET data9 = @inter3 WHERE ra_aluno = @ra
			END
			IF @inter1 = 10
			BEGIN
				UPDATE @tabela SET data10 = @inter3 WHERE ra_aluno = @ra
			END
			IF @inter1 = 11
			BEGIN
				UPDATE @tabela SET data11 = @inter3 WHERE ra_aluno = @ra
			END
			IF @inter1 = 12
			BEGIN
				UPDATE @tabela SET data12 = @inter3 WHERE ra_aluno = @ra
			END
			IF @inter1 = 13
			BEGIN
				UPDATE @tabela SET data13 = @inter3 WHERE ra_aluno = @ra
			END
			IF @inter1 = 14
			BEGIN
				UPDATE @tabela SET data14 = @inter3 WHERE ra_aluno = @ra
			END
			IF @inter1 = 15
			BEGIN
				UPDATE @tabela SET data15 = @inter3 WHERE ra_aluno = @ra
			END
			IF @inter1 = 16
			BEGIN
				UPDATE @tabela SET data16 = @inter3 WHERE ra_aluno = @ra
			END
			IF @inter1 = 17
			BEGIN
				UPDATE @tabela SET data17 = @inter3 WHERE ra_aluno = @ra
			END
			IF @inter1 = 18
			BEGIN
				UPDATE @tabela SET data18 = @inter3 WHERE ra_aluno = @ra
			END
			IF @inter1 = 19
			BEGIN
				UPDATE @tabela SET data19 = @inter3 WHERE ra_aluno = @ra
			END
			IF @inter1 = 20
			BEGIN
				UPDATE @tabela SET data20 = @inter3 WHERE ra_aluno = @ra
			END
			UPDATE @tabela SET total_faltas = total_faltas - @presenca WHERE RA_Aluno = @ra
			FETCH NEXT FROM c_faltas INTO @ra, @nome, @data, @presenca
			SET @inter1 = @inter1 + 1
			END
	END

	RETURN

END

SELECT * FROM faltas_turma(4203010)
SELECT * FROM faltas
DROP FUNCTION faltas_turma