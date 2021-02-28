drop table if exists levo.sas_churn_dataset;

create table levo.sas_churn_dataset as

select aod.customer_id,
	count(distinct(order_id)) filter (where line_kind = 'order') as orders, --filter by orders and exclude return 'orders'
	sum(units_sold)	as units_ordered, --total units sold across all orders
	sum(units_returned * -1) as units_returned, --total units returned
	sum(net_quantity) as net_units, --total units kept thus far
	sum(gross_sales) as gross_sales, --total gross sales
	sum(discount) as discount_amt, --total amount of discounts received across all orders
	round(cast(float8 ((sum(discount) / sum(gross_sales)) * -100) as numeric), 2) as discount_percent, --percent of total sales discounted
	sum(net_sales) as net_sales, --gross sales less discount amount and return value
	pt.num_product_types,
	((max(date)-'2021-02-11') * -1) as days_since_order, --number of days since last purchase
	case
		when sum(net_quantity) <= 0 then cast(0 as money) --needed a case for when net_quantity = 0
	else
		(sum(net_sales) / sum(net_quantity))
	end aur, --average unit retail
	case
		when sum(net_quantity) <= 0 then cast(0 as money) --needed a case for when net_quantity = 0
	else
		(sum(net_sales) / count(distinct(order_id)))
	end aov, --average order value
	case
		when count(order_id) filter (where line_kind = 'order') > 1 then 1
	else
		0
	end repeat_purchaser, --identify repeat purchasers using binary (1 - repeat purchaser, 0 - one-time purchaser)
	case
		when sum(units_returned * -1) > 0 then 1 
	else
		0
	end returner, --identify returners using a binary data type (1 - returner, 0 - never returned)
	min(churn) as churn --find current subscription value (1 - unsubscribed, 0 - current subscriber)
from levo.all_order_data as aod

	join
		(select customer_id, count(distinct(product_type)) as num_product_types
		from levo.all_order_data
		group by customer_id) as pt -- required a subquery to determine the number of different types of products purchased
	on pt.customer_id = aod.customer_id

	where net_sales != cast(0 as money) --exclude promotional gifts/employee purchases
	group by aod.customer_id, pt.num_product_types
	order by orders desc;

select * from levo.sas_churn_dataset;