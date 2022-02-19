--DDL SCRIPS

use [V1-2022]

drop table if exists [Feriado]
drop table if exists [Agendamento]

create table [Feriado] (
	[Id] int primary key identity(1, 1),
	[Name] nvarchar(100),
	[Dia] int not null,
	[Mes] int not null,
	[Ano] int,
)

create table [Agendamento] (
	[Id] int primary key identity (1, 1),
	[PacienteNome] nvarchar(100),
	[Data] datetime not null,
)

go
