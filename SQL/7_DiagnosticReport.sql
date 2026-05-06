-- 1. ROI variance check
SELECT 
    MIN(roi) AS min_roi,
    MAX(roi) AS max_roi,
    STDDEV(roi) AS roi_std_dev
FROM marketing.fact_marketing_performance;

/* output:
min_roi 	max_roi			roi_std_dev
2.00		  8.00		1.7344883434709055
*/

-- 2. CPA variance
SELECT STDDEV(cpa) FROM marketing.fact_marketing_performance;
/* Output:
stddev
97014.02411467
*/

-- 3. Channel ROI variance
SELECT campaign_type, STDDEV(roi)
FROM marketing.fact_marketing_performance
GROUP BY campaign_type;
/* Output:
campaign_type		stddev
"Display"		1.7301199414808158
"Email"			1.7328458849987923
"Influencer"	1.7358210113082580
"Search"		1.7398080162960174
"Social Media"	1.7337938247769466
*/

-- 4. Correlation check
SELECT 
    CORR(acquisition_cost, roi) AS spend_roi_corr,
    CORR(engagement_score, roi) AS engagement_roi_corr
FROM marketing.fact_marketing_performance;
/* Output:
0.0045848234907008255	0.0005883311877310662*/