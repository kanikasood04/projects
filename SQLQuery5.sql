select * from Portfolioproject..['covid-deaths$']
where continent is not null
order by 3,4

select * from Portfolioproject..['covid-vaccinations$']
order by 3,4

select location, date, total_cases, new_cases, total_deaths, population from Portfolioproject..['covid-deaths$']
order by 1,2

--looking at total cases and total deaths

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Deathpercentage 
from Portfolioproject..['covid-deaths$']
order by 1,2
--where for searchinf us rate(shows the likelyhood of dying if you contract covid in your country)
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Deathpercentage 
from Portfolioproject..['covid-deaths$']
where location like'%states%'
order by 1,2


--looking at the total cases vs populations
--shows what % of population got covid
select location, date, total_cases, population, (total_cases/population)*100 as percentpopulationinfected 
from Portfolioproject..['covid-deaths$']
--where location like'%states%'
order by 1,2

--looking at countries with highest infection rate compared to population

select location, population, max(total_cases)as highestInfectioncount, max((total_cases/population))*100 as percentpopulationinfected 
from Portfolioproject..['covid-deaths$']
--where location like'%states%'
group by location, population
order by percentpopulationinfected desc

--showing countries with highest death count per population


select location,  max(total_deaths)as totaldeathcount
from Portfolioproject..['covid-deaths$']
--where location like'%states%'
group by location
order by totaldeathcount desc
 --to get more accurate value use cast as mentioned below
 
select location,  max(cast (total_deaths as int))as totaldeathcount
from Portfolioproject..['covid-deaths$']
--where location like'%states%'
group by location
order by totaldeathcount desc




select location,  max(cast (total_deaths as int))as totaldeathcount
from Portfolioproject..['covid-deaths$']
--where location like'%states%'
where continent is  null
group by location
order by totaldeathcount desc

--lets just do this with continents instead of locations


select continent,  max(cast (total_deaths as int))as totaldeathcount
from Portfolioproject..['covid-deaths$']
--where location like'%states%'
where continent is not null
group by continent
order by totaldeathcount desc


--next one is showing the continents with the highest deathcounts, as we did for location do it for continents
select continent,  max(cast (total_deaths as int))as totaldeathcount
from Portfolioproject..['covid-deaths$']
--where location like'%states%'
where continent is not null
group by continent
order by totaldeathcount desc



--GLOBAL NUMBERS

select  date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Deathpercentage 
from Portfolioproject..['covid-deaths$']
--where location like'%states%'
where continent is not null
order by 1,2

--ACROSS THE WORLD WE GHONNA SEE TOTAL CASES AND TOTAL DEATHS AND %AGE

select  date, SUM(new_cases)as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/SUM(new_cases)*100 as Deathpercentage 
from Portfolioproject..['covid-deaths$']
--where location like'%states%'
where continent is not null
group by date
order by 1,2

--overall across the world total cases are( remove date)
select  SUM(new_cases)as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/SUM(new_cases)*100 as Deathpercentage 
from Portfolioproject..['covid-deaths$']
--where location like'%states%'
where continent is not null

order by 1,2

--apply join between these 2 tables (looking at total population vs vaccinations) people in the world has been vaccinated

select dea.continent, dea.location,dea.date, dea.population, vac.new_vaccinations from  Portfolioproject..['covid-deaths$'] dea
join Portfolioproject..['covid-vaccinations$'] vac
on dea.location=vac.location 
and dea.date=vac.date
where dea.continent is not null
order by 2,3

--GETTING RESULT BY ADDING NEW VACCINATION OF ONE COUNTRY TO THE OTHER COUNTRY
select dea.continent, dea.location,dea.date, dea.population, vac.new_vaccinations, 
SUM(cast( vac.new_vaccinations as bigint)) OVER (PARTITION BY  dea.location order by 
dea.location, dea.date) as rollingpeoplevaccinated
from  Portfolioproject..['covid-deaths$'] dea
join Portfolioproject..['covid-vaccinations$'] vac
on dea.location=vac.location 
and dea.date=vac.date
--where dea.continent is not null
order by 2,3

--use CTE

with PopvsVac ( continent, location, date, population, new_vaccination, rollingpeoplevaccinated)
as
(
Select dea.continent, dea.location,dea.date, dea.population, vac.new_vaccinations, 
SUM(cast( vac.new_vaccinations as bigint)) OVER (PARTITION BY  dea.location order by 
dea.location, dea.date) as rollingpeoplevaccinated
from  Portfolioproject..['covid-deaths$'] dea
join Portfolioproject..['covid-vaccinations$'] vac
on dea.location=vac.location 
and dea.date=vac.date
where dea.continent is not null
--order by 2,3
)
select *, (rollingpeoplevaccinated/population)*100
from PopvsVac




--TEMP TABLE
drop table if exists #percentpopulationvaccinated
 Create table #percentpopulationvaccinated
 (
 continent nvarchar(255),
 location nvarchar(255),
 date datetime,
 population numeric,
 new_vaccinations numeric,
 rollingpeoplevaccinated numeric
 )
 insert into #percentpopulationvaccinated
 Select dea.continent, dea.location,dea.date, dea.population, vac.new_vaccinations, 
SUM(cast( vac.new_vaccinations as bigint)) OVER (PARTITION BY  dea.location order by 
dea.location, dea.date) as rollingpeoplevaccinated
from  Portfolioproject..['covid-deaths$'] dea
join Portfolioproject..['covid-vaccinations$'] vac
on dea.location=vac.location 
and dea.date=vac.date
--where dea.continent is not null
--order by 2,3
select *, (rollingpeoplevaccinated/population)*100
from #percentpopulationvaccinated



--creating view to store data for later visualizations

Create view percentpopulationvaccinated as
Select dea.continent, dea.location,dea.date, dea.population, vac.new_vaccinations, 
SUM(cast( vac.new_vaccinations as bigint)) OVER (PARTITION BY  dea.location order by 
dea.location, dea.date) as rollingpeoplevaccinated
from  Portfolioproject..['covid-deaths$'] dea
join Portfolioproject..['covid-vaccinations$'] vac
on dea.location=vac.location 
and dea.date=vac.date
where dea.continent is not null
--order by 2,3


select * from percentpopulationvaccinated