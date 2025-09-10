# Apple Refurb Stock Forecasting to Minimize Customer Wait Times
![apple logo](https://github.com/jumooon/apple_sales_analysis/blob/main/Apple_Changsha_RetailTeamMembers_09012021_big.jpg.slideshow-xlarge_2x.jpg)
## Project overview

Apple’s strong warranty and replacement policies boost customer trust but also create operational challenges. When claims surge for specific products or regions, customers often face long wait times due to limited refurb stock on hand.  

This project asks:  
“Can we forecast refurb demand in advance so stores pre-stock the right devices and minimize customer wait times?”  

To answer this, we:  
	•	Analyze hotspots (stores/products with unusually high claim probabilities).  
	•	Model demand using two approaches:  
	•	MVP (Moving Average Forecast) – short-term, data-driven trend detection.  
	•	PRO (Lifecycle Hazard Model) – product age-based risk modeling.  
	•	Blend forecasts to generate a store×product refurb stocking plan.  
	•	Prioritize urgent stores/products so inventory can be allocated before shortages occur.  

Impact:  
This enables Apple to reduce repair/replacement wait times, optimize refurb logistics, and improve the warranty experience.  

## Entity Relationship Diagram (ERD)
![ERD](https://github.com/jumooon/apple_sales_analysis/blob/main/erd.png)

## Schema

Five main tables:

1. **stores**: Contains information about Apple retail stores.
   - `store_id` : Unique identifier for each store.
   - `store_name` : Name of the store.
   - `city` : City where the store is located.
   - `country` : Country of the store.

2. **category**: Holds product category information.
   - `category_id` : Unique identifier for each product category.
   - `category_name` : Name of the category.

3. **products**: Details about Apple products.
   - `product_id` : Unique identifier for each product.
   - `product_name` : Name of the product.
   - `category_id` : References the category table.
   - `launch_date` : Date when the product was launched.
   - `price` : Price of the product.

4. **sales**: Stores sales transactions.
   - `sale_id` : Unique identifier for each sale.
   - `sale_date` : Date of the sale.
   - `store_id` : References the store table.
   - `product_id` : References the product table.
   - `quantity` : Number of units sold.

5. **warranty**: Stores warranty claim information.
   - `claim_id` : Unique identifier for each claim.
   - `claim_date` : Date when the claim was filed.
   - `sale_id` : References the sale table.
   - `repair_status` : Status of the warranty claim (e.g., Paid Repaired, Warranty Void).

## Objectives

1.	Measure the Core Risk Metric  
	•	Calculate Claim Probability (%) = (Number of warranty claims ÷ Units sold) × 100.  
	•	Track how this metric changes over time (YoY growth comparison between sales and claims).

2.	Identify Adjustment Factors (Supporting Analyses)  
	•	By Region/Store: Detect whether warranty claims are concentrated in specific markets.  
	•	By Product Lifecycle: Examine claim rates in different phases (0–6 months, 6–12, 12–18, 18+).  
	•	By Price Segment: Analyze the correlation between product price and claim frequency.  
	•	By Claim Type: Differentiate between “Paid Repaired” vs “Warranty Void” to assess actual cost impact.

3.	Business Insight  
	•	Determine whether revenue growth is sufficient to absorb warranty-related costs.  
	•	Provide actionable recommendations for quality improvement, warranty strategy, and regional risk management.

## Methodology
   •	SQL: CTEs, Window functions, CASE logic, correlation analysis  
	•	Visualization: Tableau dashboards  
	•	Analysis: Year-over-year growth, claim probability, price-claim correlation  

## Key findings
