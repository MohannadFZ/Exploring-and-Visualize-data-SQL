


Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/  SUM(new_cases)*100
as DeathPercentage
From ProtfolioProject..CovidDeaths
where continent is not null
order by 1,2



Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From ProtfolioProject..CovidDeaths
where continent is null
and location not in('World', 'European Union', 'International', 'Lower middle income', 'Low income', 'Upper middle income', 'High income')
group by location
order by TotalDeathCount desc



Select Location, population, MAX(total_cases)as HighestInfectionCount,
(MAX(total_cases)/population)*100 AS 'PercentagePopulationInfected'
From ProtfolioProject..CovidDeaths
Group by Location, population
order by PercentagePopulationInfected desc




Select Location, population, date, MAX(total_cases)as HighestInfectionCount,
(MAX(total_cases)/population)*100 AS 'PercentagePopulationInfected'
From ProtfolioProject..CovidDeaths
Group by Location, population, date
order by PercentagePopulationInfected desc