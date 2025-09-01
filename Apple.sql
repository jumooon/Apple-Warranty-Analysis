--Apple project 10M datasets
select * from category;
select * from products;
select * from sales;
select * from stores;
select * from warranty;

--EDA
select distinct repair_status from warranty;
select count(*) from sales;

-- Improving Query Performance
--Execution Time : 39 ms
--Planing Time : 0.139
--After creating index
--ET : 8.871 ms
--PT : 0.129
explain analyze
select * from sales
where product_id = 'P-44'

create index sales_product_id on sales(product_id);
--ET : 39 ms
--PT : 1.309
--After creating index
--ET : 3.4 ms
--PT . 1.6

explain analyze
select * from sales
where store_id = 'ST-31'

create index sales_store_id on sales(store_id);

-- Business Problems
--1. Find each country and number of stores
select country, count(*) 
from  stores
group by 1
order by 2 desc;
--2. What is the total number of units sold by each store?
select s.store_id, st.store_name, sum(quantity) as total_unit_sold
from sales as s inner join stores as st on s.store_id = st.store_id
group by 1, 2
order by 3 DESC;

--3. How many sales occurred in December 2023?
select count(*) as sales_Dec_2023
from sales
where to_char(sale_date, 'MM-YYYY') = '12-2023';
--4. How many stores have never had a warranty claim filed against any of their products?

select * from stores
where store_id not in(
				select distinct store_id
				from sales as s
				right join warranty as w
				on s.sale_id = w.sale_id);

--5. What percentage of warranty claims are marked as "Warranty Void"?
select round ((count(*) / (select count(*) from warranty)::numeric * 100), 2) as warranty_void_rate
from warranty
where repair_status = 'Warranty Void';
--6. Which store had the highest total units sold in the 2 years?
select s.store_id, st.store_name, sum(s.quantity)
from sales as s join stores as st on s.store_id = st.store_id
where s.sale_date >= current_date - interval '2 year'
group by 1, 2
order by 3 desc
limit 1;

--7. Count the number of unique products sold in the last year.
select p.product_id, p.product_name, sum(s.quantity)
from products as p join sales as s on p.product_id = s.product_id
where s.sale_date  >= current_date - interval '2 years'
group by 1, 2
order by 3 desc;
--8. What is the average price of products in each category?
select c.category_name, round(avg(p.price)::numeric, 2) as AVG_price
from category as c join products as p on c.category_id = p.category_id
group by 1;
--9. How many warranty claims were filed in 2020?
select count(*)
from warranty as w
where extract(year from w.claim_date ) = 2020;
--10. Identify each store and best selling day based on highest qty sold
select store_id, day_name, total_unit_sold, rank
from
	(select
	store_id, to_char(sale_date, 'Day') as day_name,
	sum(quantity) as total_unit_sold,
	rank() over(partition by store_id order by sum(quantity) DESC) as rank
	from sales
	group by 1, 2) as t1
where rank = 1;

--11. Identify least selling product of each country for each year based on total unit sold
select *	
from (select st.country, p.product_name, extract(year from s.sale_date), sum(s.quantity) as total_qty_sold,
	rank() over(partition by st.country, extract(year from s.sale_date) order by sum(s.quantity) asc) as rank
	from sales as s join stores as st on s.store_id = st.store_id 
	join products as p on s.product_id = p.product_id
	group by 1,2,3
	order by 1,3,4) as product_rank_by_year
where rank = 1;
	
