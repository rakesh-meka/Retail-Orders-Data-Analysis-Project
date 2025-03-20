select *from Retail_orders;

-- 1. Top 10 Revenue generating category and sub categories

SELECT TOP (10) 
    category, 
    sub_category, 
    SUM(profit) AS Total_profit
FROM Retail_orders
GROUP BY category, sub_category
ORDER BY Total_profit DESC;


--2. find top 5 highest selling product in each region

with cte as (select  region, product_id, sum(sale_price) as sale
from Retail_orders
group by region,product_id
)
 select * from (select *, 
 ROW_NUMBER() over (partition by region order by sale desc) as rn from cte)A
 where rn<=5;

 --3. find month over month growth comparision for 2022 and 2023 sales

 with cte as ( select year(order_date)as order_year, month(order_date) as order_month, sum(sale_price) as sales from Retail_orders
 group by year(order_date), month(order_date))
 
 select order_month,
 sum(case when order_year = 2022 then sales else 0 end) as sales_2022 , 
 sum(case when order_year = 2023 then sales else 0 end) as sales_2023
 from cte
 group by order_month
 order by order_month


-- 4. for each category which month has highest sales

with cte as  (select category,format(order_date, 'yyyyMM') as Year_month, 
sum(sale_price) as sales 
from Retail_orders
group by category, format(order_date, 'yyyyMM'))
select * from  (select *, row_number() over (partition by category order by sales desc) as rn from cte)a
where rn = 1



--5. which category has highest growth_percentage profit in 2023 compare to 2022


 with cte as ( select category, year(order_date)as order_year, sum(sale_price) as sales from Retail_orders
 group by category, year(order_date)), 

cte2 as (
 select category,
 sum(case when order_year = 2022 then sales else 0 end) as sales_2022 , 
 sum(case when order_year = 2023 then sales else 0 end) as sales_2023
 from cte
 group by category)
  select Top 1 * , 
  (sales_2023-sales_2022)*100/sales_2022 as growth_percentage
  from cte2
  order by (sales_2023-sales_2022)*100/sales_2022 desc


--6. which sub category has highest growth_percentage profit in 2023 compare to 2022


 with cte as ( select sub_category, year(order_date)as order_year, sum(sale_price) as sales from Retail_orders
 group by sub_category, year(order_date)), 

cte2 as (
 select sub_category,
 sum(case when order_year = 2022 then sales else 0 end) as sales_2022 , 
 sum(case when order_year = 2023 then sales else 0 end) as sales_2023
 from cte
 group by sub_category)
  select Top 1 * , 
  (sales_2023-sales_2022)*100/sales_2022 as growth_percentage
  from cte2
  order by   (sales_2023-sales_2022)*100/sales_2022 desc

  --7. Top 5 state having highest sales

select Top 5 state, country,  sum(sale_price) as sales from Retail_orders
group  by state, country
order by sales desc

