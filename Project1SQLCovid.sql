
select * from PortfolioProject2..CovidDeaths
where continent is not null
order by 3,4

--select * from PortfolioProject2..CovidVaccinations
--order by 3,4

--select data 

select location,date, total_cases, new_cases, total_deaths, population
from PortfolioProject2..CovidDeaths
where continent is not null
order by 1,2

--total cases vs total deaths

select location,date, total_cases, total_deaths, ((total_deaths/total_cases)*100) as percentage_total_deaths
from PortfolioProject2..CovidDeaths
WHERE location like '%Indonesia%' and continent is not null
order by 1,2

--Total cases vs population
select location, date, population, total_cases, ((total_cases/population)*100) as percentage_total_population
from PortfolioProject2..CovidDeaths
WHERE location like '%Indonesia%' and continent is not null
order by 1,2

--Highest infection rate compared to population
Select location, population, max(total_cases) as Highest_infection, Max((total_cases/population)*100) as percentage_population_infected
from PortfolioProject2..CovidDeaths
where continent is not null
group by location, population
order by percentage_population_infected desc 

--Country with highest death count per population
select location, max(cast(total_deaths as int)) as Total_death_count
from PortfolioProject2..CovidDeaths
where continent is not null
group by location
order by Total_death_count desc

--grouping by continent
select continent, max(cast(total_deaths as int)) as total_death_count
from PortfolioProject2..CovidDeaths
where continent is not null
group by continent
order by total_death_count desc

select location, max(cast(total_deaths as int)) as total_death_count
from PortfolioProject2..CovidDeaths
where continent is null
group by location
order by total_death_count desc

--continents highest death count/population
select continent, max(cast(total_deaths as int)) as total_death_count
from PortfolioProject2..CovidDeaths
where continent is not null
group by continent
order by total_death_count desc

--Global number
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as percentage_of_deaths
from PortfolioProject2..CovidDeaths
where continent is not null
order by 1,2

select date, sum(new_cases) as total_new_cases, sum(cast(new_deaths as int)) as total_new_deaths, (sum(cast(new_deaths as int))/sum(new_cases))*100 as percentage_of_death
from PortfolioProject2..CovidDeaths
where continent is not null
group by date
order by 1,2

select --date 
sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, (sum(cast(new_deaths as int))/sum(new_cases))*100 as percentage_of_death
from PortfolioProject2..CovidDeaths
where continent is not null
--group by date
order by 1,2

--Total population vs vaccinations
select * from PortfolioProject2..CovidDeaths
select * from PortfolioProject2..CovidVaccinations

select dth.continent, dth.location, dth.date, dth.population, vcn.new_vaccinations
from PortfolioProject2..CovidDeaths dth
JOIN PortfolioProject2..CovidVaccinations vcn
	on dth.location = vcn.location
	and dth.date = vcn.date
where dth.continent is not null
order by 1,2,3

select dth.continent, dth.location, dth.date, dth.population, vcn.new_vaccinations
, sum(convert(int, vcn.new_vaccinations)) over (partition by dth.location order by dth.location, dth.date) as people_vaccinations
from PortfolioProject2..CovidDeaths dth
JOIN PortfolioProject2..CovidVaccinations vcn
	on dth.location = vcn.location
	and dth.date = vcn.date
where dth.continent is not null
order by 2,3

--use cte
with popvsvac (continent, location, date, population, new_vaccinations, people_vaccinations)
as 
(
select dth.continent, dth.location, dth.date, dth.population, vcn.new_vaccinations
, sum(convert(int, vcn.new_vaccinations)) over (partition by dth.location order by dth.location, dth.date) as people_vaccinations
from PortfolioProject2..CovidDeaths dth
JOIN PortfolioProject2..CovidVaccinations vcn
	on dth.location = vcn.location
	and dth.date = vcn.date
where dth.continent is not null
--order by 2,3
)
select *, (people_vaccinations/population)*100 AS percent_people_vaccinated from popvsvac order by location, date

--Create view
create view percentpopulationvaccinated as 
select dth.continent, dth.location, dth.date, dth.population, vcn.new_vaccinations
, sum(convert(int, vcn.new_vaccinations)) over (partition by dth.location order by dth.location, dth.date) as people_vaccinations
from PortfolioProject2..CovidDeaths dth
JOIN PortfolioProject2..CovidVaccinations vcn
	on dth.location = vcn.location
	and dth.date = vcn.date
where dth.continent is not null
--order by 2,3

--run view
select * from percentpopulationvaccinated order by location, date

--testing
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as percentage_of_deaths
from PortfolioProject2..CovidDeaths
where continent is not null and location like '%Korea%'
order by 1,2

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as percentage_of_deaths
from PortfolioProject2..CovidDeaths
where continent is not null and location like '%states%'
order by location, date


select dth.continent, dth.location, dth.date, dth.population, vcn.new_vaccinations
, sum(cast(vcn.new_vaccinations as int)) as people_vaccinations
from PortfolioProject2..CovidDeaths dth
JOIN PortfolioProject2..CovidVaccinations vcn
	on dth.location = vcn.location
	and dth.date = vcn.date
where dth.continent is not null
group by dth.continent, dth.location, dth.date, dth.population, vcn.new_vaccinations
order by 2,3


select location, max(cast(total_deaths as int)) as Total_death_count
from PortfolioProject2..CovidDeaths
where continent is not null
group by location
order by Total_death_count desc

select location, max(convert(bigint, total_vaccinations))+1 as total_vaccinations_count
from PortfolioProject2..CovidVaccinations
where continent is not null
group by location
order by total_vaccinations_count desc

select continent, max(convert(bigint, total_vaccinations))+1 as total_vaccinations_count
from PortfolioProject2..CovidVaccinations
where continent is not null
group by continent
order by total_vaccinations_count desc