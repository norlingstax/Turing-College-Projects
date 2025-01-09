# 1. An overview of Products

# 1.1 
-- select info on products that have subcategory
select 
  p.ProductID, 
  p.Name, 
  p.ProductNumber, 
  p.Size, 
  p.Color, 
  p.ProductSubcategoryID, 
  ps.Name Subcategory

from adwentureworks_db.product p 
  inner join adwentureworks_db.productsubcategory ps
    using (ProductSubcategoryID)

order by ps.Name;

# 1.2
-- add category name to previous query
select 
  p.ProductID, 
  p.Name, 
  p.ProductNumber, 
  p.Size, 
  p.Color, 
  p.ProductSubcategoryID, 
  ps.Name SubcategoryName, 
  pc.Name Category

from adwentureworks_db.product p 
  inner join adwentureworks_db.productsubcategory ps
    using (ProductSubcategoryID)
  inner join adwentureworks_db.productcategory pc
    using (ProductCategoryID)

order by pc.Name;

# 1.3
-- bikes above 2000 cost that are for sale atm
select 
  p.ProductID, 
  p.Name BikeName, 
  p.ProductNumber, 
  p.ListPrice, 
  p.Size, 
  p.Color, 
  p.ProductSubcategoryID, 
  ps.Name SubcategoryName, 
  pc.Name Category

from adwentureworks_db.product p 
  inner join adwentureworks_db.productsubcategory ps
    using (ProductSubcategoryID)
  inner join adwentureworks_db.productcategory pc
    using (ProductCategoryID)

where pc.Name = 'Bikes'
  and p.SellEndDate is NULL
  and p.ListPrice > 2000

order by p.ListPrice desc;


# 2. Reviewing work orders

# 2.1
-- number of unique orders, number of unique products, total cost for each location in january 2004
select 
  LocationID,
  count(distinct WorkOrderID) no_work_orders,
  count(distinct ProductID) no_unique_products,
  sum(ActualCost) actual_cost

from adwentureworks_db.workorderrouting
where date(ActualStartDate) between '2004-01-01' and '2004-01-31'
group by LocationID;

# 2.2
-- add location name and average gap between start and end date per each location
select 
  wor.LocationID, 
  loc.Name Location,
  count(wor.WorkOrderID) no_work_orders,
  count(distinct wor.ProductID) no_unique_products,
  sum(wor.ActualCost) actual_cost,
  round(avg(date_diff(wor.ActualEndDate, wor.ActualStartDate, day)), 2) avg_days_diff

from adwentureworks_db.workorderrouting wor
  inner join adwentureworks_db.location loc 
    using(LocationID)

where date(wor.ActualStartDate) between '2004-01-01' and '2004-01-31'
group by wor.LocationID, loc.name;

# 2.3
-- all orders above 300 cost during january 2004
select 
  WorkOrderID,
  sum(ActualCost) actual_cost

from adwentureworks_db.workorderrouting
where date(ActualStartDate) between '2004-01-01' and '2004-01-31'
group by WorkOrderID
having actual_cost > 300;


# 3. Query validation

# 3.1
select count(SpecialOfferID)
from adwentureworks_db.salesorderdetail; -- result: 121,317 while in original query 296,983 -> duplicates

-- specialofferproduct table is redundant -> remove from join
select 
  sd.SalesOrderId,
  sd.OrderQty,
  sd.UnitPrice,
  round(sd.LineTotal, 2) LineTotal,
  sd.ProductId,
  sd.SpecialOfferID,
  so.Category,
  so.Description

from adwentureworks_db.salesorderdetail sd
  inner join adwentureworks_db.specialoffer so
    on sd.SpecialOfferID = so.SpecialOfferID

order by LineTotal desc;

-- or if ModifiedDate within specialofferproduct is really essential -> add 1 more join condition
select 
  sd.SalesOrderId,
  sd.OrderQty,
  sd.UnitPrice,
  round(sd.LineTotal, 2) LineTotal,
  sd.ProductId,
  sd.SpecialOfferID,
  sop.ModifiedDate,
  so.Category,
  so.Description

from adwentureworks_db.salesorderdetail sd
left join adwentureworks_db.specialofferproduct sop
  on sd.ProductId = sop.ProductID 
  and sd.SpecialOfferID = sop.SpecialOfferID
left join adwentureworks_db.specialoffer so
  on sd.SpecialOfferID = so.SpecialOfferID

order by sd.LineTotal desc;

-- edited version from peer review with unique order ids and filtered out "no discount" category
select
  distinct sd.SalesOrderID,
  sd.OrderQty,
  sd.UnitPrice,
  sd.LineTotal,
  sd.ProductId,
  sd.SpecialOfferID,
  sop.ModifiedDate,
  so.Category,
  so.Description
from adwentureworks_db.salesorderdetail sd
  join adwentureworks_db.specialofferproduct sop
    on sd.SpecialOfferID = sop.SpecialOfferID
  join adwentureworks_db.specialoffer so
    on sd.SpecialOfferID = so.SpecialOfferID

where sd.SpecialOfferID != 1
order by LineTotal desc;


# 3.2
-- implement better aliases, fix table and column referencing, use more readable query structure for easier debugging
-- however, resulting table contains multiple rows for vendors having multiple contacts / addresses
select
  ven.VendorID,
  ven.Name,
  ven_con.ContactID, 
  ven_con.ContactTypeID, 
  ven.CreditRating, 
  ven.ActiveFlag, 
  ven_add.AddressID,
  addr.City

from adwentureworks_db.vendor ven
  left join adwentureworks_db.vendorcontact ven_con
    on ven.VendorID = ven_con.VendorID 
  left join adwentureworks_db.vendoraddress ven_add
    on ven.VendorID = ven_add.VendorID
  left join adwentureworks_db.address addr 
    on ven_add.AddressID = addr.AddressID;

-- to display one row per vendor, contacts are aggregated, just one city is picked out
select 
  ven.VendorID,
  ven.Name,
  count(ven_con.ContactID) NumberOfContacts,  -- count of contacts per vendor
  ven.CreditRating,
  ven.ActiveFlag,
  min(addr.City) city -- picking one city (alphabetically first)

from adwentureworks_db.vendor ven
left join adwentureworks_db.vendorcontact ven_con
  on ven.VendorID = ven_con.VendorID 
left join adwentureworks_db.vendoraddress ven_add
  on ven.VendorID = ven_add.VendorID
left join adwentureworks_db.address addr
  on ven_add.AddressID = addr.AddressID

group by ven.VendorID, ven.Name, ven.CreditRating, ven.ActiveFlag;