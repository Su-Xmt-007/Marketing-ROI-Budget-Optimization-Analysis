--- ****************     Statistical Test     *****************---
-- 1. Find correlation between spend vs roi using sql.
-- Statistical Significance ($t$-statistic)
WITH stats AS (
    SELECT 
        CORR(acquisition_cost, roi_ratio) AS r,
        COUNT(*) AS n
    FROM marketing.fact_marketing_performance
)
SELECT 
    ROUND(r::numeric, 4) AS correlation_coefficient,
    n AS sample_size,
    ROUND((r * SQRT((n - 2) / (1 - r * r)))::numeric, 4) AS t_stat
FROM stats;




-- 2. SIMPLE LINEAR REGRESSION (Spend → ROI)
SELECT
    regr_slope(roi_ratio, acquisition_cost) AS beta_1_slope,
    regr_intercept(roi_ratio, acquisition_cost) AS beta_0_intercept,
    regr_r2(roi_ratio, acquisition_cost) AS r_squared,
    regr_count(roi_ratio, acquisition_cost) AS n
FROM marketing.fact_marketing_performance;