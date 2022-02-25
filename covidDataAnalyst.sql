use covidData
--Return all data in covidDeath table
select * from covid19death
where location='asia'
order by 3,4








--Return all data in covidVassination table
--select * from covid19vassination
--order by 3,4

select location,date,total_cases,new_cases,total_deaths,population
from covid19death
where location like '%states%'
order by 1,2



--- looking at total cases vs total death
select location,date,total_cases,total_deaths, (total_deaths/total_cases)*100 as death_percentage
from covid19death
where continent is not null
order by 1,2

--- looking at total cases vs population
---Shows what population percentage has gotten covid
select location,date,population,total_cases, (total_cases/population)*100 as infection_percentage
from covid19death
where continent is not null
order by 1,2


---looking for countries with highest infection rate per population.
select location,population,max(total_cases)as Infection_cases, max(total_cases/population)*100 as infectedPopulationPercentage
from covid19death
where continent is not null
group by location,population
order by infectedPopulationPercentage desc

---Looking for countries with the highest death count per population
select location,population,max(cast(total_deaths as int))as deaths_cases, max(cast(total_deaths as int)/population)*100 as deathsPercentagePerPopulation
from covid19death
where continent is not null
group by location,population
order by deathsPercentagePerPopulation desc

---Looking for countries with the highest death count
select location,max(cast(total_deaths as int))as deaths_cases
from covid19death
where continent is not null
group by location
order by deaths_cases desc

-- create view for countries with the highest death count
create view highest_death_count
as
select location,max(cast(total_deaths as int))as deaths_cases
from covid19death
where continent is not null
group by location



--break down death count by continent

---Looking for countries with the highest death count
-- location,max(cast(total_deaths as int))as deaths_cases
--from covid19death
--where continent is  null and location not like '%income%'
--group by location
--order by deaths_cases desc

--Showing the continent with the highest death count per population
select continent,max(cast(total_deaths as int))as deaths_cases
from covid19death
where continent is not  null 
group by continent
order by deaths_cases desc

--create view for continent with the highest death
create view continent_deaths as
select continent,max(cast(total_deaths as int))as deaths_cases
from covid19death
where continent is not  null 
group by continent

--Global numbers by date

select date,sum(new_cases)as Total_new_cases,sum(cast(new_deaths as int))as Total_new_deaths,(sum(cast(new_deaths as int))/sum(new_cases))*100 as death_percentage
from covid19death
where continent is not null
group by date
order by 1,2

--create view for global_numbers_byDate
create view global_numbers_byDate 
as
select date,sum(new_cases)as Total_new_cases,sum(cast(new_deaths as int))as Total_new_deaths,(sum(cast(new_deaths as int))/sum(new_cases))*100 as death_percentage
from covid19death
where continent is not null
group by date

--Global total numbers 
select sum(new_cases)as Total_new_cases,sum(cast(new_deaths as int))as Total_new_deaths,(sum(cast(new_deaths as int))/sum(new_cases))*100 as death_percentage
from covid19death
where continent is not null
order by 1,2

--create view for global total numbers
create view global_total_number
as
select sum(new_cases)as Total_new_cases,sum(cast(new_deaths as int))as Total_new_deaths,(sum(cast(new_deaths as int))/sum(new_cases))*100 as death_percentage
from covid19death
where continent is not null


--covid19vassination
select * from covid19vassination
where location like '%states%'
order by date

--looking at total vassinated population percentage.
select de.continent,de.location,de.date, de.population, vas.new_vaccinations, sum(cast(vas.new_vaccinations as float)) over (partition by de.location order by de.location, de.date )as Rolling_people_vassinated
 from covid19death de join covid19vassination vas
on de.location=vas.location and  de.date = vas.date
where de.continent is not null and de.location='albania'
order by 2,3 


--USE CTE

WITH PopVsVas(continent,location,date,population,new_vaccinations,Rolling_people_vassinated)
as
(
select de.continent,de.location,de.date, de.population, vas.new_vaccinations, sum(cast(vas.new_vaccinations as float)) over (partition by de.location order by de.location, de.date )as Rolling_people_vassinated
 from covid19death de join covid19vassination vas
on de.location=vas.location and  de.date = vas.date
where de.continent is not null and de.location='nigeria'

)
select *, (Rolling_people_vassinated/population)*100   from PopVsVas


---Temp Table


create table #PercentPopulationVassinated
(
	continent varchar(255),
	location varchar(255),
	date datetime,
	population float,
	new_vassinations float,
	Rolling_people_vassinated float
)

insert into #PercentPopulationVassinated
select de.continent,de.location,de.date, de.population, vas.new_vaccinations, sum(cast(vas.new_vaccinations as float)) over (partition by de.location order by de.location, de.date )as Rolling_people_vassinated
 from covid19death de join covid19vassination vas
on de.location=vas.location and  de.date = vas.date
where de.continent is not null

select *, (Rolling_people_vassinated/population)*100   from #PercentPopulationVassinated


create view PercentPopulationVassinated as
select de.continent,de.location,de.date, de.population, vas.new_vaccinations, sum(cast(vas.new_vaccinations as float)) over (partition by de.location order by de.location, de.date )as Rolling_people_vassinated
 from covid19death de join covid19vassination vas
on de.location=vas.location and  de.date = vas.date
where de.continent is not null





