SELECT *
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
AND continent <> ''
ORDER BY 3,4

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..CovidDeaths
ORDER BY 1,2

-- Analyse Total Cases vs Total Deaths
-- Shows the likelihood of dying from COVID

SELECT location, date, total_cases, total_deaths, (CONVERT(float, total_deaths) / NULLIF(CONVERT(float, total_cases), 0)) * 100 AS Deathpercentage
FROM PortfolioProject..CovidDeaths
ORDER BY 1,2

-- CHECK ANALYSIS FOR NIGERIA

-- Convert data type varchar to enable divide operator

-- Shows the likelihood of dying from COVID

SELECT location, date, total_cases, total_deaths, (CONVERT(float, total_deaths) / NULLIF(CONVERT(float, total_cases), 0)) * 100 AS Deathpercentage
FROM PortfolioProject..CovidDeaths
WHERE location like '%Nigeria%'
ORDER BY 1,2

-- Analyse Total Cases vs Population
-- Convert data type varchar to enable divide operator
-- Shows what percentage of population got COVID

SELECT location, date, total_cases, population, (CONVERT(float, total_cases) / NULLIF(CONVERT(float, population), 0)) * 100 AS PercentPopulationInfected
FROM PortfolioProject..CovidDeaths
WHERE location like '%Nigeria%'
ORDER BY 1,2

-- Analyse Countries with Highest Infection Rate compared to Population

SELECT location, population, MAX(total_cases) AS HighestInfectionCount, MAX((CONVERT(float, total_cases) / NULLIF(CONVERT(float, population), 0))) * 100 AS PercentPopulationInfected
FROM PortfolioProject..CovidDeaths
--WHERE location like '%Nigeria%'
GROUP BY location, population
ORDER BY PercentPopulationInfected DESC

-- Analyse Countries with Highest Death Count per Population

SELECT location, MAX(CAST(total_deaths AS INT)) AS HighestDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
AND continent <> ''
GROUP BY location
ORDER BY HighestDeathCount DESC

-- CHECK ANALYSIS BY CONTINENTS

-- Analyse Continents with Highest Death Count per Population

SELECT continent, SUM((CONVERT(float, new_deaths))) AS HighestDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY HighestDeathCount DESC


-- GLOBAL ANALYSIS

SELECT SUM(CAST(new_cases as INT)) AS TotalCases, SUM(CAST(new_deaths as INT)) AS TotalDeaths,
 CASE 
	WHEN SUM(CAST(new_cases AS INT)) = 0 THEN 0 
	ELSE SUM(CAST(new_deaths AS FLOAT)) / SUM(CAST(new_cases AS FLOAT)) * 100 
END AS DeathPercentage
FROM PortfolioProject..CovidDeaths
--WHERE location like '%Nigeria%'
WHERE continent IS NOT NULL
AND continent <> ''
ORDER BY 1,2


-- Analysing Total Population vs Vaccination


-- Using CTE

WITH POPUvsVAC (continent, location, date, population, new_vaccination, AggregatePopulationVaccinated)
AS
(
SELECT D.continent, D.location, D.date, D.population, V.new_vaccinations
, SUM(CONVERT(INT, V.new_vaccinations)) OVER (PARTITION BY D.location ORDER BY D.location, D.date) AS AggregatePopulationVaccinated
-- , (AggregatePopulationVaccinated/Population) * 100
FROM PortfolioProject..CovidDeaths D
JOIN PortfolioProject..CovidVaccinations V
	ON D.location = V.location
	AND D.date = V.date
WHERE D.continent IS NOT NULL
AND D.continent <> ''
-- ORDER BY 2,3
)

SELECT *, 
CASE
	WHEN population = 0 THEN 0
	ELSE (AggregatePopulationVaccinated * 1.0/population) * 100
END AS VaccinationPercentage
FROM POPUvsVAC


-- USING TEMP TABLE

DROP TABLE IF EXISTS #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
AggregatePopulationVaccinated numeric
)

INSERT INTO #PercentPopulationVaccinated
SELECT D.continent, D.location, D.date, D.population, V.new_vaccinations
, SUM(CONVERT(INT, V.new_vaccinations)) OVER (PARTITION BY D.location ORDER BY D.location, D.date) AS AggregatePopulationVaccinated
-- , (AggregatePopulationVaccinated/Population) * 100
FROM PortfolioProject..CovidDeaths D
JOIN PortfolioProject..CovidVaccinations V
	ON D.location = V.location
	AND D.date = V.date
WHERE D.continent IS NOT NULL
AND D.continent <> ''
-- ORDER BY 2,3

SELECT *, AggregatePopulationVaccinated/population * 100
FROM #PercentPopulationVaccinated


-- Create Views to store data for visualizations

CREATE VIEW PercentPopulationVaccinated AS
SELECT D.continent, D.location, D.date, D.population, V.new_vaccinations
, SUM(CONVERT(INT, V.new_vaccinations)) OVER (PARTITION BY D.location ORDER BY D.location, D.date) AS AggregatePopulationVaccinated
-- , (AggregatePopulationVaccinated/Population) * 100
FROM PortfolioProject..CovidDeaths D
JOIN PortfolioProject..CovidVaccinations V
	ON D.location = V.location
	AND D.date = V.date
WHERE D.continent IS NOT NULL
AND D.continent <> ''
-- ORDER BY 2,3

SELECT *
FROM PercentPopulationVaccinated