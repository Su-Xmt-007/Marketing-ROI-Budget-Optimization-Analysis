-- -- 1. Create  STAGING TABLE
-- CREATE TABLE marketing.stg_campaign_clean (
--     campaign_id VARCHAR(50),
--     company VARCHAR(100),
--     campaign_type VARCHAR(50),
--     target_audience VARCHAR(100),
--     duration INT,
--     channels_used VARCHAR(100),
--     conversion_rate NUMERIC(6,2),
--     acquisition_cost NUMERIC(14,2),
--     roi NUMERIC(8,2),
--     location VARCHAR(100),
--     language VARCHAR(50),
--     clicks INT,
--     impressions INT,
--     engagement_score NUMERIC(6,2),
--     customer_segment VARCHAR(100),
--     campaign_date DATE
-- );

-- ALTER TABLE marketing.stg_campaign_clean
-- ALTER COLUMN campaign_id TYPE BIGINT
-- USING campaign_id::BIGINT;

-- ALTER TABLE marketing.stg_campaign_clean
-- ADD COLUMN gender VARCHAR(100),
-- ADD COLUMN age_group VARCHAR(100);



-- UPDATE marketing.stg_campaign_clean
-- SET 
--     gender = 
--         CASE 
--             WHEN target_audience LIKE 'Men%' THEN 'Men'
--             WHEN target_audience LIKE 'Women%' THEN 'Women'
-- 			WHEN target_audience = 'All Ages' THEN 'Both'
--             ELSE NULL
--         END,

--     age_group =
--         CASE 
--             WHEN target_audience LIKE '%18-24%' THEN '18-24'
--             WHEN target_audience LIKE '%25-34%' THEN '25-34'
--             WHEN target_audience LIKE '%35-44%' THEN '35-44'
--             WHEN target_audience = 'All Ages' THEN 'All Ages'
--             ELSE NULL
--         END;


-- -- Data Checking --
-- SELECT * FROM marketing.stg_campaign_clean;
-- SELECT * FROM marketing.raw_campaign_landing;




-- -- 2. Insert  data into staging table
-- INSERT INTO marketing.stg_campaign_clean
-- SELECT DISTINCT
--     TRIM(campaign_id)::bigint,
--     INITCAP(TRIM(company)),
--     INITCAP(TRIM(campaign_type)),
--     INITCAP(TRIM(target_audience)),
--     NULLIF(REGEXP_REPLACE(duration,'[^0-9]','','g'),'')::INT,
--     INITCAP(TRIM(channels_used)),
--     NULLIF(REPLACE(conversion_rate,'%',''),'')::NUMERIC(6,2),
--     NULLIF(REPLACE(REPLACE(acquisition_cost,'$',''),',',''),'')::NUMERIC(14,2),
--     NULLIF(REPLACE(roi,'%',''),'')::NUMERIC(8,2),
--     INITCAP(TRIM(location)),
--     INITCAP(TRIM(language)),
--     NULLIF(clicks,'')::INT,
--     NULLIF(impressions,'')::INT,
--     NULLIF(engagement_score,'')::NUMERIC(6,2),
--     INITCAP(TRIM(customer_segment)),
--     TO_DATE(date,'YYYY-MM-DD')
-- FROM marketing.raw_campaign_landing

-- WHERE 
--     campaign_id IS NOT NULL
--     AND campaign_id <> ''
--     AND date ~ '^\d{4}-\d{2}-\d{2}$'
--     AND acquisition_cost ~ '^[0-9.$,]+$';



-- -- CREATE REALISTIC PERFORMANCE LOGIC

-- -- Add AOV (Average Order Value) by Segment
-- ALTER TABLE marketing.stg_campaign_clean
-- ADD COLUMN aov NUMERIC(10,2);

-- UPDATE marketing.stg_campaign_clean
-- SET aov =
-- CASE 
--     WHEN customer_segment = 'Tech Enthusiasts' THEN 1200
--     WHEN customer_segment = 'Fashionistas' THEN 800
--     WHEN customer_segment = 'Health & Wellness' THEN 900
--     WHEN customer_segment = 'Foodies' THEN 600
--     WHEN customer_segment = 'Outdoor Adventurers' THEN 1000
-- END;


-- -- ADD DIMINISHING RETURNS: Add spend penalty:
-- ALTER TABLE marketing.stg_campaign_clean
-- ADD COLUMN spend_penalty NUMERIC(6,4);

