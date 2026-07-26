-- =====================================================================
-- Data load: South Korea, Malaysia, Canada
-- All figures sourced from public data; see `source` column per row.
-- Run this after 01_schema.sql
-- =====================================================================

INSERT INTO countries (country_code, country_name) VALUES
    ('KR', 'South Korea'),
    ('MY', 'Malaysia'),
    ('CA', 'Canada');

INSERT INTO economic_indicators (country_code, gdp_per_capita_usd, gdp_data_year, urban_population_pct, source) VALUES
    ('KR', 36239.00, 2024, 81.40, 'World Bank / Trading Economics'),
    ('MY', 11868.36, 2024, 79.20, 'World Bank / Trading Economics'),
    ('CA', 44539.00, 2024, 81.98, 'World Bank / Trading Economics');

INSERT INTO governance_indicators (country_code, corruption_perceptions_index, cpi_global_rank, source) VALUES
    ('KR', 63, 31, 'Transparency International CPI 2025'),
    ('MY', 52, 54, 'Transparency International CPI 2025'),
    ('CA', 75, 12, 'Transparency International CPI 2025');

INSERT INTO market_opportunity (country_code, coffee_market_size_usd_bn, coffee_market_year, coffee_market_cagr_pct, notes, source) VALUES
    ('KR', 13.67, 2025, 9.70, 'Cafe count grew from 69,000 (2019) to 102,000 (2023); ~405 cups consumed per capita annually', 'Expert Market Research, South Korea Coffee Market Report'),
    ('MY', 0.75, 2024, 6.50, 'Growth driven by urbanization and rising middle-class disposable income; figure is national coffee product market, narrower than cafe/foodservice sector', '6Wresearch / StrategyHelix Malaysia Coffee Market'),
    ('CA', 27.64, 2024, 6.10, 'Broader "coffee system" market; narrower NAICS coffee & snack shop retail sector estimated at $6.5-6.7bn (2025-26) -- use whichever scope matches your model', 'Introspective Market Research / IBISWorld Canada Coffee Market');

INSERT INTO competitive_landscape (country_code, cafe_count_est, existing_brand_stores, market_maturity_notes, source) VALUES
    ('KR', 102000, 16, 'Mature, dense, highly competitive cafe culture; largest overseas footprint for the case-study brand to date', 'Statista / Vietnam Insider reporting on Cong Ca Phe South Korea expansion'),
    ('MY', NULL, 3, 'Earlier-stage overseas market for the brand; smaller footprint than South Korea', 'Inside Retail Asia / Vietnam Insider reporting on Cong Ca Phe Malaysia'),
    ('CA', NULL, 2, 'Newest market (first store opened Toronto, 2023); large but Tim Hortons-dominated, mature market with a growing specialty-coffee niche', 'Vietnam Insider / Inside Retail Asia reporting on Cong Ca Phe Canada');
