DECLARE @Cpfs VARCHAR(MAX) = ' 309.681.760-03 ,   941.643.460-43, 389.598.620-88'

SELECT
	U.Nome
	,U.CPF
	,S.Descricao
	,FORMAT(S.DataInclusao, 'dddd, dd \de MMMM \de yyyy  à\s hh:mm tt', 'pt-br') as Quando
	,CONCAT(DATEDIFF(YEAR, U.DataNascimento, GETDATE()), ' anos') AS Idade
	,CASE WHEN U.Ativo = 1 THEN 'Sim' ELSE 'Não' END AS Ativo
	,CASE WHEN DATEDIFF(YEAR, U.DataNascimento, GETDATE()) > 17 THEN 'Sim' ELSE 'Não' END AS 'Adulto'
	,CONCAT(CAST(E.Classificacao AS DECIMAL(10, 2)), ' pontos') AS 'Classificação'
FROM Usuario U (NOLOCK)
INNER JOIN Solicitacao S (NOLOCK) ON S.IdUsuario = U.Id
INNER JOIN Experiencia E (NOLOCK) ON E.IdUsuario = U.Id
WHERE REPLACE(REPLACE(REPLACE(U.CPF, ' ', ''), '.', ''), '-', '') 
	IN (SELECT REPLACE(REPLACE(REPLACE(value, ' ', ''), '.', ''), '-', '') FROM string_split(@Cpfs, ','))
GROUP BY U.Nome, U.CPF, S.Descricao, S.DataInclusao, U.DataNascimento, U.Ativo, E.Classificacao	

--SELECT DATEDIFF(YEAR, U.DataNascimento, GETDATE()) AS IDADE FROM Usuario U ORDER BY IDADE
--SELECT MIN(DATEDIFF(YEAR, U.DataNascimento, GETDATE())) AS 'MAIS NOVO' FROM Usuario U
--SELECT MAX(DATEDIFF(YEAR, U.DataNascimento, GETDATE())) AS 'MAIS VELHO' FROM Usuario U
--SELECT AVG(DATEDIFF(YEAR, U.DataNascimento, GETDATE())) AS 'MEDIA DAS IDADES' FROM Usuario U

-- DISTINCT IN ONLY ONE COLUMN
SELECT Id, Descricao
FROM Solicitacao
WHERE Id in (SELECT MIN(Id) FROM Solicitacao GROUP BY Descricao)
