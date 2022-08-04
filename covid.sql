

--Select *
--From PortfolioProject..[Coviddeaths]
--where continent is not null
--order by 3,4

--Select *
--From PortfolioProject..[Covid vaccination]
--order by 3,4

-- select data that we are going to be using

--Select Location, Date, total_cases, new_cases, total_deaths, population
--From PortfolioProject..[Coviddeaths]
--order by 1,2

-- looking at total cases vs total deaths
-- Shows likelihood of dying if you contract covid in your country
--Select Location, Date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Deathpercentage
--From PortfolioProject..[Coviddeaths]
--Where location like '%state%'
--order by 1,2

-- looking at Total cases vs Population
-- shows what percentage of population got covid
--Select Location, Date, total_cases, population, (total_cases/population)*100 as Deathpercentage
--From PortfolioProject..[Coviddeaths]
----Where location like '%nepal%'
--order by 1,2

-- looking at Countries with highest infection rate compared to population

--Select Location, Population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
--From PortfolioProject..[Coviddeaths]
----Where location like '%nepal%'
--Group by Location, Population
--order by PercentPopulationInfected desc

---- Showing Countries with Highest Death Count per population
--Select Location, MAX(total_deaths) as TotalDeathCount
--From PortfolioProject..[Coviddeaths]
----Where location like '%nepal%'
--where continent is not null
--Group by Location
--order by TotalDeathCount desc 

-- let breal things down by continet

-- Showing the continent with highest death count per population

--Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
--From PortfolioProject..[Coviddeaths]
----Where location like '%nepal%'
--where continent is not null
--Group by continent
--order by TotalDeathCount desc 

-- global numbers

--Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths,
--SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as  DeathPercentage
--From PortfolioProject..[Coviddeaths]
----Where location like '%nepal%'
--Where continent is not null
----group by date
--order by 1,2


-- looking at total population vs vaccination 

--Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
--, SUM(cast(vac.new_vaccinations as bigint)) Over (Partition by dea.Location Order by dea.location, cast(dea.date as bigint)) as RollingPeopleVaccinated
--From PortfolioProject..[Coviddeaths] dea
--join PortfolioProject..[Covid vaccination] vac
--	On dea.location = vac.location
--	and dea.date = vac.date
--where dea.continent is not null
--order by 2,3

--convert(bigint, 8) * 1024 * 1048576
--select 
--    [DAY] as [DAY],
--    [Name] as [Name],
--    ((cast([columnA] + [columnB] + [columnC] as bigint) * 1000) / NULLIF(8 * 1024 * 1048576, 0)) as [TotalColumn]
--from 
--    [TableA]
--select 
--'Monday' as [DAY],
--'Septiana Fajrin' as [Name],
--((cast('5' + '5' + '5' as Numeric) * 1000) / (convert(Numeric, 8) * 1024 * 1048576))as [TotalColumn]  

-- USE CTE

--With PopvsVAC (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
--as
--(
--Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
--, SUM(convert(int, vac.new_vaccinations)) Over (Partition by dea.Location Order by dea.location, dea.date) 
--as RollingPeopleVaccinated
--From PortfolioProject..[Coviddeaths] dea
--join PortfolioProject..[Covid vaccination] vac
--	On dea.location = vac.location
--	and dea.date = vac.date
--where dea.continent is not null
----order by 2,3
--)
--Select *, (RollingPeopleVaccinated/Population)*100
--From PopvsVAC

-- Using Temp Table to perform Calculation on Partition By in previous query

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From PortfolioProject..[Covid vaccination] vac
Join PortfolioProject..[Coviddeaths] dea
	On dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null 
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated





