-- DQL SCRIPTS

use [V1-2022]

select a.Data
from [dbo].[Agendamento] as a

select a.Data
from [dbo].[Agendamento] as a
where not exists (
	select f.Dia, f.Mes
	from [dbo].[Feriado] as f
	where f.Dia = DAY(a.Data) and f.Mes = MONTH(a.Data))

go