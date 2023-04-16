--1
--SELECT DISTINCT c.customer_id, c.contact_name  
--FROM orders o, customers c 
--WHERE o.order_date >= '1998-01-01' and o.order_date < '1999-01-01' and o.customer_id = c.customer_id;


--1
--SELECT DISTINCT c.customer_id, c.contact_name
--FROM orders o, customers c 
--WHERE o.order_date between date('1998-01-01') and date('1998-12-31') and o.customer_id = c.customer_id;


--2
--select CONCAT(e1.first_name,' ', e1.last_name) as employee_name, CONCAT(e2.first_name,' ', e2.last_name) as supervisor_name
--from employees e1 inner join employees e2 on e1.reports_to = e2.employee_id 


--3
--select t1.customer_id, AVG(t1.total_order_cost) as average
--from (
--	select o.customer_id, (od.unit_price * od.quantity * (1 - od.discount)) as total_order_cost
--	from orders o, order_details od, customers c
--	where o.order_id = od.order_id and o.customer_id = c.customer_id
--	) as t1
--group by t1.customer_id
--order by average desc;


--4
--select c1.*, t2.total_customer_payment
--from (
--		select t1.customer_id, SUM(t1.total_order_cost) as total_customer_payment
--		from (
--				select o.customer_id, (od.unit_price * od.quantity * (1 - od.discount)) as total_order_cost
--				from orders o, order_details od
--				where o.order_id = od.order_id
--				) as t1
--		group by t1.customer_id
--		order by total_customer_payment desc 
--		limit 10
--		)as t2, customers c1
--where c1.customer_id = t2.customer_id

	
--5
--select e1.reports_to, COUNT(e1.reports_to)
--from employees e1
--where e1.reports_to is not null 
--group by e1.reports_to;


--6
--select *
--from (select od.product_id, SUM(od.quantity) as total_order_count
--		from order_details od, products p  
--		where od.product_id = p.product_id and p.category_id = 5
--		group by od.product_id 
--		order by total_order_count desc
--		limit 5
--		) as t1
--order by t1.total_order_count asc;


--7
--select t1.*, p.unit_price
--from (
--	select od.product_id, count(o.customer_id) as order_count
--	from orders o, order_details od 
--	where o.order_id = od.order_id 
--	group by (od.product_id)
--	having count(o.customer_id) > 20
--	) as t1, products p
--where p.product_id = t1.product_id;


--8
--select c1.customer_id, c1.contact_name, t2.total_customer_payment
--from (
--		select t1.customer_id, SUM(t1.total_order_cost) as total_customer_payment
--		from (
--				select o.customer_id, (od.unit_price * od.quantity * (1 - od.discount)) as total_order_cost
--				from orders o, order_details od
--				where o.order_id = od.order_id
--				) as t1
--		group by t1.customer_id
--		)as t2, customers c1
--where  c1.customer_id = t2.customer_id and
--		t2.customer_id = (
--		SELECT c.customer_id  FROM customers c
--		ORDER BY RANDOM() LIMIT 1
--		);


--9
--with customers_with_no_order_in_the_last_year as(
--	select o.customer_id, max(o.order_date) as last_order 
--	from customers c left join orders o on c.customer_id = o.customer_id
--	group by o.customer_id
--	having extract(year from MAX(o.order_date)) <= extract(year from (select max_order_date - INTERVAL '1 year' 
--																	from (
--																	  select MAX(order_date) as max_order_date
--																	  from orders) as last_order_date
--																)
--														)
--	union 
--	select c.customer_id, o.order_date 
--	from customers c
--	left join orders o on c.customer_id = o.customer_id
--	where o.order_id is null 
--)
--select customer_id, last_order
--from customers_with_no_order_in_the_last_year
--order by last_order asc nulls first 


--10
--create or replace view insufficient_products as
--(
--	select p
--	from products p
--	where p.units_in_stock < p.reorder_level
--	order by p.units_in_stock asc
--);
--select * from insufficient_products;


--11
--select t1.mon, count(distinct t1.order_id) as orders_count, SUM(quantity) as total_quantity_sold, SUM(t1.total_order_cost) as total_month_income
--from(
--	select o.order_id, o.customer_id, EXTRACT(MONTH FROM o.order_date) as mon,
--			od.quantity, (od.unit_price * od.quantity * (1 - od.discount)) as total_order_cost
--	from orders o, order_details od
--	where o.order_id = od.order_id 
--	) as t1
--group by t1.mon;


--12
--select *
--from customers c 
--where c.fax is null;


--13
--select od1.product_id as product_id1, od2.product_id as product_id2, COUNT(*) as cnt
--from order_details od1, order_details od2
--where od1.order_id = od2.order_id and od1.product_id < od2.product_id  
--group by od1.product_id , od2.product_id
--having COUNT(*) > 4;


--14
--select c.customer_id, AVG(od.unit_price * od.quantity * (1 - od.discount)) as avg_price,
--    (abs(AVG(od.unit_price * od.quantity * (1 - od.discount)) - (
--					    									select AVG(unit_price * quantity * (1 - discount)) 
--					    									from order_details))) as difference
--from customers c, orders o, order_details od
--where c.customer_id = o.customer_id and o.order_id = od.order_id
--group by c.customer_id
--order by difference desc
--limit 5;








