create schema if not exists levo;

drop table if exists levo.all_order_data;

create table levo.all_order_data (
	line_item		serial		primary key,
	date			date,
	order_id		bigint,
	line_kind		varchar(6),
	customer_id		bigint,
	customer_type		varchar(8),
	product_id		bigint,
	product_price		money,
	product_title		varchar(75),
	product_type		varchar(20),
	zip_code		int,
	region			varchar(25),
	churn			smallint,
	gross_sales		money,
	discount		money,
	net_sales		money,
	return_sales		money,
	units_sold		smallint,
	units_returned		smallint,
	net_quantity		smallint
);

copy levo.all_order_data(
date, order_id, line_kind,
customer_id, customer_type,
product_id, product_price,
product_title, product_type,
zip_code, region, churn,
gross_sales, discount,
net_sales, return_sales,
units_sold, units_returned,
net_quantity
)
from 'C:\levodb\abridged_data.csv'
delimiter ','
csv header;