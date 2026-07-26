-- =====================================================================
-- Analysis: market attractiveness scoring
-- Run after 01_schema.sql and 02_load_data.sql
-- =====================================================================

-- 1. Consolidated view joining all four data layers - this is what you'll
--    point Power BI at as a single clean data source.
CREATE OR REPLACE VIEW market_screening AS
SELECT
    c.country_name,
    e.gdp_per_capita_usd,
    e.urban_population_pct,
    g.corruption_perceptions_index,
    g.cpi_global_rank,
    m.coffee_market_size_usd_bn,
    m.coffee_market_cagr_pct,
    cl.cafe_count_est,
    cl.existing_brand_stores
FROM countries c
JOIN economic_indicators e   ON c.country_code = e.country_code
JOIN governance_indicators g ON c.country_code = g.country_code
JOIN market_opportunity m    ON c.country_code = m.country_code
JOIN competitive_landscape cl ON c.country_code = cl.country_code;

-- 2. Min-max normalized attractiveness score (0-1 scale per indicator),
--    weighted across the four layers. Weights are a modeling choice --
--    adjust to match whatever narrative you want to defend in interview.
--    Default weights below: Economic 25%, Financial/Opportunity 35%,
--    Governance 20%, Competitive intensity 20% (inverted -- lower
--    existing footprint = more room to grow = higher score).
WITH bounds AS (
    SELECT
        MIN(gdp_per_capita_usd) AS gdp_min, MAX(gdp_per_capita_usd) AS gdp_max,
        MIN(coffee_market_cagr_pct) AS cagr_min, MAX(coffee_market_cagr_pct) AS cagr_max,
        MIN(corruption_perceptions_index) AS cpi_min, MAX(corruption_perceptions_index) AS cpi_max,
        MIN(existing_brand_stores) AS stores_min, MAX(existing_brand_stores) AS stores_max
    FROM market_screening
)
SELECT
    ms.country_name,
    ROUND(((ms.gdp_per_capita_usd - b.gdp_min) / NULLIF(b.gdp_max - b.gdp_min, 0))::numeric, 3) AS econ_score,
    ROUND(((ms.coffee_market_cagr_pct - b.cagr_min) / NULLIF(b.cagr_max - b.cagr_min, 0))::numeric, 3) AS opportunity_score,
    ROUND(((ms.corruption_perceptions_index - b.cpi_min) / NULLIF(b.cpi_max - b.cpi_min, 0))::numeric, 3) AS governance_score,
    -- inverted: fewer existing stores = more white space = higher score
    ROUND((1 - (ms.existing_brand_stores - b.stores_min)::numeric / NULLIF(b.stores_max - b.stores_min, 0))::numeric, 3) AS whitespace_score,
    ROUND((
        0.25 * ((ms.gdp_per_capita_usd - b.gdp_min) / NULLIF(b.gdp_max - b.gdp_min, 0))
      + 0.35 * ((ms.coffee_market_cagr_pct - b.cagr_min) / NULLIF(b.cagr_max - b.cagr_min, 0))
      + 0.20 * ((ms.corruption_perceptions_index - b.cpi_min) / NULLIF(b.cpi_max - b.cpi_min, 0))
      + 0.20 * (1 - (ms.existing_brand_stores - b.stores_min)::numeric / NULLIF(b.stores_max - b.stores_min, 0))
    )::numeric, 3) AS overall_attractiveness_score
FROM market_screening ms, bounds b
ORDER BY overall_attractiveness_score DESC;
