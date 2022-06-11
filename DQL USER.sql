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

-- USING WITH TO SAVE TABLE DATA FOR NOT LOOP IN SAME TABLE A LOT OF TIMES
with 
	UniqueRecentDescritionTable(IdSolicitacao) as 
		(select MAX(s.Id) from Solicitacao s group by s.Descricao),
	SolicitacaoUsuarioTable(Nome, Descricao) as 
		(select distinct 
				u.Nome, 
				s.Descricao 
			from Solicitacao s
			inner join Usuario u on s.IdUsuario = u.Id)
select 
	s.Descricao
	,s.DataInclusao
	,s.Id as IdSolicitacao
	,u.Nome as 'Último usuário que solicitou'
	,STUFF((select case when ss.Nome <> u.Nome
			then ', ' + ss.Nome
			else ' e ' + ss.Nome end
		from SolicitacaoUsuarioTable ss
		where ss.Descricao like s.Descricao
		for xml path('')), 1, 2, '') as 'Usuários com a mesma solicitacao'
from Solicitacao as s with(nolock)
inner join Usuario as u with(nolock) on s.IdUsuario = u.Id
inner join UniqueRecentDescritionTable as t with(nolock) on t.IdSolicitacao = s.Id
order by DataInclusao desc
