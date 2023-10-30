

 select iso_code, sum(new_cases)/population,
 case 
	when sum(new_cases)/population > 0.1 then 'A'
	when sum(new_cases)/population between 0.05 and 0.1 then 'B'
	else 'C'
end
from De
 group by iso_code, population
 
 ------------------------------------------------------------------------------------------------------

 alter table [SQL project1].dbo.De
 alter column total_deaths int
  
select location, continent, date, total_cases, new_cases, total_deaths, population, (total_deaths/total_cases)*100 as 'PercentofDeath [%]'
 from [SQL project1].dbo.De
 where location in ('Poland','Germany') or continent like 'Asi%'
 order by 2

------------------------------------------------------------------------------------------------------

 select location, population, max(total_cases), max((total_cases/population))*100
 from [SQL project1].dbo.De
 where continent is not null
 group by location, population
 having population >=50000000
 order by 1

 ------------------------------------------------------------------------------------------------------

  select continent, max(total_deaths)
 from [SQL project1].dbo.De
 where continent is not null
 group by continent
 order by continent desc

 ------------------------------------------------------------------------------------------------------

 alter table [SQL project1].dbo.De
 alter column new_deaths int

 select date, sum(new_cases), sum(new_deaths), (sum(new_deaths)/sum(new_cases))*100 as 'PercentofDeath [%]'
 from [SQL project1].dbo.De
 where continent is not null
 group by date
 order by 1,2

 ------------------------------------------------------------------------------------------------------

 select De.continent, De.location, de.date, de.population, va.new_vaccinations
 from De
 join Va
 on de.location = va.location
 and de.date = va.date
 where de.continent is not null
 order by 1,2

 ------------------------------------------------------------------------------------------------------

  select de.iso_code, va.continent, de.new_cases, sum(de.new_cases) over (partition by va.location)
 from De
 join Va
 on de.location = va.location
 and de.date = va.date
 where va.continent is not null
 order by 1,2

 ------------------------------------------------------------------------------------------------------

 drop table if exists #MyTable
 create table #MyTable (
 location nvarchar(255),
 date datetime,
 new_cases int,
 new_vaccinations int)

 insert into #MyTable
 select de.location, de.date, de.new_cases, va.new_vaccinations
 from De
 join Va
 on de.location = va.location
 and de.date = va.date
 where va.continent is not null
 order by 1,2
 
 select * 
 from #MyTable
