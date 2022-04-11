DECLARE @Cpfs VARCHAR(MAX) = ' 309.681.760-03 ,   941.643.460-43, 389.598.620-88'

SELECT
	U.Nome
	,U.CPF
	,S.Descricao
	,FORMAT(S.DataInclusao, 'dddd, dd \de MMMM \de yyyy  à\s hh:mm tt', 'pt-br') as Quando
	,CONCAT(DATEDIFF(YEAR, U.DataNascimento, GETDATE()), ' anos') AS Idade
	,CASE WHEN U.Ativo = 1 THEN 'Sim' ELSE 'Não' END AS Ativo
FROM Usuario U (NOLOCK)
INNER JOIN Solicitacao S (NOLOCK) ON S.IdUsuario = U.Id
WHERE REPLACE(REPLACE(REPLACE(U.CPF, ' ', ''), '.', ''), '-', '') 
	IN (SELECT REPLACE(REPLACE(REPLACE(value, ' ', ''), '.', ''), '-', '') FROM string_split(@Cpfs, ','))
ORDER BY U.Nome