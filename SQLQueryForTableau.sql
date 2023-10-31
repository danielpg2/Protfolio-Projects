--Covid 19 Data Visualization


-- Global numbers of corona cases
SELECT  MAX(cast(total_cases AS BIGINT)) AS TotalCases, MAX(CAST(total_deaths AS INT)) AS TotalDeath, (MAX(CAST(total_deaths AS FLOAT)) / MAX(NULLIF(CAST(total_cases AS FLOAT),0)))*100 AS DeathPrecentage
FROM CovidPortfolioProject.dbo.CovidDeaths
WHERE continent IS NOT NULL
--AND location like '%israel%'


-- TotalDeaths by Continent
SELECT continent ,SUM(CAST(new_deaths AS INT)) AS TotalDeath
FROM CovidPortfolioProject.dbo.CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeath DESC
OFFSET 1 ROW

--Population Infected By Country
SELECT location, population, MAX(CAST(total_cases AS FLOAT)) AS HighestInfectionCount, (MAX(CAST(total_cases AS FLOAT)) / MAX((CAST(population AS FLOAT))))*100 AS PercentOfPopulationInfected
FROM CovidPortfolioProject.dbo.CovidDeaths 
WHERE Continent iS NOT NULL
-- AND LOCATION LIKE '%COUNTRY%'
GROUP BY Location, Population
ORDER BY PercentOfPopulationInfected DESC


--Population Infected By Country and Date
SELECT location, population, date, MAX(CAST(total_cases AS FLOAT)) AS HighestInfectionCount, (MAX(CAST(total_cases AS FLOAT)) / MAX((CAST(population AS FLOAT))))*100 AS PercentOfPopulationInfected
FROM CovidPortfolioProject.dbo.CovidDeaths 
WHERE Continent iS NOT NULL
-- AND LOCATION LIKE '%COUNTRY%'
GROUP BY Location, Population, date
ORDER BY PercentOfPopulationInfected DESC
