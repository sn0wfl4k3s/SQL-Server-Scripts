--https://stackoverflow.com/questions/1209181/what-represents-a-double-in-sql-server

DROP TABLE IF EXISTS Solicitacao
DROP TABLE IF EXISTS Usuario
DROP TABLE IF EXISTS Experiencia
GO

CREATE TABLE Usuario (
	Id				UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
	Nome			NVARCHAR(50) NOT NULL,
	CPF				NVARCHAR(14) NOT NULL,
	DataInclusao	DATETIME NOT NULL DEFAULT GETDATE(),
	DataNascimento	DATE NOT NULL,
	Ativo			BIT NOT NULL
)
GO

CREATE TABLE Solicitacao (
	Id				UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
	Descricao		NVARCHAR(200) NOT NULL,
	DataInclusao	DATETIME NOT NULL DEFAULT GETDATE()
)
GO

CREATE TABLE Experiencia (
	Id				UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
	IdUsuario		UNIQUEIDENTIFIER NOT NULL,
	Classificacao	FLOAT(10) NOT NULL
)
GO

ALTER TABLE Solicitacao ADD IdUsuario UNIQUEIDENTIFIER DEFAULT NEWID()
ALTER TABLE Solicitacao DROP CONSTRAINT IF EXISTS Solicitacao_IdUsuario_FK
ALTER TABLE Experiencia DROP CONSTRAINT IF EXISTS Experiencia_IdUsuario_FK
ALTER TABLE Solicitacao ADD CONSTRAINT Solicitacao_IdUsuario_FK FOREIGN KEY (IdUsuario) REFERENCES Usuario(Id)
ALTER TABLE Experiencia ADD CONSTRAINT Experiencia_IdUsuario_FK FOREIGN KEY (IdUsuario) REFERENCES Usuario(Id)
GO


BEGIN TRANSACTION

BEGIN TRY
	INSERT INTO Usuario (Nome, CPF, DataNascimento, Ativo) VALUES 
		('Eduardo', '941.643.460-43', '1993-12-19', 1)
		,('Davi', '309.681.760-03', '2010-06-17', 1)
		,('Vânia', '389.598.620-88', '1975-09-15', 1)

	DECLARE @Key1 UNIQUEIDENTIFIER
	DECLARE @Key2 UNIQUEIDENTIFIER
	DECLARE @Key3 UNIQUEIDENTIFIER

	SELECT TOP 1 @Key1 = U.Id FROM (SELECT ROW_NUMBER() OVER(ORDER BY US.Id) AS Indice, Id FROM Usuario US) U WHERE U.Indice = 1
	SELECT TOP 1 @Key2 = U.Id FROM (SELECT ROW_NUMBER() OVER(ORDER BY US.Id) AS Indice, Id FROM Usuario US) U WHERE U.Indice = 2
	SELECT TOP 1 @Key3 = U.Id FROM (SELECT ROW_NUMBER() OVER(ORDER BY US.Id) AS Indice, Id FROM Usuario US) U WHERE U.Indice = 3

	INSERT INTO Solicitacao (Descricao, IdUsuario) VALUES
		('Um problema ocorreu ao realizar login', @Key1)
		,('Não consegui me logar no sistema..', @Key1)
		,('Cara alguem me ajuda', @Key2)
		,('Login inválido, mas eu acabei de me cadastrar', @Key3)
	
	INSERT INTO Experiencia (IdUsuario, Classificacao) VALUES
		(@Key1, 2.599)
		,(@Key2, 258.78)
		,(@Key3, 42.49)

	COMMIT;
END TRY
BEGIN CATCH
	ROLLBACK;
END CATCH

