-- Create Error Table
CREATE TABLE marketing.error_campaign_records AS
SELECT *,
       'Invalid data format' AS error_reason,
       CURRENT_TIMESTAMP AS error_timestamp
FROM marketing.raw_campaign_landing
WHERE 1=0;


--Insert Errors (Using NOT)
INSERT INTO marketing.error_campaign_records
SELECT *,
       'Validation Failed' AS error_reason,
       CURRENT_TIMESTAMP
FROM marketing.raw_campaign_landing
WHERE NOT (
    campaign_id IS NOT NULL
    AND campaign_id <> ''
    AND date ~ '^\d{4}-\d{2}-\d{2}$'
    AND acquisition_cost ~ '^[0-9.$,]+$'
	);