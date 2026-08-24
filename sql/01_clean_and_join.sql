import sqlite3

esg = pd.read_csv("SP 500 ESG Risk Ratings.csv")
returns = pd.read_csv("ytd_returns.csv")

conn = sqlite3.connect(":memory:")
esg.to_sql("esg", conn, index=False)
returns.to_sql("returns", conn, index=False)

q1 = """
SELECT
  e.Symbol,
  e.Sector,
  e."Total ESG Risk score" AS ESG_Risk_Score,
  e."Controversy Level" AS Controversy_Level,
  e."ESG Risk Level" AS ESG_Risk_Level,
  r.YTD_Return_Pct
FROM esg e
JOIN returns r ON e.Symbol = r.Symbol
WHERE e."Total ESG Risk score" IS NOT NULL
  AND r.YTD_Return_Pct IS NOT NULL;
"""
joined = pd.read_sql(q1, conn)
print(joined.shape)
joined.to_sql("joined", conn, index=False)
joined.head()
