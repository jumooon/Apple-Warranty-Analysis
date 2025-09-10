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
/* 	.	Regional Variability
	•	For each country / city / store_id, compute Claim Probability.
	•	Highlight outliers vs. national/global average.
→ Why: Pinpoints geographic hotspots and operational weaknesses. */

with high_claim_probability_country
as (
select st.country, st.store_name, count(w.claim_id) as num_claim, count(s.sale_id) as num_sales
from sales as s left join stores as st on s.store_id =st.store_id
left join warranty as w on s.sale_id = w.sale_id
group by 1,2
order by 3 desc
limit 15
)
select country, store_name, num_claim, num_sales, round(num_claim::numeric /num_sales::numeric * 100, 2) as claim_probability_by_stores
from high_claim_probability_country
order by 3 desc;

/*
Country       Store Name                Claims   Sales    Claim Probability (%)
-------------------------------------------------------------------------------
Spain         Apple Barcelona            6052     9321           64.93
UAE           Apple Mall of the Emirates 5978     6026           99.20
UAE           Apple Dubai Mall           5838    10805           54.03
Turkey        Apple Ankara               3126    26672           11.72
Turkey        Apple Istanbul             3031    26512           11.43
India         Apple New Delhi            2241    26650            8.41
Italy         Apple Milan                1691    12738           13.28
UK            Apple Regent Street        1214    21075            5.76
Germany       Apple Munich                481    21015            2.29
UK            Apple Covent Garden         267    21117            1.26
UK            Apple Bluewater             259    20993            1.23
France        Apple Lyon                  184    12837            1.43
Netherlands   Apple Amsterdam             163    12874            1.27
Germany       Apple Kurfürstendamm        160    12717            1.26
France        Apple Champs-Élysées        151    12644            1.19
*/


 /*  Lifecycle Risk
	•	For each product, bucket claims by time since launch:
	•	0–6 months (early failure)
	•	7–12 months
	•	13+ months (mature)
	•	Compare Claim Probability across buckets.*/

with claim
as(
select p.product_name, p.launch_date, w.claim_date , w.claim_id
from products as p right join sales as s on p.product_id  = s.product_id
left join warranty as w on s.sale_id = w.sale_id
where w.claim_date is not null
group by 1,2,3,4)
select product_name, count(claim_id),
case
	when claim_date::date - launch_date::date between 0 and 180 then '0-6 months'
	when claim_date::date - launch_date::date between 181 and 360 then '7-12 months'
	else '13+ months(mature)'
end
, rank() over(partition by product_name order by count(claim_id) desc) as rank
from claim
group by 1,3
order by 1;

