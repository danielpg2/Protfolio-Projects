-- Covid 19 Data Exploration 

SELECT location, date, total_cases, new_deaths, total_deaths, population 
FROM CovidPortfolioProject.dbo.CovidDeaths
ORDER BY 1 

-- Looking at Total cases vs Total Deaths
-- Likelihhod of dying if you contract covid in your country
SELECT location, date, total_cases, total_deaths , ((CAST(total_deaths AS FLOAT)) / (NULLIF(CAST(total_cases AS FLOAT), 0)))*100 AS DeathPrecentage
FROM CovidPortfolioProject.dbo.CovidDeaths
WHERE Continent iS NOT NULL
AND location like '%israel%'
ORDER BY 1

-- Looking at the Total Cases vs Population
-- Shows what percentage of the population got infected with Covid
SELECT location, date, total_cases ,population ,((CAST(total_cases AS FLOAT)) / (NULLIF(CAST(population AS FLOAT), 0)))*100 AS InfectedPopulation
FROM CovidPortfolioProject.dbo.CovidDeaths
WHERE Continent iS NOT NULL
AND location like '%israel%'
ORDER BY 1

-- Looking at the Countries with the highest infected rate compared to Population

SELECT location, population, MAX(CAST(total_cases AS FLOAT)) AS HighestInfectionCount, (MAX(CAST(total_cases AS FLOAT)) / MAX((CAST(population AS FLOAT))))*100 AS PercentOfPopulationInfected
FROM CovidPortfolioProject.dbo.CovidDeaths 
WHERE Continent iS NOT NULL
-- AND LOCATION LIKE '%COUNTRY%'
GROUP BY Location, Population
ORDER BY PercentOfPopulationInfected DESC


-- Looking at the Countries with the highest death rate 

SELECT location ,MAX(CAST(total_deaths AS INT)) AS TotalDeath
FROM CovidPortfolioProject.dbo.CovidDeaths
WHERE continent iS NOT NULL
AND  location NOT IN ('World' , 'High income' , 'Upper middle income' , 'Europe' , 'Asia' , 'North America' ,'South America' , 'Lower middle income' , 'European Union')
GROUP BY location
ORDER BY TotalDeath DESC

-- Looking at Continents with the highest death rate

SELECT continent ,SUM(CAST(new_deaths AS INT)) AS TotalDeath
FROM CovidPortfolioProject.dbo.CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeath DESC
OFFSET 1 ROW

-- Global numbers of corona cases

SELECT  MAX(cast(total_cases AS BIGINT)) AS TotalCases, MAX(CAST(total_deaths AS INT)) AS TotalDeath, (MAX(CAST(total_deaths AS FLOAT)) / MAX(NULLIF(CAST(total_cases AS FLOAT),0)))*100 AS DeathPrecentage
FROM CovidPortfolioProject.dbo.CovidDeaths
WHERE continent IS NOT NULL
--AND location like '%israel%'



-- Looking at Total Population vs Vaccinations(1)
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CAST(vac.new_vaccinations AS BIGINT)) OVER (Partition by dea.location ORDER BY dea.location,YEAR(dea.date),MONTH(dea.date), DAY(dea.date)) AS TotalVaccinationByCountryAndDate

FROM CovidPortfolioProject.dbo.CovidDeaths dea
JOIN CovidPortfolioProject.dbo.CovidVaccinations vac
 ON dea.location = vac.location
 AND dea.date = vac.date
 WHERE dea.continent IS NOT NULL
 AND  dea.location NOT IN ('World' , 'High income' , 'Upper middle income' ,'Low income', 'Europe' , 'Asia' , 'North America' ,'South America' , 'Lower middle income' , 'European Union', 'Africa','Oceania')
 ORDER BY 1,2


 -- Looking at Total Population vs Vaccinations(2) (ADVANCED VERSION WITH EXTRA INFO)
 --TEMP TABLE
 --DROP TABLE #PrecentageOfPopulationThatIsVaccinated (Just incase it already exists)
 CREATE TABLE #PrecentageOfPopulationThatIsVaccinated
 (continent NVARCHAR(225),location NVARCHAR(225),date DATE,population BIGINT,new_vaccinations BIGINT, TotalVaccinationByCountryAndDate FLOAT)


INSERT INTO #PrecentageOfPopulationThatIsVaccinated
 SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CAST(vac.new_vaccinations AS BIGINT)) OVER (Partition by dea.location ORDER BY dea.location,YEAR(dea.date),MONTH(dea.date), DAY(dea.date)) AS TotalVaccinationByCountryAndDate
FROM CovidPortfolioProject.dbo.CovidDeaths dea
JOIN CovidPortfolioProject.dbo.CovidVaccinations vac
 ON dea.location = vac.location
 AND dea.date = vac.date
 WHERE dea.continent IS NOT NULL
 AND  dea.location NOT IN ('World' , 'High income' , 'Upper middle income' ,'Low income', 'Europe' , 'Asia' , 'North America' ,'South America' , 'Lower middle income' , 'European Union', 'Africa','Oceania')
 ORDER BY 1,2

 SELECT *,(TotalVaccinationByCountryAndDate/population)*100 AS VaccinationDosesReceivedPerPopulation
 --Above 100% means that every citizen recived more than one vaccination on average
 FROM #PrecentageOfPopulationThatIsVaccinated
 --WHERE location = 'israel'



