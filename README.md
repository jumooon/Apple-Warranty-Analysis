# Sales Growth vs Warranty Costs: Apple’s After-Sales Case
![apple logo](https://github.com/jumooon/apple_sales_analysis/blob/main/Apple_Changsha_RetailTeamMembers_09012021_big.jpg.slideshow-xlarge_2x.jpg)
## Project overview

This project is inspired by Apple’s renowned replacement and warranty policy.
Apple has built a reputation for offering generous repair and replacement services, often providing refurbished devices with minimal friction for the customer. While this strengthens brand loyalty and customer satisfaction, it also raises a key business question:

“Can strong sales growth sustainably offset the rising costs of warranty and replacement services?”

To explore this question, I analyze a dataset labeled as Apple sales and warranty data, obtained from a public source.  
⚠️ The authenticity of this dataset as official Apple data has not been independently verified, and it should be treated as Apple-inspired data for analytical purposes.

The analysis simulates a real-world scenario to evaluate whether revenue growth is sufficient to absorb increasing warranty costs, drawing lessons from Apple’s customer-focused after-sales strategy.

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
