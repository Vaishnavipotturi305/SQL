create database if not exists salesDataWalmart;
create table if not exists sales(
  invoice_id varchar(30) not null primary key,
  branch varchar(5) not null,
  city varchar(30) not null,
  customer_type varchar(30) not null, 
  gender varchar(10) not null,
  product_line varchar(100) not null,
  unit_price Decimal(10, 2) not null, 
  quantity int not null, 
  vat float(6, 4) not null, 
  total decimal(12, 4) not null,
  date DATETIME not  null,
  time TIME not null,
  payment_method varchar(15) not null,
  cogs decimal(10, 2) not null,
  gross_margin_pct float(11, 9),
  gross_income decimal(12, 4) not null,
  rating float(2, 1)
 );
 
 
 
 
 -- --------------------------------------------------------------------------------------------------
 -- --------------------FEATURE ENGINEERING  adding new features------------------------------------------------
 
 -- TIME_OF_DAY
 select 
      time ,
      (  case
      when 'time' between "00:00:00" and "12:00:00" then "Morning"
      when 'time' between "12:01:00" and "16:00:00" then "Evening"
      else "Evening"
           end  
      )as time_of_date
      from sales;
      
alter table sales add column time_of_day varchar(20);
	UPDATE sales set time_of_day =
	(
	   case
		  when 'time' between "00:00:00" and "12:00:00" then "Morning"
		  when 'time' between "12:01:00" and "16:00:00" then "Evening"
		  else "Evening"
			   end  
	);
    
    



--  day_name
select date, 
DAYNAME(date)
from sales;

alter table sales add column day_name varchar(10);
update sales set day_name=
(
  DAYNAME(date)
);


-- month_name
select date, monthname(date) from sales;
alter table sales add month_name varchar(10);
update sales set month_name=   MONTHNAME(date);



-- EDA ---
-- HOW MANY UNIQUE CITES DOES THE DATA HAVE ----
select distinct city from sales;

-- In which city is each branch-----
select distinct city , branch from sales;

-- unique product_lines---
select count(distinct product_line) from sales;

---  most common payent method -----
select  payment_method ,count(payment_method)  as count from sales group by payment_method order by count limit 1 ;
  
  
-- what is the most selling product line ---
select product_line, count(product_line) as cnt from sales  group by product_line order by cnt desc limit 1;
		  
          
----  what is the total revenue by month? ----
select month_name as  month, sum(total) as total_revenue from sales group by month_name
order by total_revenue desc;


---- what month has largest cogs ---
select 
month_name as month, sum(cogs) as cogs 
from sales
group by month_name 
order by cogs desc;


--   which product_line has largest revenue ---
select 
product_line, 
sum(total) as total_revenue 
from sales 
group by product_line 
order by total_revenue desc;


-- which city has largest revenue --
select 
branch,
city, 
sum(total) as total_revenue 
from sales 
group by city, branch
order by total_revenue desc;



---  which product_line has largest vat? --
select product_line , avg(vat) as avg_tax
from sales group by product_line order by avg_tax desc;


--- which branch sold more products than avearge products_sold ---

select branch, sum(quantity) as qty from sales group by branch having sum(quantity) >
(select avg(quantity) from sales);


-- most common productline by gender --
select gender , product_line , count(gender) as total_cnt from sales group by gender, product_line
order by total_cnt;

-- avearge rating each product_line---
select round(avg(rating), 2) as avg_rating , product_line from sales group by product_line order by avg_rating desc;



-- number of sales made in each time of day --- 
select time_of_day, count(*) as total_sales
from sales where day_name="Monday" group by time_of_day order by total_sales desc;

-- which of the customer brings the most revenue

select  customer_type, sum(total) as total_rev from sales group by customer_type order by total_rev desc;


-- which city has the largest tax percent/vat ?
select city, avg(vat) as vat from sales group by city order by vat desc;

-- which customer type has paid largest vat?
select customer_type, avg(vat) as vat from sales group by customer_type order by vat desc;


-- how many unique customer_types;
select distinct customer_type from sales;

-- unique paymentmethod
select distinct payment_method from sales;

-- which customer buys the most -- 
select customer_type ,count(*) as cust_cnt from sales group by customer_type; 

-- what is the gender of most of the customer 
select gender, count(*) as gen_cnt from sales group by gender order by gen_cnt desc;

-- gender distriustion per branch --
select gender, count(*) as gen_cnt from sales where branch='C' group by gender order by gen_cnt desc;


-- which time of day do cuatomers give most rating 
select time_of_day, avg(rating) as av from sales group by time_of_day order by av desc;

-- which day of week has the best avg rating?
select day_name, avg(rating) as avg_rating from sales group by day_name order by avg_rating desc;

-- which branch has best average rating
select branch, avg(rating) as avg_rating from sales group by branch order by avg_rating desc;
