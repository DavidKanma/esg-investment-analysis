q2 = """
SELECT *,
  NTILE(5) OVER (ORDER BY ESG_Risk_Score) AS ESG_Risk_Quintile
FROM joined;
"""
quintiles = pd.read_sql(q2, conn)
quintiles.to_csv("esg_returns_joined.csv", index=False)
quintiles.groupby("ESG_Risk_Quintile")["YTD_Return_Pct"].mean().round(2)
