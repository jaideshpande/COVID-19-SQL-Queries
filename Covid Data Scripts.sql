-- select * from CovidData.vaccinations
-- ORDER BY 3,4;

#Select data we are going to use
select Location, last_updated_date, total_cases, new_cases, total_deaths, population
FROM CovidData.deaths
order by 1,2


# Looking at Total Cases vs. Total Deaths
# Shows likelihood of dying if you contract COVID in your country
Select Location, last_updated_date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM CovidData.deaths
order by 5 desc


# Looking at Total Cases vs. Population
Select Location, last_updated_date, Population, total_cases, (total_cases/population)*100 as ContractedPercentage
FROM CovidData.deaths
order by 5 desc

-- # Show countries with highest death count per population
Select Location, MAX(total_deaths) as TotalDeathCount
From CovidData.deaths
WHERE continent IS NOT NULL AND TRIM(continent) <> ''
Group by Location
order by TotalDeathCount desc




# Let's break things down by CONTINENT. Showing Continents with highest death count
  
Select continent, MAX(total_deaths) as TotalDeathCount
From CovidData.deaths
WHERE continent IS NOT NULL AND TRIM(continent) <> ''
Group by continent
order by TotalDeathCount desc


# GLOBAL NUMBERS
Select location, (total_deaths/total_cases)*100 as DeathPercentage
FROM CovidData.deaths
WHERE TRIM(continent) <> ''
group by 1,2
order by 2 desc

# Looking at Total Population vs Vaccinations

# Use CTE

use CovidData;
drop table if exists PercentPopulationVaccinated;
Create Table PercentPopulationVaccinated(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations text,
RollingPeopleVaccinated numeric
);

Insert into PercentPopulationVaccinated
Select dea.continent, dea.location, dea.last_updated_date, dea.population, vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER (Partition by dea.location Order by dea.location, dea.last_updated_date) as RollingPeopleVaccinated
from CovidData.deaths dea
join CovidData.vaccinations vac
on dea.location = vac.location
and dea.last_updated_date = vac.last_updated_date
WHERE TRIM(dea.continent) <> '' 
order by 1;

Select * from PercentPopulationVaccinated



# Creating View to store data for later visualizations
Create View DeathPercentageView as
Select Location, last_updated_date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM CovidData.deaths
order by 5 desc




