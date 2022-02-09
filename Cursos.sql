use [V1-2022]
go

/* DDL */
drop table if exists [Curso]
go

create table [Curso] (
	[Id] int primary key identity(1, 1),
	[Nome] varchar(100),
)
go

/* DML */
insert into [Curso] values
	('Javascript'),
	('Typescript'),
	('Dotnet Core'),
	('HTML5'),
	('CSS3'),
	('C#'),
	('F#')
go

select * from [Curso]
go