-- 1️⃣ Which channel delivers highest ROI?
SELECT 
    channels_used,
    ROUND(AVG(roi_ratio),4) AS avg_roi,
    ROUND(SUM(total_profit),2) AS total_profit,
    SUM(acquisition_cost) AS total_spend
FROM marketing.fact_marketing_performance
GROUP BY channels_used
ORDER BY avg_roi DESC;


-- 2️⃣ Which Customer Segment Has Lowest CPA?
SElECT
	customer_segment,
	ROUND(AVG(cpa),2) AS avg_cpa,
	ROUND(SUM(total_profit),2) AS total_profit
FROM marketing.fact_marketing_performance
GROUP BY  customer_segment
ORDER BY avg_cpa ASC;


-- 3️⃣ Are we overspending on certain campaign types?
SELECT 
    campaign_type,
    ROUND(SUM(acquisition_cost),2) AS total_spend,
    ROUND(AVG(roi),2) AS avg_roi,
    ROUND(SUM(total_profit),2) AS total_profit
FROM marketing.fact_marketing_performance
GROUP BY campaign_type
ORDER BY total_spend DESC;

-- 4️⃣ Does engagement correlate with ROI?
SELECT 
    ROUND(
        CAST(CORR(engagement_score, roi_ratio) AS numeric),
        4
    ) AS engagement_roi_correlation
FROM marketing.fact_marketing_performance;



-- 5️⃣ Is there diminishing return beyond certain spend?
SELECT 
    CASE 
        WHEN acquisition_cost < 10000 THEN 'Low Spend'
        WHEN acquisition_cost < 50000 THEN 'Medium Spend'
        ELSE 'High Spend'
    END AS spend_bucket,
    ROUND(AVG(roi_ratio),4) AS avg_roi
FROM marketing.fact_marketing_performance
GROUP BY spend_bucket;


-- 6️⃣ Which geography yields highest profit?
SELECT 
    location,
    ROUND(SUM(total_profit),2) AS total_profit,
    ROUND(AVG(roi_ratio),4) AS avg_roi
FROM marketing.fact_marketing_performance
GROUP BY location
ORDER BY total_profit DESC;



-- 7️⃣ Which campaign type drives highest conversions?
SELECT 
    campaign_type,
    SUM(conversion_volume) AS total_conversions
FROM marketing.fact_marketing_performance
GROUP BY campaign_type
ORDER BY total_conversions DESC;

-- 8️⃣ Is language affecting ROI?
SELECT 
    language,
    ROUND(AVG(roi_ratio),4) AS avg_roi,
    ROUND(SUM(total_profit),2) AS total_profit
FROM marketing.fact_marketing_performance
GROUP BY language
ORDER BY avg_roi DESC;

-- 9️⃣ Are long-duration campaigns more profitable?
SELECT ROUND(AVG(duration),2) AS avg_duration,
	MIN(duration) AS min_duration,
	MAX(duration) AS max_duration
FROM marketing.fact_marketing_performance;


SELECT 
    CASE 
        WHEN duration < 30 THEN 'Short'
        WHEN duration <= 60 THEN 'Medium'
        ELSE 'Long'
    END AS duration_type,
    ROUND(AVG(roi_ratio),4) AS avg_roi
FROM marketing.fact_marketing_performance
GROUP BY duration_type;

-- 1️⃣0️⃣ Does CTR predict conversion?
SELECT 
    CORR(ctr, conversion_volume) AS ctr_conversion_correlation
FROM 
    marketing.fact_marketing_performance;

-- 1️⃣1️⃣ Which segment is cost inefficient?
SELECT 
    customer_segment,
    ROUND(AVG(cpa),2) AS avg_cpa,
    ROUND(AVG(roi_ratio),4) AS avg_roi
FROM marketing.fact_marketing_performance
GROUP BY customer_segment
ORDER BY avg_cpa DESC;

-- 1️⃣2️⃣ Is ROI improving YoY?
SELECT 
    EXTRACT(MONTH FROM campaign_date) AS month,
    ROUND(AVG(roi_ratio),4) AS avg_roi
FROM marketing.fact_marketing_performance
GROUP BY month
ORDER BY month;


-- 1️⃣3️⃣ Which location has highest engagement?
SELECT 
    location,
    ROUND(AVG(engagement_score),2) AS avg_engagement
FROM marketing.stg_campaign_clean
GROUP BY location
ORDER BY avg_engagement DESC;

-- 1️⃣4️⃣ Which campaign type burns budget?
SELECT 
    campaign_type,
    SUM(acquisition_cost) AS spend,
    SUM(total_profit) AS profit,
    ROUND(SUM(total_profit)/SUM(acquisition_cost),4) AS efficiency
FROM marketing.fact_marketing_performance
GROUP BY campaign_type
ORDER BY efficiency ASC;

-- 1️⃣5️⃣ Revenue Concentration Ratio
WITH ranked AS (
    SELECT *,
           NTILE(5) OVER (ORDER BY total_revenue DESC) AS revenue_bucket
    FROM marketing.fact_marketing_performance
)
SELECT 
    revenue_bucket,
    ROUND(SUM(total_revenue),2) AS revenue
FROM ranked
GROUP BY revenue_bucket
ORDER BY revenue_bucket;

-- SQL for Pareto (Channel Level)
SELECT 
    channels_used,
    SUM(total_revenue) AS revenue
FROM marketing.fact_marketing_performance
GROUP BY channels_used
ORDER BY revenue DESC;


--  Does spend correlate with ROI?
SELECT 
    ROUND(
        CORR(acquisition_cost, roi_ratio)::numeric,
        4
    ) AS spend_roi_correlation
FROM marketing.fact_marketing_performance
WHERE acquisition_cost IS NOT NULL
AND roi_ratio IS NOT NULL;

--Funnel SQL
SELECT
    SUM(impressions) AS impressions,
    SUM(clicks) AS clicks,
    SUM(conversion_volume) AS conversions
FROM marketing.fact_marketing_performance;