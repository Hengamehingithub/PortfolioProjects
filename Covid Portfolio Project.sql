
select * from PortfolioProject..CovidDeaths$
order by 3,4

--select * from PortfolioProject..CovidVaccinations$
--order by 3,4

--select Data I am going to be using

select Location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject..CovidDeaths$
order by 1,2


-- Looking at Total Cases vs Total Deaths
-- shows likelihood of dying if you contract covid in your country
select Location, date, total_cases, new_cases, total_deaths, 
(total_deaths/total_cases)*100 as Deathpercentage 
from PortfolioProject..CovidDeaths$
order by 1,2


select Location, date, total_cases, new_cases, total_deaths, 
(total_deaths/total_cases)*100 as Deathpercentage 
from PortfolioProject..CovidDeaths$
where Location like '%states%'
order by 1,2

-- Looking at the Total Cases vs Poulation
-- Shows what percentage of population got covid


select Location, date, total_cases, population, 
(total_cases/population)*100 as Deathpercentage 
from PortfolioProject..CovidDeaths$
where Location like '%states%'
order by 1,2

select Location, date, total_cases, population, 
(total_cases/population)*100 as Deathpercentage 
from PortfolioProject..CovidDeaths$
order by 1,2


-- Looking at countries with highest Infection Rate compared to population

select Location, date, population, total_cases, 
MAX((total_cases/population))*100 as Deathpercentage 
from PortfolioProject..CovidDeaths$
Group by Location

-- Lets break things down by continent
-- Showing countries with highest death count per population

select location, MAX(cast(total_deaths as int)) as TotalDeathcount 
from PortfolioProject..CovidDeaths$
where continent is not null
Group by location
order by TotalDeathcount desc


-- Showing the continents with the highest death count per population

select continent, MAX(cast(total_deaths as int)) as TotalDeathcount 
from PortfolioProject..CovidDeaths$
where continent is not null
Group by continent
order by TotalDeathcount desc
 


-- Global numbers

select date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, 
SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths$
where continent is not null
Group by date
order by 1,2

-- Overal

select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, 
SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths$
where continent is not null
--Group by date
order by 1,2




Select * 
from PortfolioProject..CovidDeaths$ dea
join PortfolioProject..CovidVaccinations$ vac
on dea.location = vac.location
and dea.date = vac .date


--Looking at total population vs Vaccination

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
from PortfolioProject..CovidDeaths$ dea
join PortfolioProject..CovidVaccinations$ vac
on dea.location = vac.location
and dea.date = vac .date
where dea.continent is not null
order by 2,3


-- partition by

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as int)) over (partition by dea.Location order by dea.Location, dea.date)
from PortfolioProject..CovidDeaths$ dea
join PortfolioProject..CovidVaccinations$ vac
on dea.location = vac.location
and dea.date = vac .date
where dea.continent is not null
order by 2,3



-- Creating View to store for later visualisations




select continent, MAX(cast(total_deaths as int)) as TotalDeathcount 
from PortfolioProject..CovidDeaths$
where continent is not null
Group by continent
order by TotalDeathcount desc
 

Create View PercentPopulationVaccinated as 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as int)) over (partition by dea.Location order by dea.Location, dea.date) 
  as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths$ dea
join PortfolioProject..CovidVaccinations$ vac
   on dea.location = vac.location
   and dea.date = vac .date
where dea.continent is not null


select * 
From PercentPopulationVaccinated



