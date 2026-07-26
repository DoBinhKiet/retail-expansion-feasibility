-- =====================================================================
-- International Retail Expansion Feasibility: Schema
-- Case study: a Vietnamese coffee retail chain evaluating South Korea,
-- Malaysia, and Canada as candidate markets for further store growth.
-- Target platform: PostgreSQL (Supabase / Neon free tier)
-- =====================================================================

DROP TABLE IF EXISTS competitive_landscape;
DROP TABLE IF EXISTS market_opportunity;
DROP TABLE IF EXISTS governance_indicators;
DROP TABLE IF EXISTS economic_indicators;
DROP TABLE IF EXISTS countries;

CREATE TABLE countries (
    country_code    CHAR(2) PRIMARY KEY,        -- ISO 3166-1 alpha-2
    country_name    VARCHAR(50) NOT NULL
);

CREATE TABLE economic_indicators (
    country_code        CHAR(2) PRIMARY KEY REFERENCES countries(country_code),
    gdp_per_capita_usd  NUMERIC(10,2) NOT NULL,   -- current US$, latest available year
    gdp_data_year       SMALLINT NOT NULL,
    urban_population_pct NUMERIC(5,2) NOT NULL,   -- % of total population, 2024
    source              TEXT NOT NULL
);

CREATE TABLE governance_indicators (
    country_code        CHAR(2) PRIMARY KEY REFERENCES countries(country_code),
    corruption_perceptions_index SMALLINT NOT NULL, -- Transparency International CPI 2025, 0-100 (higher = cleaner)
    cpi_global_rank      SMALLINT NOT NULL,
    source               TEXT NOT NULL
);

CREATE TABLE market_opportunity (
    country_code               CHAR(2) PRIMARY KEY REFERENCES countries(country_code),
    coffee_market_size_usd_bn  NUMERIC(6,2) NOT NULL,  -- latest available year, national coffee/cafe market
    coffee_market_year         SMALLINT NOT NULL,
    coffee_market_cagr_pct     NUMERIC(4,2) NOT NULL,  -- forward-looking CAGR, source-reported
    notes                      TEXT,
    source                     TEXT NOT NULL
);

CREATE TABLE competitive_landscape (
    country_code            CHAR(2) PRIMARY KEY REFERENCES countries(country_code),
    cafe_count_est           INTEGER,               -- approx. total cafes/coffee shops, latest available
    existing_brand_stores    SMALLINT NOT NULL,      -- case-study brand's current store count in this market
    market_maturity_notes    TEXT,
    source                   TEXT NOT NULL
);
