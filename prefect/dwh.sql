
create table dim_product (
    dwh_id serial NOT NULL,
    id integer null, 
	name varchar NULL,
	description varchar NULL,
	barcode varchar NULL,
	price decimal,
	
	created_at TIMESTAMP,
	updated_at TIMESTAMP,
	dwh_changed_at TIMESTAMP
);

create table dim_customer (
    dwh_id serial NOT NULL,
    id integer null,
	name varchar NULL,
	phone varchar NULL,
	address varchar NULL,
	country varchar NULL,
	state varchar NULL,
	
	created_at TIMESTAMP,
	updated_at TIMESTAMP,
	dwh_changed_at TIMESTAMP
);


CREATE TABLE fact_sale_order (
    dwh_id serial NOT NULL,
    id integer null,
	order_date date,
	status varchar,
	shipped_date date,
	payment_status varchar NOT NULL,
	customer_id int null,
	created_at TIMESTAMP,
	updated_at TIMESTAMP,
	dwh_changed_at TIMESTAMP
);

CREATE TABLE fact_order_line (
    dwh_id serial NOT NULL,
	id INT,
	product_id INT,
	order_id INT,
	qty int,
	price DECIMAL,
	money DECIMAL,
	created_at TIMESTAMP,
	updated_at TIMESTAMP,
	dwh_changed_at TIMESTAMP
);


create or replace view snapshot_dim_customer as 
with datarows as (
select id,name, phone , address , country , state,
	ROW_NUMBER() OVER(partition  by id order by updated_at desc) as rowNo
from dim_customer
) 
select id,name, phone , address , country , state from datarows where rowNo = 1;


create or replace view snapshot_dim_product as 
with datarows as (
select id,name, description , barcode , price,
	ROW_NUMBER() OVER(partition  by id order by updated_at desc) as rowNo
from dim_product
) 
select id,name, description , barcode , price from datarows where rowNo = 1;

select * from snapshot_dim_product;

create or replace view snapshot_fact_sale_order as 
with fact_so as (
	select id,order_date, shipped_date , status , payment_status, customer_id,
		ROW_NUMBER() OVER(partition  by id order by updated_at desc) as rowNo
	from fact_sale_order 
),
snapshot_so as (select id,order_date, shipped_date , status , payment_status, customer_id from fact_so where rowNo = 1),
fact_sol as (
	select id,product_id, order_id , qty , price, money,
		ROW_NUMBER() OVER(partition  by id order by updated_at desc) as rowNo
	from fact_order_line 
),
snapshot_sol as (select id,product_id, order_id , qty , price, money from fact_sol where rowNo = 1)
select 
	so.id as order_id,
	so.customer_id,
	sol.product_id,
	so.status as order_status,
	so.payment_status,
	so.order_date,
	so.shipped_date,
	sol.qty,
	sol.price,
	sol."money"
from snapshot_so so
left join snapshot_sol sol on so.id = sol.order_id;

select c.state, 
		sum(so.money) as total_money, 
		count(*) as cnt
from snapshot_fact_sale_order so
left join snapshot_dim_customer c on so.customer_id = c.id 
group by c."state"; 

select  to_char(so.order_date, 'YYYY-MM-01') as month, 
		sum(so.money) as total_money, 
		count(*) as cnt
from snapshot_fact_sale_order so
group by month;

