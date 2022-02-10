use [V1-2022]
go

create procedure InserirCurso  
	@nome	varchar(100)
as
begin
	declare @vIdUltimoCurso	int
	declare @vExiste		int

	select @vExiste =  [Id] from [Curso] where [Nome] like @nome

	if @vExiste > 0
		begin
			select 'O curso já existe! Gravação não realizada' as retorno
		end
	else
		begin
			select @vIdUltimoCurso = max([Id]) + 1 from [Curso]

			insert into [Curso] values (@nome)
		end
end
go

exec InserirCurso 'teste'
go
