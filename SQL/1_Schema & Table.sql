-- Schema Creating
CREATE SCHEMA marketing;

-- Create a RAW TABLE (All TEXT)
CREATE TABLE marketing.raw_campaign_landing (
	campaign_id TEXT,
    company TEXT,
    campaign_type TEXT,
    target_audience TEXT,
    duration TEXT,
    channels_used TEXT,
    conversion_rate TEXT,
    acquisition_cost TEXT,
    roi TEXT,
    location TEXT,
    language TEXT,
    clicks TEXT,
    impressions TEXT,
    engagement_score TEXT,
    customer_segment TEXT,
    date TEXT
);


-- Import CSV INTO LANDING TABLE
COPY marketing.raw_campaign_landing
FROM 'E:\DATA ANALYST\Project\Portfolio Project- EXCEL  SQL  PBI\3_Marketing ROI & Budget Optimization\marketing_campaign_dataset.csv'
DELIMITER ','
CSV HEADER;

-- Viewing data
SELECT * FROM marketing.raw_campaign_landing

