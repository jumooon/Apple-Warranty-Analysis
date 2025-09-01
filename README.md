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
1.	Revenue Growth Analysis
	•	Measure store and country level sales volume
	•	Compute year over year growth rates
	•	Visualize monthly running totals

3.	Warranty Cost Analysis
	•	Track annual claim volumes
	•	Assess ratios of “Paid Repaired” vs “Warranty Void”
	•	Evaluate claim rates across product lifecycle stages

5.	Sales vs Warranty Risk
	•	Calculate probability of claims per unit sold
	•	Identify high-risk stores/countries
	•	Explore correlation between product price and claim frequency

7.	Growth Comparison
	•	Compare sales growth vs warranty growth rates
	•	Test whether warranty costs threaten profitability in the long term

## Methodology
   •	SQL: CTEs, Window functions, CASE logic, correlation analysis
	•	Visualization: Tableau / Power BI dashboards
	•	Analysis: Year-over-year growth, claim probability, price-claim correlation

## Key findings