/* Product                           Claims   Lifecycle        Rank
----------------------------------------------------------------
### 🎧 Audio Devices
AirPods (3rd Gen)                    64    0-6 months        1
AirPods (3rd Gen)                    35    7-12 months       2
AirPods (3rd Gen)                    19    13+ months        3
AirPods Max                          18    0-6 months        1
AirPods Max                           9    7-12 months       2
AirPods Max                           5    13+ months        3
AirPods Pro (2nd Gen)               299    0-6 months        2
AirPods Pro (2nd Gen)               384    7-12 months       1
AirPods Pro (2nd Gen)               230    13+ months        3
AirTag                              876    0-6 months        3
AirTag                             2332    7-12 months       1
AirTag                             1889    13+ months        2
HomePod mini                         40    0-6 months        1
HomePod mini                         26    7-12 months       2
HomePod mini                          8    13+ months        3

### 📺 Streaming / Subscription
Apple Fitness+                       16    0-6 months        1
Apple Fitness+                       15    7-12 months       2
Apple Fitness+                        5    13+ months        3
Apple One                            151   0-6 months        3
Apple One                            164   7-12 months       2
Apple One                           1065   13+ months        1
Apple TV 4K                           59   0-6 months        3
Apple TV 4K                          160   7-12 months       1
Apple TV 4K                          112   13+ months        2

### ⌚ Wearables
Apple Watch Series 5                  35   7-12 months       2
Apple Watch Series 5                1015   13+ months        1
Apple Watch Series 4                 824   13+ months        1
Apple Watch Series 7                  59   0-6 months        1
Apple Watch Series 7                  32   7-12 months       2
Apple Watch Series 7                  25   13+ months        3

### 💻 Macs
Mac mini (M1)                         34   0-6 months        1
Mac mini (M1)                         16   7-12 months       3
Mac mini (M1)                         17   13+ months        2
MacBook Air (M1)                      58   0-6 months        1
MacBook Air (M1)                      21   7-12 months       2
MacBook Air (M1)                       9   13+ months        3
MacBook Pro (M1 Max, 16-inch)        343   0-6 months        1
MacBook Pro (M1 Max, 16-inch)        292   7-12 months       2
MacBook Pro (M1 Max, 16-inch)        140   13+ months        3
MacBook Pro (M1 Pro, 14-inch)        327   0-6 months        1
MacBook Pro (M1 Pro, 14-inch)        286   7-12 months       2
MacBook Pro (M1 Pro, 14-inch)        151   13+ months        3
MacBook Pro (M1, 13-inch)             36   0-6 months        1
MacBook Pro (M1, 13-inch)             19   7-12 months       2
MacBook Pro (M1, 13-inch)             12   13+ months        3
iMac (24-inch, M1)                    60   0-6 months        3
iMac (24-inch, M1)                   134   7-12 months       1
iMac (24-inch, M1)                   120   13+ months        2

### 📱 iPad
iPad (10th Gen)                      224   0-6 months        2
iPad (10th Gen)                      260   7-12 months       1
iPad (10th Gen)                      201   13+ months        3
iPad (7th Gen)                        39   7-12 months       2
iPad (7th Gen)                       983   13+ months        1
iPad (6th Gen)                       781   13+ months        1
iPad (9th Gen)                        37   0-6 months        2
iPad (9th Gen)                        46   7-12 months       1
iPad (9th Gen)                        27   13+ months        3
iPad Air (4th Gen)                   109   0-6 months        3
iPad Air (4th Gen)                   189   7-12 months       2
iPad Air (4th Gen)                  1076   13+ months        1
iPad Pro (M1, 11-inch)                61   0-6 months        3
iPad Pro (M1, 11-inch)               135   7-12 months       1
iPad Pro (M1, 11-inch)               126   13+ months        2
iPad Pro (M1, 12.9-inch)              55   0-6 months        3
iPad Pro (M1, 12.9-inch)             153   7-12 months       1
iPad Pro (M1, 12.9-inch)             127   13+ months        2
iPad Pro (M2, 11-inch)               246   0-6 months        2
iPad Pro (M2, 11-inch)               297   7-12 months       1
iPad Pro (M2, 11-inch)               173   13+ months        3

### 📱 iPhone
iPhone 12                            67   0-6 months        1
iPhone 12                            58   7-12 months       2
iPhone 12                            29   13+ months        3
iPhone 12 Mini                       48   0-6 months        1
iPhone 12 Mini                       24   7-12 months       2
iPhone 12 Mini                       11   13+ months        3
iPhone 12 Pro                        88   0-6 months        1
iPhone 12 Pro                        46   7-12 months       2
iPhone 12 Pro                        19   13+ months        3
iPhone 12 Pro Max                    45   0-6 months        1
iPhone 12 Pro Max                    22   7-12 months       2
iPhone 12 Pro Max                    11   13+ months        3
iPhone 13                            48   0-6 months        2
iPhone 13                            55   7-12 months       1
iPhone 13                            15   13+ months        3
iPhone 13 Mini                     1156   13+ months        1
iPhone 13 Pro                        54   0-6 months        2
iPhone 13 Pro                        64   7-12 months       1
iPhone 13 Pro                        33   13+ months        3
iPhone 13 Pro Max                    48   0-6 months        1
iPhone 13 Pro Max                    36   7-12 months       2
iPhone 13 Pro Max                    24   13+ months        3
iPhone 14                           454   0-6 months        2
iPhone 14                           539   7-12 months       1
iPhone 14                           328   13+ months        3
iPhone 14 Pro                       405   0-6 months        2
iPhone 14 Pro                       534   7-12 months       1
iPhone 14 Pro                       321   13+ months        3
iPhone 15                           193   0-6 months        1
iPhone 15                           128   7-12 months       2
iPhone 15 Pro                       177   0-6 months        1
iPhone 15 Pro                       113   7-12 months       2
iPhone 15 Pro Max                   189   0-6 months        1
iPhone 15 Pro Max                   131   7-12 months       2
iPhone 11                            49   7-12 months       2
iPhone 11                           946   13+ months        1
iPhone 11 Pro                        51   7-12 months       2
iPhone 11 Pro                       989   13+ months        1
iPhone 11 Pro Max                    35   7-12 months       2
iPhone 11 Pro Max                   907   13+ months        1
iPhone SE (3rd Gen)                  28   7-12 months       2
iPhone SE (3rd Gen)                1857   13+ months        1
iPhone X                            798   13+ months        1
iPhone XR                           766   13+ months        1
iPhone XS                           746   13+ months        1
iPhone XS Max                       760   13+ months        1

*/

/*   Product / Category Hotspots
	•	For each category_name and product_name, compute Claim Probability.
	•	Rank by risk (with a minimum sales threshold).
→ Why: Identifies a few problematic products driving disproportionate costs. */

select category_name, product_name, count(claim_id), count(s.sale_id), round((count(claim_id)::numeric / count(s.sale_id)::numeric * 100), 2) as claim_probability_by_product
, rank() over(order by round((count(claim_id)::numeric / count(s.sale_id)::numeric * 100), 2) desc)
from category as c right join products as p on c.category_id  = p.category_id 
right join sales as s on p.product_id  = s.product_id 
left join warranty as w on s.sale_id = w.sale_id 
group by 1, 2
order by 5 desc;
-- Claim Probability
/* 	1.	iPad Air (4th Gen) — 24.85%
	2.	Apple One (Subscription Service) — 24.71%
	3.	Apple Watch Series 5 — 20.27%
	4.	iPhone 11 Pro — 20.23%
	5.	iPad (7th Gen) — 19.59%
	6.	iPhone 11 — 19.52%
	7.	iPhone 11 Pro Max — 18.53%
	8.	iPhone 13 Mini — 18.12%
	9.	iPhone SE (3rd Gen) — 13.82%
	10.	Apple Watch Series 4 — 4.14% */
