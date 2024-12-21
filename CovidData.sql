--Global
CREATE VIEW global_covid_overview AS
SELECT 
    dth.country,
    dth.continent,
    dth.population,
    dth.total_case,
    vaxx.total_test,
    vaxx.total_recovered,
    dth.total_death,
    dth.who_region
FROM PortfolioProject..covid_deaths AS dth
JOIN PortfolioProject..covid_vaccinations AS vaxx
    ON dth.country = vaxx.country;
GO

--Mortality Rate
CREATE VIEW mortality_rate AS
SELECT 
	country,
	continent,
	population,
	total_case,
	total_death,
	(total_death / total_case) * 100 AS mortality_rate
FROM PortfolioProject..covid_deaths
GO

--Recovery Rate
CREATE VIEW recovery_rate AS
SELECT 
	vaxx.country,
	vaxx.continent,
	dth.population,
	vaxx.total_test,
	vaxx.total_recovered,
	(vaxx.total_recovered / vaxx.total_test) * 100 AS mortality_rate
FROM PortfolioProject..covid_vaccinations vaxx
JOIN PortfolioProject..covid_deaths dth
	ON vaxx.country = dth.country
GO

--Testing efficiency per 1000
CREATE VIEW testing_efficiency AS
SELECT
	vaxx.country,
	vaxx.continent,
	dth.population,
	vaxx.total_test,
	vaxx.total_recovered,
	ROUND(vaxx.total_test *  1000 / dth.population, 2) AS test_per_thousand
FROM PortfolioProject..covid_vaccinations vaxx
LEFT JOIN PortfolioProject..covid_deaths dth
	ON vaxx.country = dth.country
GO
	
--Regional Overview
CREATE VIEW regional_overview AS
SELECT
	dth.who_region,
	SUM(dth.total_case) AS total_case,
	SUM(dth.total_death) AS total_death,
	SUM(vaxx.total_test) AS total_test,
	SUM(vaxx.total_recovered) AS total_recovered
FROM PortfolioProject..covid_deaths dth
JOIN PortfolioProject..covid_vaccinations vaxx
	ON dth.country = vaxx.country
GROUP BY dth.who_region
GO
