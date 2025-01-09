# 1. Customers Analysis

# 1.1 Detailed overview of all individual customers

create temp table TempCustomerDetails as

with individuals as (

  select -- individual type customers, their account no.
    CustomerID,
    AccountNumber,
    CustomerType
  from adwentureworks_db.customer -- 18,484 distinct individuals
  where CustomerType = 'I'
  ),

contact_info as (

  select -- join all contact information for individual customers
    individual.CustomerID,
    individual.ContactID,
    contact.FirstName,
    contact.LastName,
    concat(contact.FirstName, ' ', contact.LastName) as FullName,
    case when contact.Title is null 
      then concat('Dear ', contact.LastName) 
      else concat(contact.Title, ' ', contact.LastName)
    end as AddressingTitle,
    contact.EmailAddress,
    contact.Phone
  from adwentureworks_db.individual as individual
    join adwentureworks_db.contact as contact
    using(ContactID)
),

individuals_address as (
  
  select -- customerid, addressid from individual customers
    individuals.CustomerID, 
    max(customer_address.AddressID) as AddressID
  from adwentureworks_db.customeraddress as customer_address
    join individuals
    using(CustomerID)
  group by CustomerID
),

full_address as (
  
  select -- join address and country & state tables for individual customers
    address.AddressID,
    address.City,
    address.AddressLine1,
    address.AddressLine2,
    address.StateProvinceID,
    full_country.State,
    full_country.Country
  from adwentureworks_db.address address

  join (
    select -- join country names
      territory.TerritoryID,
      country_region.Name as Country,
      state.StateProvinceID,
      state.Name as State
    from adwentureworks_db.salesterritory as territory
      join adwentureworks_db.countryregion as country_region
      using(CountryRegionCode)
      join 
        (select -- join state names
          TerritoryID,
          StateProvinceID,
          Name
        from adwentureworks_db.stateprovince) as state 
      using(TerritoryID)
  ) as full_country -- join country and state names together
  using(StateProvinceID)
),

orders_info as (
  select -- orders aggregations
    CustomerID,
    count(*) as number_orders,
    round(sum(TotalDue), 2) as total_amount,
    max(date(OrderDate)) as date_last_order
  from adwentureworks_db.salesorderheader
  group by CustomerID
)

select -- combine everything together
  CustomerID,
  FirstName,
  LastName,
  FullName,
  AddressingTitle,
  EmailAddress,
  Phone,
  AccountNumber,
  CustomerType,
  City,
  AddressLine1,
  AddressLine2,
  State,
  Country,
  number_orders,
  total_amount,
  date_last_order
from individuals 
  join orders_info using(CustomerID)
  join contact_info using(CustomerID)
  join individuals_address using(CustomerID)
  join full_address using(AddressID)
order by total_amount desc;

select * from TempCustomerDetails
limit 200;


# 1.2 Top 200 customers who were inactive for the past year

with recent_date as (
  select max(date_last_order) as max_date
  from TempCustomerDetails
)

select TempCustomerDetails.*
from TempCustomerDetails
  join recent_date
  on date_diff(max_date, date_last_order, day) >= 365
limit 200;


# 1.3 Add new active / inactive column

select *,
  case 
    when date_diff(
          (select max(date(OrderDate))
          from adwentureworks_db.salesorderheader), 
        date_last_order, day) >= 365 
    then 'Inactive'
    else 'Active'
  end as CustomerStatus
from TempCustomerDetails;


# 1.4 Select all active customers from NA that spent > 2500 or have 5+ orders 

select *
from (
  select
    CustomerID,
    FirstName,
    LastName,
    FullName,
    AddressingTitle,
    EmailAddress,
    Phone,
    AccountNumber,
    CustomerType,
    City,
    AddressLine1,
    -- extract the address number which may be followed by whitespace or a comma and whitespace
    regexp_extract(AddressLine1, r'^(\d+)[,\s]*') as Address_no,
    -- extract the street part which may follow the digits and optional comma and whitespace
    regexp_extract(AddressLine1, r'^\d+[,\s]*(.*)') as Address_st,
    AddressLine2,
    State,
    Country,
    number_orders,
    total_amount,
    date_last_order,
    case 
      when date_diff(
            (select max(date(OrderDate))
            from adwentureworks_db.salesorderheader), 
          date_last_order, day) >= 365 
      then 'Inactive'
      else 'Active'
    end as CustomerStatus
  from TempCustomerDetails
) as customer_detail
where country in ('United States', 'Canada')
  and (total_amount >= 2500
      or number_orders > 4)
  and CustomerStatus = 'Active'
order by Country, State, date_last_order;




# 2. Reporting Sales’ numbers

# 2.1 Monthly sales, orders, customers and salespeople for each region

create temp table monthly_sales as 
  
  select 
    format_timestamp('%Y-%m', OrderDate) as order_month,
    territory.CountryRegionCode,
    territory.Name as Region,
    count(OrderDate) as no_Orders,
    count(distinct CustomerID) as no_Customers,
    count(distinct SalesPersonID) as no_SalesPeople,
    round(sum(TotalDue)) as Total_w_Tax
  from adwentureworks_db.salesorderheader
    join adwentureworks_db.salesterritory as territory
    using(TerritoryID)
  group by 
    order_month, 
    CountryRegionCode, 
    Region;
  
select * from monthly_sales
order by 
    CountryRegionCode desc, 
    Region desc,
    extract(year from parse_date('%Y-%m', order_month)) desc, 
    extract(month from parse_date('%Y-%m', order_month)) asc;

# 2.2 Add cumulative_sum of the total amount 

create temp table cmltv_sum as 

  select *,
    round(sum(Total_w_Tax) 
      over(partition by CountryRegionCode, Region 
      order by order_month)) 
    as cumulative_sum
  from monthly_sales;

select * from cmltv_sum
order by CountryRegionCode, Region, order_month;

# 2.3 Add ‘sales_rank’ column based on total amount desc

create temp table sales_rank as

  select *,
    dense_rank() 
      over(partition by CountryRegionCode 
      order by Total_w_Tax desc) 
    as country_sales_rank
  from cmltv_sum;

select * from sales_rank
order by 
    CountryRegionCode, 
    Total_w_Tax desc;

# 2.4 Add mean tax by country, % of provinces with tax

with province_taxes as (
  select 
    province.CountryRegionCode,
    province.Name as Province,
    max(tax_rate.TaxRate) as province_tax
  from adwentureworks_db.stateprovince as province
    left join adwentureworks_db.salestaxrate as tax_rate
    using(StateProvinceID)
  where province.CountryRegionCode in 
      (select CountryRegionCode 
      from adwentureworks_db.salesterritory)
  group by CountryRegionCode, Province
),

country_taxes as (
  select 
    CountryRegionCode,
    round(avg(province_tax), 1) as mean_tax_rate,
    round((count(province_tax) / count(*)) * 100, 2) as pcnt_provinces_w_tax
  from province_taxes
  group by CountryRegionCode
)

select 
  order_month,
  CountryRegionCode,
  Region, 
  no_Orders,
  no_Customers,
  no_SalesPeople,
  Total_w_Tax,
  cumulative_sum,
  country_sales_rank,
  mean_tax_rate,
  pcnt_provinces_w_tax
from sales_rank 
  join country_taxes 
  using(CountryRegionCode)
order by CountryRegionCode, Region desc;
