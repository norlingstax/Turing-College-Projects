-- salesorderheader table
select 
  SalesOrderID,
  OrderDate,
  ShipDate,
  CustomerID,
  SalesPersonID,
  TotalDue,
  TerritoryID,
  ShipToAddressID
from adwentureworks_db.salesorderheader
where OrderDate < '2004-07-01';

-- salesreasons table
select
  sales_reason.SalesOrderID,
  reason.Name as SalesReason,
from adwentureworks_db.salesorderheadersalesreason as sales_reason
join adwentureworks_db.salesreason as reason
  using(SalesReasonID);

-- salespersons table
select 
  SalesPersonID,
  Title,
  TerritoryID,
  SalesQuota,
  Bonus,
  Rate*8 as DailyRate,
  CommissionPct,
  HireDate
from adwentureworks_db.salesperson as sales_person
join adwentureworks_db.employee as employee
  on sales_person.SalesPersonID = employee.EmployeeID
join adwentureworks_db.employeepayhistory
  using(EmployeeID)
where Title = 'Sales Representative';

-- salesterritories table
select
  address.AddressID,
  province.CountryRegionCode as country_code,
  territory.Name as Region,
  province.StateProvinceCode as province_code,
  province.Name as province_name
from adwentureworks_db.address as address
join adwentureworks_db.stateprovince as province
  using(StateProvinceID)
join adwentureworks_db.salesterritory as territory
  using(TerritoryID);
