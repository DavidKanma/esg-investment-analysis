# 📊 ESG Risk & Portfolio Performance Analysis

Should an asset manager overweight or underweight high-ESG-risk sectors?

## Business Problem

I'm acting as a data analyst for a fund's portfolio committee, who are considering launching
an ESG-tilted equity fund. Before committing, they want evidence-based answers to three questions:

1. Do low-ESG-risk companies actually outperform high-risk companies on return, or is the
   relationship more complicated?
2. Which S&P 500 sectors carry the most ESG risk, and is that risk already priced into valuations?
3. If we exclude the worst-ESG-risk quintile of companies from the index, what happens to
   sector diversification and expected return?

## Data Sources

- **S&P 500 ESG Risk Ratings** (Kaggle) — company-level ESG risk scores, sector, controversy level (503 companies, 430 with valid ESG scores)
- **YTD stock returns** pulled live via the `yfinance` Python library (485 tickers matched)

## Tools & Approach

| Stage | Tool | What I did |
|---|---|---|
| Data cleaning & prep | Excel | Cleaned raw CSV, handled 73 missing ESG scores, built sector-level pivot tables |
| Data joins & aggregation | SQL (SQLite) | Joined ESG dataset to return data by ticker, ranked companies into 5 ESG risk quintiles |
| Statistical analysis | Python (pandas, scipy) | Pearson correlation and linear regression of ESG risk score vs. YTD return; sector-level ANOVA |
| Dashboard | Power BI | Sector risk heatmap, return-by-risk-quintile chart, interactive exclusion-impact simulator |

## Repo Structure

    esg-risk-portfolio-analysis/
    ├── README.md
    ├── data/
    │   ├── raw/                     # original Kaggle CSV + yfinance pull
    │   └── cleaned/                 # joined, quintile-ranked dataset used for analysis
    ├── excel/
    │   └── esg_sector_pivot_analysis.xlsx
    ├── sql/
    │   ├── 01_clean_and_join.sql
    │   └── 02_risk_quintile_ranking.sql
    ├── notebooks/
    │   └── esg_risk_return_analysis.ipynb
    ├── dashboard/
    │   ├── esg_dashboard.pbix
    │   └── screenshots/
    └── images/
        └── dashboard_preview.png

## Key Findings

**Finding 1 — ESG risk score alone does not predict return.**
Correlation between ESG risk score and YTD return was effectively zero (r = -0.003, p = 0.955), and regression confirmed no explanatory power (R² ≈ 0.0000). An initial quintile breakdown suggested a pattern (Quintile 1: 16.86%, Quintile 5: 16.07%, Quintile 4: 9.03%), but statistical testing shows this is noise, not signal — ESG risk score is not a usable standalone return predictor for this period.

**Finding 2 — Sector, not ESG risk, drives return differences.**
A sector-level ANOVA found highly significant return differences by sector (F = 6.80, p < 0.0001). Energy (31.8) and Utilities (26.7) carry the highest average ESG risk scores, while Real Estate (13.1) and Technology (16.9) carry the lowest — consistent with expected real-world sector risk profiles. In effect, ESG risk score functions as a sector proxy rather than an independent risk factor.

**Finding 3 — Exclusion reallocates sector exposure, it doesn't improve returns.**
Excluding the worst ESG-risk quintile shifts portfolio weight away from Energy (-2.6pp), Industrials (-2.1pp), and Basic Materials (-1.9pp), toward Technology (+2.3pp) and Financial Services (+2.0pp). Average YTD return declined slightly after exclusion, from 13.49% to 12.84% (-0.65pp) — reinforcing that a blanket ESG-risk exclusion is functionally a sector reallocation, not a risk-adjusted performance improvement.

## Recommendation

I'd recommend against a broad ESG-risk-based exclusion screen. The data shows no statistically significant relationship between ESG risk score and return (p = 0.955); exclusion primarily reallocates sector exposure — away from Energy and Industrials, into Technology and Financial Services — rather than improving risk-adjusted performance. If the committee's objective is genuinely ESG-driven rather than an implicit sector bet, I'd suggest a **sector-neutral ESG tilt**: excluding worst-in-sector performers within each sector, rather than a blanket risk-quintile cut. This preserves diversification while still screening out the highest-risk names in every sector, including lower-risk sectors like Technology and Real Estate.

## Dashboard Preview

![Dashboard Preview](images/dashboard_preview.png)

**Pages:**
- **Sector Risk Overview** — heatmap of average ESG risk score and return by sector
- **Return by ESG Risk Quintile** — bar chart showing the non-significant relationship between risk and return
- **Exclusion Impact Simulator** — interactive slicer showing sector reallocation and return impact when excluding the highest-risk quintile

🔗 Full interactive file: [`dashboard/esg_dashboard.pbix`](dashboard/esg_dashboard.pbix)

## How to Reproduce

1. Clone this repo
2. Download the raw ESG dataset from Kaggle into `data/raw/`
3. Run `notebooks/esg_risk_return_analysis.ipynb` to pull YTD returns via `yfinance` and reproduce the join, quintile ranking, and statistical analysis
4. Reference `sql/01_clean_and_join.sql` and `sql/02_risk_quintile_ranking.sql` for the underlying query logic
5. Open `dashboard/esg_dashboard.pbix` in Power BI Desktop to explore the interactive dashboard
