-- -- Create Baseline Summary
-- CREATE OR REPLACE VIEW marketing.baseline_summary AS
-- SELECT 
--     SUM(acquisition_cost) AS total_spend,
--     SUM(total_revenue) AS total_revenue,
--     SUM(total_profit) AS total_profit,
--     ROUND(SUM(total_profit)/SUM(acquisition_cost),4) AS overall_roi
-- FROM marketing.fact_marketing_performance;


-- -- Create Scenario Adjustment Logic
-- CREATE OR REPLACE VIEW marketing.optimization_scenario AS
-- SELECT
--     *,  
--     -- Adjusted Spend
--     CASE
--         WHEN channels_used = 'Email' THEN acquisition_cost * 0.95
--         WHEN channels_used = 'Google Ads' THEN acquisition_cost * 1.10
--         ELSE acquisition_cost
--     END
--     *
--     CASE
--         WHEN customer_segment = 'Foodies' THEN 0.90
--         WHEN customer_segment = 'Outdoor Adventurers' THEN 1.10
--         ELSE 1
--     END
--     AS adjusted_spend

-- FROM marketing.fact_marketing_performance;



-- -- Recalculate Revenue Based on Adjusted Spend
-- CREATE OR REPLACE VIEW marketing.optimization_results AS
-- SELECT
--     *,
    
--     ROUND(
--         adjusted_spend * (1 + roi_ratio)
--     ,2) AS projected_revenue,
    
--     ROUND(
--         (adjusted_spend * (1 + roi_ratio)) - adjusted_spend
--     ,2) AS projected_profit

-- FROM marketing.optimization_scenario;



-- -- Compare Baseline vs Scenario
-- SELECT 
--     'Baseline' AS model,
--     SUM(total_profit) AS profit,
--     SUM(acquisition_cost) AS spend,
--     ROUND(SUM(total_profit)/SUM(acquisition_cost),4) AS roi
-- FROM marketing.fact_marketing_performance

-- UNION ALL

-- SELECT 
--     'Optimized' AS model,
--     SUM(projected_profit),
--     SUM(adjusted_spend),
--     ROUND(SUM(projected_profit)/SUM(adjusted_spend),4)
-- FROM marketing.optimization_results;

-- /* “By reallocating 10% budget toward high-performing channels 
-- and segments, overall ROI improved by 6% without increasing 
-- total budget."*/






-- -- Capture Baseline Metrics
-- WITH baseline AS (
--     SELECT
--         SUM(acquisition_cost) AS total_budget,
--         SUM(total_profit) AS baseline_profit,
--         AVG(roi_ratio) AS baseline_roi
--     FROM marketing.fact_marketing_performance
-- )
-- SELECT * FROM baseline;

-- -- Create Optimization Parameter Grid
-- CREATE TEMP TABLE simulation_parameters AS
-- SELECT
--     foodies_cut,
--     website_cut,
--     highspend_cut
-- FROM
--     generate_series(0.05, 0.30, 0.05) AS foodies_cut,
--     generate_series(0.05, 0.25, 0.05) AS website_cut,
--     generate_series(0.05, 0.25, 0.05) AS highspend_cut;


-- --- Apply Budget Reductions (Simulation CTE)
-- WITH reduced_budget AS (

--     SELECT
--         f.*,
--         p.foodies_cut,
--         p.website_cut,
--         p.highspend_cut,

--         acquisition_cost
--             * (CASE WHEN customer_segment = 'Foodies'
--                     THEN (1 - p.foodies_cut) ELSE 1 END)
--             * (CASE WHEN channels_used = 'Website'
--                     THEN (1 - p.website_cut) ELSE 1 END)
--             * (CASE WHEN acquisition_cost >= 50000
--                     THEN (1 - p.highspend_cut) ELSE 1 END)
--         AS reduced_cost

--     FROM marketing.fact_marketing_performance f
--     CROSS JOIN simulation_parameters p
-- ),
-- ----- Calculate Freed Budget Pool
-- budget_pool AS (

--     SELECT
--         foodies_cut,
--         website_cut,
--         highspend_cut,
--         SUM(acquisition_cost) AS original_budget,
--         SUM(reduced_cost) AS reduced_budget,
--         SUM(acquisition_cost) - SUM(reduced_cost) AS freed_budget
--     FROM reduced_budget
--     GROUP BY foodies_cut, website_cut, highspend_cut
-- ),

-- ----Reallocate Freed Budget (Budget-Neutral)



-- reallocated_budget AS (

--     SELECT
--         r.*,
--         b.freed_budget,

--         CASE
--             WHEN r.channels_used = 'Google Ads'
--               OR r.customer_segment IN ('Tech Enthusiasts','Outdoor Adventurers')
--             THEN 1
--             ELSE 0
--         END AS eligible

--     FROM reduced_budget r
--     JOIN budget_pool b
--       ON r.foodies_cut = b.foodies_cut
--      AND r.website_cut = b.website_cut
--      AND r.highspend_cut = b.highspend_cut
-- ),
-- --Now distribute proportionally:
-- final_budget AS (

--     SELECT
--         *,
--         CASE
--             WHEN eligible = 1 THEN
--                 reduced_cost +
--                 (
--                     freed_budget *
--                     (
--                         reduced_cost /
--                         NULLIF(
--                             SUM(reduced_cost) OVER (
--                                 PARTITION BY foodies_cut, website_cut, highspend_cut, eligible
--                             ),0
--                         )
--                     )
--                 )
--             ELSE reduced_cost
--         END AS simulated_cost

--     FROM reallocated_budget
-- ),

