-- -- DROP TABLE IF EXISTS marketing.fact_marketing_performance;

-- -- CREATE TABLE marketing.fact_marketing_performance AS
-- -- SELECT *,
-- --     ROUND(clicks::decimal / NULLIF(impressions,0),4) AS ctr,
-- --     ROUND((clicks * conversion_rate/100.0),2) AS conversion_volume,
-- --     ROUND((clicks * conversion_rate/100.0) * aov,2) AS total_revenue,
-- --     ROUND(((clicks * conversion_rate/100.0) * aov) - acquisition_cost,2) AS total_profit,
-- --     ROUND(acquisition_cost / NULLIF((clicks * conversion_rate/100.0),0),2) AS cpa
-- -- FROM marketing.stg_campaign_clean;


-- /*DROP TABLE marketing.fact_marketing_performance;

-- CREATE TABLE marketing.fact_marketing_performance AS
-- SELECT *,
--     ROUND((clicks * conversion_rate/100.0),2) AS conversion_volume,
--     ROUND((clicks * conversion_rate/100.0) * aov * (1 - spend_penalty),2) AS total_revenue,
--     ROUND(((clicks * conversion_rate/100.0) * aov * (1 - spend_penalty)) - acquisition_cost,2) AS total_profit
-- FROM marketing.stg_campaign_clean;*/

-- CREATE TABLE marketing.fact_marketing_performance AS
-- SELECT
--     *,
--     ROUND(clicks::decimal / NULLIF(impressions,0),4) AS ctr,
--     ROUND((clicks * conversion_rate/100.0),2) AS conversion_volume,

--     -- Revenue Model
--     ROUND((clicks * conversion_rate/100.0) 
--           * aov 
--           * channel_multiplier 
--           * seasonal_boost 
--           * (1 - spend_penalty),2) AS total_revenue,

--     -- Profit
--     ROUND(
--         ((clicks * conversion_rate/100.0) 
--           * aov 
--           * channel_multiplier 
--           * seasonal_boost 
--           * (1 - spend_penalty))
--         - acquisition_cost
--     ,2) AS total_profit
-- FROM marketing.stg_campaign_clean;



-- SELECT * FROM marketing.fact_marketing_performance;






-- SELECT MIN(conversion_rate), MAX(conversion_rate)
-- FROM marketing.stg_campaign_clean;


-- DROP TABLE IF EXISTS marketing.fact_marketing_performance;

-- CREATE TABLE marketing.fact_marketing_performance AS
-- SELECT
--     *,

--     ROUND(clicks::decimal / NULLIF(impressions,0),4) AS ctr,

--     ROUND(clicks * conversion_rate,2) AS conversion_volume,

--     ROUND(
--         (clicks * conversion_rate)
--         * aov
--         * channel_multiplier
--         * seasonal_boost
--         * (1 - (LN(acquisition_cost) * 0.005))
--     ,2) AS total_revenue,

--     ROUND(
--         (
--         (clicks * conversion_rate)
--         * aov
--         * channel_multiplier
--         * seasonal_boost
--         * (1 - (LN(acquisition_cost) * 0.005))
--         )
--         - acquisition_cost
--     ,2) AS total_profit,

--     ROUND(
--         (
--         (
--         (clicks * conversion_rate)
--         * aov
--         * channel_multiplier
--         * seasonal_boost
--         * (1 - (LN(acquisition_cost) * 0.005))
--         )
--         - acquisition_cost
--         )
--         / acquisition_cost
--     ,4) AS roi_ratio

-- FROM marketing.stg_campaign_clean;

-- SELECT * FROM marketing.fact_marketing_performance;









DROP TABLE IF EXISTS marketing.fact_marketing_performance;

CREATE TABLE marketing.fact_marketing_performance AS
WITH performance_base AS (
    SELECT
        *,
        ROUND(clicks::decimal / NULLIF(impressions,0),4) AS ctr,
        ROUND(clicks * conversion_rate,2) AS conversion_volume,

        -- Precompute revenue before cost
        ROUND((
            (clicks * conversion_rate)
            * aov
            * channel_multiplier
            * seasonal_boost
            * (1 - (LN(NULLIF(acquisition_cost,0)) * 0.005)) -- Spend Penalty
        ),4) AS calculated_revenue
    FROM marketing.stg_campaign_clean
)

SELECT
    *,
    ROUND(calculated_revenue,2) AS total_revenue,
    ROUND(calculated_revenue - acquisition_cost,2) AS total_profit,
    ROUND((calculated_revenue - acquisition_cost) / NULLIF(acquisition_cost,0),4) AS roi_ratio
FROM performance_base;


-- adding missing cpa and update the column with correct formula
ALTER TABLE marketing.fact_marketing_performance
ADD COLUMN cpa NUMERIC(10,2);

UPDATE marketing.fact_marketing_performance
SET cpa = ROUND(
    acquisition_cost / NULLIF(conversion_volume,0),
    2
);


SELECT * FROM marketing.fact_marketing_performance;
