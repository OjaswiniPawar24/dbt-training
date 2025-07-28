select 
-- from raw orders
{{ dbt_utils.generate_surrogate_key(['orderid', 'o.customerid', 'o.productid']) }} as sk_orders,
o.orderid,
o.orderdate,
o.shipdate,
o.shipmode,
o.ordersellingprice-o.ordercostprice as orderprofit,
o.ordercostprice,
o.ordersellingprice,
--from raw customer
c.customerid,
c.customername,
c.segment,
c.country,
--from raw producto.
p.productid,
p.category,
p.productname,
p.subcategory,
{{ markup('ordersellingprice','ordercostprice') }} as markup,
d.delivery_team
FROM {{ ref('raw_orders') }} as o
left join {{ ref('raw_customer') }} as c
on o.customerid = c.customerid
left join {{ ref('raw_product') }} as p
on o.productid = p.productid
left join {{ ref('delivery_team') }} as d 
on o.shipmode = d.shipmode