
Select *
From ProtfolioProject..CovidDeaths
where continent is not null
order by 3,4

-- Select Data that we are going to be using
Select Location, date, total_cases, new_cases, total_deaths, population
From ProtfolioProject..CovidDeaths
where continent is not null
order by 1,2


-- looking at total cases vs total death

Select Location, date, total_cases, total_deaths,
(CONVERT(DECIMAL(15, 3), total_deaths) / total_cases)*100 AS 'Death_Percentage'
From ProtfolioProject..CovidDeaths
where location like '%state%'
and continent is not null
order by 1,2



-- looking at total cases vs Population
-- show what percentage of population got covid

Select Location, date, population, total_cases,
(total_cases/population)*100 AS 'PercentagePopulationInfected'
From ProtfolioProject..CovidDeaths
where continent is not null
order by 1,2



-- Looking at Countries with Highest Infection Rate compared to Population

Select Location, population, MAX(total_cases)as HighestInfectionCount,
(MAX(total_cases)/population)*100 AS 'PercentagePopulationInfected'
From ProtfolioProject..CovidDeaths
where continent is not null
Group by Location, population
order by PercentagePopulationInfected desc



-- Looking at Countries with Highest Death Count per Population

Select Location, MAX(total_deaths)as TotalDeathCount
From ProtfolioProject..CovidDeaths
where continent is not null
Group by Location
order by TotalDeathCount desc



-- Looking at Continent with Highest Death Count per Population

Select continent, MAX(total_deaths)as TotalDeathCount
From ProtfolioProject..CovidDeaths
where continent is not null
Group by continent
order by TotalDeathCount desc



-- GLOBAL NUMBERS

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From ProtfolioProject..CovidDeaths
where continent is not null 
order by 1,2



-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(DECIMAL(15, 3),vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From ProtfolioProject..CovidDeaths dea
Join ProtfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3


-- Using CTE to perform Calculation on Partition By in previous query

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(DECIMAL(15, 3),vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From ProtfolioProject..CovidDeaths dea
Join ProtfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac



-- Using Temp Table to perform Calculation on Partition By in previous query

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(DECIMAL(15, 3),vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From ProtfolioProject..CovidDeaths dea
Join ProtfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null 
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated




-- Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From ProtfolioProject..CovidDeaths dea
Join ProtfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 