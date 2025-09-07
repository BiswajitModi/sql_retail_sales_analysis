--SQL Retail Sales Analysis - P1



--create table
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
         (
           transactions_id int primary key,
		   sale_date date,
		   sale_time time,
		   customer_id int,
		   gender varchar(15),
		   age int,
		   category varchar(15),
		   quantiy int, 
		   price_per_unit float, 
		   cogs float, 
		   total_sale float

);

select * from retail_sales
limit 100
select 
     count (*)
from retail_sales	 

--data cleaning
select * from retail_sales
where
     transactions_id is null
	 or
	 sale_date is null
	 or
	 sale_time is null
	 or
	 gender is null
	 or
	 category is null
	 or
	 quantiy is null
	 or 
	 cogs is null
	 or 
	 total_sale is null ;
--
delete from retail_sales
where
      transactions_id is null
	 or
	 sale_date is null
	 or
	 sale_time is null
	 or
	 gender is null
	 or
	 category is null
	 or
	 quantiy is null
	 or 
	 cogs is null
	 or 
	 total_sale is null;
-- how many sales we have ?
select count (*) as total_sales from retail_sales
--how many unique customers we have
select count (distinct customer_id) as total_sales from retail_sales
select distinct category from retail_sales

--data analysis & business key problems & answers

--Q1)write a sql query to retrieve all column for sales made on '2022-11-05'
select *
from retail_sales
where sale_date = '2022-11-05' ;

--Q2)write a sql query to retrive all transactions where the category is 'clothing' and 
--the quantity sold is more than equal to 4 in the month of Nov-2022

select
 *
from retail_sales
where category = 'Clothing'
     and
     TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
	 and
	 quantiy >= 4 

--Q3)write a sql query to calculate the total sales (total_sales) for each category.
select 
       category,
	   sum(total_sale) as net_sale,
	   count(*) as total_orders
from retail_sales
group by 1

-- Q4)write a sql query to find the average age of customers who purchased items from the 'Beauty' category

select 
      ROUND(AVG(age), 2) as avg_age
from retail_sales
where category = 'Beauty'

--Q5) write a sql to find all transactions where the total_sale is greater than 1000.

select *
from retail_sales
where 
     total_sale > 1000

--Q6) write a sql query to find the total number of transactions (transaction_id) made by each gender in each category.

select 
     category, 
	 gender,
	 count (*) as  total_transactions
	 from retail_sales
group
    by 
	category,
	gender
order by 1

--Q7) write a sql query to calculate the average sale for each month. Find out best selling month in each year.

select 
      year,
	  month,
	 avg_sale
from
(
select
    extract(year from sale_date) as year,
	extract (month from sale_date) as month,
	avg(total_sale) as avg_sale,
	RANK() over(partition by extract(year from sale_date) order by avg(total_sale) DESC) as rank
from retail_sales
group by  1,2
) as t1
where rank = 1
--

--Q8) write a sql query to find the top 5 customers based on the highest total sales

select
      customer_id,
	  sum(total_sale) as total_sales
from retail_sales
group by 1
order by 2 desc
limit 5

--order by 1, 3 Desc

--Q9) write a sql query to find the number of unique customers who purchased items from each category.
select
	 category,
	 count( distinct customer_id ) as count_unique_customers
from retail_sales
group by category

--Q10) write a sql to create each shift and number of orders (Example morning <=12, afternoon between 12 & 17, Evening >17).

with hourly_sale
as
(
select * ,
      CASE
	     when extract(hour from sale_time) <= 12 then 'morning'
		 when  extract(hour from sale_time) between 12 and  17 then 'afternoon'
		 else 'evening'
	 end as shift	 
from retail_sales
)
select
     shift,
	 count(*) as total_orders
from hourly_sale
group by shift
	   

-- end of project