-- UPDATE marketing.stg_campaign_clean
-- SET spend_penalty = LN(acquisition_cost) * 0.02;


-- -- ADD SEASONALITY

-- ALTER TABLE marketing.stg_campaign_clean
-- ADD COLUMN seasonal_boost NUMERIC(5,2);

-- UPDATE marketing.stg_campaign_clean
-- SET seasonal_boost =
-- CASE 
--     WHEN EXTRACT(MONTH FROM campaign_date) IN (11,12) THEN 1.15
--     WHEN EXTRACT(MONTH FROM campaign_date) IN (6,7) THEN 1.08
--     ELSE 1
-- END;

-- -- create and Populate Channel Multiplier
-- ALTER TABLE marketing.stg_campaign_clean
-- ADD COLUMN channel_multiplier NUMERIC(5,2);

-- UPDATE marketing.stg_campaign_clean
-- SET channel_multiplier =
-- CASE
--     WHEN channels_used = 'Google Ads' THEN 1.25
--     WHEN channels_used = 'Email' THEN 1.10
--     WHEN channels_used = 'Facebook' THEN 1.05
--     WHEN channels_used = 'Instagram' THEN 1.00
--     WHEN channels_used = 'Youtube' THEN 0.95
--     WHEN channels_used = 'Website' THEN 0.90
--     ELSE 1
-- END;






















-- Optimized Staging Table
CREATE TABLE marketing.stg_campaign_clean (
    campaign_id BIGINT,
    company VARCHAR(100),
    campaign_type VARCHAR(50),
    target_audience VARCHAR(100),
    duration INT,
    channels_used VARCHAR(100),
    conversion_rate NUMERIC(6,2),
    acquisition_cost NUMERIC(14,2),
    roi NUMERIC(8,2),
    location VARCHAR(100),
    language VARCHAR(50),
    clicks INT,
    impressions INT,
    engagement_score NUMERIC(6,2),
    customer_segment VARCHAR(100),
    campaign_date DATE,
    gender VARCHAR(20),
    age_group VARCHAR(20),
    aov NUMERIC(10,2),
    seasonal_boost NUMERIC(5,2),
    channel_multiplier NUMERIC(5,2)
);
-- Optimized INSERT
INSERT INTO marketing.stg_campaign_clean
SELECT DISTINCT
    TRIM(campaign_id)::BIGINT,
    INITCAP(TRIM(company)),
    INITCAP(TRIM(campaign_type)),
    INITCAP(TRIM(target_audience)),
    NULLIF(REGEXP_REPLACE(duration,'[^0-9]','','g'),'')::INT,
    INITCAP(TRIM(channels_used)),
    NULLIF(REPLACE(conversion_rate,'%',''),'')::NUMERIC(6,2),
    NULLIF(REPLACE(REPLACE(acquisition_cost,'$',''),',',''),'')::NUMERIC(14,2),
    NULLIF(REPLACE(roi,'%',''),'')::NUMERIC(8,2),
    INITCAP(TRIM(location)),
    INITCAP(TRIM(language)),
    NULLIF(clicks,'')::INT,
    NULLIF(impressions,'')::INT,
    NULLIF(engagement_score,'')::NUMERIC(6,2),
    INITCAP(TRIM(customer_segment)),
    TO_DATE(date,'YYYY-MM-DD'),

    -- Gender
    CASE 
        WHEN target_audience LIKE 'Men%' THEN 'Men'
        WHEN target_audience LIKE 'Women%' THEN 'Women'
        WHEN target_audience = 'All Ages' THEN 'Both'
    END,

    -- Age Group
    CASE 
        WHEN target_audience LIKE '%18-24%' THEN '18-24'
        WHEN target_audience LIKE '%25-34%' THEN '25-34'
        WHEN target_audience LIKE '%35-44%' THEN '35-44'
        WHEN target_audience = 'All Ages' THEN 'All Ages'
    END,

    -- AOV
    CASE 
        WHEN customer_segment = 'Tech Enthusiasts' THEN 1200
        WHEN customer_segment = 'Fashionistas' THEN 800
        WHEN customer_segment = 'Health & Wellness' THEN 900
        WHEN customer_segment = 'Foodies' THEN 600
        WHEN customer_segment = 'Outdoor Adventurers' THEN 1000
    END,

    
    -- Seasonal Boost
    CASE 
        WHEN EXTRACT(MONTH FROM TO_DATE(date,'YYYY-MM-DD')) IN (11,12) THEN 1.15
        WHEN EXTRACT(MONTH FROM TO_DATE(date,'YYYY-MM-DD')) IN (6,7) THEN 1.08
        ELSE 1
    END,

    -- Channel Multiplier
    CASE
        WHEN channels_used = 'Google Ads' THEN 1.25
        WHEN channels_used = 'Email' THEN 1.10
        WHEN channels_used = 'Facebook' THEN 1.05
        WHEN channels_used = 'Instagram' THEN 1.00
        WHEN channels_used = 'Youtube' THEN 0.95
        WHEN channels_used = 'Website' THEN 0.90
        ELSE 1
    END

