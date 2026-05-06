SELECT * FROM marketing.raw_campaign_landing;



-- 1. Total Row Count
SELECT COUNT(*) FROM marketing.raw_campaign_landing;



-- 2. Check Column Completeness (NULL / Blank Detection)
SELECT
COUNT(*) FILTER (WHERE campaign_id IS NULL OR campaign_id = '') AS missing_campaign_id,
COUNT(*) FILTER (WHERE company IS NULL OR company = '') AS missing_company,
COUNT(*) FILTER (WHERE campaign_type IS NULL OR campaign_type = '') AS missing_campaign_type,
COUNT(*) FILTER (WHERE target_audience IS NULL OR target_audience = '') AS missing_target_audience,
COUNT(*) FILTER (WHERE duration IS NULL OR duration = '') AS missing_duration,
COUNT(*) FILTER (WHERE channels_used IS NULL OR channels_used = '') AS missing_channels_used,
COUNT(*) FILTER (WHERE conversion_rate IS NULL OR conversion_rate = '') AS missing_conversion_rate,
COUNT(*) FILTER (WHERE acquisition_cost IS NULL OR acquisition_cost = '') AS missing_acquisition_cost,
COUNT(*) FILTER (WHERE roi IS NULL OR roi = '') AS missing_roi,
COUNT(*) FILTER (WHERE location IS NULL OR location = '') AS missing_location,
COUNT(*) FILTER (WHERE language IS NULL OR language = '') AS missing_language,
COUNT(*) FILTER (WHERE clicks IS NULL OR clicks = '') AS missing_clicks,
COUNT(*) FILTER (WHERE impressions IS NULL OR impressions = '') AS missing_impressions,
COUNT(*) FILTER (WHERE engagement_score IS NULL OR engagement_score = '') AS missing_engagement_score,
COUNT(*) FILTER (WHERE customer_segment IS NULL OR customer_segment = '') AS missing_customer_segment,
COUNT(*) FILTER (WHERE date IS NULL OR date = '') AS missing_date
FROM marketing.raw_campaign_landing;




-- 3. Non-Numeric Detection
SELECT
COUNT(*) FILTER (
  WHERE duration IS NOT NULL
  AND duration <> ''
  AND duration !~ '^[0-9]+$'
) AS invalid_duration,

COUNT(*) FILTER (
  WHERE clicks IS NOT NULL
  AND clicks <> ''
  AND clicks !~ '^[0-9]+$'
) AS invalid_clicks,

COUNT(*) FILTER (
  WHERE impressions IS NOT NULL
  AND impressions <> ''
  AND impressions !~ '^[0-9]+$'
) AS invalid_impressions,

COUNT(*) FILTER (
  WHERE conversion_rate IS NOT NULL
  AND conversion_rate <> ''
  AND conversion_rate !~ '^[0-9.]+%?$'
) AS invalid_conversion_rate,

COUNT(*) FILTER (
  WHERE acquisition_cost IS NOT NULL
  AND acquisition_cost <> ''
  AND acquisition_cost !~ '^[0-9.$,]+$'
) AS invalid_acquisition_cost,

COUNT(*) FILTER (
  WHERE roi IS NOT NULL
  AND roi <> ''
  AND roi !~ '^[0-9.-]+%?$'
) AS invalid_roi,

COUNT(*) FILTER (
  WHERE engagement_score IS NOT NULL
  AND engagement_score <> ''
  AND engagement_score !~ '^[0-9.]+$'
) AS invalid_engagement_score

FROM marketing.raw_campaign_landing;




-- 4. Date validation
SELECT COUNT(*)
FROM marketing.raw_campaign_landing
WHERE date IS NOT NULL
AND date <> ''
AND date !~ '^\d{4}-\d{2}-\d{2}$';




-- 5.1 DUPLICATE CHECK
SELECT campaign_id, COUNT(*)
FROM marketing.raw_campaign_landing
GROUP BY campaign_id
HAVING COUNT(*) > 1;
-- 5.2 Campaign + Date
SELECT campaign_id, date, COUNT(*)
FROM marketing.raw_campaign_landing
GROUP BY campaign_id, date
HAVING COUNT(*) > 1;
-- 5.3 Full Grain Check
SELECT campaign_id, date, location, customer_segment, COUNT(*)
FROM marketing.raw_campaign_landing
GROUP BY campaign_id, date, location, customer_segment
HAVING COUNT(*) > 1;



-- 6. OUTLIER CHECK
SELECT COUNT(*)
FROM marketing.raw_campaign_landing
WHERE roi ~ '^[0-9.-]+$'
AND roi::numeric > 20;


-- 7. Categorical Inconsistency Check
SELECT DISTINCT campaign_type
FROM marketing.raw_campaign_landing
ORDER BY campaign_type;


-- 8. Detect Negative or Unrealistic ROI
SELECT roi
FROM marketing.raw_campaign_landing
WHERE roi::numeric < -100 OR roi::numeric > 1000;