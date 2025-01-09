select count(*) -- 541,909 rows
from turing_data_analytics.rfm; 

select 
  min(InvoiceDate), -- 2010-12-01
  max(InvoiceDate)  -- 2011-12-09
from turing_data_analytics.rfm;

select count(distinct CustomerID) -- 4,372 customers
from turing_data_analytics.rfm;

select countif(customerID is null) -- 135080 null ids
from turing_data_analytics.rfm;



with daterange as ( 
  select 
    date('2010-12-01') as start_date,
    date('2011-12-01') as end_date
),

filtered as ( -- use only one year of data, filter out null ids and negative quantities and zero prices (382,720 rows)
  select -- 4,300 unique customers
    CustomerID,
    Country,
    InvoiceNo,
    date(InvoiceDate) as InvoiceDate,
    Quantity,
    UnitPrice
  from turing_data_analytics.rfm
  where date(InvoiceDate) between (select start_date from daterange) and (select end_date from daterange)
    and CustomerID is not null
    and Quantity > 0
    and UnitPrice > 0
),

fm_table as ( -- calculate F & M
  select 
    CustomerID,
    max(InvoiceDate) as last_purchase,
    count(distinct InvoiceNo) as frequency,
    sum(Quantity * UnitPrice) as monetary
  from filtered
  group by CustomerID
),

rfm_table as ( -- calculate R
  select 
    CustomerID,
    date_diff((select end_date from daterange), last_purchase, day) as recency,
    frequency,
    round(monetary, 2) as monetary
  from fm_table
),

quantiles as ( -- determine quantiles for each RFM metric
select
  a.*,
  -- percentiles for R
  r.percentiles[offset(25)] AS r25, 
  r.percentiles[offset(50)] AS r50,
  r.percentiles[offset(75)] AS r75,
  r.percentiles[offset(100)] AS r100,
  -- percentiles for F
  f.percentiles[offset(25)] AS f25, 
  f.percentiles[offset(50)] AS f50,
  f.percentiles[offset(75)] AS f75,
  f.percentiles[offset(100)] AS f100, 
  -- percentiles for M
  m.percentiles[offset(25)] AS m25, 
  m.percentiles[offset(50)] AS m50,
  m.percentiles[offset(75)] AS m75, 
  m.percentiles[offset(100)] AS m100,
from 
  rfm_table a,
  (select approx_quantiles(recency, 100) percentiles from rfm_table) as r,
  (select approx_quantiles(frequency, 100) percentiles from rfm_table) as f,
  (select approx_quantiles(monetary, 100) percentiles from rfm_table) as m
),

scores as ( -- assign scores for each RFM metric
  select *,
  concat(r_score, f_score, m_score) as rfm_score
  from (
    select *,
      
      case 
        when recency <= r25 then 4
        when recency <= r50 and recency > r25 then 3
        when recency <= r75 and recency > r50 then 2
        when recency <= r100 and recency > r75 then 1
      end as r_score,

      case 
        when frequency <= f25 then 1
        when frequency <= f50 and frequency > f25 then 2
        when frequency <= f75 and frequency > f50 then 3
        when frequency <= f100 and frequency > f75 then 4
      end as f_score,

      case 
        when monetary <= m25 then 1
        when monetary <= m50 and monetary > m25 then 2
        when monetary <= m75 and monetary > m50 then 3
        when monetary <= m100 and monetary > m75 then 4
      end as m_score

    from quantiles
  )
)

select 
  CustomerID,
  recency,
  frequency,
  monetary,
  r_score,
  f_score,
  m_score,
  rfm_score
from scores;