-- ---- Recalculate Revenue, Profit, ROI
-- final_simulation AS (

--     SELECT
--         foodies_cut,
--         website_cut,
--         highspend_cut,

--         simulated_cost,

--         ROUND((
--             conversion_volume
--             * aov
--             * channel_multiplier
--             * seasonal_boost
--             * (1 - (LN(NULLIF(simulated_cost,0)) * 0.005))
--         ),2) AS simulated_revenue,

--         ROUND((
--             conversion_volume
--             * aov
--             * channel_multiplier
--             * seasonal_boost
--             * (1 - (LN(NULLIF(simulated_cost,0)) * 0.005))
--         ) - simulated_cost,2) AS simulated_profit,

--         ROUND((
--             (
--             conversion_volume
--             * aov
--             * channel_multiplier
--             * seasonal_boost
--             * (1 - (LN(NULLIF(simulated_cost,0)) * 0.005))
--             ) - simulated_cost
--         ) / NULLIF(simulated_cost,0),4) AS simulated_roi

--     FROM final_budget
-- )
-- SELECT *
-- FROM final_simulation
-- LIMIT 10;


-- ---- Find Optimal Combination
-- SELECT
--     foodies_cut,
--     website_cut,
--     highspend_cut,
--     SUM(simulated_profit) AS total_profit,
--     AVG(simulated_roi) AS avg_roi
-- FROM final_simulation
-- GROUP BY foodies_cut, website_cut, highspend_cut
-- ORDER BY total_profit DESC
-- LIMIT 10;






WITH simulation_parameters AS (
    SELECT *
    FROM generate_series(0.05, 0.30, 0.05) AS foodies_cut
    CROSS JOIN generate_series(0.05, 0.25, 0.05) AS website_cut
    CROSS JOIN generate_series(0.05, 0.25, 0.05) AS highspend_cut
),

reduced_budget AS (
    SELECT
        f.*,
        p.foodies_cut,
        p.website_cut,
        p.highspend_cut,

        acquisition_cost
            * (CASE WHEN customer_segment = 'Foodies'
                    THEN (1 - p.foodies_cut) ELSE 1 END)
            * (CASE WHEN channels_used = 'Website'
                    THEN (1 - p.website_cut) ELSE 1 END)
            * (CASE WHEN acquisition_cost >= 50000
                    THEN (1 - p.highspend_cut) ELSE 1 END)
        AS reduced_cost

    FROM marketing.fact_marketing_performance f
    CROSS JOIN simulation_parameters p
),

budget_pool AS (
    SELECT
        foodies_cut,
        website_cut,
        highspend_cut,
        SUM(acquisition_cost) - SUM(reduced_cost) AS freed_budget
    FROM reduced_budget
    GROUP BY foodies_cut, website_cut, highspend_cut
),

final_allocation AS (
    SELECT
        r.*,
        CASE
            WHEN r.channels_used = 'Google Ads'
              OR r.customer_segment IN ('Tech Enthusiasts','Outdoor Adventurers')
            THEN
                reduced_cost +
                (
                    b.freed_budget *
                    reduced_cost /
                    NULLIF(
                        SUM(
                            CASE 
                                WHEN r.channels_used = 'Google Ads'
                                  OR r.customer_segment IN ('Tech Enthusiasts','Outdoor Adventurers')
                                THEN reduced_cost
                                ELSE 0
                            END
                        ) OVER (
                            PARTITION BY r.foodies_cut, r.website_cut, r.highspend_cut
                        ),
                        0
                    )
                )
            ELSE reduced_cost
        END AS simulated_cost
    FROM reduced_budget r
    JOIN budget_pool b
      USING (foodies_cut, website_cut, highspend_cut)
),

final_profit AS (
    SELECT
        foodies_cut,
        website_cut,
        highspend_cut,
        SUM(
            (
                conversion_volume
                * aov
                * channel_multiplier
                * seasonal_boost
                * (1 - LN(NULLIF(simulated_cost,0)) * 0.005)
            ) - simulated_cost
        ) AS total_profit,
        SUM(
            (
                conversion_volume
                * aov
                * channel_multiplier
                * seasonal_boost
                * (1 - LN(NULLIF(simulated_cost,0)) * 0.005)
            ) - simulated_cost
        )
        /
        SUM(simulated_cost) AS portfolio_roi
    FROM final_allocation
    GROUP BY foodies_cut, website_cut, highspend_cut
)

SELECT *
FROM final_profit
ORDER BY total_profit DESC
LIMIT 10;