FROM marketing.raw_campaign_landing
WHERE 
    campaign_id IS NOT NULL
    AND campaign_id <> ''
    AND date ~ '^\d{4}-\d{2}-\d{2}$'
    AND acquisition_cost ~ '^[0-9.$,]+$';


-- -- Data Checking --
-- SELECT * FROM marketing.stg_campaign_clean;
-- SELECT * FROM marketing.raw_campaign_landing;

























/*
	🥇 1. STRUCTURAL CLEANING (Already Mostly Done)
	
	✔ Trim spaces
	✔ Remove "$"
	✔ Remove ","
	✔ Remove "%"
	✔ Convert "30 days" → 30
	✔ Convert TEXT → proper numeric
	✔ Convert TEXT → DATE
*/

-- 1. Any NULL campaign_id?
SELECT COUNT(*)
FROM marketing.stg_campaign_clean
WHERE campaign_id IS NULL;
-- 2. Any negative values?
SELECT *
FROM marketing.stg_campaign_clean
WHERE clicks < 0
   OR impressions < 0
   OR acquisition_cost < 0;
-- 3. conversion_rate > 1 ?
SELECT *
FROM marketing.stg_campaign_clean
WHERE conversion_rate > 1;
-- 4. impressions = 0 but clicks > 0?
SELECT *
FROM marketing.stg_campaign_clean
WHERE impressions = 0
AND clicks > 0;

SELECT * FROM marketing.stg_campaign_clean;




/*🥈 2. FORMAT STANDARDIZATION:
			🔎 A. Categorical Column Data Consistency */
-- 1. Company name column data consistency check
SELECT DISTINCT company
FROM marketing.stg_campaign_clean
ORDER BY company;

-- 2. Campaign type column data consistency check
SELECT DISTINCT campaign_type
FROM marketing.stg_campaign_clean
ORDER BY campaign_type;

-- 3. Target Audience column data consistency check
SELECT DISTINCT target_audience
FROM marketing.stg_campaign_clean
ORDER BY target_audience;

-- 4. Channels Used column data consistency check
SELECT DISTINCT channels_used
FROM marketing.stg_campaign_clean
ORDER BY channels_used;

-- 5. Location column data consistency check
SELECT DISTINCT location
FROM marketing.stg_campaign_clean
ORDER BY location;

-- 6. Language column data consistency check
SELECT DISTINCT language
FROM marketing.stg_campaign_clean
ORDER BY language;

-- 7. Customer Segment column data consistency check
SELECT DISTINCT customer_segment
FROM marketing.stg_campaign_clean
ORDER BY customer_segment;

SELECT * FROM marketing.stg_campaign_clean;




/* 🥉 3. BUSINESS RULE CLEANING (Most Important)*/
-- A. conversion_rate Validation
SELECT *
FROM marketing.stg_campaign_clean
WHERE conversion_rate < 0
   OR conversion_rate > 1;

-- B. Clicks vs Impressions
SELECT *
FROM marketing.stg_campaign_clean
WHERE clicks > impressions;

-- C. Zero Impression Problem
SELECT *
FROM marketing.stg_campaign_clean
WHERE impressions = 0;

-- D. Negative Numbers
SELECT *
FROM marketing.stg_campaign_clean
WHERE acquisition_cost < 0
   OR clicks < 0
   OR impressions < 0;

-- E. Unrealistic ROI
SELECT *
FROM marketing.stg_campaign_clean
WHERE roi < -100 OR roi > 100;



SELECT campaign_id
FROM marketing.stg_campaign_clean
ORDER BY campaign_id;
SELECT campaign_id FROM marketing.stg_campaign_clean;
SELECT campaign_id FROM marketing.raw_campaign_landing;

