use sales

select * from sales

---- change to date format

SET SQL_SAFE_UPDATES = 0;
UPDATE sales
SET purchase_date = STR_TO_DATE(purchase_date, '%d-%m-%Y');
alter table sales
modify purchase_date DATE;

---change to time format

UPDATE sales
SET time_of_purchase = STR_TO_DATE(time_of_purchase, '%H:%i:%S');
alter table sales
modify time_of_purchase TIME;

ALTER TABLE sales
MODIFY status VARCHAR(50);

---DATA ANALYSIS-----

---1.what are the top 5 most selling products by quantity?

select product_name, sum(quantity) as total_quantity_sold 
       from sales
       where status = 'delivered'
	   group by product_name 
       order by total_quantity_sold desc
	   limit 5;
       
----2.which products are most frequently cancelled?

select product_name, count(*) as total_cancelled 
       from sales 
       where status = 'cancelled' 
       group by product_name
       order by total_cancelled desc 
       limit 10;
       
----3.what times of the day has highest number of purchase?

select case 
	when hour(time_of_purchase)between 6 and 11 then 'Morning'
    when hour(time_of_purchase)between 12 and 17 then 'Afternoon'
	when hour(time_of_purchase)between 18 and 23 then 'Evening'
     else 'night'
     end as time_of_day, 
     count(*) as total_order 
     from sales 
     group by  time_of_day
     order by total_order desc;
     
------4.who are the top 5 highest spending customers?

select customer_id, customer_name,
       sum(quantity*price) as total_spendings_by_customer 
       from sales
       where status='delivered'
       group by customer_id,customer_name
       order by total_spendings_by_customer desc 
       limit 5;
       
---5.which product categories generatee the highest revenue?

select product_category, 
       sum(quantity*price) as revenue 
       from sales
	   where status='delivered'
       group by product_category
	   order by revenue desc 
       limit 5;

----6.what is the return/cancelled rate per product category?

select product_category, 
       count(*) as total_order, 
       sum(status = 'returned') as returned_orders,
       sum(status = 'cancelled') as cancelled_orders,
       sum(status = 'returned')/count(*) as returned_rate,
       round(sum(status = 'cancelled')/count(*),2)
       as cancelled_rate 
       from sales
       group by product_category;
       
------7.what is the preferred payment mode?

select payment_mode, 
       count(*) as total_count 
       from sales 
       group by payment_mode
       order by total_count desc;
       
--8.how does age group affects purchasing behaviour?

select case 
       when customer_age between 18 and 25 then '18-25'
       when customer_age between 26 and 35 then '26-35'
       when customer_age between 36 and 50 then '36-50'
       else '51+'
       end as age_group, 
	   sum(quantity*price) 
       as total_purchase_by_age 
       from sales
       group by age_group
       order by total_purchase_by_age desc;
       
--9. what is monthly sales trend?--

select date_format(purchase_date, '%Y-%M') as monthly_purchase,
       sum(quantity*price) as total_sales,
       sum(quantity) 
       from sales
       group by monthly_purchase
       order by monthly_purchase;
       
---10. are certain genders buying more specific product categories?

select gender, product_category, 
       count(product_category) as total_purchase 
       from sales
	   group by gender, product_category
       order by total_purchase desc;





