# 🌍 Global Sales Data Analytics Project – 2025

<img width="1536" height="1024" alt="Global Sales Analytics Banner" src="YOUR_BANNER_IMAGE_LINK">

### End-to-End Retail Sales Analytics & Executive Intelligence Platform

This project delivers a complete enterprise-grade retail analytics solution designed to transform raw multi-country sales data into actionable business intelligence.

Using PostgreSQL, advanced SQL analytics, statistical testing, regression modeling, and Power BI dashboards, the project identifies the key drivers of profitability, validates business assumptions using statistics, and provides executive-level strategic recommendations.

The analysis combines:
- Data Engineering
- Financial Validation
- Statistical Analytics
- Business Intelligence
- Executive Storytelling

---

# 🚀 Project Objective

Modern retail organizations generate massive transactional data every day, yet many businesses struggle to convert raw sales records into strategic decision-making insights.

This project was built to answer critical business questions:

- Which countries and product categories generate the highest profitability?
- Do discounts meaningfully improve profit performance?
- Which factors statistically drive sales margin?
- Are customer demographics influencing profitability?
- Can data-driven operational strategies improve revenue stability?

The goal was to move beyond descriptive reporting and build a complete analytics-driven decision support system.

---

# 📂 Dataset Overview

The project analyzes retail sales transactions across multiple countries:

- 🇨🇦 Canada
- 🇨🇳 China
- 🇮🇳 India
- 🇳🇬 Nigeria
- 🇬🇧 United Kingdom
- 🇺🇸 United States

The dataset includes:

| Column | Description |
|---|---|
| Order Date | Transaction date |
| Country | Sales geography |
| Category | Product category |
| Quantity Purchased | Units sold |
| Price Per Unit | Selling price |
| Discount Applied | Discount percentage |
| Customer Age | Buyer age |
| Gender | Customer gender |
| Payment Method | Purchase payment type |
| Revenue | Sales revenue |
| Cost | Product cost |
| Profit Margin | Profitability metric |

---

# 🏗️ Project Architecture

The project follows a complete enterprise analytics workflow:

```plaintext
Raw CSV Data
      ↓
PostgreSQL Data Warehouse
      ↓
Data Cleaning & Validation
      ↓
Feature Engineering
      ↓
Advanced SQL EDA
      ↓
Statistical Hypothesis Testing
      ↓
Regression Modeling
      ↓
Power BI Data Modeling
      ↓
Executive Dashboard & Reporting
```

---

# 🗄️ Enterprise Data Architecture (PostgreSQL)

A layered PostgreSQL architecture was implemented to ensure scalability, data quality, and analytics readiness.

## Data Layers

| Layer | Purpose |
|---|---|
| RAW | Raw CSV ingestion |
| VALIDATION | Null checks & data integrity validation |
| TRANSFORM | Cleaning & business metric generation |
| FACT | Analytics-ready centralized fact table |

---

# 🔍 Data Integrity & Financial Validation

During exploratory analysis, several business inconsistencies were discovered:

- Unrealistic cost structures
- Excessive discounts (up to 98%)
- Artificial negative profit margins
- Revenue instability

## Corrections Applied

- Reconstructed realistic product costs
- Standardized discount ranges (0–40%)
- Recalculated financial KPIs
- Validated business consistency rules

### Result:
The dataset became economically realistic and suitable for enterprise-level analysis.

---

# 📊 Exploratory Data Analysis (SQL)

Advanced SQL analysis was conducted to identify profitability patterns and operational risks.

## Key Business Questions Answered

### 🌍 Revenue Performance

- Which countries generate highest revenue?
- Which months drive strongest sales?
- How stable is revenue performance?

### 📦 Profitability Analysis

- Which categories generate strongest margins?
- How do discounts impact profitability?
- Which products are high-margin but low-volume?

### 👥 Customer Analytics

- Revenue contribution by age group
- Gender-wise purchasing behavior
- Payment method preference analysis

### ⚠️ Risk & Stability

- Revenue volatility analysis
- Profit margin consistency
- Outlier detection using Z-score & IQR

---

# 📈 Statistical Analysis & Hypothesis Testing

The project moved beyond descriptive reporting into diagnostic analytics using statistical validation.

---

## 1️⃣ T-Test — Adult vs Senior Purchase Quantity

### Objective
Determine whether purchase quantity differs significantly between adult and senior customers.

### Results

| Metric | Value |
|---|---|
| p-value | 0.728 |
| Cohen's d | 0.015 |

### Insight
No statistically significant difference exists between adult and senior purchasing quantity.

---

## 2️⃣ ANOVA — Store Location vs Profit Margin

### Objective
Determine whether geography significantly affects profitability.

### Results

| Metric | Value |
|---|---|
| p-value | 0.629 |
| Eta² | 0.0048 |

### Insight
Country/location has minimal influence on profit margin performance.

---

## 3️⃣ Chi-Square Test — Age Group × Payment Method

### Objective
Evaluate dependency between age group and payment preference.

### Results

| Metric | Value |
|---|---|
| p-value | 0.107 |
| Cramer's V | 0.038 |

### Insight
Payment method preference is statistically independent of age.

---