--12. How many warranty claims were filed within 180 days of a product sale?
select count(*)
from warranty as w
left join sales as s
on s.sale_id = w.sale_id
where w.claim_date - sale_date <= 180;
--13. How many warranty claims have been filed for products launched in the last two years?
select p.product_name, count(w.claim_id), count(s.sale_id)
from products as p right join sales as s on p.product_id = s.product_id 
left join warranty as w on s.sale_id = w.sale_id
where p.launch_date >= current_date - interval '2 years'
group by 1
having count(w.claim_id) > 0;
--14. List the months in the last 3 years where sales exceeded 5000 units from usa.
select to_char(sale_date, 'Month')
from sales as s join stores as st on s.store_id = st.store_id
where country = 'USA' and s.sale_date > current_date - interval '3 years'
group by 1
having sum(quantity) > 5000;
--15. Which product category had the most warranty claims filed in the last 2 years?
select c.category_id, p.product_name, count(w.claim_id)
from category as c join products as p on c.category_id = p.category_id
join sales as s on p.product_id  = s.product_id 
join warranty as w on s.sale_id  = w.sale_id
where w.claim_date > current_date - interval '2 years'
group by 1, 2
order by 3 desc
limit 1;
--16. Determine the percentage chance of receiving claims after each items purchase for each country.
with t1 as
(select st.country, p.product_name, round(count(w.claim_id )::numeric / sum(s.quantity )::numeric, 4) * 100 as the_percentage_receiving_claims
from sales as s left join stores as st on s.store_id = st.store_id 
left join warranty as w on s.sale_id = w.sale_id
left join products as p on s.product_id  = p.product_id
group by 1,2)
select country, product_name, the_percentage_receiving_claims
from t1
where the_percentage_receiving_claims != 0;
--17. Analyze each stores year by year growth ratio
with yearly_sales
as(
select s.store_id, st.store_name, extract(year from sale_date) as year, sum(s.quantity * p.price) as total_sale
from sales as s join products as p on s.product_id = p.product_id
join stores as st on s.store_id  = st.store_id
group by 1, 2, 3
order by 2,3),
growth_ratio
as(
select store_name, year, LAG(total_sale, 1) over(partition by store_name order by year) as last_year_sale, total_sale as current_year_sale
from yearly_sales)
select store_name, year, last_year_sale, current_year_sale, round((current_year_sale::numeric - last_year_sale::numeric)/last_year_sale::numeric * 100, 2)  as growth_ratio_year_by_year
from growth_ratio
where last_year_sale is not null and year <> extract(year from current_date);
/*18. What is the correlation between product price and warranty claims for products sold in the
last five years? (Segment based on diff price)*/
select 
case
	when p.price < 500 then 'less expensive product'
	when p.price between 500 and 1000 then 'Mid range product'
	else 'expensive product'
end as price_segment,
count(w.claim_id) as total_claim
from warranty as w
join sales as s on w.sale_id = s.sale_id join products as p on p.product_id = s.product_id
where claim_date >= current_date - interval '5 year'
group by 1;
/*19. Identify the store with the highest percentage of "Paid Repaired" claims in relation to total
claims filed.*/
with paid_repair
as 
(select
	s.store_id, count(repair_status) as paid_repaired
from sales as s join warranty as w on s.sale_id = w.sale_id
where repair_status = 'Paid Repaired'
group by 1),
total_repair as(
select
	s.store_id, count(repair_status) as total_repaired
from sales as s join warranty as w on s.sale_id = w.sale_id
group by 1)
select
	p.store_id, paid_repaired, total_repaired, (paid_repaired::numeric / total_repaired::numeric) * 100 as percentage_paid_repaired
from paid_repair as p join total_repair as t on p.store_id = t.store_id
order by 3 asc
limit 1;

/*20.Write SQL query to calculate the monthly running total of sales for each store over the past
years and compare the trends across this period?*/
with monthly_sale 
as
(select 
	store_id,
	extract(year from sale_date) as year,
	extract(month from sale_date) as month,
	sum(p.price * s.quantity) as total_revenue
from sales as s join products as p on s. product_id = p.product_id
group by 1,2,3
order by 1, 3)
select
	store_id,
	month,
	year,
	total_revenue,
	sum(total_revenue) over(partition by store_id order by year, month) as running_total
from monthly_sale;

/*21.Analyze sales trends of product over time, segmented into key time periods: from launch to 6
months, 6-12 months, 12-18 months, and beyond 18 months?*/

select
	p.product_name,
	case
		when s.sale_date between p.launch_date and p.launch_date + interval '6 month' then '0-6'
		when s.sale_date between p.launch_date + interval '6 month' and p.launch_date + interval '12 month' then '6-12'
		when s.sale_date between p.launch_date + interval '12 month' and p.launch_date + interval '18 month' then '12-18'
		else '18+'
	end as plc,
	sum(s.quantity) as total_qty_sale
from sales as s join products as p on s.product_id = p.product_id
group by 1,2
order by 1,2 asc;
	