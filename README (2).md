# International Retail Expansion Feasibility

A small personal project looking at how you'd screen international markets for retail
expansion, using Vietnam's coffee export success as the jumping off point.

## Why this project

Vietnam is the second largest coffee exporter in the world, and a few homegrown
coffee retail chains have been opening stores overseas over the past few years. I got
curious about a simple question: if you only had public data to work with, could you
build a reasonable, defensible way to rank which market to enter next?

I used Cong Ca Phe as a loose case study since it already has stores in a few
different countries, which gave me something real to check the model against instead
of working purely in the abstract.

## What's here

- `sql/01_schema.sql`: table definitions
- `sql/02_load_data.sql`: the actual data, loaded from public sources (source noted
  per row, nothing made up)
- `sql/03_analysis_queries_fixed.sql`: the scoring query, plus a view for connecting
  to Power BI
- `dashboard/`: the Power BI file and a screenshot of the finished dashboard

Database is PostgreSQL, hosted for free on Supabase. Dashboard connects to it live
through Power BI's PostgreSQL connector.

## The approach

I looked at three candidate markets: South Korea, Malaysia, and Canada. I picked
these three specifically because they're the ones with clean, complete public data
across all four layers below (I originally wanted to include Taiwan too, but the
World Bank and governance data sources don't track it as a separate entity, so I
dropped it rather than leave gaps).

Four layers of data, one score per country:

1. **Economic**: GDP per capita, urbanization (World Bank)
2. **Market opportunity**: coffee market size and growth rate (industry market
   research reports)
3. **Governance**: Corruption Perceptions Index (Transparency International)
4. **Competitive whitespace**: how saturated the market already is, using existing
   store counts as a rough proxy

Each layer gets normalized to a 0 to 1 scale, then combined into one weighted score.
The weights (25% economic, 35% market opportunity, 20% governance, 20% whitespace)
are a judgment call on my end, not some objectively correct formula. That's on
purpose. The query is written so the weights are easy to change and re-test, since the
point isn't to pretend there's one right answer.

## What I found

| Country | Economic | Opportunity | Governance | Whitespace | Overall |
|---|---|---|---|---|---|
| Canada | 1.00 | 0.00 | 1.00 | 1.00 | 0.65 |
| South Korea | 0.75 | 1.00 | 0.48 | 0.00 | 0.63 |
| Malaysia | 0.00 | 0.11 | 0.00 | 0.93 | 0.23 |

Canada and South Korea come out almost tied, but for pretty different reasons, which
was the part I found most interesting. South Korea has the strongest coffee market by
far (fast growing, dense cafe culture), but the case study brand is already fairly
established there, so there's less obvious room left to grow. Canada scores well on
income and governance and is a much newer market for the brand, so there's more open
space, even though the underlying coffee market itself is growing slower and is
dominated by an established player (Tim Hortons). Malaysia lags on most fronts, even
though it also has plenty of whitespace.

## Honest limitations

- The market size numbers come from a few different industry reports that don't all
  measure the same thing the same way (some cover the whole coffee market, some just
  cafes). I noted the scope per source rather than pretending they're perfectly
  comparable.
- The weights I used are a starting point, not a verified formula. Someone could
  reasonably argue for different weights and get a different answer.
- Governance is just one index (CPI). A more thorough version would pull in a few
  more governance measures.
- This is a market attractiveness model, not a full feasibility study. Real expansion
  decisions would need site level details like rent, lease terms, and specific
  locations, which is outside what this project covers.