# 📉 Multiple Regression Modeling

A multiple regression model was developed to identify the strongest drivers of profitability.

## Model Performance

| Metric | Value |
|---|---|
| R² | ~4.9% |
| Overall Significance | Statistically Significant |

---

## Key Predictors

| Variable | Impact | Result |
|---|---|---|
| Quantity Purchased | Strong Positive | ✅ Significant |
| Discount Applied | Weak | ❌ Not Significant |
| Country | Minimal | ❌ Not Significant |
| Category | Minimal | ❌ Not Significant |

---

# 🔥 Core Business Finding

> Profitability is primarily volume-driven.

After controlling for:
- Geography
- Product category
- Customer demographics
- Discount strategy
- Payment behavior

The strongest and only consistently significant profitability driver was:

✅ Quantity Purchased

This suggests businesses should prioritize:
- Basket size growth
- Cross-selling
- Operational scale
- Inventory efficiency

instead of aggressive discounting strategies.

---

# 📊 Power BI Data Modeling

A star schema model was implemented for scalable dashboard performance.

## Fact Table

- Fact_Global_Sales

## Dimension Tables

- Dim_Country
- Dim_Category
- Dim_Customer
- Dim_Date
- Dim_Payment_Method

---

# 📊 Power BI Dashboard

The project includes a professional 3-page executive dashboard.

---

## 1️⃣ Executive Summary

### Key Visuals

- KPI Cards
- Revenue Trend Analysis
- Country Comparison
- Profit Margin Overview

---

## 2️⃣ Regional Performance Analysis

### Key Visuals

- Geographic Sales Map
- Regional Heatmaps
- Category Profit Matrix
- Seasonal Sales Trend

---

## 3️⃣ Customer & Profitability Analysis

### Key Visuals

- Age × Gender Treemap
- Payment Method Distribution
- Discount Sensitivity Scatter Plot
- High-Profit Segment Analysis

---

# 🚀 Advanced Dashboard Features

- Interactive slicers
- Drill-through navigation
- Dynamic Top N filtering
- KPI vs Target comparison
- Cross-filtering visuals
- Executive storytelling layout

---

# 📷 Dashboard Preview

## Executive Dashboard

<img width="1400" alt="Global Sales Dashboard" src="YOUR_DASHBOARD_IMAGE_LINK">

---

# 💼 Business Impact

The analysis demonstrates how enterprise analytics can improve operational and financial decision-making.

## Expected Outcomes

- 📈 4–7% potential margin improvement
- 💰 Reduced discount leakage
- 📊 Improved revenue consistency
- 🏪 Better inventory planning
- 🎯 Improved operational efficiency

---

# 🧠 Strategic Recommendations

## Recommended Actions

1️⃣ Increase basket size through cross-selling  
2️⃣ Reduce excessive discount dependency  
3️⃣ Optimize operational efficiency  
4️⃣ Improve seasonal inventory planning  
5️⃣ Focus on high-volume profitability growth  

---

# 🛠️ Tools & Technologies

| Tool | Purpose |
|---|---|
| PostgreSQL | Data warehouse & SQL analytics |
| SQL | EDA & business analysis |
| Excel | Statistical testing |
| Power BI | Dashboard visualization |
| Python (ReportLab) | Executive PDF generation |
| pgAdmin 4 | Database administration |

---

# 🗂️ Repository Structure

```plaintext
GLOBAL-SALES-DATA-ANALYSIS/
│
├── 📁 DATA/
│
├── 📁 SQL/
│   ├── schema_creation.sql
│   ├── validation_queries.sql
│   ├── eda_queries.sql
│   └── regression_analysis.sql
│
├── 📁 POWERBI/
│   └── Global_Sales_Dashboard.pbix
│
├── 📁 REPORT/
│   └── Global_Sales_Executive_Report_2025.pdf
│
├── 📁 DASHBOARD_SCREENSHOTS/
│
└── README.md
```

---

# 🎯 Skills Demonstrated

- SQL Data Architecture
- Advanced SQL Analytics
- Data Validation & Governance
- Exploratory Data Analysis
- Statistical Hypothesis Testing
- Regression Modeling
- Business Intelligence
- Dashboard Design
- Executive Reporting
- Data Storytelling

---

# 🔮 Future Enhancements

- Predictive sales forecasting
- Customer segmentation clustering
- Real-time Power BI refresh pipeline
- Automated anomaly detection
- Streamlit analytics application
- Machine learning-based profit prediction

---

# 📌 Portfolio / Interview Summary

This project demonstrates complete end-to-end analytics capability — from enterprise data architecture and financial validation to advanced statistical analysis, regression modeling, and executive-level business intelligence dashboards.

The project reflects strong proficiency in:
- SQL
- PostgreSQL
- Power BI
- Statistical Analytics
- Business Problem Solving
- Executive Communication

---

# 👨‍💻 Author

## Subhamoy Hazra

Aspiring Data Analyst specializing in:
- SQL
- PostgreSQL
- Power BI
- Statistical Analytics
- Business Intelligence

🔗 GitHub: https://github.com/Su-Xmt-007

---

# ⭐ Final Note

If you found this project valuable, consider giving it a ⭐ on GitHub.
